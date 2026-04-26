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
| B1 | **`checkUsernameAvailable` não deployada** — todo cadastro retorna "username em uso", impossível criar conta | Yuri | `firebase deploy --only functions:checkUsernameAvailable` |
| B2 | **Cursor preso no campo de texto da carta** — não reposiciona ao tocar no meio do texto | Yuri | Investigar `GestureDetector` sobreposto em `write_letter_screen.dart` |
| B3 | **Botão Apple Sign-in sem `onTap`** — decoração pura; App Store rejeita app se login social existir sem Apple | Yuri | Implementar `OAuthProvider` + nonce em `login_screen.dart` |
| B4 | **Budget Alerts Firebase não configurados** — bug em loop pode gerar fatura inesperada | Diego + Yuri | Google Cloud Console → Billing → Budgets & Alerts → $20/mês, alertas 50/80/100% |

---

## 🔴 SEMANA 1 — antes do soft launch com amigos

- [ ] **Sign in with Apple** — `OAuthProvider` + nonce, capability no App ID, provedor no Firebase Console, ligar botão `login_screen.dart` · **Yuri**
- [ ] **Google Sign-in** — `GoogleAuthProvider`, ligar botão em `login_screen.dart` · **Yuri**
- [ ] **Simplificação do onboarding** — reduzir fricção na primeira experiência; mostrar só UMA ação antes de qualquer outra coisa · **Yuri**
- [ ] **Botão Google (login) sem `onTap`** — enquanto não implementado, esconder ou mostrar "Em breve" · **Yuri**
- [ ] **Aviso de conteúdo ofensivo localizado** — mover string hardcoded PT-BR para ARB em 4 idiomas · **Diego** · `write_letter_screen.dart` + ARBs

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

- [ ] **Budget Alerts configurados** na Google Cloud Console (alertas a 50%, 80% e 100% de $20/mês)
- [ ] **Firebase Usage dashboard** ativado e monitorização planejada para os primeiros dias
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
- [ ] **Test account** — credenciais de login de teste para App Review (Sign-in required marcado)
- [ ] **Deploy hosting** — `firebase deploy --only hosting` para publicar `support.html`

---

## ✅ CONCLUÍDO — Referência completa

### Autenticação e onboarding
- [x] Splash, Onboarding, Login, Cadastro
- [x] Verificação de email após cadastro (`sendEmailVerification`) + guard + bottom sheet soft-block
- [x] Email de recuperação de senha funcionando (domínio personalizado)
- [x] Termos + confirmação de idade obrigatórios no cadastro
- [x] Guard `requireVerifiedEmail()` em ações-chave (enviar carta, comentar, criar cápsula)

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

---

**Progresso geral (14/04/2026):**
- 🔴 Bloqueadores pré-lançamento: **4 pendentes** (B1-B4 acima)
- 🟡 Semana 1: **5 pendentes**
- 🟡 Semana 2: **6 pendentes** (inclui aniversário + notificação)
- 🟢 Mês 3+: **1 nova feature validada** (Cápsulas Coletivas)
- Núcleo técnico: **totalmente concluído** ✅
- Legal: **concluído** (revisão com advogado pendente)
- Monetização: **planejada** (ativar após 10K users)
