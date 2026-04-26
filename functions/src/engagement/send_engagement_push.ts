/**
 * Centralised helper: writes an in-app notification doc AND sends an FCM push.
 *
 * Re-uses the `users/{uid}/notifications` subcollection already read by the
 * Flutter client (`ModerationNotificationsScreen`).
 *
 * Anti-spam: for likes, the caller passes `dedupeKey` so we can coalesce
 * rapid-fire likes on the same letter into a single notification.
 */

import {FieldValue, Firestore} from "firebase-admin/firestore";
import {getMessaging} from "firebase-admin/messaging";
import * as logger from "firebase-functions/logger";

// ─── Types ──────────────────────────────────────────────────────────

export type EngagementKind = "like" | "comment" | "follow";

export interface EngagementNotificationInput {
  /** Notification sub-type. */
  kind: EngagementKind;
  /** UID of the user who performed the action. */
  actorUid: string;
  /** Display name of the actor (resolved by caller). */
  actorName: string;
  /** Profile photo URL of the actor (optional). */
  actorPhotoUrl?: string | null;
  /** Letter ID — relevant for like / comment. */
  letterId?: string | null;
  /** Comment preview (first ~100 chars) — relevant for comment. */
  commentPreview?: string | null;
  /** Localised title for push + inbox. */
  title: string;
  /** Localised body for push + inbox. */
  body: string;
  /**
   * Optional deduplication key. When set, the function checks if an unread
   * notification with the same `dedupeKey` was created within the last
   * `DEDUPE_WINDOW_MS`. If so, it skips creating a new doc/push.
   */
  dedupeKey?: string | null;
}

// ─── Constants ──────────────────────────────────────────────────────

/** Window (ms) within which duplicate engagement notifications are coalesced. */
const DEDUPE_WINDOW_MS = 5 * 60 * 1000; // 5 minutes

// ─── Main helper ────────────────────────────────────────────────────

/**
 * Sends an engagement notification (Firestore doc + FCM push).
 *
 * Returns the created notification doc ID, or `null` if skipped (self-action,
 * deduplicated, missing token, blocked, etc.).
 */
export async function sendEngagementNotification(
  db: Firestore,
  recipientUid: string,
  input: EngagementNotificationInput
): Promise<string | null> {
  // ── 1. Never notify yourself ──────────────────────────────────────
  if (recipientUid === input.actorUid) {
    return null;
  }

  // ── 2. Check block (either direction) ─────────────────────────────
  const blocked = await isBlocked(db, recipientUid, input.actorUid);
  if (blocked) {
    return null;
  }

  // ── 3. Dedupe check ───────────────────────────────────────────────
  if (input.dedupeKey) {
    const notifCol = db
      .collection("users")
      .doc(recipientUid)
      .collection("notifications");

    const cutoff = new Date(Date.now() - DEDUPE_WINDOW_MS);
    const existing = await notifCol
      .where("dedupeKey", "==", input.dedupeKey)
      .where("read", "==", false)
      .where("createdAt", ">=", cutoff)
      .limit(1)
      .get();

    if (!existing.empty) {
      logger.info("Engagement notification deduplicated", {
        recipientUid,
        dedupeKey: input.dedupeKey,
      });
      return null;
    }
  }

  // ── 4. Write in-app notification doc ──────────────────────────────
  const ref = db
    .collection("users")
    .doc(recipientUid)
    .collection("notifications")
    .doc();

  const notifData: Record<string, unknown> = {
    type: "engagement",
    kind: input.kind,
    actorUid: input.actorUid,
    actorName: input.actorName,
    actorPhotoUrl: input.actorPhotoUrl ?? null,
    letterId: input.letterId ?? null,
    commentPreview: input.commentPreview ?? null,
    title: input.title,
    body: input.body,
    read: false,
    createdAt: FieldValue.serverTimestamp(),
    ...(input.dedupeKey ? {dedupeKey: input.dedupeKey} : {}),
  };

  await ref.set(notifData);

  // ── 5. Send FCM push ──────────────────────────────────────────────
  await sendFcmPush(db, recipientUid, input);

  return ref.id;
}

// ─── FCM push ───────────────────────────────────────────────────────

async function sendFcmPush(
  db: Firestore,
  recipientUid: string,
  input: EngagementNotificationInput
): Promise<void> {
  const userSnap = await db.collection("users").doc(recipientUid).get();
  const fcmToken = userSnap.data()?.fcmToken as string | undefined;

  if (!fcmToken) {
    logger.info("No FCM token for recipient; skipping push", {recipientUid});
    return;
  }

  try {
    await getMessaging().send({
      token: fcmToken,
      notification: {
        title: input.title,
        body: input.body,
      },
      data: {
        type: "engagement",
        kind: input.kind,
        ...(input.letterId ? {letterId: input.letterId} : {}),
        actorUid: input.actorUid,
      },
      android: {
        priority: "high",
        notification: {
          channelId: "whenote_default",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      },
      apns: {
        payload: {
          aps: {
            alert: {
              title: input.title,
              body: input.body,
            },
            sound: "default",
            badge: 1,
          },
        },
      },
    });
  } catch (err: unknown) {
    // Token invalid / unregistered → clean it up
    if (isTokenError(err)) {
      logger.warn("FCM token invalid; clearing from user doc", {recipientUid});
      await db
        .collection("users")
        .doc(recipientUid)
        .update({
          fcmToken: FieldValue.delete(),
          fcmTokenUpdatedAt: FieldValue.delete(),
        });
    } else {
      logger.error("FCM send failed", {recipientUid, err});
    }
  }
}

// ─── Block check ────────────────────────────────────────────────────

async function isBlocked(
  db: Firestore,
  userA: string,
  userB: string
): Promise<boolean> {
  // Check both directions: A blocked B, or B blocked A.
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

// ─── Error helpers ──────────────────────────────────────────────────

function isTokenError(err: unknown): boolean {
  if (typeof err !== "object" || err === null) return false;
  const code = (err as { code?: string }).code;
  return (
    code === "messaging/invalid-registration-token" ||
    code === "messaging/registration-token-not-registered"
  );
}
