# OpenWhen — Troubleshooting

Operational notes for **developers** when something fails in production or on device.  
**Configuração de produção** (`dart-define`, deploy Firebase): [PRODUCTION.md](PRODUCTION.md) · **QA em dispositivo:** [DEVICE_TESTING.md](DEVICE_TESTING.md).

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

## 2. Admin moderation screen — app closes when opening “Moderation (admin)”

### Cause (fixed in app)

Loads were started from `initState` and the **first line** of each async loader called **`setState` synchronously** — still during `initState`, which Flutter disallows. That can assert in debug or **terminate** the app on device.

### Fix

Loaders are scheduled with **`WidgetsBinding.instance.addPostFrameCallback`** so `setState` runs after the first frame. See [`lib/features/admin/presentation/admin_moderation_screen.dart`](../lib/features/admin/presentation/admin_moderation_screen.dart).

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

No Firebase Console → **Project settings → Cloud Messaging** → app `com.openwhen.app`:

- Carregar a **mesma chave APNs `.p8`** em **Development APNs auth key** (não só em Production). Builds de desenvolvimento/profile usam sandbox; sem isso aparece `I-FCM002022` e o SDK pode falhar em threads em background.

### 3) Isolar moderação (`moderateContent`) vs Firestore

Sem alterar a documentação Firestore, podes forçar o cliente a **ignorar** a moderação por IA:

```bash
flutter run --profile -d <device_id> --dart-define=SKIP_AI_MODERATION=true
```

Implementado em [`lib/features/feed/presentation/screens/comments_screen.dart`](../lib/features/feed/presentation/screens/comments_screen.dart): com `SKIP_AI_MODERATION=true`, o fluxo deixa de chamar `moderateContent` e vai direto ao Firestore.

- Se o crash **parar**, investigar **Cloud Functions** / callable / região.
- Se **continuar**, foco em **Firestore** ou **FCM** (threads paralelas).

### 4) Entitlement `aps-environment` (Push)

Se o Xcode mostrar **`no valid "aps-environment" entitlement string found`**, o alvo iOS **não tinha** a capability de push no ficheiro de entitlements. O projeto usa [`ios/Runner/Runner.entitlements`](../ios/Runner/Runner.entitlements) com `aps-environment` = **`development`** (Debug/Profile) e [`ios/Runner/RunnerRelease.entitlements`](../ios/Runner/RunnerRelease.entitlements) com **`production`** (Release / App Store).

No [Apple Developer](https://developer.apple.com/account/resources/identifiers/list), o App ID `com.openwhen.app` deve ter **Push Notifications** ativado; no Xcode, **Signing & Capabilities** pode incluir **Push Notifications** (o perfil de provisioning tem de corresponder).

### 5) Bundle ID e Apple Team

- O **Runner** deve usar **`com.openwhen.app`**, alinhado com [`ios/Runner/GoogleService-Info.plist`](../ios/Runner/GoogleService-Info.plist) (`BUNDLE_ID`) e com a app registada no Firebase.
- `DEVELOPMENT_TEAM` no Xcode (`project.pbxproj`) é o **Team** que assina a app. A **APNs Authentication Key** no Firebase deve pertencer ao **mesmo** Apple Developer Program que possui o App ID `com.openwhen.app`, caso contrário push/APNs ficam inconsistentes. Se o Team ID no Firebase (chave APNs) for diferente do Team do Xcode, alinha assinatura ou chave no projeto Firebase certo.

---

## 6. Quick reference — deploy rules

```bash
firebase deploy --only firestore:rules,storage
```

Validate main flows after deploy ([DEVICE_TESTING.md](DEVICE_TESTING.md)).

---

*Português (resumo):* falhas ao **enviar carta** → verificar regras Firestore deployadas e blocos `letters` / `users` / `users/{uid}/badgeUnlocks` em [`firestore.rules`](../firestore.rules). **Moderação (admin)** a fechar a app → correcção: carregar dados **após** o primeiro frame (ficheiro `admin_moderation_screen.dart` acima). **`SIGABRT` ao comentar** → secção 4 acima (Xcode backtrace, APNs Development no Firebase, `SKIP_AI_MODERATION`, bundle `com.openwhen.app`, entitlement `aps-environment` em `Runner.entitlements`).
