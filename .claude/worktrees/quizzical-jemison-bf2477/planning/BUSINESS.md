# Whenote — Estratégia e negócio

Documento de contexto para investidores e parceiros. Detalhes técnicos: [`ARCHITECTURE.md`](ARCHITECTURE.md).

---

## Empresa

- **Forma:** Delaware C-Corp (via Stripe Atlas).
- **Founders:** Diego Rocha & Yuri Lima.

---

## Estrutura jurídica e abertura

### Por Que Delaware C-Corp

- Leis favoráveis para startups de tecnologia (referência: Google, Facebook, Stripe, Airbnb).
- Investidores americanos exigem Delaware C-Corp.
- Sem imposto estadual sobre empresas que não operam lá.
- Proteção legal maior para os founders (separação de bens pessoais).

### Custos

| Fase | Descrição | Valor |
|------|-----------|-------|
| **Abertura** | Stripe Atlas | $500 |
| **Anuais** | Registered Agent + Delaware Franchise Tax | $950 a $2.450 |

Recomendação: **Stripe Atlas ($500)** — já temos conta no Stripe, integração direta com pagamentos, suporte especializado.

### Conta Bancária

Mercury Bank (mercury.com): 100% online, gratuito, feito para startups, integra com Stripe.

### Quando Abrir

Abrir quando o app estiver **pronto para lançar**. Assim já lança com empresa pronta e processa pagamentos desde o primeiro dia. Antes disso, não aceitar dinheiro de usuários, investimento ou assinar contratos em nome da empresa.

### Passo a Passo

1. App pronto para lançar
2. Abrir pelo Stripe Atlas (stripe.com/atlas) — $500
3. Abrir conta no Mercury Bank (mercury.com) — gratuito
4. Atualizar Stripe com dados da empresa
5. Convidar Yuri Lima como Developer no Stripe
6. Configurar APIs de pagamento
7. Contratar contador quando começar a faturar

---

## Proposta de valor

Whenote combina **cartas temporizadas**, uma **rede social emocional** e **QR Code físico** para aproximar pessoas no tempo certo — não apenas no feed infinito.

**Tagline:** *Escreva hoje. Sinta amanhã.*

---

## Mercado e público

| Dimensão | Direção |
|----------|---------|
| **Geografia** | Brasil primeiro; expansão para EUA depois |
| **Faixa etária** | ~18–35 anos |
| **Comportamento** | Usuários ativos de Instagram / TikTok; confortáveis com stories e compartilhamento |

---

## Monetização

| Fase | Modelo |
|------|--------|
| Atual | **Freemium** — crescimento e retenção |
| Escala | **Pay-per-feature** somente após marco de ~**10k usuários** (evitar monetizar cedo demais) |

**Subscrição (tiers):** o produto prevê níveis nomeados (**Amanhã**, **Brisa**, **Horizonte**) com pagamento recorrente via **Stripe** (Checkout + portal do cliente) e sincronização server-side (Firebase Cloud Functions + estado no perfil). A integração técnica pode existir no código antes do “go live” comercial; política de quando activar a cobrança segue o marco de escala acima.

### Texto para onboarding Stripe (KYC / “What products or services…”)

Use na consola Stripe (inglês) — alinhado ao produto e à stack descrita acima; ajuste só se o go-to-market mudar.

**English (short):**  
“We operate Whenote, a consumer software application for scheduled digital letters, guided time capsules, and an emotional social feed. Through Stripe we sell recurring subscription plans (named tiers) that unlock premium digital features in the app. We may later add optional pay-per-feature upgrades, in-app digital purchases, and scheduled delivery of printed letters and curated physical gifts. Current offerings are digital services; physical goods fulfillment is on our product roadmap.”

**English (longer, if the form allows):**  
“Whenote (Delaware C-Corp) offers a cross-platform application where users write messages that unlock in the future—scheduled letters, time capsules, and optional sharing in a social layer—with QR code flows connecting physical touchpoints to the app. Stripe processes subscription payments for premium membership tiers (recurring billing) and, when activated, the Stripe Customer Portal for plan management. Future roadmap items may include sealed monetary gifts attached to letters, additional digital add-ons, and scheduled delivery of printed letters and curated physical gifts tied to letter opening dates. Current offerings are digital services; physical goods fulfillment will be added as a future product line.”

**Português (referência interna / formulários em PT):**  
“A Whenote oferece uma aplicação de software para cartas temporizadas, cápsulas do tempo guiadas e feed social emocional, com ponte por QR Code. Através do Stripe vendemos assinaturas recorrentes (planos nomeados) que desbloqueiam funcionalidades premium digitais na app. O roadmap inclui pay-per-feature, complementos digitais, e futuramente envio de cartas impressas e presentes físicos programados para a data de abertura. Atualmente tudo como serviço digital; envio de produtos físicos será adicionado como linha de produto futura.”

Premium futuro pode incluir recursos como exportação avançada, temas, ou cápsulas coletivas — a definir com dados de uso. **IA** futura no produto foca em **assistência à criação e personalização** (incl. contexto familiar: datas importantes, relações), com transparência — não em vigilância do utilizador.

### Whenote Gift (valor selado à carta)

Produto planejado: o remetente pode **adicionar um valor financeiro** à carta temporizada; o montante fica retido até a **data de abertura** escolhida, quando o destinatário resgata (ex.: conta, PIX na expansão, carteira). Conceito de produto: *Escreva hoje. Presenteie amanhã.* — alinhado à tagline da marca (*Escreva hoje. Sinta amanhã.*).

