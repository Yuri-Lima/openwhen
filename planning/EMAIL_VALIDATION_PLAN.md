# Plano de Execução — Validação de Email + Notificação ao Remetente

> **Data:** 2026-04-11
> **Status:** ✅ Concluído (deployed + preferredLanguage implementado) — pendente apenas teste E2E
> **Prioridade:** Alta (impacta UX de cartas externas)
> **Review:** 3 correcções críticas (C1-C3), 5 melhorias arquitecturais (A1-A5), 7 boas práticas (B1-B7)
> **Implementado em:** 2026-04-11

---

## Resumo da implementação

**Ficheiros criados:**
| Ficheiro | Descrição |
|----------|-----------|
| `lib/core/utils/validators.dart` | Utility com regex de email reutilizável |
| `functions/src/sendgrid_webhook.ts` | Webhook handler (C1-rawBody, C2-defineSecret, A1-chunking, A2-FCM pós-commit, A3-idempotência, A4-deferred silencioso, B4-preferredLanguage, B5-logging) |
| `test/core/validators_test.dart` | 7 testes unitários (todos passando) |

**Ficheiros editados:**
| Ficheiro | Alterações |
|----------|------------|
| `write_letter_screen.dart` | `Validators.isValidEmail()` em vez de `contains('@')` |
| `letter.dart` | Enum `InviteEmailStatus` + campos `inviteEmailStatus`, `inviteEmailStatusUpdatedAt`, `receiverEmail` + getter `hasEmailDeliveryFailure` |
| `external_letters.ts` | `defineSecret(SENDGRID_API_KEY)`, `customArgs`, `inviteEmailStatus: sent/send_failed`, + callable `resendExternalInviteEmail` com rate limiting |
| `index.ts` | Exports de `resendExternalInviteEmail` e `onSendGridWebhook` |
| `firestore.rules` | Campos imutáveis protegidos (C3) + delete restrito ao sender |
| `letter_detail_screen.dart` | Banner de bounce vermelho + dialog de reenvio via Cloud Function |
| `moderation_notifications_screen.dart` | Handling de `type == "email_bounce"` com ícone vermelho |
| `app_en.arb` | Mensagem melhorada + 6 novas keys (bounce, sendFailed, resend) |
| `app_pt.arb` | Idem em PT |
| `app_pt_BR.arb` | Idem em PT-BR |
| `app_es.arb` | Idem em ES |

---

## Contexto

Quando um utilizador envia uma carta para um email externo (destinatário sem conta), o fluxo atual:

1. Valida o email apenas com `contains('@')` (`write_letter_screen.dart:416`)
2. Grava a carta no Firestore com `receiverEmail` e `receiverEmailNormalized`
3. A Cloud Function `onLetterCreatedSendExternalInviteEmail` (`external_letters.ts:112`) envia o convite via SendGrid
4. **Se o email não existe → silêncio total** — o remetente nunca sabe que a carta ficou num limbo

---

## Arquivos-chave identificados

| Componente | Ficheiro | Linhas | Alteração |
|---|---|---|---|
| **Validators (NOVO)** | `lib/core/utils/validators.dart` | — | Criar — B1 |
| Validação email (cliente) | `lib/features/letters/presentation/screens/write_letter_screen.dart` | 414-421 | Editar |
| Modelo Letter (Dart) | `lib/features/letters/models/letter.dart` | 5-92 | Editar — B2 |
| SendGrid invite | `functions/src/external_letters.ts` | 112-149 | Editar — C2, A5 |
| SendGrid helper | `functions/src/external_letters.ts` | 19-50 | Editar — C2 |
| **SendGrid webhook (NOVO)** | `functions/src/sendgrid_webhook.ts` | — | Criar — C1, A1-A4 |
| Notificações (moderação) | `functions/src/moderation/user_notifications.ts` | 16-37 | Referência |
| Tela de notificações | `lib/features/profile/presentation/screens/moderation_notifications_screen.dart` | — | Editar |
| FCM Token Manager | `lib/core/services/fcm_token_manager.dart` | 12-33 | Referência |
| Notification Service | `lib/core/services/notification_service.dart` | 35-169 | Referência |
| Firestore Rules | `firestore.rules` | 65-87 | Editar — C3 |
| Localizações (ARB) | `lib/l10n/app_en.arb`, `app_pt.arb`, `app_pt_BR.arb`, `app_es.arb` | — | Editar |
| index.ts (exports) | `functions/src/index.ts` | — | Editar |

