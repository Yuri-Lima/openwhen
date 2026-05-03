# Whenote — Checklist do MVP

Use este arquivo para acompanhamento diário. Marque `[x]` quando concluído.

**Legenda:** 🔴 crítico/bloqueador · 🟡 importante · 🟢 pós-MVP · ✅ concluído

> **Documento de auditoria completa:** [`AUDIT_ABRIL_2026.md`](AUDIT_ABRIL_2026.md)
> **Estratégia de monetização e custos Firebase:** [`MONETIZACAO.md`](MONETIZACAO.md)
> **Abertura da empresa (Delaware holding):** [`DELAWARE.md`](DELAWARE.md)
> **Nova feature — Aniversário + Notificações:** [`ANIVERSARIO_NOTIFICACAO.md`](ANIVERSARIO_NOTIFICACAO.md)
> **Nova feature — Cápsulas Coletivas (grupos):** [`CAPSULAS_COLETIVAS.md`](CAPSULAS_COLETIVAS.md)

---

## 🔴 BLOQUEADORES — corrigir ANTES de qualquer lançamento

> Enquanto estes itens estiverem abertos, NÃO convidar ninguém para testar.

| # | Problema | Responsável | Como resolver |
|---|----------|-------------|---------------|
| ~~B1~~ | ~~**`checkUsernameAvailable` não deployada** — todo cadastro retorna "username em uso"~~ — ✅ **Resolvido 2026-05-01** (callable `checkUsernameAvailable` v2 deployada — verificado com `firebase functions:list`) | Yuri | — |
| ~~B2~~ | ~~**Cursor preso no campo de texto da carta**~~ — ✅ **Resolvido 2026-04-27** | Yuri | — |
| ~~B3~~ | ~~**Botão Apple Sign-in sem `onTap`**~~ — ✅ **Resolvido 2026-04-28** (Apple + Google Sign-In implementados) | Yuri | — |
| ~~B4~~ | ~~**Budget Alerts Firebase não configurados**~~ — ✅ **Resolvido 2026-05-01** (€20/mês, alertas 50/80/100%, email admins + project owners) | Diego + Yuri | — |

---

## 🔴 SEMANA 1 — antes do soft launch com amigos

- [x] **Sign in with Apple** — `OAuthProvider` + nonce, capability no App ID, provedor no Firebase Console, ligar botão `login_screen.dart` · **Yuri** · ✅ 2026-04-28
- [x] **Google Sign-in** — `GoogleAuthProvider`, ligar botão em `login_screen.dart` · **Yuri** · ✅ 2026-04-28
- [ ] **Simplificação do onboarding** — reduzir fricção na primeira experiência; mostrar só UMA ação antes de qualquer outra coisa · **Yuri**
- [x] ~~**Botão Google (login) sem `onTap`**~~ — implementado com Google Sign-In completo · **Yuri** · ✅ 2026-04-28
- [x] **Aviso de conteúdo ofensivo localizado** — filtro lexical (Camada 1) em cartas e cápsulas com `commentsModerationWarning` (ARB en/pt/pt-BR/es) + helper `banned_lexical_words.dart` · ✅ 2026-04-28

---

## 🟡 SEMANA 2 — retenção (primeiros usuários)

- [ ] **Resposta à carta** — botão "Responder" ao abrir carta; `WriteLetterScreen` pré-preenchido; campos `replyToLetterId` + `threadId` no Firestore; cria loop emocional e é o maior driver de retenção do app · **Yuri**
- [ ] **Rascunho automático** — salvar carta em rascunho ao sair da tela; `shared_preferences` com chave por usuário · **Diego** · `write_letter_screen.dart`
- [ ] **Preview da carta antes de selar** — dialog de confirmação com destinatário, data e prévia do conteúdo · **Diego** · `write_letter_screen.dart`
- [ ] **Data mínima 30 dias nas cápsulas** — cápsula para amanhã quebra a emoção do conceito; validação no DatePicker · **Diego** · `create_capsule_screen.dart`
- [ ] **Card compartilhável ao enviar carta** — "Selei uma carta 🦉" para Stories; marketing orgânico por carta enviada · **Diego + Yuri**
- [ ] **Aniversário + notificação para seguidores** — campo `birthdate` + privacidade no perfil/cadastro; Cloud Function cron dispara push 3 dias antes; carta de aniversário abre no próximo aniversário; tela especial no dia + self-letter · **Yuri** · ver [`ANIVERSARIO_NOTIFICACAO.md`](ANIVERSARIO_NOTIFICACAO.md) · ~10–12 dias

