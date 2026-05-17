# Whenote — Auditoria Completa (Maio 2026)

> Documento gerado em 02/05/2026. Análise técnica, estratégica e de negócio com base em revisão
> completa do código-fonte, planning docs, histórico de commits e arquitetura do projeto.
> Avaliação independente e imparcial — inclui pontos fortes, críticas diretas e recomendações.

---

## 1. O que o Yuri fez — e estado atual da master

### Commits de Yuri (incorporados à master)

Nos últimos ciclos, o Yuri entregou 36 commits que cobrem as áreas mais críticas do projeto:

**Autenticação social (desbloqueador B3):**
- Apple Sign-In completo — `OAuthProvider`, nonce SHA-256, entitlements iOS, criação do doc Firestore no primeiro login
- Google Sign-In completo — `GoogleSignIn` + `GoogleAuthProvider.credential`, `REVERSED_CLIENT_ID` no Info.plist
- Geração de usernames legíveis no OAuth (sem conflito com `checkUsernameAvailable`)
- UX de erro de senha incorreta melhorada no login

**Qualidade e segurança:**
- `letter_emotional_primer_screen.dart` — tela de aviso emocional antes da abertura da carta (mostrada uma vez por dispositivo)
- Filtro lexical (Camada 1) — `banned_lexical_words.dart` com ARB en/pt/pt-BR/es, ativo em cartas e cápsulas
- Correção definitiva do cursor preso no `write_letter_screen.dart` (desbloqueador B2)
- `checkUsernameAvailable` callable v2 deployada em `us-central1` (desbloqueador B1)

**Infra e operações:**
- Budget Alerts configurados — €20/mês, 50/80/100%, email admins (desbloqueador B4)
- Microphone permission no iOS (`NSMicrophoneUsageDescription`)
- Localizações (ARB) atualizadas com informações da empresa
- Documentos legais atualizados (ToS, privacidade)

**App Store:**
- Screenshots para App Store Connect (build 17 no TestFlight)
- `Podfile.lock` atualizado

**Git (concluído na sessão anterior):**
- Branch `master` = `origin/master` = `cdd80d3` — tudo sincronizado
- Branch `main` local foi fast-forwarded para `master` com sucesso
- **Ação pendente para você:** executar `git push origin main` no terminal do Cursor (remote bloqueado no sandbox)

### Conclusão sobre conflitos

Não há conflito. O merge foi limpo — `main` era subconjunto exato de `master`. A master atual reflete o trabalho de ambos sem sobreposição.

---

## 2. Como estamos indo — relatório de progresso

### Núcleo técnico: ✅ Completo

O app está tecnicamente pronto para funcionar. Features core implementadas:

| Área | Status |
|------|--------|
| Auth (email, Apple, Google) | ✅ |
| Escrever e enviar cartas | ✅ |
| Timer de abertura + animação | ✅ |
| Cofre (Aguardando / Abertas / Enviadas / Cápsulas) | ✅ |
| Feed social (3 camadas + filtros de emoção) | ✅ |
| Notificações push (curtida, comentário, seguidor) | ✅ |
| QR Code + abertura por GPS (10m) | ✅ |
| Moderação por IA (OpenAI, score 1-10) | ✅ |
| Export de cartas (PDF/ZIP) | ✅ |
| Temas (classic, dark, midnight, sepia) | ✅ |
| Multilíngue (pt-BR, en, es) | ✅ |
| Legal (LGPD, GDPR, CCPA) | ✅ |
| Domínio `whenote.app` + hosting | ✅ |
| Budget alerts Firebase | ✅ |

### Bloqueadores: ✅ Todos resolvidos

Todos os 4 bloqueadores críticos identificados na auditoria de abril estão resolvidos.

### O que ainda falta para o soft launch

