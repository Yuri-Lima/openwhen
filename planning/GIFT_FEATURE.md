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
