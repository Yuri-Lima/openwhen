# OpenWhen — Troubleshooting

Operational notes for **developers** when something fails in production or on device.  
**Configuração de produção** (`dart-define`, deploy Firebase): [PRODUCTION.md](PRODUCTION.md) · **QA em dispositivo:** [PRODUCTION.md](PRODUCTION.md) (secção 9).

---

## 1. Send letter — `permission-denied` or “Could not save your letter”

### What it means

The client writes to Firestore in one **atomic transaction**: create `letters/{id}`, increment `users/{uid}.lettersSentCount`, and optionally create `users/{uid}/badgeUnlocks/{badgeId}` documents. If **any** of these operations is rejected by **Security Rules**, the whole transaction fails with `FirebaseException` code **`permission-denied`**. The UI may show a localized error; in builds that append the code, you will see e.g. `(permission-denied)`.

**Optional GPS / “10 m” at send time** does **not** go through Firestore rules. Denying precise location only affects optional `senderLocation` fields — it is **not** the usual cause of `permission-denied`.

### Common causes

| Cause | What to check |
|--------|----------------|
| **Rules not deployed** | Console rules differ from [`firestore.rules`](../firestore.rules). Deploy: `firebase deploy --only firestore:rules` |
| **`badgeUnlocks` create** | Rules require `unlockedAt` to match server time or a timestamp (see `badgeUnlocks` block in `firestore.rules`). Client uses `FieldValue.serverTimestamp()`. |
| **`users` update** | Rules require billing fields (`subscriptionTier`, Stripe IDs, `subscriptionStatus`) to stay **unchanged** on increment. Older user docs with missing vs `null` fields were a known edge case — rules use `.get('field', null)` for stable comparisons. |
| **Not signed in** | `senderUid` must equal `request.auth.uid` for `letters` create. |

### Code references

- Transaction: [`lib/features/letters/data/letter_send_service.dart`](../lib/features/letters/data/letter_send_service.dart)
- UI / steps: [`lib/features/letters/presentation/screens/write_letter_screen.dart`](../lib/features/letters/presentation/screens/write_letter_screen.dart)
- Badge helpers (other flows): [`lib/features/gamification/badge_unlock_service.dart`](../lib/features/gamification/badge_unlock_service.dart)

### After wiping Firestore data in Console

Deleting collections (letters, follows, etc.) does **not** by itself block new writes. If you **kept** `users` documents but they are incomplete or inconsistent with rules (e.g. billing fields), profile updates during send can still fail — fix the user document or deploy the latest rules.

---

## 2. Admin moderation screen — app closes or `SIGABRT` when opening “Moderation (admin)”

### Causes (fixed / avoid regressions)

1. **Flutter lifecycle:** Loads were started from `initState` and the **first line** of each async loader called **`setState` synchronously** — still during `initState`, which Flutter disallows. That can assert in debug or **terminate** the app on device.

2. **Parallel Firebase HTTPS callables on iOS:** After fixing (1), starting **all** admin callables **at once** (`getModerationInfo`, list reports, feedback, reviews, incidents) still stressed the **native** Firebase iOS stack and correlated with **`SIGABRT`** on device (terminal often only shows `__pthread_kill`; use Xcode **`bt all`** to see the real module).

### Fixes (do not undo)

- Schedule work with **`WidgetsBinding.instance.addPostFrameCallback`** so the first `setState` from loaders runs **after** the first frame.
- Run the five admin loaders **sequentially** (`_loadAllAdminData()` with `await` between each), **not** five parallel futures from the same callback.

See [`lib/features/admin/presentation/admin_moderation_screen.dart`](../lib/features/admin/presentation/admin_moderation_screen.dart).

### Common mistake when debugging `SIGABRT`

**`--dart-define=SKIP_AI_MODERATION=true`** only skips the **`moderateContent`** callable in [`comments_screen.dart`](../lib/features/feed/presentation/screens/comments_screen.dart). It does **not** affect the admin screen, which uses different **`admin*`** callables. Use the sequential-load pattern above for admin; use Xcode backtraces if the crash persists (see §4).

