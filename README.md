<div align="center">

# OpenWhen

**Write today. Feel tomorrow.** · *Escreva hoje. Sinta amanhã.*

[![Flutter](https://img.shields.io/badge/Flutter-3.41.4-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11.1-0175C2?logo=dart)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-openwhen--923f5-FFCA28?logo=firebase)](https://firebase.google.com)
[![MVP](https://img.shields.io/badge/MVP-~92%25-success)](planning/MVP_CHECKLIST.md)

*Timed letters, time capsules, and an emotional social layer — with a physical QR bridge to the people you care about.*

[Product roadmap](planning/ROADMAP.md) · [MVP checklist](planning/MVP_CHECKLIST.md) · [Architecture](planning/ARCHITECTURE.md) · [Business](planning/BUSINESS.md)

</div>

---

## What is OpenWhen?

OpenWhen is a cross-platform social product for **writing messages that unlock in the future** — combining **scheduled letters**, **guided time capsules**, and a **feed** tuned for emotion, not just engagement. A **QR code** flow lets memories travel from the physical world into the app.

**For users:** express what matters, schedule it with intention, and open it when the moment is right.

**For builders & backers:** Flutter + Firebase, a clear feature-first codebase, and a roadmap focused on finishing the MVP before scaling monetization.

---

## Key features

| Area | Highlights |
|------|------------|
| **Letters** | Write, schedule, emotional opening animation, QR generation and sharing |
| **Time capsules** | Themes (memories, goals, feelings, relationships, growth), 2–5 guided Q&A, lock until date/event |
| **Social** | Instagram-style feed, likes & comments, follows, privacy controls, moderation |
| **Vault** | Tabs for waiting, opened, and **capsules** |
| **Profile** | Own profile, other users, search by @username, settings, legal pages |

---

## Tech stack

| Layer | Choice |
|-------|--------|
| **UI** | Flutter (Material 3) |
| **State** | Riverpod |
| **Backend** | Firebase Auth, Cloud Firestore, Storage, Cloud Messaging |
| **Navigation** | `MaterialApp` routes + imperative navigation; `go_router` available for future consolidation |
| **Fonts** | Google Fonts (DM Serif Display + DM Sans) |

Architecture is **feature-first** under `lib/features/`, with auth split into `data` / `domain` / `presentation`. See **[planning/ARCHITECTURE.md](planning/ARCHITECTURE.md)** for folder layout and Firestore collections.

---

## Getting started

### Prerequisites

- Flutter **3.41.4** (or compatible channel) and Dart **3.11.1+**
- Firebase CLI (optional, for local tooling)
- Access to Firebase config for this project

### Run

```bash
git clone https://github.com/Yuri-Lima/openwhen.git
cd openwhen
flutter pub get
flutter run -d chrome
```

For day-to-day development, **`flutter run -d chrome`** is the default target.

### Firebase configuration

- **Project ID:** `openwhen-923f5`
- The file **`lib/firebase_options.dart`** is required to run the app and is **not** published in the public repository. Request it from the team and place it under `lib/` before building.

---

## Project structure (abbreviated)

```
lib/
├── main.dart
├── firebase_options.dart          # local, not in repo
├── core/constants/
├── features/
│   ├── auth/
│   ├── letters/
│   ├── capsules/
│   ├── feed/
│   └── profile/
└── shared/theme/
```

Full tree and schema notes: **[planning/ARCHITECTURE.md](planning/ARCHITECTURE.md)** · Design tokens: **[planning/DESIGN_SYSTEM.md](planning/DESIGN_SYSTEM.md)**

---

## Roadmap & progress

**~92% MVP complete.** Critical next steps: capsule opening experience, profile avatar upload, FCM notifications, real-device QA, production Firestore rules.

| Document | Purpose |
|----------|---------|
| [planning/ROADMAP.md](planning/ROADMAP.md) | Phased product roadmap |
| [planning/MVP_CHECKLIST.md](planning/MVP_CHECKLIST.md) | Day-to-day checklist |
| [planning/CHANGELOG.md](planning/CHANGELOG.md) | Release history |

---

## Business overview (investors)

- **Incorporation:** Delaware C-Corp (Stripe Atlas)
- **Founders:** Diego Rocha & Yuri Lima
- **Markets:** Brazil first, US expansion later
- **Audience:** ~18–35, heavy Instagram/TikTok usage
- **Monetization:** Freemium now; **pay-per-feature** after **~10k users**

Full narrative: **[planning/BUSINESS.md](planning/BUSINESS.md)**

---

## Contributing

1. Branch from **`master`** (or follow team workflow if it changes).
2. Keep UI aligned with **[planning/DESIGN_SYSTEM.md](planning/DESIGN_SYSTEM.md)**.
3. Update **[planning/MVP_CHECKLIST.md](planning/MVP_CHECKLIST.md)** or **[planning/CHANGELOG.md](planning/CHANGELOG.md)** when you ship user-visible changes.

---

## License & contact

**License:** TBD.

**Repository:** [github.com/Yuri-Lima/openwhen](https://github.com/Yuri-Lima/openwhen) (branch `master`)

**Founders:** Diego Rocha & Yuri Lima

---

## Planning folder

| File | Description |
|------|-------------|
| [planning/ROADMAP.md](planning/ROADMAP.md) | Phases 1–4 (MVP → monetization) |
| [planning/MVP_CHECKLIST.md](planning/MVP_CHECKLIST.md) | Granular MVP tracking |
| [planning/ARCHITECTURE.md](planning/ARCHITECTURE.md) | Stack, folders, Firestore |
| [planning/DESIGN_SYSTEM.md](planning/DESIGN_SYSTEM.md) | Colors, type, capsule themes |
| [planning/BUSINESS.md](planning/BUSINESS.md) | Strategy for investors |
| [planning/CHANGELOG.md](planning/CHANGELOG.md) | Keep a Changelog style |
