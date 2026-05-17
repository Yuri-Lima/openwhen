import {FieldValue, Firestore, getFirestore} from "firebase-admin/firestore";

import type {ContentType} from "./types";

export const MODERATION_REVIEWS_COLLECTION = "moderationReviews";

export interface CreateModerationReviewInput {
  authorUid: string;
  authorDisplayName: string;
  text: string;
  contentSurface: ContentType;
  letterId?: string;
  locale?: string;
  flagged: boolean;
  categories: Record<string, boolean>;
  categoryScores: Record<string, number>;
}

/**
 * Creates a pending human-moderation queue item. Returns new document id.
 */
export async function createModerationReview(
  input: CreateModerationReviewInput,
  db: Firestore = getFirestore()
): Promise<string> {
  const ref = db.collection(MODERATION_REVIEWS_COLLECTION).doc();
  await ref.set({
    status: "pending",
    authorUid: input.authorUid,
    authorDisplayName: input.authorDisplayName,
    text: input.text,
    contentSurface: input.contentSurface,
    letterId: input.letterId ?? null,
    locale: input.locale ?? null,
    flagged: input.flagged,
    categories: input.categories,
    categoryScores: input.categoryScores,
    createdAt: FieldValue.serverTimestamp(),
  });
  return ref.id;
}
