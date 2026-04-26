import {onObjectFinalized} from "firebase-functions/v2/storage";
import {getFirestore} from "firebase-admin/firestore";
import {getStorage} from "firebase-admin/storage";
import * as logger from "firebase-functions/logger";

import {getOpenAIApiKey} from "./factory";
import {
  ModerationProviderError,
  moderateImageWithOpenAI,
  moderateWithOpenAI,
  transcribeAudioWithWhisper,
} from "./openai_adapter";
import {recordModerationIncident} from "./incidents";
import {writeModerationNotification} from "./user_notifications";
import {copyMediaRemoved} from "./notification_copy";

// ─── Storage path patterns ──────────────────────────────────────────
// avatars/{uid}.jpg
// capsules/photos/{uid}_{ts}.jpg
// handwritten/{uid}_{ts}.jpg
// voiceLetters/{uid}_{ts}.m4a

const BUCKET = "openwhen-923f5.firebasestorage.app";

/** Signed URL lifetime for image moderation requests (10 minutes). */
const SIGNED_URL_EXPIRY_MS = 10 * 60 * 1000;

/**
 * Extract the uploader UID from known storage paths.
 * Returns null for paths we don't moderate.
 */
function extractUidFromPath(filePath: string): string | null {
  // avatars/{uid}.jpg
  const avatarMatch = filePath.match(/^avatars\/([^/]+)\.jpg$/);
  if (avatarMatch) return avatarMatch[1];

  // capsules/photos/{uid}_{ts}.jpg
  const capsuleMatch = filePath.match(/^capsules\/photos\/([^_]+)_/);
  if (capsuleMatch) return capsuleMatch[1];

  // handwritten/{uid}_{ts}.jpg
  const handwrittenMatch = filePath.match(/^handwritten\/([^_]+)_/);
  if (handwrittenMatch) return handwrittenMatch[1];

  // voiceLetters/{uid}_{ts}.m4a
  const voiceMatch = filePath.match(/^voiceLetters\/([^_]+)_/);
  if (voiceMatch) return voiceMatch[1];

  return null;
}

/**
 * Determine the media kind from the storage path for cleanup logic.
 */
type MediaKind = "avatar" | "capsule_photo" | "handwritten" | "voice_letter";

function classifyPath(filePath: string): MediaKind | null {
  if (filePath.startsWith("avatars/")) return "avatar";
  if (filePath.startsWith("capsules/photos/")) return "capsule_photo";
  if (filePath.startsWith("handwritten/")) return "handwritten";
  if (filePath.startsWith("voiceLetters/")) return "voice_letter";
  return null;
}

// ─── Firestore cleanup when media is flagged ────────────────────────

async function cleanFirestoreReference(
  uid: string,
  filePath: string,
  kind: MediaKind,
  downloadUrl: string
): Promise<void> {
  const db = getFirestore();

  switch (kind) {
  case "avatar":
    // Clear photoUrl in users/{uid}
    await db.collection("users").doc(uid).update({photoUrl: null});
    break;

  case "capsule_photo":
    // Remove URL from photos array in matching capsule(s) by this user
    // The capsule may already be saved, so we search for it
    try {
      const capsuleSnap = await db
        .collection("capsules")
        .where("creatorUid", "==", uid)
        .get();
      for (const doc of capsuleSnap.docs) {
        const photos = doc.data().photos as string[] | undefined;
        if (photos && photos.includes(downloadUrl)) {
          await doc.ref.update({
            photos: photos.filter((u: string) => u !== downloadUrl),
          });
        }
      }
    } catch (e) {
      logger.warn("moderate_storage: failed to clean capsule photo ref", {
        uid,
        filePath,
        error: e instanceof Error ? e.message : String(e),
      });
    }
    break;

  case "handwritten":
    // Clear handwrittenImageUrl in matching letter(s)
    try {
      const letterSnap = await db
        .collection("letters")
        .where("senderUid", "==", uid)
        .get();
      for (const doc of letterSnap.docs) {
        const imgUrl = doc.data().handwrittenImageUrl as string | undefined;
        if (imgUrl && imgUrl.includes(filePath)) {
          await doc.ref.update({handwrittenImageUrl: null});
        }
      }
    } catch (e) {
      logger.warn("moderate_storage: failed to clean handwritten ref", {
        uid,
        filePath,
        error: e instanceof Error ? e.message : String(e),
      });
    }
    break;

  case "voice_letter":
    // Clear voiceUrl in matching letter(s)
    try {
      const letterSnap = await db
        .collection("letters")
        .where("senderUid", "==", uid)
        .get();
      for (const doc of letterSnap.docs) {
        const voiceUrl = doc.data().voiceUrl as string | undefined;
        if (voiceUrl && voiceUrl.includes(filePath)) {
          await doc.ref.update({voiceUrl: null});
        }
      }
    } catch (e) {
      logger.warn("moderate_storage: failed to clean voice ref", {
        uid,
        filePath,
        error: e instanceof Error ? e.message : String(e),
      });
    }
    break;
  }
}