---

## Fases de Execução

### FASE 1 — Validação no Cliente (Flutter) ✅
**Esforço:** ~30 min | **Risco:** Baixo | **Dependências:** Nenhuma | **Status:** Implementado

#### 1.1 Extrair validação de email para utility reutilizável

**Ficheiro novo:** `lib/core/utils/validators.dart`

```dart
class Validators {
  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static bool isValidEmail(String email) => _emailRegex.hasMatch(email.trim());
}
```

**Justificação:** Centraliza a regex num único local reutilizável (ecrã de escrita, reenvio, perfil, etc.). Rejeita emails como `user@`, `@domain`, `user @domain.com` (com espaços). Não precisa de ser perfeito — o SendGrid validará no envio.

#### 1.2 Usar a utility no ecrã de escrita

**Ficheiro:** `lib/features/letters/presentation/screens/write_letter_screen.dart`
**Linha:** 416

**De:**
```dart
if (!emailTrim.contains('@')) {
```

**Para:**
```dart
if (!Validators.isValidEmail(emailTrim)) {
```

Adicionar o import: `import 'package:openwhen/core/utils/validators.dart';`

#### 1.3 Melhorar mensagem de erro no SnackBar

**Ficheiro:** `lib/features/letters/presentation/screens/write_letter_screen.dart`

A mensagem atual usa `l10n.writeLetterSnackEmailInvalid`. Verificar se o texto já é suficientemente descritivo; se não, atualizar nos ARB:

**Ficheiros ARB a atualizar:**
- `lib/l10n/app_en.arb` — ex: `"writeLetterSnackEmailInvalid": "Please enter a valid email address (e.g. name@example.com)"`
- `lib/l10n/app_pt.arb` / `app_pt_BR.arb` — ex: `"writeLetterSnackEmailInvalid": "Insira um email válido (ex: nome@exemplo.com)"`
- `lib/l10n/app_es.arb` — ex: `"writeLetterSnackEmailInvalid": "Ingresa un email válido (ej: nombre@ejemplo.com)"`

Após editar ARBs: `flutter gen-l10n`

#### 1.4 Validação pode ser commitada independentemente
> ✅ Este é um commit isolado e seguro — não altera backend nem Firestore.

---

### FASE 2 — Webhook do SendGrid + Cloud Function ✅
**Esforço:** ~2-3 horas | **Risco:** Médio | **Dependências:** Painel SendGrid (acesso manual do utilizador) | **Status:** Código implementado — pendente `npm install @sendgrid/eventwebhook` + config SendGrid + deploy

#### 2.1 Passar `letterId` como custom arg no SendGrid

**Ficheiro:** `functions/src/external_letters.ts` (linhas ~130-145)

No payload do SendGrid, adicionar `custom_args` para que o webhook consiga mapear o evento à carta:

```typescript
// No corpo do request para SendGrid API
personalizations: [{
  to: [{ email: to.trim() }],
  custom_args: {
    letterId: letterId,
    senderUid: data.senderUid as string,
  }
}]
```

**Notas:**
- Isto requer mudar o helper `sendSendgridInvite` (linhas 19-50) para aceitar `custom_args` como parâmetro adicional, ou reestruturar o payload.
- **⚠️ REVIEW:** Os valores de `custom_args` do SendGrid devem ser **strings**. `letterId` e `senderUid` já são strings, mas confirmar no código que não são passados como outros tipos.

#### 2.2 Criar Cloud Function HTTP `onSendGridWebhook`

**Ficheiro novo:** `functions/src/sendgrid_webhook.ts`

> **⚠️ REVIEW:** Correcções aplicadas — C1 (rawBody), C2 (defineSecret), A1 (batch chunking ≤250), A2 (FCM após commit), A3 (idempotência), A4 (deferred sem notificação), B4 (preferredLanguage), B5 (logging estruturado).