### Still required for the feature

- User must have the **`admin` custom claim** (see [`lib/core/admin/admin_claims.dart`](../lib/core/admin/admin_claims.dart)).
- **Cloud Functions** for admin callables must be deployed and region must match `FUNCTIONS_REGION` (see [PRODUCTION.md](PRODUCTION.md) §2).

---

## 3. iOS — `EXC_BAD_ACCESS` on `DartWorker` after launch

A **native crash** in a Dart isolate worker (not a normal Dart `Exception`). Often **intermittent** or **debug-build** specific.

**Try:** `flutter run --release` on a physical device; update Flutter; get a full crash log from Xcode (Organizer → Crashes). Not specific to “send letter” unless it reproduces only on that flow.

---

## 4. iOS — `SIGABRT` ao enviar comentário (profile / debug no dispositivo)

### O que é

`SIGABRT` em thread nativa (`Task`, `com.apple.root.user-initiated-qos`) — **abort** em código nativo (Firebase SDK, gRPC, etc.), não uma exceção Dart no `catch`. O terminal só mostra `__pthread_kill`; falta o **módulo** que falhou.

### 1) Capturar causa no Xcode (obrigatório para cravar)

1. Abrir [`ios/Runner.xcworkspace`](../ios/Runner.xcworkspace) no Xcode.
2. **Product → Scheme → Edit Scheme → Run**: se precisar reproduzir em Profile, duplicar o scheme ou usar **Profile** como build configuration.
3. Correr no iPhone; ao crashar, no painel de debug **ler linhas acima** do abort (ex.: `FirebaseMessaging`, `Firestore`, `FIRAssert`, `NSException`).
4. No debugger **(lldb)**: `bt all` ou abrir o **backtrace** de outras threads além da frame zero — ver frames com nome de biblioteca (ex.: `FirebaseFirestore`, `grpc`).

### 2) Firebase Cloud Messaging — APNs em Development

No Firebase Console → **Project settings → Cloud Messaging** → app iOS cujo `BUNDLE_ID` em [`ios/Runner/GoogleService-Info.plist`](../ios/Runner/GoogleService-Info.plist) corresponde ao **Runner**:

- Carregar a **mesma chave APNs `.p8`** em **Development APNs auth key** (não só em Production). Builds de desenvolvimento/profile usam sandbox; sem isso aparece `I-FCM002022` e o SDK pode falhar em threads em background.

### 3) Isolar moderação (`moderateContent`) vs Firestore

Sem alterar a documentação Firestore, podes forçar o cliente a **ignorar** a moderação por IA:

```bash
flutter run --profile -d <device_id> --dart-define=SKIP_AI_MODERATION=true
```

Implementado em [`lib/features/feed/presentation/screens/comments_screen.dart`](../lib/features/feed/presentation/screens/comments_screen.dart): com `SKIP_AI_MODERATION=true`, o fluxo deixa de chamar `moderateContent` e vai direto ao Firestore.

- Se o crash **parar**, investigar **Cloud Functions** / callable / região.
- Se **continuar**, foco em **Firestore** ou **FCM** (threads paralelas).

**Nota:** isto **não** isola o ecrã **Moderação (admin)** (callables `admin*`). Para esse ecrã, ver **§2** (cargas sequenciais, não paralelas).

### 4) Entitlement `aps-environment` (Push)

Se o Xcode mostrar **`no valid "aps-environment" entitlement string found`**, o alvo iOS **não tinha** a capability de push no ficheiro de entitlements. O projeto usa [`ios/Runner/Runner.entitlements`](../ios/Runner/Runner.entitlements) com `aps-environment` = **`development`** (Debug/Profile) e [`ios/Runner/RunnerRelease.entitlements`](../ios/Runner/RunnerRelease.entitlements) com **`production`** (Release / App Store).

