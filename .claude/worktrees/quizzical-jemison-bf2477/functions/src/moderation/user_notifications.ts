import {FieldValue, Firestore} from "firebase-admin/firestore";

export type ModerationNotificationKind = "pending" | "approved" | "rejected";

export interface WriteModerationNotificationInput {
  reviewId: string;
  letterId?: string | null;
  kind: ModerationNotificationKind;
  title: string;
  body: string;
}

/**
 * Writes `users/{uid}/notifications/{autoId}` — client reads via Firestore rules.
 */
export async function writeModerationNotification(
  db: Firestore,
  recipientUid: string,
  input: WriteModerationNotificationInput
): Promise<string> {
  const ref = db
    .collection("users")
    .doc(recipientUid)
    .collection("notifications")
    .doc();
  await ref.set({
    type: "moderation_review",
    kind: input.kind,
    reviewId: input.reviewId,
    letterId: input.letterId ?? null,
    title: input.title,
    body: input.body,
    read: false,
    createdAt: FieldValue.serverTimestamp(),
  });
  return ref.id;
}

