/**
 * Cloud Function trigger: `onDocumentCreated("comments/{commentId}")`.
 *
 * When a user comments on a letter, notify the letter author via FCM + in-app.
 * No deduplication — each comment is a meaningful individual event.
 */

import {onDocumentCreated} from "firebase-functions/v2/firestore";
import {getFirestore} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";

import {sendEngagementNotification} from "./send_engagement_push";
import {copyComment} from "./engagement_copy";

export const onCommentCreated = onDocumentCreated(
  "comments/{commentId}",
  async (event) => {
    const snap = event.data;
    if (!snap) return;

    const data = snap.data();
    const letterId = data.letterId as string | undefined;
    const commenterUid = data.userUid as string | undefined;
    const commenterName = (data.userName as string) || "Someone";
    const message = (data.message as string) || "";

    if (!letterId || !commenterUid) {
      logger.warn("onCommentCreated: missing letterId or userUid", {data});
      return;
    }

    const db = getFirestore();

    // ── Resolve letter author ───────────────────────────────────────
    const letterSnap = await db.collection("letters").doc(letterId).get();
    if (!letterSnap.exists) {
      logger.warn("onCommentCreated: letter not found", {letterId});
      return;
    }
    const authorUid = letterSnap.data()?.senderUid as string | undefined;
    if (!authorUid) return;

    // ── Resolve commenter photo ─────────────────────────────────────
    const commenterSnap = await db.collection("users").doc(commenterUid).get();
    const commenterPhoto =
      (commenterSnap.data()?.photoUrl as string) || null;

    // ── Resolve author locale ───────────────────────────────────────
    const authorSnap = await db.collection("users").doc(authorUid).get();
    const authorLocale = authorSnap.data()?.preferredLanguage as
      | string
      | undefined;

    const copy = copyComment(commenterName, authorLocale);
    const preview = message.length > 100 ? message.slice(0, 100) + "…" : message;

    await sendEngagementNotification(db, authorUid, {
      kind: "comment",
      actorUid: commenterUid,
      actorName: commenterName,
      actorPhotoUrl: commenterPhoto,
      letterId,
      commentPreview: preview,
      title: copy.title,
      body: preview,
    });
  }
);
