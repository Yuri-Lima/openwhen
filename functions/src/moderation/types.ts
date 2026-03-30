/** User-facing content surface (extensible). */
export type ContentType = "comment" | "letter" | "capsule";

/** Where the decision came from. */
export type ModerationSource = "provider" | "fallback" | "skipped";

/** Incident taxonomy for internal ops (Firestore aggregation). */
export type IncidentKind =
  | "config_missing"
  | "adapter_unavailable"
  | "auth_invalid"
  | "rate_limited"
  | "provider_error";

export type IncidentSeverity = "warning" | "critical";

export interface ModerationRequest {
  text: string;
  contentType?: ContentType;
  locale?: string;
  /** Required when human review queue triggers for comments. */
  letterId?: string;
}

/** Normalized API response for the Flutter client. */
export interface ModerationResponse {
  allowed: boolean;
  source: ModerationSource;
  /** Stable code for strict mode / errors (e.g. moderation_unavailable). */
  reason?: string;
  providerId?: string;
  flagged?: boolean;
  categories?: Record<string, boolean>;
  /** OpenAI category_scores when source is provider. */
  categoryScores?: Record<string, number>;
  /** Set when content is queued for human review. */
  reviewId?: string;
}

export interface SystemModerationConfig {
  aiModerationEnabled: boolean;
  aiModerationFailClosed: boolean;
  /** When true, indications on comments go to moderationReviews instead of auto-block-only. */
  humanModerationQueueEnabled: boolean;
  /** If set (>0), max(category_scores) >= threshold counts as an indication. If unset, only `flagged` does. */
  moderationReviewScoreThreshold: number | null;
}

export type ModerationReviewStatus = "pending" | "approved" | "rejected";
