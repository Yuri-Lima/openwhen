import {randomBytes} from "crypto";
import {FieldValue, getFirestore} from "firebase-admin/firestore";
import {getMessaging} from "firebase-admin/messaging";
import {HttpsError, onCall, onRequest} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import {openUrl} from "./config/app_urls";

/**
 * Generates a URL-safe share token (12 chars, ~72 bits of entropy).
 * Uses Node.js native crypto — no external dependency needed.
 */
function generateShareToken(): string {
  return randomBytes(9).toString("base64url"); // 9 bytes → 12 base64url chars
}

// ---------------------------------------------------------------------------
// generateShareLink — callable
// ---------------------------------------------------------------------------

/**
 * Generates a shareable link for a letter.
 * Idempotent: if the letter already has a shareToken, returns the existing URL.
 *
 * Input:  { letterId: string }
 * Output: { url: string, shareToken: string }
 */
export const generateShareLink = onCall(
  {region: "us-central1", cors: true},
  async (request) => {
    if (!request.auth?.uid) {
      throw new HttpsError("unauthenticated", "Sign in required");
    }
    const uid = request.auth.uid;

    const {letterId} = request.data as {letterId?: string};
    if (!letterId || typeof letterId !== "string") {
      throw new HttpsError("invalid-argument", "letterId required");
    }

    const db = getFirestore();
    const letterRef = db.doc(`letters/${letterId}`);
    const letterDoc = await letterRef.get();

    if (!letterDoc.exists) {
      throw new HttpsError("not-found", "Letter not found");
    }

    const data = letterDoc.data()!;
    if (data.senderUid !== uid) {
      throw new HttpsError("permission-denied", "Not the sender");
    }

    // Idempotent: return existing token if already generated
    if (data.shareToken && typeof data.shareToken === "string") {
      if (data.shareRevoked === true) {
        throw new HttpsError(
          "failed-precondition",
          "Link was revoked. Use revokeShareLink to generate a new one."
        );
      }
      return {
        url: openUrl(data.shareToken),
        shareToken: data.shareToken,
      };
    }

    // --- Dual limit: functional (active) + anti-abuse (total) ---
    // 1) Total limit (including revoked) — anti-abuse ceiling
    const totalCount = await db
      .collection("letters")
      .where("senderUid", "==", uid)
      .where("shareMode", "==", "link")
      .count()
      .get();

    if (totalCount.data().count >= 500) {
      throw new HttpsError(
        "resource-exhausted",
        "Lifetime share link limit reached. Contact support."
      );
    }

    // 2) Active limit (excluding revoked) — functional cap
    const activeCount = await db
      .collection("letters")
      .where("senderUid", "==", uid)
      .where("shareMode", "==", "link")
      .where("shareRevoked", "==", false)
      .count()
      .get();

    if (activeCount.data().count >= 100) {
      throw new HttpsError(
        "resource-exhausted",
        "Too many active share links. Revoke old links to create new ones."
      );
    }

    // Generate token with collision check (max 3 attempts)
    let token = "";
    for (let attempt = 0; attempt < 3; attempt++) {
      const candidate = generateShareToken();
      const collision = await db
        .collection("letters")
        .where("shareToken", "==", candidate)
        .limit(1)
        .get();
      if (collision.empty) {
        token = candidate;
        break;
      }
      logger.warn("share_token_collision", {attempt, letterId});
    }
    if (!token) {
      throw new HttpsError("internal", "Failed to generate unique token");
    }

    await letterRef.update({
      shareToken: token,
      shareMode: "link",
      shareCreatedAt: FieldValue.serverTimestamp(),
      shareRevoked: false,
    });

    logger.info("share_link_generated", {letterId, uid});
    return {
      url: openUrl(token),
      shareToken: token,
    };
  }
);

// ---------------------------------------------------------------------------
// getSharePreview — HTTP (public, no auth) with in-memory rate limiting
// ---------------------------------------------------------------------------