---

## 🟡 SEMANA 3 — crescimento orgânico

- [ ] **Salvar carta do feed** — bookmarkar cartas bonitas de outros para rever; campo `savedLetters` no perfil · **Diego** · `feed_screen.dart`
- [ ] **Sugestões de datas especiais** — ao criar carta, sugerir: "Aniversário de X em 3 meses — quer escrever para ele?" · **Yuri**
- [ ] **Explicação clara do fluxo de publicação** — toggle "Permitir publicação" é confuso; melhorar texto na criação e na abertura da carta · **Diego**
- [ ] **Links reais de download** — substituir placeholders "Baixar o app" por links App Store / Google Play · **Diego**

---

## 🟡 MÊS 2 — pós primeiros 100 usuários

- [ ] **Landing page para destinatário sem conta** — receber link da carta, ver prévia bloqueada, cadastrar para abrir; maior funil de conversão orgânico do app · **Yuri**
- [ ] **Follow Request para contas privadas** — conta privada existe mas qualquer pessoa segue sem pedir permissão; `followRequests/{id}` + notificação + aceite/recusa · **Yuri**
- [ ] **Silenciar conta** — opção intermediária entre seguir e bloquear · **Diego** · `user_profile_screen.dart`
- [ ] **Feed com visual de envelope** — envelopes que se abrem ao rolar; diferencia visualmente do Instagram · **Yuri**
- [ ] **Múltiplas fotos por carta** — carrossel até 5 fotos · **Yuri**
- [ ] **Contagem regressiva animada no cofre** — "Abre em 47 dias" como elemento visual central dos cards · **Diego/Yuri**

---

## 🟢 MÊS 3+ — para crescimento e investidores

- [ ] **Cápsulas Coletivas (grupos)** — grupos de até 50 pessoas com data de abertura coletiva; admin cria e convida por link; todos contribuem em segredo; abertura simultânea com notificação push; monetização: admin paga R$14,99/grupo ou R$4,99/mês · **Yuri + Diego** · ver [`CAPSULAS_COLETIVAS.md`](CAPSULAS_COLETIVAS.md) · ~8–10 semanas
- [ ] **Nox Card** — card da coruja por nível de uso, animação compartilhável; ver [`ROADMAP.md`](ROADMAP.md) Fase 2 e [`BUSINESS.md`](BUSINESS.md)
- [ ] **Análise Firebase completa** — documentar estimativas por DAU em [`MONETIZACAO.md`](MONETIZACAO.md) ✅ (ver documento)
- [ ] **Ativar monetização** — apenas após ~10K usuários; ver [`MONETIZACAO.md`](MONETIZACAO.md)
- [ ] **Abertura da empresa Delaware** — ver [`DELAWARE.md`](DELAWARE.md) para timing e passo a passo
- [ ] **Contribuições múltiplas antes de selar** — subcoleção `contributions` + `contentMode: multiContributor`; ver [`ROADMAP.md`](ROADMAP.md) Fase 3
- [ ] **Música de fundo** — reprodução dentro do app (distinto do link externo já suportado)
- [ ] **Premium pay-per-feature** — após ~10K usuários; ver [`MONETIZACAO.md`](MONETIZACAO.md)

---

