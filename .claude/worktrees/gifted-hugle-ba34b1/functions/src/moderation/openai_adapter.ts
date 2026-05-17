import type {IncidentKind} from "./types";

const MODERATIONS_URL = "https://api.openai.com/v1/moderations";

export class ModerationProviderError extends Error {
  constructor(
    public readonly kind: IncidentKind,
    message: string,
    public readonly httpStatus?: number
  ) {
    super(message);
    this.name = "ModerationProviderError";
  }
}

export interface OpenAIModerationResult {
  flagged: boolean;
  categories: Record<string, boolean>;
  categoryScores: Record<string, number>;
}

/**
 * Calls OpenAI Moderation API. Throws ModerationProviderError on HTTP/network failure.
 */
export async function moderateWithOpenAI(
  apiKey: string,
  text: string
): Promise<OpenAIModerationResult> {
  let res: Response;
  try {
    res = await fetch(MODERATIONS_URL, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${apiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({input: text}),
    });
  } catch (e) {
    throw new ModerationProviderError(
      "provider_error",
      `OpenAI request failed: ${e instanceof Error ? e.message : String(e)}`
    );
  }

  if (res.status === 401) {
    throw new ModerationProviderError(
      "auth_invalid",
      "OpenAI returned 401",
      401
    );
  }
  if (res.status === 429) {
    throw new ModerationProviderError(
      "rate_limited",
      "OpenAI returned 429",
      429
    );
  }
  if (!res.ok) {
    throw new ModerationProviderError(
      "provider_error",
      `OpenAI returned ${res.status}`,
      res.status
    );
  }

  let json: {
    results?: Array<{
      flagged?: boolean;
      categories?: Record<string, boolean>;
      category_scores?: Record<string, number>;
    }>;
  };
  try {
    json = (await res.json()) as typeof json;
  } catch (e) {
    throw new ModerationProviderError(
      "provider_error",
      "Invalid JSON from OpenAI"
    );
  }

  const first = json.results?.[0];
  if (!first) {
    throw new ModerationProviderError(
      "provider_error",
      "Empty results from OpenAI"
    );
  }

  const rawScores = first.category_scores ?? {};
  const categoryScores: Record<string, number> = {};
  for (const [k, v] of Object.entries(rawScores)) {
    if (typeof v === "number" && Number.isFinite(v)) {
      categoryScores[k] = v;
    }
  }

  return {
    flagged: first.flagged === true,
    categories: first.categories ?? {},
    categoryScores,
  };
}

/**
 * Calls OpenAI Moderation API with omni-moderation-latest for image analysis.
 * Accepts a publicly accessible URL (e.g. Firebase Storage signed URL).
 * Returns the same shape as text moderation for uniform downstream handling.
 */
export async function moderateImageWithOpenAI(
  apiKey: string,
  imageUrl: string
): Promise<OpenAIModerationResult> {
  let res: Response;
  try {
    res = await fetch(MODERATIONS_URL, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${apiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "omni-moderation-latest",
        input: [
          {
            type: "image_url",
            image_url: {url: imageUrl},
          },
        ],
      }),
    });
  } catch (e) {
    throw new ModerationProviderError(
      "provider_error",
      `OpenAI image moderation request failed: ${e instanceof Error ? e.message : String(e)}`
    );
  }

  if (res.status === 401) {
    throw new ModerationProviderError(
      "auth_invalid",
      "OpenAI returned 401 (image moderation)",
      401
    );
  }
  if (res.status === 429) {
    throw new ModerationProviderError(
      "rate_limited",
      "OpenAI returned 429 (image moderation)",
      429
    );
  }
  if (!res.ok) {
    throw new ModerationProviderError(
      "provider_error",
      `OpenAI returned ${res.status} (image moderation)`,
      res.status
    );
  }

  let json: {
    results?: Array<{
      flagged?: boolean;
      categories?: Record<string, boolean>;
      category_scores?: Record<string, number>;
    }>;
  };
  try {
    json = (await res.json()) as typeof json;
  } catch (e) {
    throw new ModerationProviderError(
      "provider_error",
      "Invalid JSON from OpenAI (image moderation)"
    );
  }

  const first = json.results?.[0];
  if (!first) {
    throw new ModerationProviderError(
      "provider_error",
      "Empty results from OpenAI (image moderation)"
    );
  }

  const rawScores = first.category_scores ?? {};
  const categoryScores: Record<string, number> = {};
  for (const [k, v] of Object.entries(rawScores)) {
    if (typeof v === "number" && Number.isFinite(v)) {
      categoryScores[k] = v;
    }
  }

  return {
    flagged: first.flagged === true,
    categories: first.categories ?? {},
    categoryScores,
  };
}

/**
 * Transcribes audio using OpenAI Whisper API.
 * Returns plain text transcription for subsequent text moderation.
 */
export async function transcribeAudioWithWhisper(
  apiKey: string,
  audioBuffer: Buffer,
  fileName: string
): Promise<string> {
  const formData = new FormData();
  formData.append("file", new Blob([audioBuffer as unknown as BlobPart]), fileName);
  formData.append("model", "whisper-1");
  formData.append("response_format", "text");

  let res: Response;
  try {
    res = await fetch("https://api.openai.com/v1/audio/transcriptions", {
      method: "POST",
      headers: {Authorization: `Bearer ${apiKey}`},
      body: formData,
    });
  } catch (e) {
    throw new ModerationProviderError(
      "provider_error",
      `Whisper transcription request failed: ${e instanceof Error ? e.message : String(e)}`
    );
  }

  if (res.status === 401) {
    throw new ModerationProviderError("auth_invalid", "OpenAI Whisper returned 401", 401);
  }
  if (res.status === 429) {
    throw new ModerationProviderError("rate_limited", "OpenAI Whisper returned 429", 429);
  }
  if (!res.ok) {
    throw new ModerationProviderError(
      "provider_error",
      `OpenAI Whisper returned ${res.status}`,
      res.status
    );
  }

  return res.text();
}
