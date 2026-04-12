import {getFirestore, FieldValue, Timestamp} from "firebase-admin/firestore";
import {HttpsError, onCall} from "firebase-functions/v2/https";
import {defineSecret} from "firebase-functions/params";
import * as logger from "firebase-functions/logger";
import {simpleHash} from "./delete_account";

const db = () => getFirestore();
const sendgridApiKey = defineSecret("SENDGRID_API_KEY");

/** Grace period in calendar days (corridos, not business days). */
const GRACE_PERIOD_DAYS = 15;

/** Maximum deletion requests per month (anti-abuse). */
const MAX_REQUESTS_PER_MONTH = 3;

/* ══════════════════════════════════════════════════════════════
 *  REQUEST ACCOUNT DELETION (Soft Delete)
 *
 *  Marks the account as `pending_deletion` with a 15-day grace
 *  period. The scheduled function `processScheduledDeletions`
 *  will execute the actual deletion after the period expires.
 *
 *  The user can still log in during this period but cannot send
 *  new letters or capsules.
 * ══════════════════════════════════════════════════════════════ */

export const requestAccountDeletion = onCall(
  {
    cors: true,
    secrets: [sendgridApiKey],
  },
  async (request) => {
    if (!request.auth?.uid) {
      throw new HttpsError("unauthenticated", "Sign in required");
    }
    const uid = request.auth.uid;
    const email = request.auth.token.email;
    const mode = request.data?.mode as string;

    if (mode !== "delete_all" && mode !== "anonymize") {
      throw new HttpsError("invalid-argument", "mode must be 'delete_all' or 'anonymize'");
    }

    const firestore = db();
    const userRef = firestore.collection("users").doc(uid);
    const userSnap = await userRef.get();

    if (!userSnap.exists) {
      throw new HttpsError("not-found", "User not found");
    }

    const userData = userSnap.data()!;

    // Check if already pending
    if (userData.accountStatus === "pending_deletion") {
      throw new HttpsError(
        "already-exists",
        "Account deletion already requested. Cancel first to make a new request."
      );
    }

    // Rate limit: max 3 requests per month
    const monthAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);
    const recentRequests = await firestore
      .collection("privacyRequestLogs")
      .where("uid", "==", simpleHash(uid))
      .where("type", "==", "deletion_request")
      .where("createdAt", ">=", Timestamp.fromDate(monthAgo))
      .get();

    if (recentRequests.size >= MAX_REQUESTS_PER_MONTH) {
      throw new HttpsError(
        "resource-exhausted",
        `Maximum ${MAX_REQUESTS_PER_MONTH} deletion requests per month exceeded.`
      );
    }

    // Calculate scheduled deletion date (15 calendar days)
    const now = new Date();
    const scheduledFor = new Date(now);
    scheduledFor.setDate(scheduledFor.getDate() + GRACE_PERIOD_DAYS);

    // Mark account as pending deletion
    await userRef.update({
      accountStatus: "pending_deletion",
      deletionRequestedAt: FieldValue.serverTimestamp(),
      deletionMode: mode,
      deletionScheduledFor: Timestamp.fromDate(scheduledFor),
    });

    // Log the request
    await firestore.collection("privacyRequestLogs").add({
      uid: simpleHash(uid),
      type: "deletion_request",
      status: "pending",
      metadata: {
        mode,
        gracePeriodDays: GRACE_PERIOD_DAYS,
        scheduledFor: scheduledFor.toISOString(),
      },
      createdAt: FieldValue.serverTimestamp(),
      source: "server",
    });

    // Send confirmation email (best-effort)
    if (email) {
      try {
        await sendDeletionConfirmationEmail({
          to: email,
          scheduledFor,
          mode,
          locale: userData.language ?? "pt-BR",
        });
      } catch (e) {
        logger.warn("requestAccountDeletion: confirmation email failed", e);
      }
    }

    logger.info(`requestAccountDeletion: uid=${uid} mode=${mode} scheduledFor=${scheduledFor.toISOString()}`);

    return {
      success: true,
      scheduledFor: scheduledFor.toISOString(),
      gracePeriodDays: GRACE_PERIOD_DAYS,
    };
  }
);

