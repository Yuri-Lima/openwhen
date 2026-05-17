# Whenote — Auditoria Completa · Abril 2026

> **Para:** Yuri Lima
> **De:** Diego Rocha + Claude
> **Data:** 13/04/2026
> **Objetivo:** Pente fino completo antes do lançamento — bugs, UX, custos, comparação com Instagram, estratégia de monetização.

---

## Resumo executivo

O app está **pronto para beta fechado com amigos** depois de corrigir 3 bloqueadores críticos. O trabalho do Yuri nas últimas semanas foi impressionante — notificações de engajamento, verificação de email, busca, lista de seguidores, privacy center, deleção de conta. A base técnica é sólida.

**Os 3 bloqueadores antes de qualquer lançamento:**
1. `checkUsernameAvailable` não deployada → bloqueia 100% dos cadastros
2. Cursor preso no campo de texto da carta → frustra o uso principal do app
3. Botão Apple Sign-in sem `onTap` → App Store rejeita se login social existir sem Apple

---

## 1. O Que o Yuri Entregou (confirmado no código e checklist)

Antes de falar dos problemas, é importante registrar o que foi concluído recentemente para não perdermos o contexto:

| Feature | Status | Data |
|---------|--------|------|
| Notificações de engajamento (curtida/comentário/seguidor) — Cloud Functions | ✅ Deployado | 12/04/2026 |
| Email de recuperação de senha (domínio personalizado) | ✅ Concluído | — |
| Verificação de email com guard + bottom sheet | ✅ Concluído | — |
| Lupa do feed → navega para SearchScreen | ✅ Concluído | — |
| Sino do feed → navega para tela de notificações | ✅ Concluído | — |
| Busca de usuários (catch silencioso corrigido) | ✅ Concluído | — |
| Detecção de bounce de email (SendGrid webhook) | ✅ Concluído | — |
| Lista de seguidores/seguindo com paginação | ✅ Concluído | — |
| Central de privacidade no app | ✅ Concluído | — |
| Deletar conta com exportação de dados + anonimizar | ✅ Concluído | — |
| Moderação por IA no envio (score 1-10, OpenAI) | ✅ Concluído | — |
| Termos de uso + confirmação de idade no cadastro | ✅ Concluído | — |
| Anti-spam nas notificações (dedup curtidas 5 min) | ✅ Concluído | — |
| Onboarding guia primeira ação | ✅ Concluído | — |
| Backfill contadores de seguidores | ✅ Concluído | — |

---

## 2. Bugs Críticos — Corrigir Antes do Lançamento

### 🔴 BUG #1 — `checkUsernameAvailable` não deployada

**Descrição:** A Cloud Function `checkUsernameAvailable` foi escrita em `functions/src/check_username.ts` e exportada em `functions/src/index.ts`, mas nunca foi deployada em produção. O resultado prático: quando o `_isUsernameAvailable()` em `register_screen.dart` é chamado (linha 127), o callable falha silenciosamente e retorna `false` (indisponível). **Todo username que qualquer novo usuário tentar usar vai aparecer como "já está em uso"**, tornando impossível o cadastro.

**Arquivo afetado:** `lib/features/auth/presentation/screens/register_screen.dart` → método `_isUsernameAvailable()`

**Solução:**
```bash
firebase deploy --only functions:checkUsernameAvailable
```

E no Dart, corrigir o catch (linha ~134):
```dart
} catch (e) {
  debugPrint('checkUsername error: $e');
  return true; // assume disponível se a função falhar
}
```

---

### 🔴 BUG #2 — Cursor preso no campo de texto da carta

**Descrição:** O usuário não consegue tocar numa posição específica do texto para corrigir uma letra. O cursor não vai para a posição tocada — fica sempre no final. Em cartas longas (o caso de uso mais emocional do app), é obrigatório apagar tudo até chegar no erro.

