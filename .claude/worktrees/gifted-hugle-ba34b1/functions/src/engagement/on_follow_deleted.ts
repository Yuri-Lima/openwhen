/**
 * Cloud Function trigger: `onDocumentDeleted("follows/{followId}")`.
 *
 * When a follow relationship is removed, decrement the counters:
 *  - followingUid's `followersCount` (they lost a follower)
 *  - followerUid's `followingCount` (they unfollowed someone)
 */

import {onDocumentDeleted} from "firebase-functions/v2/firestore";
import {FieldValue, getFirestore} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";

export const onFollowDeleted = onDocumentDeleted(
  "follows/{followId}",
  async (event) => {
    const snap = event.data;
    if (!snap) return;

    const data = snap.data();
    const followerUid = data.followerUid as string | undefined;
    const followingUid = data.followingUid as string | undefined;

    if (!followerUid || !followingUid) {
      logger.warn("onFollowDeleted: missing followerUid or followingUid", {
        data,
      });
      return;
    }

    const db = getFirestore();

    // Decrement both counters atomically (independent writes, no tx needed).
    await Promise.all([
      db
        .collection("users")
        .doc(followingUid)
        .update({followersCount: FieldValue.increment(-1)})
        .catch((err) =>
          logger.warn("onFollowDeleted: failed to decrement followersCount", {
            followingUid,
            err,
          })
        ),
      db
        .collection("users")
        .doc(followerUid)
        .update({followingCount: FieldValue.increment(-1)})
        .catch((err) =>
          logger.warn("onFollowDeleted: failed to decrement followingCount", {
            followerUid,
            err,
          })
        ),
    ]);

    logger.info("onFollowDeleted: counters decremented", {
      followerUid,
      followingUid,
    });
  }
);
