/**
 * Cloud Function trigger: `onDocumentCreated("follows/{followId}")`.
 *
 * When a user follows another, notify the followed user via FCM + in-app.
 * No deduplication — follow/unfollow/follow should still notify.
 */

import {onDocumentCreated} from "firebase-functions/v2/firestore";
import {FieldValue, getFirestore} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";

import {sendEngagementNotification} from "./send_engagement_push";
import {copyFollow} from "./engagement_copy";

export const onFollowCreated = onDocumentCreated(
  "follows/{followId}",
  async (event) => {
    const snap = event.data;
    if (!snap) return;

    const data = snap.data();
    const followerUid = data.followerUid as string | undefined;
    const followingUid = data.followingUid as string | undefined;

    if (!followerUid || !followingUid) {
      logger.warn("onFollowCreated: missing followerUid or followingUid", {
        data,
      });
      return;
    }

    const db = getFirestore();

    // ── Increment denormalized counters ─────────────────────────────
    await Promise.all([
      db
        .collection("users")
        .doc(followingUid)
        .update({followersCount: FieldValue.increment(1)})
        .catch((err) =>
          logger.warn("onFollowCreated: failed to increment followersCount", {
            followingUid,
            err,
          })
        ),
      db
        .collection("users")
        .doc(followerUid)
        .update({followingCount: FieldValue.increment(1)})
        .catch((err) =>
          logger.warn("onFollowCreated: failed to increment followingCount", {
            followerUid,
            err,
          })
        ),
    ]);

    // ── Resolve follower profile ────────────────────────────────────
    const followerSnap = await db.collection("users").doc(followerUid).get();
    const followerData = followerSnap.data();
    const followerName = (followerData?.name as string) || "Someone";
    const followerPhoto = (followerData?.photoUrl as string) || null;

    // ── Resolve followed user locale ────────────────────────────────
    const followedSnap = await db.collection("users").doc(followingUid).get();
    const followedLocale = followedSnap.data()?.preferredLanguage as
      | string
      | undefined;

    const copy = copyFollow(followerName, followedLocale);

    await sendEngagementNotification(db, followingUid, {
      kind: "follow",
      actorUid: followerUid,
      actorName: followerName,
      actorPhotoUrl: followerPhoto,
      title: copy.title,
      body: copy.body,
    });
  }
);
