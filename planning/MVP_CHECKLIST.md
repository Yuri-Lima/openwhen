# OpenWhen — Checklist do MVP

Use este arquivo para acompanhamento diário. Marque `[x]` quando concluído.

**Legenda:** 🔴 crítico · 🟡 importante · 🟢 pós-MVP

---

## 🔴 Crítico (bloqueadores do MVP "completo")

- [x] Tela de **abertura da cápsula** (animação, revelar perguntas/respostas, fluxo de publicar após revisão)
- [x] **Avatar de perfil** com upload (funcional em web e mobile)
- [x] **Notificações FCM** (configuração, permissões, handlers)
- [x] **Testes em celular real** (build iOS/Android, fluxos principais) — ver [`PRODUCTION.md`](PRODUCTION.md) (secção 9)
- [x] **Regras Firestore de produção** (deploy e validação) — `firestore.rules` + `storage.rules`; executar `firebase deploy --only firestore:rules,storage`
- [x] **Notificações de engajamento** (curtida, comentário, novo seguidor) via Cloud Functions — ref: UX_AUDIT.md #3
  - [x] Cloud Functions: `onLikeCreated`, `onCommentCreated`, `onFollowCreated` (`functions/src/engagement/`)
  - [x] Helper centralizado `sendEngagementPush` (FCM push + Firestore in-app notification)
  - [x] Anti-spam: deduplicação de curtidas na mesma carta (janela 5 min)
  - [x] Verificação de bloqueio (ambas direções) e self-notification
  - [x] Limpeza automática de FCM token inválido
  - [x] Localização server-side (en, pt, es) via `preferredLanguage`
  - [x] Tela de notificações expandida para tipos `engagement` (like, comment, follow) com ícones
  - [x] Deep linking: tap em like/comment → carta, tap em follow → perfil do seguidor
  - [x] Índice Firestore composto para deduplicação (`notifications: dedupeKey + read + createdAt`)
  - [x] **Deploy concluído** (12 abr 2026): `firebase deploy --only functions,firestore:indexes`

---

## 🟡 Importante (logo após o núcleo do MVP)

- [ ] **Bug crítico: cursor preso no campo de texto da carta** — usuário não consegue reposicionar cursor para corrigir letra específica, precisa apagar tudo. Arquivo: write_letter_screen.dart. Responsável: Yuri. Corrigir antes do lançamento.
- [ ] **Sign in with Apple** — Firebase Auth (`OAuthProvider` + nonce), pacote `sign_in_with_apple`, capability no App ID, provedor Apple no Firebase Console, ligar o botão em `login_screen.dart` (hoje só UI)
- [ ] **Simplificação do onboarding** (reduzir passos, experiência guiada) — ref: UX_AUDIT.md #1
- [x] Fotos na cápsula (mobile; web desabilitado com aviso)
- [x] Compartilhamento Stories/Reels
- [x] Tela **Cartas recebidas** dedicada (locked + opened numa aba, com filtros)
- [x] Badges / gamificação leve
- [x] **Temas do app** (várias paletas + opção automática/sistema) — `open_when_palette.dart` (classic, dark, midnight, sepia) + `theme_provider.dart` + seletor em Configurações
- [ ] **Nox Card** (card da coruja por nível, animação compartilhável) — ver [ROADMAP.md](ROADMAP.md) Fase 2 e [BUSINESS.md](BUSINESS.md)
- [ ] **Links reais de download do app** — substituir botões/placeholders de "Baixar o app" por links verdadeiros da App Store e Google Play em todas as telas e páginas web onde aparecem
- [x] **Lista de Seguidores / Seguindo** — tela com tabs + lazy load (20 por página, cursor `startAfter`); contadores clicáveis em ambos os perfis; otimizar contadores para usar `followersCount`/`followingCount` denormalizados em vez de `StreamBuilder` que lê N docs; ver [`FOLLOWERS_LIST_PLAN.md`](FOLLOWERS_LIST_PLAN.md)
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

