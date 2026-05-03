# Whenote — Arquitetura técnica

## Visão geral

- **Cliente:** Flutter (multiplataforma: web, iOS, Android, etc.).
- **Backend:** Firebase (Auth, Cloud Firestore, Storage, Cloud Messaging).
- **Estado:** Riverpod (`flutter_riverpod`).
- **Navegação:** `MaterialApp` com `routes` nomeadas; telas adicionais via `Navigator` (`MaterialPageRoute`). O pacote `go_router` está no `pubspec` para evolução futura da navegação (ver [Navegação e `go_router`](#navegação-e-go_router)).

---

## Performance e carregamento diferido

- **Baseline:** como medir antes/depois (bundle web, DevTools, Firestore) — ver secção [Performance e carregamento diferido](#performance-e-carregamento-diferido) abaixo.
- **Code splitting (web):** [`lib/core/navigation/deferred_screens.dart`](../lib/core/navigation/deferred_screens.dart) importa em modo `deferred` as telas **Escrever carta**, **Nova cápsula** e **Buscar**; cada uma mostra um `CircularProgressIndicator` até `loadLibrary()` completar. As rotas nomeadas `/write`, `/create-capsule` e `/search` em [`main.dart`](../lib/main.dart) usam estes shells.
- **Exportação PDF/ZIP (por carta):** [`lib/features/letters/export/letter_export_deferred.dart`](../lib/features/letters/export/letter_export_deferred.dart) importa [`letter_export_service.dart`](../lib/features/letters/export/letter_export_service.dart) em modo `deferred`; o chunk com `pdf` / `archive` só é carregado quando o utilizador exporta (detalhe da carta).
- **Exportação completa de dados (GDPR Art. 20):** [`lib/core/export/complete_export_service.dart`](../lib/core/export/complete_export_service.dart) — exporta todos os dados do utilizador (perfil, cartas, cápsulas, comentários, likes, follows, badges) em ficheiros JSON + media num ZIP. Queries Firestore paginadas (500/batch), sanitização de campos internos, validação SSRF de URLs de media. Acesso via Settings > Data and Privacy > Export my data (gratuito, sem restrição de tier). Progress callback com estágios para feedback na UI.
- **Cofre — abas:** o corpo do cofre mostra **apenas a aba selecionada** (sem `TabBarView` que montava as três de uma vez), reduzindo listeners Firestore simultâneos. **Swipe horizontal entre abas** deixou de estar disponível; mudança só por toque nas tabs.

### Navegação e `go_router`

Uma migração futura para `go_router` pode declarar rotas com `pageBuilder` e reutilizar os mesmos padrões `deferred` (ou `NoTransitionPage` + carregamento assíncrono). Não há roteador `go_router` ativo no código; mantém-se `MaterialApp.routes` + `Navigator` até haver refactor dedicado.

---

## Estrutura de pastas (`lib/`)

```
lib/
├── main.dart
├── firebase_options.dart          # FlutterFire — versionado para whenote-923f5; regenerar com FlutterFire CLI se mudar de projeto
├── core/
│   ├── navigation/
│   │   ├── deferred_screens.dart  # Shells FutureBuilder + import deferred (WriteLetter, CreateCapsule, Search)
│   │   └── home_tab_provider.dart # Índice do separador principal (Feed / Cofre / Perfil)
│   ├── admin/                     # AdminFunctionsService — callables com claim `admin` (filas, incidentes, info de moderação)
│   ├── billing/                   # BillingProvider, StripeBillingProvider, tier guard, feature flags (BILLING_ENABLED)
│   ├── config/
│   │   ├── system_config_provider.dart  # `systemConfig/app`: reportsEnabled, aiModerationEnabled, aiModerationFailClosed
│   │   └── facebook_app_config.dart  # `FB_APP_ID` (dart-define) para Instagram Sharing to Stories
│   ├── constants/
│   │   └── firestore_collections.dart # Constantes nomeadas (subset; outras coleções usadas inline)
│   ├── export/
│   │   └── complete_export_service.dart # Export completo GDPR Art. 20: ZIP com JSONs + media
│   ├── linking/
│   │   └── share_link_service.dart      # Flutter wrapper para callables de share (generateShareLink, claimShareLink, revokeShareLink)
│   ├── utils/
│   │   ├── email_normalization.dart   # normalizeReceiverEmailForMatching (must match server)
│   │   ├── validators.dart            # Validators.isValidEmail — regex reutilizável (B1)
│   │   └── age_verification.dart     # validateAge — idade mínima por jurisdição (GDPR Art. 8 / COPPA)
│   └── moderation/
│       └── moderation_functions_service.dart  # Callable `moderateContent` (região igual a billing)
├── features/
│   ├── auth/
│   │   ├── data/auth_service.dart
│   │   ├── domain/auth_repository.dart
│   │   ├── models/app_user.dart
│   │   └── presentation/
│   │       ├── providers/auth_provider.dart
│   │       └── screens/ (splash, login, register, onboarding)
│   ├── letters/
│   │   ├── domain/
│   │   │   ├── draft_model.dart             # LetterDraft — modelo com expiração 30 dias, fromFirestore/toFirestore
│   │   │   └── draft_service.dart           # CRUD Firestore, TTL fallback, migração SharedPrefs, limite 10/user
│   │   ├── export/
│   │   │   ├── letter_export_service.dart
│   │   │   └── letter_export_deferred.dart  # API fina: loadLibrary + share* (chunk pdf/archive)
│   │   ├── models/
│   │   └── presentation/
│   │       ├── models/
│   │       │   └── emotional_state.dart     # EmotionalState extraído (evita dep. circular write↔drafts)
│   │       ├── screens/ (write, vault, detail, opening, requests, qr, drafts)
│   │       ├── vault_list_filters.dart   # estado de filtros por aba + sort/filtro em memória sobre snapshots
│   │       ├── widgets/ (vault_filter_sheet — bottom sheet de filtro/ordenação)
│   │       └── voice_letter.dart    # conditional export: upload/delete ficheiro local (IO vs web stub)
│   ├── capsules/
│   │   └── presentation/screens/ (create_capsule)
│   ├── feed/
│   │   ├── domain/ (feed_letter_filter, feed_following_merge — filtro cliente e merge de chunks)
│   │   ├── models/
│   │   └── presentation/
│   │       ├── providers/ (feed_pinned_filters_provider — chips fixados, SharedPreferences)
│   │       ├── screens/ (feed, comments)
│   │       └── widgets/ (explore_feed_paged, following_feed_body, pinned_feed_filters_sheet)
│   └── profile/
│       └── presentation/screens/ (profile, user_profile, search, settings, legal, subscription_plans)
└── shared/
    ├── icons/
    │   └── whenote_icons.dart        # Caminhos `assets/icons/*.svg`; widget `WhenoteSvgIcon` (flutter_svg)
    ├── social/                        # Partilha para Instagram Stories (Meta Sharing to Stories)
    │   ├── story_share_content.dart   # Allowlist de campos para imagem 9:16 (sem mensagem/Q&A)
    │   ├── story_asset_builder.dart   # Overlay off-screen → PNG temporário
    │   ├── instagram_stories_platform.dart  # MethodChannel nativo
    │   └── instagram_stories_share_service.dart  # Orquestra nativo + fallback share_plus + limpeza de ficheiros
    ├── theme/
    │   └── app_theme.dart
    ├── utils/
    │   ├── music_url.dart             # Validação de URL https para link de música (cartas/cápsulas)
    │   ├── voice_url.dart             # Validação de URL de download Firebase Storage (voiceLetters/)
    │   ├── location_capture.dart      # `tryGetCurrentPosition()` (geolocator); constante `kProximityRadiusMeters` (10 m)
    │   ├── sender_location.dart       # Parse `senderLocation` do Firestore; URL Google Maps; copiar para clipboard
    │   ├── proximity_gate.dart        # Distância até o ponto ancorado vs. raio de produto
    │   ├── location_prompt_flow.dart  # Diálogos ao gravar carta/cápsula: partilhar GPS + opcional abertura só nos 10 m
    │   └── open_with_proximity.dart   # Navegação para `LetterOpeningScreen` / `CapsuleOpeningScreen` com gate no Cofre
    └── widgets/
        ├── owl_logo.dart              # OwlLogo, OwlSealOpeningAnimation, pintura do lacre/coruja
        ├── owl_feedback_affordance.dart  # Coruja tocável + animação idle; abre feedback sheet
        ├── feedback_entry_button.dart # Botão/FAB + showFeedbackSheet (sheet partilhado)
        ├── keyboard_dismiss_overlay_button.dart # Overlay global: botão “fechar teclado” quando há teclado virtual (MaterialApp.builder)
        ├── music_link_tile.dart       # Abrir link externo (url_launcher) + tile escuro “Ouvir música”
        ├── voice_letter_tile.dart     # Reprodução in-app (just_audio) — detalhe e abertura da carta
        └── location_share_tile.dart   # Tile escuro: toque copia link Maps (detalhe carta/cápsula)
```

**Ficheiros fora de `lib/` relevantes:**
- `functions/src/share_link.ts` — 4 Cloud Functions para share via link (`generateShareLink`, `getSharePreview`, `claimShareLink`, `revokeShareLink`).
- `hosting/public/open/index.html` — Landing page para share links (`whenote.app/open/{token}`).

**Assets na raiz do repositório:** `assets/icons/` — SVGs do kit (`currentColor`); `assets/branding/app_icon.png` — ícone mestre 1024×1024 para **flutter_launcher_icons** (Android `mipmap-*`, iOS `AppIcon.appiconset`). Após alterar a PNG: `dart run flutter_launcher_icons`.

Padrão **feature-first**: cada feature agrupa o que for necessário; auth mantém camadas `data` / `domain` / `presentation`.

### Partilha social / Instagram Stories

- **Meta App ID:** o cliente precisa do Facebook / Meta **App ID** registado para “Sharing to Stories”. Injetar em build com `--dart-define=FB_APP_ID=seu_id` (ver [`lib/core/config/facebook_app_config.dart`](../lib/core/config/facebook_app_config.dart)). Sem `FB_APP_ID`, o fluxo usa apenas o fallback (folha de partilha com PNG + texto). Checklist completo de produção: [`planning/PRODUCTION.md`](PRODUCTION.md).
- **iOS:** `LSApplicationQueriesSchemes` inclui `instagram` e `instagram-stories` em `Info.plist`; registo do channel em `AppDelegate` (`didInitializeImplicitFlutterEngine`).
- **Android:** `FileProvider` em `AndroidManifest.xml`, `res/xml/file_paths.xml` (cache), `<queries>` para `com.instagram.android`; `MainActivity` implementa o mesmo `MethodChannel`.

### Overlays globais (`MaterialApp.builder`)

Em [`lib/main.dart`](../lib/main.dart), o `builder` empilha widgets sobre o `Navigator`:

| Widget | Comportamento |
|--------|----------------|
| [`FeedbackEntryButton`](../lib/shared/widgets/feedback_entry_button.dart) | Visível quando o utilizador **não** tem sessão (canto superior direito); abre o sheet de feedback. |
| [`KeyboardDismissOverlayButton`](../lib/shared/widgets/keyboard_dismiss_overlay_button.dart) | Quando `MediaQuery.viewInsets.bottom > 0` (teclado virtual aberto), mostra um controlo pequeno acima do teclado; toque chama `FocusManager.instance.primaryFocus?.unfocus()`. Mesmo comportamento em todas as rotas e ecrãs. |

---

## Camadas (auth e extensível)

| Camada | Responsabilidade |
|--------|------------------|
| **data** | Implementação concreta (ex.: `AuthService` + Firebase) |
| **domain** | Contratos (`AuthRepository`) |
| **presentation** | UI, providers Riverpod |

Outras features hoje concentram-se em `presentation` + `models` conforme necessidade.

---

## Firebase

| Serviço | Uso |
|---------|-----|
| **Authentication + Identity Platform** | Sessão do usuário; blocking functions (`beforeUserCreated`) para anti-abuse |
| **Cloud Firestore** | Dados principais (usuários, cartas, drafts, social, cápsulas, moderação) |
| **Cloud Storage** | Avatares; fotos de carta manuscrita (`handwritten/`); mensagens de voz (`voiceLetters/`, áudio curto); mídia de cápsulas (`capsules/**`) — ver [`storage.rules`](../storage.rules) |
| **FCM** | Notificações push (Firebase Cloud Messaging; integrado no app — ver `MVP_CHECKLIST.md` 🔴) |

| **App Check** | Atestação de dispositivo (DeviceCheck iOS, Play Integrity Android). Enforced (`enforceAppCheck: true`) em todas as callable Cloud Functions. No iOS, `SafeCallable` envia token App Check via header HTTP `X-Firebase-AppCheck` (workaround para firebase-ios-sdk#15974). |

**Projeto Firebase (referência):** `whenote-923f5`

---

## Coleções Firestore

Constantes centralizadas em [`lib/core/constants/firestore_collections.dart`](../lib/core/constants/firestore_collections.dart): `users`, `letters`, `comments`, `likes`, `reports`, `capsules`, `follows`, `blocks`, `feedback`, `moderationIncidents`, `moderationReviews`, `deletionAuditLogs`, `systemConfig`.

Coleções também usadas no código (strings / queries):

| Coleção | Propósito |
|---------|-----------|
| `users` | Perfis |
| `letters` | Cartas agendadas/abertas |
| `likes` | Curtidas |
| `comments` | Comentários |
| `follows` | Relação seguidor/seguindo |
| `blocks` | Bloqueios |
| `capsules` | Cápsulas do tempo |
| `reports` | Denúncias de utilizadores (UGC) — schema fixo em `firestore.rules` |
| `moderationIncidents` | Alertas operacionais da moderação por IA (agregados por tipo + hora UTC); escrita só Admin SDK / Cloud Functions; leitura no app via `adminListModerationIncidents` |
| `systemConfig` | Documento `app`: feature flags remotas (`reportsEnabled`, `aiModerationEnabled`, `aiModerationFailClosed`, …); leitura autenticada, escrita só admin/backend |
| `drafts` | Rascunhos de carta — TTL Policy Firestore no campo `expiresAt` (30 dias); deleção automática server-side. Limite: 10/utilizador (`draftCount` no user doc). Service: [`draft_service.dart`](../lib/features/letters/domain/draft_service.dart) |
| `accountCreationLogs` | Auditoria anti-abuse — IP, provider, emailDomain, timestamp de cada criação de conta. Escrita: Admin SDK (Cloud Function `onUserCreated`). Leitura/escrita pelo cliente: **bloqueada** nas Firestore Rules. Usado para rate limiting (5 contas/IP/24h). Índice composto: `ip ASC, createdAt ASC`. |

### Busca de utilizadores

- **Implementação:** [`lib/core/user_search/user_search_service.dart`](../lib/core/user_search/user_search_service.dart) — não usa `collection('users').get()` para pesquisa; combina query por **prefixo de `username`** (range indexado) e **`searchTokens` com `array-contains`** (tokens derivados do nome público e do handle em [`user_search_tokens.dart`](../lib/core/user_search/user_search_tokens.dart)), com teto de **30** resultados por pedido; mínimo **2** caracteres na tela Buscar; API só expõe `uid`, `@username`, nome público e `photoUrl` (sem email na busca). **Observabilidade:** falhas nas queries Firestore são logadas com `debugPrint` protegido por `kDebugMode` (sem overhead em release, sem PII). **Limitação conhecida:** `array-contains` usa a query normalizada inteira; pesquisas com **múltiplas palavras** (ex.: nome completo) podem não bater nos tokens (gerados por palavra) — os utilizadores devem pesquisar por uma palavra ou `@username`.
- **Persistência:** `searchTokens` escrito em [`auth_repository.dart`](../lib/features/auth/domain/auth_repository.dart) (registo) e ao guardar perfil ([`edit_profile_screen.dart`](../lib/features/profile/presentation/screens/edit_profile_screen.dart)). Utilizadores antigos sem `searchTokens` podem ser encontrados por prefixo de `@username` até atualizarem o perfil.
- **Seguir na Buscar:** estado obtido com leituras em batch ([`user_search_follows.dart`](../lib/core/user_search/user_search_follows.dart)), não um listener Firestore por linha.
- **Histórico:** até ~abril/2026 o cliente carregava **todos** os documentos de `users` para filtrar em memória (Buscar, convite em cápsula coletiva, destinatário na carta) — problema de escala documentado em [`CHANGELOG.md`](CHANGELOG.md) e [`PRODUCTION.md`](PRODUCTION.md).

### Config remota (`systemConfig` / doc `app`)

Lido por [`lib/core/config/system_config_provider.dart`](../lib/core/config/system_config_provider.dart). Campos relevantes para moderação:

| Campo | Efeito |
|-------|--------|
| `reportsEnabled` | Se `false`, o feed não oferece denunciar (default: ligado se omitido). |
| `aiModerationEnabled` | Se `true`, o cliente chama `moderateContent` antes de publicar comentários (e futuras superfícies). |
| `aiModerationFailClosed` | Se **omitido** ou `true`, falha do provedor (rede, chave, API) **bloqueia** o envio no cliente; definir `false` para fallback “soft” (permite envio além da lista local de palavras). |

### Moderação de conteúdo

- **Cliente:** lista lexical em [`comments_screen.dart`](../lib/features/feed/presentation/screens/comments_screen.dart); denúncias em [`shared/moderation/report_flow.dart`](../lib/shared/moderation/report_flow.dart); opcionalmente IA quando `aiModerationEnabled` via [`ModerationFunctionsService`](../lib/core/moderation/moderation_functions_service.dart).
- **Servidor:** Firebase Cloud Functions em [`functions/src/moderation/`](../functions/src/moderation/) — adapter **OpenAI** (Moderation API) por defeito; `MODERATION_PROVIDER` reservado para mais provedores; fallback + coleção `moderationIncidents` em falhas. Ver [`functions/README.md`](../functions/README.md).
- **Superadmin:** [`AdminModerationScreen`](../lib/features/admin/presentation/admin_moderation_screen.dart) — quatro abas (denúncias, feedback, revisão humana, alertas IA); `TabBar` **rolável** (`isScrollable: true`) para rótulos completos em ecrãs estreitos; texto longo nos cartões com `SelectionArea` + scroll horizontal quando necessário; banner com `adminGetModerationInfo` (provedor efectivo e se a chave está configurada no runtime, sem expor segredos). Os dados são carregados **após** o primeiro frame (`addPostFrameCallback`) para não chamar `setState` durante `initState`, e os callables admin são invocados **em série** (`_loadAllAdminData`), não em paralelo — evita `SIGABRT` em iOS por stress no SDK nativo (ver [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md) §2).
- **Thresholds (compile-time):** definidos em `config/dart_defines.json` e lidos via `double.fromEnvironment()`. `MODERATION_WARNING_THRESHOLD` (default `0.40`) → dialog de aviso; `MODERATION_BLOCK_THRESHOLD` (default `0.70`) ou `flagged` → bloqueio. Detalhes completos: [`MODERATION.md`](MODERATION.md).
- **Moderação de media (Storage):** Cloud Function `moderateUploadedFile` com trigger `onObjectFinalized` — analisa imagens via OpenAI `omni-moderation-latest` (gratuito) e áudio via Whisper (transcrição) + moderação de texto. Detalhes: [`MODERATION.md`](MODERATION.md).

### Carta (`letters`) — campos relevantes (subset)

**Envio (Firestore):** o cliente confirma o envio numa **transação** — cria o documento em `letters`, incrementa `lettersSentCount` no remetente e cria documentos em `users/{uid}/badgeUnlocks/{badgeId}` quando aplicável ([`letter_send_service.dart`](../lib/features/letters/data/letter_send_service.dart)). Falhas de regras em qualquer passo revertem a transação. Diagnóstico: [`planning/TROUBLESHOOTING.md`](TROUBLESHOOTING.md) — secção “Send letter”.

**Modos de entrega:** além de email (`deliveryMode: “email”`, destinatário externo sem conta) e `@username` (destinatário com conta), existe um terceiro modo: **link** (`shareMode: “link”`, `deliveryMode: “link”`). O remetente gera um link partilhável via `generateShareLink`; o destinatário abre a landing page (`whenote.app/open/{token}`) e faz claim da carta ao autenticar-se (`claimShareLink`). O link pode ser revogado ou regenerado pelo remetente (`revokeShareLink`).

Além de título, mensagem, destinatário, datas, `emotionalState`, etc., o documento pode incluir:

| Campo | Tipo / notas |
|-------|----------------|
| `musicUrl` | String opcional — URL `https` (ex.: Spotify, YouTube Music). Não há streaming na app: o destinatário abre o link no browser ou na app do serviço (`url_launcher`, modo externo). Validado em UI com `lib/shared/utils/music_url.dart`. |
| `voiceUrl` | String opcional — URL de download do **Firebase Storage** (objeto em `voiceLetters/`), gravado no envio da carta. Reprodução **dentro da app** com `just_audio` em detalhe e fluxo de abertura. Validado com `lib/shared/utils/voice_url.dart`. Limite de gravação no cliente: **1 minuto** (política do produto). |
| `senderLocation` | Map opcional — `{ lat: double, lng: double, capturedAt: Timestamp }`. Preenchido se o remetente aceitar partilhar localização ao enviar (`geolocator`). O destinatário vê um tile no detalhe que copia uma URL de pesquisa no Google Maps. |
| `openRequiresProximity` | Boolean opcional (default implícito `false`). Se `true` **e** existir `senderLocation`, o destinatário só entra no ecrã de abertura a partir do Cofre se a posição atual estiver a **≤ 10 m** do ponto (verificação **no cliente** em `open_with_proximity.dart` / `proximity_gate.dart`; não substitui validação server-side). |
| `receiverEmail` | String opcional — email do destinatário externo (sem conta). Preenchido no envio quando `receiverHasAccount: false`. |
| `inviteEmailStatus` | String opcional — estado da entrega do email de convite: `sent`, `delivered`, `bounced`, `dropped`, `deferred`, `send_failed`. Escrito por Cloud Functions (Admin SDK), protegido nas Firestore rules contra escrita do cliente. Enum `InviteEmailStatus` em Dart. |
| `inviteEmailStatusUpdatedAt` | Timestamp opcional — última atualização do estado pelo webhook SendGrid. |
| `lastResendAt` | Timestamp opcional — timestamp do último reenvio via `resendExternalInviteEmail`; usado para rate limiting (cooldown 5 min). |
| `shareToken` | String opcional — token único do link (12 chars base64url, indexado). |
| `shareMode` | String opcional — `"link"` se enviado por link. |
| `shareCreatedAt` | Timestamp opcional — quando o link foi gerado. |
| `shareClaimedAt` | Timestamp opcional — quando o destinatário fez claim. |
| `shareClaimedBy` | String opcional — UID de quem fez claim. |
| `shareRevoked` | Boolean opcional — se o link foi revogado. |

### Entrega de email externo (SendGrid webhook)

Quando um utilizador envia uma carta a um email sem conta, a Cloud Function `onLetterCreatedSendExternalInviteEmail` envia um convite via SendGrid com `custom_args` (letterId + senderUid). O SendGrid envia eventos de entrega de volta via webhook HTTP (`onSendGridWebhook` em `functions/src/sendgrid_webhook.ts`):

- **Verificação:** assinatura ECDSA com `rawBody` e `defineSecret("SENDGRID_WEBHOOK_VERIFICATION_KEY")`.
- **Idempotência:** skip se estado actual == evento ou se estado final (bounced/dropped) ao receber `delivered`.
- **Batch chunking:** lotes de 250 eventos (limite Firestore 500 operações por batch).
- **Notificação:** em bounce/dropped, cria documento em `users/{senderUid}/notifications` + push FCM localizado (`preferredLanguage`). FCM enviado **após** `batch.commit()`.
- **Reenvio:** callable `resendExternalInviteEmail` com rate limiting (5 min cooldown via `lastResendAt`).
- **Validação no cliente:** `lib/core/utils/validators.dart` (regex reutilizável); mensagens ARB com exemplo de formato.
- **Firestore rules:** campos de email delivery (`inviteEmailStatus*`, `inviteEmailSentAt`, `receiverEmailNormalized`, `deliveryMode`, `lastResendAt`) protegidos contra escrita do cliente; `delete` restrito ao sender.

Configuração manual necessária: painel SendGrid (Event Webhook URL + Signed Webhook) + secrets Firebase. Ver [`PRODUCTION.md`](PRODUCTION.md) secção "SendGrid — webhook de email bounce".

### Inventário de Cloud Functions

| Function | Tipo | Trigger | Ficheiro | Estado |
|----------|------|---------|----------|--------|
| `onUserCreated` | Blocking (Identity Platform) | `beforeUserCreated` — bloqueia emails descartáveis + rate limit IP (5/24h) | `functions/src/on_user_created.ts` | ✅ Deployed |
| `moderateContent` | Callable | Cliente chama antes de publicar comentário/carta/cápsula | `functions/src/moderation/moderate_content.ts` | ✅ Deployed |
| `moderateUploadedFile` | Storage trigger | `onObjectFinalized` em avatars, capsules/photos, handwritten, voiceLetters | `functions/src/moderation/moderate_storage.ts` | ✅ Deployed |
| `adminGetModerationInfo` | Callable | Admin screen — info de provedor/chave | `functions/src/moderation/moderate_content.ts` | ✅ Deployed |
| `onLetterCreatedSendExternalInviteEmail` | Firestore trigger | Criação de carta com `receiverEmail` | `functions/src/external_letters.ts` | ✅ Deployed |
| `resendExternalInviteEmail` | Callable | Reenvio manual com rate limiting (5 min) | `functions/src/external_letters.ts` | ✅ Deployed |
| `onSendGridWebhook` | HTTP | Webhook SendGrid (bounce/delivered/dropped/deferred) | `functions/src/sendgrid_webhook.ts` | ✅ Deployed |
| `deleteUserAccount` | Callable | Exclusão de conta (2 modos) | `functions/src/delete_account.ts` | ✅ Deployed |
| `bootstrapAdminClaim` | Callable | Bootstrap de claim admin | `functions/src/admin/bootstrap_admin.ts` | ✅ Deployed |
| `createCheckoutSession` | Callable | Stripe Checkout (billing) | `functions/src/billing/` | ⏳ Desactivado (`BILLING_ENABLED=false`) |
| `createPortalSession` | Callable | Stripe Customer Portal (billing) | `functions/src/billing/` | ⏳ Desactivado |
| `stripeWebhook` | HTTP | Webhook Stripe (subscription events) | `functions/src/billing/` | ⏳ Desactivado |
| `generateShareLink` | Callable | Gera link partilhável para carta | `functions/src/share_link.ts` | ✅ Deployed |
| `getSharePreview` | HTTP público | Preview sanitizado para landing page (rate limited) | `functions/src/share_link.ts` | ✅ Deployed |
| `claimShareLink` | Callable | Destinatário vincula carta ao seu uid (transaction) | `functions/src/share_link.ts` | ✅ Deployed |
| `revokeShareLink` | Callable | Remetente revoga ou regenera link | `functions/src/share_link.ts` | ✅ Deployed |

**Nota:** função `commitLetterSend` é uma **transação Firestore no cliente** ([`letter_send_service.dart`](../lib/features/letters/data/letter_send_service.dart)), não uma Cloud Function.

### Firebase Hosting — rotas relevantes

| URL | Destino |
|-----|---------|
| `whenote.app/open/{token}` | Landing page para share via link (rewrite → `/open/index.html`) |
| `whenote.app/api/share-preview` | Rewrite → Cloud Function `getSharePreview` |

### Deep links

| Padrão | Descrição |
|--------|-----------|
| `/open/{token}` | Share link claim (Android intent filter + iOS AASA + `PendingDeepLink`) |

### Cápsula (`capsules`) — campos principais

Alinhados ao fluxo em `create_capsule_screen.dart`:

| Campo | Tipo / notas |
|-------|----------------|
| `id` | ID do documento |
| `senderUid`, `receiverUid`, `receiverName` | Remetente e destinatário |
| `title` | Título |
| `theme` | `memories` \| `goals` \| `feelings` \| `relationships` \| `growth` |
| `questions` | `[{ question, answer }]` |
| `photos` | URLs (Storage); pode ficar vazio no web |
| `openDate` | `Timestamp` ou null |
| `openEvent` | Texto do evento ou null |
| `openEventType` | `date` \| `event` \| `both` |
| `status` | `locked` \| `opened` |
| `isPublic` | boolean |
| `publishAfterReview` | boolean (decisão ao abrir) |
| `createdAt`, `openedAt`, `publishedAt` | timestamps |
| `likeCount`, `commentCount` | contadores |
| `musicUrl` | String opcional — mesmo padrão que em `letters` (link `https`, abertura externa) |
| `senderLocation` | Igual a `letters` — opcional ao criar a cápsula. |
| `openRequiresProximity` | Igual a `letters` — opcional; raio fixo **10 m** no código. |
| `isCollective` | `bool` — `true` quando existem convidados além do criador (abertura em grupo). |
| `participantUids` | `array<string>` — inclui sempre o criador; convidados são os restantes (máx. **20** nas regras). |
| `participantNames` | `map<string,string>` opcional — snapshot de nomes no selo (`uid` → nome). |
| `contentMode` | `singleAuthor` \| `multiContributor` — MVP usa `singleAuthor`; `multiContributor` reservado para fase em que cada um contribui antes de selar. |

**Subcoleção (futuro):** `capsules/{capsuleId}/contributions/{participantUid}` — contrato para contribuições por utilizador; leitura alinhada aos participantes; escrita ainda `false` no cliente até `multiContributor`. Ver regras em `firestore.rules`.

**Helpers:** `lib/shared/utils/capsule_content_mode.dart` (modo e participação); `lib/features/capsules/data/capsule_vault_streams.dart` (merge de duas queries: remetente + participante coletivo).

---

## Fluxo principal na UI autenticada

- **`HomeScreen`** (`main.dart`): bottom navigation (Feed, **Buscar**, Cofre, Perfil) + **FAB** que abre `showModalBottomSheet` com:
  - Escrever carta → [`DeferredWriteLetterPage`](../lib/core/navigation/deferred_screens.dart) (`loadLibrary` + `WriteLetterScreen`)
  - Nova cápsula → [`DeferredCreateCapsulePage`](../lib/core/navigation/deferred_screens.dart) (`loadLibrary` + `CreateCapsuleScreen`)
  - O item **Buscar** na barra usa [`DeferredSearchPage`](../lib/core/navigation/deferred_screens.dart) (mesmo padrão). Rotas nomeadas `/write`, `/search`, `/create-capsule` apontam para os mesmos shells.

- **`VaultScreen`** (`vault_screen.dart`): abas **Recebidas** / **Enviadas** / **Cápsulas**; só a aba visível monta os respetivos `StreamBuilder` (lazy por aba; sem swipe). A **aba Cápsulas** funde no cliente duas streams (`senderUid` + `locked` e `participantUids` array-contains + `isCollective` + `locked`, ver `capsule_vault_streams.dart`); deduplicação por `doc.id`. As outras abas mantêm as queries habituais. **Filtro e ordenação** aplicam-se no cliente (`vault_list_filters.dart`). O ícone de ajustes abre `showVaultFilterSheet` (`widgets/vault_filter_sheet.dart`): critérios por aba (ex.: intervalo de datas na Recebidas; origem recebidas/enviadas nas cartas já abertas; estado nas enviadas; temas nas cápsulas). Indicador (`Badge`) quando a aba atual tem filtros não padrão; mensagem localizada se o filtro esvazia a lista sem haver dados reais em falta. O **badge do Cofre** no `main.dart` usa a mesma lógica de contagem de cápsulas fechadas (cartas recebidas locked + cápsulas merged). Ação rápida “nova cápsula” no cofre vazio também usa `DeferredCreateCapsulePage`.

### Feed

- **`FeedScreen` / `_FeedCard`** ([`feed_screen.dart`](../lib/features/feed/presentation/screens/feed_screen.dart)): lista de cartas públicas; cada card pode mostrar um **preview de comentários** (`_buildCommentsPreview`).
  - **Header:** gradiente personalizado (não `AppBar`); lado esquerdo — branding + subtítulo; lado direito — botões de ação via `_iconBtn(icon, {onTap, tooltip})`. Quando `onTap` é fornecido, o ícone fica envolto em `Semantics` (a11y), `Tooltip`, `SizedBox(48×48)` (alvo mínimo Material 3) e `Material` + `InkWell` (ripple). **Lupa** navega via `pushNamed('/search')` (respeitando `DeferredSearchPage`); **sino** navega para [`ModerationNotificationsScreen`](../lib/features/profile/presentation/screens/moderation_notifications_screen.dart) via `MaterialPageRoute` (consistente com Settings).
  - **Três camadas (fonte de dados):** o utilizador escolhe no bottom sheet **Explorar** | **Destaques** | **Seguindo** (ícone de filtros à direita, fixo; só ícone). **Explorar** — [`explore_feed_paged.dart`](../lib/features/feed/presentation/widgets/explore_feed_paged.dart): primeira página em tempo real (`snapshots`) + páginas extra com `startAfter`; carregamento incremental ao aproximar do fim do scroll (`ScrollController`, sem botão “carregar mais”). **Destaques** — mesma query limitada + janela `openedAt` que o feed global, depois ordenação no cliente por `likeCount` e `openedAt` com teto em [`FeedConfig.highlightsMaxVisible`](../lib/core/constants/feed_config.dart). **Seguindo** — [`following_feed_body.dart`](../lib/features/feed/presentation/widgets/following_feed_body.dart): IDs de `follows`, consultas `letters` em blocos `whereIn` (≤10) e merge em [`feed_following_merge.dart`](../lib/features/feed/domain/feed_following_merge.dart); sem sessão mostra estado “entrar”.
  - **Filtros emocionais (cliente):** quatro significados semânticos (Para todos / Amor / Amizade / Família) mapeiam para `emotionalState` e listas em `_filterEmotions` no ecrã. O utilizador **fixa até 3** chips na barra — preferência em [`feed_pinned_filters_provider.dart`](../lib/features/feed/presentation/providers/feed_pinned_filters_provider.dart) (`SharedPreferences`, chave `feed_pinned_filter_ids_v1`); edição no sheet [`pinned_feed_filters_sheet.dart`](../lib/features/feed/presentation/widgets/pinned_feed_filters_sheet.dart), acessível a partir do mesmo bottom sheet do tipo de feed (“Fixar filtros rápidos”). Os chips deslocam-se horizontalmente; o botão de filtros permanece à direita (`Row` + `Expanded`).
  - **Bloqueios:** [`feed_letter_filter.dart`](../lib/features/feed/domain/feed_letter_filter.dart) — cartas de remetentes em `blocks` não são mostradas.
  - **Custo / escala:** todas as camadas respeitam `limit` + janela em `openedAt` onde aplicável ([`feed_config.dart`](../lib/core/constants/feed_config.dart)). Destaques não fazem sort global infinito no servidor. Seguindo: até **ceil(n/10)** listeners/query por atualização (n = número de contas seguidas), documentado em [`PRODUCTION.md`](PRODUCTION.md).
  - **Quantidade (comentários no card):** query Firestore com `limit(2)` por defeito; se `commentCount > 2`, aparece o link localizado **Ver todos os N comentários** (`feedViewAllComments`), que passa a `limit(20)` no mesmo preview (estado `_showAllComments` no card).
  - **Texto longo por comentário:** cada linha do preview usa `Text.rich` com no máximo **4 linhas** e `TextOverflow.ellipsis` até o utilizador expandir **esse** comentário (toque em **Ler mais** — mesma string `feedReadMore` que o corpo da carta). IDs expandidos ficam em `_expandedCommentPreviewIds` (`Set<String>` de IDs de documento em `comments`).
  - **Quando mostrar “Ler mais”:** heurística no cliente — mensagem com mais de **120** caracteres **ou** com **4** ou mais linhas (`\n`). Não mede overflow com `TextPainter`.
  - **Lista completa:** ícone de comentário no card abre [`CommentsScreen`](../lib/features/feed/presentation/screens/comments_screen.dart) (stream sem este limite de linhas por item).

---

## Testes e ambiente

- Desenvolvimento web frequente: `flutter run -d chrome`
- Validar também builds móveis antes de releases (`flutter run` em dispositivo/emulador).

Para detalhes visuais, ver [`DESIGN_SYSTEM.md`](DESIGN_SYSTEM.md).

---

## Deleção de conta e compliance

### Fluxo
1. Usuário toca "Deletar conta" → modal `_DeleteAccountSheet` com escolha (apagar tudo / anonimizar) + re-autenticação por senha
2. Client chama `AccountDeletionService.requestDeletion()` via `CallableQueue`
3. Cloud Function `deleteUserAccount(uid, mode)` executa 15 etapas server-side (Stripe, Firestore, Storage, Auth)
4. Client faz sign-out local

### Arquivos
- `functions/src/delete_account.ts` — Cloud Function
- `lib/core/services/account_deletion_service.dart` — serviço client
- `lib/features/profile/presentation/screens/settings_screen.dart` — UI (`_DeleteAccountSheet`)
- `planning/DATA_RETENTION_POLICY.md` — política completa

### COPPA / GDPR Art. 8 / LGPD
- **Verificação de idade:** date picker de data de nascimento no registro (email/password) e age gate modal no login social (Google/Apple). A idade mínima é determinada automaticamente pela jurisdição do dispositivo (`Platform.localeName`) via `age_verification.dart`, que mapeia 27 países EU/EEA/UK com idades entre 13–16 (GDPR Art. 8); restantes defaultam a 16 (EU) ou 13 (COPPA).
- **Campo `dateOfBirth`:** gravado no Firestore (`users/{uid}`) como `Timestamp`; campo nullable para retrocompatibilidade com contas existentes.
- Aceite obrigatório de Termos de Uso e Política de Privacidade no registro.
- Deleção: escolha do usuário entre remover tudo ou anonimizar cartas.
- Audit log: `deletionAuditLogs` com hash do UID (sem PII).

---

## Extensões futuras — pagamentos (planejado)

O produto **Whenote Gift** prevê integração com **Stripe Connect** (retenção e repasse do valor associado à carta; detalhes de modelo e fases em [`ROADMAP.md`](ROADMAP.md)). O backend atual centra-se em **Firebase**; a camada de pagamentos será um serviço adicional (API Stripe, webhooks, idempotência) — desenho concreto na fase de implementação.

### Subscrição (tiers Amanhã / Brisa / Horizonte)

A subscrição usa **Stripe Checkout** (modo subscription) e **Customer Portal**, expostos via **Firebase Cloud Functions** (`createCheckoutSession`, `createPortalSession`, `stripeWebhook`, `migrateUserBillingDefaults`). O estado (`subscriptionTier`, ids Stripe) vive em `users/{uid}` e só é escrito pelo webhook ou pela migração server-side; o cliente Flutter usa a abstracção `BillingProvider` com implementação `StripeBillingProvider` (`lib/core/billing/`). As Functions leem chaves Stripe de **variáveis de ambiente** em runtime (sem obrigar Secret Manager). No app, o checkout Stripe fica **desactivado por defeito** (`BILLING_ENABLED=false`); usar `--dart-define=BILLING_ENABLED=true` quando Stripe e envs estiverem prontos. **Moderação por IA** e callables de admin (`moderateContent`, `adminGetModerationInfo`, listagens) estão no mesmo projeto Functions; ver secção [Moderação de conteúdo](#moderação-de-conteúdo) e [`functions/README.md`](../functions/README.md).
