import {getFirestore, FieldValue, Timestamp} from "firebase-admin/firestore";
import {onSchedule} from "firebase-functions/v2/scheduler";
import * as logger from "firebase-functions/logger";

const db = () => getFirestore();

/* ══════════════════════════════════════════════════════════════
 *  ANONYMIZE OLD FEEDBACK
 *
 *  Runs daily at 05:00 UTC. Finds product feedback documents
 *  older than 1 year and strips PII fields, keeping anonymized
 *  metadata for product improvement statistics.
 *
 *  Privacy policy commitment (Section 9 — Data Retention):
 *  "Product feedback: anonymized after 1 year."
 *
 *  Fields REMOVED:  uid, message
 *  Fields KEPT:     type, createdAt, appLocale, platform
 *  Fields ADDED:    anonymizedAt (server timestamp)
 *
 *  COST OPTIMISATION
 *  -----------------
 *  Same window query pattern as anonymizeResolvedReports:
 *  - Window query: feedback created between 366 and 365 days
 *    ago. Constant daily reads regardless of total volume.
 *  - Backfill query: limited batch with select() projection
 *    to catch feedback submitted before this function was
 *    deployed.
 *
 *  Firestore costs per run (steady state):
 *    Reads:  ~daily feedback docs (typically <5)
 *    Writes: same count (update to strip PII)
 *    Cost:   negligible (~$0.0001/day)
 * ══════════════════════════════════════════════════════════════ */

/** Batch write limit for Firestore (max 500 operations per batch). */
const BATCH_LIMIT = 450;

const ONE_DAY_MS = 24 * 60 * 60 * 1000;
const ONE_YEAR_MS = 365 * ONE_DAY_MS;

export const anonymizeOldFeedback = onSchedule(
  {
    schedule: "every day 05:00",
    timeZone: "UTC",
    timeoutSeconds: 300,
    retryCount: 1,
  },
  async () => {
    const firestore = db();

    logger.info("anonymizeOldFeedback: starting daily run");

    let totalAnonymized = 0;

    // 1. Window query: feedback that crossed the 1-year mark in
    //    the last 24 hours (createdAt between 366d ago and 365d ago).
    const windowCount = await anonymizeWindow(firestore);
    totalAnonymized += windowCount;

    // 2. Backfill: catch old feedback missed before deployment.
    //    Uses select() projection to minimise bandwidth. Limited to
    //    one batch per run to keep costs bounded.
    const backfillCount = await anonymizeBackfill(firestore);
    totalAnonymized += backfillCount;

    logger.info(
      `anonymizeOldFeedback: finished — ${totalAnonymized} feedback docs anonymized`
    );
  }
);

/**
 * Window query: only feedback created between 366 and 365 days ago.
 * Constant cost regardless of total feedback volume.
 */
async function anonymizeWindow(
  firestore: FirebaseFirestore.Firestore
): Promise<number> {
  const windowStart = Timestamp.fromMillis(Date.now() - ONE_YEAR_MS - ONE_DAY_MS);
  const windowEnd = Timestamp.fromMillis(Date.now() - ONE_YEAR_MS);

  const snapshot = await firestore
    .collection("feedback")
    .where("createdAt", ">=", windowStart)
    .where("createdAt", "<=", windowEnd)
    .get();

  if (snapshot.empty) return 0;

  // Filter out any already-anonymized (safety net for retries)
  const toAnonymize = snapshot.docs.filter((doc) => !doc.data().anonymizedAt);
  if (toAnonymize.length === 0) return 0;

  logger.info(
    `anonymizeOldFeedback: window — ${toAnonymize.length} feedback docs`
  );

  return await batchAnonymize(firestore, toAnonymize);
}

/**
 * Backfill: catches feedback from before deployment that was never
 * anonymized. Uses select() to only fetch the anonymizedAt field,
 * minimising read bandwidth. Processes one batch per run.
 */
async function anonymizeBackfill(
  firestore: FirebaseFirestore.Firestore
): Promise<number> {
  const cutoff = Timestamp.fromMillis(Date.now() - ONE_YEAR_MS - ONE_DAY_MS);

  // select() projection: only fetch anonymizedAt to check eligibility.
  const snapshot = await firestore
    .collection("feedback")
    .where("createdAt", "<=", cutoff)
    .select("anonymizedAt")
    .limit(BATCH_LIMIT)
    .get();

  if (snapshot.empty) return 0;

  const toAnonymize = snapshot.docs.filter((doc) => !doc.data().anonymizedAt);
  if (toAnonymize.length === 0) return 0;

  logger.info(
    `anonymizeOldFeedback: backfill — ${toAnonymize.length} feedback docs`
  );

  return await batchAnonymize(firestore, toAnonymize);
}

async function batchAnonymize(
  firestore: FirebaseFirestore.Firestore,
  docs: FirebaseFirestore.QueryDocumentSnapshot[]
): Promise<number> {
  let batch = firestore.batch();
  let batchCount = 0;
  let total = 0;

  for (const doc of docs) {
    batch.update(doc.ref, {
      uid: FieldValue.delete(),
      message: FieldValue.delete(),
      anonymizedAt: FieldValue.serverTimestamp(),
    });

    batchCount++;
    total++;

    if (batchCount >= BATCH_LIMIT) {
      await batch.commit();
      logger.info(`anonymizeOldFeedback: committed batch of ${batchCount}`);
      batch = firestore.batch();
      batchCount = 0;
    }
  }

  if (batchCount > 0) {
    await batch.commit();
  }

  return total;
}
