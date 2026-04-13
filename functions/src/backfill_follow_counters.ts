/**
 * One-shot callable: recalculates `followersCount` and `followingCount`
 * for every user document based on the actual `follows` collection.
 *
 * Intended to run once after deploying the new `onFollowCreated` /
 * `onFollowDeleted` counter triggers, to fix historical data.
 *
 * Requires the caller to have the `admin` custom claim.
 *
 * Usage (from Flutter / admin panel):
 *   FirebaseFunctions.instance.httpsCallable('backfillFollowCounters').call();
 */

import {HttpsError, onCall} from "firebase-functions/v2/https";
import {getFirestore} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";

/** How many user docs to process per Firestore batch commit. */
const BATCH_SIZE = 400;

export const backfillFollowCounters = onCall(
  {cors: true, timeoutSeconds: 540, memory: "512MiB"},
  async (request) => {
    // ── Auth: require admin claim ──────────────────────────────────
    if (!request.auth?.token?.admin) {
      throw new HttpsError(
        "permission-denied",
        "Only admins can run the backfill."
      );
    }

    try {
    const db = getFirestore();
    logger.info("backfillFollowCounters: starting");

    // ── 1. Count followers per user (followingUid → count) ─────────
    const followersMap = new Map<string, number>();
    const followingMap = new Map<string, number>();

    let lastDoc: FirebaseFirestore.QueryDocumentSnapshot | undefined;
    let totalFollows = 0;

    // Paginate through the entire follows collection
    while (true) {
      let query = db
        .collection("follows")
        .orderBy("__name__")
        .limit(BATCH_SIZE);
      if (lastDoc) {
        query = query.startAfter(lastDoc);
      }
      const snap = await query.get();
      if (snap.empty) break;

      for (const doc of snap.docs) {
        const data = doc.data();
        const followerUid = data.followerUid as string | undefined;
        const followingUid = data.followingUid as string | undefined;

        if (followingUid) {
          followersMap.set(
            followingUid,
            (followersMap.get(followingUid) ?? 0) + 1
          );
        }
        if (followerUid) {
          followingMap.set(
            followerUid,
            (followingMap.get(followerUid) ?? 0) + 1
          );
        }
      }

      totalFollows += snap.docs.length;
      lastDoc = snap.docs[snap.docs.length - 1];
      if (snap.docs.length < BATCH_SIZE) break;
    }

    logger.info(
      `backfillFollowCounters: scanned ${totalFollows} follow docs, ` +
        `${followersMap.size} users with followers, ` +
        `${followingMap.size} users following others`
    );

    // ── 2. Collect all unique UIDs that need updates ───────────────
    const allUids = new Set<string>([
      ...followersMap.keys(),
      ...followingMap.keys(),
    ]);

    // ── 3. Batch-update user documents ─────────────────────────────
    let updatedCount = 0;
    let batch = db.batch();
    let batchCount = 0;

    for (const uid of allUids) {
      const userRef = db.collection("users").doc(uid);

      // Skip UIDs whose user document was deleted (update would throw NOT_FOUND)
      const userSnap = await userRef.get();
      if (!userSnap.exists) {
        logger.warn("backfillFollowCounters: skipping missing user doc", {uid});
        continue;
      }

      const update: Record<string, number> = {};

      const fc = followersMap.get(uid);
      if (fc !== undefined) update.followersCount = fc;
      else update.followersCount = 0;

      const fg = followingMap.get(uid);
      if (fg !== undefined) update.followingCount = fg;
      else update.followingCount = 0;

      batch.update(userRef, update);
      batchCount++;
      updatedCount++;

      if (batchCount >= BATCH_SIZE) {
        await batch.commit();
        batch = db.batch();
        batchCount = 0;
      }
    }

    // Also reset users who have NO follows at all but might have stale counts.
    // Paginate through all users and zero out anyone not in allUids.
    let lastUserDoc: FirebaseFirestore.QueryDocumentSnapshot | undefined;
    while (true) {
      let userQuery = db
        .collection("users")
        .orderBy("__name__")
        .limit(BATCH_SIZE);
      if (lastUserDoc) {
        userQuery = userQuery.startAfter(lastUserDoc);
      }
      const userSnap = await userQuery.get();
      if (userSnap.empty) break;

      for (const doc of userSnap.docs) {
        if (!allUids.has(doc.id)) {
          const data = doc.data();
          const currentFollowers = data.followersCount as number | undefined;
          const currentFollowing = data.followingCount as number | undefined;
          // Only update if they have non-zero stale values
          if ((currentFollowers && currentFollowers !== 0) ||
              (currentFollowing && currentFollowing !== 0)) {
            batch.update(doc.ref, {
              followersCount: 0,
              followingCount: 0,
            });
            batchCount++;
            updatedCount++;

            if (batchCount >= BATCH_SIZE) {
              await batch.commit();
              batch = db.batch();
              batchCount = 0;
            }
          }
        }
      }

      lastUserDoc = userSnap.docs[userSnap.docs.length - 1];
      if (userSnap.docs.length < BATCH_SIZE) break;
    }

    // Commit remaining
    if (batchCount > 0) {
      await batch.commit();
    }

    logger.info(
      `backfillFollowCounters: done — updated ${updatedCount} user docs`
    );

    return {
      success: true,
      totalFollowDocs: totalFollows,
      usersUpdated: updatedCount,
    };
    } catch (err) {
      // Surface the real error message instead of generic INTERNAL
      if (err instanceof HttpsError) throw err;
      const msg = err instanceof Error ? err.message : String(err);
      logger.error("backfillFollowCounters: unhandled error", {err: msg});
      throw new HttpsError("internal", `Backfill failed: ${msg}`);
    }
  }
);
