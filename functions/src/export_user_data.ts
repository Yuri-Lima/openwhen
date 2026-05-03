import {getFirestore, FieldValue} from "firebase-admin/firestore";
import {getStorage} from "firebase-admin/storage";
import {HttpsError, onCall} from "firebase-functions/v2/https";
import {defineSecret} from "firebase-functions/params";
import * as logger from "firebase-functions/logger";
import {hashUid, storagePathFromUrl} from "./delete_account";
import {DEFAULT_FROM_EMAIL} from "./config/app_urls";

const db = () => getFirestore();
const bucket = () => getStorage().bucket();
const sendgridApiKey = defineSecret("SENDGRID_API_KEY");

/* ══════════════════════════════════════════════════════════════
 *  EXPORT USER DATA — Cloud Function
 *
 *  Collects all user data from Firestore + Storage, builds a
 *  JSON bundle, uploads it as a ZIP to Storage, generates a
 *  signed URL (7 days), and sends it to the user's email.
 *
 *  Called as the first step before account deletion (Tarefa 1).
 * ══════════════════════════════════════════════════════════════ */

export const exportUserData = onCall(
  {
    cors: true,
    timeoutSeconds: 300, // 5 min — export can be large
    secrets: [sendgridApiKey],
  },
  async (request) => {
    if (!request.auth?.uid) {
      throw new HttpsError("unauthenticated", "Sign in required");
    }
    const uid = request.auth.uid;
    const email = request.auth.token.email;

    logger.info(`exportUserData: starting for uid=${uid}`);

    const firestore = db();

    /* ── 1. Collect all user data ────────────────────────── */
    const exportData = await collectUserData(firestore, uid);

    /* ── 2. Build JSON bundle ────────────────────────────── */
    const jsonBundle = JSON.stringify(exportData, null, 2);
    const buffer = Buffer.from(jsonBundle, "utf-8");

    /* ── 3. Upload to Storage ────────────────────────────── */
    const uidHash = hashUid(uid);
    const timestamp = Date.now();
    const exportPath = `exports/${uidHash}_${timestamp}.json`;

    const b = bucket();
    const file = b.file(exportPath);
    await file.save(buffer, {
      contentType: "application/json",
      metadata: {
        customMetadata: {
          uidHash,
          exportedAt: new Date().toISOString(),
          type: "user_data_export",
        },
      },
    });

    /* ── 4. Generate signed URL (7 days) ─────────────────── */
    const [signedUrl] = await file.getSignedUrl({
      action: "read",
      expires: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
    });

    /* ── 5. Send email with download link ────────────────── */
    if (email) {
      try {
        await sendExportEmail({
          to: email,
          downloadUrl: signedUrl,
          letterCount: exportData.letters?.sent?.length ?? 0,
          capsuleCount: exportData.capsules?.length ?? 0,
          locale: (exportData.profile?.language as string | undefined) ?? "pt-BR",
        });
        logger.info(`exportUserData: email sent to ${email}`);
      } catch (e) {
        // Email is best-effort — don't fail the export
        logger.warn("exportUserData: email send failed (best-effort)", e);
      }
    }

    /* ── 6. Log to privacyRequestLogs ────────────────────── */
    await firestore.collection("privacyRequestLogs").add({
      uid: hashUid(uid),
      type: "export_pre_deletion",
      status: "completed",
      metadata: {
        letterCount: (exportData.letters?.sent?.length ?? 0) +
          (exportData.letters?.received?.length ?? 0),
        capsuleCount: exportData.capsules?.length ?? 0,
        exportPath,
        expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString(),
      },
      createdAt: FieldValue.serverTimestamp(),
      source: "server",
    });

    logger.info(`exportUserData: completed for uid=${uid}`);

    return {
      success: true,
      downloadUrl: signedUrl,
      expiresInDays: 7,
    };
  }
);

/* ══════════════════════════════════════════════════════════════
 *  DATA COLLECTION
 * ══════════════════════════════════════════════════════════════ */

interface ExportBundle {
  metadata: {
    exportedAt: string;
    version: string;
    uid: string;
  };
  profile: Record<string, unknown> | null;
  letters: {
    sent: Record<string, unknown>[];
    received: Record<string, unknown>[];
  };
  capsules: Record<string, unknown>[];
  comments: Record<string, unknown>[];
  likes: Record<string, unknown>[];
  social: {
    followers: Record<string, unknown>[];
    following: Record<string, unknown>[];
  };
  badges: Record<string, unknown>[];
  mediaFiles: {
    type: string;
    originalUrl: string;
    signedUrl: string | null;
  }[];
}