// ─── Image moderation logic ─────────────────────────────────────────

async function moderateImage(
  filePath: string,
  uid: string,
  kind: MediaKind
): Promise<void> {
  const apiKey = getOpenAIApiKey();
  if (!apiKey) {
    await recordModerationIncident({
      kind: "config_missing",
      message: "OPENAI_API_KEY not set — skipping image moderation",
      providerId: "openai",
      callerUid: uid,
    });
    logger.warn("moderate_storage: OPENAI_API_KEY missing, skipping", {filePath});
    return;
  }

  const bucket = getStorage().bucket(BUCKET);
  const file = bucket.file(filePath);

  // Generate a temporary signed URL for OpenAI to fetch
  const [signedUrl] = await file.getSignedUrl({
    action: "read",
    expires: Date.now() + SIGNED_URL_EXPIRY_MS,
  });

  let downloadUrl: string;
  try {
    const metadata = await file.getMetadata();
    downloadUrl = metadata[0]?.mediaLink ?? signedUrl;
  } catch {
    downloadUrl = signedUrl;
  }

  try {
    const result = await moderateImageWithOpenAI(apiKey, signedUrl);

    if (result.flagged) {
      logger.info("moderate_storage: image FLAGGED — deleting", {
        filePath,
        uid,
        categories: result.categories,
      });

      // 1. Delete the file from Storage
      await file.delete().catch((e: Error) => {
        logger.warn("moderate_storage: failed to delete file", {
          filePath,
          error: e.message,
        });
      });

      // 2. Clean Firestore reference
      await cleanFirestoreReference(uid, filePath, kind, downloadUrl);

      // 3. Record moderation incident
      await recordModerationIncident({
        kind: "provider_error", // reusing existing kind for logging
        message: `Image flagged and removed: ${filePath}`,
        providerId: "openai",
        callerUid: uid,
      });

      // 4. Notify the user
      const db = getFirestore();
      const copy = copyMediaRemoved("image");
      await writeModerationNotification(db, uid, {
        reviewId: `media_${Date.now()}`,
        kind: "rejected",
        title: copy.title,
        body: copy.body,
      });
    } else {
      logger.info("moderate_storage: image passed moderation", {
        filePath,
        uid,
      });
    }
  } catch (e) {
    const isProv = e instanceof ModerationProviderError;
    await recordModerationIncident({
      kind: isProv ? e.kind : "provider_error",
      message: `Image moderation failed for ${filePath}: ${e instanceof Error ? e.message : String(e)}`,
      providerId: "openai",
      httpStatus: isProv ? e.httpStatus : undefined,
      callerUid: uid,
    });
    logger.error("moderate_storage: image moderation error", {
      filePath,
      error: e instanceof Error ? e.message : String(e),
    });
    // Fail open for now — don't delete the file on provider errors
  }
}

// ─── Audio moderation logic (Fase 2 — Whisper + text moderation) ────