```typescript
import { onRequest } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { getMessaging } from "firebase-admin/messaging";
import * as logger from "firebase-functions/logger";

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
  en: { title: "Email not delivered", body: "The email to {email} could not be delivered. Check the address and try again." },
  pt: { title: "Email não entregue", body: "O email para {email} não pôde ser entregue. Verifique o endereço e tente novamente." },
  es: { title: "Email no entregado", body: "El email a {email} no pudo ser entregado. Verifica la dirección e inténtalo de nuevo." },
};

function maskEmail(email: string): string {
  const [local, domain] = email.split("@");
  return `${local.slice(0, 2)}***@${domain}`;
}

export const onSendGridWebhook = onRequest(
  { region: "us-central1", secrets: [sendgridWebhookKey] },
  async (req, res) => {
    if (req.method !== "POST") { res.status(405).send("Method not allowed"); return; }

    if (!verifySendGridSignature(req, sendgridWebhookKey.value())) {
      logger.warn("sendgrid_webhook: invalid signature");
      res.status(403).send("Forbidden"); return;
    }

    const events: SendGridEvent[] = req.body;
    const db = getFirestore();
    const pendingFcm: PendingFcm[] = [];

    const CHUNK_SIZE = 250;
    for (let i = 0; i < events.length; i += CHUNK_SIZE) {
      const chunk = events.slice(i, i + CHUNK_SIZE);
      const batch = db.batch();

      for (const evt of chunk) {
        if (!evt.letterId) continue;
        const letterRef = db.doc(`letters/${evt.letterId}`);

        // A3 — Idempotência: verificar estado actual antes de escrever
        const letterDoc = await letterRef.get();
        const current = letterDoc.data()?.inviteEmailStatus;
        if (current === evt.event) {
          logger.info("sendgrid_webhook: skip_duplicate", { letterId: evt.letterId, event: evt.event });
          continue;
        }
        if (FINAL_STATES.has(current) && evt.event === "delivered") {
          logger.info("sendgrid_webhook: skip_override_final", { letterId: evt.letterId, current, event: evt.event });
          continue;
        }

        batch.update(letterRef, {
          inviteEmailStatus: evt.event,
          inviteEmailStatusUpdatedAt: FieldValue.serverTimestamp(),
          ...(evt.reason ? { inviteEmailStatusReason: evt.reason } : {}),
        });

        logger.info("sendgrid_webhook: status_update", {
          letterId: evt.letterId,
          event: evt.event,
          email: maskEmail(evt.email),
        });

        // A4 — Só notificar em bounce/dropped (estados finais), NÃO em deferred
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

          pendingFcm.push({ senderUid: evt.senderUid, email: evt.email, letterId: evt.letterId, lang });
        }
      }

      await batch.commit();
    }

    // A2 — FCM push só APÓS batch.commit() ter sucesso
    await Promise.allSettled(pendingFcm.map(async (p) => {
      const userDoc = await db.doc(`users/${p.senderUid}`).get();
      const fcmToken = userDoc.data()?.fcmToken;
      if (!fcmToken) return;
      const msgs = bounceMessages[p.lang] || bounceMessages.en;
      await getMessaging().send({
        token: fcmToken,
        notification: { title: msgs.title, body: msgs.body.replace("{email}", p.email) },
        data: { type: "email_bounce", letterId: p.letterId },
      });
    }));

    res.status(200).send("OK");
  }
);
```

#### 2.3 Validar assinatura do webhook

O SendGrid **Signed Event Webhook** envia headers `X-Twilio-Email-Event-Webhook-Signature` e `X-Twilio-Email-Event-Webhook-Timestamp`. Validar com a **verification key** do painel SendGrid.

**Dependência:** instalar `@sendgrid/eventwebhook` no functions/:
```bash
cd functions && npm install @sendgrid/eventwebhook
```

> **⚠️ REVIEW (C1):** Usar `req.rawBody` (Buffer original) em vez de `JSON.stringify(req.body)`. O Firebase Functions v2 faz parse automático do JSON body — re-serializar com `JSON.stringify` **não reproduz** o payload original byte-a-byte, e a assinatura nunca bateria.

> **⚠️ REVIEW (C2):** A secret key é passada como parâmetro via `defineSecret()` (já declarada na secção 2.2). **Não usar** `process.env` directamente — em Firebase Functions v2, secrets só ficam disponíveis se declarados com `defineSecret()` e passados na config da função.