## Futuro — OpenWhen Physical (carta real & produtos; ver [`ROADMAP.md`](ROADMAP.md) Fase 4 e [`BUSINESS.md`](BUSINESS.md))

**Physical 1 — Carta impressa premium**

- [ ] Pesquisa de parceiros de impressão/fulfillment (Lob, Stannp, gráficas locais BR)
- [ ] Pesquisa legal concluída (envio postal, impostos, responsabilidade)
- [ ] Design do template de carta impressa (papel premium, selo da coruja, personalização por emoção)
- [ ] API de integração com parceiro de fulfillment
- [ ] Cálculo de lead time por região/país (programar envio para chegar na data de abertura)
- [ ] Fluxo no app: escolher "Carta física" ao criar carta
- [ ] Pagamento via Stripe (preço fixo por unidade)
- [ ] Tracking de envio com notificação ao remetente e destinatário
- [ ] MVP testado e lançado

**Physical 2 — Presentes de parceiros (marketplace)**

- [ ] Curadoria de parceiros (floristas, livrarias, chocolatiers, artesãos)
- [ ] Catálogo de presentes no app (fotos, preços, descrições)
- [ ] Integração logística com parceiros (API ou manual inicial)
- [ ] Política de itens aceites e itens proibidos
- [ ] Fluxo de compra: carta + presente combinados
- [ ] Comissão/markup configurado no Stripe
- [ ] MVP testado e lançado

**Physical 3 — Item custom do utilizador (futuro)**

- [ ] Modelo de custódia temporária (armazém/fulfillment center)
- [ ] Seguro para itens em custódia
- [ ] Termos legais para custódia de objectos pessoais
- [ ] Fluxo de envio do item pelo utilizador ao armazém
- [ ] Envio programado ao destinatário na data de abertura

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
- [x] **Domínio `openwhen.live`** — registado na Cloudflare (DNS gerido lá); conectado ao Firebase Hosting (páginas públicas, `assetlinks.json`, deep links)
- [x] **Subscrição (scaffold)** — Cloud Functions Stripe (`functions/`), camada `lib/core/billing/`, ecrã de planos; **desactivado por defeito** (`BILLING_ENABLED=false`) até Stripe e deploy — ver `functions/README.md` e `ARCHITECTURE.md`

---

**Progresso MVP (estimativa):** núcleo **🔴 Crítico** totalmente concluído (incl. notificações de engajamento). **🟡 Importante** — pendente: Sign in with Apple; restantes concluídos. **🔴 Email** — itens 1, 2 e 4 concluídos; item 3 (engajamento) concluído. **🔴 Moderação** — concluída. **🔴 Legal** — itens pendentes documentados. Manter revisão manual (QA em dispositivo físico) antes do lançamento.

---

## 🔴 Email — problemas críticos

**1. Email de recuperação de senha — CONCLUÍDO ✅**
- [x] Domínio personalizado configurado no Firebase Console (Authentication → Templates)
- [x] Emails de recuperação chegando corretamente aos usuários

**2. Verificação de email no cadastro — IMPLEMENTADO ✅**
- [x] `sendEmailVerification()` disparado no registo (`register_screen.dart`, `auth_repository.dart`)
- [x] Guard `requireVerifiedEmail()` em `lib/core/auth/email_verification_guard.dart` — verifica `user.emailVerified` antes de ações protegidas (enviar cartas, comentar, criar cápsulas)
- [x] Bottom sheet `email_verification_sheet.dart` com opções: "Já verifiquei" (reload + check), "Reenviar email" (cooldown 60s), "Mais tarde"
- Abordagem: soft-block (login permitido, ações-chave bloqueadas até verificação)

**3. Notificações de engajamento — IMPLEMENTADO ✅**
- [x] Cloud Functions `onDocumentCreated` em `likes`, `comments` e `follows` (`functions/src/engagement/`)
- [x] FCM push + notificação in-app (Firestore `users/{uid}/notifications`)
- [x] Tela de notificações expandida com ícones e deep linking
- [x] **Deploy concluído** (12 abr 2026): `firebase deploy --only functions,firestore:indexes`

