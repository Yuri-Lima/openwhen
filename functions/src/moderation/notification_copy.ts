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