**Causa provável:** O `TextField` da mensagem (`write_letter_screen.dart` linha ~860) está dentro de uma estrutura com `GestureDetector` aninhados. Um dos `GestureDetectors` pode estar consumindo o evento de toque antes de chegar ao `TextField`. Verificar se o `GestureDetector` do `InkWell` da versão recolhida está interferindo com a versão expandida.

**Como reproduzir:**
1. Abrir tela de escrever carta
2. Expandir o campo de mensagem
3. Digitar 3+ linhas
4. Tentar tocar no meio do texto para corrigir uma letra
5. Cursor vai para o final em vez da posição tocada

**Arquivo:** `lib/features/letters/presentation/screens/write_letter_screen.dart`

---

### 🔴 BUG #3 — Botões Apple e Google (login) sem `onTap`

**Descrição:** Em `login_screen.dart`, o método `_buildSocialButtons()` (linhas 484–541) retorna dois `Container` sem nenhum `GestureDetector`, `InkWell` ou `onTap`. Ambos os botões são puramente visuais. O usuário toca e nada acontece.

**Impacto App Store:** A Apple exige que qualquer app que ofereça login social (Google, Facebook, etc.) **também deve obrigatoriamente oferecer Sign in with Apple**. Como o botão Apple aparece mas não funciona, o app pode ser rejeitado na review da App Store.

**Solução:** Implementar Sign in with Apple com `OAuthProvider` + nonce (documentado no checklist). Para o Google, usar `GoogleAuthProvider`. Enquanto não implementado, **recomendo esconder os botões** ou mostrar "Em breve" para não confundir usuários.

**Arquivo:** `lib/features/auth/presentation/screens/login_screen.dart`

---

### 🔴 BUG #4 — Budget Alerts Firebase não configurados

**Descrição:** Nenhum alerta de orçamento foi configurado no Google Cloud Console. Se houver um bug que gere leituras Firestore em loop (ex: listener sem `limit`, stream que re-subscribes a cada rebuild), os custos podem escalar em horas sem que ninguém perceba.

**Solução (15 minutos):**
1. Google Cloud Console → Billing → Budgets & Alerts
2. Criar alerta com teto de $20/mês (fase beta)
3. Alertas em: 50%, 80% e 100%
4. Notificação por email para ambos os founders

**Por que é urgente:** O plano Blaze é pay-as-you-go. Sem teto, não há proteção automática contra custos inesperados.

---

### ✅ BUG #5 — Aviso Camada 1 (resolvido abril/2026)

**Era:** risco de texto PT hardcoded no fluxo de carta; diálogos de moderação IA já usavam `letterModeration*` nos ARBs.

**Agora:** filtro lexical antes da IA em **escrever carta** e **criar cápsula** com `l10n.commentsModerationWarning` (4 ARBs). Lista partilhada: `lib/core/moderation/banned_lexical_words.dart`; comentários refactorados para o mesmo helper.

**Ver:** [`MODERATION.md`](MODERATION.md) §2 e [`CHANGELOG.md`](CHANGELOG.md) \[Unreleased].

---

## 3. UX — Problemas que Vão Frustrar Usuários

### Onboarding ainda complexo
O usuário chega ao app e precisa entender: carta, cápsula, cofre, feed, estados emocionais, data de abertura, QR Code, proximidade GPS. Apps que viralizaram têm UMA ação clara na primeira experiência. O UX_AUDIT.md documenta isso como #1. O `first_action_guide` foi implementado, mas o fluxo completo ainda é denso.

**Recomendação:** Esconder funcionalidades avançadas (GPS, voz, cápsula coletiva) da interface principal do primeiro acesso. Mostrar só: "Para quem você quer escrever? Quando essa pessoa pode abrir?"

### Sem rascunhos
Se o usuário começa a escrever uma carta longa e larga o app, perde tudo. Para o caso de uso mais emocional do app (cartas longas e significativas), isso é uma perda real.

**Arquivo:** `write_letter_screen.dart` — salvar automaticamente em `shared_preferences` com chave por usuário.

