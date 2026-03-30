import {FieldValue, Firestore, getFirestore} from "firebase-admin/firestore";

import type {IncidentKind, IncidentSeverity} from "./types";

export const MODERATION_INCIDENTS_COLLECTION = "moderationIncidents";

/** UTC hour bucket for deduplication (yyyyMMddHH). */
export function hourBucketUtc(d: Date): string {
  const y = d.getUTCFullYear();
  const m = String(d.getUTCMonth() + 1).padStart(2, "0");
  const day = String(d.getUTCDate()).padStart(2, "0");
  const h = String(d.getUTCHours()).padStart(2, "0");
  return `${y}${m}${day}${h}`;
}

function severityForKind(kind: IncidentKind): IncidentSeverity {
  if (kind === "config_missing" || kind === "auth_invalid") {
    return "critical";
  }
  return "warning";
}

export interface RecordIncidentInput {
  kind: IncidentKind;
  message: string;
  providerId?: string;
  httpStatus?: number;
  callerUid?: string;
}

/**
 * Aggregates incidents per kind + UTC hour to avoid spamming Firestore during outages.
 */
export async function recordModerationIncident(
  input: RecordIncidentInput,
  db: Firestore = getFirestore()
): Promise<void> {
  const bucket = hourBucketUtc(new Date());
  const dedupeKey = `${input.kind}_${bucket}`;
  const docId = `inc_${dedupeKey}`;
  const ref = db.collection(MODERATION_INCIDENTS_COLLECTION).doc(docId);
  const severity = severityForKind(input.kind);

  await db.runTransaction(async (t) => {
    const snap = await t.get(ref);
    if (!snap.exists) {
      t.set(ref, {
        kind: input.kind,
        severity,
        message: input.message,
        providerId: input.providerId ?? null,
        httpStatus: input.httpStatus ?? null,
        callerUid: input.callerUid ?? null,
        dedupeKey,
        count: 1,
        createdAt: FieldValue.serverTimestamp(),
        lastOccurredAt: FieldValue.serverTimestamp(),
      });
    } else {
      t.update(ref, {
        message: input.message,
        lastOccurredAt: FieldValue.serverTimestamp(),
        count: FieldValue.increment(1),
        ...(input.httpStatus != null ? {httpStatus: input.httpStatus} : {}),
      });
    }
  });
}