/* ══════════════════════════════════════════════════════════════
 *  CANCEL ACCOUNT DELETION
 *
 *  Reverts the account to `active` status, clearing all deletion
 *  fields. Can only be called while the grace period is active.
 * ══════════════════════════════════════════════════════════════ */

export const cancelAccountDeletion = onCall(
  {cors: true},
  async (request) => {
    if (!request.auth?.uid) {
      throw new HttpsError("unauthenticated", "Sign in required");
    }
    const uid = request.auth.uid;

    const firestore = db();
    const userRef = firestore.collection("users").doc(uid);
    const userSnap = await userRef.get();

    if (!userSnap.exists) {
      throw new HttpsError("not-found", "User not found");
    }

    const userData = userSnap.data()!;

    if (userData.accountStatus !== "pending_deletion") {
      throw new HttpsError(
        "failed-precondition",
        "Account is not pending deletion."
      );
    }

    // Revert to active
    await userRef.update({
      accountStatus: "active",
      deletionRequestedAt: FieldValue.delete(),
      deletionMode: FieldValue.delete(),
      deletionScheduledFor: FieldValue.delete(),
    });

    // Log cancellation
    await firestore.collection("privacyRequestLogs").add({
      uid: simpleHash(uid),
      type: "deletion_request",
      status: "cancelled",
      metadata: {
        cancelledAt: new Date().toISOString(),
      },
      createdAt: FieldValue.serverTimestamp(),
      source: "server",
    });

    logger.info(`cancelAccountDeletion: uid=${uid} reverted to active`);

    return {success: true};
  }
);

/* ══════════════════════════════════════════════════════════════
 *  EMAIL — Deletion Confirmation
 * ══════════════════════════════════════════════════════════════ */

interface DeletionEmailParams {
  to: string;
  scheduledFor: Date;
  mode: string;
  locale: string;
}

async function sendDeletionConfirmationEmail(params: DeletionEmailParams): Promise<void> {
  const key = sendgridApiKey.value();
  if (!key) {
    logger.warn("requestAccountDeletion: SENDGRID_API_KEY missing; skip email");
    return;
  }

  const fromEmail = process.env.SENDGRID_FROM_EMAIL || "noreply@openwhen.live";
  const fromName = process.env.SENDGRID_FROM_NAME || "OpenWhen";

  const isPt = params.locale.startsWith("pt");
  const isEs = params.locale.startsWith("es");

  const dateStr = params.scheduledFor.toLocaleDateString(
    isPt ? "pt-BR" : isEs ? "es" : "en",
    {year: "numeric", month: "long", day: "numeric"},
  );

  const modeLabel = params.mode === "delete_all"
    ? (isPt ? "Excluir tudo" : isEs ? "Eliminar todo" : "Delete all")
    : (isPt ? "Anonimizar" : isEs ? "Anonimizar" : "Anonymize");

  const subject = isPt
    ? "Confirmação de exclusão de conta — OpenWhen"
    : isEs
      ? "Confirmación de eliminación de cuenta — OpenWhen"
      : "Account deletion confirmation — OpenWhen";

  const html = buildDeletionEmailHtml({dateStr, modeLabel, isPt, isEs});
  const plainText = buildDeletionEmailPlainText({dateStr, modeLabel, isPt, isEs});

  const body = {
    personalizations: [{to: [{email: params.to}]}],
    from: {email: fromEmail, name: fromName},
    reply_to: {email: fromEmail, name: fromName},
    subject,
    content: [
      {type: "text/plain", value: plainText},
      {type: "text/html", value: html},
    ],
    headers: {
      "List-Unsubscribe": `<mailto:${fromEmail}?subject=unsubscribe>`,
    },
    mail_settings: {bypass_list_management: {enable: false}},
    tracking_settings: {
      click_tracking: {enable: true, enable_text: false},
      open_tracking: {enable: true},
    },
  };

  const res = await fetch("https://api.sendgrid.com/v3/mail/send", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${key}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify(body),
  });

  if (!res.ok) {
    const t = await res.text();
    throw new Error(`SendGrid ${res.status}: ${t}`);
  }
}

