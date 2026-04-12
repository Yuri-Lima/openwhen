import {getAuth} from "firebase-admin/auth";
import {getFirestore, FieldValue} from "firebase-admin/firestore";
import {getStorage} from "firebase-admin/storage";
import {HttpsError, onCall} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import Stripe from "stripe";

const db = () => getFirestore();
const auth = () => getAuth();
const bucket = () => getStorage().bucket();

/* ══════════════════════════════════════════════════════════════
 *  PUBLIC TYPES
 * ══════════════════════════════════════════════════════════════ */

export type DeletionMode = "delete_all" | "anonymize";

export interface DeletionResult {
  success: boolean;
  lettersProcessed: number;
  capsulesProcessed: number;
  lockedLettersPreserved: number;
  lockedCapsulesPreserved: number;
}

/* ══════════════════════════════════════════════════════════════
 *  CALLABLE — kept for backward compatibility & direct calls
 * ══════════════════════════════════════════════════════════════ */

/**
 * Deletes or anonymises all user data.
 *
 * mode = 'delete_all'  → remove every document & file owned by the user.
 * mode = 'anonymize'   → keep letters/capsules but strip PII; delete everything else.
 *
 * Locked letters/capsules with a future openDate are ALWAYS preserved
 * (anonymised) regardless of mode — they represent a promise to the recipient.
 *
 * MUST be called right after a successful client-side reauthentication so
 * the token is fresh (Firebase validates this on its own for auth().deleteUser).
 */
export const deleteUserAccount = onCall(
  {cors: true, timeoutSeconds: 120},
  async (request) => {
    if (!request.auth?.uid) {
      throw new HttpsError("unauthenticated", "Sign in required");
    }
    const uid = request.auth.uid;
    const mode = request.data?.mode as string;
    if (mode !== "delete_all" && mode !== "anonymize") {
      throw new HttpsError("invalid-argument", "mode must be 'delete_all' or 'anonymize'");
    }

    const result = await executeAccountDeletion(uid, mode as DeletionMode, {
      deleteAuth: true,
    });
    return result;
  }
);

/* ══════════════════════════════════════════════════════════════
 *  CORE LOGIC — reusable by callable & scheduled function
 * ══════════════════════════════════════════════════════════════ */

interface DeletionOptions {
  /** Whether to delete the Firebase Auth user. False when called from
   *  the scheduled function (auth may already be gone). */
  deleteAuth?: boolean;
}

/**
 * Executes the full account deletion / anonymisation pipeline.
 * Extracted so it can be called from both the onCall callable and
 * the scheduled soft-delete processor.
 */
