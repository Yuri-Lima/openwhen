import {getFirestore, Timestamp} from "firebase-admin/firestore";
import {onSchedule} from "firebase-functions/v2/scheduler";
import * as logger from "firebase-functions/logger";

const db = () => getFirestore();

/* ══════════════════════════════════════════════════════════════
 *  PURGE OLD ACCESS LOGS — Marco Civil da Internet Art. 15
 *
 *  Runs daily at 05:30 UTC. Deletes access log documents older
 *  than 180 days (6 months).
 *
 *  Privacy policy commitment (Section 9 — Data Retention):
 *  "Access logs: retained for 6 months pursuant to Internet
 *   Civil Framework Article 15."
 *
 *  Uses batch deletes with a limit of 450 per batch to respect
 *  the Firestore 500-operation limit.
 * ══════════════════════════════════════════════════════════════ */

const RETENTION_DAYS = 180;
const BATCH_LIMIT = 450;

export const purgeOldAccessLogs = onSchedule(
  {
    schedule: "every day 05:30",
    timeZone: "UTC",
    timeoutSeconds: 300,
    retryCount: 1,
  },
  async () => {
    const firestore = db();
    const cutoff = Timestamp.fromDate(
      new Date(Date.now() - RETENTION_DAYS * 24 * 60 * 60 * 1000)
    );

    let totalDeleted = 0;
    let hasMore = true;

    while (hasMore) {
      const snap = await firestore
        .collection("accessLogs")
        .where("createdAt", "<", cutoff)
        .limit(BATCH_LIMIT)
        .get();

      if (snap.empty) {
        hasMore = false;
        break;
      }

      const batch = firestore.batch();
      snap.docs.forEach((doc) => batch.delete(doc.ref));
      await batch.commit();
      totalDeleted += snap.size;

      if (snap.size < BATCH_LIMIT) {
        hasMore = false;
      }
    }

    if (totalDeleted > 0) {
      logger.info(`purgeOldAccessLogs: deleted ${totalDeleted} documents older than ${RETENTION_DAYS} days`);
    } else {
      logger.info("purgeOldAccessLogs: no documents to purge");
    }
  }
);
