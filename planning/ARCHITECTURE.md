# OpenWhen — Arquitetura técnica

## Visão geral

- **Cliente:** Flutter (multiplataforma: web, iOS, Android, etc.).
- **Backend:** Firebase (Auth, Cloud Firestore, Storage, Cloud Messaging).
- **Estado:** Riverpod (`flutter_riverpod`).
- **Navegação:** `MaterialApp` com `routes` nomeadas; telas adicionais via `Navigator` (`MaterialPageRoute`). O pacote `go_router` está no `pubspec` para evolução futura da navegação.

---

## Estrutura de pastas (`lib/`)

```
lib/
├── main.dart
├── firebase_options.dart          # Não versionado no remoto — obter com o time
├── core/
│   ├── billing/                   # BillingProvider, StripeBillingProvider, tier guard, feature flags (BILLING_ENABLED)
│   ├── config/
│   │   └── facebook_app_config.dart  # `FB_APP_ID` (dart-define) para Instagram Sharing to Stories
│   └── constants/
│       └── firestore_collections.dart # Constantes nomeadas (subset; outras coleções usadas inline)
├── features/
│   ├── auth/
│   │   ├── data/auth_service.dart
│   │   ├── domain/auth_repository.dart
│   │   ├── models/app_user.dart
│   │   └── presentation/
│   │       ├── providers/auth_provider.dart
│   │       └── screens/ (splash, login, register, onboarding)
│   ├── letters/
│   │   ├── models/
│   │   └── presentation/
│   │       ├── screens/ (write, vault, detail, opening, requests, qr)
│   │       ├── vault_list_filters.dart   # estado de filtros por aba + sort/filtro em memória sobre snapshots
│   │       └── widgets/ (vault_filter_sheet — bottom sheet de filtro/ordenação)
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
| **Authentication** | Sessão do usuário |
| **Cloud Firestore** | Dados principais (usuários, cartas, social, cápsulas, moderação) |
| **Cloud Storage** | Avatares; fotos de carta manuscrita (`handwritten/`); mensagens de voz (`voiceLetters/`, áudio curto); mídia de cápsulas (`capsules/**`) — ver [`storage.rules`](../storage.rules) |
| **FCM** | Notificações push (Firebase Cloud Messaging; integrado no app — ver `MVP_CHECKLIST.md` 🔴) |

**Projeto Firebase (referência):** `openwhen-923f5`

---

## Coleções Firestore

Constantes centralizadas em [`lib/core/constants/firestore_collections.dart`](../lib/core/constants/firestore_collections.dart): `users`, `letters`, `comments`, `likes`, `reports`, `capsules`.

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
| `reports` | Denúncias / moderação |

### Carta (`letters`) — campos relevantes (subset)

Além de título, mensagem, destinatário, datas, `emotionalState`, etc., o documento pode incluir:

| Campo | Tipo / notas |
|-------|----------------|
| `musicUrl` | String opcional — URL `https` (ex.: Spotify, YouTube Music). Não há streaming na app: o destinatário abre o link no browser ou na app do serviço (`url_launcher`, modo externo). Validado em UI com `lib/shared/utils/music_url.dart`. |
| `voiceUrl` | String opcional — URL de download do **Firebase Storage** (objeto em `voiceLetters/`), gravado no envio da carta. Reprodução **dentro da app** com `just_audio` em detalhe e fluxo de abertura. Validado com `lib/shared/utils/voice_url.dart`. Limite de gravação no cliente: **1 minuto** (política do produto). |
| `senderLocation` | Map opcional — `{ lat: double, lng: double, capturedAt: Timestamp }`. Preenchido se o remetente aceitar partilhar localização ao enviar (`geolocator`). O destinatário vê um tile no detalhe que copia uma URL de pesquisa no Google Maps. |
| `openRequiresProximity` | Boolean opcional (default implícito `false`). Se `true` **e** existir `senderLocation`, o destinatário só entra no ecrã de abertura a partir do Cofre se a posição atual estiver a **≤ 10 m** do ponto (verificação **no cliente** em `open_with_proximity.dart` / `proximity_gate.dart`; não substitui validação server-side). |

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

---

## Fluxo principal na UI autenticada

- **`HomeScreen`** (`main.dart`): bottom navigation (Feed, Buscar, Cofre, Perfil) + **FAB** que abre `showModalBottomSheet` com:
  - Escrever carta → `WriteLetterScreen`
  - Nova cápsula → `CreateCapsuleScreen`

- **`VaultScreen`** (`vault_screen.dart`): abas Aguardando / Abertas / Enviadas / Cápsulas; cada aba mantém a mesma query Firestore de sempre; **filtro e ordenação avançados aplicam-se no cliente** sobre os documentos recebidos (`vault_list_filters.dart`). O ícone de ajustes abre `showVaultFilterSheet` (`widgets/vault_filter_sheet.dart`): busca por texto, ordenação, intervalo de data de abertura (aba Aguardando), origem recebidas/enviadas (Abertas), só pendentes de aceite (Enviadas), temas (Cápsulas). Indicador (`Badge`) quando a aba atual tem filtros não padrão; mensagem localizada se o filtro esvazia a lista sem haver dados reais em falta.

### Feed

- **`FeedScreen` / `_FeedCard`** ([`feed_screen.dart`](../lib/features/feed/presentation/screens/feed_screen.dart)): lista de cartas públicas; cada card pode mostrar um **preview de comentários** (`_buildCommentsPreview`).
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

## Extensões futuras — pagamentos (planejado)

O produto **OpenWhen Gift** prevê integração com **Stripe Connect** (retenção e repasse do valor associado à carta; detalhes de modelo e fases em [`ROADMAP.md`](ROADMAP.md) e [`BUSINESS.md`](BUSINESS.md)). O backend atual centra-se em **Firebase**; a camada de pagamentos será um serviço adicional (API Stripe, webhooks, idempotência) — desenho concreto na fase de implementação.

### Subscrição (tiers Amanhã / Brisa / Horizonte)

A subscrição usa **Stripe Checkout** (modo subscription) e **Customer Portal**, expostos via **Firebase Cloud Functions** (`createCheckoutSession`, `createPortalSession`, `stripeWebhook`, `migrateUserBillingDefaults`). O estado (`subscriptionTier`, ids Stripe) vive em `users/{uid}` e só é escrito pelo webhook ou pela migração server-side; o cliente Flutter usa a abstracção `BillingProvider` com implementação `StripeBillingProvider` (`lib/core/billing/`). As Functions leem chaves Stripe de **variáveis de ambiente** em runtime (sem obrigar Secret Manager). No app, o checkout Stripe fica **desactivado por defeito** (`BILLING_ENABLED=false`); usar `--dart-define=BILLING_ENABLED=true` quando Stripe e envs estiverem prontos. Ver [`functions/README.md`](../functions/README.md).
