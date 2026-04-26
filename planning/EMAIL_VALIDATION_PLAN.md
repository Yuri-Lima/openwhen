# Email Validation + Bounce Notification — Implementation Summary

> **Status:** ✅ Concluído (2026-04-11)  
> **Purpose:** External email validation + SendGrid bounce tracking + sender notifications  
> **Deployed:** Webhook, Cloud Functions, Firestore rules, Flutter UI, i18n  

---

## Resumo da Implementação

**Ficheiros criados:**
| Ficheiro | Descrição |
|----------|-----------|
| `lib/core/utils/validators.dart` | Email regex utility (reutilizável) |
| `functions/src/sendgrid_webhook.ts` | SendGrid webhook handler (bounce/dropped/deferred/delivered) |
| `test/core/validators_test.dart` | 7 unit tests — todos passando |

**Ficheiros editados:**
| Ficheiro | O quê |
|----------|-------|
| `write_letter_screen.dart` | Usar `Validators.isValidEmail()` em vez de `contains('@')` |
| `letter.dart` | Enum `InviteEmailStatus` + 3 campos (status, updatedAt, receiverEmail) |
| `external_letters.ts` | `defineSecret(SENDGRID_API_KEY)`, `customArgs`, `inviteEmailStatus: sent/send_failed`, callable `resendExternalInviteEmail` (rate limit 5 min) |
| `index.ts` | Exports de webhook + resend callable |
| `firestore.rules` | Proteger campos imutáveis (senderUid, receiverUid, createdAt, inviteEmailStatus, etc.) — delete apenas sender |
| `letter_detail_screen.dart` | Banner vermelho + dialog reenvio (se bounced/dropped/send_failed) |
| `moderation_notifications_screen.dart` | Handling `type == "email_bounce"` com ícone vermelho |
| `app_*.arb` (4x) | Novas keys: bounce, sendFailed, resend messages |

---

## Contexto

Quando utilizador envia carta para email externo (sem conta):
1. Email validado no cliente com regex
2. Carta gravada no Firestore com `receiverEmail`
3. Cloud Function `onLetterCreatedSendExternalInviteEmail` envia via SendGrid
4. **Problema:** Se email não existe → silêncio total (remetente nunca sabe)

**Solução:** Webhook SendGrid + notificações in-app + UI para reenvio.

---

## Arquitetura

**3 componentes:**

1. **Client validation** — `Validators.isValidEmail()` regex (`lib/core/utils/validators.dart`)
2. **SendGrid webhook** — `onSendGridWebhook` (HTTP Cloud Function) recebe bounce/dropped/deferred/delivered, atualiza Firestore + notifica sender via FCM
3. **Firestore schema** — `inviteEmailStatus` enum (sent|delivered|bounced|dropped|deferred|send_failed), `inviteEmailStatusUpdatedAt`, `receiverEmail`

---

## Campos Firestore

**Enum `InviteEmailStatus`:**
```
sent | delivered | bounced | dropped | deferred | send_failed | null
```

**Novos campos no modelo `Letter`:**
- `inviteEmailStatus: InviteEmailStatus?` — status do envio ao email externo
- `inviteEmailStatusUpdatedAt: DateTime?` — último update do status (via webhook)
- `receiverEmail: String?` — email do destinatário (para reenvio/edição)

---

## Cloud Functions

| Função | Descrição |
|--------|-----------|
| `onSendGridWebhook` | HTTP endpoint que recebe eventos SendGrid, atualiza `inviteEmailStatus` em batch (≤250 eventos), notifica sender apenas se bounce/dropped, envia FCM após commit |
| `onLetterCreatedSendExternalInviteEmail` | Trigger ao criar carta → tenta enviar via SendGrid → marca como `sent` ou `send_failed` |
| `resendExternalInviteEmail` | Callable → permite sender re-enviar com email novo/antigo (rate limit 5 min) |

---

## Deploy / Configuração

**Secrets necessárias:**
- `SENDGRID_API_KEY` — já existente (migrada de `.env` para Secret Manager)
- `SENDGRID_WEBHOOK_VERIFICATION_KEY` — obtida no painel SendGrid (Signed Event Webhook)

**Webhook URL (no painel SendGrid):**
```
https://us-central1-whenote-923f5.cloudfunctions.net/onSendGridWebhook
```

**Eventos a ativar:** Bounced, Dropped, Deferred, Delivered

**Dependências npm:** `npm install @sendgrid/eventwebhook`

**Deploy:**
```bash
firebase deploy --only functions
firebase deploy --only firestore:rules
```

---

## Referências

- **PRODUCTION.md §5** — Setup completo (secrets, painel SendGrid, deploy)
- **ARCHITECTURE.md** — Diagrama de fluxo + decisões de design
- **Testes:** Unitários (validators) passando; E2E manual pendente

---

## Status Atual

- ✅ Validação cliente + webhook handler
- ✅ Enum + campos Firestore
- ✅ Notificações in-app + FCM
- ✅ UI (banner, dialog reenvio)
- ✅ Firestore rules protegidas
- ✅ i18n (en, pt, pt_BR, es)
- ⚠️ E2E test pendente (dispositivo real)
