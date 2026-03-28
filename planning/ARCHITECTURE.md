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
│   │       └── voice_letter.dart    # conditional export: upload/delete ficheiro local (IO vs web stub)
│   ├── capsules/
│   │   └── presentation/screens/ (create_capsule)
│   ├── feed/
│   │   ├── models/
│   │   └── presentation/screens/ (feed, comments)
│   └── profile/
│       └── presentation/screens/ (profile, user_profile, search, settings, legal, subscription_plans)
└── shared/
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
        ├── music_link_tile.dart       # Abrir link externo (url_launcher) + tile escuro “Ouvir música”
        ├── voice_letter_tile.dart     # Reprodução in-app (just_audio) — detalhe e abertura da carta
        └── location_share_tile.dart   # Tile escuro: toque copia link Maps (detalhe carta/cápsula)
```

Padrão **feature-first**: cada feature agrupa o que for necessário; auth mantém camadas `data` / `domain` / `presentation`.

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
| **FCM** | Notificações push (a configurar no MVP) |

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