No [Apple Developer](https://developer.apple.com/account/resources/identifiers/list), o **App ID** do Runner (mesmo string que `PRODUCT_BUNDLE_IDENTIFIER` no Xcode) deve ter **Push Notifications** ativado; no Xcode, **Signing & Capabilities** pode incluir **Push Notifications** (o perfil de provisioning tem de corresponder).

### 5) Bundle ID e Apple Team

- O **Runner** `PRODUCT_BUNDLE_IDENTIFIER` deve coincidir com `BUNDLE_ID` em [`ios/Runner/GoogleService-Info.plist`](../ios/Runner/GoogleService-Info.plist) e com a app iOS registada no Firebase (mesmo projeto).
- `DEVELOPMENT_TEAM` no Xcode (`project.pbxproj`) é o **Team** que assina a app. A **APNs Authentication Key** no Firebase deve pertencer ao **mesmo** Apple Developer Program que possui esse App ID, caso contrário push/APNs ficam inconsistentes. Se o Team ID no Firebase (chave APNs) for diferente do Team do Xcode, alinha assinatura ou chave no projeto Firebase certo.

---

## 5. iOS 26.x — `SIGABRT` na startup / `HTTPSCallable.call()` crash nativo

### Causa raiz

`cloud_functions: 6.1.0` + iOS 26.x (confirmado em 23E246, 23F5043k): a chamada `HTTPSCallable.call()` causa `SIGABRT` em `libswift_Concurrency.dylib` / `swift_task_dealloc_specific` / `asyncLet_finish_after_task_completion` no gRPC/Swift concurrency. É um crash **nativo**, não capturável por Dart `try-catch`.

**Crash confirmado em 2026-04-11** (iOS 26.5, 23F5043k, iPhone 14, TestFlight): Thread 25 — `libswift_Concurrency.dylib` frames 4-8, `FirebaseFunctions` frames 9-14 (`HTTPSCallable.call`, closures async, specialized thunks). Crash ocorre ao abrir **Moderação (admin)** em Settings (primeira callable `adminGetModerationInfo`).

### Regra de ouro

**NUNCA** chamar uma callable Firebase na startup do app (initState do HomeScreen, AuthWrapper, etc.). Callables só devem ser chamadas por ação do usuário (tap) ou em telas lazy (Plans, Admin, etc.) com `addPostFrameCallback`.

### Padrão obrigatório: `CallableQueue`

Todas as callables HTTPS usam [`CallableQueue.enqueue()`](../lib/core/services/callable_queue.dart) — mutex FIFO global com cooldown de 600ms. Impede sobreposição de callables nativas.

### Checklist de diagnóstico (Xcode)

Ao investigar um crash nativo de callable:

1. Abrir o `.ips` / crash log completo no Xcode Organizer
2. Procurar frames com: `swift_task_dealloc`, `swift_task_cancel`, `asyncLet_finish_after_task_completion`, gRPC channel teardown
3. Identificar em qual Thread o abort ocorre (normalmente thread auxiliar, não main)
4. Comparar: reproduzir o mesmo build em **iOS estável** (18.x) vs **26 beta** — se só crasha em 26.x, é regressão do SO/SDK
5. Verificar `CallableQueue` logs em debug: `[CallableQueue] start:` / `[CallableQueue] done:` — confirmar que não há sobreposição

### Critérios de sucesso após mitigação

- Monitorar crash reports no Xcode Organizer / TestFlight por **48–72 h** após cada build
- Sucesso: zero crashes `libswift_Concurrency.dylib` na mesma versão iOS
- Se crash persistir: aumentar `_cooldown` em `callable_queue.dart` (ver baseline atual) e repetir ciclo

### Upstream tracking

**Causa raiz upstream:** Swift 6.3 compiler regression (Xcode 26.4) — `async let` teardown gera código incorreto em builds otimizados. Firebase iOS SDK usa `async let` em `FunctionsContextProvider.context()`, causando crash em release/profile. Não afeta debug builds (`-Onone`).

| Issue | Estado |
|-------|--------|
| [`firebase/firebase-ios-sdk#15974`](https://github.com/firebase/firebase-ios-sdk/issues/15974) | Fix merged |
| [`firebase/firebase-ios-sdk#16013`](https://github.com/firebase/firebase-ios-sdk/issues/16013) | Duplicado |
| [`firebase/flutterfire#18153`](https://github.com/firebase/flutterfire/issues/18153) | Aguarda BoM com iOS SDK 12.12.0 |
| [PR #15991](https://github.com/firebase/firebase-ios-sdk/pull/15991) | Merged — substitui `async let` por `Task` |

**Fix:** Firebase iOS SDK **12.12.0** (lançado 2026-04-06). FlutterFire `cloud_functions: 6.1.0` depende de `~> 12.9.0` (Podfile.lock), que **não** inclui 12.12.0 automaticamente.

**Override individual de pod NÃO funciona:** o plugin `firebase_core` do FlutterFire fixa **todos** os pods Firebase na mesma versão (`12.9.0`). Adicionar `pod 'FirebaseFunctions', '~> 12.12.0'` ao Podfile causa conflito em `pod install`. A solução definitiva requer um novo FlutterFire BoM (>= 4.12.0) que inclua iOS SDK 12.12.0+.

**Mitigação definitiva (client-side, 2026-04-12):** `SafeCallable` — no iOS, todas as callables são invocadas via HTTP direto (`package:http`) em vez do SDK nativo, bypassing completamente o código Swift com `async let`. No Android/web, usa o SDK normalmente. Todas as chamadas continuam serializadas pelo `CallableQueue` com cooldown de 600ms.

**Quando BoM atualizar:** executar `flutter pub upgrade`, depois `cd ios && pod install --repo-update` e testar no dispositivo físico em profile/release. Após confirmar que o SDK 12.12.0+ está no `Podfile.lock`, o fallback HTTP pode ser removido (basta mudar `_useHttpFallback` para `false` em `safe_callable.dart`).

### Arquivos afetados

- `lib/core/services/safe_callable.dart` — HTTP fallback iOS + proxy para CallableQueue
- `lib/core/services/callable_queue.dart` — FIFO mutex global com cooldown
- `lib/main.dart` — HomeScreen NÃO chama callables no initState
- `lib/features/profile/presentation/screens/subscription_plans_screen.dart` — billing migration lazy
- `lib/core/billing/stripe_billing_provider.dart` — todas callables via SafeCallable
- `lib/core/admin/admin_functions_service.dart` — todas callables via SafeCallable
- `lib/core/moderation/moderation_functions_service.dart` — moderateContent via SafeCallable
- `lib/core/letters/external_letters_service.dart` — claimExternalLetters via SafeCallable
- `lib/features/letters/presentation/screens/letter_detail_screen.dart` — resendExternalInviteEmail via SafeCallable
- `lib/features/auth/presentation/screens/register_screen.dart` — checkUsernameAvailable via SafeCallable
- `lib/core/services/account_deletion_service.dart` — deleteUserAccount via SafeCallable
- `lib/core/billing/disabled_billing_provider.dart` — migrateUserBillingDefaults via SafeCallable

---

## 6. Delete account — fluxo e compliance

### Problema original (até abril/2026)

O botão "Deletar conta" em Settings executava:
1. `FirebaseFirestore.instance.collection('users').doc(uid).delete()` — sem try-catch
2. `_user?.delete()` — falhava silenciosamente com `requires-recent-login`
3. Dados órfãos: cartas, cápsulas, follows, likes, comments, storage, Stripe ficavam no sistema

### Correção implementada

1. **Re-autenticação:** `AccountDeletionService.reauthenticateWithPassword()` pede senha antes
2. **Escolha do usuário:** modal com opção "Excluir Tudo" vs "Anonimizar cartas"
3. **Cloud Function `deleteUserAccount`:** limpeza completa server-side (15 etapas, inclui Stripe, Storage, Auth)
4. **Loading overlay:** feedback visual durante processamento
5. **Tratamento de erros:** wrong-password, timeout, etc. com mensagens l10n

### Arquivos

- Cloud Function: `functions/src/delete_account.ts`
- Serviço client: `lib/core/services/account_deletion_service.dart`
- UI: `lib/features/profile/presentation/screens/settings_screen.dart` (`_DeleteAccountSheet`)
- Política: `planning/DATA_RETENTION_POLICY.md`

### Deploy necessário

```bash
firebase deploy --only functions:deleteUserAccount
```

### COPPA — checkbox idade 13+

Adicionado em `register_screen.dart`: checkbox obrigatório "Confirmo que tenho 13 anos ou mais" + aceite de Termos de Uso e Política de Privacidade. Registro bloqueado se desmarcados.

---

## 7. Quick reference — deploy rules

```bash
firebase deploy --only firestore:rules,storage
```

Validate main flows after deploy ([PRODUCTION.md](PRODUCTION.md) secção 9).

---

---

## 8. Email de convite externo — bounce / send_failed

### O que acontece

Quando um utilizador envia uma carta a um email externo sem conta, a Cloud Function `onLetterCreatedSendExternalInviteEmail` envia via SendGrid e define `inviteEmailStatus: "sent"`. Se o envio falha (SendGrid rejeita), fica `"send_failed"`. Se o email chega mas o destinatário não existe, o webhook `onSendGridWebhook` recebe um evento `bounce` ou `dropped` e atualiza o documento.

### O utilizador vê

- Banner vermelho no detalhe da carta (sender) com botão "Reenviar"
- Notificação in-app (tipo `email_bounce`) na tela de notificações
- Push FCM localizado (se `fcmToken` presente no doc do utilizador)

### Diagnóstico

| Sintoma | O que verificar |
|---------|-----------------|
| Email nunca chega e `inviteEmailStatus` fica `null` | Cloud Function `onLetterCreatedSendExternalInviteEmail` não deployed ou `SENDGRID_API_KEY` não definida como secret |
| `inviteEmailStatus: "send_failed"` | SendGrid rejeitou o envio — verificar logs da Cloud Function (`external_invite_email_failed`) e validade da API key |
| Webhook não actualiza status | Event Webhook não configurado no painel SendGrid, ou URL incorrecta, ou `SENDGRID_WEBHOOK_VERIFICATION_KEY` não bate |
| Webhook retorna 403 | Assinatura inválida — verificar que a verification key no secret Firebase corresponde à do painel SendGrid |
| Reenvio falha com "resource-exhausted" | Rate limiting — cooldown de 5 min entre reenvios (campo `lastResendAt` no documento) |
| Deploy falha com "Secret environment variable overlaps non secret environment variable" | `SENDGRID_API_KEY` existe simultaneamente em `functions/.env` e no Secret Manager. Remover a linha do `.env` — o `defineSecret()` usa apenas o Secret Manager. (Corrigido em 2026-04-11) |
| Notificações de bounce sempre em inglês | Campo `preferredLanguage` ausente no doc do utilizador. O webhook faz fallback: `preferredLanguage` → `language` (2 primeiros chars) → `"en"`. Utilizadores antigos sem o campo receberão a língua do campo `language` (`pt-BR` → `pt`). |

### Ficheiros relevantes

- Webhook: [`functions/src/sendgrid_webhook.ts`](../functions/src/sendgrid_webhook.ts)
- Envio + reenvio: [`functions/src/external_letters.ts`](../functions/src/external_letters.ts)
- Modelo Dart: [`lib/features/letters/models/letter.dart`](../lib/features/letters/models/letter.dart) (`InviteEmailStatus`)
- Banner UI: [`lib/features/letters/presentation/screens/letter_detail_screen.dart`](../lib/features/letters/presentation/screens/letter_detail_screen.dart)
- Validação: [`lib/core/utils/validators.dart`](../lib/core/utils/validators.dart)
- Config produção: [PRODUCTION.md](PRODUCTION.md) (secção "SendGrid — webhook de email bounce")
- Plano completo: [`EMAIL_VALIDATION_PLAN.md`](EMAIL_VALIDATION_PLAN.md)

---

## 9. Emails de auth vão para spam ou confirmação sem branding

### Causa raiz (corrigido 2026-04-12)

1. **Remetente genérico:** `noreply@openwhen-923f5.firebaseapp.com` não tem reputação nem SPF/DKIM
2. **Página de confirmação:** default do Firebase — texto plano sem branding
3. **Redirect pós-registro:** `RegisterScreen` ficava empilhada sobre `AuthWrapper`, utilizador não via o app após criar conta

### Correções aplicadas

- **SMTP SendGrid:** Firebase Auth envia emails via `smtp.sendgrid.net:587` (STARTTLS). Domínio `openwhen.live` autenticado no SendGrid (`em2352.openwhen.live`) com SPF/DKIM ativos.
- **Action URL customizada:** `https://openwhen.live/auth/action.html` — página dark theme com branding OpenWhen. Aplica-se globalmente (todos os templates).
- **Sender name:** "OpenWhen" nos 3 templates (verification, password reset, email change).
- **Redirect:** `Navigator.popUntil((route) => route.isFirst)` em `register_screen.dart` — volta ao `AuthWrapper` que redireciona à `HomeScreen`.

### Pendências

| Item | Estado |
|------|--------|
| `firebase deploy --only hosting` | ⏳ Necessário para publicar `auth/action.html` |
| Domínio remetente `noreply@openwhen.live` | ⏳ 4 registros DNS no Cloudflare (2 TXT + 2 CNAME DKIM). Ver [`PRODUCTION.md`](PRODUCTION.md) (secção "Email de autenticação"). |

### Se emails ainda forem para spam após a configuração

1. Verificar se o deploy do Hosting foi feito (`firebase deploy --only hosting`)
2. Verificar se os CNAMEs do SendGrid (`em2352.openwhen.live`) estão propagados: `dig CNAME em2352.openwhen.live`
3. Verificar no Firebase Console → Authentication → Templates → SMTP Settings que a password (API key SendGrid) está correta
4. Enviar email de teste criando uma conta nova; verificar headers SPF/DKIM no Gmail (⋮ → Show original)
5. Se o domínio customizado do remetente (`noreply@openwhen.live`) estiver configurado, verificar que os 4 registros DNS Firebase foram adicionados e verificados

### Ficheiros

- Página de ação: [`hosting/public/auth/action.html`](../hosting/public/auth/action.html)
- Templates HTML: `hosting/email-templates/verify-email.html`, `reset-password.html`
- Fix redirect: [`register_screen.dart`](../lib/features/auth/presentation/screens/register_screen.dart)
- Guia completo: [`EMAIL_SETUP.md`](EMAIL_SETUP.md)
- Config produção: [`PRODUCTION.md`](PRODUCTION.md) (secção "Email de autenticação")

---

*Português (resumo):* falhas ao **enviar carta** → verificar regras Firestore deployadas e blocos `letters` / `users` / `users/{uid}/badgeUnlocks` em [`firestore.rules`](../firestore.rules). **Moderação (admin)** a fechar / `SIGABRT` → secção **2**: `addPostFrameCallback` **e** callables admin **em série** (não disparar cinco HTTPS callables em paralelo); `SKIP_AI_MODERATION` só afecta **comentários**, não o admin. **`SIGABRT` ao comentar** → secção 4 (Xcode `bt all`, APNs Development no Firebase, `SKIP_AI_MODERATION`, bundle alinhado ao plist, entitlement `aps-environment` em `Runner.entitlements`). **Email bounce** → secção **8**: verificar secrets, webhook URL no painel SendGrid e logs das Cloud Functions. **Emails de auth em spam / sem branding** → secção **9**: SMTP SendGrid + Action URL customizada + deploy Hosting + DNS pendente para domínio remetente.
