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
├── core/constants/
│   └── firestore_collections.dart # Constantes nomeadas (subset; outras coleções usadas inline)
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
│   │   └── presentation/screens/ (write, vault, detail, opening, requests, qr)
│   ├── capsules/
│   │   └── presentation/screens/ (create_capsule)
│   ├── feed/
│   │   ├── models/
│   │   └── presentation/screens/ (feed, comments)
│   └── profile/
│       └── presentation/screens/ (profile, user_profile, search, settings, legal)
└── shared/
    ├── theme/
    │   └── app_theme.dart
    └── widgets/
        ├── owl_logo.dart              # OwlLogo, OwlSealOpeningAnimation, pintura do lacre/coruja
        ├── owl_feedback_affordance.dart  # Coruja tocável + animação idle; abre feedback sheet
        └── feedback_entry_button.dart # Botão/FAB + showFeedbackSheet (sheet partilhado)
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
| **Cloud Storage** | Mídia (avatar, futuras fotos de cápsula, etc.) |
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
