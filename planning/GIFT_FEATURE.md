# OpenWhen Gift — Presente Selado

## Visão Geral
Funcionalidade futura que permite ao remetente adicionar um valor financeiro
à carta temporizada. O dinheiro fica "selado" junto com a carta e só é
liberado para o destinatário na data de abertura escolhida.

## Conceito
"Escreva hoje. Presenteie amanhã."

O presente mais completo do mundo — palavras e valor financeiro juntos,
entregues no momento exato que o remetente escolheu.

## Diferenciais
- Nenhum app de carta faz isso hoje
- O dinheiro fica temporizado — só libera na data da carta
- Combina emoção (a carta) com valor prático (o presente)
- Funciona para qualquer distância — Brasil, EUA, mundo

## Fluxo do Usuário

### Remetente:
1. Escreve a carta normalmente
2. Opcionalmente ativa "Adicionar presente"
3. Escolhe o valor em dólares ou reais
4. Paga via cartão, PIX ou Apple Pay
5. O valor fica retido até a data de abertura

### Destinatário:
1. Recebe notificação "Sua carta está pronta"
2. Abre a carta com animação normal
3. Vê a mensagem emocional
4. Descobre o presente financeiro junto
5. Resgata para conta bancária, PIX ou carteira digital

## Tecnologia

### Fase 1 — MVP do Gift (sem banco próprio)
- Stripe Connect — processa pagamentos e retém o valor
- Stripe já é parceiro do Stripe Atlas (empresa do Diego)
- Sem necessidade de licença de money transmission
- Funciona no Brasil e EUA

### Fase 2 — Expansão
- PIX para mercado brasileiro
- Wise para transferências internacionais
- Apple Pay e Google Pay

### Fase 3 — Parcerias bancárias
- Parceria com banco digital (Nubank, Inter, Chime)
- API bancária própria
- Licença de money transmission nos EUA

## Modelo de Receita

### Taxa por transação — 2,9% + R$0,30
```
Exemplo:
Presente enviado:    R$100,00
Taxa OpenWhen 2,9%:  R$2,90
Taxa fixa:           R$0,30
Total de taxa:       R$3,20
Destinatário recebe: R$96,80
```

### Projeção de receita:
```
1.000 presentes/mês × R$50 médio = R$1.450/mês
5.000 presentes/mês × R$50 médio = R$7.250/mês
20.000 presentes/mês × R$50 médio = R$29.000/mês
```

### Por que 2,9%:
- É o mesmo que o Stripe cobra — repassamos ao usuário
- Quando crescer, negociamos taxa menor com Stripe
- A diferença vira lucro puro para o OpenWhen
- Transparente e justo para o usuário

## Diferença de Vaquinha Online
- Vaquinha = arrecadação coletiva para um objetivo
- OpenWhen Gift = presente direto de uma pessoa para outra
- Legalmente são produtos completamente diferentes
- Sem semelhança conceitual ou jurídica

## Nome da Funcionalidade
- "Presente Selado" (mercado brasileiro)
- "Gift When" (mercado americano)
- Mantém o DNA da marca OpenWhen

## Casos de Uso
- Namorado nos EUA enviando presente para namorada no Brasil
- Pais enviando mesada para filho que foi estudar fora
- Avó que quer garantir presente no aniversário do neto
- Empresa presenteando cliente com carta + vale presente

## Estimativa de Implementação
- Fase 1 MVP: 2-3 meses de desenvolvimento
- Requer: conta Stripe Connect aprovada
- Requer: termos de uso atualizados com política de reembolso
- Requer: pesquisa legal sobre money transmission nos EUA

## Status
[ ] Aprovado para desenvolvimento futuro
[ ] Pesquisa legal concluída
[ ] Integração Stripe Connect configurada
[ ] MVP desenvolvido
[ ] Lançado

---
*Ideia criada por Diego Rocha — CEO & Founder OpenWhen*
*Yuri Lima — CTO & Co-Founder OpenWhen*
*Data: Março 2026*

---

## NOX CARD — Card da Coruja (Funcionalidade Viral)

### Conceito
Quando alguém recebe um presente pelo OpenWhen, recebe também um
Card da Coruja — uma animação compartilhável onde a coruja aparece,
voa, solta o lacre e revela o nível do presente.

Feito para viralizar no TikTok e Instagram.

### Nome da Coruja
A coruja tem um nome próprio — ela é o personagem da marca.
Opções em avaliação (todas universais, sem regionalismo):
- **Owly** — simples, fofo, universal
- **Hoot** — som da coruja, conhecido mundialmente
- **Nox** — latim para noite, misterioso e elegante
- **Sage** — sábio em inglês, símbolo da coruja
- **Luno** — lua, onde a coruja voa
- **Oryn** — inventado, soa misterioso e universal

*Nome a ser decidido pelos founders antes do lançamento.*

### Níveis do Card
O card mostra o nível mas NUNCA o valor exato.
Quem recebe sabe o nível, não o número — protege quem tem menos condição.
A margem grande dentro de cada nível garante que ninguém saiba
se foi $1 ou $99 dentro do Bronze, por exemplo.

| Nível | Faixa de Valor | Visual |
|-------|---------------|--------|
| Bronze | $1 a $100 | Coruja com brilho bronze, tons quentes |
| Prata | $100 a $500 | Coruja prateada, elegante |
| Ouro | $500 a $2.000 | Coruja dourada, premium |
| Rubi | $2.000 a $10.000 | Coruja vermelha, exclusivo |
| Diamante | Acima de $10.000 | Coruja cristal, lendário |

### A Animação Compartilhável
1. Tela escura — dois olhos se abrem devagar
2. A coruja aparece completa voando
3. Ela pousa e segura um envelope lacrado
4. Bate as asas — o lacre se abre
5. O nível do card é revelado com efeito de luz
6. Aparece o nome do remetente e a mensagem
7. Botão "Compartilhar" para Stories e Reels

### Por Que Viraliza
- A animação é bonita e emocional — pessoas compartilham emoção
- O mistério do valor exato gera curiosidade nos comentários
- "Recebi um Nox Ouro!" vira status social
- Quem vê quer saber o que é — tráfego orgânico para o app
- A coruja já é a identidade da marca — reforça o branding

### Impacto na Marca
Cada card compartilhado é um anúncio gratuito do OpenWhen.
Cada pessoa que vê o card e não conhece o app vai pesquisar.
A coruja vira reconhecível — como o pombo do Twitter ou o cão do Snapchat.

### Receita Adicional
- Taxa de 2,9% + $0,30 já cobre o processamento
- Cards de nível Rubi e Diamante podem ter taxa especial
- Futuramente: cards colecionáveis NFT para níveis premium

### Roadmap do Nox Card
- [ ] Nome da coruja definido
- [ ] Animação do card criada
- [ ] Integração com Gift When (Fase 1)
- [ ] Compartilhamento para Stories e Reels
- [ ] Cards colecionáveis (futuro)

---
*Ideia criada por Diego Rocha — CEO & Founder OpenWhen*
*Yuri Lima — CTO & Co-Founder OpenWhen*
*Data: Março 2026*
