/**
 * Map OpenAI moderation result to allow/block (single policy module).
 */
export function applyModerationPolicy(flagged: boolean): {allowed: boolean} {
  return {allowed: !flagged};
}