**Implementação (no mesmo ficheiro `sendgrid_webhook.ts`):**
```typescript
import { EventWebhook } from "@sendgrid/eventwebhook";

function verifySendGridSignature(req: functions.https.Request, publicKeyStr: string): boolean {
  const ew = new EventWebhook();
  const ecKey = ew.convertPublicKeyToECDSA(publicKeyStr);
  const signature = req.headers["x-twilio-email-event-webhook-signature"] as string;
  const timestamp = req.headers["x-twilio-email-event-webhook-timestamp"] as string;
  const payload = req.rawBody.toString("utf8");  // ← rawBody, NÃO JSON.stringify
  return ew.verifySignature(ecKey, payload, signature, timestamp);
}
```

#### 2.4 Corrigir `defineSecret` para `SENDGRID_API_KEY` existente

> **⚠️ REVIEW (C2):** O helper `sendSendgridInvite` em `external_letters.ts` (linha 24) usa `process.env.SENDGRID_API_KEY` directamente. Para consistência e correcta operação em Functions v2, migrar para `defineSecret`:

**Ficheiro:** `functions/src/external_letters.ts`

```typescript
import { defineSecret } from "firebase-functions/params";
const sendgridApiKey = defineSecret("SENDGRID_API_KEY");

// Na declaração de onLetterCreatedSendExternalInviteEmail:
export const onLetterCreatedSendExternalInviteEmail = onDocumentCreated(
  { document: "letters/{letterId}", region: "us-central1", secrets: [sendgridApiKey] },
  async (event) => { /* ... */ }
);

// Dentro de sendSendgridInvite, substituir:
//   const key = process.env.SENDGRID_API_KEY;
// por:
//   const key = sendgridApiKey.value();
```

**Ficheiro:** `functions/src/index.ts`

Adicionar:
```typescript
export { onSendGridWebhook } from "./sendgrid_webhook";
export { resendExternalInviteEmail } from "./external_letters";
```

#### 2.6 Configuração manual no painel SendGrid (utilizador)

O utilizador precisa:
1. Ir a **Settings → Mail Settings → Event Webhook**
2. Inserir a URL da Cloud Function: `https://us-central1-openwhen-923f5.cloudfunctions.net/onSendGridWebhook`
3. Selecionar eventos: **Bounced**, **Dropped**, **Deferred**, **Delivered**
4. Ativar **Signed Event Webhook** e copiar a verification key
5. Gravar a key como secret: `firebase functions:secrets:set SENDGRID_WEBHOOK_VERIFICATION_KEY`

> ⚠️ **Ação manual do utilizador** — Claude não tem acesso à internet para configurar o painel SendGrid.

---

### FASE 3 — Modelo e Status no Firestore ✅
**Esforço:** ~1 hora | **Risco:** Baixo | **Dependências:** Fase 2 | **Status:** Implementado

#### 3.1 Adicionar campo `inviteEmailStatus` ao documento `letters/{letterId}`

**Não requer migração** — Firestore é schemaless. Os documentos existentes simplesmente não terão o campo (tratar como `null` no Dart).

**Valores possíveis:** `sent` | `delivered` | `bounced` | `dropped` | `deferred` | `send_failed` | `null` (ainda não enviado ou carta para utilizador com conta)

> **⚠️ REVIEW (A5):** Adicionado `send_failed` — quando o SendGrid rejeita o envio inicial (excepção em `sendSendgridInvite`), o documento não deve ficar sem estado.

#### 3.2 Marcar `sent` quando o email é enviado com sucesso

**Ficheiro:** `functions/src/external_letters.ts` (linhas ~139-143)

No bloco `try/catch` existente, adicionar `inviteEmailStatus` em ambos os caminhos:

> **⚠️ REVIEW (A5):** O catch original apenas faz log — o documento fica sem estado. Adicionar `inviteEmailStatus: "send_failed"` no catch.

```typescript
try {
  await sendSendgridInvite({ to: to.trim(), subject, html });
  await snap.ref.update({
    inviteEmailSentAt: FieldValue.serverTimestamp(),
    inviteEmailStatus: "sent",
  });
  logger.info("external_invite_email_sent", { letterId });
} catch (e) {
  await snap.ref.update({
    inviteEmailStatus: "send_failed",
  });
  logger.error("external_invite_email_failed", { letterId, err: String(e) });
}
```

#### 3.3 Atualizar modelo Dart `Letter`

**Ficheiro:** `lib/features/letters/models/letter.dart`

> **⚠️ REVIEW (B2):** Usar enum em vez de strings soltas para evitar typos e permitir `switch` exaustivo.