async function collectUserData(
  firestore: FirebaseFirestore.Firestore,
  uid: string,
): Promise<ExportBundle> {
  const bundle: ExportBundle = {
    metadata: {
      exportedAt: new Date().toISOString(),
      version: "1.0",
      uid,
    },
    profile: null,
    letters: {sent: [], received: []},
    capsules: [],
    comments: [],
    likes: [],
    social: {followers: [], following: []},
    badges: [],
    mediaFiles: [],
  };

  // Profile
  const userDoc = await firestore.collection("users").doc(uid).get();
  if (userDoc.exists) {
    const data = userDoc.data() ?? {};
    // Exclude internal/sensitive fields
    const {fcmToken, ...profileData} = data;
    bundle.profile = serializeFirestoreData(profileData);
  }

  // Letters sent
  const sentLetters = await firestore
    .collection("letters")
    .where("senderUid", "==", uid)
    .get();
  for (const doc of sentLetters.docs) {
    const data = doc.data();
    bundle.letters.sent.push({id: doc.id, ...serializeFirestoreData(data)});
    collectMediaUrls(data, bundle.mediaFiles);
  }

  // Letters received
  const receivedLetters = await firestore
    .collection("letters")
    .where("receiverUid", "==", uid)
    .get();
  for (const doc of receivedLetters.docs) {
    const data = doc.data();
    bundle.letters.received.push({id: doc.id, ...serializeFirestoreData(data)});
  }

  // Capsules
  const capsulesBySender = await firestore
    .collection("capsules")
    .where("senderUid", "==", uid)
    .get();
  for (const doc of capsulesBySender.docs) {
    const data = doc.data();
    bundle.capsules.push({id: doc.id, ...serializeFirestoreData(data)});
    const photos = (data.photos as string[]) || [];
    for (const url of photos) {
      bundle.mediaFiles.push({type: "capsule_photo", originalUrl: url, signedUrl: null});
    }
  }

  // Also capsules where user is participant
  const capsulesByParticipant = await firestore
    .collection("capsules")
    .where("participantUids", "array-contains", uid)
    .get();
  const capsuleIds = new Set(bundle.capsules.map((c) => c.id));
  for (const doc of capsulesByParticipant.docs) {
    if (capsuleIds.has(doc.id)) continue;
    bundle.capsules.push({id: doc.id, ...serializeFirestoreData(doc.data())});
  }

  // Comments
  const comments = await firestore
    .collection("comments")
    .where("userUid", "==", uid)
    .get();
  for (const doc of comments.docs) {
    bundle.comments.push({id: doc.id, ...serializeFirestoreData(doc.data())});
  }

  // Likes
  const likes = await firestore
    .collection("likes")
    .where("userUid", "==", uid)
    .get();
  for (const doc of likes.docs) {
    bundle.likes.push({id: doc.id, ...serializeFirestoreData(doc.data())});
  }

  // Followers (people who follow this user)
  const followers = await firestore
    .collection("follows")
    .where("followingUid", "==", uid)
    .get();
  for (const doc of followers.docs) {
    bundle.social.followers.push({id: doc.id, ...serializeFirestoreData(doc.data())});
  }

  // Following (people this user follows)
  const following = await firestore
    .collection("follows")
    .where("followerUid", "==", uid)
    .get();
  for (const doc of following.docs) {
    bundle.social.following.push({id: doc.id, ...serializeFirestoreData(doc.data())});
  }

  // Badges
  const badges = await firestore
    .collection(`users/${uid}/badgeUnlocks`)
    .get();
  for (const doc of badges.docs) {
    bundle.badges.push({id: doc.id, ...serializeFirestoreData(doc.data())});
  }

  // Generate signed URLs for all collected media files
  await generateSignedUrls(bundle.mediaFiles);

  return bundle;
}

/**
 * Extracts media URLs from a letter document for inclusion in the export.
 */
function collectMediaUrls(
  data: FirebaseFirestore.DocumentData,
  mediaFiles: ExportBundle["mediaFiles"],
): void {
  if (data.voiceUrl) {
    mediaFiles.push({type: "voice", originalUrl: data.voiceUrl, signedUrl: null});
  }
  if (data.handwrittenImageUrl) {
    mediaFiles.push({type: "handwritten", originalUrl: data.handwrittenImageUrl, signedUrl: null});
  }
}

/**
 * Generates 7-day signed download URLs for all collected media files.
 */
async function generateSignedUrls(
  mediaFiles: ExportBundle["mediaFiles"],
): Promise<void> {
  const b = bucket();
  const expires = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);

  for (const mf of mediaFiles) {
    try {
      const path = storagePathFromUrl(mf.originalUrl);
      if (!path) continue;
      const file = b.file(path);
      const [exists] = await file.exists();
      if (!exists) continue;
      const [url] = await file.getSignedUrl({action: "read", expires});
      mf.signedUrl = url;
    } catch {
      // Best-effort — some files may have been deleted
    }
  }
}

/* ══════════════════════════════════════════════════════════════
 *  EMAIL
 * ══════════════════════════════════════════════════════════════ */

interface ExportEmailParams {
  to: string;
  downloadUrl: string;
  letterCount: number;
  capsuleCount: number;
  locale: string;
}

