import {getFirestore} from "firebase-admin/firestore";
import {HttpsError, onCall} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";

import {copyPendingReview} from "./notification_copy";
import {applyModerationPolicy, hasIndication} from "./policy";
import {createModerationReview} from "./reviews";
import {resolveModeration} from "./resolve";
import type {ContentType, ModerationResponse, SystemModerationConfig} from "./types";
import {writeModerationNotification} from "./user_notifications";

const MAX_TEXT_LEN = 16000;
const MAX_LETTER_ID_LEN = 128;

async function readSystemModerationConfig(): Promise<SystemModerationConfig> {
  const snap = await getFirestore()
    .collection("systemConfig")
    .doc("app")
    .get();
  const data = snap.data();
  const thr = data?.moderationReviewScoreThreshold;
  let moderationReviewScoreThreshold: number | null = null;
  if (typeof thr === "number" && Number.isFinite(thr) && thr > 0) {
    moderationReviewScoreThreshold = thr;
  }
  return {
    aiModerationEnabled: data?.aiModerationEnabled === true,
    aiModerationFailClosed: data?.aiModerationFailClosed !== false,
    humanModerationQueueEnabled: data?.humanModerationQueueEnabled === true,
    moderationReviewScoreThreshold,
  };
}

async function fetchAuthorDisplayName(uid: string): Promise<string> {
  const snap = await getFirestore().collection("users").doc(uid).get();
  const name = snap.data()?.name;
  if (typeof name === "string" && name.trim().length > 0) {
    return name.trim();
  }
  return "";
}

/**
 * Authenticated clients send text for server-side moderation (OpenAI by default).
 */
export const moderateContent = onCall({cors: true}, async (request) => {
  if (!request.auth?.uid) {
    throw new HttpsError("unauthenticated", "Sign in required");
  }

  const raw = request.data?.text;
  const text = typeof raw === "string" ? raw.trim() : "";
  if (!text) {
    throw new HttpsError("invalid-argument", "text required");
  }
  if (text.length > MAX_TEXT_LEN) {
    throw new HttpsError("invalid-argument", "text too long");
  }

  const contentType = request.data?.contentType as ContentType | undefined;
  const locale =
    typeof request.data?.locale === "string" ? request.data.locale : undefined;

  const letterRaw = request.data?.letterId;
  const letterId =
    typeof letterRaw === "string" ? letterRaw.trim() : undefined;
  if (letterId && letterId.length > MAX_LETTER_ID_LEN) {
    throw new HttpsError("invalid-argument", "letterId too long");
  }

  const config = await readSystemModerationConfig();

  const mod: ModerationResponse = await resolveModeration(
    {text, contentType, locale, letterId},
    config,
    {
      failClosed: config.aiModerationFailClosed,
      callerUid: request.auth.uid,
    }
  );

  if (mod.source !== "provider" || mod.flagged === undefined) {
    return mod;
  }

  const flagged = mod.flagged === true;
  const categoryScores = mod.categoryScores ?? {};
  const indication = hasIndication(
    flagged,
    categoryScores,
    config.moderationReviewScoreThreshold
  );

  const queueOn =
    config.humanModerationQueueEnabled === true &&
    contentType === "comment" &&
    indication;

  if (queueOn) {
    if (!letterId || letterId.length === 0) {
      throw new HttpsError(
        "invalid-argument",
        "letterId required when comment is queued for review"
      );
    }

    const db = getFirestore();
    try {
      const authorDisplayName = await fetchAuthorDisplayName(request.auth.uid);
      const reviewId = await createModerationReview(
        {
          authorUid: request.auth.uid,
          authorDisplayName,
          text,
          contentSurface: "comment",
          letterId,
          locale,
          flagged,
          categories: mod.categories ?? {},
          categoryScores,
        },
        db
      );
      const copy = copyPendingReview(locale);
      await writeModerationNotification(db, request.auth.uid, {
        reviewId,
        letterId,
        kind: "pending",
        title: copy.title,
        body: copy.body,
      });
      return {
        ...mod,
        allowed: false,
        reason: "pending_moderation_review",
        reviewId,
      };
    } catch (e) {
      logger.error("moderation: human queue failed", {
        message: e instanceof Error ? e.message : String(e),
      });
      throw new HttpsError(
        "internal",
        "moderation_queue_failed"
      );
    }
  }

  const {allowed} = applyModerationPolicy(flagged);
  return {
    ...mod,
    allowed,
  };
});
