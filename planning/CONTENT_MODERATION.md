# OpenWhen — Política de Moderação de Conteúdo
### Abril 2026 — Decisão de produto e implementação

---

## Filosofia

O OpenWhen existe para conectar pessoas com amor, superação e conexão genuína.
Uma carta temporizada tem um poder único — ela chega num momento específico,
quando a pessoa pode estar vulnerável, e o remetente não sabe o estado emocional
do destinatário naquele momento.

Uma carta agressiva ou cruel que abre no aniversário de alguém, ou num momento
difícil, pode causar dano real — incluindo consequências graves para pessoas
em estado emocional vulnerável.

**Posicionamento:** O OpenWhen é o app que só permite amor, superação e conexão.
*"O único app onde você só pode enviar amor."*

---

## O Que Queremos Proteger

✅ Permitido — expressão humana genuína:
- Tristeza, saudade, despedida
- Dificuldades e sofrimento em contexto de apoio
- Críticas construtivas com amor
- Emoções difíceis mas honestas
- "Sei que você está sofrendo mas não está sozinho"
- "Essa fase difícil vai passar"

❌ Bloqueado — dano emocional intencional:
- Agressão e humilhação direcionada
- Ameaças de qualquer natureza
- Conteúdo que denigre ou diminui o destinatário
- Mensagens que possam induzir pensamentos autodestrutivos
- "Você é um fracasso"
- "Ninguém te ama"
- "Você deveria desaparecer"

---

## Como Funciona — Duas Camadas

### Camada 1 — Visual em tempo real (cliente Flutter)
**Responsável:** Diego
**Arquivo:** `lib/features/letters/presentation/screens/write_letter_screen.dart`

Enquanto a pessoa escreve:
- Lista de palavras claramente ofensivas em pt-BR, en e es
- Se detectar → sublinha suavemente em vermelho
- Aviso gentil embaixo do campo: *"O OpenWhen existe para conectar com amor 🦉"*
- Botão enviar bloqueado até corrigir
- Não interrompe o fluxo — só um lembrete gentil

### Camada 2 — Análise por IA no momento do envio (servidor)
**Responsável:** Yuri
**Arquivo:** `functions/src/moderation/moderate_content.ts`

Quando a pessoa clica em Enviar, antes de salvar no Firestore:

**Prompt para OpenAI:**
**Regras de decisão:**
| Score | Ação |
|-------|------|
| 1 a 4 | Envia normalmente |
| 5 a 7 | Aviso gentil: "Sua carta tem um tom que pode machucar. Quer revisar antes de selar?" — pessoa decide |
| 8 a 10 | Bloqueado: "O OpenWhen existe para conectar com amor e superação. Esta carta não pode ser enviada. 🦉" |

---

## Mensagens para o Usuário

**Aviso em tempo real (score 1-4, palavra detectada):**
> "O OpenWhen existe para conectar com amor 🦉"

**Aviso de revisão (score 5-7):**
> "Sua carta tem um tom que pode machucar quem recebe.
> Quer revisar antes de selar? O momento em que essa carta
> vai ser lida pode ser delicado."
> [Revisar] [Enviar mesmo assim]

**Bloqueio (score 8-10):**
> "Esta carta não pode ser enviada.
> O OpenWhen existe para conectar pessoas com amor,
> superação e conexão genuína.
> Palavras que machucam não têm lugar aqui. 🦉"

---

## O Que NÃO Fazer

- Não bloquear tristeza, saudade ou emoções difíceis
- Não bloquear palavras fora de contexto
- Não ser agressivo nas mensagens de aviso
- Não punir o usuário — educar com gentileza
- Não moderar cartas privadas sem o consentimento implícito do envio

---

## Contexto de Saúde Mental

Pessoas em estado emocional vulnerável podem receber cartas em momentos
críticos. O sistema de moderação é uma camada de proteção real, não apenas
uma feature de produto.

Em casos extremos de conteúdo que induza automutilação ou pensamentos
suicidas, o sistema deve:
1. Bloquear o envio
2. Mostrar recursos de apoio ao remetente
3. Registrar o incidente para revisão (sem expor o conteúdo)

---

## Implementação — Próximos Passos

- [ ] Diego: camada visual em tempo real no write_letter_screen.dart
- [ ] Yuri: integrar análise de score na Cloud Function moderateContent
- [ ] Yuri: adicionar campo contentRiskScore no documento da carta
- [ ] Yuri: bloquear salvamento no Firestore se score >= 8
- [ ] Diego + Yuri: definir lista de palavras para camada 1 (pt-BR, en, es)
- [ ] Revisar mensagens com nativo de português e inglês

---

## Por Que Isso Importa Para o Negócio

1. Diferencial único — nenhum app de mensagens tem essa política
2. Posicionamento premium — "O app que só permite amor"
3. Proteção legal — reduz responsabilidade por dano causado pela plataforma
4. Confiança dos usuários — pais confiam em deixar filhos usar
5. App Store — Apple valoriza apps que protegem bem-estar dos usuários

---
*Decisão tomada por Diego Rocha — CEO & Founder OpenWhen*
*Abril 2026*
