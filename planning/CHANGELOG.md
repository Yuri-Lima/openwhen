# Changelog

Todas as mudanças notáveis neste projeto serão documentadas aqui.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/),
e este projeto adere ao [Semantic Versioning](https://semver.org/lang/pt-BR/) onde aplicável.

---

## [Unreleased]

### Added

- **Rascunhos de carta (Drafts):** nova coleção Firestore `drafts` com auto-save (debounce 5 s), TTL Policy no campo `expiresAt` (30 dias, deleção automática server-side). `DraftService` com CRUD, limpeza client-side de expirados, limite de 10 drafts/utilizador (`draftCount` no user doc), e migração one-time do SharedPreferences legado. `DraftsScreen` com listagem, emoji badges, barra de countdown (cores por urgência), swipe-to-delete com confirmação. Navegação via FAB ("Rascunhos") e ícone no header do WriteLetterScreen. 10 chaves i18n (en/pt/pt-BR/es) com plurais ICU. Novos ficheiros: `draft_model.dart`, `draft_service.dart`, `drafts_screen.dart`, `emotional_state.dart` (extraído para resolver dependência circular). Regras Firestore para `drafts/{draftId}` com proteção de campos imutáveis.
- **Restrição de processamento — GDPR Art. 18:** `ProcessingRestrictionService` com `accountStatus: 'restricted'`. UI no Settings com toggle dinâmico + diálogo de confirmação. 8 chaves i18n (en/pt/pt-BR/es).
- **Access logs — Marco Civil Art. 15:** Cloud Function `logAccess` + `purgeOldAccessLogs` (6 meses). IP server-side, UID pseudonimizado (HMAC-SHA-256). Client: `AccessLogService.logLogin()` fire-and-forget.
- **Hash criptográfico em audit logs:** `hashUid()` (HMAC-SHA-256) substitui `simpleHash()` (djb2) em 4 ficheiros backend. `simpleHash()` deprecated.
- **Audit trail de privacidade completo:** `PrivacyLogService` expandido com `logDeletionRequest`, `logDeletionCancellation`, `logReauthentication`. Firestore rules whitelist actualizada.
- **Export completo — cápsulas recebidas + GPS:** query `participantUids array-contains uid` para incluir cápsulas recebidas. Coordenadas GPS exportadas como `{latitude, longitude}`.
- **Re-autenticação social para eliminação de conta:** detecção automática de provider (Apple/Google/email). Re-auth social dentro do `_DeleteAccountSheet`. 4 chaves i18n.
- **Cloud Functions de retenção automática:** `anonymizeOldFeedback` (1 ano), `purgeOldModerationLogs` (2 anos), `anonymizeResolvedReports` (90 dias) — cumprem compromissos da Política de Privacidade §9.
- **Exportação completa de dados — GDPR Art. 20 / LGPD Art. 18:** `CompleteExportService` com ZIP (perfil, cartas, cápsulas, comentários, likes, follows, badges + media). Queries paginadas (500/batch). Export gratuito para todos.
- **Consentimento de analytics EU/EEA/UK — ePrivacy:** Analytics desativado por defeito. Banner slide-up para EU/EEA/UK. Toggle no Settings. Auto-grant fora da EU. 6 chaves ARB.
- **Verificação de idade por jurisdição — GDPR Art. 8 / COPPA:** date picker no registro + age gate modal no login social. Idade mínima por país (13–16). Campo `dateOfBirth` no `AppUser`.
- **Aviso emocional antes de abrir carta:** tela one-time “Essa carta pode ser emocional” com opção de adiar. Flag via `SharedPreferences`.
- **Sign in with Apple:** `OAuthProvider('apple.com')` com nonce SHA-256. Entitlements configurados. Visível só iOS.
- **Google Sign-In:** `GoogleSignIn` + `GoogleAuthProvider.credential`. `REVERSED_CLIENT_ID` no `Info.plist`. Todas as plataformas.
- **Social sign-in ativado:** `kSocialSignInEnabled = true`. Botões Apple (iOS) + Google (all).
- **SMTP na Política de Privacidade:** secção 7(a) actualizada para Google Workspace. SendGrid mantido em 7(c) para emails de convite.
- **Sistema de re-consentimento de políticas — Seção 16:** versionamento de políticas, banner informativo (15 dias), dialog full-screen (obrigatório). Cloud Function `sendPolicyUpdateEmails` batch multi-idioma. 11 chaves i18n.
- **Página de suporte (FAQ):** `support.html` com 7 FAQs, EN/PT/ES, dark mode. URL: `whenote.app/support`.
- **Moderação de mídia:** Cloud Function `moderateUploadedFile` (Storage trigger). Imagens: OpenAI omni-moderation. Áudio: Whisper + moderação de texto. Fail-open.
- **Política de Privacidade completa (LGPD + GDPR + CCPA/CPRA + COPPA):** reescrita total com 17 seções, 3 idiomas.
- **Termos de Uso — encerramento de serviço:** Seção 7, aviso 90 dias, Fundo de Continuidade. 3 idiomas.
- **Aviso de cartas pendentes na exclusão de conta:** banner amarelo explicando impacto nos dois modos.
- **Plano de contingência de encerramento:** cronograma 90 dias, 4 cenários de cartas pendentes.
- **Páginas web públicas:** `privacy.html` e `terms.html` com EN/PT/ES e dark mode.
- **Deleção de conta completa (GDPR/LGPD):** Cloud Function `deleteUserAccount` com 15 etapas. Dois modos: “Excluir Tudo” e “Anonimizar cartas”.
- **Política de retenção de dados:** `DATA_RETENTION_POLICY.md` com mapeamento de 15 coleções + 4 paths Storage.
- **Kit de ícones:** SVGs em `assets/icons/`, `WhenoteIcons`, flutter_launcher_icons (Android adaptativo + iOS).
- **Cápsula coletiva:** modo singleAuthor com convites, `participantUids`, regras Firestore, cofre com streams fundidas.
- **Partilha Instagram Stories (nativo):** `MethodChannel` iOS/Android. PNG 1080×1920. Fallback `share_plus`. Config: `FB_APP_ID`.
- **Fechar teclado global:** botão flutuante via `MaterialApp.builder`.
- **Cofre — filtro e ordenação avançados:** bottom sheet com filtros por aba (texto, ordenação, data, tema).
- **Localização opcional:** GPS ao criar carta/cápsula + abertura restrita a ≤10 m.
- **Carta — voz opcional:** gravação 1 min, upload Storage, reprodução `just_audio`.
- **Link de música:** campo `musicUrl` com abertura externa (Spotify, YouTube Music).
- **Selo animado (coruja):** animação de abertura e hero do login.
- **Feedback pela coruja:** `OwlFeedbackAffordance` nos headers com animação idle.

### Fixed

- **Dados stale ao criar carta:** draft do SharedPreferences não era limpo após envio bem-sucedido; formulário retinha dados da última carta. Corrigido com `_clearDraft()` no callback de sucesso + migração para Firestore.
- **NSLocationAlwaysAndWhenInUseUsageDescription:** re-adicionado ao Info.plist (App Store warning 90683).
- **Cursor preso + copiar/colar ausente na carta:** `GestureDetector` global substituído por `TapRegion` isolado. Campo mensagem unificado em `TextField`. Bloqueador B2 fechado.
- **Moderação lexical alinhada:** lista e SnackBar partilhados entre cartas, cápsulas e comentários.
- **Bug avatar path:** método morto `_pickAndUploadAvatar()` removido. Upload só via `AvatarService`.
- **Página de ação customizada (auth):** `action.html` dark theme, Firebase JS SDK v10.12.0.
- **SMTP SendGrid → Workspace:** migração documentada (histórico).
- **Redirect pós-registro:** `popUntil` para `AuthWrapper` redirecionar à `HomeScreen`.
- **Email externo + bounce:** validação regex, banner de reenvio, webhook SendGrid com ECDSA, rate limiting.
- **Deploy email bounce:** secrets migrados para `defineSecret()`, `resendExternalInviteEmail` em produção.
- **`preferredLanguage` sync:** campo adicionado na criação + sync real-time no Settings.
- **Feed — botões busca/notificações:** `_iconBtn` refactorado com `onTap`, a11y e ripple.
- **Busca — erros silenciosos:** `catch (_)` → `catch (e)` com `debugPrint` em debug mode.
- **Enviar carta — permission-denied:** regras `badgeUnlocks` e billing corrigidas. Envio em `runTransaction`.
- **Admin — SIGABRT:** loaders adiados com `addPostFrameCallback`, callables em série.
- **Busca de utilizadores (escala):** `UserSearchService` com queries limitadas (30 docs) substituiu `collection('users').get()`.
- **Admin — TabBar e overflow:** `isScrollable: true`, `_BidirectionalScrollText` nos cartões.
- **Onboarding overflow:** `PageView` com `Positioned.fill` + scroll.

### Changed

- **Animação da coruja removida da abertura de carta:** `OwlSealOpeningAnimation` substituído por `Icon(Icons.lock_rounded)` em `letter_opening_screen.dart`. `AnimationController` de 5.5 s removido, reduzindo tempo de abertura.
- **GPC removido da Política de Privacidade:** não aplicável a apps nativos. Re-adicionar com versão web.
- **SMTP migrado para Google Workspace Relay (2026-04-26):** `smtp-relay.gmail.com:587`, sender `noreply@whenote.com`.
- **Envio carta — botão OK removido:** email validado automaticamente ao clicar “Enviar carta”.
- **Toggle privacidade invertido:** `_isPrivate = true` por defeito (cadeado ligado).
- **Cápsula — rótulo coletivo:** texto reduzido a uma palavra.
- **Feed — preview de comentários:** limite 4 linhas com “Ler mais” por comentário.

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

[0.9.0]: https://github.com/Yuri-Lima/whenote/releases
