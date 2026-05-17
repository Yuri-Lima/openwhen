import {HttpsError, onCall} from "firebase-functions/v2/https";
import {getFirestore} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";

/**
 * Backfill da collection `usernames` a partir dos `users` existentes.
 *
 * Apenas admin (custom claim `admin: true`) pode executar.
 * Idempotente: se o doc `usernames/{username}` já existir com o mesmo uid,
 * é ignorado; se existir com uid diferente (colisão), é logado e ignorado.
 *
 * Uso: chamar uma vez após o deploy das novas rules.
 */
export const backfillUsernames = onCall(
  {cors: true, enforceAppCheck: false, timeoutSeconds: 540},
  async (request) => {
    // Só admin pode executar
    if (!request.auth?.token?.admin) {
      throw new HttpsError(
        "permission-denied",
        "Admin only"
      );
    }

    const db = getFirestore();
    const usersRef = db.collection("users");
    const usernamesRef = db.collection("usernames");

    let processed = 0;
    let created = 0;
    let skipped = 0;
    let conflicts = 0;
    const conflictList: Array<{username: string; existingUid: string; userUid: string}> = [];

    const PAGE_SIZE = 300;
    let lastDoc: FirebaseFirestore.QueryDocumentSnapshot | undefined;

    // eslint-disable-next-line no-constant-condition
    while (true) {
      let query = usersRef
        .orderBy("__name__")
        .limit(PAGE_SIZE);

      if (lastDoc) {
        query = query.startAfter(lastDoc);
      }

      const snap = await query.get();
      if (snap.empty) break;

      let batch = db.batch();
      let batchSize = 0;

      for (const doc of snap.docs) {
        processed++;
        const data = doc.data();
        const username = data.username as string | undefined;

        if (!username || typeof username !== "string" || username.trim().length === 0) {
          skipped++;
          continue;
        }

        const normalizedUsername = username.trim().toLowerCase();
        const existingReservation = await usernamesRef.doc(normalizedUsername).get();

        if (existingReservation.exists) {
          const existingUid = existingReservation.data()?.uid;
          if (existingUid === doc.id) {
            // Já backfilled — ignorar
            skipped++;
          } else {
            // Colisão: dois users com o mesmo username
            conflicts++;
            conflictList.push({
              username: normalizedUsername,
              existingUid: existingUid || "unknown",
              userUid: doc.id,
            });
            logger.warn("Username collision during backfill", {
              username: normalizedUsername,
              existingUid,
              newUid: doc.id,
            });
          }
          continue;
        }

        batch.set(usernamesRef.doc(normalizedUsername), {uid: doc.id});
        batchSize++;
        created++;

        // Firestore batch limit: 500 writes.
        // A committed batch cannot be reused — create a fresh one.
        if (batchSize >= 450) {
          await batch.commit();
          batch = db.batch();
          batchSize = 0;
        }
      }

      if (batchSize > 0) {
        await batch.commit();
      }

      lastDoc = snap.docs[snap.docs.length - 1];

      if (snap.size < PAGE_SIZE) break;
    }

    const summary = {
      processed,
      created,
      skipped,
      conflicts,
      conflictList: conflictList.slice(0, 50), // Limitar output
    };

    logger.info("backfillUsernames completed", summary);
    return summary;
  }
);
