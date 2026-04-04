# OpenWhen — Próximas Funcionalidades e Cronograma
### Abril 2026 — Planejamento pós-auditoria de UX

---

## Cronograma de Implementação

### Semana 1 — Bloqueadores (antes de qualquer lançamento)
Responsável: Yuri

- [ ] Email de recuperação de senha funcionando
- [ ] Verificação de email no cadastro
- [ ] Notificações de curtida, comentário e seguidor (Cloud Functions)
- [ ] Lupa do feed com navegação para SearchScreen
- [ ] Busca de usuários retornando resultados

### Semana 2 — Retenção
Responsável: Diego + Yuri

- [ ] Contagem regressiva no cofre — "Abre em 47 dias"
- [ ] Card compartilhável ao enviar carta — "Selei uma carta 🦉"
- [ ] Data mínima de 30 dias nas cápsulas
- [ ] Resposta à carta (detalhado abaixo)

### Semana 3 — Crescimento orgânico
Responsável: Diego + Yuri

- [ ] Preview da carta antes de selar
- [ ] Explicação clara do fluxo de publicação
- [ ] Sugestões de datas especiais no momento de criar carta

### Mês 2 — Pós primeiros usuários
Responsável: Yuri

- [ ] Landing page web para quem recebe carta sem ter conta
- [ ] Feed com identidade visual própria — envelopes que se abrem ao rolar
- [ ] Sistema de sugestões por datas especiais (aniversários, Natal etc)

### Mês 3+ — Para investidores
Responsável: Diego + Yuri

- [ ] Gift When / Nox Card
- [ ] Analytics completo para mostrar métricas
- [ ] Meta: 1.000 usuários ativos antes de buscar investimento

---

## Funcionalidade Prioritária — Resposta à Carta

### Conceito
João recebe uma carta de Maria que abre no seu aniversário.
João lê, se emociona e quer responder.
Ele escreve uma resposta que Maria só pode ler daqui a 6 meses.
Cria um loop emocional contínuo entre duas pessoas ao longo do tempo.

### Por que é importante
- Resolve o problema de retenção — a pessoa tem motivo para voltar
- Cria fidelidade entre usuários — conversas de cartas ao longo de meses
- Diferencial único — nenhum app de mensagens faz isso
- Viral — "estou numa conversa de cartas com minha mãe há 1 ano"

### Como funciona para o usuário
1. Destinatário abre a carta e lê
2. Aparece botão "Responder com carta selada"
3. Tela de escrever carta abre pré-preenchida com o remetente original como destinatário
4. Usuário escolhe quando a resposta pode ser aberta
5. O remetente original recebe notificação: "Você recebeu uma resposta selada 🦉"
6. No cofre as cartas aparecem agrupadas como um fio de conversa

### Como implementar (Yuri)

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

---

## Funcionalidade — Contagem Regressiva no Cofre

### Conceito
Em vez de mostrar apenas a data de abertura, mostrar:
"Abre em 47 dias" ou "Abre amanhã!" ou "Abre em 2 horas!"

### Como implementar (Diego)
- `vault_screen.dart` — calcular diferença entre `openDate` e `DateTime.now()`
- Mostrar em vermelho quando faltar menos de 7 dias
- Mostrar pulsando quando faltar menos de 24 horas

---

## Funcionalidade — Card Compartilhável ao Enviar

### Conceito
Ao enviar uma carta, gerar um card animado para Stories:
"Acabei de selar uma carta para alguém especial 🦉
Abre em [data]"
Sem revelar o destinatário nem o conteúdo.

### Como implementar (Yuri)
- Reutilizar a infra de `instagram_stories_share_service.dart`
- Criar template de card com envelope fechado + data de abertura
- Disparar após confirmação de envio em `write_letter_screen.dart`

---

## Funcionalidade — Preview Antes de Selar

### Conceito
Antes de enviar, mostrar exatamente como o destinatário vai ver a carta:
- Papel bege com linhas
- Fonte itálica
- Nome do remetente
- Estado emocional com cor

### Como implementar (Diego)
- Adicionar passo final no fluxo de criação da carta
- Reutilizar o widget de leitura da carta (`letter_opening_screen.dart`)
- Botão "Parece ótimo, selar!" ou "Editar"

---

## Estratégia para Investidores

### O que mostrar
1. A animação de abertura — o momento emocional único
2. Número de usuários e retenção (DAU/WAU)
3. O plano do Gift When como modelo de receita escalável

### O que NÃO mostrar primeiro
- Lista de funcionalidades técnicas
- Código ou arquitetura
- Funcionalidades que ainda não funcionam

### Meta antes de buscar investimento
- 1.000 usuários ativos
- Retenção D7 acima de 40%
- Pelo menos 1 carta aberta por usuário por semana
- Gift When em MVP mesmo que básico

---

## Sobre o App Completo Segurar Usuários

O app completo é um argumento para investidores — não para usuários.
Para o usuário o que segura é:
1. Receber uma carta e querer responder
2. Ter uma carta aguardando para abrir
3. Receber notificação de curtida no feed

Funcionalidades avançadas (GPS, voz, cápsula coletiva) devem existir mas
ficarem em segundo plano — o usuário descobre quando está engajado,
não na primeira vez que abre o app.

---
*Documento criado em Abril 2026*
*Diego Rocha & Yuri Lima — OpenWhen Inc.*
