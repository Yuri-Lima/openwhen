# OpenWhen — Auditoria de UX e Produto
### Abril 2026 — Análise profissional como usuário experiente de redes sociais

---

## O Que Está Excepcional

- Proposta central única — nenhum app combina carta temporizada + rede social emocional + QR Code físico
- Animação de abertura com a coruja — tipo de detalhe que faz pessoas gravarem a tela e postarem no TikTok
- Design system consistente e premium
- História de origem genuína e poderosa
- Conceito "escreva hoje, sinta amanhã" — impossível de copiar

---

## 🔴 Problemas Críticos — Impedem o Crescimento

### 1. Primeira experiência complexa demais
- Usuário precisa entender: carta, cápsula, cofre, feed, estados emocionais, data de abertura, QR Code
- Apps que viralizaram (BeReal, Wordle) têm UMA ação clara
- **Solução:** onboarding que ensina UMA coisa — escrever e enviar a primeira carta. Só depois mostrar o resto.

### 2. Loop de engajamento vazio sem amigos
- Se nenhum amigo usa o app, feed vazio + cofre vazio = sem motivo para voltar
- **Solução:** sugerir contatos, mostrar cartas públicas com boa curadoria, criar desafio viral "escreva uma carta para você mesmo"

### 3. Notificações de engajamento não existem
- Sem notificação de curtida e comentário o usuário não tem motivo para abrir o app
- É o coração da retenção de qualquer rede social
- O Instagram sem notificações de curtida teria morrido em 2011
- **Solução:** Cloud Functions para curtida, comentário e seguidor (documentado em MVP_CHECKLIST.md)

### 4. Email quebrado
- Recuperação de senha não chega ao usuário
- ~~Verificação de email no cadastro não existe~~ → **IMPLEMENTADO ✅**
- Guard `requireVerifiedEmail()` bloqueia ações-chave (cartas, comentários, cápsulas) até email verificado
- Bottom sheet com reenvio e verificação inline

### 5. Busca não funciona
- Lupa do feed não faz nada ao clicar
- Busca de usuários não retorna resultados
- Sem busca o crescimento orgânico é impossível
- **Solução:** documentado em MVP_CHECKLIST.md

---

## 🟡 Problemas de UX — Vão Frustrar os Usuários

### 6. Sem experiência para quem não tem conta
- QR Code é genial mas se a pessoa escanear sem conta, o cadastro interrompe o momento emocional
- **Solução:** landing page web bonita que mostre a carta bloqueada e convide para criar conta mantendo a emoção

### 7. Sem contagem regressiva visível
- No cofre o usuário vê cartas aguardando mas não há contador visível
- "Abre em 47 dias" é muito mais envolvente do que só a data
- **Solução:** exibir contagem regressiva em dias como elemento central do card no cofre

### 8. Publicar carta é confuso
- Toggle "Permitir publicação" está no momento de criar mas quem publica é o destinatário ao abrir
- Contra-intuitivo — remetente ativa mas não controla quando publica
- **Solução:** explicação clara do fluxo na tela de criação e na tela de abertura

### 9. Feed sem identidade visual própria
- Feed de cartas públicas parece um Instagram de texto genérico
- Animação de abertura é linda mas só acontece uma vez
- **Solução:** visual único no feed — envelopes que se abrem ao rolar, estética de papel, diferenciação clara

### 10. Cápsula do tempo sem data mínima
- Possível criar cápsula para abrir amanhã — quebra a emoção do conceito
- **Solução:** data mínima de 30 dias para cápsulas — cria mais significado e antecipação

---

## 🟢 Oportunidades Que Estão Sendo Perdidas

### 11. Datas especiais como gatilho
- App deveria sugerir ativamente: "Seu aniversário é em 3 meses. Escreva uma carta para si mesmo?"
- Dia dos Namorados, Natal, aniversários — momentos emocionalmente carregados
- **Solução:** sistema de sugestões baseado em datas do calendário

### 12. Sem resposta à carta
- Destinatário abre carta emocionante e não pode responder
- **Sugestão:** resposta que também fica bloqueada por tempo — extraordinário e único

### 13. Sem preview antes de selar
- Ao criar uma carta o usuário não vê como vai aparecer para o destinatário
- **Solução:** preview realista com papel, fonte e elementos visuais antes de enviar

### 14. Compartilhar que enviou uma carta
- "Acabei de selar uma carta para alguém especial 🦉" — card compartilhável sem revelar conteúdo
- Marketing orgânico gratuito a cada carta enviada
- **Solução:** card animado para Stories ao enviar carta (não só ao abrir)

---

## Opinião Final

O OpenWhen tem o ingrediente mais difícil de criar: uma razão emocional para existir.
A coruja, a história de origem, o conceito — tudo genuíno e poderoso.

**O problema é foco.** O app tem 15 funcionalidades quando precisa de 3 que funcionem perfeitamente.

### Recomendação antes de lançar:
1. Esconder funcionalidades avançadas da interface principal
2. Mostrar UMA coisa na primeira experiência
3. Criar o hábito primeiro
4. Revelar o resto depois

O usuário não precisa de voz, GPS, proximidade, QR Code e cápsula coletiva ao mesmo tempo.
Precisa de uma primeira carta enviada com sucesso e uma notificação que o faça voltar no dia seguinte.

---
*Auditoria realizada em Abril 2026*
*Diego Rocha & Yuri Lima — OpenWhen Inc.*
