# OpenWhen — Checklist do MVP

Use este arquivo para acompanhamento diário. Marque `[x]` quando concluído.

**Legenda:** 🔴 crítico · 🟡 importante · 🟢 pós-MVP

---

## 🔴 Crítico (bloqueadores do MVP "completo")

- [x] Tela de **abertura da cápsula** (animação, revelar perguntas/respostas, fluxo de publicar após revisão)
- [x] **Avatar de perfil** com upload (funcional em web e mobile)
- [x] **Notificações FCM** (configuração, permissões, handlers)
- [x] **Testes em celular real** (build iOS/Android, fluxos principais) — ver [`DEVICE_TESTING.md`](DEVICE_TESTING.md)
- [x] **Regras Firestore de produção** (deploy e validação) — `firestore.rules` + `storage.rules`; executar `firebase deploy --only firestore:rules,storage`

---

## 🟡 Importante (logo após o núcleo do MVP)

- [ ] Fotos na cápsula (mobile; comportamento explícito no web)
- [ ] Compartilhamento Stories/Reels
- [ ] Tela **Cartas recebidas** dedicada
- [ ] Badges / gamificação leve
- [x] **Temas do app** (várias paletas + opção automática/sistema) — `open_when_palette.dart` (classic, dark, midnight, sepia) + `theme_provider.dart` + seletor em Configurações
- [ ] Feed em **3 camadas**
- [ ] Exportar cartas (PDF / ZIP)
- [x] **Multilíngue (pt-BR, en, es)**
  - [x] `flutter_localizations` + `gen-l10n` (ARB `app_pt_BR`, `app_en`, `app_es`)
  - [x] **Idioma padrão:** detectar locale do sistema (`PlatformDispatcher`); mapear `pt*` → pt-BR, `es*` → es, `en*` → en; demais → fallback pt-BR
  - [x] **Override:** usuário escolhe em Configurações; persistir (`shared_preferences`); prioridade sobre o sistema
  - [x] Opção **"Automático (sistema)"** no seletor de idioma
  - [x] Review e migração de **todos** os textos hardcoded nas telas para `AppLocalizations`

---

## 🟢 Pós-MVP

- [ ] Cápsula coletiva
- [ ] Música de fundo
- [ ] Voz gravada
- [ ] Moderação por IA
- [ ] Premium pay-per-feature (após ~10k usuários)

---

## Concluído (referência)

### Autenticação e onboarding

- [x] Splash
- [x] Onboarding
- [x] Login
- [x] Cadastro

### Cartas e cofre

- [x] Escrever carta
- [x] Cofre com abas (Aguardando / Abertas / Cápsulas)
- [x] Detalhe da carta
- [x] Animação de abertura por estado emocional
- [x] **Selo / coruja na abertura da carta** — sequência no lacre (`OwlSealOpeningAnimation` em `lib/shared/widgets/owl_logo.dart`): olhos, revelação de asas/corpo, voo, pausa só no lacre, rosto completo de volta **sem asas**; toque só na área do selo
- [x] **Login** — mesmo selo animado no hero (toque no lacre; `AnimationController` com inicialização lazy para hot reload)
- [x] Leitura da carta
- [x] Pedidos de carta
- [x] QR Code (gerar e compartilhar)

### Cápsulas do tempo

- [x] Fluxo criar cápsula (Tema → Perguntas → Detalhes)
- [x] Persistência em Firestore (`capsules`)
- [x] Listagem no Cofre (aba Cápsulas)
- [x] FAB com bottom sheet: Carta ou Cápsula

### Social e perfil

- [x] Feed estilo Instagram
- [x] Curtidas e comentários em tempo real
- [x] Filtros por emoção (feed)
- [x] Seguidores (`follows`)
- [x] Conta pública/privada
- [x] Perfil próprio e de outros
- [x] Busca por @username
- [x] Bloqueios (`blocks`)
- [x] Comentários com moderação
- [x] Configurações
- [x] Termos, Privacidade, Sobre, Ajuda

### Bugfixes recentes

- [x] **Onboarding** — `Column` overflow em ecrãs baixos: `PageView` com `Positioned.fill`, conteúdo com `SingleChildScrollView` + `ConstrainedBox(minHeight:)` (`onboarding_screen.dart`)
- [x] **Sair da conta** não redirecionava (popUntil até raiz após signOut em `settings_screen.dart`)
- [x] **Contraste em temas escuros** — splash, onboarding e hero do login usavam `context.pal.ink` (cor de texto) como fundo, ficando claro em midnight/dark; corrigido para `context.pal.headerGradient.first`
- [x] **Contraste (acessibilidade)** — fluxo **criar cápsula** usa `OpenWhenPalette` em vez de cores fixas; botão desabilitado sem `AnimatedOpacity` (cores `inkFaint`/`inkSoft`); **Configurações** com subtítulos em `inkSoft`; **bottom sheet da foto de perfil** (`avatar_upload_helper.dart`) com fundo e texto do tema

### Infra

- [x] Firebase (Auth, Firestore, Storage, FCM dependência no projeto)
- [x] Índices Firestore deployados (incl. cápsulas)

---

**Progresso MVP (estimativa):** ~100% — itens 🔴 Crítico implementados no código; validar deploy das regras e QA em dispositivo físico.