export async function executeAccountDeletion(
  uid: string,
  mode: DeletionMode,
  opts: DeletionOptions = {},
): Promise<DeletionResult> {
  const {deleteAuth: shouldDeleteAuth = true} = opts;

  logger.info(`executeAccountDeletion: uid=${uid} mode=${mode} deleteAuth=${shouldDeleteAuth}`);

  const firestore = db();
  let lockedLettersPreserved = 0;
  let lockedCapsulesPreserved = 0;

  /* ── 1. Cancel Stripe subscription (best-effort) ──────── */
  try {
    const userSnap = await firestore.collection("users").doc(uid).get();
    const userData = userSnap.data();
    const stripeKey = process.env.STRIPE_SECRET_KEY;
    if (userData?.stripeCustomerId && stripeKey) {
      const stripe = new Stripe(stripeKey);
      const subs = await stripe.subscriptions.list({
        customer: userData.stripeCustomerId,
        status: "active",
      });
      for (const sub of subs.data) {
        await stripe.subscriptions.cancel(sub.id);
        logger.info(`Cancelled Stripe subscription ${sub.id}`);
      }
    }
  } catch (e) {
    logger.warn("Stripe cancellation best-effort failed", e);
  }

  /* ── 2. Letters where user is SENDER ──────────────────── */
  const sentLetters = await firestore
    .collection("letters")
    .where("senderUid", "==", uid)
    .get();

  for (const doc of sentLetters.docs) {
    const data = doc.data();

    if (isLockedWithFutureOpen(data)) {
      // PRESERVE: locked letters are a promise to the recipient.
      // Voice is removed (can identify sender); handwritten stays anonymised.
      await anonymiseLockedLetter(doc.ref, data);
      lockedLettersPreserved++;
    } else if (mode === "delete_all") {
      await deleteLetterMedia(data);
      await doc.ref.delete();
    } else {
      // anonymize mode for opened/past letters
      await doc.ref.update({
        senderUid: "",
        senderName: "Deleted user",
        senderLocation: FieldValue.delete(),
      });
    }
  }

  /* ── 3. Letters where user is RECEIVER ─────────────────── */
  const receivedLetters = await firestore
    .collection("letters")
    .where("receiverUid", "==", uid)
    .get();

  for (const doc of receivedLetters.docs) {
    if (mode === "delete_all") {
      await deleteLetterMedia(doc.data());
      await doc.ref.delete();
    } else {
      await doc.ref.update({
        receiverUid: "",
        receiverName: "Deleted user",
        receiverEmail: FieldValue.delete(),
        receiverEmailNormalized: FieldValue.delete(),
      });
    }
  }

  /* ── 4. Capsules ───────────────────────────────────────── */
  const capsulesBySender = await firestore
    .collection("capsules")
    .where("senderUid", "==", uid)
    .get();

  for (const doc of capsulesBySender.docs) {
    const data = doc.data();
    const isCollective = data.isCollective === true;
    const participants = (data.participantUids as string[]) || [];

    if (isLockedWithFutureOpen(data)) {
      // PRESERVE: locked capsules survive deletion, same as letters.
      // Voice removed, photos stay (not personally identifying like voice).
      await anonymiseLockedCapsule(doc.ref, data, uid);
      lockedCapsulesPreserved++;
    } else if (mode === "delete_all") {
      if (!isCollective || participants.length <= 1) {
        await deleteCapsuleMedia(data);
        await doc.ref.delete();
      } else {
        await doc.ref.update({
          senderUid: "",
          senderName: "Deleted user",
          participantUids: FieldValue.arrayRemove([uid]),
          [`participantNames.${uid}`]: FieldValue.delete(),
          senderLocation: FieldValue.delete(),
        });
      }
    } else {
      // anonymize
      const updates: Record<string, unknown> = {
        senderUid: "",
        senderName: "Deleted user",
        senderLocation: FieldValue.delete(),
      };
      if (participants.includes(uid)) {
        updates["participantUids"] = FieldValue.arrayRemove([uid]);
        updates[`participantNames.${uid}`] = FieldValue.delete();
      }
      await doc.ref.update(updates);
    }
  }

  // Also handle capsules where user is participant but not sender
  const capsulesByParticipant = await firestore
    .collection("capsules")
    .where("participantUids", "array-contains", uid)
    .get();

  for (const doc of capsulesByParticipant.docs) {
    // Skip if already handled above (user was sender)
    if (doc.data().senderUid === uid || doc.data().senderUid === "") continue;
    await doc.ref.update({
      participantUids: FieldValue.arrayRemove([uid]),
      [`participantNames.${uid}`]: FieldValue.delete(),
    });
  }

  /* ── 5. Comments ───────────────────────────────────────── */
  const comments = await firestore
    .collection("comments")
    .where("userUid", "==", uid)
    .get();

  for (const doc of comments.docs) {
    const letterId = doc.data().letterId as string | undefined;
    await doc.ref.delete();
    if (letterId) {
      const letterRef = firestore.collection("letters").doc(letterId);
      await letterRef.update({commentCount: FieldValue.increment(-1)}).catch(() => {});
    }
  }

  /* ── 6. Likes ──────────────────────────────────────────── */
  const likes = await firestore
    .collection("likes")
    .where("userUid", "==", uid)
    .get();

  for (const doc of likes.docs) {
    const letterId = doc.data().letterId as string | undefined;
    await doc.ref.delete();
    if (letterId) {
      const letterRef = firestore.collection("letters").doc(letterId);
      await letterRef.update({likeCount: FieldValue.increment(-1)}).catch(() => {});
    }
  }

  /* ── 7. Follows (both directions) ──────────────────────── */
  const followsAsFollower = await firestore
    .collection("follows")
    .where("followerUid", "==", uid)
    .get();
  for (const doc of followsAsFollower.docs) {
    const followingUid = doc.data().followingUid as string | undefined;
    await doc.ref.delete();
    if (followingUid) {
      await firestore.collection("users").doc(followingUid)
        .update({followersCount: FieldValue.increment(-1)}).catch(() => {});
    }
  }

  const followsAsFollowing = await firestore
    .collection("follows")
    .where("followingUid", "==", uid)
    .get();
  for (const doc of followsAsFollowing.docs) {
    const followerUid = doc.data().followerUid as string | undefined;
    await doc.ref.delete();
    if (followerUid) {
      await firestore.collection("users").doc(followerUid)
        .update({followingCount: FieldValue.increment(-1)}).catch(() => {});
    }
  }

  /* ── 8. Blocks (both directions) ──────────────────────── */
  const blocksBy = await firestore
    .collection("blocks")
    .where("blockedBy", "==", uid)
    .get();
  for (const doc of blocksBy.docs) {
    await doc.ref.delete();
  }

  const blocksOf = await firestore
    .collection("blocks")
    .where("blockedUid", "==", uid)
    .get();
  for (const doc of blocksOf.docs) {
    await doc.ref.delete();
  }

  /* ── 9. Reports ────────────────────────────────────────── */
  const reports = await firestore
    .collection("reports")
    .where("reporterUid", "==", uid)
    .get();
  for (const doc of reports.docs) {
    await doc.ref.delete();
  }

  /* ── 10. Feedback ──────────────────────────────────────── */
  const feedback = await firestore
    .collection("feedback")
    .where("uid", "==", uid)
    .get();
  for (const doc of feedback.docs) {
    await doc.ref.delete();
  }

  /* ── 11. Subcollections: badgeUnlocks, notifications ──── */
  await deleteSubcollection(firestore, `users/${uid}/badgeUnlocks`);
  await deleteSubcollection(firestore, `users/${uid}/notifications`);

  /* ── 12. Firebase Storage files ────────────────────────── */
  try {
    const b = bucket();
    // Avatar
    await b.file(`avatars/${uid}.jpg`).delete().catch(() => {});
    // Prefix-based deletions (handwritten, voice, capsule photos)
    // NOTE: locked letter media that was migrated to anon_ prefix survives this.
    for (const prefix of ["handwritten/", "voiceLetters/", "capsulePhotos/"]) {
      const [files] = await b.getFiles({prefix: `${prefix}${uid}_`});
      for (const file of files) {
        await file.delete().catch(() => {});
      }
    }
  } catch (e) {
    logger.warn("Storage cleanup best-effort failed", e);
  }

  /* ── 13. Delete user document ──────────────────────────── */
  await firestore.collection("users").doc(uid).delete();

  /* ── 14. Delete Firebase Auth user (optional) ──────────── */
  if (shouldDeleteAuth) {
    try {
      await auth().deleteUser(uid);
      logger.info(`deleteUserAccount: auth deleted uid=${uid}`);
    } catch (e) {
      // Auth user may already be gone (e.g. scheduled cleanup after manual deletion)
      logger.warn(`Auth deletion failed for uid=${uid} (may already be gone)`, e);
    }
  }

  logger.info(`executeAccountDeletion: completed uid=${uid} mode=${mode} lockedPreserved=${lockedLettersPreserved}+${lockedCapsulesPreserved}`);

  /* ── 15. Audit log (no PII) ────────────────────────────── */
  await firestore.collection("deletionAuditLogs").add({
    uidHash: simpleHash(uid),
    mode,
    deletedAt: FieldValue.serverTimestamp(),
    lettersProcessed: sentLetters.size + receivedLetters.size,
    capsulesProcessed: capsulesBySender.size,
    lockedLettersPreserved,
    lockedCapsulesPreserved,
  });

  /* ── 16. Privacy request log (unified) ───────────────── */
  await firestore.collection("privacyRequestLogs").add({
    uid: simpleHash(uid),
    type: mode === "delete_all" ? "account_deletion" : "account_anonymization",
    status: "completed",
    metadata: {
      mode,
      lettersProcessed: sentLetters.size + receivedLetters.size,
      capsulesProcessed: capsulesBySender.size,
      lockedLettersPreserved,
      lockedCapsulesPreserved,
    },
    createdAt: FieldValue.serverTimestamp(),
    source: "server",
  });

  return {
    success: true,
    lettersProcessed: sentLetters.size + receivedLetters.size,
    capsulesProcessed: capsulesBySender.size,
    lockedLettersPreserved,
    lockedCapsulesPreserved,
  };
}

