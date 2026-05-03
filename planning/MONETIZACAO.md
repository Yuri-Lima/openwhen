# Whenote — Estratégia de Monetização e Custos Firebase

> Complementa [`ROADMAP.md`](ROADMAP.md) (secção "Contexto de negócio"). Foco prático: quanto custa, quando monetizar, como precificar.
> Última atualização: 13/04/2026

---

## 1. Custos Firebase — Estimativas Reais

### Plano obrigatório: Blaze (pay-as-you-go)

Pelo uso de Cloud Functions, o plano **Blaze é obrigatório**. O plano inclui quota gratuita mensal:

| Recurso | Quota grátis/mês | Preço após quota |
|---------|-----------------|-----------------|
| Firestore leituras | ~1,5M (50K/dia) | $0,06 / 100K |
| Firestore escritas | ~600K (20K/dia) | $0,18 / 100K |
| Firestore deletes | ~600K (20K/dia) | $0,02 / 100K |
| Cloud Functions invocações | 2M | $0,40 / 1M |
| Cloud Functions CPU | 400K GB-s | $0,0001 / GB-s |
| Storage armazenamento | 5 GB | $0,026 / GB/mês |
| Storage downloads | ~30 GB (1GB/dia) | $0,12 / GB |
| Authentication | Gratuito | — |
| Hosting bandwidth | 10 GB | $0,15 / GB |

### Estimativas por fase

| Fase | Registrados | DAU | Leituras/dia | Escritas/dia | Firebase/mês |
|------|-------------|-----|-------------|--------------|-------------|
| Beta fechado | 50–200 | 20–80 | ~4.000 | ~400 | **~$0** |
| Beta aberto | 200–1K | 80–300 | ~15.000 | ~1.500 | **~$0–5** |
| Crescimento | 1K–5K | 300–1.500 | ~45.000 | ~4.500 | **~$5–30** |
| Escala inicial | 5K–10K | 1.5K–3K | ~100.000 | ~10.000 | **~$30–100** |
| Escala real | 10K–50K | 3K–15K | ~500.000 | ~50.000 | **~$100–500** |

> Estimativas baseadas em ~50 leituras Firestore/sessão de 5 min, ~5 escritas/sessão, 2 sessões/dia por DAU.

### Riscos que podem inflar o custo

1. **Listeners sem `.limit()`** — um stream que lê 10.000 documentos a cada rebuild pode custar mais em 1 dia do que 1.000 usuários normais em 1 mês. Revisar: feed (Explorar), notificações, cofre.
2. **Moderação por IA (OpenAI)** — a cada carta enviada, `moderateContent` chama a API da OpenAI. Com 1.000 cartas/dia, o custo OpenAI (~$0,002/chamada = ~$2/dia = ~$60/mês) supera o Firebase.
3. **Storage de áudio** — voz de 1 min em OGG ≈ 500KB. 10.000 cartas com voz = 5GB de Storage. Implementar TTL para áudios de cartas já abertas.
4. **Bounces de email via SendGrid** — custo por email enviado. Conta trial (nova, criada 2026-05-03) com 100 emails/dia gratuitos. Revisar se é suficiente para o beta.

### Ação obrigatória antes de lançar

```
Google Cloud Console → Billing → Budgets & Alerts → Create Budget
Teto fase beta: $20/mês
Alertas: 50%, 80%, 100%
Emails: ambos os founders
```

---

## 2. Modelo de Monetização

### Princípio central

> **Não monetizar antes de 10.000 usuários.** Cobrar cedo mata a viralidade e o crescimento orgânico. O objetivo nos primeiros meses é criar hábito e boca a boca — não receita.

### Por que pay-per-feature (e não só assinatura mensal)

O Whenote não é um app de uso diário como Spotify ou Netflix. É um app de **momentos especiais** — datas marcantes, presentes emocionais, cartas de aniversário. Uma mensalidade cria ansiedade de justificativa ("estou usando o suficiente?"). Uma cobrança pontual no pico emocional (hora de criar a carta mais especial) é psicologicamente mais forte e menos propensa a churn.

### Estrutura proposta

#### Grátis para sempre
- Cartas de texto ilimitadas (texto puro)
- Receber e abrir cartas
- 1 cápsula ativa por vez
- Feed público básico (Explorar)
- QR Code padrão

> **Por que cartas de texto ilimitadas:** cada carta enviada é marketing orgânico gratuito. O destinatário recebe email/notificação e pode baixar o app. Limitar cartas seria limitar aquisição.

#### Carta Premium — R$3,99 por carta
*(ou R$9,99 por pacote de 5 cartas)*

- Mensagem de voz (até 5 min)
- Fotos na carta (até 5 por carta)
- Link de música integrado
- Abertura por GPS — só abre a 10m do local certo
- Fundo/papel personalizado por emoção (amor, saudade, conquista...)
- QR Code premium com design personalizado

