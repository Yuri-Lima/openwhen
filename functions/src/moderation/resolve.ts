import * as logger from "firebase-functions/logger";

import {getOpenAIApiKey, getModerationProviderId} from "./factory";
import {
  ModerationProviderError,
  moderateWithOpenAI,
} from "./openai_adapter";
import {applyModerationPolicy} from "./policy";
import {recordModerationIncident} from "./incidents";
import type {
  IncidentKind,
  ModerationRequest,
  ModerationResponse,
  SystemModerationConfig,
} from "./types";

export interface ResolveContext {
  failClosed: boolean;
  callerUid?: string;
}

/**
 * Runs OpenAI moderation when configured; on failure records an incident and applies fallback policy.
 */
export async function resolveModeration(
  req: ModerationRequest,
  config: SystemModerationConfig,
  ctx: ResolveContext
): Promise<ModerationResponse> {
  if (!config.aiModerationEnabled) {
    return {
      allowed: true,
      source: "skipped",
      reason: "ai_moderation_disabled",
    };
  }

  const providerId = getModerationProviderId();
  const apiKey = getOpenAIApiKey();

  if (providerId !== "openai") {
    await recordModerationIncident({
      kind: "adapter_unavailable",
      message: `Provider "${providerId}" is not implemented yet`,
      providerId,
      callerUid: ctx.callerUid,
    });
    return buildFallbackResponse(ctx.failClosed, "provider_unavailable");
  }

  if (!apiKey) {
    await recordModerationIncident({
      kind: "config_missing",
      message: "OPENAI_API_KEY is not set",
      providerId: "openai",
      callerUid: ctx.callerUid,
    });
    logger.warn("moderation: OPENAI_API_KEY missing");
    return buildFallbackResponse(ctx.failClosed, "provider_unavailable");
  }

  try {
    const raw = await moderateWithOpenAI(apiKey, req.text);
    const {allowed} = applyModerationPolicy(raw.flagged);
    return {
      allowed,
      source: "provider",
      providerId: "openai",
      flagged: raw.flagged,
      categories: raw.categories,
      categoryScores: raw.categoryScores,
    };
  } catch (e) {
    const isProv = e instanceof ModerationProviderError;
    const kind: IncidentKind = isProv ? e.kind : "provider_error";

    await recordModerationIncident({
      kind,
      message: e instanceof Error ? e.message : String(e),
      providerId: "openai",
      httpStatus: isProv ? e.httpStatus : undefined,
      callerUid: ctx.callerUid,
    });
    logger.error("moderation: provider error", {
      kind,
      message: e instanceof Error ? e.message : String(e),
    });

    return buildFallbackResponse(ctx.failClosed, "provider_unavailable");
  }
}

function buildFallbackResponse(
  failClosed: boolean,
  _reason: string
): ModerationResponse {
  if (failClosed) {
    return {
      allowed: false,
      source: "fallback",
      reason: "moderation_unavailable",
      providerId: "openai",
    };
  }
  return {
    allowed: true,
    source: "fallback",
    reason: "provider_unavailable",
    providerId: "openai",
  };
}