function buildDeletionEmailHtml(p: {
  dateStr: string;
  modeLabel: string;
  isPt: boolean;
  isEs: boolean;
}): string {
  const title = p.isPt
    ? "Exclusão de conta agendada"
    : p.isEs
      ? "Eliminación de cuenta programada"
      : "Account deletion scheduled";

  const body1 = p.isPt
    ? `Sua conta será excluída em <strong>${p.dateStr}</strong> no modo <strong>${p.modeLabel}</strong>.`
    : p.isEs
      ? `Tu cuenta será eliminada el <strong>${p.dateStr}</strong> en modo <strong>${p.modeLabel}</strong>.`
      : `Your account will be deleted on <strong>${p.dateStr}</strong> in <strong>${p.modeLabel}</strong> mode.`;

  const body2 = p.isPt
    ? "Se mudar de ideia, abra o app e cancele a exclusão antes desta data."
    : p.isEs
      ? "Si cambias de opinión, abre la app y cancela la eliminación antes de esa fecha."
      : "If you change your mind, open the app and cancel the deletion before this date.";

  const footer = p.isPt
    ? "Se não solicitou esta exclusão, entre no app imediatamente e cancele."
    : p.isEs
      ? "Si no solicitaste esta eliminación, entra a la app inmediatamente y cancela."
      : "If you did not request this deletion, open the app immediately and cancel.";

  return `
<!DOCTYPE html>
<html>
<head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"></head>
<body style="margin:0;padding:0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;background:#f5f5f5;">
  <table width="100%" cellpadding="0" cellspacing="0" style="max-width:560px;margin:40px auto;background:#fff;border-radius:12px;overflow:hidden;">
    <tr>
      <td style="padding:32px 28px 0;text-align:center;">
        <h1 style="font-size:22px;color:#1a1a1a;margin:0 0 16px;">${title}</h1>
      </td>
    </tr>
    <tr>
      <td style="padding:0 28px;">
        <p style="font-size:14px;color:#444;line-height:1.6;margin:0 0 12px;">${body1}</p>
        <p style="font-size:14px;color:#444;line-height:1.6;margin:0 0 24px;">${body2}</p>
      </td>
    </tr>
    <tr>
      <td style="padding:0 28px 28px;text-align:center;">
        <p style="font-size:12px;color:#dc2626;font-weight:600;margin:0;">${footer}</p>
      </td>
    </tr>
  </table>
</body>
</html>`.trim();
}

function buildDeletionEmailPlainText(p: {
  dateStr: string;
  modeLabel: string;
  isPt: boolean;
  isEs: boolean;
}): string {
  if (p.isPt) {
    return [
      "Exclusão de conta agendada — OpenWhen",
      `Sua conta será excluída em ${p.dateStr} (modo: ${p.modeLabel}).`,
      "Para cancelar, abra o app antes desta data.",
      "",
      "Se não solicitou, entre no app imediatamente e cancele.",
    ].join("\n");
  }
  if (p.isEs) {
    return [
      "Eliminación de cuenta programada — OpenWhen",
      `Tu cuenta será eliminada el ${p.dateStr} (modo: ${p.modeLabel}).`,
      "Para cancelar, abre la app antes de esa fecha.",
      "",
      "Si no solicitaste esto, entra a la app inmediatamente y cancela.",
    ].join("\n");
  }
  return [
    "Account deletion scheduled — OpenWhen",
    `Your account will be deleted on ${p.dateStr} (mode: ${p.modeLabel}).`,
    "To cancel, open the app before this date.",
    "",
    "If you did not request this, open the app immediately and cancel.",
  ].join("\n");
}
