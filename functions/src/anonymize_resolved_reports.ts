import {getFirestore, FieldValue, Timestamp} from "firebase-admin/firestore";
import {onSchedule} from "firebase-functions/v2/scheduler";
import * as logger from "firebase-functions/logger";

const db = () => getFirestore();

/* ══════════════════════════════════════════════════════════════
 *  ANONYMIZE RESOLVED REPORTS
 *
 *  Runs daily at 04:00 UTC. Finds all content reports with
 *  status "resolved" or "dismissed" whose resolvedAt timestamp
 *  is older than 90 days, and strips PII fields while keeping
 *  anonymized metadata for moderation statistics.
 *
 *  Privacy policy commitment (Section 9 — Data Retention):
 *  "Content reports: anonymized 90 days after resolution."
 *
 *  Fields REMOVED:  reporterUid, detail, resolvedByUid
 *  Fields KEPT:     targetType, targetId, letterId, reason,
 *                   status, createdAt, resolvedAt
 *  Fields ADDED:    anonymizedAt (server timestamp)
 * ══════════════════════════════════════════════════════════════ */

/** Batch write limit for Firestore (max 500 operations per batch). */
const BATCH_LIMIT = 450;

/** 90 days in milliseconds. */
const NINETY_DAYS_MS = 90 * 24 * 60 * 60 * 1000;

export const anonymizeResolvedReports = onSchedule(
  {
    schedule: "every day 04:00",
    timeZone: "UTC",
    timeoutSeconds: 300, // 5 min — reports are lightweight
    retryCount: 1,
  },
  async () => {
    const firestore = db();
    const cutoff = Timestamp.fromMillis(Date.now() - NINETY_DAYS_MS);

    logger.info("anonymizeResolvedReports: starting daily run");

    // Process "resolved" and "dismissed" separately to use composite index
    let totalAnonymized = 0;

    for (const status of ["resolved", "dismissed"] as const) {
      const count = await anonymizeByStatus(firestore, status, cutoff);
      totalAnonymized += count;
    }

    logger.info(
      `anonymizeResolvedReports: finished — ${totalAnonymized} reports anonymized`
    );
  }
);

async function anonymizeByStatus(
  firestore: FirebaseFirestore.Firestore,
  status: string,
  cutoff: Timestamp
): Promise<number> {
  // Query: status matches, resolved before cutoff.
  // We filter out already-anonymized reports in-memory (by checking
  // for the presence of anonymizedAt) because Firestore does not
  // index missing fields — a "== null" filter would miss documents
  // that don't have the field at all (i.e., all existing reports).
  const query = firestore
    .collection("reports")
    .where("status", "==", status)
    .where("resolvedAt", "<=", cutoff);

  const snapshot = await query.get();

  if (snapshot.empty) {
    logger.info(`anonymizeResolvedReports: no ${status} reports eligible`);
    return 0;
  }

  // Filter out already-anonymized documents in memory
  const toAnonymize = snapshot.docs.filter((doc) => !doc.data().anonymizedAt);

  if (toAnonymize.length === 0) {
    logger.info(`anonymizeResolvedReports: no ${status} reports to anonymize`);
    return 0;
  }

  logger.info(
    `anonymizeResolvedReports: ${toAnonymize.length} of ${snapshot.size} ${status} reports need anonymization`
  );

  let batch = firestore.batch();
  let batchCount = 0;
  let total = 0;

  for (const doc of toAnonymize) {
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

  // Commit remaining
  if (batchCount > 0) {
    await batch.commit();
  }

  return total;
}
