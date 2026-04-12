import {getFirestore, Timestamp} from "firebase-admin/firestore";
import {onSchedule} from "firebase-functions/v2/scheduler";
import * as logger from "firebase-functions/logger";
import {executeAccountDeletion} from "./delete_account";
import type {DeletionMode} from "./delete_account";

const db = () => getFirestore();

/* ══════════════════════════════════════════════════════════════
 *  SCHEDULED DELETION PROCESSOR
 *
 *  Runs daily at 03:00 UTC (off-peak). Finds all users with
 *  accountStatus === 'pending_deletion' whose grace period
 *  has expired, and executes the actual account deletion.
 *
 *  Uses the same `executeAccountDeletion` function as the
 *  direct callable, ensuring identical behavior.
 * ══════════════════════════════════════════════════════════════ */

export const processScheduledDeletions = onSchedule(
  {
    schedule: "every day 03:00",
    timeZone: "UTC",
    timeoutSeconds: 540, // 9 min — may process multiple accounts
    retryCount: 1,
  },
  async () => {
    const firestore = db();
    const now = Timestamp.now();

    logger.info("processScheduledDeletions: starting daily run");

    // Find all users whose deletion grace period has expired
    const pendingUsers = await firestore
      .collection("users")
      .where("accountStatus", "==", "pending_deletion")
      .where("deletionScheduledFor", "<=", now)
      .get();

    if (pendingUsers.empty) {
      logger.info("processScheduledDeletions: no pending deletions found");
      return;
    }

    logger.info(`processScheduledDeletions: found ${pendingUsers.size} accounts to process`);

    let succeeded = 0;
    let failed = 0;

    for (const userDoc of pendingUsers.docs) {
      const uid = userDoc.id;
      const data = userDoc.data();
      const mode = (data.deletionMode as DeletionMode) || "delete_all";

      try {
        logger.info(`processScheduledDeletions: processing uid=${uid} mode=${mode}`);

        const result = await executeAccountDeletion(uid, mode, {
          // Auth user may already be inaccessible (account was disabled),
          // but we still try to delete it.
          deleteAuth: true,
        });

        logger.info(
          `processScheduledDeletions: completed uid=${uid}` +
          ` letters=${result.lettersProcessed}` +
          ` capsules=${result.capsulesProcessed}` +
          ` lockedPreserved=${result.lockedLettersPreserved}+${result.lockedCapsulesPreserved}`
        );
        succeeded++;
      } catch (e) {
        logger.error(`processScheduledDeletions: FAILED uid=${uid}`, e);
        failed++;

        // Mark the failure for admin review but don't block other deletions
        try {
          await firestore.collection("deletionAuditLogs").add({
            uidHash: uid.substring(0, 8) + "...",
            mode,
            status: "scheduled_failure",
            error: e instanceof Error ? e.message : String(e),
            attemptedAt: Timestamp.now(),
          });
        } catch {
          // Best-effort logging
        }
      }
    }

    logger.info(
      `processScheduledDeletions: finished — succeeded=${succeeded} failed=${failed}`
    );
  }
);
