/**
 * Resolve provider id from env. Default openai when MODERATION_PROVIDER unset.
 */
export function getModerationProviderId(): string {
  const p = process.env.MODERATION_PROVIDER?.trim().toLowerCase();
  if (p && p.length > 0) return p;
  return "openai";
}

export function getOpenAIApiKey(): string | undefined {
  const k = process.env.OPENAI_API_KEY?.trim();
  return k && k.length > 0 ? k : undefined;
}
