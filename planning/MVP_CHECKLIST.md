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

- [ ] **Sign in with Apple** — Firebase Auth (`OAuthProvider` + nonce), pacote `sign_in_with_apple`, capability no App ID, provedor Apple no Firebase Console, ligar o botão em `login_screen.dart` (hoje só UI)
- [x] Fotos na cápsula (mobile; web desabilitado com aviso)
- [x] Compartilhamento Stories/Reels
- [x] Tela **Cartas recebidas** dedicada (locked + opened numa aba, com filtros)
- [x] Badges / gamificação leve
- [x] **Temas do app** (várias paletas + opção automática/sistema) — `open_when_palette.dart` (classic, dark, midnight, sepia) + `theme_provider.dart` + seletor em Configurações
- [x] Feed em **3 camadas**
- [x] Exportar cartas (PDF / ZIP)
- [x] **Multilíngue (pt-BR, en, es)**
  - [x] `flutter_localizations` + `gen-l10n` (ARB `app_pt_BR`, `app_en`, `app_es`)
  - [x] **Idioma padrão:** detectar locale do sistema (`PlatformDispatcher`); mapear `pt*` → pt-BR, `es*` → es, `en*` → en; demais → fallback pt-BR
  - [x] **Override:** usuário escolhe em Configurações; persistir (`shared_preferences`); prioridade sobre o sistema
  - [x] Opção **"Automático (sistema)"** no seletor de idioma
  - [x] Review e migração de **todos** os textos hardcoded nas telas para `AppLocalizations`

---

## 🟢 Pós-MVP

- [x] **Cápsula coletiva** (grupo que abre junto; só o criador escreve) — `participantUids`, `isCollective`, `participantNames`, `contentMode: singleAuthor`; Cofre e badge com merge de queries (`capsule_vault_streams.dart`); regras `firestore.rules` + índice composto `participantUids` + `status` + `isCollective`
- [ ] **Contribuições múltiplas antes de selar** — cada participante adiciona respostas/blocos; subcoleção `contributions` + `contentMode: multiContributor`; ver [`ROADMAP.md`](ROADMAP.md) Fase 3
- [ ] Música de fundo (reprodução dentro do app — distinto do **link externo** opcional já suportado em cartas/cápsulas)
- [x] **Moderação por IA** (base) — Cloud Functions `moderateContent` + adapter OpenAI (`functions/src/moderation/`); `systemConfig/app` (`aiModerationEnabled`, `aiModerationFailClosed`); comentários em [`comments_screen.dart`](../lib/features/feed/presentation/screens/comments_screen.dart); incidentes `moderationIncidents` + aba admin; [`functions/README.md`](../functions/README.md) · [`ARCHITECTURE.md`](ARCHITECTURE.md)
- [ ] Premium pay-per-feature (após ~10k usuários)

---

## Futuro — Gift & Nox (pós-escala; ver [`ROADMAP.md`](ROADMAP.md) Fase 2 / 4 e [`BUSINESS.md`](BUSINESS.md))

**OpenWhen Gift (Presente Selado / Gift When)**

- [ ] Aprovado para desenvolvimento futuro
- [ ] Pesquisa legal concluída (*money transmission* EUA e requisitos locais)
- [ ] Integração Stripe Connect configurada (conta aprovada)
- [ ] Termos de uso e política de reembolso atualizados
- [ ] MVP Gift desenvolvido e validado
- [ ] Lançado

**Nox Card (card da coruja)**

- [ ] Nome do mascote definido
- [ ] Animação do card criada
- [ ] Integração com Gift When (Fase 1 do Gift)
- [ ] Compartilhamento para Stories e Reels
- [ ] Cards colecionáveis (futuro)

---

## Concluído (referência)

### Autenticação e onboarding

- [x] Splash
- [x] Onboarding
- [x] Login
- [x] Cadastro

### Cartas e cofre

- [x] Escrever carta (mensagem digitada recolhível por defeito; voz opcional até 1 min + `voiceUrl`)
- [x] Cofre com abas (Aguardando / Abertas / Enviadas / Cápsulas)
- [x] **Filtro e ordenação no Cofre** — bottom sheet por aba (busca, sort, datas, origem, pendentes, temas); processamento em memória após o snapshot (`vault_list_filters.dart`, `vault_filter_sheet.dart`)
- [x] Detalhe da carta
- [x] Animação de abertura por estado emocional
- [x] **Selo / coruja na abertura da carta** — sequência no lacre (`OwlSealOpeningAnimation` em `lib/shared/widgets/owl_logo.dart`): olhos, revelação de asas/corpo, voo, pausa só no lacre, rosto completo de volta **sem asas**; toque só na área do selo
- [x] **Login** — mesmo selo animado no hero (toque no lacre; `AnimationController` com inicialização lazy para hot reload)
- [x] Leitura da carta
- [x] Pedidos de carta
- [x] QR Code (gerar e compartilhar)
- [x] **Link opcional de música** (`musicUrl` em Firestore — só `https`; abre no browser ou app do serviço; cartas e cápsulas)
- [x] **Mensagem de voz opcional na carta** (`voiceUrl` — Storage `voiceLetters/`, reprodução in-app ao abrir; limite 1 min)
- [x] **Localização opcional** (`senderLocation`, `geolocator`) — diálogos ao enviar; destinatário copia link do Maps no detalhe
- [x] **Abertura só no local (10 m)** (`openRequiresProximity`) — gate no Cofre antes da animação de abertura (verificação no cliente)

### Cápsulas do tempo