### Conta privada sem Follow Request
Se a conta é privada, qualquer pessoa pode seguir diretamente sem pedir permissão. O conceito de privacidade fica vazio. Documentado na seção anterior do checklist.

### Sem "Silenciar" — só bloquear
O usuário só pode bloquear. Não há opção de silenciar (parar de ver no feed sem bloquear). Cria fricção social para quem quer menos visibilidade de alguém sem o conflito de bloquear.

---

## 4. Funcionalidades Sugeridas pela Auditoria

### Alta prioridade (impacto em retenção)

**Resposta à carta** — quando o destinatário abre uma carta, poder responder com uma carta selada cria um loop emocional contínuo. É o recurso com maior potencial de retenção do roadmap. Especificação completa em `ROADMAP.md` (Semana 2).

**Rascunhos** — salvar automaticamente ao sair da tela de escrita.

**Card compartilhável ao enviar** — "Selei uma carta para alguém especial 🦉" — card animado para Stories, sem revelar conteúdo. Cada carta enviada se torna marketing orgânico gratuito.

### Média prioridade

**Salvar carta do feed** — poder marcar cartas bonitas de outros para rever. Campo `savedLetters` ou coleção `saves/{uid}`. Instagram tem isso há anos porque funciona.

**Preview da carta antes de selar** — dialog de confirmação com destinatário, data e prévia do conteúdo antes do envio definitivo.

**Data mínima 30 dias nas cápsulas** — cápsula para amanhã quebra a emoção do conceito. Simples validação no DatePicker.

**Múltiplas fotos por carta** (carrossel até 5).

---

## 5. Comparação com Instagram

O objetivo não é copiar o Instagram — é aprender com 15 anos de otimização de retenção e aplicar o que faz sentido para o DNA do Whenote.

### O que o Instagram tem e o Whenote deveria ter

| Feature | Por que importa | Esforço |
|---------|----------------|---------|
| Salvar/bookmark posts | Cria engajamento profundo com conteúdo de outros | Baixo |
| Rascunhos | Recuperar cartas interrompidas | Médio |
| Follow Request (privado) | Privacidade real em contas privadas | Médio |
| Silenciar contas | Opção social menos agressiva que bloquear | Baixo |
| Menções @usuario | Engajamento e conexões no feed | Alto |

### O que o Instagram NÃO tem e é diferencial único do Whenote

| Feature | Descrição |
|---------|-----------|
| Timer de abertura | Conteúdo bloqueado até uma data futura — impossível de replicar no Instagram |
| QR Code físico | Bridge digital/físico — carta impressa, colada, entregue |
| Abertura por GPS (10m) | Só abre no local certo — contexto físico único |
| Cápsula coletiva | Grupo que escreve junto para o futuro |
| Animação emocional | Experiência ritualizada de abrir uma carta |
| Gift When | Valor financeiro selado à carta (roadmap) |

**O QR Code físico é o maior diferencial e o menos explorado na comunicação.** No Instagram, tudo existe só no digital. O Whenote pode existir impresso, colado numa caixa de presente, guardado numa gaveta por anos. Esse posicionamento deveria estar no centro do marketing do lançamento.

### O que o Instagram tem mas NÃO faz sentido para o Whenote

- Reels curtos de vídeo — contrário à filosofia de profundidade e paciência
- Algoritmo de relevância instantânea — o Whenote é sobre espera, não sobre scroll infinito
- Lives — não alinhado com o conceito

---

## 6. Análise de Custos Firebase

### Estrutura obrigatória

Por usarem Cloud Functions, vocês **precisam obrigatoriamente do plano Blaze** (pay-as-you-go). O plano Spark (gratuito) não suporta Cloud Functions. A boa notícia: o Blaze inclui uma quota gratuita mensal generosa.

### Quota gratuita mensal incluída no Blaze