## 🔴 Custos Firebase — ANTES DO LANÇAMENTO

- [x] **Budget Alerts configurados** na Google Cloud Console (€20/mês, alertas a 50%, 80% e 100% — 2026-05-01)
- [x] **Firebase Usage dashboard** ativado (plano Blaze, dashboard acessível em Firebase Console → Usage and billing — verificado 2026-05-01: $0.00, Firestore reads/writes <1% do quota gratuito)
- [ ] Estimativas documentadas em [`MONETIZACAO.md`](MONETIZACAO.md) ✅

> ⚠️ **Sem Budget Alerts, NÃO lançar em produção.** Ver [`PRODUCTION.md`](PRODUCTION.md) e [`MONETIZACAO.md`](MONETIZACAO.md).

---

## 🔴 Legal e Privacidade — ANTES DO LANÇAMENTO

### ✅ Concluído
- [x] Política de Privacidade completa (LGPD + GDPR + CCPA) — 17 seções em 3 idiomas + `legal_screen.dart`
- [x] Termos de Uso com cláusula de encerramento de serviço (Seção 7 — aviso 90 dias, exportação, Fundo de Continuidade)
- [x] Aviso na tela de deletar conta sobre cartas pendentes — banner warning. 3 idiomas.
- [x] Plano de contingência de 90 dias — [`LEGAL.md`](LEGAL.md)
- [x] Página web de privacidade sem login — `hosting/public/privacy.html` + `terms.html`
- [x] Log de todas as solicitações de privacidade
- [x] Export automático de dados ao deletar conta — `export_user_data.ts` + `deletion_request_service.dart`
- [x] Solicitação de exclusão de dados com prazo de 15 dias — `request_deletion.ts` + `scheduled_deletion.ts`
- [x] Central de privacidade no app — `privacy_center_screen.dart`
- [x] 7 emails de contato configurados — Cloudflare Email Routing → Gmail

### Pendente
- [ ] **Revisar Termos de Uso com advogado** antes de lançar
- [ ] Manter entrega de cartas locked mesmo após conta deletada (testar)
- [ ] Backup redundante das cartas fora do Firebase

---

## 🔴 Auditoria de Compliance Legal — 02/05/2026

> Cruzamento entre o que os Termos de Uso e Política de Privacidade prometem vs. o que o código realmente implementa.
> **Resultado: 9 conformes · 4 parciais · 5 ausentes (4 resolvidos em 02/05/2026)**

### ✅ Conforme (9)

- [x] **Consentimento no registro (email)** — dois checkboxes obrigatórios: Termos + Política de Privacidade, e confirmação de idade 13+. Botão de criar conta desabilitado sem ambos. `register_screen.dart` linhas 617-669.
- [x] **Eliminação de conta (2 modos)** — Delete All e Anonymize implementados no client (`account_deletion_service.dart`) e Cloud Functions (`delete_account.ts`, `scheduled_deletion.ts`). Cobre perfil, cartas, cápsulas, comentários, likes, follows, bloqueos, denúncias, feedback, badges, notificações, ficheiros e registo Firebase Auth.
- [x] **Re-autenticação antes de eliminar** — `reauthenticateWithPassword()` exigido antes de qualquer ação de eliminação. UI bloqueia confirmação até sucesso.
- [x] **Stripe: dados de cartão nunca no servidor** — checkout via Cloud Functions (`createCheckoutSession`), cartão processado diretamente pelo Stripe. Campos billing (`stripeCustomerId`, `subscriptionTier`, etc.) protegidos nas Firestore Rules como server-only write.
- [x] **Moderação IA (3 tiers)** — OpenAI Moderation API integrada. `ModerationDecision` com `allowed`/`warning`/`blocked`. Thresholds configuráveis (0.40 warning, 0.70 block). `send_moderation_helper.dart`.
- [x] **Fila de moderação humana** — Admin panel com 4 abas (Reports, Feedback, Human Reviews, Incidents). `admin_moderation_screen.dart`. `humanModerationQueueEnabled` no SystemConfig.
- [x] **Denúncia de conteúdo** — bottom sheet com 5 categorias (spam, assédio, ódio, ilegal, outro) + detalhe opcional (2000 chars). Reports escritos no Firestore com metadados completos. `report_flow.dart`.
- [x] **Limite de voz (1 minuto)** — `_voiceMaxSeconds = 60` em `write_letter_screen.dart` linha 124. Gravação para automaticamente ao atingir 60s.
- [x] **Firestore Security Rules** — 260 linhas cobrindo users, letters, capsules, comments, likes, follows, blocks, reports, moderação. Campos billing protegidos. Collections de moderação write-locked para Admin SDK. `firestore.rules`.
- [x] **Localização opt-in por carta** — dialog por carta/cápsula (`location_prompt_flow.dart`), sem background tracking. Feature atualmente desabilitada por flag (`kEnableSenderLocationPromptOnSend = false`).