/** Simple in-memory rate limiter: max 60 requests per minute per IP. */
const rateLimitMap = new Map<string, {count: number; resetAt: number}>();
const RATE_LIMIT_WINDOW_MS = 60_000;
const RATE_LIMIT_MAX = 60;

function isRateLimited(ip: string): boolean {
  const now = Date.now();
  const entry = rateLimitMap.get(ip);
  if (!entry || now >= entry.resetAt) {
    rateLimitMap.set(ip, {count: 1, resetAt: now + RATE_LIMIT_WINDOW_MS});
    return false;
  }
  entry.count++;
  return entry.count > RATE_LIMIT_MAX;
}

/**
 * Returns a sanitised preview of a shared letter for the landing page.
 * NEVER returns the letter content (title, message, etc.).
 *
 * GET /getSharePreview?token={shareToken}
 */
export const getSharePreview = onRequest(
  {region: "us-central1", cors: true},
  async (req, res) => {
    if (req.method !== "GET") {
      res.status(405).json({error: "Method not allowed"});
      return;
    }

    // Rate limiting per IP
    const clientIp = req.ip || req.headers["x-forwarded-for"] as string || "unknown";
    if (isRateLimited(clientIp)) {
      res.status(429).json({error: "Too many requests. Try again later."});
      return;
    }

    const token = req.query.token as string | undefined;
    if (!token || typeof token !== "string" || token.length < 8 || token.length > 24) {
      res.status(400).json({error: "Invalid token"});
      return;
    }

    const db = getFirestore();
    const snap = await db
      .collection("letters")
      .where("shareToken", "==", token)
      .limit(1)
      .get();

    if (snap.empty) {
      res.status(404).json({error: "Not found"});
      return;
    }

    const data = snap.docs[0].data();

    if (data.shareRevoked === true) {
      res.status(410).json({error: "Link revoked"});
      return;
    }

    const isClaimed = !!(data.receiverUid && data.receiverUid !== "");
    const openDate = data.openDate?.toDate?.() ?? null;

    // Sanitised preview — no content leaked
    res.status(200).json({
      senderName: (data.senderName as string) || null,
      openDate: openDate ? openDate.toISOString() : null,
      emotionalState: (data.emotionalState as string) || null,
      isClaimed,
      status: data.status || "locked",
    });
  }
);

// ---------------------------------------------------------------------------
// claimShareLink — callable
// ---------------------------------------------------------------------------

/**
 * Claims a shared letter for the calling user.
 * The user becomes the receiver of the letter.
 *
 * Input:  { shareToken: string }
 * Output: { letterId: string, status: string }
 */
