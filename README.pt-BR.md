<div align="center">

<a href="README.md" target="_blank" rel="noopener noreferrer">English</a> · **Português (Brasil)**

# OpenWhen

**Escreva hoje. Sinta amanhã.** · *Write today. Feel tomorrow.*

[![Flutter](https://img.shields.io/badge/Flutter-3.41.4-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11.1-0175C2?logo=dart)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-openwhen--923f5-FFCA28?logo=firebase)](https://firebase.google.com)
[![MVP](https://img.shields.io/badge/MVP-~92%25-success)](planning/MVP_CHECKLIST.md)

*Cartas temporizadas, cápsulas do tempo e uma camada social emocional — com QR Code físico ligando o mundo real ao app.*

[Roadmap](planning/ROADMAP.md) · [Checklist MVP](planning/MVP_CHECKLIST.md) · [Arquitetura](planning/ARCHITECTURE.md) · [Negócio](planning/BUSINESS.md)

</div>

---

## O que é o OpenWhen?

O OpenWhen é um produto social multiplataforma para **escrever mensagens que desbloqueiam no futuro** — combinando **cartas agendadas**, **cápsulas do tempo guiadas** e um **feed** pensado para emoção, não só engajamento. Um fluxo de **QR Code** leva memórias do mundo físico para dentro do app.

**Para quem usa:** expressar o que importa, agendar com intenção e abrir no momento certo.

**Para quem constrói e investe:** Flutter + Firebase, código organizado por features e roadmap focado em fechar o MVP antes de escalar a monetização.

---

## Principais recursos

| Área | Destaques |
|------|-----------|
| **Cartas** | Escrever, agendar, animação de abertura por emoção, gerar QR e compartilhar |
| **Cápsulas do tempo** | Temas (memórias, metas, sentimentos, relacionamentos, crescimento), 2–5 perguntas e respostas, abertura por data/evento |
| **Social** | Feed estilo Instagram, curtidas e comentários, seguidores, privacidade, moderação |
| **Cofre** | Abas: aguardando, abertas e **cápsulas** |
| **Perfil** | Perfil próprio e de outros, busca por @username, configurações, páginas legais |

---

## Stack técnica

| Camada | Escolha |
|--------|---------|
| **UI** | Flutter (Material 3) |
| **Estado** | Riverpod |
| **Backend** | Firebase Auth, Cloud Firestore, Storage, Cloud Messaging |
| **Navegação** | Rotas do `MaterialApp` + navegação imperativa; `go_router` disponível para evolução |
| **Fontes** | Google Fonts (DM Serif Display + DM Sans) |

A arquitetura é **por features** em `lib/features/`, com auth em camadas `data` / `domain` / `presentation`. Veja **[planning/ARCHITECTURE.md](planning/ARCHITECTURE.md)** para a árvore de pastas e coleções do Firestore.

---

## Como rodar

### Pré-requisitos

- Flutter **3.41.4** (ou canal compatível) e Dart **3.11.1+**
- Firebase CLI (opcional, para ferramentas locais)
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

- **ID do projeto:** `openwhen-923f5`
- O arquivo **`lib/firebase_options.dart`** é obrigatório para rodar o app e **não** está no repositório público. Solicite ao time e coloque em `lib/` antes do build.

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
└── shared/theme/
```

Árvore completa e schema: **[planning/ARCHITECTURE.md](planning/ARCHITECTURE.md)** · Design: **[planning/DESIGN_SYSTEM.md](planning/DESIGN_SYSTEM.md)**

---

## Roadmap e progresso

**~92% do MVP concluído.** Próximos passos críticos: experiência de abertura da cápsula, upload de avatar, notificações FCM, testes em dispositivo real, regras Firestore de produção.

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