**4. Validação de email externo + notificação de bounce — IMPLEMENTADO ✅**
- [x] Validação de email no cliente melhorada (regex em `lib/core/utils/validators.dart` em vez de `contains('@')`)
- [x] Mensagens ARB melhoradas com exemplo de formato (4 idiomas)
- [x] Cloud Function `onSendGridWebhook` — webhook para eventos bounce/dropped/delivered/deferred com idempotência, batch chunking, logging estruturado
- [x] `defineSecret()` para `SENDGRID_API_KEY` e `SENDGRID_WEBHOOK_VERIFICATION_KEY` (Firebase Functions v2)
- [x] `custom_args` (letterId + senderUid) no envio SendGrid para mapeamento no webhook
- [x] Estado `inviteEmailStatus` no Firestore (`sent`, `delivered`, `bounced`, `dropped`, `deferred`, `send_failed`)
- [x] Notificação in-app + push FCM localizado (preferredLanguage) ao remetente em caso de bounce/dropped
- [x] Enum `InviteEmailStatus` no modelo Dart `Letter` com `fromString` seguro
- [x] Banner de bounce no detalhe da carta (sender) com botão de reenvio
- [x] Dialog de reenvio com edição de email → callable `resendExternalInviteEmail` com rate limiting (5 min)
- [x] Firestore rules: campos imutáveis protegidos (`senderUid`, `receiverUid`, `createdAt`, `inviteEmailStatus`, etc.); delete restrito ao sender
- [x] Tela de notificações expandida para tipo `email_bounce` com ícone diferenciado
- [x] Testes unitários `Validators.isValidEmail` (7/7 passando)
- [x] **Deploy:** `npm install @sendgrid/eventwebhook` + config SendGrid + `firebase deploy --only functions` + `firebase deploy --only firestore:rules`
- Plano completo: [`EMAIL_VALIDATION_PLAN.md`](EMAIL_VALIDATION_PLAN.md)

---

## ~~🟡 Bugs de navegação — feed~~ (concluído)

- [x] **Lupa do feed** — `_iconBtn` refactorado com `onTap`, `Semantics`, `Tooltip`, `Material` + `InkWell`, alvo 48×48 dp; navega via `pushNamed('/search')` (preserva `DeferredSearchPage`)
- [x] **Botão de notificações do feed** — navega para `ModerationNotificationsScreen` (mesmo padrão de Settings); quando existir inbox genérico, bastará trocar o destino
- [x] **Busca de utilizadores — diagnóstico:** `catch (_)` silenciosos em `UserSearchService` substituídos por `catch (e)` com `debugPrint` protegido por `kDebugMode`; tokens `searchTokens` confirmados nos 3 caminhos de escrita (registo, lazy profile, edição de perfil). **Nota:** pesquisas com múltiplas palavras (nome completo) podem não devolver resultados porque `array-contains` usa a query inteira e os tokens são por palavra — limitação documentada, não um bug de indexação

---

## ~~🔴 Moderação de conteúdo nas cartas~~ (concluído ✅)

**Filosofia:** O OpenWhen só permite amor, superação e conexão genuína.
Cartas que machucam não têm lugar aqui.

~~**Camada 1 — Visual em tempo real**~~ *(removida — moderação ocorre apenas no envio, via Camada 2)*

**Camada 2 — IA no momento do envio (Yuri) ✅**
- [x] Antes de salvar no Firestore, analisar score de risco via OpenAI
- [x] Score 1-4 → envia normalmente
- [x] Score 5-7 → aviso gentil, pessoa decide
- [x] Score 8-10 → bloqueado, carta não é salva
- [x] Arquivo: `functions/src/moderation/moderate_content.ts`
- [x] Detalhes completos: `planning/MODERATION.md`
- [x] Moderação de mídia (imagens + áudio) via Storage trigger
- [x] Localização em 4 idiomas + config fail-closed por defeito