Adicionar enum e campos:
```dart
enum InviteEmailStatus { sent, delivered, bounced, dropped, deferred, sendFailed;
  static InviteEmailStatus? fromString(String? value) {
    if (value == null) return null;
    if (value == 'send_failed') return sendFailed;
    return InviteEmailStatus.values.where((e) => e.name == value).firstOrNull;
  }
}
```

Adicionar campos ao `Letter`:
```dart
final InviteEmailStatus? inviteEmailStatus;
final DateTime? inviteEmailStatusUpdatedAt;
final String? receiverEmail;
```

Atualizar o `factory Letter.fromFirestore(...)` para ler estes campos:
```dart
inviteEmailStatus: InviteEmailStatus.fromString(data['inviteEmailStatus'] as String?),
inviteEmailStatusUpdatedAt: data['inviteEmailStatusUpdatedAt'] != null
    ? (data['inviteEmailStatusUpdatedAt'] as Timestamp).toDate()
    : null,
receiverEmail: data['receiverEmail'] as String?,
```

> **Nota:** O modelo actual não inclui `deliveryMode`, `receiverHasAccount`, etc. Considerar criar um sub-objecto `ExternalDeliveryInfo` agrupando todos os campos de envio externo, ou adicionar apenas os necessários para a UI (como acima).

---

### FASE 4 — Notificação ao Remetente ✅
**Esforço:** ~2 horas | **Risco:** Médio | **Dependências:** Fase 2 e 3 | **Status:** Implementado (ARBs + webhook handler)

#### 4.1 Notificação in-app (Firestore)

Já coberto no webhook handler (Fase 2.2). O documento em `users/{senderUid}/notifications/{id}` segue o **mesmo schema** das notificações de moderação existentes:

```json
{
  "type": "email_bounce",
  "letterId": "abc123",
  "email": "destinatario@invalido.com",
  "reason": "550 User not found",
  "title": "Email não entregue",
  "body": "O email para destinatario@invalido.com não pôde ser entregue. Verifique o endereço e tente novamente.",
  "read": false,
  "createdAt": "..."
}
```

#### 4.2 Push notification (FCM)

> **⚠️ REVIEW (A2):** O push FCM deve ser enviado **APÓS** `batch.commit()` ter sucesso, não dentro do loop. Se o commit falhar, o push já teria sido enviado — o utilizador receberia notificação de algo não persistido.
>
> **⚠️ REVIEW (A4):** Só notificar em `bounce` e `dropped` (estados finais). O evento `deferred` significa que o SendGrid vai re-tentar automaticamente — notificar causaria alarme desnecessário.

A implementação corrigida já está incluída no código da secção 2.2, com:
- Array `pendingFcm` preenchido durante o loop
- `Promise.allSettled(pendingFcm.map(...))` executado **após** todos os `batch.commit()`
- Filtragem por `NOTIFY_EVENTS` (bounce/dropped apenas)

#### 4.3 Textos localizados para notificações

> **⚠️ REVIEW (B4):** Adoptar Opção B (ler `preferredLanguage` do doc do utilizador). Já implementado na secção 2.2.

**Templates no servidor** (já incluídos em `sendgrid_webhook.ts`):
```typescript
const bounceMessages: Record<string, { title: string; body: string }> = {
  en: { title: "Email not delivered", body: "The email to {email} could not be delivered. Check the address and try again." },
  pt: { title: "Email não entregue", body: "O email para {email} não pôde ser entregue. Verifique o endereço e tente novamente." },
  es: { title: "Email no entregado", body: "El email a {email} no pudo ser entregado. Verifica la dirección e inténtalo de nuevo." },
};
```

**Pré-requisito:** Garantir que o campo `preferredLanguage` existe no documento do utilizador (`users/{uid}`). Se ainda não existir, adicionar ao fluxo de registo/settings com default `"en"`.

**Para notificações in-app (ARB — Flutter):**

Adicionar nos ficheiros ARB:
- `"notificationEmailBounceTitle": "Email not delivered"`
- `"notificationEmailBounceBody": "The email to {email} could not be delivered. Check the address and try again."`
- `"notificationEmailSendFailedTitle": "Email could not be sent"`
- `"notificationEmailSendFailedBody": "The email to {email} could not be sent. Try again later."`

---

### FASE 5 — UI — Exibição no App ✅
**Esforço:** ~2-3 horas | **Risco:** Baixo | **Dependências:** Fase 3 e 4 | **Status:** Implementado