export const claimShareLink = onCall(
  {region: "us-central1", cors: true},
  async (request) => {
    if (!request.auth?.uid) {
      throw new HttpsError("unauthenticated", "Sign in required");
    }
    const uid = request.auth.uid;
    const token = request.auth.token;

    if (token.email_verified !== true) {
      throw new HttpsError("failed-precondition", "email_not_verified");
    }

    const {shareToken} = request.data as {shareToken?: string};
    if (!shareToken || typeof shareToken !== "string") {
      throw new HttpsError("invalid-argument", "shareToken required");
    }

    const db = getFirestore();

    // --- Find the letter by token (outside transaction — query not allowed inside) ---
    const snap = await db
      .collection("letters")
      .where("shareToken", "==", shareToken)
      .limit(1)
      .get();

    if (snap.empty) {
      throw new HttpsError("not-found", "Invalid or expired link");
    }

    const letterRef = snap.docs[0].ref;

    // --- Atomic claim inside a transaction to prevent race conditions ---
    const result = await db.runTransaction(async (tx) => {
      const letterSnap = await tx.get(letterRef);
      if (!letterSnap.exists) {
        throw new HttpsError("not-found", "Letter not found");
      }

      const data = letterSnap.data()!;

      if (data.shareRevoked === true) {
        throw new HttpsError("failed-precondition", "This link has been revoked");
      }

      if (data.senderUid === uid) {
        throw new HttpsError("invalid-argument", "You cannot claim your own letter");
      }

      if (data.receiverUid && data.receiverUid !== "") {
        if (data.receiverUid === uid) {
          return {letterId: letterRef.id, status: "already_yours" as const, senderUid: data.senderUid};
        }
        throw new HttpsError(
          "failed-precondition",
          "This letter has already been claimed by someone else"
        );
      }

      tx.update(letterRef, {
        receiverUid: uid,
        receiverHasAccount: true,
        shareClaimedAt: FieldValue.serverTimestamp(),
        shareClaimedBy: uid,
        requestStatus: "accepted",
      });

      return {letterId: letterRef.id, status: "claimed" as const, senderUid: data.senderUid};
    });

    // --- Notifications (outside transaction — best-effort, never blocks claim) ---
    if (result.status === "claimed") {
      try {
        const senderDoc = await db.doc(`users/${result.senderUid}`).get();
        const senderData = senderDoc.data();
        const fcmToken = senderData?.fcmToken as string | undefined;

        if (fcmToken) {
          await getMessaging().send({
            token: fcmToken,
            notification: {
              title: "Your letter was received! 🦉",
              body: "Someone claimed your shared letter on Whenote.",
            },
            data: {
              type: "share_claimed",
              letterId: result.letterId,
            },
          });
        }

        await db.collection(`users/${result.senderUid}/notifications`).add({
          type: "share_claimed",
          letterId: result.letterId,
          title: "Your letter was received! 🦉",
          body: "Someone claimed your shared letter on Whenote.",
          read: false,
          createdAt: FieldValue.serverTimestamp(),
        });
      } catch (e) {
        logger.warn("share_claim_notification_failed", {
          letterId: result.letterId,
          err: String(e),
        });
      }
    }

    logger.info("share_link_claimed", {letterId: result.letterId, claimedBy: uid});
    return {letterId: result.letterId, status: result.status};
  }
);

// ---------------------------------------------------------------------------
// revokeShareLink — callable
// ---------------------------------------------------------------------------

/**
 * Revokes a share link so it can no longer be claimed.
 * Optionally generates a new token (if regenerate: true).
 *
 * Input:  { letterId: string, regenerate?: boolean }
 * Output: { revoked: true, newUrl?: string }
 */
export const revokeShareLink = onCall(
  {region: "us-central1", cors: true},
  async (request) => {
    if (!request.auth?.uid) {
      throw new HttpsError("unauthenticated", "Sign in required");
    }
    const uid = request.auth.uid;

    const {letterId, regenerate} = request.data as {
      letterId?: string;
      regenerate?: boolean;
    };
    if (!letterId || typeof letterId !== "string") {
      throw new HttpsError("invalid-argument", "letterId required");
    }

    const db = getFirestore();
    const letterRef = db.doc(`letters/${letterId}`);
    const letterDoc = await letterRef.get();

    if (!letterDoc.exists) {
      throw new HttpsError("not-found", "Letter not found");
    }

    const data = letterDoc.data()!;
    if (data.senderUid !== uid) {
      throw new HttpsError("permission-denied", "Not the sender");
    }

    // Cannot revoke if already claimed
    if (data.receiverUid && data.receiverUid !== "") {
      throw new HttpsError(
        "failed-precondition",
        "Cannot revoke — letter already claimed"
      );
    }

    if (regenerate) {
      let newToken = "";
      for (let attempt = 0; attempt < 3; attempt++) {
        const candidate = generateShareToken();
        const collision = await db
          .collection("letters")
          .where("shareToken", "==", candidate)
          .limit(1)
          .get();
        if (collision.empty) {
          newToken = candidate;
          break;
        }
      }
      if (!newToken) {
        throw new HttpsError("internal", "Failed to generate unique token");
      }
      await letterRef.update({
        shareToken: newToken,
        shareRevoked: false,
        shareCreatedAt: FieldValue.serverTimestamp(),
      });
      logger.info("share_link_regenerated", {letterId, uid});
      return {
        revoked: true,
        newUrl: openUrl(newToken),
      };
    }

    await letterRef.update({
      shareRevoked: true,
    });

    logger.info("share_link_revoked", {letterId, uid});
    return {revoked: true};
  }
);
