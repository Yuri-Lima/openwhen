<div align="center">

<a href="README.md" target="_blank" rel="noopener noreferrer">English</a> · **Português (Brasil)**

# OpenWhen

**Escreva hoje. Sinta amanhã.** · *Write today. Feel tomorrow.*

[![Flutter](https://img.shields.io/badge/Flutter-3.41.4-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11.1-0175C2?logo=dart)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-openwhen--923f5-FFCA28?logo=firebase)](https://firebase.google.com)
[![MVP](https://img.shields.io/badge/MVP-~100%25-success)](planning/MVP_CHECKLIST.md)

*Cartas temporizadas, cápsulas do tempo e uma camada social emocional — com QR Code físico ligando o mundo real ao app.*

[Roadmap](planning/ROADMAP.md) · [Checklist MVP](planning/MVP_CHECKLIST.md) · [Arquitetura](planning/ARCHITECTURE.md) · [Negócio](planning/BUSINESS.md)

</div>

---

## O que é o OpenWhen?

O OpenWhen é um produto social multiplataforma para **escrever mensagens que desbloqueiam no futuro** — combinando **cartas agendadas**, **cápsulas do tempo guiadas** e um **feed** pensado para emoção, não só engajamento. Um fluxo de **QR Code** leva memórias do mundo físico para dentro do app.

**Para quem usa:** expressar o que importa, agendar com intenção e abrir no momento certo.

**Para quem constrói e investe:** Flutter + Firebase, código organizado por features e roadmap que cobre o **núcleo do MVP (concluído)**, entregas de **engajamento** ([`planning/ROADMAP.md`](planning/ROADMAP.md) Fase 2) e **monetização** depois em escala.

---

## Principais recursos

| Área | Destaques |
|------|-----------|
| **Cartas** | Escrever, agendar, animação de abertura por emoção (lacre + coruja), gerar QR e compartilhar; campo **mensagem digitada** começa **recolhido** e expande ao toque; **mensagem de voz** opcional (máx. **1 minuto** definido pelo produto, gravação no dispositivo, upload no Storage) com reprodução no app na abertura/detalhe; **link de música** opcional (só `https`, abre fora do app — sem streaming de música no app); **localização** opcional no envio (`geolocator`): diálogos perguntam se compartilha coordenadas com o destinatário (no detalhe, toque copia URL do **Google Maps**) e se a abertura exige estar a **≤ 10 m** do ponto (verificação no cliente ao abrir pelo Cofre — não é garantia de servidor) |
| **Cápsulas do tempo** | Temas (memórias, metas, sentimentos, relacionamentos, crescimento), 2–5 perguntas e respostas, abertura por data/evento; mesmo padrão de link de música opcional; mesma **localização opcional + opção de abertura em 10 m** das cartas |
| **Social** | Feed estilo Instagram, curtidas e comentários (no card: até 2 comentários, “ver todos” até 20; textos longos limitados a 4 linhas com **Ler mais** por comentário), seguidores, privacidade, moderação |
| **Cofre** | Abas: aguardando, abertas, enviadas e **cápsulas**; **filtro e ordenação** (bottom sheet, no cliente sobre os dados já carregados) |
| **Perfil** | Perfil próprio e de outros, busca por @username, configurações, páginas legais |
| **Feedback** | Toque na coruja do header para enviar feedback (mesmo bottom sheet); animação idle (oscilação + vibração) em intervalos aleatórios por visita ao ecrã. Utilizadores sem sessão também têm o FAB global. |
| **Teclado** | Com o teclado virtual aberto, um botão **fechar teclado** aparece logo acima dele (overlay global no `MaterialApp.builder`); o mesmo comportamento em todo o app. |

---

## Stack técnica

| Camada | Escolha |
|--------|---------|
| **UI** | Flutter (Material 3) |
| **Estado** | Riverpod |
| **Backend** | Firebase Auth, Cloud Firestore, Storage, Cloud Messaging |
| **Localização** | `geolocator` (+ permissões por plataforma) para compartilhar no envio e checagem de proximidade na abertura |
| **Navegação** | Rotas do `MaterialApp` + navegação imperativa; `go_router` disponível para evolução |
| **Fontes** | Google Fonts (DM Serif Display + DM Sans) |

A arquitetura é **por features** em `lib/features/`, com auth em camadas `data` / `domain` / `presentation`. Veja **[planning/ARCHITECTURE.md](planning/ARCHITECTURE.md)** para a árvore de pastas e coleções do Firestore.

---

## Como rodar

### Pré-requisitos

- Flutter **3.41.4** (ou canal compatível) e Dart **3.11.1+**
- Firebase CLI (opcional; veja [Firebase CLI e emuladores](#firebase-cli-e-emuladores))
- **JDK 21+** (só se você usar o [Firebase Emulator Suite](https://firebase.google.com/docs/emulator-suite); detalhes abaixo)
- Acesso à configuração Firebase do projeto

### Comandos

```bash
git clone https://github.com/Yuri-Lima/openwhen.git
cd openwhen
flutter pub get
flutter run -d chrome
```

No dia a dia, o alvo padrão de desenvolvimento é **`flutter run -d chrome`**.

### Configuração Firebase

#### Identificadores do projeto (Console)

| Campo | Valor |
|-------|--------|
| **ID do projeto** | `openwhen-923f5` |
| **Número do projeto** | `393943450881` (ex.: FCM, algumas integrações no console) |
| **Bucket padrão do Storage** | `openwhen-923f5.firebasestorage.app` (deve bater com `storageBucket` em `firebase_options.dart`) |
| **Domínio de auth (web)** | `openwhen-923f5.firebaseapp.com` |

O arquivo **`lib/firebase_options.dart`** é obrigatório para rodar o app e **não** está no repositório público. Solicite ao time e coloque em `lib/` antes do build. Para mudanças de plataforma, regenere com [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/).

#### Arquivos de backend (neste repositório)

| Arquivo | Função |
|---------|--------|
| [`firebase.json`](firebase.json) | Caminhos das regras do Firestore/Storage e índices |
| [`.firebaserc`](.firebaserc) | Projeto padrão da CLI (`openwhen-923f5`) |
| [`firestore.rules`](firestore.rules) | Regras de segurança do Firestore |
| [`firestore.indexes.json`](firestore.indexes.json) | Índices compostos |
| [`storage.rules`](storage.rules) | Regras de segurança do Cloud Storage |

### Firebase CLI e emuladores

1. **Instalar a CLI** (Node.js / npm):

   ```bash
   npm install -g firebase-tools
   ```

   Sem instalação global: `npx firebase-tools <comando>`.

2. **Login** (uma vez por máquina):

   ```bash
   firebase login
   ```

3. **Contexto do projeto:** Este repositório inclui [`.firebaserc`](.firebaserc) com o projeto padrão **`openwhen-923f5`**. Dá para sobrescrever com `--project openwhen-923f5` ou usar `firebase use --add` para aliases.

4. **Publicar regras de segurança e índices** (na raiz do repo):

   ```bash
   firebase deploy --only firestore:rules,storage
   ```

   Incluindo índices do Firestore:

   ```bash
   firebase deploy --only firestore:rules,firestore:indexes,storage
   ```

#### Firebase Emulator Suite (opcional)

Use os [emuladores](https://firebase.google.com/docs/emulator-suite) para testar regras de Firestore/Storage localmente sem afetar produção.

- **Java:** O `firebase-tools` atual exige **JDK versão 21 ou superior** (`java -version` deve mostrar 21+). No macOS com Homebrew:

  ```bash
  brew install openjdk@21
  export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"
  export JAVA_HOME="/opt/homebrew/opt/openjdk@21"
  ```

  Para o sistema enxergar o Java 21 (substitui o aviso da Apple quando não há JRE):

  ```bash
  sudo ln -sfn /opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-21.jdk
  ```

- **Subir emuladores** (exemplo: Firestore + Storage):

  ```bash
  firebase emulators:start --only firestore,storage
  ```

  Portas padrão (se não mudar o `firebase.json`): **UI dos emuladores** `http://127.0.0.1:4000/`, **Firestore** `127.0.0.1:8080`, **Storage** `127.0.0.1:9199`.

  O comando correto é `firebase emulators:start` (com **t** em `start`).

  **Evite** rodar `firebase init emulators` e marcar **App Hosting**, **Hosting**, **Realtime Database** ou **Pub/Sub** para este app Flutter, a menos que você precise mesmo — o **App Hosting** exige um `startCommand` web e costuma falhar com *Failed to auto-detect your project's start command*. O [`firebase.json`](firebase.json) deste repositório só configura **Firestore**, **Storage** e a **UI dos emuladores**.

- **App Flutter:** Por padrão, `flutter run` usa o Firebase **em nuvem** de `firebase_options.dart`. Para apontar para emuladores é preciso chamar `useFirestoreEmulator` / `useStorageEmulator` (por exemplo atrás de uma flag de debug). Sem isso, use a UI dos emuladores e o [simulador de regras](https://firebase.google.com/docs/rules/simulator) para validar regras, ou teste direto no projeto de desenvolvimento na nuvem.

---

## Estrutura do projeto (resumida)

```
lib/
├── main.dart
├── firebase_options.dart          # local, fora do repo
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
    └── widgets/        # ex.: location_share_tile (copiar link do Maps)
```

Árvore completa e schema: **[planning/ARCHITECTURE.md](planning/ARCHITECTURE.md)** · Design: **[planning/DESIGN_SYSTEM.md](planning/DESIGN_SYSTEM.md)**

---

## Roadmap e progresso

**Núcleo do MVP (🔴 crítico) concluído** — ver [`planning/MVP_CHECKLIST.md`](planning/MVP_CHECKLIST.md). **Próximo:** itens 🟡 Importantes. Para **produção** (variáveis de build, Firebase, Instagram): [`planning/PRODUCTION.md`](planning/PRODUCTION.md). QA em dispositivo: [`planning/DEVICE_TESTING.md`](planning/DEVICE_TESTING.md).

| Documento | Função |
|-----------|--------|
| [planning/ROADMAP.md](planning/ROADMAP.md) | Roadmap por fases |
| [planning/MVP_CHECKLIST.md](planning/MVP_CHECKLIST.md) | Checklist diário |
| [planning/CHANGELOG.md](planning/CHANGELOG.md) | Histórico de releases |

---

## Visão de negócio (investidores)

- **Empresa:** C-Corp em Delaware (Stripe Atlas)
- **Fundadores:** Diego Rocha & Yuri Lima
- **Mercados:** Brasil primeiro; EUA depois
- **Público:** ~18–35 anos, uso intenso de Instagram/TikTok
- **Monetização:** Freemium agora; **pay-per-feature** após **~10k usuários**

Narrativa completa: **[planning/BUSINESS.md](planning/BUSINESS.md)**

---

## Contribuindo

1. Branch a partir de **`master`** (ou siga o fluxo do time se mudar).
2. Mantenha a UI alinhada ao **[planning/DESIGN_SYSTEM.md](planning/DESIGN_SYSTEM.md)**.
3. Atualize **[planning/MVP_CHECKLIST.md](planning/MVP_CHECKLIST.md)** ou **[planning/CHANGELOG.md](planning/CHANGELOG.md)** quando houver mudanças visíveis ao usuário.

---

## Licença e contato

**Licença:** a definir (TBD).

**Repositório:** [github.com/Yuri-Lima/openwhen](https://github.com/Yuri-Lima/openwhen) (branch `master`)

**Fundadores:** Diego Rocha & Yuri Lima

---

## Pasta de planejamento

| Arquivo | Descrição |
|---------|-----------|
| [planning/ROADMAP.md](planning/ROADMAP.md) | Fases 1–4 (MVP → monetização) |
| [planning/MVP_CHECKLIST.md](planning/MVP_CHECKLIST.md) | Acompanhamento do MVP |
| [planning/ARCHITECTURE.md](planning/ARCHITECTURE.md) | Stack, pastas, Firestore |
| [planning/DESIGN_SYSTEM.md](planning/DESIGN_SYSTEM.md) | Cores, tipografia, temas das cápsulas |
| [planning/BUSINESS.md](planning/BUSINESS.md) | Estratégia para investidores |
| [planning/CHANGELOG.md](planning/CHANGELOG.md) | Estilo Keep a Changelog |
| [planning/PRODUCTION.md](planning/PRODUCTION.md) | Checklist de produção (`dart-define`, Firebase, Meta/Instagram, lojas) |