#### 5.1 Expandir tela de notificações para tipo `email_bounce`

**Ficheiro:** `lib/features/profile/presentation/screens/moderation_notifications_screen.dart`

A tela atual lê `users/{uid}/notifications` e exibe por tipo. Adicionar handling para `type == "email_bounce"`:
- Ícone diferente (ex: `Icons.email_outlined` com cor vermelha)
- Ao tocar: navegar para a carta (`letterId`) ou abrir modal de reenvio

> **⚠️ REVIEW:** Manter o ficheiro `moderation_notifications_screen.dart` com o nome actual nesta fase — adicionar o handling de `email_bounce` primeiro. O rename para `notifications_screen.dart` deve ser feito como refactor separado para não misturar preocupações no mesmo commit.

#### 5.2 Badge/alerta na tela de detalhes da carta

**Ficheiro:** `lib/features/letters/presentation/screens/letter_detail_screen.dart`

Quando `letter.inviteEmailStatus` indica falha:
```dart
if (letter.inviteEmailStatus == InviteEmailStatus.bounced ||
    letter.inviteEmailStatus == InviteEmailStatus.dropped ||
    letter.inviteEmailStatus == InviteEmailStatus.sendFailed)
  Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.red.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        const Icon(Icons.warning_amber_rounded, color: Colors.red),
        const SizedBox(width: 8),
        Expanded(child: Text(l10n.notificationEmailBounceBody(letter.receiverEmail ?? ''))),
        TextButton(
          onPressed: () => _showResendDialog(),
          child: Text(l10n.resendEmail),
        ),
      ],
    ),
  ),
```

#### 5.3 Ação de reenviar / editar email

Criar um dialog/bottom sheet que permite:
1. Ver o email original que falhou
2. Editar o email do destinatário
3. Reenviar — chama uma nova Cloud Function `resendExternalInviteEmail` que:
   - Atualiza `receiverEmail` e `receiverEmailNormalized` no doc da carta
   - Reenvia o email via SendGrid
   - Reseta `inviteEmailStatus` para `sent`

> **⚠️ REVIEW (B3):** Implementar rate limiting — sem limite, um utilizador pode enviar spam de reenvios. Usar campo `lastResendAt` no documento da carta com cooldown de 5 minutos.

**Nova Cloud Function:** `functions/src/external_letters.ts`
```typescript
export const resendExternalInviteEmail = onCall(
  { region: "us-central1", secrets: [sendgridApiKey] },
  async (req) => {
    if (!req.auth?.uid) throw new HttpsError("unauthenticated", "Sign in required");
    const { letterId, newEmail } = req.data as { letterId: string; newEmail?: string };

    const db = getFirestore();
    const letterRef = db.doc(`letters/${letterId}`);
    const letterDoc = await letterRef.get();
    if (!letterDoc.exists) throw new HttpsError("not-found", "Letter not found");

    const data = letterDoc.data()!;
    if (data.senderUid !== req.auth.uid) throw new HttpsError("permission-denied", "Not the sender");

    // Rate limiting: cooldown de 5 minutos
    const lastResend = data.lastResendAt?.toDate();
    if (lastResend && Date.now() - lastResend.getTime() < 5 * 60 * 1000) {
      throw new HttpsError("resource-exhausted", "Please wait before resending");
    }

    const email = newEmail?.trim() || data.receiverEmail;
    if (!email) throw new HttpsError("invalid-argument", "No email");

    await sendSendgridInvite({ to: email, subject: "...", html: "..." });
    await letterRef.update({
      receiverEmail: email,
      receiverEmailNormalized: normalizeReceiverEmailForMatching(email),
      inviteEmailStatus: "sent",
      inviteEmailSentAt: FieldValue.serverTimestamp(),
      lastResendAt: FieldValue.serverTimestamp(),
    });

    return { success: true };
  }
);
```

---

### FASE 6 — Firestore Rules ✅
**Esforço:** ~15 min | **Risco:** Baixo | **Dependências:** Fase 3 | **Status:** Implementado — pendente `firebase deploy --only firestore:rules`

**Ficheiro:** `firestore.rules`

As regras atuais já permitem que o sender leia a carta (linha 78: `resource.data.senderUid == request.auth.uid`). O campo `inviteEmailStatus` é **escrito apenas pelo Admin SDK** (Cloud Functions), que bypassa as rules.

