# Whenote — Roadmap de produto

Este documento organiza entregas por fase. Prioridades: **P0** (crítico), **P1** (importante), **P2** (desejável).

**Estado vs. checklist:** o rastreio fino (marcado `[x]` / `[ ]`) está em `[MVP_CHECKLIST.md](MVP_CHECKLIST.md)`. Este roadmap resume por fase; em caso de divergência, prevalece o checklist.

---

## Fase 1 — MVP core (concluída — março 2026)

Foco original: experiência completa de cartas + cápsulas, estabilidade e segurança. Itens **P0** abaixo estão entregues no código e marcados no checklist (🔴 Crítico).


| Entrega                                                                    | Prioridade | Status    | Notas                                                   |
| -------------------------------------------------------------------------- | ---------- | --------- | ------------------------------------------------------- |
| Tela de abertura da cápsula (animação, revelar Q&A, publicar após revisão) | P0         | Concluído | Fecha o loop da feature cápsulas                        |
| Avatar de perfil (upload; web + mobile)                                    | P0         | Concluído | `file_picker` / Storage                                 |
| Notificações FCM                                                           | P0         | Concluído | Lembretes e eventos de abertura                         |
| Testes em dispositivo real (iOS/Android)                                   | P0         | Concluído | Ver `[PRODUCTION.md](PRODUCTION.md) (secção 9)`            |
| Regras Firestore de produção                                               | P0         | Concluído | `firestore.rules` + `storage.rules`; deploy e validação |


---

## Fase 2 — Engajamento (foco atual)

Retenção, descoberta e hábito de uso. Itens **concluídos** alinhados a `[MVP_CHECKLIST.md](MVP_CHECKLIST.md)` (🟡 Importante).


| Entrega                                                                            | Prioridade | Status    | Esforço (est.) | Notas                                                                                                                                                                                 |
| ---------------------------------------------------------------------------------- | ---------- | --------- | -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Fotos na cápsula (mobile; desabilitado no Chrome se necessário)                    | P1         | Concluído | Médio          | `image_picker`                                                                                                                                                                        |
| Compartilhamento Stories/Reels                                                     | P1         | Concluído | Alto           | Instagram Stories (nativo iOS/Android) + fallback; ver `[ARCHITECTURE.md](ARCHITECTURE.md)` e `lib/shared/social/`                                                                    |
| Tela “Cartas recebidas” separada                                                   | P1         | Concluído | Médio          | Clareza no cofre                                                                                                                                                                      |
| Badges / gamificação                                                               | P1         | Concluído | Médio          | Metas leves no cliente; `lib/features/gamification/` (desbloqueio, faixa no perfil); regras Firestore `users/{uid}/badgeUnlocks`                                                      |
| Temas do app (paletas + automático/sistema)                                        | P1         | Concluído | Baixo          | Evolução do “toggle claro/escuro”; `whenote_palette.dart`, Configurações                                                                                                            |
| Feed em 3 camadas                                                                  | P1         | Concluído | Alto           | Explorar / Destaques / Seguindo; filtros emocionais com até 3 chips fixados; ver `[ARCHITECTURE.md](ARCHITECTURE.md)` secção “Feed”                                                   |
| Carta multimodal (OCR em foto; transcrição de áudio)                               | P1         | Pendente  | Médio          | **Nota:** moderação de imagens e áudio já implementada (ver [MODERATION.md](MODERATION.md)); esta linha refere-se à feature de **OCR visível** e **transcrição para texto** como UX do utilizador. Vídeo→carta fica para fase posterior.                                                                                                       |
| Multilíngue (pt-BR, en, es)                                                        | P1         | Concluído | Alto           | Também no checklist 🟡; expansão para mais locales → Fase 3                                                                                                                           |
| **Nox Card** (card da coruja por nível — sem valor exato; animação compartilhável) | P1         | Pendente  | Alto           | Viralidade (TikTok / Instagram); reforça marca; integração com **Whenote Gift** para níveis; depende de **Stories/Reels** e nome do mascote (TBD) — ver `[BUSINESS.md](BUSINESS.md)` |


**Exportar cartas (PDF / ZIP)** está concluído no checklist 🟡 (export no cliente: Configurações). A linha na Fase 3 abaixo referencia **evoluções** opcionais (ex.: processamento server-side, batch grande); a entrega MVP segue o checklist.