async function sendExportEmail(params: ExportEmailParams): Promise<void> {
  const key = sendgridApiKey.value();
  if (!key) {
    logger.warn("exportUserData: SENDGRID_API_KEY missing; skip email");
    return;
  }

  const fromEmail = DEFAULT_FROM_EMAIL;
  const fromName = process.env.SENDGRID_FROM_NAME || "Whenote";

  const isPt = params.locale.startsWith("pt");
  const isEs = params.locale.startsWith("es");

  const subject = isPt
    ? "Seus dados do Whenote estão prontos"
    : isEs
      ? "Tus datos de Whenote están listos"
      : "Your Whenote data export is ready";

  const html = buildExportEmailHtml(params, {isPt, isEs});
  const plainText = buildExportEmailPlainText(params, {isPt, isEs});

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

function buildExportEmailHtml(
  params: ExportEmailParams,
  lang: {isPt: boolean; isEs: boolean},
): string {
  const {downloadUrl, letterCount, capsuleCount} = params;

  const title = lang.isPt
    ? "Seus dados estão prontos"
    : lang.isEs
      ? "Tus datos están listos"
      : "Your data is ready";

  const body1 = lang.isPt
    ? `Seu export contém <strong>${letterCount} carta(s)</strong> e <strong>${capsuleCount} cápsula(s)</strong>.`
    : lang.isEs
      ? `Tu exportación contiene <strong>${letterCount} carta(s)</strong> y <strong>${capsuleCount} cápsula(s)</strong>.`
      : `Your export contains <strong>${letterCount} letter(s)</strong> and <strong>${capsuleCount} capsule(s)</strong>.`;

  const body2 = lang.isPt
    ? "O link abaixo expira em <strong>7 dias</strong>. Faça o download antes disso."
    : lang.isEs
      ? "El enlace a continuación expira en <strong>7 días</strong>. Descárgalo antes de eso."
      : "The link below expires in <strong>7 days</strong>. Download it before then.";

  const btnLabel = lang.isPt
    ? "Baixar meus dados"
    : lang.isEs
      ? "Descargar mis datos"
      : "Download my data";

  const footer = lang.isPt
    ? "Se você não solicitou este export, ignore este email."
    : lang.isEs
      ? "Si no solicitaste esta exportación, ignora este correo."
      : "If you did not request this export, please ignore this email.";

  return `
<!DOCTYPE html>
<html lang="${lang.isPt ? "pt" : lang.isEs ? "es" : "en"}">
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
        <table width="100%" cellpadding="0" cellspacing="0">
          <tr><td align="center">
            <a href="${downloadUrl}" style="display:inline-block;padding:14px 32px;background:#2563eb;color:#fff;text-decoration:none;border-radius:8px;font-size:15px;font-weight:600;">${btnLabel}</a>
          </td></tr>
        </table>
      </td>
    </tr>
    <tr>
      <td style="padding:28px;text-align:center;">
        <p style="font-size:12px;color:#999;margin:0;">${footer}</p>
      </td>
    </tr>
  </table>
</body>
</html>`.trim();
}

function buildExportEmailPlainText(
  params: ExportEmailParams,
  lang: {isPt: boolean; isEs: boolean},
): string {
  const {downloadUrl, letterCount, capsuleCount} = params;

  if (lang.isPt) {
    return [
      "Seus dados do Whenote estão prontos.",
      `Export: ${letterCount} carta(s), ${capsuleCount} cápsula(s).`,
      `Link (expira em 7 dias): ${downloadUrl}`,
      "",
      "Se não solicitou, ignore este email.",
    ].join("\n");
  }
  if (lang.isEs) {
    return [
      "Tus datos de Whenote están listos.",
      `Exportación: ${letterCount} carta(s), ${capsuleCount} cápsula(s).`,
      `Enlace (expira en 7 días): ${downloadUrl}`,
      "",
      "Si no solicitaste esto, ignora este correo.",
    ].join("\n");
  }
  return [
    "Your Whenote data export is ready.",
    `Export: ${letterCount} letter(s), ${capsuleCount} capsule(s).`,
    `Download link (expires in 7 days): ${downloadUrl}`,
    "",
    "If you did not request this, please ignore this email.",
  ].join("\n");
}

/* ══════════════════════════════════════════════════════════════
 *  HELPERS
 * ══════════════════════════════════════════════════════════════ */

/**
 * Converts Firestore Timestamps to ISO strings for JSON serialization.
 */
function serializeFirestoreData(
  data: Record<string, unknown>,
): Record<string, unknown> {
  const result: Record<string, unknown> = {};
  for (const [key, value] of Object.entries(data)) {
    if (value && typeof value === "object" && "toDate" in value &&
        typeof (value as {toDate: () => Date}).toDate === "function") {
      result[key] = (value as {toDate: () => Date}).toDate().toISOString();
    } else if (value && typeof value === "object" && !Array.isArray(value)) {
      result[key] = serializeFirestoreData(value as Record<string, unknown>);
    } else {
      result[key] = value;
    }
  }
  return result;
}