> **⚠️ REVIEW (C3 — CRÍTICO):** As regras actuais permitem que sender/receiver alterem **qualquer campo**, incluindo `senderUid`, `receiverUid`, `createdAt`, etc. A correcção deve proteger **todos** os campos imutáveis, não apenas os novos campos de email.

**Regra corrigida:**
```
allow update: if signedIn()
  && (resource.data.senderUid == request.auth.uid
      || resource.data.receiverUid == request.auth.uid)
  && !request.resource.data.diff(resource.data).affectedKeys().hasAny([
    'senderUid', 'receiverUid', 'createdAt',
    'inviteEmailStatus', 'inviteEmailStatusUpdatedAt', 'inviteEmailStatusReason',
    'inviteEmailSentAt', 'receiverEmailNormalized', 'deliveryMode', 'lastResendAt'
  ]);

allow delete: if signedIn()
  && resource.data.senderUid == request.auth.uid;
```

**Nota:** `delete` restringido apenas ao sender (antes era sender OU receiver). Separado do `update` para granularidade.

---

### FASE 7 — Testes ✅ (parcial)
**Esforço:** ~2 horas | **Risco:** Baixo | **Dependências:** Todas as fases anteriores | **Status:** Testes unitários implementados e passando; testes de rules e E2E pendentes deploy

#### 7.1 Teste unitário — Validators.isValidEmail (Flutter)

```dart
import 'package:openwhen/core/utils/validators.dart';
import 'package:test/test.dart';

void main() {
  group('Validators.isValidEmail', () {
    test('aceita emails válidos', () {
      expect(Validators.isValidEmail('user@domain.com'), isTrue);
      expect(Validators.isValidEmail('user+tag@domain.co.uk'), isTrue);
      expect(Validators.isValidEmail('  user@domain.com  '), isTrue); // trim
    });

    test('rejeita emails inválidos', () {
      expect(Validators.isValidEmail('user@domain'), isFalse);
      expect(Validators.isValidEmail('user@'), isFalse);
      expect(Validators.isValidEmail('@domain.com'), isFalse);
      expect(Validators.isValidEmail('user @domain.com'), isFalse);
      expect(Validators.isValidEmail('user@dom ain.com'), isFalse);
      expect(Validators.isValidEmail(''), isFalse);
    });
  });
}
```

#### 7.2 Teste do webhook handler

Criar payloads simulados no formato SendGrid e chamar a function localmente:
```bash
cd functions && npm test
```

Testar cenários: bounce com `letterId` válido, evento sem `letterId`, assinatura inválida, evento `delivered`, evento duplicado (idempotência), batch com >250 eventos.

#### 7.3 Testes de Firestore Rules

> **⚠️ REVIEW (B6):** Adicionar testes para verificar que clientes não podem alterar campos protegidos.

**Dependência:** instalar `@firebase/rules-unit-testing` no functions/:
```bash
cd functions && npm install --save-dev @firebase/rules-unit-testing
```

**Cenários a testar:**
1. Sender pode actualizar campos permitidos (ex: `isPublic`, `status`)
2. Sender **não pode** actualizar `inviteEmailStatus`, `senderUid`, `receiverUid`, `createdAt`
3. Receiver **não pode** actualizar campos protegidos
4. Utilizador sem relação com a carta **não pode** ler nem actualizar
5. Apenas sender pode apagar a carta

#### 7.4 Teste E2E manual

1. Enviar carta para email inexistente (ex: `test-bounce@simulator.amazonses.com` ou usar SendGrid bounce testing)
2. Aguardar webhook de bounce (~minutos)
3. Verificar no Firestore: campo `inviteEmailStatus: "bounced"` na carta
4. Verificar notificação em `users/{senderUid}/notifications`
5. Verificar push notification no dispositivo
6. Verificar UI: badge na carta + notificação na lista

---

## Ordem de Execução

```
FASE 1 (validators + cliente)  ──────►  ✅ Implementado
     │
FASE 2 (webhook + defineSecret)──────►  ✅ Deployed (secrets + SendGrid webhook configurados)
     │                                        │
FASE 3 (modelo + enum)         ◄──────────────┘  ✅ Implementado
     │
FASE 4 (notificação + i18n)    ──────►  ✅ Implementado + preferredLanguage sincronizado
     │
FASE 5 (UI + resend)           ──────►  ✅ Implementado
     │
FASE 6 (rules — imutáveis)     ──────►  ✅ Deployed
     │
FASE 7 (testes + rules tests)  ──────►  ✅ Unit tests passando — ⚠️ E2E pendente teste no dispositivo
```

