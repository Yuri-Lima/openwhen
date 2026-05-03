import {getFirestore, FieldValue} from "firebase-admin/firestore";
import {onCall} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import {hashUid} from "./delete_account";

const db = () => getFirestore();

/* ══════════════════════════════════════════════════════════════
 *  LOG ACCESS — Marco Civil da Internet Art. 15
 *
 *  Callable Cloud Function invoked by the client after each
 *  successful authentication (email, Google, Apple).
 *
 *  Captures:
 *   - Hashed UID (HMAC-SHA-256, no raw PII)
 *   - IP address (from rawRequest — server-side, reliable)
 *   - Platform (ios / android / web)
 *   - Auth method (email / google / apple)
 *   - Timestamp (server)
 *
 *  Retention: 6 months (180 days), enforced by
 *  purgeOldAccessLogs scheduled function.
 *
 *  Collection: accessLogs (read/write false in Firestore rules —
 *  only Admin SDK / Cloud Functions can access).
 * ══════════════════════════════════════════════════════════════ */

export const logAccess = onCall(
  {cors: true, enforceAppCheck: true},
  async (request) => {
    const uid = request.auth?.uid;
    if (!uid) {
      // Not authenticated — silently ignore (best-effort).
      return {ok: false, reason: "unauthenticated"};
    }

    const platform = (request.data?.platform as string) || "unknown";
    const authMethod = (request.data?.authMethod as string) || "unknown";

    // Extract IP from the raw HTTP request (works in Cloud Functions v2).
    const ip =
      request.rawRequest?.headers?.["x-forwarded-for"]?.toString().split(",")[0]?.trim() ||
      request.rawRequest?.ip ||
      "unknown";

    try {
      await db().collection("accessLogs").add({
        uidHash: hashUid(uid),
        ip,
        platform: sanitize(platform, 32),
        authMethod: sanitize(authMethod, 32),
        createdAt: FieldValue.serverTimestamp(),
      });
      return {ok: true};
    } catch (e) {
      logger.error("logAccess: failed (best-effort)", e);
      return {ok: false, reason: "internal"};
    }
  }
);

/** Truncate and strip non-alphanumeric chars (defence-in-depth). */
function sanitize(value: string, maxLen: number): string {
  return value.replace(/[^a-zA-Z0-9_-]/g, "").substring(0, maxLen);
}