- **Nomes de produto:** **Presente Selado** (BR) · **Gift When** (EUA) — mantém o DNA Whenote.
- **Receita por transação (referência):** taxa transparente no modelo **2,9% + valor fixo por transação** (ex.: +R$ 0,30 em BRL), alinhada à estrutura do processador; em escala, negociar taxa menor com o parceiro e retê-la como margem. Projeções de volume estão no roadmap de negócio interno; não substituem modelo financeiro formal.
- **Diferença vs vaquinha / crowdfunding:** arrecadação coletiva para um objetivo é um produto jurídico e de percepção distinto; o Gift é **presente direto de uma pessoa para outra**, atrelado à carta temporizada — sem equivalência conceitual ou jurídica com campanhas de vaquinha.

**Nox Card** (card da coruja): experiência viral opcional quando há presente — animação compartilhável (Stories / Reels); o card mostra **nível**, nunca o valor exato (faixas largas para preservar privacidade). Nome do mascote em avaliação (ex.: Owly, Hoot, Nox, Sage, Luno, Oryn). Detalhe de entregas: [`ROADMAP.md`](ROADMAP.md).

| Nível | Faixa indicativa (USD) | Notas |
|-------|------------------------|--------|
| Bronze | $1 – $100 | Visual bronze / tons quentes |
| Prata | $100 – $500 | Visual prateado |
| Ouro | $500 – $2.000 | Visual dourado |
| Rubi | $2.000 – $10.000 | Visual vermelho / exclusivo |
| Diamante | acima de $10.000 | Visual cristal / lendário |

**Outros (escala):** compra no app ou na web e **resgate** via código (saldo ou desbloqueio premium) pode reutilizar a mesma stack de pagamentos — alinhado ao marco de ~10k usuários e à Stripe, salvo decisão contrária de produto.

### Whenote Physical — Carta Física & Produtos Selados

**Visão:** expandir o Whenote do mundo digital para o físico — o utilizador pode enviar uma **carta real impressa** e/ou **presentes/produtos físicos** que chegam ao destinatário na data de abertura escolhida. O produto físico reforça o valor emocional da plataforma e cria uma nova vertical de receita com margem significativa.

**Proposta de valor para o mercado:**
- Nenhuma plataforma combina **carta temporizada + presente físico programado** — diferencial único
- Ponte natural entre digital e físico já existente no Whenote (QR Code)
- Apelo forte para datas comemorativas (aniversários, Natal, Dia dos Namorados, formaturas)
- Potencial de viralidade: receber um pacote físico inesperado gera conteúdo orgânico (unboxing)

**Modelo de receita (estimativas iniciais):**

| Produto | Preço estimado (BR) | Preço estimado (EUA) | Margem estimada |
|---------|---------------------|----------------------|-----------------|
| Carta impressa premium (envelope + selo) | R$15–30 | $5–10 | 50–70% |
| Carta + presente de catálogo (parceiro) | R$50–200+ | $20–80+ | 15–25% (comissão) |
| Bundle carta + Gift When (digital + físico) | variável | variável | mista |

**Parceiros potenciais (pesquisa inicial necessária):**
- **Impressão/fulfillment (carta):** Lob (EUA), Stannp (global), gráficas locais (BR)
- **Presentes/marketplace:** floristas, chocolatiers, livrarias, artesãos locais — curadoria por região
- **Logística:** Correios (BR), USPS/UPS/FedEx (EUA); cálculo de lead time por CEP/ZIP

**Impacto na estratégia Stripe/KYC:** quando a feature de envio físico for activada, o perfil Stripe do Whenote passará a incluir venda de produtos tangíveis (ver textos KYC atualizados abaixo). Até lá, manter a descrição actual (serviços digitais).

**Pré-requisito sugerido:** validar demanda com **waitlist** ou **pesquisa com utilizadores** antes de investir em integração logística. Começar com carta impressa (Physical 1) antes de marketplace de presentes. Detalhes de implementação: [`ROADMAP.md`](ROADMAP.md) Fase 4.

---

## Diferenciais competitivos

1. **Carta temporizada** — emoção no momento certo, não só “postar agora”.
2. **Rede social emocional** — feed e interações alinhadas a sentimento e intimidade, não só viralidade.
3. **QR Code físico** — ponte entre mundo real e digital (presentes, eventos, lembranças).
4. **Inteligência como apoio emocional** — roadmap prevê IA para sugestões alinhadas ao contexto (família, hábitos, criação de cartas), sempre com foco em confiança e opt-in onde houver dados sensíveis.
5. **Presente emocional + valor prático** — carta temporizada com opcional de valor financeiro selado (Whenote Gift), incluindo ângulo viral (Nox Card) sem expor montante exato.
6. **Do digital ao físico** — possibilidade futura de enviar carta impressa real e/ou presentes físicos programados para a data de abertura (Whenote Physical) — nenhuma plataforma combina temporização + envio físico programado.

---

## Métricas sugeridas (produto)

- Usuários ativos (DAU/WAU/MAU)
- Retenção D1 / D7 / D30
- Cartas e cápsulas criadas vs abertas
- Taxa de publicação no feed (após revisão, nas cápsulas)
- Crescimento de seguidores e engajamento (curtidas/comentários)
- Conversão para notificações ativas (FCM)

Roadmap de entregas: [`ROADMAP.md`](ROADMAP.md).
Estratégia para investidores e metas de readiness: [`ROADMAP.md`](ROADMAP.md) Fase 4 (§Estratégia para Investidores).
