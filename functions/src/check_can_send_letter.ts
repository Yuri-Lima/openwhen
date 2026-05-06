import {onCall, HttpsError} from "firebase-functions/v2/https";
import {getFirestore} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";

/**
 * Callable Cloud Function: checkCanSendLetter
 *
 * Checks whether the authenticated user can send a letter to a given receiver.
 * Validates:
 *   1. Block status (bidirectional — either direction blocks sending)
 *   2. Receiver's letterPermission setting (everyone | followers | nobody)
 *
 * Returns: { canSend: boolean, reason?: string }
 *   reason values: 'blocked' | 'not_accepting' | 'followers_only'
 */
export const checkCanSendLetter = onCall(async (request) => {
  const senderUid = request.auth?.uid;
  if (!senderUid) {
    throw new HttpsError("unauthenticated", "Must be signed in.");
  }

  const receiverUid = request.data?.receiverUid as string | undefined;
  if (!receiverUid || typeof receiverUid !== "string") {
    throw new HttpsError("invalid-argument", "receiverUid is required.");
  }

  if (senderUid === receiverUid) {
    return {canSend: true};
  }

  const db = getFirestore();

  // ── 1. Parallel: block check + receiver doc fetch ────────────────
  const [blocked, receiverDoc] = await Promise.all([
    isBlocked(db, senderUid, receiverUid),
    db.collection("users").doc(receiverUid).get(),
  ]);

  if (blocked) {
    logger.info("Letter send blocked (block relationship)", {
      senderUid,
      receiverUid,
    });
    return {canSend: false, reason: "blocked"};
  }

  // ── 2. Receiver existence check ──────────────────────────────────
  if (!receiverDoc.exists) {
    // Receiver doesn't exist yet (invite-via-email scenario) — allow
    return {canSend: true};
  }

  // ── 3. Receiver's letterPermission ────────────────────────────────
  const receiverData = receiverDoc.data();
  const permission = (receiverData?.letterPermission as string) || "everyone";

  if (permission === "nobody") {
    return {canSend: false, reason: "not_accepting"};
  }

  if (permission === "followers") {
    // Check if receiver follows the sender
    const followSnap = await db
      .collection("follows")
      .where("followerUid", "==", receiverUid)
      .where("followingUid", "==", senderUid)
      .limit(1)
      .get();

    if (followSnap.empty) {
      return {canSend: false, reason: "followers_only"};
    }
  }

  return {canSend: true};
});

// ─── Block check (reused from engagement/send_engagement_push.ts) ───

async function isBlocked(
  db: FirebaseFirestore.Firestore,
  userA: string,
  userB: string
): Promise<boolean> {
  const [ab, ba] = await Promise.all([
    db
      .collection("blocks")
      .where("blockedBy", "==", userA)
      .where("blockedUid", "==", userB)
      .limit(1)
      .get(),
    db
      .collection("blocks")
      .where("blockedBy", "==", userB)
      .where("blockedUid", "==", userA)
      .limit(1)
      .get(),
  ]);
  return !ab.empty || !ba.empty;
}
