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

function buildInviteHtml(p: {
  senderName: string; title: string; link: string;
}): string {
  const s = escapeHtml(p.senderName);
  const t = escapeHtml(p.title);
  return `<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>${s} sent you a letter on Whenote</title>
  <!--[if mso]>
  <noscript><xml>
    <o:OfficeDocumentSettings>
      <o:PixelsPerInch>96</o:PixelsPerInch>
    </o:OfficeDocumentSettings>
  </xml></noscript>
  <![endif]-->
  <style>
    body, table, td, a { -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; }
    table, td { mso-table-lspace: 0pt; mso-table-rspace: 0pt; }
    img { -ms-interpolation-mode: bicubic; border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; }
    body { margin: 0; padding: 0; width: 100% !important; background-color: #0D0B09; }
    @media (prefers-color-scheme: dark) {
      .email-bg { background-color: #0D0B09 !important; }
    }
    @media only screen and (max-width: 600px) {
      .container { width: 100% !important; padding: 16px !important; }
      .card { padding: 28px 20px !important; }
      .btn-td { padding: 14px 28px !important; }
    }
  </style>
</head>
<body style="margin:0;padding:0;background-color:#0D0B09;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;">

  <div style="display:none;font-size:1px;color:#0D0B09;line-height:1px;max-height:0;max-width:0;opacity:0;overflow:hidden;">
    ${s} wrote you a letter titled &ldquo;${t}&rdquo; on Whenote. Sign in to read it when it unlocks.
  </div>

  <table role="presentation" cellpadding="0" cellspacing="0" width="100%" style="background-color:#0D0B09;" class="email-bg">
    <tr>
      <td align="center" style="padding:40px 16px;">
        <table role="presentation" cellpadding="0" cellspacing="0" width="480" class="container" style="max-width:480px;width:100%;">

          <!-- Logo -->
          <tr>
            <td align="center" style="padding-bottom:32px;">
              <table role="presentation" cellpadding="0" cellspacing="0">
                <tr>
                  <td align="center" style="padding-bottom:16px;">
                    <div style="width:88px;height:60px;background-color:#252018;border-radius:8px;border:1px solid rgba(255,255,255,0.06);text-align:center;line-height:60px;box-shadow:0 8px 24px rgba(0,0,0,0.3),0 0 16px rgba(231,76,60,0.1);">
                      <div style="display:inline-block;width:30px;height:30px;background-color:#E74C3C;border-radius:50%;line-height:30px;text-align:center;vertical-align:middle;box-shadow:0 2px 8px rgba(231,76,60,0.3);">
                        <span style="font-family:Georgia,'Times New Roman',serif;font-style:italic;font-size:10px;color:#F5F0EB;letter-spacing:-0.3px;">OW</span>
                      </div>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td align="center">
                    <span style="font-family:Georgia,'Times New Roman',serif;font-size:20px;color:#F5F0EB;letter-spacing:-0.3px;">Whenote</span>
                  </td>
                </tr>
              </table>
            </td>
          </tr>

          <!-- Card -->
          <tr>
            <td>
              <table role="presentation" cellpadding="0" cellspacing="0" width="100%" style="background-color:#252018;border-radius:16px;border:1px solid rgba(255,255,255,0.06);" class="card">
                <tr>
                  <td style="padding:36px 32px;">

                    <p style="font-family:Georgia,'Times New Roman',serif;font-size:18px;color:#F5F0EB;margin:0 0 8px 0;">
                      You have a letter! &#x1F48C;
                    </p>
                    <p style="font-size:14px;color:#B8B0A8;line-height:1.7;margin:0 0 6px 0;">
                      <strong style="color:#F5F0EB;">${s}</strong> sent you a letter titled
                      <strong style="color:#F5F0EB;">&ldquo;${t}&rdquo;</strong> on Whenote.
                    </p>
                    <p style="font-size:14px;color:#B8B0A8;line-height:1.7;margin:0 0 28px 0;">
                      Sign in with this email address to read it when it unlocks.
                    </p>

                    <!-- CTA -->
                    <table role="presentation" cellpadding="0" cellspacing="0" width="100%">
                      <tr>
                        <td align="center">
                          <table role="presentation" cellpadding="0" cellspacing="0">
                            <tr>
                              <td align="center" style="background-color:#E74C3C;border-radius:12px;box-shadow:0 4px 16px rgba(231,76,60,0.3);" class="btn-td">
                                <a href="${p.link}" target="_blank" style="display:inline-block;padding:14px 36px;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;font-size:14px;font-weight:500;color:#F5F0EB;text-decoration:none;letter-spacing:0.3px;">
                                  Open the App
                                </a>
                              </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                    </table>

                    <p style="font-size:11px;color:#7A726A;line-height:1.6;margin:24px 0 0 0;text-align:center;">
                      If the button doesn&rsquo;t work, copy and paste this link into your browser:
                    </p>
                    <p style="font-size:11px;color:#B8B0A8;line-height:1.5;margin:6px 0 0 0;word-break:break-all;text-align:center;">
                      <a href="${p.link}" style="color:#E74C3C;text-decoration:underline;">${p.link}</a>
                    </p>

                  </td>
                </tr>
              </table>
            </td>
          </tr>

          <!-- Info note -->
          <tr>
            <td style="padding:20px 0;">
              <table role="presentation" cellpadding="0" cellspacing="0" width="100%" style="background-color:rgba(37,32,24,0.5);border-radius:10px;border:1px solid rgba(255,255,255,0.03);">
                <tr>
                  <td style="padding:16px 20px;">
                    <p style="font-size:12px;color:#7A726A;line-height:1.6;margin:0;">
                      &#x1F512; If you didn&rsquo;t expect this message, you can safely ignore it. No account was created on your behalf.
                    </p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td align="center" style="padding:8px 0 0 0;">
              <p style="font-size:11px;color:#7A726A;margin:0 0 4px 0;">
                &copy; 2026 Whenote &middot; Write today. Feel tomorrow.
              </p>
              <p style="font-size:11px;color:#7A726A;margin:0;">
                <a href="https://whenote.app/privacy.html" style="color:#B8B0A8;text-decoration:none;">Privacy</a>
                &nbsp;&middot;&nbsp;
                <a href="https://whenote.app/terms.html" style="color:#B8B0A8;text-decoration:none;">Terms</a>
              </p>
            </td>
          </tr>

        </table>
      </td>
    </tr>
  </table>
</body>
</html>`;
}

