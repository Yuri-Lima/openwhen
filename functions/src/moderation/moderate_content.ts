import {getFirestore} from "firebase-admin/firestore";
import {HttpsError, onCall} from "firebase-functions/v2/https";

import {resolveModeration} from "./resolve";
import type {ContentType, SystemModerationConfig} from "./types";

const MAX_TEXT_LEN = 16000;

async function readSystemModerationConfig(): Promise<SystemModerationConfig> {
  const snap = await getFirestore()
    .collection("systemConfig")
    .doc("app")
    .get();
  const data = snap.data();
  return {
    aiModerationEnabled: data?.aiModerationEnabled === true,
    aiModerationFailClosed: data?.aiModerationFailClosed !== false,
  };
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

  const config = await readSystemModerationConfig();

  return resolveModeration(
    {text, contentType, locale},
    config,
    {
      failClosed: config.aiModerationFailClosed,
      callerUid: request.auth.uid,
    }
  );
});
