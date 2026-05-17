import {HttpsError, onCall} from "firebase-functions/v2/https";
import {getFirestore} from "firebase-admin/firestore";

/* ══════════════════════════════════════════════════════════════
 *  In-memory rate limiter (per Cloud Function instance).
 *
 *  Limits each IP to MAX_REQUESTS_PER_WINDOW calls within
 *  WINDOW_MS. Entries are lazily cleaned up on each check.
 *  Resets naturally when the instance is recycled.
 * ══════════════════════════════════════════════════════════════ */

const MAX_REQUESTS_PER_WINDOW = 30; // generous for legit registration flow
const WINDOW_MS = 60_000; // 1 minute

const ipHits = new Map<string, number[]>();

function isRateLimited(ip: string): boolean {
  const now = Date.now();
  const windowStart = now - WINDOW_MS;

  let hits = ipHits.get(ip) ?? [];
  // Prune old entries
  hits = hits.filter((t) => t > windowStart);

  if (hits.length >= MAX_REQUESTS_PER_WINDOW) {
    ipHits.set(ip, hits);
    return true;
  }

  hits.push(now);
  ipHits.set(ip, hits);

  // Lazy cleanup: remove stale IPs (avoid unbounded memory growth)
  if (ipHits.size > 1500) {
    for (const [key, timestamps] of ipHits) {
      const fresh = timestamps.filter((t) => t > windowStart);
      if (fresh.length === 0) ipHits.delete(key);
      else ipHits.set(key, fresh);
    }
  }

  return false;
}

function extractIp(request: {rawRequest?: {headers?: Record<string, unknown>; ip?: string}}): string {
  // Prefer rawRequest.ip (set by Cloud Functions infrastructure, reliable)
  // over x-forwarded-for (can be spoofed by client).
  if (request.rawRequest?.ip) return request.rawRequest.ip;
  const forwarded = request.rawRequest?.headers?.["x-forwarded-for"];
  if (typeof forwarded === "string") {
    return forwarded.split(",")[0]?.trim() || "unknown";
  }
  return "unknown";
}

/**
 * Checks whether a username is available.
 *
 * Protected by App Check (requires valid device attestation) and
 * in-memory rate limiting per IP (30 req/min).
 *
 * Does **not** require authentication so it can be invoked
 * from the registration screen before the user has an account.
 */
export const checkUsernameAvailable = onCall(
  {cors: true, enforceAppCheck: true},
  async (request) => {
    // ── Rate limiting ──
    const ip = extractIp(request as never);
    if (isRateLimited(ip)) {
      throw new HttpsError(
        "resource-exhausted",
        "too_many_requests"
      );
    }

    const raw = request.data?.username;
    if (typeof raw !== "string" || raw.trim().length === 0) {
      throw new HttpsError("invalid-argument", "username is required");
    }

    const username = raw.trim().toLowerCase().replace(/@/g, "").replace(/ /g, "");

    // Format validation
    if (username.length < 3) {
      throw new HttpsError("invalid-argument", "username_too_short");
    }
    if (username.length > 20) {
      throw new HttpsError("invalid-argument", "username_too_long");
    }
    if (!/^[a-z0-9._]+$/.test(username)) {
      throw new HttpsError("invalid-argument", "username_invalid_chars");
    }
    if (/^[._]/.test(username) || /[._]$/.test(username)) {
      throw new HttpsError("invalid-argument", "username_invalid_edges");
    }
    if (/\.\./.test(username)) {
      throw new HttpsError("invalid-argument", "username_consecutive_dots");
    }

    const db = getFirestore();

    // Verificar ambas as fontes de verdade:
    // 1. Collection `usernames` (reserva atómica — source of truth)
    // 2. Collection `users` (fallback para users criados antes do backfill)
    const [reservationSnap, usersSnap] = await Promise.all([
      db.collection("usernames").doc(username).get(),
      db.collection("users")
        .where("username", "==", username)
        .limit(1)
        .get(),
    ]);

    const available = !reservationSnap.exists && usersSnap.empty;
    return {available};
  }
);
