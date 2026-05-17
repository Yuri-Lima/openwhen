import {FieldValue, getFirestore} from "firebase-admin/firestore";
import {HttpsError, onCall} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";

import {copyApproved} from "./notification_copy";
import {MODERATION_REVIEWS_COLLECTION} from "./reviews";
import {writeModerationNotification} from "./user_notifications";

function assertAdmin(token: Record<string, unknown> | undefined): void {
  if (token?.admin !== true) {
    throw new HttpsError("permission-denied", "admin_required");
  }
}

const MAX_FEEDBACK = 4000;

function rejectionTitle(locale: string | undefined): string {
  const l = (locale ?? "en").toLowerCase();
  if (l.startsWith("pt")) return "Comentário não aprovado";
  if (l.startsWith("es")) return "Comentario no aprobado";
  return "Comment not approved";
}

export const adminListPendingModerationReviews = onCall(
  {cors: true},
  async (request) => {
    if (!request.auth?.uid) {
      throw new HttpsError("unauthenticated", "Sign in required");
    }
    assertAdmin(request.auth.token as Record<string, unknown>);

    const db = getFirestore();
    const limit = Math.min(Number(request.data?.limit) || 50, 100);
    const cursorId = request.data?.cursorId as string | undefined;

    let q = db
      .collection(MODERATION_REVIEWS_COLLECTION)
      .where("status", "==", "pending")
      .orderBy("createdAt", "desc")
      .limit(limit);

    if (cursorId) {
      const cur = await db
        .collection(MODERATION_REVIEWS_COLLECTION)
        .doc(cursorId)
        .get();
      if (cur.exists) {
        q = q.startAfter(cur);
      }
    }

    const snap = await q.get();
    const items = snap.docs.map((d) => ({id: d.id, ...d.data()}));
    const nextCursor =
      snap.docs.length === limit ? snap.docs[snap.docs.length - 1].id : null;

    return {items, nextCursor};
  }
);

export const adminResolveModerationReview = onCall(
  {cors: true},
  async (request) => {
    if (!request.auth?.uid) {
      throw new HttpsError("unauthenticated", "Sign in required");
    }
    assertAdmin(request.auth.token as Record<string, unknown>);

    const reviewId = request.data?.reviewId as string | undefined;
    const decision = request.data?.decision as
      | "approved"
      | "rejected"
      | undefined;
    const userFeedbackRaw = request.data?.userFeedback as string | undefined;

    if (!reviewId || !decision) {
      throw new HttpsError(
        "invalid-argument",
        "reviewId and decision required"
      );
    }
    if (decision !== "approved" && decision !== "rejected") {
      throw new HttpsError("invalid-argument", "invalid decision");
    }

    if (decision === "rejected") {
      const fb = typeof userFeedbackRaw === "string" ? userFeedbackRaw.trim() : "";
      if (!fb || fb.length > MAX_FEEDBACK) {
        throw new HttpsError(
          "invalid-argument",
          "userFeedback required when rejecting"
        );
      }
    }

    const db = getFirestore();
    const reviewRef = db.collection(MODERATION_REVIEWS_COLLECTION).doc(reviewId);

    const pre = await reviewRef.get();
    if (!pre.exists) {
      throw new HttpsError("not-found", "review_not_found");
    }
    const preData = pre.data()!;
    if (preData.status !== "pending") {
      return {ok: true, alreadyResolved: true};
    }

    if (preData.contentSurface !== "comment") {
      throw new HttpsError(
        "failed-precondition",
        "only_comment_reviews_supported"
      );
    }

    const letterId = preData.letterId as string | undefined;
    const authorUid = preData.authorUid as string;
    const authorDisplayName = (preData.authorDisplayName as string) ?? "";
    const text = preData.text as string;
    const locale = preData.locale as string | undefined;

    if (!letterId) {
      throw new HttpsError("failed-precondition", "review_missing_letterId");
    }

    if (decision === "approved") {
      const approvedCopy = copyApproved(locale);
      let alreadyResolved = false;

      await db.runTransaction(async (transaction) => {
        const rs = await transaction.get(reviewRef);
        if (!rs.exists) {
          throw new HttpsError("not-found", "review_not_found");
        }
        const rv = rs.data()!;
        if (rv.status !== "pending") {
          alreadyResolved = true;
          return;
        }

        const letterRef = db.collection("letters").doc(letterId);
        const letterSnap = await transaction.get(letterRef);
        if (!letterSnap.exists) {
          throw new HttpsError("failed-precondition", "letter_not_found");
        }
        const ld = letterSnap.data()!;
        if (
          !(
            ld.senderUid === authorUid ||
            ld.receiverUid === authorUid ||
            (ld.isPublic === true && ld.status === "opened")
          )
        ) {
          throw new HttpsError(
            "permission-denied",
            "cannot_comment_on_letter"
          );
        }

        const commentRef = db.collection("comments").doc();
        transaction.set(commentRef, {
          letterId,
          userUid: authorUid,
          userName: authorDisplayName,
          message: text,
          createdAt: FieldValue.serverTimestamp(),
        });

        transaction.update(letterRef, {
          commentCount: FieldValue.increment(1),
        });

        transaction.update(reviewRef, {
          status: "approved",
          resolvedAt: FieldValue.serverTimestamp(),
          resolvedByUid: request.auth!.uid,
        });

        const notifRef = db
          .collection("users")
          .doc(authorUid)
          .collection("notifications")
          .doc();
        transaction.set(notifRef, {
          type: "moderation_review",
          kind: "approved",
          reviewId,
          letterId,
          title: approvedCopy.title,
          body: approvedCopy.body,
          read: false,
          createdAt: FieldValue.serverTimestamp(),
        });
      });

      if (alreadyResolved) {
        return {ok: true, alreadyResolved: true};
      }

      logger.info("moderationReview approved", {
        reviewId,
        letterId,
        authorUid,
      });

      return {ok: true, alreadyResolved: false};
    }

    const userFeedback =
      typeof userFeedbackRaw === "string" ? userFeedbackRaw.trim() : "";

    let alreadyResolvedReject = false;
    await db.runTransaction(async (transaction) => {
      const rs = await transaction.get(reviewRef);
      if (!rs.exists) {
        throw new HttpsError("not-found", "review_not_found");
      }
      const rv = rs.data()!;
      if (rv.status !== "pending") {
        alreadyResolvedReject = true;
        return;
      }

      transaction.update(reviewRef, {
        status: "rejected",
        adminFeedback: userFeedback,
        resolvedAt: FieldValue.serverTimestamp(),
        resolvedByUid: request.auth!.uid,
      });

      const notifRef = db
        .collection("users")
        .doc(authorUid)
        .collection("notifications")
        .doc();
      transaction.set(notifRef, {
        type: "moderation_review",
        kind: "rejected",
        reviewId,
        letterId,
        title: rejectionTitle(locale),
        body: userFeedback,
        read: false,
        createdAt: FieldValue.serverTimestamp(),
      });
    });

    if (alreadyResolvedReject) {
      return {ok: true, alreadyResolved: true};
    }

    logger.info("moderationReview rejected", {reviewId, letterId, authorUid});

    return {ok: true, alreadyResolved: false};
  }
);