function buildInvitePlainText(p: {
  senderName: string; title: string; link: string;
}): string {
  return [
    `Hi,`,
    ``,
    `${p.senderName} sent you a letter titled "${p.title}" on Whenote.`,
    ``,
    `Sign in with this email address to read it when it unlocks:`,
    p.link,
    ``,
    `If you didn't expect this message, you can safely ignore it.`,
    ``,
    `---`,
    `Whenote — Write today. Feel tomorrow.`,
    `https://whenote.app`,
  ].join("\n");
}

async function sendSendgridInvite(params: {
  to: string;
  subject: string;
  html: string;
  plainText?: string;
  customArgs?: Record<string, string>;
}): Promise<void> {
  const key = sendgridApiKey.value();
  if (!key) {
    logger.warn("external_invite_email: SENDGRID_API_KEY missing; skip send");
    return;
  }
  const fromEmail =
    process.env.SENDGRID_FROM_EMAIL || "noreply@whenote.com";
  const fromName = process.env.SENDGRID_FROM_NAME || "Whenote";

  const content: Array<{type: string; value: string}> = [];
  if (params.plainText) {
    content.push({type: "text/plain", value: params.plainText});
  }
  content.push({type: "text/html", value: params.html});

  const body = {
    personalizations: [{
      to: [{email: params.to}],
      ...(params.customArgs ? {custom_args: params.customArgs} : {}),
    }],
    from: {email: fromEmail, name: fromName},
    reply_to: {email: fromEmail, name: fromName},
    subject: params.subject,
    content,
    headers: {
      "List-Unsubscribe": `<mailto:${fromEmail}?subject=unsubscribe>`,
    },
    mail_settings: {
      bypass_list_management: {enable: false},
    },
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
    const title = (data.title as string) || "Whenote";
    const senderName = (data.senderName as string) || "Someone";
    const link = `https://whenote.app/letter/${letterId}`;
    const subject = `${senderName} sent you a letter on Whenote`;
    const templateParams = {senderName, title, link};
    const html = buildInviteHtml(templateParams);
    const plainText = buildInvitePlainText(templateParams);

    try {
      await sendSendgridInvite({
        to: to.trim(),
        subject,
        html,
        plainText,
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
    const title = (data.title as string) || "Whenote";
    const link = `https://whenote.app/letter/${letterId}`;
    const subject = `${senderName} sent you a letter on Whenote`;
    const templateParams = {senderName, title, link};
    const html = buildInviteHtml(templateParams);
    const plainText = buildInvitePlainText(templateParams);

    try {
      await sendSendgridInvite({
        to: email,
        subject,
        html,
        plainText,
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
