/**
 * Map OpenAI moderation result to allow/block (single policy module).
 */
export function applyModerationPolicy(flagged: boolean): {allowed: boolean} {
  return {allowed: !flagged};
}

/**
 * Indication for human review: explicit flag from provider, or any score at/above threshold.
 * When threshold is null/<=0, only `flagged` counts (score gate disabled).
 */
export function hasIndication(
  flagged: boolean,
  categoryScores: Record<string, number> | undefined,
  threshold: number | null | undefined
): boolean {
  if (flagged) return true;
  if (threshold == null || threshold <= 0 || !Number.isFinite(threshold)) {
    return false;
  }
  if (!categoryScores || Object.keys(categoryScores).length === 0) return false;
  const maxScore = Math.max(...Object.values(categoryScores));
  return maxScore >= threshold;
}
