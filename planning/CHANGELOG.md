# Changelog

Todas as mudanças notáveis neste projeto serão documentadas aqui.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/),
e este projeto adere ao [Semantic Versioning](https://semver.org/lang/pt-BR/) onde aplicável.

---

## [Unreleased]

### Added

- **Carta — mensagem recolhível e voz opcional:** na escrita, o campo “mensagem” digitada começa recolhido (`AnimatedSize`, pré-visualização de uma linha) e expande ao toque; gravação de voz opcional com limite de **1 minuto** (política OpenWhen), upload para Cloud Storage em `voiceLetters/` no envio (`record`, `permission_handler`, `path_provider`; web sem gravação — stub). Campo Firestore `voiceUrl`; reprodução com `just_audio` + `audio_session` (best-effort no `main`) em `letter_detail_screen` e `letter_opening_screen`. Validação: `voice_url.dart`; UI: `voice_letter_tile.dart`; upload: `voice_letter_io.dart` / `voice_letter_stub.dart`. Regras Storage: `handwritten/` e `voiceLetters/` em [`storage.rules`](../storage.rules).
- **Link de música (cartas e cápsulas):** campo opcional `musicUrl` no Firestore; o autor cola um URL `https` (ex.: Spotify, YouTube Music). Na abertura e no detalhe, o destinatário usa “Ouvir música” e o sistema abre o link no browser ou na app do serviço (`url_launcher`, `LaunchMode.externalApplication`). Validação: `lib/shared/utils/music_url.dart`; UI partilhada: `lib/shared/widgets/music_link_tile.dart`. Modelo `Letter` inclui `musicUrl`.
- **Selo animado (coruja)** na abertura da carta e no hero do login: olhos, revelação de asas/corpo, voo, lacre só em vermelho, reaparição do rosto completo **sem asas**; detalhe dos olhos (sobrancelha/cílios), tufts e penas; `OwlSealArt` / `OwlSealOpeningAnimation` em `lib/shared/widgets/owl_logo.dart`.
- **Feedback pela coruja nos headers:** `OwlFeedbackAffordance` envolve o glifo da coruja (`OwlWatermark` / `OwlLogo`); toque abre o mesmo bottom sheet que `FeedbackEntryButton` via `showFeedbackSheet`. Animação idle: oscilação + fase de “vibração” rápida, repetida em intervalos aleatórios por visita ao ecrã. FAB global de feedback permanece para utilizadores sem sessão (`main.dart`).

### Changed

- `planning/ROADMAP.md` e `planning/BUSINESS.md`: inclusão de cartões-presente (compra e resgate) na fase de monetização.

### Fixed

- **Onboarding:** overflow vertical em ecrãs curtos — `PageView` com `Positioned.fill` + página com scroll e altura mínima (`onboarding_screen.dart`).

---

## [0.9.0] - 2026-03-23

### Contexto

Release de referência alinhada ao estado do MVP (~**92%**). Consolida funcionalidades já implementadas no repositório e documentação em `planning/`.

### Added (usuário)

- Onboarding, autenticação (login/cadastro), splash
- Feed com curtidas, comentários e filtros por emoção
- Cofre com abas: aguardando, abertas e **cápsulas**
- Escrever cartas, detalhe, leitura e animação de abertura
- Pedidos de carta, QR Code e compartilhamento
- Perfil (próprio e outros), busca por @username, configurações
- Telas legais (termos, privacidade, sobre, ajuda)
- **Cápsulas do tempo:** fluxo em 3 passos (Tema → Perguntas → Detalhes), persistência Firestore, listagem no cofre
- FAB com bottom sheet: nova carta ou nova cápsula
- Seguidores, bloqueios, moderação em comentários

### Added (projeto)

- Pasta `planning/` com roadmap, checklist de MVP, arquitetura, design system, negócio e changelog
- README voltado a desenvolvedores e investidores

### Known limitations / próximos passos

- Tela dedicada de **abertura da cápsula** (revelação + publicar após revisão)
- **Avatar** com upload estável em web e mobile
- **FCM** end-to-end
- **Regras Firestore** de produção e testes em dispositivo real

[0.9.0]: https://github.com/Yuri-Lima/openwhen/releases
