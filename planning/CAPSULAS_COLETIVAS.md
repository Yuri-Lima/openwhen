# Cápsulas Coletivas — Grupos e Comunidades

> **Status:** ✅ MVP implementado (singleAuthor mode — convites, participantUids, cofre com streams fundidas). Pendente: contribuições pré-selo (multiContributor).
> **Complexidade estimada (visão completa):** Alta (6–10 semanas de desenvolvimento)
> **Quando fazer (multiContributor):** Mês 3+ após lançamento, quando base de usuários ativa > 1.000

---

## Visão geral

Um usuário (o "admin") cria um **Grupo** com nome, foto de capa e uma data de abertura. Convida outras pessoas pelo link ou username. Cada membro contribui com cartas e fotos até a data fechar. Na data definida, tudo abre simultaneamente para todos — um momento coletivo e emocional.

O diferencial é o componente social: cápsulas individuais dependem de 2 pessoas. Cápsulas coletivas dependem de N pessoas, criando comprometimento mútuo e tração orgânica de aquisição.

---

## Tipos de grupo previstos

| Tipo | Exemplo | Prazo típico |
|------|---------|--------------|
| Turma escolar | "3º Ano B 2025 – EEEM São Paulo" | 5–10 anos |
| Família | "Natal 2025 – Família Rocha" | 1 ano |
| Grupo de amigos | "Viagem Cancun 2025" | 1–2 anos |
| Empresa / time | "Time de Produto Q1 2026" | 6–12 meses |
| Casal | "Nosso primeiro ano juntos" | 1 ano |

---

## Fluxo de uso (UX)

### Criação do grupo (admin)
1. Tap em "+ Novo Grupo"
2. Definir: nome, foto de capa, tipo (escola / família / amigos / empresa)
3. Definir data de abertura (mínimo 30 dias no futuro)
4. Configurar privacidade: fechado (convite) ou público (link compartilhável)
5. Compartilhar link de convite

### Participação (membros)
1. Entrar pelo link ou aceitar convite
2. Ver o feed do grupo: quem já contribuiu (sem revelar o conteúdo)
3. Adicionar carta, foto ou vídeo curto
4. Editar ou deletar até a data de fechamento
5. Receber notificação quando a cápsula abre

### Abertura coletiva
1. Na data definida, todos recebem uma notificação push: *"A cápsula [nome] abriu! 🎉"*
2. Feed especial da abertura: cartas e fotos reveladas em sequência
3. Possibilidade de reagir e comentar após a abertura

---

## Regras de negócio importantes

- **Admin** pode: editar grupo, remover membros, cancelar ou adiar data (com notificação)
- **Membro** pode: adicionar e editar seu próprio conteúdo, sair do grupo (conteúdo permanece)
- **Conteúdo** não é visível para ninguém antes da data de abertura — nem para o admin
- Se o grupo for cancelado antes da abertura, cada membro recebe seu conteúdo por e-mail
- Limite de membros: 10 no free, 50 no premium

---

## Perguntas em aberto para validar antes de construir

1. **Moderação:** e se um membro colocar conteúdo ofensivo que só aparece na abertura?
   → Solução possível: moderação automática no upload + flag para o admin.

2. **Saída de membro:** o conteúdo de quem sai aparece na abertura?
   → Proposta: sim, mas anonimizado ("Membro removido").

3. **Privacidade forte:** grupos familiares com crianças precisam de controle extra de quem pode entrar.
   → Grupos fechados por padrão; link com expiração.

4. **Notificação de engajamento:** avisar membros que ainda não contribuíram próximo à data?
   → Sim — notificação 7 dias antes do fechamento.

---

## Monetização

**Modelo:** Admin paga, membros entram de graça.

| Plano | Preço | Limites |
|-------|-------|---------|
| Free | R$ 0 | 1 grupo ativo, até 10 membros, só texto |
| Grupo Premium (único) | R$ 14,99 | 1 grupo, até 50 membros, fotos e vídeos |
| Grupo Premium (mensal) | R$ 4,99/mês | Grupos ilimitados, 50 membros cada, mídia |

**Por que o admin paga:** ele é o motivador do grupo; é quem tem o incentivo mais forte para a cápsula funcionar.

---

## Por que faz sentido para o Whenote

- **Aquisição orgânica:** uma turma de 30 alunos = 30 downloads mínimos
- **Engajamento profundo:** o usuário não pode deletar o app ou vai perder a cápsula do grupo
- **Marketing gratuito:** screenshots da abertura coletiva viralizam no Instagram/WhatsApp
- **Monetização direta:** admin tem disposição a pagar pelo momento emocional

---

## Referências de mercado

- **Google Photos — Shared Albums:** compartilhamento em tempo real, sem o componente "cápsula"
- **WhatsApp Groups:** sem cápsula, sem data de abertura, sem emocionalidade
- **Capsule.me (descontinuado):** havia tentado cápsulas coletivas, mas falhou por falta de tração inicial
- **Diferencial Whenote:** o bloqueio temporal + a narrativa emocional não existe em nenhum desses

---

## Dependências técnicas

- Sistema de grupos no Firestore (subcoleções: `groups/{id}/members`, `groups/{id}/items`)
- Deep links para convite (`whenote.app/join/{groupId}`)
- Permissões por papel: `admin`, `member`
- Job agendado (Cloud Function) para abertura automática na data
- Moderação de mídia em upload (extensão do sistema já existente)
- Notificações push por grupo (FCM topics)

---

## Roadmap sugerido

| Fase | Entrega | Prazo estimado |
|------|---------|----------------|
| Fase 0 | Definir modelo de dados e regras Firestore | 1 semana |
| Fase 1 | Criar grupo + convite por link | 2 semanas |
| Fase 2 | Feed do grupo + adicionar conteúdo | 2 semanas |
| Fase 3 | Abertura automática + notificação coletiva | 1 semana |
| Fase 4 | Moderação + privacidade avançada | 1 semana |
| Fase 5 | Monetização + plano premium de grupo | 1 semana |

**Total estimado:** 8–10 semanas com 1 desenvolvedor dedicado.