---

## 🔴 Custos Firebase — ANTES DO LANÇAMENTO

- [ ] **Análise completa de custos Firebase** — entender a estrutura de preços (Firestore leituras/escritas, Cloud Functions invocações/CPU, Storage, Hosting bandwidth) com estimativas por DAU
- [ ] **Budget Alerts configurados** na Google Cloud Console (alertas a 50%, 80% e 100% de um teto mensal)
- [ ] **Firebase Usage dashboard ativado** e monitorização planeada para os primeiros dias/semanas
- [ ] Estimativas documentadas em [`planning/custos/GASTOS.md`](custos/GASTOS.md)

> ⚠️ **Sem esta análise, NÃO lançar em produção.** Ver aviso detalhado em [`PRODUCTION.md`](PRODUCTION.md).

---

## 🔴 Legal e Privacidade — ANTES DO LANÇAMENTO

### Concluído
- [x] Escrever Política de Privacidade completa (LGPD + GDPR + CCPA) — **17 seções** em 3 idiomas (EN, PT-BR, ES) nos ARBs + `legal_screen.dart`
- [x] Escrever Termos de Uso com cláusula de encerramento de serviço — nova Seção 7 (aviso 90 dias, exportação, Fundo de Continuidade). Em 3 idiomas.
- [x] Adicionar aviso na tela de deletar conta sobre cartas pendentes — banner warning no bottom sheet de exclusão. Em 3 idiomas.
- [x] Documentar plano de contingência de 90 dias — [`LEGAL.md`](LEGAL.md) (secção 1)
- [x] Criar página web de privacidade acessível sem login — `hosting/public/privacy.html` + `terms.html` (EN/PT/ES, dark mode)
- [x] Documentar Fundo de Continuidade nos Termos de Uso — Seção 7 + [`LEGAL.md`](LEGAL.md) §4

### Implementado — pendente de testes (12/04/2026)
- [x] Export automático de todos os dados ao deletar conta — `export_user_data.ts` + `deletion_request_service.dart` (testar)
- [x] Solicitação de exclusão de dados com prazo de 15 dias (Cloud Function) — `request_deletion.ts` + `scheduled_deletion.ts` (testar)
- [x] Manter entrega de cartas locked mesmo após conta deletada — `delete_account.ts` preservação automática (testar)
- [x] Central de privacidade no app — usuário vê todos os dados armazenados — `privacy_center_screen.dart` (testar)

### Pendente
- [x] Log de todas as solicitações de privacidade
- [ ] Revisar Termos de Uso com advogado antes de lançar
- [x] Criar email de contato para solicitações de privacidade — **7 endereços** configurados via Cloudflare Email Routing (`privacy@`, `privacidade@`, `suporte@`, `dpo@`, `juridico@`, `info@`, `noreply@`) → redirecionamento para Gmail; migrar para caixas dedicadas quando o volume justificar

---

## 🔴 Bug crítico — Cursor preso no campo de texto da carta

**Problema:** O campo de mensagem da carta não permite reposicionar o cursor.
Se o usuário erra uma letra no meio do texto, é obrigado a apagar tudo
até chegar na letra errada. Não consegue tocar numa posição específica
para corrigir apenas aquela letra.

**Impacto:** Alto — cartas longas ficam impossíveis de editar.
Usuário desiste de escrever ou envia carta com erro.

**Reproduzir:**
1. Abrir tela de escrever carta
2. Digitar um texto longo
3. Perceber um erro no meio do texto
4. Tentar tocar na letra errada para corrigir
5. Cursor não vai para a posição tocada — fica sempre no final

**Causa provável:**
O campo pode estar com `enableInteractiveSelection: false`
ou com um `GestureDetector` sobreposto bloqueando o toque.

**Arquivo:** `lib/features/letters/presentation/screens/write_letter_screen.dart`
**Responsável:** Yuri
**Prioridade:** Corrigir antes do lançamento
