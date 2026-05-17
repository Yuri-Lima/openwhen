/**
 * Server-side localised copy for engagement push notifications.
 *
 * Each function returns `{ title, body }` ready for FCM payload.
 * Locale defaults to "en" when not supplied.
 */

// ─── Helpers ────────────────────────────────────────────────────────

function pickLocale(locale: string | undefined): string {
  if (!locale || typeof locale !== "string") return "en";
  const lower = locale.toLowerCase();
  if (lower.startsWith("pt")) return "pt";
  if (lower.startsWith("es")) return "es";
  return "en";
}

type Copy = Record<string, { title: string; body: string }>;

// ─── Like ───────────────────────────────────────────────────────────

function likeCopy(name: string): Copy {
  return {
    en: {
      title: `${name} liked your letter`,
      body: "Open the app to see who's connecting with your words.",
    },
    pt: {
      title: `${name} curtiu a sua carta`,
      body: "Abra o app para ver quem se conectou com as suas palavras.",
    },
    es: {
      title: `A ${name} le gustó tu carta`,
      body: "Abre la app para ver quién conecta con tus palabras.",
    },
  };
}

export function copyLike(
  actorName: string,
  locale: string | undefined
): { title: string; body: string } {
  const k = pickLocale(locale);
  const map = likeCopy(actorName);
  return map[k] ?? map.en;
}

// ─── Comment ────────────────────────────────────────────────────────

function commentCopy(name: string): Copy {
  return {
    en: {
      title: `${name} commented on your letter`,
      body: "See what they had to say.",
    },
    pt: {
      title: `${name} comentou na sua carta`,
      body: "Veja o que escreveram.",
    },
    es: {
      title: `${name} comentó en tu carta`,
      body: "Mira lo que escribieron.",
    },
  };
}

export function copyComment(
  actorName: string,
  locale: string | undefined
): { title: string; body: string } {
  const k = pickLocale(locale);
  const map = commentCopy(actorName);
  return map[k] ?? map.en;
}

// ─── Follow ─────────────────────────────────────────────────────────

function followCopy(name: string): Copy {
  return {
    en: {
      title: `${name} started following you`,
      body: "You have a new connection on Whenote.",
    },
    pt: {
      title: `${name} começou a seguir você`,
      body: "Você tem uma nova conexão no Whenote.",
    },
    es: {
      title: `${name} empezó a seguirte`,
      body: "Tienes una nueva conexión en Whenote.",
    },
  };
}

export function copyFollow(
  actorName: string,
  locale: string | undefined
): { title: string; body: string } {
  const k = pickLocale(locale);
  const map = followCopy(actorName);
  return map[k] ?? map.en;
}