### ⚠️ Parcialmente implementado (4)

- [x] **Verificação de idade em login social** — ~~Sign in with Apple e Google pulavam a tela de registro completamente sem age gate.~~ ✅ **Resolvido 2026-05-02** — dialog com checkboxes de Termos + Idade 13+ adicionado antes de qualquer social sign-in em `login_screen.dart`. Chaves i18n adicionadas nos 4 idiomas.
- [ ] **App Check iOS desativado** — App Check funciona em Android (Play Integrity), mas está comentado no iOS por bug do SDK Firebase (`firebase-ios-sdk#15974`). A política promete proteção em ambas as plataformas. `main.dart` linhas 58-77. **Corrigir:** reativar quando FlutterFire publicar SDK >= 12.12.0.
- [x] **Eliminação "irreversível" vs. grace period** — ~~A política dizia "irreversible" mas o código implementa 15 dias de carência.~~ ✅ **Resolvido 2026-05-02** — texto de `privacySection11Body` atualizado nos 4 idiomas (EN/PT/PT_BR/ES) para explicar o período de carência de 15 dias com opção de cancelamento.
- [x] **Info.plist: NSLocationAlwaysAndWhenInUseUsageDescription** — ~~O código só usa location `whenInUse`, mas o Info.plist declarava permissão "Always", contradizendo a política.~~ ✅ **Resolvido 2026-05-02** — chave removida do Info.plist. **Atualização 2026-05-03:** chave re-adicionada com o mesmo texto de `NSLocationWhenInUseUsageDescription`. A Apple exige que ambas as chaves estejam presentes quando qualquer dependência (ex: plugin de localização) referencia a API `CLLocationManager`, mesmo que o app só use `whenInUse`. Sem esta chave, o Transporter/App Store Connect emite warning 90683. O app continua a pedir apenas permissão "when in use" em runtime — a chave no Info.plist é apenas declarativa para satisfazer a validação da Apple.

### ❌ Ausente no código (5 restantes, 5 resolvidos — todos implementados)