/* ══════════════════════════════════════════════════════════════
 *  LOCKED CONTENT PRESERVATION
 * ══════════════════════════════════════════════════════════════ */

/**
 * Returns true if the document is locked and has an openDate in the future.
 * Used for both letters and capsules.
 */
function isLockedWithFutureOpen(data: FirebaseFirestore.DocumentData): boolean {
  if (data.status !== "locked") return false;
  const openDate = data.openDate;
  if (!openDate) return false;
  const openMs = typeof openDate.toMillis === "function"
    ? openDate.toMillis()
    : new Date(openDate).getTime();
  return openMs > Date.now();
}

/**
 * Anonymises a locked letter: strips sender identity, removes voice
 * (voice can identify the sender), keeps handwritten image with
 * anonymised path.
 */
async function anonymiseLockedLetter(
  ref: FirebaseFirestore.DocumentReference,
  data: FirebaseFirestore.DocumentData,
): Promise<void> {
  const b = bucket();

  // Remove voice file (voice identifies sender)
  if (data.voiceUrl) {
    const voicePath = storagePathFromUrl(data.voiceUrl);
    if (voicePath) await b.file(voicePath).delete().catch(() => {});
  }

  // Migrate handwritten image to anonymous path (so uid-prefix cleanup won't delete it)
  let newHandwrittenUrl: string | null = null;
  if (data.handwrittenImageUrl) {
    newHandwrittenUrl = await migrateToAnonymousPath(data.handwrittenImageUrl, "handwritten");
  }

  // Update document
  const updates: Record<string, unknown> = {
    senderUid: "",
    senderName: "Deleted user",
    senderLocation: FieldValue.delete(),
    voiceUrl: FieldValue.delete(),
  };
  if (newHandwrittenUrl) {
    updates["handwrittenImageUrl"] = newHandwrittenUrl;
  } else if (data.handwrittenImageUrl) {
    // Migration failed — remove reference rather than leave a broken URL
    updates["handwrittenImageUrl"] = FieldValue.delete();
  }

  await ref.update(updates);
}

