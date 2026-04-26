# Aniversário + Notificação para Seguidores

> **Status:** Ideia validada — pode entrar antes do lançamento (Semana 1–2)
> **Complexidade estimada:** Baixa (1–2 semanas de desenvolvimento)
> **Quando fazer:** Semana 1 pós-bloqueadores, junto com onboarding

---

## Visão geral

O usuário informa sua data de aniversário no cadastro ou no perfil. Quando a data se aproxima, os seguidores recebem uma notificação convidando-os a **escrever uma carta** que o aniversariante só vai ler **daqui a 1 ano** — no próximo aniversário. O ciclo se repete automaticamente todo ano.

O diferencial em relação ao Facebook: não é "parabéns no mural". É um presente emocional com data de abertura — a pessoa recebe a carta no seu próximo aniversário, não no dia.

---

## Fluxo de uso (UX)

### No cadastro / perfil
- Campo opcional: **Data de aniversário**
- Configuração de privacidade com 3 opções:
  - `Público` → qualquer seguidor vê e pode escrever
  - `Apenas mútuos` → só quem eu sigo de volta
  - `Privado` → só eu sei (não gera notificações)

---

### Para quem recebe a notificação (seguidor)

**3 dias antes do aniversário:**
> *"🎂 Daqui a 3 dias é aniversário de @diego.*
> *Que tal escrever uma carta que ele só vai ler no próximo aniversário?"*

Tap na notificação → abre a tela de escrita de carta com:
- Destinatário pré-preenchido: @diego
- Data de abertura pré-preenchida: aniversário do próximo ano
- Campo de texto livre

**No dia do aniversário (se ainda não escreveu):**
> *"🎂 Hoje é aniversário de @diego. Ainda dá tempo de enviar uma carta! ✉️"*

---

### Para o aniversariante

**No dia do aniversário:**
> *"🎉 Feliz aniversário, Diego!*
> *N pessoas te enviaram cartas. Elas abrem no seu próximo aniversário."*

Tap → tela especial mostrando os envelopes lacrados com a contagem regressiva.

**No próximo aniversário (quando as cartas abrem):**
> *"🎂 Feliz aniversário! Suas cartas do ano passado estão prontas para abrir."*

Tap → cartas reveladas uma a uma, com a data que foram escritas.

---

### O vice-versa — carta para si mesmo

Quando o aniversário chega, além das cartas recebidas, o app exibe uma tela especial:

> *"É o seu dia. Que tal deixar uma mensagem para o Diego de daqui a 1 ano?"*

O usuário escreve para si mesmo. A carta abre no próximo aniversário, junto com as cartas dos outros. Cria o hábito de reflexão anual: *quem você era no último aniversário, o que mudou.*

---

## Por que é diferente do Facebook

| Facebook "Aniversário hoje" | Whenote Aniversário |
|---|---|
| Notificação de engajamento superficial | Convite para criar algo significativo |
| "Parabéns" publicado no mural (público) | Carta privada e pessoal |
| A pessoa vê no mesmo dia | A pessoa só vê no próximo aniversário |
| Esquecido em horas | Guardado e antecipado por 1 ano |
| Não gera receita | Pode ser monetizado (carta premium com foto) |

---

## Regras de negócio

- Notificação de 3 dias antes: apenas para seguidores com privacidade `Público` ou `Mútuos`
- Máximo 1 notificação de lembrete por pessoa (não spamear)
- O aniversariante não vê quem escreveu até a abertura
- Se o seguidor não tiver o app instalado, pode receber e-mail (configurável)
- A carta de aniversário segue as mesmas regras de moderação das demais
- Usuário pode desativar a feature completamente nas configurações

---

## Dados necessários no Firestore

```
users/{uid}:
  - birthdate: Timestamp (apenas dia e mês visíveis para seguidores)
  - birthdatePrivacy: "public" | "mutuals" | "private"

letters/{id}:
  - type: "birthday" (novo tipo, além de "capsule" e "feed")
  - opensAt: Timestamp (próximo aniversário do destinatário)
```

Cloud Function agendada (cron diário):
- Verificar usuários com aniversário em 3 dias
- Enviar notificação push (FCM) para os seguidores elegíveis
- Verificar usuários com aniversário hoje → notificação de abertura de cartas

---

## Monetização indireta

Esta feature não cobra diretamente, mas:
- **Retém o usuário** por pelo menos 1 ano (ele quer ver as cartas no próximo aniversário)
- **Traz novos usuários:** o seguidor que recebe a notificação pode não ter o app → download
- **Ativa o ciclo viral:** quem recebe cartas de aniversário vai querer escrever para outros
- Carta de aniversário com **foto** pode ser uma funcionalidade premium (Carta Premium R$ 3,99)

---

## Perguntas a validar antes de construir

1. **Armazenar aniversário sem o ano?** Para preservar a idade, guardar só `MM-DD`, não o ano completo.
2. **O que acontece se o usuário deletar a conta antes da abertura?** As cartas enviadas a ele ficam arquivadas para o remetente.
3. **Limite de cartas de aniversário?** No free: receber ilimitado, enviar ilimitado (texto). Premium: com foto.
4. **Push para usuário que tem o app mas não usa há meses?** Oportunidade de reativação — sim, enviar.

---

## Roadmap sugerido

| Passo | Entrega | Tempo estimado |
|-------|---------|----------------|
| 1 | Campo `birthdate` + privacidade no perfil/cadastro | 2 dias |
| 2 | Carta com tipo `birthday` e data de abertura automática | 2 dias |
| 3 | Cloud Function cron: detectar aniversários e enviar push | 3 dias |
| 4 | Tela especial de aniversário (envelopes lacrados + self-letter) | 3 dias |
| 5 | Testes + edge cases (privacidade, sem seguidores, etc.) | 2 dias |

**Total estimado:** 10–12 dias de desenvolvimento.
