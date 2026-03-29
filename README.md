<div align="center">

**English** · <a href="README.pt-BR.md" target="_blank" rel="noopener noreferrer">Português (Brasil)</a>

# OpenWhen

**Write today. Feel tomorrow.** · *Escreva hoje. Sinta amanhã.*

[![Flutter](https://img.shields.io/badge/Flutter-3.41.4-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11.1-0175C2?logo=dart)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-openwhen--923f5-FFCA28?logo=firebase)](https://firebase.google.com)
[![MVP](https://img.shields.io/badge/MVP-~100%25-success)](planning/MVP_CHECKLIST.md)

*Timed letters, time capsules, and an emotional social layer — with a physical QR bridge to the people you care about.*

[Product roadmap](planning/ROADMAP.md) · [MVP checklist](planning/MVP_CHECKLIST.md) · [Architecture](planning/ARCHITECTURE.md) · [Business](planning/BUSINESS.md)

</div>

---

## What is OpenWhen?

OpenWhen is a cross-platform social product for **writing messages that unlock in the future** — combining **scheduled letters**, **guided time capsules**, and a **feed** tuned for emotion, not just engagement. A **QR code** flow lets memories travel from the physical world into the app.

**For users:** express what matters, schedule it with intention, and open it when the moment is right.

**For builders & backers:** Flutter + Firebase, a clear feature-first codebase, and a roadmap that spans the **completed MVP core**, ongoing **engagement** work ([`planning/ROADMAP.md`](planning/ROADMAP.md) Fase 2), and **monetization** later at scale.

---

## Key features

| Area | Highlights |
|------|------------|
| **Letters** | Write, schedule, emotional opening animation (wax seal + owl micro-interaction), QR generation and sharing; **typed message** field starts **collapsed** and expands on tap; optional **voice message** (OpenWhen max **1 minute**, recorded on device, uploaded to Storage) with in-app playback on open/detail; optional **music link** (`https` only) opened externally (no in-app streaming for music); optional **location** on send (`geolocator`): dialogs ask whether to share coordinates with the recipient (detail tile copies a **Google Maps** URL to the clipboard) and whether opening requires the recipient to be **within 10 m** of that point (client-side check from the Vault before the opening screen — not a server guarantee) |
| **Time capsules** | Themes (memories, goals, feelings, relationships, growth), 2–5 guided Q&A, lock until date/event; optional **music link** same as letters; same **optional location + optional 10 m opening gate** as letters |
| **Social** | Instagram-style feed, likes & comments, follows, privacy controls, moderation |
| **Vault** | Tabs for waiting, opened, sent, and **capsules**; advanced **filter and sort** (bottom sheet, client-side on snapshot data) |
| **Profile** | Own profile, other users, search by @username, settings, legal pages |
| **Feedback** | Tap the header owl to send feedback (shared bottom sheet); idle wobble + buzz on random intervals per screen visit. Logged-out users also get the global FAB. |
| **Keyboard** | While the soft keyboard is open, a small **dismiss keyboard** control appears just above it (global `MaterialApp.builder` overlay); same behavior everywhere. |

---

## Tech stack

| Layer | Choice |
|-------|--------|
| **UI** | Flutter (Material 3) |
| **State** | Riverpod |
| **Backend** | Firebase Auth, Cloud Firestore, Storage, Cloud Messaging |
| **Location** | `geolocator` (+ platform location permissions) for optional share-at-send and proximity-to-open |
| **Navigation** | `MaterialApp` routes + imperative navigation; `go_router` available for future consolidation |
| **Fonts** | Google Fonts (DM Serif Display + DM Sans) |

Architecture is **feature-first** under `lib/features/`, with auth split into `data` / `domain` / `presentation`. See **[planning/ARCHITECTURE.md](planning/ARCHITECTURE.md)** for folder layout and Firestore collections.

---

## Getting started

### Prerequisites

- Flutter **3.41.4** (or compatible channel) and Dart **3.11.1+**
- Firebase CLI (optional; see [Firebase CLI and emulators](#firebase-cli-and-emulators))
- **JDK 21+** (only if you use the [Firebase Emulator Suite](https://firebase.google.com/docs/emulator-suite); see below)
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

#### Project identifiers (Console)

| Field | Value |
|-------|--------|
| **Project ID** | `openwhen-923f5` |
| **Project number** | `393943450881` (e.g. FCM, some console integrations) |
| **Default Storage bucket** | `openwhen-923f5.firebasestorage.app` (must match `storageBucket` in `firebase_options.dart`) |
| **Auth domain (web)** | `openwhen-923f5.firebaseapp.com` |

The file **`lib/firebase_options.dart`** is required to run the app and is **not** published in the public repository. Request it from the team and place it under `lib/` before building. Regenerate with [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/) if platform config changes.

#### Backend config files (this repo)

| File | Role |
|------|------|
| [`firebase.json`](firebase.json) | Firestore rules/indexes and Storage rules paths |
| [`.firebaserc`](.firebaserc) | Default Firebase project for CLI (`openwhen-923f5`) |
| [`firestore.rules`](firestore.rules) | Firestore security rules |
| [`firestore.indexes.json`](firestore.indexes.json) | Composite indexes |
| [`storage.rules`](storage.rules) | Cloud Storage security rules |

### Firebase CLI and emulators

1. **Install the CLI** (Node.js / npm):

   ```bash
   npm install -g firebase-tools
   ```

   Or run without a global install: `npx firebase-tools <command>`.

2. **Sign in** (once per machine):

   ```bash
   firebase login
   ```

3. **Project context:** This repository includes [`.firebaserc`](.firebaserc) with the default project **`openwhen-923f5`**. You can override per command with `--project openwhen-923f5` or run `firebase use --add` to add aliases.

4. **Deploy security rules and indexes** (from the repo root):

   ```bash
   firebase deploy --only firestore:rules,storage
   ```

   To deploy Firestore indexes as well:

   ```bash
   firebase deploy --only firestore:rules,firestore:indexes,storage
   ```

#### Firebase Emulator Suite (optional)

Use the [emulators](https://firebase.google.com/docs/emulator-suite) to exercise Firestore/Storage rules locally without touching production.

- **Java:** Current `firebase-tools` requires a **JDK of version 21 or higher** (`java -version` must report 21+). On macOS with Homebrew:

  ```bash
  brew install openjdk@21
  export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"
  export JAVA_HOME="/opt/homebrew/opt/openjdk@21"
  ```

  To make Java 21 visible to all tools, you can symlink it (Apple’s prompt when `java` is missing):

  ```bash
  sudo ln -sfn /opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-21.jdk
  ```

- **Start emulators** (example: Firestore + Storage):

  ```bash
  firebase emulators:start --only firestore,storage
  ```

  Default ports (unless changed in `firebase.json`): **Emulator UI** `http://127.0.0.1:4000/`, **Firestore** `127.0.0.1:8080`, **Storage** `127.0.0.1:9199`.

  Command name is `firebase emulators:start` (with a **t** in `start`).

  **Do not** run `firebase init emulators` and enable **App Hosting**, **Hosting**, **Realtime Database**, or **Pub/Sub** for this Flutter app unless you explicitly need them — **App Hosting** expects a web `startCommand` and fails with *Failed to auto-detect your project's start command*. This repo’s [`firebase.json`](firebase.json) only wires **Firestore**, **Storage**, and the **Emulator UI**.

- **Flutter app:** By default, `flutter run` uses **production** Firebase from `firebase_options.dart`. Pointing the app at emulators requires calling `FirebaseFirestore.instance.useFirestoreEmulator(...)` and `FirebaseStorage.instance.useStorageEmulator(...)` (e.g. behind a debug flag). Without that, use the Emulator UI and the [rules playground](https://firebase.google.com/docs/rules/simulator) to validate rules, or test against the dev project in the cloud.

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
└── shared/
    ├── theme/
    ├── utils/          # music_url, voice_url; sender_location, location_capture, proximity_gate, location_prompt_flow, open_with_proximity
    └── widgets/        # e.g. location_share_tile (copy Maps link)
```

Full tree and schema notes: **[planning/ARCHITECTURE.md](planning/ARCHITECTURE.md)** · Design tokens: **[planning/DESIGN_SYSTEM.md](planning/DESIGN_SYSTEM.md)**

---

## Roadmap & progress

**MVP core (🔴 critical) is complete** — see [`planning/MVP_CHECKLIST.md`](planning/MVP_CHECKLIST.md). **Next:** 🟡 Important items (e.g. Stories/Reels). Use [`planning/DEVICE_TESTING.md`](planning/DEVICE_TESTING.md) for regression QA on real devices when shipping releases.

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