/**
 * Anonymises a locked capsule: strips sender identity, removes voice-like
 * content, keeps photos (photos are not personally identifying like voice).
 */
async function anonymiseLockedCapsule(
  ref: FirebaseFirestore.DocumentReference,
  data: FirebaseFirestore.DocumentData,
  uid: string,
): Promise<void> {
  const participants = (data.participantUids as string[]) || [];

  // Migrate capsule photos to anonymous paths
  const photos = (data.photos as string[]) || [];
  const newPhotos: string[] = [];
  for (const photoUrl of photos) {
    const migrated = await migrateToAnonymousPath(photoUrl, "capsulePhotos");
    newPhotos.push(migrated ?? photoUrl); // keep original if migration fails
  }

  const updates: Record<string, unknown> = {
    senderUid: "",
    senderName: "Deleted user",
    senderLocation: FieldValue.delete(),
  };

  if (participants.includes(uid)) {
    updates["participantUids"] = FieldValue.arrayRemove([uid]);
    updates[`participantNames.${uid}`] = FieldValue.delete();
  }

  if (newPhotos.length > 0 && newPhotos.some((u, i) => u !== photos[i])) {
    updates["photos"] = newPhotos;
  }

  await ref.update(updates);
}

/**
 * Copies a Storage file from its uid-prefixed path to an anonymous path
 * (anon_ prefix) so that uid-based cleanup won't delete it.
 * Returns the new download URL, or null on failure.
 */