| Item | Responsável | Criticidade |
|------|-------------|-------------|
| Simplificação do onboarding | Yuri | 🔴 Alta |
| Screenshots para App Store (mínimo 3 iPhone 6.5") | Diego | 🔴 Alta |
| Testar com 5 usuários reais antes de lançar | Diego | 🔴 Alta |
| Revisar Termos de Uso com advogado | Diego | 🟡 Recomendado |

### Onde vocês estão na linha do tempo

```
[✅ Núcleo]  [✅ Bloqueadores]  [← AQUI]  [Soft launch amigos]  [Beta stores]  [Loja pública]
```

Estão na fronteira entre "pronto para testar internamente" e "pronto para mostrar para pessoas reais". Falta 1–2 semanas de polish para soft launch.

---

## 3. Estratégia de lançamento — do círculo próximo às lojas

### Fase 0 — Hoje: validação interna (1 semana)

Antes de mostrar para qualquer pessoa:

1. Simplifique o onboarding (Yuri) — a primeira experiência precisa ser: escrever uma carta → escolher data → selar. Nada mais.
2. Teste o app do zero em um dispositivo limpo, como se fosse um usuário novo. Documente cada fricção.
3. Crie 3–5 contas de teste com dados reais: envie cartas para si mesmo com datas de amanhã, de 1 semana, de 1 mês.
4. Confirme que o fluxo de abertura (notificação → tela de aviso emocional → animação da coruja) funciona perfeitamente.

### Fase 1 — Soft launch: círculo próximo (2–3 semanas)

**Quem convidar primeiro:**
- 10–15 pessoas de confiança máxima: família imediata, amigos de longa data, colegas técnicos
- Não convidar influenciadores ou desconhecidos nesta fase
- Misturar perfis: alguém mais velho (40+), alguém menos tecnológico, alguém que usa muito redes sociais

**Como fazer:**
- Convite pessoal e individual — não postar em redes sociais ainda
- Mensagem direta: "Estou lançando meu app. Quero sua opinião honesta. Pode testar por uma semana?"
- Dar as credenciais do TestFlight (iOS) ou APK direto (Android) — ainda não nas lojas
- Criar um grupo WhatsApp privado de beta testers para coleta de feedback

**O que perguntar:**
- "Você entendeu para que serve o app nos primeiros 30 segundos?"
- "Você conseguiu escrever e enviar uma carta sem ajuda?"
- "O que te confundiu?"
- "Você usaria isso de novo? Por quê?"

**Critério para avançar para Fase 2:**
- 70%+ dos testers conseguem completar o fluxo principal sem ajuda
- Nenhum crash crítico reportado
- Pelo menos 3 pessoas espontaneamente disseram "vou usar de verdade"

### Fase 2 — Beta semi-público (4–6 semanas)

**Quem convidar:**
- Expandir para 50–100 pessoas — amigos de amigos, comunidades específicas
- Grupos de WhatsApp/Telegram temáticos: "Diário pessoal", "Carta para o futuro", noivas (aniversário + carta de casamento), pais de filhos pequenos (carta para o futuro do filho)
- Micro-influenciadores (1K–10K seguidores) que falam de emoção, saudade, relacionamentos

**Presença digital mínima:**
- Perfil no Instagram: @whenote — comece a postar, mas sem gastar dinheiro em ads ainda
- 3–5 Reels mostrando o conceito de forma emocional (o vídeo do CapCut que você está editando serve como base)
- Bio com link para `whenote.app`

**Critério para avançar para Fase 3:**
- 50+ usuários ativos com pelo menos 1 carta enviada
- DAU/MAU > 20%
- Sem bugs críticos em aberto

### Fase 3 — Lançamento nas lojas (Mês 3)

**iOS:**
- Submeter screenshots (único bloqueador restante)
- Submit para revisão App Store — esperar 1–7 dias úteis
- Ter resposta preparada para perguntas da Apple Review

**Android:**
- Subir APK no Google Play Console como "Acesso antecipado" (evita revisão completa imediata)
- Gradualmente expandir para 100% dos países

**Lançamento coordenado:**
- Post único no Instagram/TikTok no dia do lançamento nas lojas — emocional, sem click-bait
- Pedir para os beta testers deixarem review de 5 estrelas no primeiro dia (os primeiros reviews são críticos para o algoritmo das lojas)
- Mensagem pessoal para cada beta tester: "Acabou de ir ao ar. Se gostar, 1 minuto de review me ajuda muito."

---

## 4. Checklist pré-lançamento completo

### 🔴 Bloqueadores absolutos (não lançar sem isto)

- [ ] Onboarding simplificado (Yuri) — primeira ação = escrever carta, nada mais
- [ ] Screenshots para App Store Connect (mínimo 3, iPhone 6.5") — Diego
- [ ] Testar abertura de carta em tempo real (carta com unlock em 1 min, 5 min, 1h)
- [ ] Testar com 5 usuários reais antes de qualquer divulgação

### 🟡 Fortemente recomendados

- [ ] Revisar Termos de Uso com advogado (especialmente cláusula de encerramento de serviço)
- [ ] Configurar Firebase App Check (previne abuso de API por bots — custo real)
- [ ] Carta de resposta implementada (Yuri) — maior driver de retenção
- [ ] Rascunho automático (Diego) — evita perda de conteúdo, reduz abandono

### 🟢 Importantes, mas podem ser pós-soft-launch

- [ ] Preview antes de selar (dialog de confirmação)
- [ ] Card compartilhável ao enviar carta (Stories/Reels)
- [ ] Follow Request para contas privadas
- [ ] Data mínima 30 dias para cápsulas
- [ ] Links reais de download nas páginas (substituir placeholders)
- [ ] Backup redundante de cartas fora do Firebase
- [ ] Confirmar que `whenote.app` tem auto-renew ativo no Cloudflare (expira 10/04/2027)
- [ ] `git push origin main` para sincronizar branch remota

### ✅ Já feito e verificado

- [x] Todos os 4 bloqueadores (B1–B4) resolvidos
- [x] Legal completo (LGPD, GDPR, CCPA, ToS)
- [x] Budget alerts Firebase (€20/mês)
- [x] Apple Sign-In + Google Sign-In
- [x] Moderação por IA ativa
- [x] Filtro lexical (Camada 1)
- [x] Aviso emocional antes de abrir carta
- [x] Export de dados (cumprimento LGPD)
- [x] Página de suporte publicada
- [x] Build no TestFlight (build 17)

---

## 5. Opinião profissional e sincera

### O que está genuinamente bom

**O conceito é forte.** "Escreva hoje. Sinta amanhã." tem apelo emocional real e imediato. Em um mercado saturado de redes sociais baseadas em presença e imediatismo, um produto que usa o tempo como mecanismo central é genuinamente diferente. Não é mais um clone de Instagram com nova skin.

**Os diferenciais são reais e difíceis de copiar.** Timer de abertura, QR Code físico, abertura por GPS, animação emocional ritualizada — esses elementos criam um ritual que é qualitativamente diferente de mandar mensagem no WhatsApp. O Instagram não vai copiar isso tão cedo porque vai contra a lógica do engajamento imediato que sustenta o negócio deles.

**A qualidade técnica está acima da média para um projeto early-stage.** Clean architecture (features separadas, Riverpod, Repository pattern), multilíngue desde o início, legal completo, código de infraestrutura sólido. A maioria dos projetos early-stage não tem metade disso. O Yuri e você fizeram um trabalho técnico sério.

**O timing está alinhado com a cultura.** Tem uma nostalgia crescente, fadiga de redes sociais imediatas e busca por autenticidade emocional, especialmente na faixa de 18–35 anos no Brasil. O app fala exatamente com esse espírito.

### O que preocupa — honestidade direta

**O onboarding vai matar a retenção se não for simplificado.** Esse é o ponto mais crítico. Um usuário novo que abre o app e vê GPS, cápsulas, feed, QR Code, cofre — sem entender para que serve — vai desinstalar em 2 minutos. A primeira experiência precisa ser um único ato emocional completo: escrever uma carta, selar, esperar. Só depois mostrar o resto. Isso não é opcional.

**A ausência de resposta à carta é um furo de retenção.** O app cria uma emoção intensa quando a carta é aberta. E depois? Não tem como responder. O usuário que recebe uma carta linda não tem para onde canalizar a emoção dentro do app. Isso precisa ser implementado antes de qualquer divulgação em escala.

**O produto resolve um problema que as pessoas não sabem que têm.** Essa é a dificuldade central do marketing. Ninguém acorda pensando "preciso de um app para carta do futuro". Isso significa que o marketing de performance clássico (anúncios diretos com CTA "Baixe agora") vai ter CAC alto. O canal que vai funcionar melhor é o emocional orgânico — vídeos que fazem as pessoas sentirem antes de clicar.

**A monetização está bem calibrada no plano, mas o timing vai ser difícil.** Esperar 10K usuários para monetizar é a decisão certa. O risco é que os custos Firebase (especialmente Storage para áudios e Firestore reads) podem crescer antes de você chegar a 10K se tiver picos de crescimento. Monitore semanalmente.

### Potencial de sucesso — avaliação honesta

**Cenário realista (18 meses):** 5K–15K usuários ativos, retenção D30 de 20–35%, crescimento principalmente via Brasil. Sustentável com custos Firebase abaixo de $100/mês. Sem investimento externo, operacional.

**Cenário otimista (18 meses):** Um vídeo viral no TikTok ou um "use case" emocional compartilhado em larga escala (carta de pai para filho, carta de noiva, carta de quem migrou) pode gerar 50K–200K installs em semanas. O app está tecnicamente preparado para isso.

**Risco principal:** retention. Se o D7 ficar abaixo de 15%, o produto não vai crescer organicamente. O loop emocional (escrever carta → esperar → abrir → responder → novo loop) é o que vai fazer ou quebrar a retenção. Resposta à carta é, sem dúvida, a feature mais importante do roadmap.

---

## 6. Onde melhorar

### Experiência do usuário (ordem de prioridade)

**1. Onboarding** — conforme dito: uma única ação, nada mais na primeira sessão.

**2. Resposta à carta** — sem isso, a emoção da abertura não vira retenção. É o feature mais importante do roadmap.

**3. Rascunho automático** — usuário escreve 3 parágrafos, telefone toca, fecha o app, perde tudo. Isso gera abandono e raiva. SharedPreferences é implementação de 2 horas.

**4. Preview antes de selar** — "Você vai enviar esta carta para [nome] para abrir em [data]. Confirmar?" Parece óbvio mas muita gente vai sellar por engano.

**5. Follow Request para conta privada** — atualmente qualquer pessoa segue uma conta privada sem pedir permissão. Isso vai gerar reclamações assim que o app tiver usuários reais.

**6. Feed visual de envelope** — o feed atual parece um feed de posts genérico. Se cada item parecesse um envelope que se abre ao rolar, seria imediatamente reconhecível e diferente. É um trabalho de UI mas de alto impacto visual.

**7. Salvar carta do feed** — usuários vão querer guardar cartas bonitas de pessoas que seguem. Sem bookmark, o conteúdo some.

### Técnico (ordem de prioridade)

**1. Firebase App Check** — sem isso, qualquer pessoa pode chamar suas Cloud Functions diretamente e gerar custo. Implementar antes do lançamento público.

**2. Data mínima de 30 dias para cápsulas** — cápsula para amanhã não tem peso emocional. Uma validação simples no DatePicker resolve isso.

**3. Card compartilhável ao enviar** — "Selei uma carta 🦉" como Stories card. Cada carta enviada vira um anúncio orgânico. É marketing de produto embutido no fluxo principal.

**4. Silenciar conta** — só existe bloquear. Silenciar é o comportamento mais comum no Instagram para conteúdo que incomoda sem merecer bloqueio.

### Negócio

**1. Landing page para destinatário sem conta** — quando alguém recebe o link de uma carta e não tem o app, deve ver uma prévia bloqueada que convida ao cadastro. Hoje o não-usuário não tem incentivo claro para criar conta. Esse é o maior funil de conversão orgânico do produto.

**2. Abertura da empresa (Delaware)** — só fazer quando o app lançar. Por enquanto não há urgência, mas tenha isso na agenda para o mês 3.

**3. Revisão de advogado** — os Termos estão bem elaborados, mas a cláusula de encerramento de serviço e a questão de dados de terceiros (destinatários) merecem revisão profissional antes de escala.

---

## 7. Estratégia de marketing

### Premissa fundamental

O Whenote não se vende com argumentos racionais. Ele se vende com emoção. "É um app de cartas temporizadas" é uma descrição fria que não motiva ninguém. "Imagine receber uma carta de você mesmo de 5 anos atrás" — isso faz alguém parar de rolar o feed.

Toda a comunicação precisa começar com a emoção, não com a feature.

### Canal 1 — Conteúdo orgânico (custo zero, alto retorno)

**Instagram Reels e TikTok — prioridade máxima**

O formato de vídeo curto (15–60s) é o único canal orgânico que ainda tem alcance sem pagar. O vídeo do CapCut que você está editando é o começo. Estratégia de conteúdo:

- **Série "E se você recebesse":** "E se você recebesse uma carta da sua versão de 10 anos atrás?" — narração emocional + demo do app
- **Casos de uso reais:** carta de mãe para filho no dia do aniversário de 18 anos; carta de noiva para o marido para abrir no 1 ano de casamento; carta de amigo para amigo para abrir quando a saudade bater
- **Bastidores do produto:** "Construindo um app de cartas" — conteúdo de build-in-public funciona bem no Brasil tech
- **UGC simulado** (nos primeiros meses antes de ter usuários reais): peçam a amigos para gravar reações ao abrir uma carta

Frequência: 3–4 posts por semana no início. Qualidade > quantidade.

**WhatsApp e grupos**

O Brasil é um país de WhatsApp. Grupos temáticos (noivas, casais, pais de bebês, diáspora brasileira no exterior) têm alto engajamento emocional. Compartilhe o app nesses grupos com mensagem pessoal, não spam.

### Canal 2 — Seeding com criadores (mês 2–3)

Não procure influenciadores grandes. Procure micro-criadores (10K–100K seguidores) que falam de:
- Relacionamentos e amor
- Desenvolvimento pessoal e journaling
- Saudade e distância (emigrantes brasileiros)
- Casamentos e aniversários

Abordagem: contato direto, produto grátis (sem pagamento ainda), storytelling pessoal. "Temos um app de cartas para o futuro. Queremos que você escreva uma carta para a sua versão de 5 anos. Se gostar, compartilhe."

### Canal 3 — Relações públicas (mês 3)

Quando estiver na App Store, buscar cobertura em:
- **Startups.com.br / Startups Brasil** — imprensa tech nacional
- **Canaltech / TecMundo** — revisão de app
- **Proxxima / Meio & Mensagem** — ângulo de comunicação emocional
- Email de imprensa: história dos founders, caso de uso emocional, diferencial técnico

### Canal 4 — Tráfego pago (mês 3–4, pós validação orgânica)

Somente depois de ter:
- Taxa de ativação > 40% (usuário cria conta + envia 1 carta)
- D7 retention > 15%
- Pelo menos 1 criativo orgânico com engajamento acima da média (indicador do que funciona)

Plataformas por ordem de prioridade:
1. **Meta Ads (Instagram/Facebook)** — melhor para público 25–45 BR, targeting por interesse emocional
2. **TikTok Ads** — melhor para público 18–28, mas CTR mais volátil
3. **Google UAC** — só quando tiver dados de conversão para otimizar

Formatos que funcionam para apps emocionais:
- Vídeo curto (15s) com hook emocional nos 3 primeiros segundos
- História de caso de uso específico (carta de aniversário, carta de emigrante)
- Nunca: "Baixe o app agora" como CTA principal — a conversão vem da emoção, não do comando

Orçamento inicial sugerido: R$ 500–1.000/mês para testes. Medir CPInstall e taxa de ativação (conta criada + carta enviada). Só escalar se o CPI estiver abaixo de R$ 8–12 com ativação acima de 30%.

---

## 8. Tráfego pago — o que consigo fazer com acesso ao computador

**Resposta direta:** Sim, consigo configurar e operar campanhas de tráfego pago com acesso ao seu computador via Computer Use. Mas existem limitações importantes e honestas que você precisa saber.

### O que consigo fazer

- Criar e configurar contas no **Meta Ads Manager** (Facebook/Instagram)
- Criar campanhas, conjuntos de anúncios, anúncios
- Fazer upload de criativos (vídeos, imagens)
- Configurar públicos (interesses, lookalike, retargeting)
- Definir orçamento, lances, datas de veiculação
- Acompanhar métricas (CPM, CTR, CPI, CPA) e ajustar campanhas
- Criar pixel do Meta e configurar eventos de conversão
- Fazer o mesmo no **Google Ads** (UAC para apps)
- Criar e otimizar criativos de texto
- Analisar relatórios e recomendar ajustes

### O que não consigo fazer (por razões de segurança)

- Inserir informações de cartão de crédito ou dados bancários — esses campos precisam ser preenchidos por você
- Confirmar pagamentos ou transações financeiras
- Criar contas do zero (Meta Business Manager, Google Ads) — a criação inicial requer seu login pessoal

### Como funcionaria na prática

Você me dá acesso visual ao computador (via Computer Use), eu navego no Meta Ads Manager ou Google Ads, configuro tudo, e peço para você confirmar/inserir dados de pagamento quando necessário. Para ações que requerem autenticação (login), você faz o login e eu assumo a partir daí.

É uma forma eficiente de trabalhar. Posso cuidar da operação técnica das campanhas, você cuida das decisões financeiras.

**Recomendação:** só ativar tráfego pago depois de ter os dados de retenção orgânica. Gastar em ads antes de ter retention é queimar dinheiro — os usuários entram, não se engajam e saem.

---

## 9. Avaliação final — profissional, sincera e imparcial

### Nota geral: 7.5/10

Nenhum produto é perfeito, e a honestidade aqui serve melhor do que elogio fácil.

**O que coloca na nota alta:**
O produto tem alma. É tecnicamente sólido para o estágio. O conceito de "carta temporizada + rede social emocional" não existe no mercado com essa execução. A decisão de fazer multilíngue, legal completo e Clean Architecture desde o início mostra maturidade que a maioria dos indie developers não tem.

**O que tira pontos:**
O onboarding não está pronto para usuário real ainda. A feature mais importante de retenção (resposta à carta) não existe. O feed visualmente parece genérico demais para um produto que se propõe emocional. E o marketing ainda não foi testado — nenhum produto vale o que diz até alguém fora do círculo de desenvolvimento usar e gostar.

**Comparação honesta com concorrentes:**
Não existe um concorrente direto com exatamente essa proposta. O Futureme.org (cartas de email para o futuro) tem 10M+ usuários mas é 2006 e não tem social. O TimeHop focou só em memórias. O Capsule.app tentou o conceito mas não sobreviveu. O Whenote está melhor posicionado do que todos eles em termos de produto — mas posicionamento de produto não é distribuição. A batalha vai ser ganhar usuários.

**O maior risco não é técnico.** É descoberta e retenção inicial. Um produto emocional precisa de um veículo emocional para crescer — e isso é conteúdo, não código. Invistam tanto em conteúdo quanto investiram em código.

**O maior ativo que vocês têm:** a coruja, a animação de abertura, o ritual emocional. Isso é marca. Isso é o que nenhum clone vai conseguir copiar sem parecer cópia. Protejam essa identidade visual em tudo que fizerem.

**Resumo executivo para tomar uma decisão agora:**
O app está pronto para ser mostrado para amigos próximos. Simplifique o onboarding (1–2 semanas), tirem os screenshots do iOS, e façam o soft launch com 10–15 pessoas de confiança. Coletem feedback real. Implementem resposta à carta antes de qualquer divulgação em escala. Com isso feito, estão prontos para lançar nas lojas.

---

*Auditoria realizada por Claude (Anthropic) — 02/05/2026*
*Baseada em: revisão completa de código-fonte, commits Git (cdd80d3), planning docs (CHANGELOG, MVP_CHECKLIST, PRODUCTION, AUDIT_ABRIL_2026, MONETIZACAO, BUSINESS, ARCHITECTURE)*
