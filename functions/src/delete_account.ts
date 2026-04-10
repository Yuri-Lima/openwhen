import {getAuth} from "firebase-admin/auth";
import {getFirestore, FieldValue} from "firebase-admin/firestore";
import {getStorage} from "firebase-admin/storage";
import {HttpsError, onCall} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import Stripe from "stripe";

const db = () => getFirestore();
const auth = () => getAuth();
const bucket = () => getStorage().bucket();

/**
 * Deletes or anonymises all user data.
 *
 * mode = 'delete_all'  → remove every document & file owned by the user.
 * mode = 'anonymize'   → keep letters/capsules but strip PII; delete everything else.
 *
 * MUST be called right after a successful client-side reauthentication so
 * the token is fresh (Firebase validates this on its own for auth().deleteUser).
 */
export const deleteUserAccount = onCall(
  {cors: true, timeoutSeconds: 120},
  async (request) => {
    /* ── 0. Auth gate ───────────────────────────────────────── */
    if (!request.auth?.uid) {
      throw new HttpsError("unauthenticated", "Sign in required");
    }
    const uid = request.auth.uid;
    const mode = request.data?.mode as string;
    if (mode !== "delete_all" && mode !== "anonymize") {
      throw new HttpsError("invalid-argument", "mode must be 'delete_all' or 'anonymize'");
    }

    logger.info(`deleteUserAccount: uid=${uid} mode=${mode}`);

    const firestore = db();

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
      if (mode === "delete_all") {
        await deleteLetterMedia(doc.data());
        await doc.ref.delete();
      } else {
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

      if (mode === "delete_all") {
        if (!isCollective || participants.length <= 1) {
          // Solo capsule or only participant → full delete
          await deleteCapsuleMedia(data);
          await doc.ref.delete();
        } else {
          // Collective: remove from participants, anonymise
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
        // Decrement commentCount on the parent letter
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

    /* ── 14. Delete Firebase Auth user ─────────────────────── */
    await auth().deleteUser(uid);
    logger.info(`deleteUserAccount: completed uid=${uid} mode=${mode}`);

    /* ── 15. Audit log (no PII) ────────────────────────────── */
    await firestore.collection("deletionAuditLogs").add({
      uidHash: simpleHash(uid),
      mode,
      deletedAt: FieldValue.serverTimestamp(),
      lettersProcessed: sentLetters.size + receivedLetters.size,
      capsulesProcessed: capsulesBySender.size,
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
      },
      createdAt: FieldValue.serverTimestamp(),
      source: "server",
    });

    return {success: true};
  }
);

/* ── Helpers ──────────────────────────────────────────────── */

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

function storagePathFromUrl(url: string): string | null {
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
  // Recurse if there were 500 (may have more)
  if (snap.size === 500) await deleteSubcollection(firestore, path);
}

function simpleHash(s: string): string {
  let h = 0;
  for (let i = 0; i < s.length; i++) {
    h = ((h << 5) - h + s.charCodeAt(i)) | 0;
  }
  return Math.abs(h).toString(16).padStart(8, "0");
}
