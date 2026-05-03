import {onCall, HttpsError} from "firebase-functions/v2/https";
import {getFirestore} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";

const db = () => getFirestore();

// ── Token generation (mirrors lib/core/user_search/user_search_tokens.dart) ──

const MAX_TOKENS = 30;
const MAX_TOKEN_LENGTH = 48;

function buildSearchTokens(
  username: string | undefined,
  displayName: string | undefined,
  name: string | undefined,
): string[] {
  const out = new Set<string>();

  function addWordTokens(raw?: string) {
    if (!raw || raw.trim().length === 0) return;
    const normalized = raw
      .toLowerCase()
      .replace(/@/g, " ")
      .replace(/\s+/g, " ")
      .trim();
    if (normalized.length === 0) return;

    for (const part of normalized.split(" ")) {
      const w = part.replace(/[^a-z0-9À-ɏ]/g, "");
      if (w.length < 2) continue;
      out.add(w);
      const maxPref = Math.min(w.length, 12);
      for (let len = 2; len < maxPref; len++) {
        out.add(w.substring(0, len));
      }
    }
  }

  addWordTokens(username);
  addWordTokens(displayName);
  if (name !== displayName) addWordTokens(name);

  const sorted = Array.from(out).sort();
  const capped: string[] = [];
  for (const t of sorted) {
    if (t.length > MAX_TOKEN_LENGTH) continue;
    capped.push(t);
    if (capped.length >= MAX_TOKENS) break;
  }
  return capped;
}

// ── Cloud Function ──

/**
 * Admin-only callable that backfills `searchTokens` for all users that
 * are missing this field (legacy accounts created before the search system).
 *
 * Call via Firebase Admin SDK or the Flutter app (requires admin custom claim).
 *
 * Returns: { updated: number, skipped: number, errors: number }
 */
export const backfillSearchTokens = onCall(
  {
    region: "us-central1",
    timeoutSeconds: 540,
    memory: "512MiB",
    enforceAppCheck: true,
  },
  async (request) => {
    // Admin-only guard
    if (!request.auth?.uid) {
      throw new HttpsError("unauthenticated", "Sign in required");
    }
    if (!request.auth.token.admin) {
      throw new HttpsError("permission-denied", "Admin only");
    }

    const PAGE_SIZE = 300;
    let lastDoc: FirebaseFirestore.DocumentSnapshot | undefined;
    let updated = 0;
    let skipped = 0;
    let errors = 0;

    // eslint-disable-next-line no-constant-condition
    while (true) {
      let query = db()
        .collection("users")
        .orderBy("createdAt")
        .limit(PAGE_SIZE);

      if (lastDoc) {
        query = query.startAfter(lastDoc);
      }

      const snap = await query.get();
      if (snap.empty) break;

      // Batch writes (max 500 per batch, we stay at PAGE_SIZE = 300)
      const batch = db().batch();
      let batchCount = 0;

      for (const doc of snap.docs) {
        const data = doc.data();

        // Skip users that already have searchTokens
        const existing = data.searchTokens as string[] | undefined;
        if (existing && Array.isArray(existing) && existing.length > 0) {
          skipped++;
          continue;
        }

        const username = (data.username as string) || "";
        const displayName = (data.displayName as string) || "";
        const name = (data.name as string) || "";

        // Skip if there's nothing to tokenize
        if (!username && !displayName && !name) {
          skipped++;
          continue;
        }

        try {
          const tokens = buildSearchTokens(username, displayName, name);
          if (tokens.length === 0) {
            skipped++;
            continue;
          }

          batch.update(doc.ref, {searchTokens: tokens});
          batchCount++;
          updated++;
        } catch (e) {
          errors++;
          logger.warn("backfill_search_tokens: error processing user", {
            uid: doc.id.substring(0, 6) + "...",
            err: String(e),
          });
        }
      }

      // Commit batch if there are writes
      if (batchCount > 0) {
        try {
          await batch.commit();
        } catch (e) {
          logger.error("backfill_search_tokens: batch commit failed", {
            err: String(e),
          });
          errors += batchCount;
          updated -= batchCount;
        }
      }

      lastDoc = snap.docs[snap.docs.length - 1];

      logger.info("backfill_search_tokens: page processed", {
        pageSize: snap.size,
        updatedSoFar: updated,
        skippedSoFar: skipped,
      });

      if (snap.size < PAGE_SIZE) break;
    }

    logger.info("backfill_search_tokens: completed", {
      updated,
      skipped,
      errors,
    });

    return {updated, skipped, errors};
  },
);
