import {onRequest} from "firebase-functions/v2/https";
import {defineSecret} from "firebase-functions/params";
import {FieldValue, getFirestore} from "firebase-admin/firestore";
import {getMessaging} from "firebase-admin/messaging";
import * as logger from "firebase-functions/logger";
import {EventWebhook} from "@sendgrid/eventwebhook";

const sendgridWebhookKey = defineSecret("SENDGRID_WEBHOOK_VERIFICATION_KEY");

type SendGridEventType = "delivered" | "bounce" | "dropped" | "deferred";

const FINAL_STATES = new Set<string>(["bounced", "dropped"]);
const NOTIFY_EVENTS = new Set<string>(["bounce", "dropped"]);

interface SendGridEvent {
  event: SendGridEventType;
  email: string;
  letterId?: string;
  senderUid?: string;
  reason?: string;
  timestamp: number;
}

interface PendingFcm {
  senderUid: string;
  email: string;
  letterId: string;
  lang: string;
}

const bounceMessages: Record<string, { title: string; body: string }> = {
  en: {
    title: "Email not delivered",
    body: "The email to {email} could not be delivered. Check the address and try again.",
  },
  pt: {
    title: "Email não entregue",
    body: "O email para {email} não pôde ser entregue. Verifique o endereço e tente novamente.",
  },
  es: {
    title: "Email no entregado",
    body: "El email a {email} no pudo ser entregado. Verifica la dirección e inténtalo de nuevo.",
  },
};

function maskEmail(email: string): string {
  const parts = email.split("@");
  if (parts.length !== 2) return "***";
  const [local, domain] = parts;
  return `${local.slice(0, 2)}***@${domain}`;
}

function verifySendGridSignature(
  req: {headers: Record<string, string | string[] | undefined>; rawBody: Buffer},
  publicKeyStr: string
): boolean {
  try {
    const ew = new EventWebhook();
    const ecKey = ew.convertPublicKeyToECDSA(publicKeyStr);
    const signature = req.headers["x-twilio-email-event-webhook-signature"] as string;
    const timestamp = req.headers["x-twilio-email-event-webhook-timestamp"] as string;
    if (!signature || !timestamp) return false;
    const payload = req.rawBody.toString("utf8");
    return ew.verifySignature(ecKey, payload, signature, timestamp);
  } catch {
    return false;
  }
}

export const onSendGridWebhook = onRequest(
  {region: "us-central1", secrets: [sendgridWebhookKey]},
  async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).send("Method not allowed");
      return;
    }

    if (!verifySendGridSignature(req, sendgridWebhookKey.value())) {
      logger.warn("sendgrid_webhook: invalid signature");
      res.status(403).send("Forbidden");
      return;
    }

    const events: SendGridEvent[] = req.body;
    if (!Array.isArray(events)) {
      res.status(400).send("Bad request");
      return;
    }

    const db = getFirestore();
    const pendingFcm: PendingFcm[] = [];

    const CHUNK_SIZE = 250;
    for (let i = 0; i < events.length; i += CHUNK_SIZE) {
      const chunk = events.slice(i, i + CHUNK_SIZE);
      const batch = db.batch();

      for (const evt of chunk) {
        if (!evt.letterId) continue;
        const letterRef = db.doc(`letters/${evt.letterId}`);

        const letterDoc = await letterRef.get();
        if (!letterDoc.exists) {
          logger.warn("sendgrid_webhook: letter_not_found", {letterId: evt.letterId});
          continue;
        }
        const current = letterDoc.data()?.inviteEmailStatus;
        if (current === evt.event) {
          logger.info("sendgrid_webhook: skip_duplicate", {letterId: evt.letterId, event: evt.event});
          continue;
        }
        if (FINAL_STATES.has(current) && evt.event === "delivered") {
          logger.info("sendgrid_webhook: skip_override_final", {letterId: evt.letterId, current, event: evt.event});
          continue;
        }

        batch.update(letterRef, {
          inviteEmailStatus: evt.event,
          inviteEmailStatusUpdatedAt: FieldValue.serverTimestamp(),
          ...(evt.reason ? {inviteEmailStatusReason: evt.reason} : {}),
        });

        logger.info("sendgrid_webhook: status_update", {
          letterId: evt.letterId,
          event: evt.event,
          email: maskEmail(evt.email),
        });

        if (NOTIFY_EVENTS.has(evt.event) && evt.senderUid) {
          const userDoc = await db.doc(`users/${evt.senderUid}`).get();
          const lang = (userDoc.data()?.preferredLanguage as string) || "en";
          const msgs = bounceMessages[lang] || bounceMessages.en;

          const notifRef = db
            .collection("users").doc(evt.senderUid)
            .collection("notifications").doc();

          batch.set(notifRef, {
            type: "email_bounce",
            letterId: evt.letterId,
            email: evt.email,
            reason: evt.reason || null,
            title: msgs.title,
            body: msgs.body.replace("{email}", evt.email),
            read: false,
            createdAt: FieldValue.serverTimestamp(),
          });

          pendingFcm.push({
            senderUid: evt.senderUid,
            email: evt.email,
            letterId: evt.letterId,
            lang,
          });
        }
      }

      await batch.commit();
    }

    await Promise.allSettled(pendingFcm.map(async (p) => {
      try {
        const userDoc = await db.doc(`users/${p.senderUid}`).get();
        const fcmToken = userDoc.data()?.fcmToken;
        if (!fcmToken) return;
        const msgs = bounceMessages[p.lang] || bounceMessages.en;
        await getMessaging().send({
          token: fcmToken,
          notification: {
            title: msgs.title,
            body: msgs.body.replace("{email}", p.email),
          },
          data: {type: "email_bounce", letterId: p.letterId},
        });
      } catch (e) {
        logger.warn("sendgrid_webhook: fcm_send_failed", {senderUid: p.senderUid, err: String(e)});
      }
    }));

    res.status(200).send("OK");
  }
);
