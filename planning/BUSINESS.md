# OpenWhen — Estratégia e negócio

Documento de contexto para investidores e parceiros. Detalhes técnicos: [`ARCHITECTURE.md`](ARCHITECTURE.md).

---

## Empresa

- **Forma:** Delaware C-Corp (via Stripe Atlas).
- **Founders:** Diego Rocha & Yuri Lima.

---

## Proposta de valor

OpenWhen combina **cartas temporizadas**, uma **rede social emocional** e **QR Code físico** para aproximar pessoas no tempo certo — não apenas no feed infinito.

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

Premium futuro pode incluir recursos como exportação avançada, temas, ou cápsulas coletivas — a definir com dados de uso. **IA** futura no produto foca em **assistência à criação e personalização** (incl. contexto familiar: datas importantes, relações), com transparência — não em vigilância do utilizador.

### OpenWhen Gift (valor selado à carta)

Produto planejado: o remetente pode **adicionar um valor financeiro** à carta temporizada; o montante fica retido até a **data de abertura** escolhida, quando o destinatário resgata (ex.: conta, PIX na expansão, carteira). Conceito de produto: *Escreva hoje. Presenteie amanhã.* — alinhado à tagline da marca (*Escreva hoje. Sinta amanhã.*).

- **Nomes de produto:** **Presente Selado** (BR) · **Gift When** (EUA) — mantém o DNA OpenWhen.
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

---

## Diferenciais competitivos

1. **Carta temporizada** — emoção no momento certo, não só “postar agora”.
2. **Rede social emocional** — feed e interações alinhadas a sentimento e intimidade, não só viralidade.
3. **QR Code físico** — ponte entre mundo real e digital (presentes, eventos, lembranças).
4. **Inteligência como apoio emocional** — roadmap prevê IA para sugestões alinhadas ao contexto (família, hábitos, criação de cartas), sempre com foco em confiança e opt-in onde houver dados sensíveis.
5. **Presente emocional + valor prático** — carta temporizada com opcional de valor financeiro selado (OpenWhen Gift), incluindo ângulo viral (Nox Card) sem expor montante exato.

---

## Métricas sugeridas (produto)

- Usuários ativos (DAU/WAU/MAU)
- Retenção D1 / D7 / D30
- Cartas e cápsulas criadas vs abertas
- Taxa de publicação no feed (após revisão, nas cápsulas)
- Crescimento de seguidores e engajamento (curtidas/comentários)
- Conversão para notificações ativas (FCM)

Roadmap de entregas: [`ROADMAP.md`](ROADMAP.md).