- [x] **Data de nascimento no registro** — ✅ Implementado (02/05/2026): campo `dateOfBirth` adicionado ao modelo `AppUser`, date picker no registro e login social, salvo no Firestore via `Timestamp`. Utilitário `age_verification.dart` criado com validação por jurisdição.
- [x] **Idade mínima 16 para EU/UK** — ✅ Implementado (02/05/2026): `age_verification.dart` contém mapa completo de idades mínimas por país EU/EEA/UK (GDPR Art. 8), usa `Platform.localeName` para inferir jurisdição. Threshold varia de 13–16 conforme legislação nacional de cada Estado-membro.
- [x] **Consentimento de analytics (EU/UK)** — ✅ Implementado (02/05/2026). Analytics desativado por defeito no arranque (`setAnalyticsCollectionEnabled(false)`). Banner de consentimento para EU/EEA/UK com Aceitar/Recusar via `AnalyticsConsentOverlay`. Auto-grant para não-EU. Toggle nas Settings (visível apenas EU/EEA/UK). SharedPreferences + Firestore sync. Guard `if (!_enabled) return` em todos os métodos de `AnalyticsService`. Ficheiros: `consent_constants.dart`, `analytics_consent_provider.dart`, `analytics_consent_banner.dart`.
- [x] **Global Privacy Control (GPC)** — ✅ Resolvido (02/05/2026). Menção ao GPC removida da secção 15 da Política de Privacidade nos 4 idiomas. GPC é um header HTTP (`Sec-GPC: 1`) aplicável a browsers — não é detectável em apps nativos móveis. A menção será re-adicionada quando existir versão web, com implementação real. O opt-out de analytics para CCPA está coberto pelo toggle nas Settings (implementado na mesma sessão).
- [x] **Exportação completa de dados (GDPR Art. 20)** — ✅ Implementado (02/05/2026). Novo serviço `complete_export_service.dart` exporta todos os dados do utilizador: perfil, cartas (sent + received, deduplicated), cápsulas, comentários, likes, follows (followers + following), badges — tudo em JSON dentro de ZIP + media (voz, manuscrito, fotos de cápsulas). Queries Firestore paginadas (500/batch). Sanitização de campos internos (UIDs, stripeCustomerId, searchTokens). URLs de media validadas contra Firebase Storage allowlist (SSRF-safe). UI em `settings_screen.dart` sem restrição de tier (gratuito para todos). Progress indicator com estágios. `PrivacyLogService.logCompleteExport()` para audit trail. i18n em 4 idiomas.
- [x] **Anonimização de denúncias (90 dias)** — ✅ Implementado (02/05/2026). Cloud Function scheduled `anonymizeResolvedReports` em `functions/src/anonymize_resolved_reports.ts`, executa diariamente às 04:00 UTC. Query: reports com `status` "resolved" ou "dismissed" e `resolvedAt` > 90 dias e sem `anonymizedAt`. Remove `reporterUid`, `detail`, `resolvedByUid` (FieldValue.delete). Mantém `targetType`, `targetId`, `letterId`, `reason`, `status`, `createdAt`, `resolvedAt` para estatísticas. Adiciona `anonymizedAt` (server timestamp). Batch writes com limite 450 por batch. Registada no `index.ts`.
- [x] **Retenção de logs de moderação (2 anos)** — ✅ Implementado (02/05/2026). Cloud Function scheduled `purgeOldModerationLogs` em `functions/src/purge_old_moderation_logs.ts`, executa diariamente às 04:30 UTC. Elimina documentos de `moderationIncidents` e `moderationReviews` com `createdAt` > 2 anos (730 dias). Deleção completa (não anonimização) — conforme política "retained for 2 years". Paginação com `limit(450)` + loop para lidar com volumes grandes. Registada no `index.ts`. Sem composite index necessário (query usa apenas `createdAt`, single-field auto-indexed).

### Notas adicionais da auditoria

- **Hash do audit log não é criptográfico** — `simpleHash` no `account_deletion_service.dart` usa djb2 (32-bit int), que é trivialmente reversível. A política implica hash seguro ("hashed, non-reversible identifiers"). **Recomendação:** substituir por SHA-256 com salt.
- **Re-auth social missing** — `reauthenticateWithPassword()` só funciona para email/password. Utilizadores autenticados via Apple/Google OAuth não conseguem re-autenticar para eliminar a conta. **Ação:** implementar `reauthenticateWithCredential` para providers OAuth.
- **TLS 1.3** — delegado à infraestrutura Firebase/Google Cloud. Não verificável no código, mas a claim é válida.
- **Notificação de breach (72h)** — compromisso da política sem mecanismo no código. Aceitável como procedimento operacional, mas recomenda-se documentar um playbook de incidentes em `planning/`.
- **Fundo de Continuidade** — documentado em `planning/LEGAL.md` como aspiracional (projetado para Q3 2026). Os Termos corretamente usam "may establish", então está conforme.