#### Whenote+ — R$12,99/mês ou R$79/ano

- Carta Premium em todas as cartas (sem pagar por carta)
- Cápsulas coletivas ilimitadas
- "Aberta em" — notificação com horário exato em que o destinatário abriu
- Exportar todas as cartas em PDF
- Cápsulas do tempo sem limite de quantidade
- Acesso antecipado a: Resposta à Carta, Gift When, Nox Card

### Por que funciona

| Perfil | Comportamento | Receita |
|--------|--------------|---------|
| Usuário casual (3 cartas/ano) | Paga por carta especial | R$3,99–11,97/ano |
| Usuário frequente (2/mês) | Vê que assinatura compensa | R$12,99/mês |
| Power user | Assina anual | R$79/ano |

O upsell acontece no **momento de maior emoção**: escrever a carta mais especial do ano para o pai, para a namorada, para o melhor amigo. "Quer adicionar a sua voz a essa carta?" → R$3,99 parece pequeno nesse contexto emocional.

---

## 3. Estratégia de Retenção

O maior risco do Whenote não é o custo — é a churn: a pessoa instala, manda 1 carta, desinstala.

### O mecanismo de retenção natural já existe no produto

Cada carta enviada planta **duas sementes de retorno**:
1. O **remetente** volta quando recebe a notificação "sua carta foi aberta 🦉" — pode ser meses depois
2. O **destinatário** que baixou o app para abrir volta quando recebe cartas de outros

### O que acelera esse loop

| Ação | Impacto na retenção |
|------|-------------------|
| Resposta à carta (planejado) | Cria conversa temporal contínua — altíssimo |
| Notificação "sua carta foi aberta" | Traz remetente de volta após meses — alto |
| Card compartilhável ao enviar | Viral: "Selei uma carta 🦉" no Stories — médio |
| Sugestões de datas especiais | "Aniversário de X em 3 meses" — médio |
| Contagem regressiva no cofre | "Abre em 47 dias" — mantém antecipação — médio |

### O que não resolve retenção

Monetização não retém — só faz o usuário pensar antes de pagar. O hábito vem de **conexões emocionais com outras pessoas via o app**. Quando a pessoa tem 3 cartas esperando no cofre, ela volta. Quando tem zero, não volta.

---

## 4. Timeline — Quando Ativar o Quê

| Marco | Ação |
|-------|------|
| **Agora** (beta < 200 users) | Tudo grátis. Observar uso. Configurar Budget Alerts |
| **500 users** | Ativar `BILLING_ENABLED=true` em testes internos. Validar fluxo Stripe |
| **2.000 users** | Considerar early adopter plan: "Carta Premium por R$1,99" para primeiros 500 |
| **5.000 users** | Lançar Carta Premium R$3,99 e Whenote+ R$12,99/mês |
| **10.000 users** | Ativar Gift When (Presente Selado) — maior potencial de receita |
| **50.000 users** | Negociar taxa menor com Stripe. Contratar suporte dedicado |

---

## 5. Projeção de Receita (conservadora)

Assumindo 3% de conversão para pagante após 10.000 usuários:

| Usuários | Pagantes (3%) | ARPU médio/mês | MRR estimado |
|----------|--------------|---------------|-------------|
| 10.000 | 300 | R$8 | R$2.400/mês |
| 25.000 | 750 | R$9 | R$6.750/mês |
| 50.000 | 1.500 | R$10 | R$15.000/mês |
| 100.000 | 3.000 | R$11 | R$33.000/mês |

> ARPU (Average Revenue Per User) mistura cartas individuais (R$3,99) e assinantes (R$12,99).
> Com Gift When ativo, o ticket médio pode ser 3–5× maior.

---

## 6. Perguntas Frequentes

**"Não seria melhor cobrar por mensalidade logo?"**
Não. A taxa de conversão de um app com < 1.000 usuários ativos é < 1%. Cobrar cedo gera R$50/mês e afasta 99% dos potenciais usuários orgânicos.

**"E se alguém criar várias contas para usar de graça?"**
Cartas de texto são ilimitadas no grátis — não há incentivo para criar múltiplas contas. O premium é sobre a experiência da carta específica, não sobre quantidade.

**"O que acontece com cartas de usuários que cancelam o plano?"**
Cartas já enviadas permanecem. Quem cancelou perde acesso a novos recursos premium mas todas as cartas enviadas continuam funcionando. Política de continuidade em [`LEGAL.md`](LEGAL.md) (secção 1).

---

*Documento criado em 13/04/2026 · Diego Rocha & Claude · Whenote*
*Relacionado: [`ROADMAP.md`](ROADMAP.md) · [`DELAWARE.md`](DELAWARE.md)*
