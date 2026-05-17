import {onDocumentWritten} from "firebase-functions/v2/firestore";
import {defineSecret} from "firebase-functions/params";
import {getFirestore, FieldValue, Timestamp} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import {DEFAULT_FROM_EMAIL, PRIVACY_URL, TERMS_URL} from "./config/app_urls";

const sendgridApiKey = defineSecret("SENDGRID_API_KEY");

const db = () => getFirestore();

interface PolicyUpdateDoc {
  termsVersion?: string;
  privacyVersion?: string;
  effectiveDate?: Timestamp;
  notifiedAt?: Timestamp;
  summaryEn?: string;
  summaryPt?: string;
  summaryPtBR?: string;
  summaryEs?: string;
  changesUrl?: string;
  emailBatchStatus?: string;
  emailBatchSentCount?: number;
  active?: boolean;
}

function escapeHtml(s: string): string {
  return s
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

function getSummary(data: PolicyUpdateDoc, lang: string): string {
  const l = lang?.substring(0, 2) || "en";
  if (l === "pt") return data.summaryPtBR || data.summaryPt || data.summaryEn || "";
  if (l === "es") return data.summaryEs || data.summaryEn || "";
  return data.summaryEn || "";
}

interface EmailTexts {
  subject: string;
  heading: string;
  intro: string;
  effectiveLabel: string;
  changesLabel: string;
  cta: string;
  footer: string;
  ignore: string;
}

function getTexts(lang: string): EmailTexts {
  const l = lang?.substring(0, 2) || "en";
  if (l === "pt") {
    return {
      subject: "Whenote — Atualização da Política de Privacidade e Termos de Uso",
      heading: "Atualizámos os nossos documentos legais",
      intro: "Queremos informá-lo(a) de que fizemos alterações aos nossos Termos de Uso e/ou Política de Privacidade.",
      effectiveLabel: "Data efetiva:",
      changesLabel: "Resumo das alterações:",
      cta: "Abrir o App",
      footer: "Se continuar a usar o Whenote após a data efetiva, tal constitui aceitação das novas condições.",
      ignore: "Se não reconhece esta mensagem, pode ignorá-la com segurança.",
    };
  }
  if (l === "es") {
    return {
      subject: "Whenote — Actualización de la Política de Privacidad y Términos de Uso",
      heading: "Hemos actualizado nuestros documentos legales",
      intro: "Queremos informarle de que hemos realizado cambios en nuestros Términos de Uso y/o Política de Privacidad.",
      effectiveLabel: "Fecha efectiva:",
      changesLabel: "Resumen de los cambios:",
      cta: "Abrir la App",
      footer: "Si continúa usando Whenote después de la fecha efectiva, esto constituirá la aceptación de las nuevas condiciones.",
      ignore: "Si no reconoce este mensaje, puede ignorarlo con seguridad.",
    };
  }
  return {
    subject: "Whenote — Privacy Policy and Terms of Use Update",
    heading: "We've updated our legal documents",
    intro: "We'd like to inform you that we've made changes to our Terms of Use and/or Privacy Policy.",
    effectiveLabel: "Effective date:",
    changesLabel: "Summary of changes:",
    cta: "Open the App",
    footer: "Continued use of Whenote after the effective date constitutes acceptance of the updated terms.",
    ignore: "If you don't recognize this message, you can safely ignore it.",
  };
}

function buildPolicyEmailHtml(params: {
  texts: EmailTexts;
  summary: string;
  effectiveDate: string;
  changesUrl: string;
}): string {
  const t = params.texts;
  const summary = escapeHtml(params.summary);
  const effectiveDate = escapeHtml(params.effectiveDate);
  return `<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${escapeHtml(t.subject)}</title>
  <style>
    body, table, td, a { -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; }
    body { margin: 0; padding: 0; width: 100% !important; background-color: #0D0B09; }
    @media only screen and (max-width: 600px) {
      .container { width: 100% !important; padding: 16px !important; }
      .card { padding: 28px 20px !important; }
    }
  </style>
</head>
<body style="margin:0;padding:0;background-color:#0D0B09;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;">
  <table role="presentation" cellpadding="0" cellspacing="0" width="100%" style="background-color:#0D0B09;">
    <tr>
      <td align="center" style="padding:40px 16px;">
        <table role="presentation" cellpadding="0" cellspacing="0" width="480" class="container" style="max-width:480px;width:100%;">
          <!-- Logo -->
          <tr>
            <td align="center" style="padding-bottom:32px;">
              <table role="presentation" cellpadding="0" cellspacing="0">
                <tr>
                  <td align="center" style="padding-bottom:16px;">
                    <div style="width:88px;height:60px;background-color:#252018;border-radius:8px;border:1px solid rgba(255,255,255,0.06);text-align:center;line-height:60px;">
                      <div style="display:inline-block;width:30px;height:30px;background-color:#E74C3C;border-radius:50%;line-height:30px;text-align:center;vertical-align:middle;">
                        <span style="font-family:Georgia,'Times New Roman',serif;font-style:italic;font-size:10px;color:#F5F0EB;">OW</span>
                      </div>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td align="center">
                    <span style="font-family:Georgia,'Times New Roman',serif;font-size:20px;color:#F5F0EB;">Whenote</span>
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
                    <p style="font-family:Georgia,'Times New Roman',serif;font-size:18px;color:#F5F0EB;margin:0 0 16px 0;">
                      ${escapeHtml(t.heading)}
                    </p>
                    <p style="font-size:14px;color:#B8B0A8;line-height:1.7;margin:0 0 16px 0;">
                      ${escapeHtml(t.intro)}
                    </p>
                    <p style="font-size:13px;color:#B8B0A8;line-height:1.7;margin:0 0 6px 0;">
                      <strong style="color:#F5F0EB;">${escapeHtml(t.effectiveLabel)}</strong> ${effectiveDate}
                    </p>
                    <p style="font-size:13px;color:#B8B0A8;line-height:1.7;margin:0 0 6px 0;">
                      <strong style="color:#F5F0EB;">${escapeHtml(t.changesLabel)}</strong>
                    </p>
                    <p style="font-size:13px;color:#B8B0A8;line-height:1.7;margin:0 0 24px 0;padding:12px 16px;background-color:rgba(0,0,0,0.2);border-radius:8px;">
                      ${summary}
                    </p>
                    <!-- CTA -->
                    <table role="presentation" cellpadding="0" cellspacing="0" width="100%">
                      <tr>
                        <td align="center">
                          <table role="presentation" cellpadding="0" cellspacing="0">
                            <tr>
                              <td align="center" style="background-color:#E74C3C;border-radius:12px;">
                                <a href="${params.changesUrl}" target="_blank" style="display:inline-block;padding:14px 36px;font-size:14px;font-weight:500;color:#F5F0EB;text-decoration:none;">
                                  ${escapeHtml(t.cta)}
                                </a>
                              </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                    </table>
                    <p style="font-size:12px;color:#7A726A;line-height:1.6;margin:20px 0 0 0;text-align:center;">
                      ${escapeHtml(t.footer)}
                    </p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <!-- Footer -->
          <tr>
            <td align="center" style="padding:20px 0 0 0;">
              <p style="font-size:11px;color:#7A726A;margin:0 0 4px 0;">
                &copy; 2026 Whenote &middot; Write today. Feel tomorrow.
              </p>
              <p style="font-size:11px;color:#7A726A;margin:0;">
                <a href="${PRIVACY_URL}" style="color:#B8B0A8;text-decoration:none;">Privacy</a>
                &nbsp;&middot;&nbsp;
                <a href="${TERMS_URL}" style="color:#B8B0A8;text-decoration:none;">Terms</a>
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

async function sendEmail(params: {
  to: string;
  subject: string;
  html: string;
}): Promise<void> {
  const key = sendgridApiKey.value();
  if (!key) {
    logger.warn("policy_email: SENDGRID_API_KEY missing; skip");
    return;
  }
  const fromEmail = DEFAULT_FROM_EMAIL;
  const fromName = process.env.SENDGRID_FROM_NAME || "Whenote";

  const body = {
    personalizations: [{to: [{email: params.to}]}],
    from: {email: fromEmail, name: fromName},
    reply_to: {email: fromEmail, name: fromName},
    subject: params.subject,
    content: [{type: "text/html", value: params.html}],
    mail_settings: {bypass_list_management: {enable: false}},
    tracking_settings: {
      click_tracking: {enable: false},
      open_tracking: {enable: false},
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
 * Triggered when `systemConfig/policyUpdate` is created or updated.
 * Sends notification emails in batch to all active users.
 *
 * To trigger: write the document via Firebase Console or Admin SDK with
 * `emailBatchStatus: "pending"` and `active: true`.
 */
export const sendPolicyUpdateEmails = onDocumentWritten(
  {
    document: "systemConfig/policyUpdate",
    region: "us-central1",
    secrets: [sendgridApiKey],
    timeoutSeconds: 540,
    memory: "512MiB",
  },
  async (event) => {
    const after = event.data?.after?.data() as PolicyUpdateDoc | undefined;
    if (!after) return; // document deleted

    // Only run when status actually transitions TO "pending" (not already pending before).
    // This prevents re-triggers when the function itself updates the document.
    const before = event.data?.before?.data() as PolicyUpdateDoc | undefined;
    if (after.emailBatchStatus !== "pending" || !after.active) {
      return;
    }
    if (before?.emailBatchStatus === "pending") {
      return; // already pending — this is a no-op re-trigger
    }

    const policyRef = db()
      .collection("systemConfig")
      .doc("policyUpdate");

    // Mark as "sending" to prevent duplicate triggers
    await policyRef.update({
      emailBatchStatus: "sending",
      emailBatchSentCount: 0,
    });

    const effectiveDate = after.effectiveDate?.toDate()
      ?.toISOString()?.substring(0, 10) || "—";
    const changesUrl = after.changesUrl || PRIVACY_URL;

    let totalSent = 0;
    let totalFailed = 0;
    let lastDoc: FirebaseFirestore.DocumentSnapshot | undefined;
    const PAGE_SIZE = 200;

    try {
      // eslint-disable-next-line no-constant-condition
      while (true) {
        let query = db()
          .collection("users")
          .where("accountStatus", "==", "active")
          .orderBy("createdAt")
          .limit(PAGE_SIZE);

        if (lastDoc) {
          query = query.startAfter(lastDoc);
        }

        const snap = await query.get();
        if (snap.empty) break;

        const promises: Promise<void>[] = [];
        for (const doc of snap.docs) {
          const userData = doc.data();
          const email = userData.email as string | undefined;
          if (!email) continue;

          const lang = (userData.language as string) || "en";
          const texts = getTexts(lang);
          const summary = getSummary(after, lang);
          const html = buildPolicyEmailHtml({
            texts,
            summary,
            effectiveDate,
            changesUrl,
          });

          promises.push(
            sendEmail({to: email, subject: texts.subject, html})
              .then(() => { totalSent++; })
              .catch((e) => {
                totalFailed++;
                logger.warn("policy_email_failed", {
                  uid: doc.id.substring(0, 6) + "...",
                  err: String(e),
                });
              })
          );

          // Throttle: wait after every 50 emails
          if (promises.length >= 50) {
            await Promise.allSettled(promises);
            promises.length = 0;
            // Small delay to respect SendGrid rate limits
            await new Promise((r) => setTimeout(r, 1000));
          }
        }

        // Flush remaining
        if (promises.length > 0) {
          await Promise.allSettled(promises);
        }

        lastDoc = snap.docs[snap.docs.length - 1];

        // Update progress
        await policyRef.update({
          emailBatchSentCount: FieldValue.increment(snap.size),
        });

        if (snap.size < PAGE_SIZE) break;
      }

      await policyRef.update({
        emailBatchStatus: "completed",
        emailBatchSentCount: totalSent,
        emailBatchCompletedAt: FieldValue.serverTimestamp(),
      });

      logger.info("policy_email_batch_completed", {
        totalSent,
        totalFailed,
      });
    } catch (e) {
      logger.error("policy_email_batch_error", {err: String(e)});
      await policyRef.update({
        emailBatchStatus: "failed",
        emailBatchError: String(e),
      });
    }
  }
);
