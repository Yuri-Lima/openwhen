import {beforeUserCreated, HttpsError} from "firebase-functions/v2/identity";
import {FieldValue, getFirestore} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";

const db = () => getFirestore();

/* ══════════════════════════════════════════════════════════════
 *  ACCOUNT CREATION AUDIT & ANTI-ABUSE
 *
 *  Blocking Cloud Function that runs BEFORE a new Firebase Auth
 *  user is fully created. It:
 *
 *  1. Logs every account creation to `accountCreationLogs`
 *     (IP, provider, timestamp — server-side, tamper-proof).
 *
 *  2. Detects suspicious patterns:
 *     - More than MAX_ACCOUNTS_PER_IP accounts from the same IP
 *       within WINDOW_HOURS → blocks creation.
 *
 *  3. Blocks disposable email domains (configurable deny list).
 *
 *  Using `beforeUserCreated` (blocking trigger) so we can REJECT
 *  the account creation if abuse is detected.
 * ══════════════════════════════════════════════════════════════ */

const MAX_ACCOUNTS_PER_IP = 5;
const WINDOW_HOURS = 24;

/** Common disposable email domains. Extend as needed. */
const DISPOSABLE_EMAIL_DOMAINS = new Set([
  "guerrillamail.com",
  "guerrillamail.info",
  "guerrillamail.net",
  "guerrillamail.org",
  "grr.la",
  "tempmail.com",
  "temp-mail.org",
  "throwaway.email",
  "mailinator.com",
  "maildrop.cc",
  "yopmail.com",
  "yopmail.fr",
  "sharklasers.com",
  "guerrillamailblock.com",
  "dispostable.com",
  "trashmail.com",
  "trashmail.net",
  "trashmail.me",
  "fakeinbox.com",
  "mailnesia.com",
  "tempail.com",
  "10minutemail.com",
  "10minutemail.net",
  "minutemail.com",
  "getnada.com",
  "mohmal.com",
  "emailondeck.com",
  "tempr.email",
  "discard.email",
  "mailsac.com",
]);

export const onUserCreated = beforeUserCreated(
  {region: "us-central1"},
  async (event) => {
    const user = event.data;
    const ip =
      event.ipAddress || "unknown";
    const email = user.email || "";
    const provider =
      event.additionalUserInfo?.providerId || "unknown";

    // ── 1. Block disposable emails ──
    if (email) {
      const domain = email.split("@")[1]?.toLowerCase();
      if (domain && DISPOSABLE_EMAIL_DOMAINS.has(domain)) {
        logger.warn("Blocked disposable email registration", {
          email: email.substring(0, 3) + "***",
          domain,
          ip,
        });
        throw new HttpsError(
          "permission-denied",
          "Registration with disposable email addresses is not allowed."
        );
      }
    }

    // ── 2. IP-based rate limiting ──
    if (ip !== "unknown") {
      const windowStart = new Date();
      windowStart.setHours(windowStart.getHours() - WINDOW_HOURS);

      try {
        const recentSnap = await db()
          .collection("accountCreationLogs")
          .where("ip", "==", ip)
          .where("createdAt", ">=", windowStart)
          .limit(MAX_ACCOUNTS_PER_IP)
          .get();

        if (recentSnap.size >= MAX_ACCOUNTS_PER_IP) {
          logger.warn("Blocked IP with too many account creations", {
            ip,
            count: recentSnap.size,
            window: `${WINDOW_HOURS}h`,
          });
          throw new HttpsError(
            "resource-exhausted",
            "Too many accounts created from this network. Please try again later."
          );
        }
      } catch (e) {
        // If rate-check fails (Firestore transient error), allow the
        // creation — best-effort anti-abuse, don't block legit users.
        if (e instanceof HttpsError) {
          throw e; // re-throw our own rate-limit / permission error
        }
        logger.error("Rate-check query failed (allowing creation)", e);
      }
    }

    // ── 3. Log the creation (always, even if checks passed) ──
    try {
      await db().collection("accountCreationLogs").add({
        ip,
        provider,
        emailDomain: email ? email.split("@")[1]?.toLowerCase() || "" : "",
        createdAt: FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Best-effort logging — don't block account creation if log fails.
      logger.error("Failed to write accountCreationLog", e);
    }

    // Return nothing = allow creation
    return;
  }
);