**Performance (cliente):** carregamento diferido de código (`deferred` para escrever carta / cápsula / busca e para export PDF-ZIP), cofre com subscrições Firestore só na aba visível; **busca de utilizadores** com queries Firestore indexadas e limite de resultados (`lib/core/user_search/`, substituição do antigo `collection(users).get()` — ver [`CHANGELOG.md`](CHANGELOG.md)) — ver [`ARCHITECTURE.md`](ARCHITECTURE.md).

### Cronograma pós-lançamento (detalhado)

**Semana 1 — Bloqueadores (antes de qualquer lançamento)**

- Email de recuperação de senha funcionando
- Verificação de email no cadastro ✅
- Notificações de curtida, comentário e seguidor (Cloud Functions) — ref: UX_AUDIT.md #3
- Lupa do feed com navegação para SearchScreen
- Busca de usuários retornando resultados

**Semana 2 — Retenção**

- Contagem regressiva no cofre — "Abre em 47 dias"
- Card compartilhável ao enviar carta — "Selei uma carta 🦉"
- Data mínima de 30 dias nas cápsulas
- Resposta à carta (ver especificações prioritárias)
- Simplificação do onboarding — reduzir fricção na primeira experiência (ref: UX_AUDIT.md #1)

**Semana 3 — Crescimento orgânico**

- Preview da carta antes de selar
- Explicação clara do fluxo de publicação
- Sugestões de datas especiais no momento de criar carta

**Mês 2 — Pós primeiros usuários**

- Landing page web para quem recebe carta sem ter conta
- Feed com identidade visual própria — envelopes que se abrem ao rolar
- Sistema de sugestões por datas especiais (aniversários, Natal etc)

**Mês 3+ — Para investidores**

- Gift When / Nox Card
- Analytics completo para mostrar métricas
- Meta: 1.000 usuários ativos antes de buscar investimento

### Especificações de funcionalidades prioritárias

#### Resposta à Carta

**Conceito:** criação de um loop emocional contínuo entre usuários. Quando um destinatário abre uma carta, pode responder com uma carta selada que o remetente original receberá. Cria retenção (motivo para voltar) e diferencial único no mercado.

**Para o usuário:**
1. Destinatário abre a carta e lê
2. Aparece botão "Responder com carta selada"
3. Tela de escrever carta abre pré-preenchida com o remetente original como destinatário
4. Usuário escolhe quando a resposta pode ser aberta
5. O remetente original recebe notificação: "Você recebeu uma resposta selada 🦉"
6. No cofre as cartas aparecem agrupadas como um fio de conversa

**Firestore — novo campo:**
```
letters/{letterId}: {
  ...campos existentes,
  replyToLetterId: string | null,  // ID da carta original
  threadId: string | null,          // ID do fio de conversa
}
```

**Flutter — mudanças:**
- `letter_opening_screen.dart` — adicionar botão "Responder com carta selada"
- `write_letter_screen.dart` — aceitar parâmetro `replyToLetterId` e `receiverUid` pré-preenchidos
- `vault_screen.dart` — agrupar cartas com mesmo `threadId` em fio de conversa
- `notification_service.dart` — notificação "Você recebeu uma resposta selada"

**Cloud Function:**
- Ao criar carta com `replyToLetterId` → notificar remetente original via FCM

#### Contagem Regressiva no Cofre

**Conceito:** em vez de mostrar apenas a data de abertura, mostrar contagem regressiva ("Abre em 47 dias", "Abre amanhã!", "Abre em 2 horas!").

**Implementação:**
- `vault_screen.dart` — calcular diferença entre `openDate` e `DateTime.now()`
- Mostrar em vermelho quando faltar menos de 7 dias
- Mostrar pulsando quando faltar menos de 24 horas

#### Card Compartilhável ao Enviar

**Conceito:** ao enviar uma carta, gerar um card animado para Stories que comunica "Acabei de selar uma carta para alguém especial 🦉 — Abre em [data]", sem revelar destinatário nem conteúdo. Reutiliza infraestrutura de Stories/Reels.

**Implementação:**
- Reutilizar a infra de `instagram_stories_share_service.dart`
- Criar template de card com envelope fechado + data de abertura
- Disparar após confirmação de envio em `write_letter_screen.dart`

#### Preview Antes de Selar

**Conceito:** antes de enviar, mostrar exatamente como o destinatário vai ver a carta (papel bege com linhas, fonte itálica, nome do remetente, estado emocional com cor), permitindo edição se necessário.

**Implementação:**
- Adicionar passo final no fluxo de criação da carta
- Reutilizar o widget de leitura da carta (`letter_opening_screen.dart`)
- Botão "Parece ótimo, selar!" ou "Editar"

---

## Fase 3 — Crescimento

Foco: expansão de produto e mercado.


| Entrega                                                                                   | Prioridade | Esforço (est.)        | Notas                                                                                                                                                                                                                                                                                                                                                 |
| ----------------------------------------------------------------------------------------- | ---------- | --------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Cápsula coletiva (multi-usuário)                                                          | P2         | Concluído (MVP grupo) | **Entregue:** convites, `participantUids` / `isCollective` / `contentMode` singleAuthor, regras Firestore, Cofre com streams fundidas, detalhe com participantes. **Pendente (fase seguinte):** **contribuições pré-selo** — cada participante adiciona respostas/blocos antes de selar (`contentMode` multiContributor, subcoleção `contributions`). |
| Música de fundo                                                                           | P2         | Médio                 | Licenciamento                                                                                                                                                                                                                                                                                                                                         |
| Voz gravada                                                                               | P2         | Médio                 | Storage + UX — distinto da **mensagem de voz** já suportada em cartas (MVP)                                                                                                                                                                                                                                                                           |
| Multilíngue (locales adicionais além de pt-BR / en / es)                                  | P2         | Alto                  | Base i18n já entregue (Fase 2); aqui expansão (ex.: mais idiomas ou variantes regionais)                                                                                                                                                                                                                                                              |
| Perfis familiares (membros, data de nascimento, fotos)                                    | P2         | Médio                 | Modelo de dados (limites, relação opcional); Storage; UX para menores e consentimento                                                                                                                                                                                                                                                                 |
| Recomendações por comportamento (trilha de ações, cartas públicas, curtidas, comentários) | P2         | Alto                  | Opt-in; minimização de dados; base analítica sólida                                                                                                                                                                                                                                                                                                   |
| Sugestões de ações por IA (círculo familiar, datas, contexto)                             | P2         | Alto                  | Pode reutilizar motor de recomendações; política clara sobre uso de fotos                                                                                                                                                                                                                                                                             |
| Moderação assistida (IA)                                                                  | P2         | Alto                  | **Base:** OpenAI Moderation API + adapters + `systemConfig`; ver [`ARCHITECTURE.md`](ARCHITECTURE.md). Evoluções (outras superfícies, políticas): política + custo                                                                                                                                                                                                                                                     |
| Humor do dia / leitura facial (inferência emocional + sugestões)                          | P2         | Alto                  | Opt-in explícito; compliance regional; preferir revisão jurídica e fornecedor com DPA ou processamento on-device                                                                                                                                                                                                                                      |
| Exportar cartas (PDF / ZIP) — evoluções                                                   | P2         | Médio                 | **MVP entregue** (`letter_export_service`, allowlist, Configurações). Aqui: melhorias futuras (escala, web/CORS, cloud) se necessário                                                                                                                                                                                                                 |
| **Export completo: suporte a volumes grandes (> 1 GB)**                                   | **P1**     | **Alto**              | **Obrigação legal (GDPR Art. 20 / LGPD Art. 18 V).** O export client-side actual monta o ZIP em RAM — crash provável em contas com centenas de áudios/fotos. Estratégias: export chunked (múltiplos ZIPs), server-side via Cloud Run, streaming ZIP para disco, ou híbrido com manifesto + signed URLs. Ver [`DATA_RETENTION_POLICY.md`](DATA_RETENTION_POLICY.md) §5 para análise detalhada. Resolver antes de escala significativa de utilizadores. |
| Backup redundante das cartas fora do Firebase                                             | P2         | Médio                 | Cópia de segurança dos dados (Firestore + Storage) para destino externo (ex.: Cloud Storage bucket separado, AWS S3); protecção contra perda acidental ou indisponibilidade do projecto Firebase                                                                                                                                                      |
| **Criptografia end-to-end (E2E) das cartas**                                             | P2         | Alto                  | Encriptar conteúdo das cartas (título, mensagem, áudio, fotos) no cliente antes de enviar ao Firestore/Storage, de modo que apenas remetente e destinatário consigam ler. Requer: gestão de chaves por utilizador (ex.: libsodium/NaCl sealed box ou AES-256-GCM com chave derivada), troca segura de chaves públicas, migração de cartas existentes (ou flag `encrypted: true` para novas), impacto na moderação (moderar antes de encriptar ou usar enclave). Referência: correção do texto de segurança (maio 2026) que removeu a alegação de E2E por não estar implementada — esta linha visa implementá-la de facto. |


---

## Fase 4 — Monetização

**Pré-requisito sugerido:** ~10k usuários ativos (alinhado à estratégia freemium → pay-per-feature).

**Infra já no repositório (scaffold):** subscrição por tiers (**Amanhã** / **Brisa** / **Horizonte**) com **Stripe Checkout**, **Customer Portal**, webhooks e **Firebase Cloud Functions**; estado em `users/{uid}`; cliente Flutter em `lib/core/billing/`. O fluxo de pagamento no app fica **desactivado por defeito** (`BILLING_ENABLED=false`) até configuração Stripe e deploy — ver `[functions/README.md](../functions/README.md)` e secção em `[ARCHITECTURE.md](ARCHITECTURE.md)`.


| Entrega                                                                                                         | Prioridade | Esforço (est.) | Notas                                                                                                                                                                                                                                                                                                                                                                                                                 |
| --------------------------------------------------------------------------------------------------------------- | ---------- | -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Pay-per-feature premium                                                                                         | —          | Alto           | Stripe / IAP conforme loja                                                                                                                                                                                                                                                                                                                                                                                            |
| **Whenote Gift** (Presente Selado / Gift When): valor financeiro selado à carta; liberação na data de abertura | —          | Alto           | **Fase 1 (MVP Gift):** Stripe Connect — retenção do valor até a abertura; Brasil e EUA; sem banco próprio; conta Connect aprovada; termos de uso e política de reembolso; pesquisa legal *money transmission* (EUA). Estimativa ~2–3 meses de desenvolvimento. Modelo de receita e posicionamento: `[BUSINESS.md](BUSINESS.md)`. Checklist de execução: `[MVP_CHECKLIST.md](MVP_CHECKLIST.md)` (Futuro — Gift & Nox). |
| Analytics de produto                                                                                            | —          | Médio          | Funis, retenção, conversão                                                                                                                                                                                                                                                                                                                                                                                            |


**Expansão Gift (após MVP do Gift):** PIX e carteiras digitais (BR); Wise (transferências internacionais); Apple Pay / Google Pay; parcerias bancárias; API bancária própria; licença de *money transmission* nos EUA (fase tardia). Códigos de resgate ou créditos para **premium** podem reutilizar a mesma stack de pagamentos — detalhar na implementação.

### Whenote Physical — Carta Física & Produtos Selados

**Conceito:** além das cartas digitais, o utilizador poderá enviar uma **carta física real** (impressa e selada com selo Whenote) e/ou **itens/produtos físicos** (presentes, livros, objetos simbólicos) ao destinatário, mantendo a mesma lógica temporal — o pacote só é enviado/entregue na **data de abertura** escolhida.

**Para o utilizador:**
1. Ao criar uma carta, escolhe "Carta digital" ou "Carta física" (ou ambas)
2. Se carta física: escreve no app → a carta é impressa em papel premium com design Whenote (selo da coruja, papel envelhecido, personalização por emoção)
3. Se incluir produto/presente: faz upload de foto do item ou seleciona de um **catálogo de parceiros** (ex.: flores, chocolates, livros, objetos artesanais)
4. Define a data de abertura → o envio físico é disparado automaticamente na data escolhida (ou X dias antes para garantir entrega a tempo)
5. Destinatário recebe o pacote físico + notificação no app + carta digital sincronizada

**Modelos de operação (a avaliar):**

| Modelo | Descrição | Prós | Contras |
|--------|-----------|------|---------|
| **Parceiro logístico (fulfillment)** | Integração com serviço de impressão e envio (ex.: Lob, Stannp, parceiro local BR) | Sem stock, escalável, menor investimento | Margem menor, dependência de terceiro |
| **Marketplace de presentes** | Catálogo curado de parceiros (floristas, livrarias, artesãos) — Whenote como intermediário | Variedade, sem stock próprio, comissão | Complexidade de integração, qualidade variável |
| **Print-on-demand (carta)** | Apenas a carta impressa + envelope premium, sem produto físico | Simples, margem alta, foco na emoção | Escopo limitado |

**Receita:**
- **Carta física:** preço fixo por unidade (ex.: R$15–30 / $5–10 USD) — inclui impressão, envelope premium e frete
- **Produto/presente:** comissão sobre cada venda de parceiro (ex.: 10–20%) ou markup sobre preço de custo
- **Bundle carta + presente:** preço combinado com desconto vs. itens separados

**Fases de desenvolvimento:**

| Fase | Escopo | Pré-requisitos |
|------|--------|----------------|
| **Physical 1 — Carta impressa** | Carta escrita no app → impressa em papel premium → enviada por correio ao destinatário na data certa | Parceiro de impressão/fulfillment; API de envio; pesquisa legal (envio postal, impostos) |
| **Physical 2 — Presentes de parceiros** | Catálogo de presentes curados (marketplace) que acompanham a carta | Parcerias com fornecedores; gestão de catálogo; logística de entrega combinada |
| **Physical 3 — Produto custom** | Utilizador envia item próprio (ex.: objecto pessoal) para armazenamento temporário e envio na data | Armazém/fulfillment center; seguro; termos legais para custódia de objectos |

**Considerações críticas:**
- **Logística temporal:** o envio deve ser programado para chegar na data de abertura (calcular lead time por região/país)
- **Alcance geográfico:** começar por Brasil (Correios + parceiros locais) e EUA (USPS/UPS + Lob); expandir depois
- **Legal:** regulamentação de envio postal, impostos sobre produtos, responsabilidade sobre itens em custódia — ver [`LEGAL.md`](LEGAL.md)
- **Moderação:** itens proibidos (armas, substâncias, etc.) — política de itens aceites
- **Integração com Gift When:** o presente físico pode substituir ou complementar o valor financeiro selado
- **Stripe KYC:** se vender produtos físicos, atualizar descrição do negócio no Stripe (ver [`BUSINESS.md`](BUSINESS.md))

### Estratégia para Investidores

**O que mostrar:**
1. A animação de abertura — o momento emocional único
2. Número de usuários e retenção (DAU/WAU)
3. O plano do Gift When como modelo de receita escalável

**O que NÃO mostrar primeiro:**
- Lista de funcionalidades técnicas
- Código ou arquitetura
- Funcionalidades que ainda não funcionam

**Metas de readiness para buscar investimento:**
- 1.000 usuários ativos
- Retenção D7 acima de 40%
- Pelo menos 1 carta aberta por usuário por semana
- Gift When em MVP mesmo que básico

### Sobre o App Completo e Retenção de Usuários

O app completo é um argumento para investidores — não o principal argumento para usuários. A retenção é impulsionada por:

1. **Receber uma carta e querer responder** — cria loop emocional contínuo
2. **Ter uma carta aguardando para abrir** — motivo para voltar na data
3. **Receber notificações de curtida no feed** — validação social e comunidade

Funcionalidades avançadas (GPS, voz, cápsula coletiva, recomendações) devem existir em background — o usuário as descobre quando está engajado, não na primeira experiência. A simplicidade inicial + retenção forte é mais convincente para investidores do que feature bloat.

---

## Como usar este roadmap

- Acompanhe o detalhamento de MVP em `[MVP_CHECKLIST.md](MVP_CHECKLIST.md)`.
- Mudanças de escopo: atualizar esta tabela e o changelog em `[CHANGELOG.md](CHANGELOG.md)`.
- **Novas ideias de produto:** preferir linhas neste roadmap (+ parágrafo em `[BUSINESS.md](BUSINESS.md)` se houver impacto em receita ou mercado) e itens em `[MVP_CHECKLIST.md](MVP_CHECKLIST.md)`; reservar arquivos em `planning/` a temas transversais (ex.: design system, testes em dispositivo).
- O cronograma detalhado (Semana 1–Mês 3+) e as especificações de funcionalidades prioritárias foram consolidados neste documento a partir de `NEXT_FEATURES.md`, mantendo centralização de roadmap e estratégia.
- Funcionalidades de **IA com perfilamento, fotos de terceiros ou biometria/emotion** (recomendações, círculo familiar, face): revisar **privacidade, bases legais e fornecedores** antes do lançamento.

