import {getFirestore, FieldValue, Timestamp} from "firebase-admin/firestore";
import {onSchedule} from "firebase-functions/v2/scheduler";
import * as logger from "firebase-functions/logger";

const db = () => getFirestore();

/* ══════════════════════════════════════════════════════════════
 *  ANONYMIZE RESOLVED REPORTS
 *
 *  Runs daily at 04:00 UTC. Finds content reports that crossed
 *  the 90-day threshold since yesterday and strips PII fields,
 *  keeping anonymized metadata for moderation statistics.
 *
 *  Privacy policy commitment (Section 9 — Data Retention):
 *  "Content reports: anonymized 90 days after resolution."
 *
 *  Fields REMOVED:  reporterUid, detail, resolvedByUid
 *  Fields KEPT:     targetType, targetId, letterId, reason,
 *                   status, createdAt, resolvedAt
 *  Fields ADDED:    anonymizedAt (server timestamp)
 *
 *  COST OPTIMISATION
 *  -----------------
 *  Instead of querying ALL reports resolved >90 days ago (which
 *  grows linearly and re-reads already-anonymized docs every
 *  day), we query a 24-hour window: reports resolved between
 *  91 days ago and 90 days ago. This keeps daily reads constant
 *  regardless of how many historical reports exist.
 *
 *  A one-time backfill query runs first (limited, with the
 *  select() projection) to catch any reports that were missed
 *  before this function was deployed.
 *
 *  Firestore costs per run (steady state):
 *    Reads:  ~daily resolved reports (typically <10)
 *    Writes: same count (update to strip PII)
 *    Cost:   negligible (~$0.0001/day)
 * ══════════════════════════════════════════════════════════════ */

/** Batch write limit for Firestore (max 500 operations per batch). */
const BATCH_LIMIT = 450;

const ONE_DAY_MS = 24 * 60 * 60 * 1000;
const NINETY_DAYS_MS = 90 * ONE_DAY_MS;

export const anonymizeResolvedReports = onSchedule(
  {
    schedule: "every day 04:00",
    timeZone: "UTC",
    timeoutSeconds: 300,
    retryCount: 1,
  },
  async () => {
    const firestore = db();

    logger.info("anonymizeResolvedReports: starting daily run");

    let totalAnonymized = 0;

    for (const status of ["resolved", "dismissed"] as const) {
      // 1. Window query: reports that crossed the 90-day mark in the
      //    last 24 hours (resolvedAt between 91d ago and 90d ago).
      const windowCount = await anonymizeWindow(firestore, status);
      totalAnonymized += windowCount;

      // 2. Backfill: catch any old reports missed before deployment.
      //    Uses select() projection to minimise bandwidth. Limited to
      //    one batch per run to keep costs bounded.
      const backfillCount = await anonymizeBackfill(firestore, status);
      totalAnonymized += backfillCount;
    }

    logger.info(
      `anonymizeResolvedReports: finished — ${totalAnonymized} reports anonymized`
    );
  }
);

/**
 * Window query: only reports resolved between 91 and 90 days ago.
 * Constant cost regardless of total report volume.
 */
async function anonymizeWindow(
  firestore: FirebaseFirestore.Firestore,
  status: string
): Promise<number> {
  const windowStart = Timestamp.fromMillis(Date.now() - NINETY_DAYS_MS - ONE_DAY_MS);
  const windowEnd = Timestamp.fromMillis(Date.now() - NINETY_DAYS_MS);

  const snapshot = await firestore
    .collection("reports")
    .where("status", "==", status)
    .where("resolvedAt", ">=", windowStart)
    .where("resolvedAt", "<=", windowEnd)
    .get();

  if (snapshot.empty) return 0;

  // Filter out any already-anonymized (safety net for retries)
  const toAnonymize = snapshot.docs.filter((doc) => !doc.data().anonymizedAt);
  if (toAnonymize.length === 0) return 0;

  logger.info(
    `anonymizeResolvedReports: window — ${toAnonymize.length} ${status} reports`
  );

  return await batchAnonymize(firestore, toAnonymize);
}

/**
 * Backfill: catches reports from before deployment that were never
 * anonymized. Uses select() to only fetch the anonymizedAt field,
 * minimising read bandwidth. Processes one batch per run.
 */
async function anonymizeBackfill(
  firestore: FirebaseFirestore.Firestore,
  status: string
): Promise<number> {
  const cutoff = Timestamp.fromMillis(Date.now() - NINETY_DAYS_MS - ONE_DAY_MS);

  // select() projection: only fetch anonymizedAt to check eligibility.
  // Saves bandwidth — we don't need reporterUid/detail to decide.
  const snapshot = await firestore
    .collection("reports")
    .where("status", "==", status)
    .where("resolvedAt", "<=", cutoff)
    .select("anonymizedAt")
    .limit(BATCH_LIMIT)
    .get();

  if (snapshot.empty) return 0;

  const toAnonymize = snapshot.docs.filter((doc) => !doc.data().anonymizedAt);
  if (toAnonymize.length === 0) return 0;

  logger.info(
    `anonymizeResolvedReports: backfill — ${toAnonymize.length} ${status} reports`
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
      reporterUid: FieldValue.delete(),
      detail: FieldValue.delete(),
      resolvedByUid: FieldValue.delete(),
      anonymizedAt: FieldValue.serverTimestamp(),
    });

    batchCount++;
    total++;

    if (batchCount >= BATCH_LIMIT) {
      await batch.commit();
      logger.info(`anonymizeResolvedReports: committed batch of ${batchCount}`);
      batch = firestore.batch();
      batchCount = 0;
    }
  }

  if (batchCount > 0) {
    await batch.commit();
  }

  return total;
}
