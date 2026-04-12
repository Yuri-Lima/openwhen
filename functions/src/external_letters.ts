import {FieldValue, getFirestore} from "firebase-admin/firestore";
import {HttpsError, onCall} from "firebase-functions/v2/https";
import {onDocumentCreated} from "firebase-functions/v2/firestore";
import {defineSecret} from "firebase-functions/params";
import * as logger from "firebase-functions/logger";

const sendgridApiKey = defineSecret("SENDGRID_API_KEY");

/** Must match Dart [normalizeReceiverEmailForMatching]. */
export function normalizeReceiverEmailForMatching(email: string): string {
  return email.trim().toLowerCase();
}

function escapeHtml(s: string): string {
  return s
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

async function sendSendgridInvite(params: {
  to: string;
  subject: string;
  html: string;
  customArgs?: Record<string, string>;
}): Promise<void> {
  const key = sendgridApiKey.value();
  if (!key) {
    logger.warn("external_invite_email: SENDGRID_API_KEY missing; skip send");
    return;
  }
  const fromEmail =
    process.env.SENDGRID_FROM_EMAIL || "noreply@openwhen.live";
  const fromName = process.env.SENDGRID_FROM_NAME || "OpenWhen";
  const body = {
    personalizations: [{
      to: [{email: params.to}],
      ...(params.customArgs ? {custom_args: params.customArgs} : {}),
    }],
    from: {email: fromEmail, name: fromName},
    subject: params.subject,
    content: [{type: "text/html", value: params.html}],
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

/**
 * Attaches letters sent to the caller's verified email (no account at send time)
 * to the caller's uid. Idempotent.
 */
export const claimExternalLetters = onCall(
  {region: "us-central1", cors: true},
  async (request) => {
    if (!request.auth?.uid) {
      throw new HttpsError("unauthenticated", "Sign in required");
    }
    const uid = request.auth.uid;
    const token = request.auth.token;
    const email = token.email;
    if (!email || typeof email !== "string") {
      throw new HttpsError("failed-precondition", "email_required");
    }
    if (token.email_verified !== true) {
      throw new HttpsError("failed-precondition", "email_not_verified");
    }
    const normalized = normalizeReceiverEmailForMatching(email);

    const db = getFirestore();
    const snap = await db
      .collection("letters")
      .where("receiverHasAccount", "==", false)
      .where("receiverEmailNormalized", "==", normalized)
      .where("receiverUid", "==", "")
      .get();

    const docsToUpdate = snap.docs.filter((d) => {
      const s = d.data().senderUid;
      return s !== uid;
    });

    let claimed = 0;
    let batch = db.batch();
    let n = 0;
    for (const doc of docsToUpdate) {
      batch.update(doc.ref, {
        receiverUid: uid,
        requestStatus: "accepted",
        claimedAt: FieldValue.serverTimestamp(),
      });
      claimed++;
      n++;
      if (n >= 450) {
        await batch.commit();
        batch = db.batch();
        n = 0;
      }
    }
    if (n > 0) {
      await batch.commit();
    }

    logger.info("claimExternalLetters_done", {uid, claimed});
    return {claimed};
  }
);

export const onLetterCreatedSendExternalInviteEmail = onDocumentCreated(
  {
    document: "letters/{letterId}",
    region: "us-central1",
    secrets: [sendgridApiKey],
  },
  async (event) => {
    const snap = event.data;
    if (!snap) return;
    const data = snap.data();
    if (!data) return;
    if (data.receiverHasAccount === true) return;
    const to = data.receiverEmail as string | undefined;
    if (!to || typeof to !== "string") return;

    const letterId = event.params.letterId as string;
    const senderUid = data.senderUid as string;
    const title = (data.title as string) || "OpenWhen";
    const senderName = (data.senderName as string) || "Someone";
    const link = `https://openwhen.live/letter/${letterId}`;
    const subject = `${senderName} sent you a letter on OpenWhen`;
    const html = `
<p>Hi,</p>
<p><strong>${escapeHtml(senderName)}</strong> sent you a letter titled
<strong>${escapeHtml(title)}</strong> on OpenWhen.</p>
<p><a href="${link}">Open the app</a> — sign in with this email address to view it when it unlocks.</p>
<p style="color:#666;font-size:12px;">If you did not expect this message, you can ignore it.</p>
`.trim();

    try {
      await sendSendgridInvite({
        to: to.trim(),
        subject,
        html,
        customArgs: {letterId, senderUid},
      });
      await snap.ref.update({
        inviteEmailSentAt: FieldValue.serverTimestamp(),
        inviteEmailStatus: "sent",
      });
      logger.info("external_invite_email_sent", {letterId});
    } catch (e) {
      await snap.ref.update({
        inviteEmailStatus: "send_failed",
      });
      logger.error("external_invite_email_failed", {letterId, err: String(e)});
    }
  }
);

export const resendExternalInviteEmail = onCall(
  {region: "us-central1", cors: true, secrets: [sendgridApiKey]},
  async (request) => {
    if (!request.auth?.uid) {
      throw new HttpsError("unauthenticated", "Sign in required");
    }
    const {letterId, newEmail} = request.data as {letterId: string; newEmail?: string};
    if (!letterId || typeof letterId !== "string") {
      throw new HttpsError("invalid-argument", "letterId required");
    }

    const db = getFirestore();
    const letterRef = db.doc(`letters/${letterId}`);
    const letterDoc = await letterRef.get();
    if (!letterDoc.exists) {
      throw new HttpsError("not-found", "Letter not found");
    }

    const data = letterDoc.data()!;
    if (data.senderUid !== request.auth.uid) {
      throw new HttpsError("permission-denied", "Not the sender");
    }

    const lastResend = data.lastResendAt?.toDate() as Date | undefined;
    if (lastResend && Date.now() - lastResend.getTime() < 5 * 60 * 1000) {
      throw new HttpsError("resource-exhausted", "Please wait before resending");
    }

    const email = newEmail?.trim() || data.receiverEmail;
    if (!email || typeof email !== "string") {
      throw new HttpsError("invalid-argument", "No email");
    }

    const senderName = (data.senderName as string) || "Someone";
    const title = (data.title as string) || "OpenWhen";
    const link = `https://openwhen.live/letter/${letterId}`;
    const subject = `${senderName} sent you a letter on OpenWhen`;
    const html = `
<p>Hi,</p>
<p><strong>${escapeHtml(senderName)}</strong> sent you a letter titled
<strong>${escapeHtml(title)}</strong> on OpenWhen.</p>
<p><a href="${link}">Open the app</a> — sign in with this email address to view it when it unlocks.</p>
<p style="color:#666;font-size:12px;">If you did not expect this message, you can ignore it.</p>
`.trim();

    try {
      await sendSendgridInvite({
        to: email,
        subject,
        html,
        customArgs: {letterId, senderUid: request.auth.uid},
      });
      await letterRef.update({
        receiverEmail: email,
        receiverEmailNormalized: normalizeReceiverEmailForMatching(email),
        inviteEmailStatus: "sent",
        inviteEmailSentAt: FieldValue.serverTimestamp(),
        lastResendAt: FieldValue.serverTimestamp(),
      });
      logger.info("resend_external_invite_sent", {letterId});
      return {success: true};
    } catch (e) {
      logger.error("resend_external_invite_failed", {letterId, err: String(e)});
      throw new HttpsError("internal", "Failed to send email");
    }
  }
);