- [x] Fluxo criar cápsula (Tema → Perguntas → Detalhes)
- [x] Persistência em Firestore (`capsules`)
- [x] Listagem no Cofre (aba Cápsulas; inclui cápsula coletiva para criador e convidados — streams fundidas)
- [x] FAB com bottom sheet: Carta ou Cápsula
- [x] Mesma **localização opcional** e **restrição 10 m** que nas cartas (campos Firestore alinhados)

### Social e perfil

- [x] Feed estilo Instagram
- [x] Curtidas e comentários em tempo real
- [x] Filtros por emoção (feed) — até **3** chips fixados pelo utilizador (`feed_pinned_filters_provider`); tipo de feed (Explorar / Destaques / Seguindo) no bottom sheet
- [x] Seguidores (`follows`)
- [x] Conta pública/privada
- [x] Perfil próprio e de outros
- [x] Busca por @username
- [x] Bloqueios (`blocks`)
- [x] Comentários com moderação
- [x] Configurações
- [x] Termos, Privacidade, Sobre, Ajuda

### Escala (Firestore)

- [x] **Busca de utilizadores** — *Problema até ~abril/2026:* `collection(users).get()` na Buscar, convites de cápsula coletiva e destinatário da carta. *Correção:* `lib/core/user_search/` (`UserSearchService`, `searchTokens`, queries limitadas). Ver [`CHANGELOG.md`](CHANGELOG.md) e [`ARCHITECTURE.md`](ARCHITECTURE.md).

### Bugfixes recentes

- [x] **Analytics (login)** — `logLogin()` só depois de `login()` bem-sucedido (`AsyncValue` sem erro); falha de credenciais mostra `SnackBar` (o notifier usa `guard` e não relança exceção)
- [x] **Onboarding** — `Column` overflow em ecrãs baixos: `PageView` com `Positioned.fill`, conteúdo com `SingleChildScrollView` + `ConstrainedBox(minHeight:)` (`onboarding_screen.dart`)
- [x] **Sair da conta** não redirecionava (popUntil até raiz após signOut em `settings_screen.dart`)
- [x] **Contraste em temas escuros** — splash, onboarding e hero do login usavam `context.pal.ink` (cor de texto) como fundo, ficando claro em midnight/dark; corrigido para `context.pal.headerGradient.first`
- [x] **Contraste (acessibilidade)** — fluxo **criar cápsula** usa `OpenWhenPalette` em vez de cores fixas; botão desabilitado sem `AnimatedOpacity` (cores `inkFaint`/`inkSoft`); **Configurações** com subtítulos em `inkSoft`; **bottom sheet da foto de perfil** (`avatar_upload_helper.dart`) com fundo e texto do tema

### Infra

- [x] Firebase (Auth, Firestore, Storage, FCM dependência no projeto)
- [x] Índices Firestore deployados (incl. cápsulas)
- [x] **Subscrição (scaffold)** — Cloud Functions Stripe (`functions/`), camada `lib/core/billing/`, ecrã de planos; **desactivado por defeito** (`BILLING_ENABLED=false`) até Stripe e deploy — ver `functions/README.md` e `ARCHITECTURE.md`

---

**Progresso MVP (estimativa):** núcleo **🔴 Crítico** concluído no código e neste checklist. **🟡 Importante** — pendente: Sign in with Apple; restantes concluídos; manter revisão manual (QA em dispositivo físico) antes do lançamento.

---

## 🔴 Email — problemas críticos (falta implementar)

**1. Email de recuperação de senha não chega**
- O código dispara `sendPasswordResetEmail` mas o email não chega ao usuário
- Provável causa: domínio padrão do Firebase bloqueado como spam
- Solução Yuri: configurar domínio personalizado no Firebase Console → Authentication → Templates → configurar SMTP customizado ou verificar authorized domains

**2. Verificação de email no cadastro — não existe**
- Usuário cria conta com qualquer email sem confirmar que é dono
- Obrigatório para App Store e Google Play
- Solução Yuri: após `createUserWithEmailAndPassword` adicionar:
```dart
  await user.sendEmailVerification();
```
- Bloquear login até email verificado com `user.emailVerified`
- Mostrar tela intermediária pedindo para verificar email

**3. Notificações de engajamento — não existem**
- Curtida: autor não recebe notificação quando alguém curte
- Comentário: autor não recebe notificação de novo comentário  
- Seguidor: usuário não recebe notificação de novo seguidor
- Solução Yuri: Cloud Functions `onDocumentCreated` em `likes`, `comments` e `follows` → buscar FCM token do autor → disparar push via Firebase Admin SDK

---

## 🟡 Bugs de navegação — feed (falta implementar)

**1. Lupa do feed não funciona**
- O botão de busca no header do feed (`_iconBtn(Icons.search)`) é apenas visual
- Não tem `onTap` nem `GestureDetector` — não faz nada ao clicar
- Solução: adicionar `GestureDetector` com navegação para `SearchScreen`

**2. Botão de notificações do feed não funciona**
- O botão de sino (`_iconBtn(Icons.notifications_outlined)`) também é apenas visual
- Solução: navegar para tela de notificações ou implementar dropdown

**3. Busca de usuários na tela de busca não está retornando resultados**
- A busca foi migrada para `searchTokens` mas pode não estar indexando corretamente
- Verificar se os tokens estão sendo gerados no cadastro e na edição de perfil
- Verificar se o índice do Firestore para `searchTokens` está deployado

**Arquivos a editar:**
- `lib/features/feed/presentation/screens/feed_screen.dart` — método `_iconBtn`
- `lib/features/profile/presentation/screens/search_screen.dart` — lógica de busca