---

## Comparação com Instagram — o que aproveitar

| Feature | Status Whenote | Prioridade |
|---------|----------------|-----------|
| Feed de descoberta | ✅ 3 camadas | — |
| Notificações push de engajamento | ✅ Implementado | — |
| Salvar/bookmark posts | ❌ Não existe | 🟡 Semana 3 |
| Rascunhos | ❌ Não existe | 🟡 Semana 2 |
| Follow Request (conta privada) | ❌ Não existe | 🟡 Mês 2 |
| Silenciar contas | ❌ Só bloquear | 🟢 Mês 2 |
| Resposta (loop emocional) | ❌ Planejado | 🔴 Semana 2 |
| Múltiplas fotos | ❌ 1 foto | 🟢 Mês 2 |
| Aniversário + notificação seguidores | ❌ Não existe | 🟡 Semana 2 |
| Grupos / cápsulas coletivas | ⚠️ Parcial (sem UX de grupo) | 🟢 Mês 3+ |

### Diferenciais únicos Whenote vs Instagram

- Timer de abertura com data futura — impossível de copiar
- QR Code físico → bridge digital/físico — único no mercado
- Abertura por GPS (10m) — só abre no local certo
- Cápsulas coletivas
- Animação emocional ritualizada na abertura
- Gift When — presente financeiro selado (roadmap)

---

## Futuro — Gift When & Nox Card

Ver [`ROADMAP.md`](ROADMAP.md) Fase 2/4 e [`BUSINESS.md`](BUSINESS.md)

**Whenote Gift (Presente Selado)**
- [ ] Pesquisa legal concluída (*money transmission* EUA e requisitos locais)
- [ ] Integração Stripe Connect configurada
- [ ] MVP Gift desenvolvido e validado

**Nox Card**
- [ ] Nome do mascote definido
- [ ] Animação do card criada (compartilhável Stories/Reels)
- [ ] Integração com Gift When

---

## Futuro — Whenote Physical

Ver [`ROADMAP.md`](ROADMAP.md) Fase 4 e [`BUSINESS.md`](BUSINESS.md)

- [ ] Parceiros de impressão/fulfillment (Lob, Stannp, gráficas BR)
- [ ] Design do template de carta impressa premium
- [ ] Fluxo no app: escolher "Carta física" ao criar
- [ ] Pagamento via Stripe (preço fixo por unidade)

---

## 🔴 App Store Connect (iOS 1.0) — Submissão

> Configuração feita em 2026-04-26. Detalhes completos: [`PRODUCTION.md`](PRODUCTION.md) secção 7 e checklist F.

### ✅ Concluído
- [x] Descrição multi-parágrafo (3 128 chars) com features principais
- [x] Keywords (85/100 chars): letters, capsules, time capsule, future, birthday, love letter, notes, journal, memories, gift
- [x] Texto promocional + subtítulo "Letters to the future"
- [x] URLs: suporte (`whenote.app/support`) e marketing (`whenote.app`)
- [x] Copyright: 2026 Whenote
- [x] Categorias: Social Networking (primária) + Lifestyle (secundária)
- [x] Age ratings: 4+ (UGC = YES, restante NONE/NO) — 7 passos concluídos
- [x] Pricing: Free ($0.00) em 175 países/regiões
- [x] Contacto de revisão: Yuri Lima, +34613784493, y.m.lima19@gmail.com
- [x] Página de suporte criada: `hosting/public/support.html` (EN/PT/ES, dark mode, 7 FAQs)
- [x] `firebase.json` — rewrites para `/support`

