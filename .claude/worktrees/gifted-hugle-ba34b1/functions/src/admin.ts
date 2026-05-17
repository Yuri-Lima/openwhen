import {getAuth} from "firebase-admin/auth";
import {FieldValue, getFirestore} from "firebase-admin/firestore";
import {HttpsError, onCall} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";

import {MODERATION_INCIDENTS_COLLECTION} from "./moderation/incidents";
import {getModerationProviderId, getOpenAIApiKey} from "./moderation/factory";

function firestore() {
  return getFirestore();
}

function assertAdmin(token: Record<string, unknown> | undefined): void {
  if (token?.admin !== true) {
    throw new HttpsError("permission-denied", "admin_required");
  }
}

/**
 * First-time admin: caller must be signed in and pass the same secret as
 * `ADMIN_BOOTSTRAP_SECRET` in the Functions runtime env. Sets `admin: true` on
 * the caller's custom claims. Rotate or remove the secret after provisioning.
 */
export const bootstrapAdminClaim = onCall(
  {
    cors: true,
    enforceAppCheck: true,
  },
  async (request) => {
    const secret = process.env.ADMIN_BOOTSTRAP_SECRET;
    if (!secret || secret.length === 0) {
      throw new HttpsError(
        "failed-precondition",
        "bootstrap_not_configured"
      );
    }
    if (!request.auth?.uid) {
      throw new HttpsError("unauthenticated", "Sign in required");
    }
    const bodySecret = request.data?.secret as string | undefined;
    if (!bodySecret || bodySecret !== secret) {
      throw new HttpsError("permission-denied", "invalid_secret");
    }
    const uid = request.auth.uid;
    await getAuth().setCustomUserClaims(uid, {admin: true});
    logger.info("bootstrapAdminClaim: granted", {uid});
    return {ok: true};
  }
);

export const adminListPendingReports = onCall(
  {
    cors: true,
    enforceAppCheck: true,
  },
  async (request) => {
    if (!request.auth?.uid) {
      throw new HttpsError("unauthenticated", "Sign in required");
    }
    assertAdmin(request.auth.token as Record<string, unknown>);

    const limit = Math.min(Number(request.data?.limit) || 50, 100);
    const snap = await firestore()
      .collection("reports")
      .where("status", "==", "pending")
      .orderBy("createdAt", "desc")
      .limit(limit)
      .get();

    return {
      reports: snap.docs.map((d) => {
        const data = d.data();
        return {id: d.id, ...data};
      }),
    };
  }
);

export const adminResolveReport = onCall(
  {
    cors: true,
    enforceAppCheck: true,
  },
  async (request) => {
    if (!request.auth?.uid) {
      throw new HttpsError("unauthenticated", "Sign in required");
    }
    assertAdmin(request.auth.token as Record<string, unknown>);

    const reportId = request.data?.reportId as string | undefined;
    const resolution = request.data?.resolution as string | undefined;
    if (!reportId || !resolution) {
      throw new HttpsError(
        "invalid-argument",
        "reportId and resolution required"
      );
    }
    if (resolution !== "dismissed" && resolution !== "resolved") {
      throw new HttpsError("invalid-argument", "invalid resolution");
    }

    await firestore().collection("reports").doc(reportId).update({
      status: resolution,
      resolvedAt: FieldValue.serverTimestamp(),
      resolvedByUid: request.auth.uid,
    });
    return {ok: true};
  }
);

export const adminListRecentFeedback = onCall(
  {
    cors: true,
    enforceAppCheck: true,
  },
  async (request) => {
    if (!request.auth?.uid) {
      throw new HttpsError("unauthenticated", "Sign in required");
    }
    assertAdmin(request.auth.token as Record<string, unknown>);

    const limit = Math.min(Number(request.data?.limit) || 50, 100);
    const snap = await firestore()
      .collection("feedback")
      .orderBy("createdAt", "desc")
      .limit(limit)
      .get();

    return {
      items: snap.docs.map((d) => {
        const data = d.data();
        return {id: d.id, ...data};
      }),
    };
  }
);

/**
 * Safe ops info for admins: configured provider id and whether credentials exist
 * (no secrets returned).
 */
export const adminGetModerationInfo = onCall(
  {
    cors: true,
    enforceAppCheck: true,
  },
  async (request) => {
    if (!request.auth?.uid) {
      throw new HttpsError("unauthenticated", "Sign in required");
    }
    assertAdmin(request.auth.token as Record<string, unknown>);

    const providerId = getModerationProviderId();
    let credentialsConfigured = false;
    if (providerId === "openai") {
      credentialsConfigured = !!getOpenAIApiKey();
    }

    return {
      providerId,
      credentialsConfigured,
    };
  }
);

export const adminListModerationIncidents = onCall(
  {
    cors: true,
    enforceAppCheck: true,
  },
  async (request) => {
    if (!request.auth?.uid) {
      throw new HttpsError("unauthenticated", "Sign in required");
    }
    assertAdmin(request.auth.token as Record<string, unknown>);

    const limit = Math.min(Number(request.data?.limit) || 50, 100);
    const snap = await firestore()
      .collection(MODERATION_INCIDENTS_COLLECTION)
      .orderBy("lastOccurredAt", "desc")
      .limit(limit)
      .get();

    return {
      items: snap.docs.map((d) => {
        const data = d.data();
        return {id: d.id, ...data};
      }),
    };
  }
);