| Recurso | Quota grátis/mês |
|---------|-----------------|
| Firestore leituras | 50.000/dia (~1,5M/mês) |
| Firestore escritas | 20.000/dia (~600K/mês) |
| Firestore deletes | 20.000/dia (~600K/mês) |
| Cloud Functions invocações | 2.000.000/mês |
| Cloud Functions CPU | 400.000 GB-segundos/mês |
| Storage armazenamento | 5 GB total |
| Storage downloads | 1 GB/dia |
| Authentication | Gratuito (exceto SMS) |
| Hosting bandwidth | 10 GB/mês |

### Estimativa de custo por fase

| Fase | Usuários registrados | DAU estimado | Custo Firebase/mês |
|------|---------------------|--------------|-------------------|
| Beta fechado (agora) | 50–200 | 20–80 | **~$0** (dentro da quota) |
| Beta aberto | 200–1.000 | 80–300 | **~$0–5** |
| Crescimento inicial | 1.000–5.000 | 300–1.500 | **~$5–30** |
| Escala leve | 5.000–10.000 | 1.500–3.000 | **~$30–100** |
| Escala real | 10.000–50.000 | 3.000–15.000 | **~$100–500** |

**Conclusão:** vocês podem operar gratuitamente (ou quase) até ~3.000–5.000 usuários registrados. Com 10.000 usuários o Firebase custa ~$100/mês — momento certo para ativar monetização.

### Riscos de custo

1. **Listeners sem `limit`** — se algum stream do Firestore não tiver `.limit(N)`, cada atualização lê todos os documentos. Revisar especialmente: feed (Explorar), notificações, cofre.
2. **Cloud Functions de moderação** — `moderateContent` chama OpenAI a cada carta enviada. Com 1.000 cartas/dia, o custo da OpenAI pode superar o do Firebase.
3. **Storage de áudio/foto** — vozes de 1 min em OGG ~500KB. 10.000 cartas com voz = 5GB de Storage. Considerar TTL para áudios de cartas já abertas.

### Ação imediata obrigatória

```
Google Cloud Console → Billing → Budgets & Alerts → Create Budget
Teto: $20/mês para beta
Alertas: 50%, 80%, 100%
Notificação: email dos dois founders
```

---

## 7. Estratégia de Monetização

### O modelo certo para o Whenote

O medo do Diego é legítimo: a pessoa instala, manda 1 carta, desinstala. A solução não está só na monetização — está no **mecanismo de timer**. Cada carta enviada planta uma semente de retorno: a notificação "sua carta foi aberta 🦉" traz o remetente de volta meses depois. Esse é o loop de retenção natural do app.

### Modelo recomendado: Freemium + Pay-per-feature

**Por que não só assinatura mensal:**
- O Whenote não é um app de uso diário por design. É um app de momentos especiais.
- Uma mensalidade cria ansiedade: "estou usando o suficiente para justificar o gasto?"
- Uma cobrança pontual no momento mais emocional (hora de escrever a carta) é psicologicamente mais forte.

**Por que não limitar cartas de texto grátis:**
- Cada carta enviada é um vetor de aquisição — o destinatário recebe uma notificação ou email e pode baixar o app. Limitar cartas seria limitar marketing orgânico gratuito.

### Estrutura proposta

**Grátis para sempre:**
- Cartas de texto ilimitadas
- Receber e ler cartas
- 1 cápsula do tempo ativa por vez
- Feed público (explorar)
- QR Code básico

**"Carta Premium" — por carta (R$3,99/carta ou R$9,99 por pacote de 5):**
- Mensagem de voz (até 5 min)
- Fotos na carta (até 5 por carta)
- Link de música integrado
- Abertura por GPS (10m)
- Fundo/papel personalizado por emoção

**Whenote+ — R$12,99/mês ou R$79/ano:**
- Carta Premium em todas as cartas
- Cápsulas coletivas ilimitadas
- "Lida em" — ver quando destinatário abriu a carta
- Exportar todas as cartas em PDF
- Acesso antecipado a novidades (Resposta à Carta, Gift When)