### Pendente
- [ ] **Screenshots** — mínimo 3 para iPhone 6.5" (bloqueador de submissão)
- [x] **Build IPA** — build 17 enviado via Transporter e visível no TestFlight
- [x] **Test account** — credenciais de login de teste para App Review (Sign-in required marcado)
- [x] **Deploy hosting** — `firebase deploy --only hosting` para publicar `support.html`

---

## ✅ CONCLUÍDO — Referência completa

### Autenticação e onboarding
- [x] Splash, Onboarding, Login, Cadastro
- [x] Verificação de email após cadastro (`sendEmailVerification`) + guard + bottom sheet soft-block
- [x] Email de recuperação de senha funcionando (domínio personalizado)
- [x] Termos + confirmação de idade obrigatórios no cadastro
- [x] Guard `requireVerifiedEmail()` em ações-chave (enviar carta, comentar, criar cápsula)
- [x] **Sign in with Apple** — `OAuthProvider` + SHA-256 nonce, entitlements iOS, Firestore user doc on first login
- [x] **Google Sign-In** — `GoogleSignIn` + `GoogleAuthProvider.credential`, `REVERSED_CLIENT_ID` no Info.plist, Firestore user doc on first login
- [x] `kSocialSignInEnabled = true` — Apple (iOS only) + Google (all platforms) visíveis no login

### Cartas e cofre
- [x] Escrever carta (texto recolhível + voz até 1 min + `voiceUrl`)
- [x] Cofre com abas (Aguardando / Abertas / Enviadas / Cápsulas)
- [x] Filtro e ordenação no cofre — bottom sheet por aba
- [x] Detalhe da carta, animação de abertura por estado emocional
- [x] Abertura da carta — animação da coruja (lacre, olhos, asas, voo)
- [x] Pedidos de carta, QR Code (gerar e compartilhar)
- [x] Link opcional de música (`musicUrl`)
- [x] Localização opcional (`senderLocation`)
- [x] Abertura só no local (10m) — `openRequiresProximity`
- [x] Moderação por IA no envio (score 1-10, OpenAI) — Camada 2 ativa
- [x] Aviso de conteúdo ofensivo ao escrever — Camada 1 (cliente)
- [x] Detecção de bounce de email (SendGrid webhook) + banner reenvio
- [x] Exportar cartas (PDF / ZIP)

### Cápsulas do tempo
- [x] Fluxo criar cápsula (Tema → Perguntas → Detalhes)
- [x] Fotos na cápsula (mobile; desabilitado no web com aviso)
- [x] Listagem no cofre (aba Cápsulas)
- [x] Cápsula coletiva (`participantUids`, `isCollective`)
- [x] Mesma localização opcional e restrição 10m

### Social e perfil
- [x] Feed em 3 camadas (Explorar / Destaques / Seguindo)
- [x] Filtros por emoção — até 3 chips fixados
- [x] Curtidas e comentários em tempo real
- [x] Notificações de engajamento (curtida, comentário, seguidor) — Cloud Functions deployadas 12/04/2026
- [x] Anti-spam notificações (dedup curtidas 5 min)
- [x] Deep linking: tap notificação → carta / perfil
- [x] Seguidores com lista paginada (tabs + lazy load 20/página)
- [x] Conta pública/privada, bloqueios
- [x] Perfil próprio e de outros, busca por @username
- [x] Badges / gamificação leve
- [x] Compartilhamento Stories/Reels
- [x] Moderação admin + incidentes

### Configurações e perfil
- [x] Temas (classic, dark, midnight, sepia) + automático/sistema
- [x] Idiomas (pt-BR, en, es) + automático/sistema + override
- [x] Configurações, Termos, Privacidade, Sobre, Ajuda
- [x] Deletar conta com opção anonimizar
- [x] Central de privacidade no app
- [x] Logout com confirmação