async function migrateToAnonymousPath(
  url: string,
  folder: string,
): Promise<string | null> {
  try {
    const oldPath = storagePathFromUrl(url);
    if (!oldPath) return null;

    // Replace uid prefix with "anon_" — e.g. handwritten/abc123_ts.jpg → handwritten/anon_ts.jpg
    const fileName = oldPath.split("/").pop() || "";
    const underscoreIdx = fileName.indexOf("_");
    if (underscoreIdx === -1) return null;

    const suffix = fileName.substring(underscoreIdx); // _timestamp.ext
    const newPath = `${folder}/anon${suffix}`;

    const b = bucket();
    const oldFile = b.file(oldPath);
    const [exists] = await oldFile.exists();
    if (!exists) return null;

    await oldFile.copy(b.file(newPath));

    // Generate a signed URL valid for 10 years (effectively permanent for locked letters)
    const [signedUrl] = await b.file(newPath).getSignedUrl({
      action: "read",
      expires: new Date(Date.now() + 10 * 365 * 24 * 60 * 60 * 1000),
    });

    return signedUrl;
  } catch (e) {
    logger.warn(`migrateToAnonymousPath failed for ${folder}`, e);
    return null;
  }
}

/* ══════════════════════════════════════════════════════════════
 *  GENERAL HELPERS
 * ══════════════════════════════════════════════════════════════ */

async function deleteLetterMedia(data: FirebaseFirestore.DocumentData) {
  const b = bucket();
  const urls = [
    data.handwrittenImageUrl,
    data.voiceUrl,
  ].filter(Boolean) as string[];
  for (const url of urls) {
    const path = storagePathFromUrl(url);
    if (path) await b.file(path).delete().catch(() => {});
  }
}

async function deleteCapsuleMedia(data: FirebaseFirestore.DocumentData) {
  const b = bucket();
  const photos = (data.photos as string[]) || [];
  for (const url of photos) {
    const path = storagePathFromUrl(url);
    if (path) await b.file(path).delete().catch(() => {});
  }
}

export function storagePathFromUrl(url: string): string | null {
  // Firebase Storage URLs contain /o/<encoded-path>?
  const match = url.match(/\/o\/(.+?)\?/);
  if (match) return decodeURIComponent(match[1]);
  // If it's already a gs:// path
  if (url.startsWith("gs://")) {
    const parts = url.replace(/^gs:\/\/[^/]+\//, "");
    return parts || null;
  }
  return null;
}

async function deleteSubcollection(
  firestore: FirebaseFirestore.Firestore,
  path: string
) {
  const snap = await firestore.collection(path).limit(500).get();
  if (snap.empty) return;
  const batch = firestore.batch();
  snap.docs.forEach((doc) => batch.delete(doc.ref));
  await batch.commit();
  if (snap.size === 500) await deleteSubcollection(firestore, path);
}

export function simpleHash(s: string): string {
  let h = 0;
  for (let i = 0; i < s.length; i++) {
    h = ((h << 5) - h + s.charCodeAt(i)) | 0;
  }
  return Math.abs(h).toString(16).padStart(8, "0");
}
