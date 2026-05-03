import {getFirestore, Timestamp} from "firebase-admin/firestore";
import {onSchedule} from "firebase-functions/v2/scheduler";
import * as logger from "firebase-functions/logger";

const db = () => getFirestore();

/* ══════════════════════════════════════════════════════════════
 *  PURGE OLD MODERATION LOGS
 *
 *  Runs daily at 04:30 UTC. Deletes documents from
 *  `moderationIncidents` and `moderationReviews` whose
 *  `createdAt` is older than 2 years.
 *
 *  Privacy policy commitment (Section 9 — Data Retention):
 *  "Moderation logs: 2 years"
 *
 *  These collections may contain PII:
 *   - moderationIncidents: callerUid, message
 *   - moderationReviews: authorUid, authorDisplayName, text,
 *                        resolvedByUid, adminFeedback
 *
 *  Documents are fully deleted (not anonymized) because the
 *  policy says "retained for 2 years" — after that period
 *  they must not exist at all.
 * ══════════════════════════════════════════════════════════════ */

/** Batch write limit for Firestore (max 500 operations per batch). */
const BATCH_LIMIT = 450;

/** 2 years in milliseconds (730 days). */
const TWO_YEARS_MS = 730 * 24 * 60 * 60 * 1000;

/** Collections to purge. */
const COLLECTIONS = ["moderationIncidents", "moderationReviews"] as const;

export const purgeOldModerationLogs = onSchedule(
  {
    schedule: "every day 04:30",
    timeZone: "UTC",
    timeoutSeconds: 300,
    retryCount: 1,
  },
  async () => {
    const firestore = db();
    const cutoff = Timestamp.fromMillis(Date.now() - TWO_YEARS_MS);

    logger.info("purgeOldModerationLogs: starting daily run");

    let grandTotal = 0;

    for (const collection of COLLECTIONS) {
      const count = await purgeCollection(firestore, collection, cutoff);
      grandTotal += count;
    }

    logger.info(
      `purgeOldModerationLogs: finished — ${grandTotal} documents deleted`
    );
  }
);

async function purgeCollection(
  firestore: FirebaseFirestore.Firestore,
  collectionName: string,
  cutoff: Timestamp
): Promise<number> {
  let total = 0;

  // Paginate with limit to avoid loading too many docs in memory
  // eslint-disable-next-line no-constant-condition
  while (true) {
    // select() with no fields: fetches only doc refs, no field data.
    // Minimises bandwidth — we only need the reference to delete.
    const snapshot = await firestore
      .collection(collectionName)
      .where("createdAt", "<", cutoff)
      .select()
      .limit(BATCH_LIMIT)
      .get();

    if (snapshot.empty) break;

    const batch = firestore.batch();
    for (const doc of snapshot.docs) {
      batch.delete(doc.ref);
    }
    await batch.commit();

    total += snapshot.size;
    logger.info(
      `purgeOldModerationLogs: deleted ${snapshot.size} from ${collectionName} (total so far: ${total})`
    );

    // If we got fewer than the limit, we're done
    if (snapshot.size < BATCH_LIMIT) break;
  }

  if (total === 0) {
    logger.info(`purgeOldModerationLogs: no expired docs in ${collectionName}`);
  }

  return total;
}
