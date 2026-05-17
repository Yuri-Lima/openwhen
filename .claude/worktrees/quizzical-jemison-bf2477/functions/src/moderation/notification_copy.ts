/**
 * User-facing copy for moderation inbox (server defaults; client may localize by type later).
 */
const PENDING: Record<string, {title: string; body: string}> = {
  en: {
    title: "Comment under review",
    body: "Your comment was sent for review. You will be notified when it is approved or rejected.",
  },
  pt: {
    title: "Comentário em análise",
    body: "O seu comentário foi enviado para revisão. Será notificado quando for aprovado ou rejeitado.",
  },
  es: {
    title: "Comentario en revisión",
    body: "Tu comentario fue enviado a revisión. Te avisaremos cuando sea aprobado o rechazado.",
  },
};

const APPROVED: Record<string, {title: string; body: string}> = {
  en: {
    title: "Comment published",
    body: "Your comment was approved and is now visible.",
  },
  pt: {
    title: "Comentário publicado",
    body: "O seu comentário foi aprovado e já está visível.",
  },
  es: {
    title: "Comentario publicado",
    body: "Tu comentario fue aprobado y ya es visible.",
  },
};

function pickLocale(locale: string | undefined): string {
  if (!locale || typeof locale !== "string") return "en";
  const lower = locale.toLowerCase();
  if (lower.startsWith("pt")) return "pt";
  if (lower.startsWith("es")) return "es";
  return "en";
}

export function copyPendingReview(locale: string | undefined): {
  title: string;
  body: string;
} {
  const k = pickLocale(locale);
  return PENDING[k] ?? PENDING.en;
}

export function copyApproved(locale: string | undefined): {
  title: string;
  body: string;
} {
  const k = pickLocale(locale);
  return APPROVED[k] ?? APPROVED.en;
}

// ─── Media removal copy (image / audio moderation) ──────────────────

const MEDIA_REMOVED_IMAGE: Record<string, {title: string; body: string}> = {
  en: {
    title: "Image removed",
    body: "An image you uploaded was removed for not meeting Whenote's guidelines.",
  },
  pt: {
    title: "Imagem removida",
    body: "Uma imagem que você enviou foi removida por não atender às diretrizes do Whenote.",
  },
  es: {
    title: "Imagen eliminada",
    body: "Una imagen que subiste fue eliminada por no cumplir con las directrices de Whenote.",
  },
};

const MEDIA_REMOVED_AUDIO: Record<string, {title: string; body: string}> = {
  en: {
    title: "Audio removed",
    body: "An audio recording you uploaded was removed for not meeting Whenote's guidelines.",
  },
  pt: {
    title: "Áudio removido",
    body: "Um áudio que você enviou foi removido por não atender às diretrizes do Whenote.",
  },
  es: {
    title: "Audio eliminado",
    body: "Un audio que subiste fue eliminado por no cumplir con las directrices de Whenote.",
  },
};

/**
 * Server-side copy for media removal notifications.
 * `mediaType` is "image" or "audio".
 * Locale defaults to "en" when not supplied.
 */
export function copyMediaRemoved(
  mediaType: "image" | "audio",
  locale?: string | undefined
): {title: string; body: string} {
  const k = pickLocale(locale);
  const map = mediaType === "image" ? MEDIA_REMOVED_IMAGE : MEDIA_REMOVED_AUDIO;
  return map[k] ?? map.en;
}
