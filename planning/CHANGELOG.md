# Changelog

Todas as mudanças notáveis neste projeto serão documentadas aqui.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/),
e este projeto adere ao [Semantic Versioning](https://semver.org/lang/pt-BR/) onde aplicável.

---

## [Unreleased]

### Docs

- **Feed (arquitetura e custo):** [`ARCHITECTURE.md`](ARCHITECTURE.md) — secção “Feed” atualizada (Explorar / Destaques / Seguindo, chips fixados até 3 com `feed_pinned_filters_provider`, ícone de filtros à direita, `explore_feed_paged` / `following_feed_body`, merge `whereIn`). [`PRODUCTION.md`](PRODUCTION.md) — tabela Firestore com nota de custo do feed Seguindo e paginação em Explorar.
- **Roadmap e README:** [`ROADMAP.md`](ROADMAP.md) Fase 2 — badges e feed em 3 camadas como **Concluído** (alinhado a [`MVP_CHECKLIST.md`](MVP_CHECKLIST.md)); Fase 3 — linha de export renomeada para evoluções (MVP de export no checklist). [`README.md`](../README.md) / [`README.pt-BR.md`](../README.pt-BR.md) — tabelas “Social” e “Perfil” com camadas do feed, chips fixados e export. [`MVP_CHECKLIST.md`](MVP_CHECKLIST.md) — detalhe nos filtros do feed.
- **Produção:** [`PRODUCTION.md`](PRODUCTION.md) — checklist para build/lojas (`dart-define` `FB_APP_ID`, `BILLING_ENABLED`, `FUNCTIONS_REGION`), ficheiros Firebase e referências cruzadas.
- **Planejamento:** alinhamento de [`ROADMAP.md`](ROADMAP.md), [`CHANGELOG.md`](CHANGELOG.md) (release 0.9.0), [`README.md`](../README.md) / [`README.pt-BR.md`](../README.pt-BR.md), [`ARCHITECTURE.md`](ARCHITECTURE.md) e [`DEVICE_TESTING.md`](DEVICE_TESTING.md) com o estado em [`MVP_CHECKLIST.md`](MVP_CHECKLIST.md) (fonte de verdade para itens concluídos).

### Added

- **Partilha Instagram Stories (nativo iOS/Android):** `MethodChannel` `com.openwhen.app/instagram_stories` — iOS: pasteboard + `instagram-stories://share`; Android: `Intent` `com.instagram.share.ADD_TO_STORY` + `FileProvider` (`${applicationId}.fileprovider`). PNG 1080×1920 gerado em `StoryAssetBuilder` a partir de `StoryShareContent` (allowlist: título truncado, data, QR com deep link; **sem** corpo da carta nem Q&A). Fallback: `share_plus`. Configuração: `--dart-define=FB_APP_ID=…` ([`lib/core/config/facebook_app_config.dart`](../lib/core/config/facebook_app_config.dart)). UI: detalhe da carta, ecrã QR, cápsula (bottom sheet: Stories vs texto). Ver [`ARCHITECTURE.md`](ARCHITECTURE.md) (secção “Partilha social / Instagram Stories”).
- **Teclado — fechar global:** botão flutuante acima do teclado virtual quando este está aberto (`MediaQuery.viewInsets.bottom > 0`), registado no `MaterialApp.builder` (`lib/shared/widgets/keyboard_dismiss_overlay_button.dart`); toque remove o foco (`FocusManager`). Strings em ARB (en, pt, pt-BR, es). Ver [`ARCHITECTURE.md`](ARCHITECTURE.md) (secção “Overlays globais”).
- **Cofre — filtro e ordenação avançados:** ícone de ajustes no header abre bottom sheet com opções por aba (Aguardando, Abertas, Enviadas, Cápsulas): texto, ordenação, intervalo de data de abertura onde aplicável, recebidas/enviadas, só pendentes, temas de cápsula. Filtros aplicados **no cliente** sobre os resultados das queries Firestore existentes (`lib/features/letters/presentation/vault_list_filters.dart`, `widgets/vault_filter_sheet.dart`). Strings em ARB (pt-BR, en, es, pt). Ver `planning/ARCHITECTURE.md`.
- **Localização opcional (cartas e cápsulas):** ao gravar, diálogos perguntam se o remetente partilha a localização atual com o destinatário (`geolocator`; permissões Android/iOS/macOS) e, em seguida, se a abertura fica restrita a **≤ 10 m** desse ponto. Firestore: `senderLocation` (`lat`, `lng`, `capturedAt`), `openRequiresProximity`. Detalhe: tile escuro copia URL do Google Maps (`location_share_tile.dart`). Cofre: `openLetterWithProximityGate` / `openCapsuleWithProximityGate` antes dos ecrãs de abertura. Modelo `Letter` atualizado. A checagem de proximidade é **só no cliente** (ver `planning/ARCHITECTURE.md`).
- **Carta — mensagem recolhível e voz opcional:** na escrita, o campo “mensagem” digitada começa recolhido (`AnimatedSize`, pré-visualização de uma linha) e expande ao toque; gravação de voz opcional com limite de **1 minuto** (política OpenWhen), upload para Cloud Storage em `voiceLetters/` no envio (`record`, `permission_handler`, `path_provider`; web sem gravação — stub). Campo Firestore `voiceUrl`; reprodução com `just_audio` + `audio_session` (best-effort no `main`) em `letter_detail_screen` e `letter_opening_screen`. Validação: `voice_url.dart`; UI: `voice_letter_tile.dart`; upload: `voice_letter_io.dart` / `voice_letter_stub.dart`. Regras Storage: `handwritten/` e `voiceLetters/` em [`storage.rules`](../storage.rules).
- **Link de música (cartas e cápsulas):** campo opcional `musicUrl` no Firestore; o autor cola um URL `https` (ex.: Spotify, YouTube Music). Na abertura e no detalhe, o destinatário usa “Ouvir música” e o sistema abre o link no browser ou na app do serviço (`url_launcher`, `LaunchMode.externalApplication`). Validação: `lib/shared/utils/music_url.dart`; UI partilhada: `lib/shared/widgets/music_link_tile.dart`. Modelo `Letter` inclui `musicUrl`.
- **Selo animado (coruja)** na abertura da carta e no hero do login: olhos, revelação de asas/corpo, voo, lacre só em vermelho, reaparição do rosto completo **sem asas**; detalhe dos olhos (sobrancelha/cílios), tufts e penas; `OwlSealArt` / `OwlSealOpeningAnimation` em `lib/shared/widgets/owl_logo.dart`.
- **Feedback pela coruja nos headers:** `OwlFeedbackAffordance` envolve o glifo da coruja (`OwlWatermark` / `OwlLogo`); toque abre o mesmo bottom sheet que `FeedbackEntryButton` via `showFeedbackSheet`. Animação idle: oscilação + fase de “vibração” rápida, repetida em intervalos aleatórios por visita ao ecrã. FAB global de feedback permanece para utilizadores sem sessão (`main.dart`).

### Changed

- **Feed — preview de comentários:** no card (`feed_screen.dart`, `_buildCommentsPreview`), cada comentário longo fica limitado a **4 linhas** com reticências (como o corpo da carta). **Ler mais** (`feedReadMore`) aparece quando a heurística indica texto longo (> 120 caracteres ou ≥ 4 linhas) e expande só aquele comentário no preview (estado por ID Firestore `_expandedCommentPreviewIds`). O link **Ver todos os N comentários** e o limite 2 → 20 no preview mantêm-se. Ver [`ARCHITECTURE.md`](ARCHITECTURE.md) (secção “Feed”).
- **Planejamento:** OpenWhen Gift (Presente Selado / Gift When) e Nox Card descritos em [`ROADMAP.md`](ROADMAP.md), [`BUSINESS.md`](BUSINESS.md), [`MVP_CHECKLIST.md`](MVP_CHECKLIST.md) e nota em [`ARCHITECTURE.md`](ARCHITECTURE.md); conteúdo que estava em `planning/GIFT_FEATURE.md` foi integrado e esse arquivo removido. Política documentada no roadmap: novas ideias entram nas tabelas e no checklist, não em um `.md` por feature.

### Fixed

- **Onboarding:** overflow vertical em ecrãs curtos — `PageView` com `Positioned.fill` + página com scroll e altura mínima (`onboarding_screen.dart`).

---

## [0.9.0] - 2026-03-23

### Contexto

Release de referência histórica (março/2026). Na época, o MVP ainda tinha lacunas documentadas em “Known limitations” abaixo; **após** esta tag, os itens críticos foram fechados no código — ver estado atual em [`MVP_CHECKLIST.md`](MVP_CHECKLIST.md) (🔴 Crítico) e [`ROADMAP.md`](ROADMAP.md) Fase 1.

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

### Known limitations / próximos passos *(no momento da release 0.9.0)*

Itens abaixo refletem o backlog **na data desta release**; não o estado atual do repositório.

- Tela dedicada de **abertura da cápsula** (revelação + publicar após revisão)
- **Avatar** com upload estável em web e mobile
- **FCM** end-to-end
- **Regras Firestore** de produção e testes em dispositivo real

**Atualização:** estes pontos foram subsequentemente concluídos e estão marcados no checklist (🔴). Próximo foco de produto: itens 🟡 Importante — ver [`MVP_CHECKLIST.md`](MVP_CHECKLIST.md) e [`ROADMAP.md`](ROADMAP.md) Fase 2.

[0.9.0]: https://github.com/Yuri-Lima/openwhen/releases
