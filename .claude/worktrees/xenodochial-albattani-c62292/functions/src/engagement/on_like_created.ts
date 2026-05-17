/**
 * Cloud Function trigger: `onDocumentCreated("likes/{likeId}")`.
 *
 * When a user likes a letter, notify the letter author via FCM + in-app inbox.
 * Deduplication: coalesces rapid-fire likes on the same letter within 5 min.
 */

import {onDocumentCreated} from "firebase-functions/v2/firestore";
import {getFirestore} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";

import {sendEngagementNotification} from "./send_engagement_push";
import {copyLike} from "./engagement_copy";

export const onLikeCreated = onDocumentCreated(
  "likes/{likeId}",
  async (event) => {
    const snap = event.data;
    if (!snap) return;

    const data = snap.data();
    const letterId = data.letterId as string | undefined;
    const likerUid = data.userUid as string | undefined;

    if (!letterId || !likerUid) {
      logger.warn("onLikeCreated: missing letterId or userUid", {data});
      return;
    }

    const db = getFirestore();

    // ── Resolve letter author ───────────────────────────────────────
    const letterSnap = await db.collection("letters").doc(letterId).get();
    if (!letterSnap.exists) {
      logger.warn("onLikeCreated: letter not found", {letterId});
      return;
    }
    const authorUid = letterSnap.data()?.senderUid as string | undefined;
    if (!authorUid) return;

    // ── Resolve liker profile ───────────────────────────────────────
    const likerSnap = await db.collection("users").doc(likerUid).get();
    const likerData = likerSnap.data();
    const likerName = (likerData?.name as string) || "Someone";
    const likerPhoto = (likerData?.photoUrl as string) || null;

    // ── Resolve author locale ───────────────────────────────────────
    const authorSnap = await db.collection("users").doc(authorUid).get();
    const authorLocale = authorSnap.data()?.preferredLanguage as
      | string
      | undefined;

    const copy = copyLike(likerName, authorLocale);

    await sendEngagementNotification(db, authorUid, {
      kind: "like",
      actorUid: likerUid,
      actorName: likerName,
      actorPhotoUrl: likerPhoto,
      letterId,
      title: copy.title,
      body: copy.body,
      dedupeKey: `like_${letterId}`,
    });
  }
);