### Infra
- [x] Firebase (Auth, Firestore, Storage, FCM)
- [x] Índices Firestore deployados
- [x] Regras Firestore e Storage deployadas
- [x] Domínio `whenote.app` — Cloudflare + Firebase Hosting
- [x] Subscrição scaffold (Stripe — `BILLING_ENABLED=false` até 10K users)
- [x] Busca de usuários com `searchTokens` (escala)
- [x] `ensureUserFirestoreProfile` + FCM token handling robusto
- [x] `privacyRequestLogs` — log unificado de solicitações de privacidade

### Bugfixes registrados
- [x] Analytics login — `logLogin()` só após sucesso
- [x] Onboarding overflow em telas pequenas
- [x] Logout não redirecionava — `popUntil` na raiz
- [x] Contraste temas escuros — splash, onboarding, login hero
- [x] Contraste acessibilidade — criar cápsula, configurações, bottom sheet foto
- [x] Lupa do feed → `SearchScreen`
- [x] Sino do feed → tela de notificações
- [x] Busca de usuários — catch silencioso corrigido
- [x] Registro de tela de cadastro — header cor corrigida (dark theme)
- [x] **Cursor preso + menu copiar/colar ausente no campo de mensagem da carta** — `GestureDetector` global no scroll competia com gestos do `TextField`; estado colapsado usava `Text` estático (sem cursor real). Unificado num único `TextField` (`minLines:1` / `maxLines:8`), `FocusNode` listener para auto-expandir ao foco, `TapRegion` isolado na busca de destinatário para fechar dropdown sem interferir com long-press. `write_letter_screen.dart` — **2026-04-27**
- [x] **`checkUsernameAvailable` callable** — antes falhava se a função não existisse em produção (`register_screen.dart` trata erro como username indisponível). Deploy v2 callable em `us-central1` verificado — **2026-05-01**

---

**Progresso geral (02/05/2026):**
- 🔴 Bloqueadores pré-lançamento: **todos resolvidos** ✅ (B1 ✅ 2026-05-01, B2 ✅, B3 ✅, B4 ✅ 2026-05-01)
- 🟡 Semana 1: **1 pendente** (Sign-in Apple ✅, Google ✅, botão Google ✅, aviso emocional ✅ — resta: onboarding)
- 🟡 Semana 2: **6 pendentes** (inclui aniversário + notificação)
- 🟢 Mês 3+: **1 nova feature validada** (Cápsulas Coletivas)
- Núcleo técnico: **totalmente concluído** ✅
- Legal: **textos atualizados** (EN/PT/PT_BR/ES — 13 gaps corrigidos nos .arb 2026-05-02); **auditoria de compliance** feita (9 conformes, 4 parciais, 5 ausentes — ver secção acima); **dateOfBirth + age verification por jurisdição** implementados (02/05/2026); **consentimento analytics EU/UK** implementado (02/05/2026); revisão com advogado pendente
- Monetização: **planejada** (ativar após 10K users)

---

## 🔴 Itens críticos identificados — análise externa abril 2026

**1. ✅ Aviso emocional antes de abrir carta — Yuri**
- Tela antes da abertura: "Essa carta pode ser emocional. Abra quando estiver pronto."
- Botões: "Abrir agora" / "Ver depois"
- Mostrado uma vez por dispositivo (SharedPreferences); ambos os botões gravam o flag.
- Arquivos: `letter_emotional_primer_screen.dart`, `letter_primer_prefs.dart`, `open_with_proximity.dart`

**2. Testar abertura de cartas com datas próximas — Diego + Yuri**
- Criar carta para abrir em 1 minuto
- Criar carta para abrir em 5 minutos
- Criar carta para abrir em 1 hora
- Verificar se notificação chega e animação funciona perfeitamente

**3. Testar com 5 usuários reais — Diego**
- Antes de lançar publicamente
- Pessoas de confiança: família, amigos próximos
- Coletar feedback honesto

**4. Simplificar onboarding — Yuri**
- Primeira experiência: só escrever carta, escolher data, selar
- Esconder GPS, cápsula, feed, QR Code na primeira vez
- Mostrar funcionalidades avançadas depois