async function moderateAudio(
  filePath: string,
  uid: string,
  kind: MediaKind
): Promise<void> {
  const apiKey = getOpenAIApiKey();
  if (!apiKey) {
    await recordModerationIncident({
      kind: "config_missing",
      message: "OPENAI_API_KEY not set — skipping audio moderation",
      providerId: "openai",
      callerUid: uid,
    });
    logger.warn("moderate_storage: OPENAI_API_KEY missing, skipping audio", {filePath});
    return;
  }

  const bucket = getStorage().bucket(BUCKET);
  const file = bucket.file(filePath);

  let downloadUrl: string;
  try {
    const metadata = await file.getMetadata();
    downloadUrl = metadata[0]?.mediaLink ?? "";
  } catch {
    downloadUrl = "";
  }

  try {
    // 1. Download audio to memory
    const [audioBuffer] = await file.download();
    const fileName = filePath.split("/").pop() ?? "audio.m4a";

    // 2. Transcribe with Whisper
    const transcription = await transcribeAudioWithWhisper(apiKey, audioBuffer, fileName);

    if (!transcription || transcription.trim().length === 0) {
      logger.info("moderate_storage: audio transcription empty, skipping moderation", {
        filePath,
        uid,
      });
      return;
    }

    // 3. Moderate the transcribed text
    const result = await moderateWithOpenAI(apiKey, transcription.trim());

    if (result.flagged) {
      logger.info("moderate_storage: audio FLAGGED — deleting", {
        filePath,
        uid,
        categories: result.categories,
      });

      // Delete file
      await file.delete().catch((e: Error) => {
        logger.warn("moderate_storage: failed to delete audio file", {
          filePath,
          error: e.message,
        });
      });

      // Clean Firestore reference
      await cleanFirestoreReference(uid, filePath, kind, downloadUrl);

      // Record incident
      await recordModerationIncident({
        kind: "provider_error",
        message: `Audio flagged and removed: ${filePath}`,
        providerId: "openai",
        callerUid: uid,
      });

      // Notify user
      const db = getFirestore();
      const copy = copyMediaRemoved("audio");
      await writeModerationNotification(db, uid, {
        reviewId: `media_${Date.now()}`,
        kind: "rejected",
        title: copy.title,
        body: copy.body,
      });
    } else {
      logger.info("moderate_storage: audio passed moderation", {
        filePath,
        uid,
      });
    }
  } catch (e) {
    const isProv = e instanceof ModerationProviderError;
    await recordModerationIncident({
      kind: isProv ? e.kind : "provider_error",
      message: `Audio moderation failed for ${filePath}: ${e instanceof Error ? e.message : String(e)}`,
      providerId: "openai",
      httpStatus: isProv ? e.httpStatus : undefined,
      callerUid: uid,
    });
    logger.error("moderate_storage: audio moderation error", {
      filePath,
      error: e instanceof Error ? e.message : String(e),
    });
    // Fail open — don't delete on provider errors
  }
}

// ─── Main trigger ───────────────────────────────────────────────────

/**
 * Triggered whenever a file is finalized (uploaded) in Firebase Storage.
 * Routes to image or audio moderation based on content type and path.
 */
export const moderateUploadedFile = onObjectFinalized(
  {bucket: BUCKET},
  async (event) => {
    const filePath = event.data.name;
    const contentType = event.data.contentType;

    if (!filePath || !contentType) {
      logger.info("moderate_storage: missing filePath or contentType, skipping");
      return;
    }

    const kind = classifyPath(filePath);
    if (!kind) {
      // Not a moderated path — skip silently
      return;
    }

    const uid = extractUidFromPath(filePath);
    if (!uid) {
      logger.warn("moderate_storage: could not extract UID from path", {filePath});
      return;
    }

    logger.info("moderate_storage: processing upload", {
      filePath,
      contentType,
      kind,
      uid,
    });

    if (contentType.startsWith("image/")) {
      await moderateImage(filePath, uid, kind);
    } else if (contentType.startsWith("audio/")) {
      await moderateAudio(filePath, uid, kind);
    } else {
      logger.info("moderate_storage: unsupported content type, skipping", {
        filePath,
        contentType,
      });
    }
  }
);