**Por que esse modelo funciona:**
- Quem manda 3 cartas/ano paga R$11,97 (pay-per-use) — feliz, sem churn de assinatura
- Quem usa intensamente (10+ cartas) → assinatura faz sentido a R$12,99
- O upsell acontece no momento de maior emoção: "Quer adicionar sua voz a essa carta especial?" → R$3,99 é fácil de justificar nesse momento

### Marco de ativação

**Monetizar somente após 10.000 usuários registrados** (como documentado em `BUSINESS.md`). Antes disso, o foco é crescimento e retenção. Cobrar cedo demais mata a viralidade.

### Timeline de custos vs receita

| Marco | Firebase/mês | Receita estimada/mês | Situação |
|-------|-------------|---------------------|----------|
| 200 usuários | ~$0 | $0 (grátis) | Sustentável sem receita |
| 1.000 usuários | ~$5 | $0 (grátis) | Sustentável — $5 do bolso |
| 5.000 usuários | ~$20 | $0 ou primeiros pagantes | Ativar monetização opcional |
| 10.000 usuários | ~$80 | ~$300–800 (3–8% conversão) | Ativar monetização obrigatória |
| 50.000 usuários | ~$400 | ~$2.000–5.000 | Crescimento acelerado |

---

## 8. Checklist de Ações Imediatas (pré-lançamento beta)

### Yuri — Bloqueadores (fazer antes de qualquer convite)

- [ ] Deploy `checkUsernameAvailable`: `firebase deploy --only functions:checkUsernameAvailable`
- [ ] Corrigir catch silencioso em `register_screen.dart` `_isUsernameAvailable()`
- [ ] Corrigir cursor preso em `write_letter_screen.dart`
- [ ] Esconder ou implementar botões Apple/Google no login
- [x] Configurar Budget Alerts no Google Cloud Console ($20/mês, 50/80/100%) — ✅ 2026-05-01

### Diego — Pode fazer sem conflito com Yuri

- [x] Localizar aviso de conteúdo ofensivo nos ARBs (`commentsModerationWarning` + lexical em carta/cápsula) — 2026-04-28
- [ ] Data mínima 30 dias no DatePicker da cápsula (`create_capsule_screen.dart`)
- [ ] Preview antes de enviar carta (dialog de confirmação)
- [ ] Rascunho automático ao sair da escrita (`shared_preferences`)

### Ambos — Após beta

- [ ] Monitorar Firebase Usage nos primeiros 3 dias
- [ ] Colher feedback dos 20–30 primeiros usuários antes de nova feature
- [ ] Resposta à carta (Semana 2 do roadmap)
- [ ] Card compartilhável ao enviar

---

## 9. Opinião Final

O Whenote tem o ingrediente mais difícil de criar: **uma razão emocional para existir**. A coruja, a história de origem, o conceito — tudo genuíno e poderoso. A proposta de valor resiste ao tempo: escrever hoje para sentir amanhã é um diferencial que nenhuma big tech pode copiar facilmente porque não é técnico — é humano.

A execução técnica está acima da média para uma equipe de 2 pessoas num MVP. A documentação de planejamento é de nível profissional.

**O problema não é o código. É o hábito.** O app precisa de 3 coisas para o lançamento funcionar:
1. Os bugs acima corrigidos (especialmente o cadastro)
2. 20–30 primeiros usuários enviando a primeira carta com sucesso
3. A notificação "sua carta foi aberta" funcionando — esse é o momento de maior impacto emocional e o maior vetor de boca a boca

**Quando lançar:** assim que o BUG #1 (checkUsername) e BUG #2 (cursor) estiverem corrigidos. Os botões Apple/Google podem esperar se os botões forem escondidos temporariamente.

---

*Auditoria realizada por Diego Rocha & Claude · Whenote · 13/04/2026*
*Próxima revisão recomendada: após primeiros 100 usuários ativos*