## Progresso

| Fase | Status | Ficheiros alterados |
|------|--------|---------------------|
| Fase 1 — Validators + cliente | ✅ Feito | `validators.dart` (novo), `write_letter_screen.dart`, 4x ARBs |
| Fase 2 — Webhook + defineSecret | ✅ Deployed | `sendgrid_webhook.ts` (novo), `external_letters.ts`, `index.ts`, `.env` (removido SENDGRID_API_KEY — agora em Secret Manager) |
| Fase 3 — Modelo + enum + send_failed | ✅ Feito | `letter.dart` |
| Fase 4 — Notificações + i18n | ✅ Feito + preferredLanguage | 4x ARBs (novas keys), l10n gerado, `locale_provider.dart` (sync Firestore), `ensure_user_firestore_profile.dart`, `auth_repository.dart` |
| Fase 5 — UI + resend | ✅ Feito | `letter_detail_screen.dart`, `moderation_notifications_screen.dart` |
| Fase 6 — Firestore Rules | ✅ Deployed | `firestore.rules` |
| Fase 7 — Testes | ✅ Parcial | `validators_test.dart` (novo, 7/7 passando) — E2E pendente |

## Ações do utilizador (deploy)

- [x] `cd functions && npm install @sendgrid/eventwebhook`
- [x] Verificar se `SENDGRID_API_KEY` já está como secret. Se não, migrar de `.env`: `firebase functions:secrets:set SENDGRID_API_KEY`
- [x] `firebase functions:secrets:set SENDGRID_WEBHOOK_VERIFICATION_KEY`
- [x] Configurar Event Webhook no painel SendGrid (Fase 2.6)
- [x] `firebase deploy --only functions` (corrigido conflito `.env` vs Secret Manager)
- [x] `firebase deploy --only firestore:rules`
- [x] Garantir campo `preferredLanguage` no documento de utilizador (implementado: sync em `locale_provider.dart`, default em criação de perfil, fallback no webhook para campo `language`)
- [ ] Teste E2E no dispositivo real (Fase 7.4)

---

## Riscos e Mitigações

| Risco | Impacto | Mitigação |
|-------|---------|-----------|
| SendGrid não entrega webhook em tempo útil | Remetente fica sem feedback por horas | **B7:** Cloud Scheduler (cron) diário que marca cartas com `inviteEmailStatus: "sent"` há mais de 48h como `status_unknown` e notifica o remetente |
| Webhook recebe eventos duplicados | Atualiza Firestore múltiplas vezes | **A3 (implementado):** Verificação de idempotência no handler — skip se estado actual == evento ou se estado final (bounced/dropped) |
| `custom_args` não são retornados no webhook | Não consegue mapear evento → carta | Fallback: mapear por `receiverEmailNormalized` (pode ser ambíguo se mesmo email em múltiplas cartas) |
| Rate limit do FCM | Push notification não é entregue | Notificação in-app (Firestore) é o fallback primário; push é complementar; usar `Promise.allSettled` para não falhar silenciosamente |
| Batch excede 500 operações Firestore | Webhook retorna 500, SendGrid re-tenta | **A1 (implementado):** Chunking em lotes de 250 eventos |
| Spam de reenvio de email | Custo SendGrid, abuso | **B3 (implementado):** Cooldown de 5 min via campo `lastResendAt` |
| Envio inicial falha e doc fica sem estado | Carta fica em limbo sem feedback | **A5 (implementado):** Estado `send_failed` no catch block |

---

## Dead-letter / Cleanup (B7)

> **⚠️ REVIEW:** Implementação recomendada como fase futura.

Criar Cloud Scheduler (cron) que executa diariamente:
```typescript
export const cleanupStaleSentLetters = onSchedule(
  { schedule: "every 24 hours", region: "us-central1" },
  async () => {
    const db = getFirestore();
    const cutoff = new Date(Date.now() - 48 * 60 * 60 * 1000);
    const stale = await db.collection("letters")
      .where("inviteEmailStatus", "==", "sent")
      .where("inviteEmailSentAt", "<", cutoff)
      .limit(200)
      .get();
    // Marcar como status_unknown e notificar remetentes
  }
);
```
