# Política de Retenção de Dados & Deleção de Conta — Whenote

> **Última atualização:** 2026-04-10
> **Legislações aplicáveis:** GDPR (UE), LGPD (Brasil), CCPA/CPRA (Califórnia), COPPA (EUA — idade mínima 13+)
> **Escopo:** Global (app disponível mundialmente)
>
> **Nota:** Os períodos de retenção documentados aqui estão refletidos na Política de Privacidade do app (Seção 9 — "Retenção de Dados") e na página web pública (`hosting/public/privacy.html`). Ver também [`LEGAL.md`](LEGAL.md) (secção 1).

---

## 1. Dados Coletados por Categoria

### 1.1 Dados de Identificação (PII)
| Campo | Coleção Firestore | Obrigatório? |
|-------|-------------------|-------------|
| Nome / displayName | `users/{uid}` | Sim |
| Username | `users/{uid}` | Sim |
| Email | `users/{uid}` + Firebase Auth | Sim |
| Foto de perfil (URL) | `users/{uid}` → Storage `avatars/{uid}.jpg` | Não |
| Bio | `users/{uid}` | Não |
| País | `users/{uid}` | Não |
| Idioma preferido | `users/{uid}` | Sim (auto) |

### 1.2 Dados de Localização (GPS)
| Campo | Coleção | Obrigatório? |
|-------|---------|-------------|
| Coordenadas do remetente (lat/lng) | `letters/{id}.senderLocation` | **Opcional** (opt-in por carta) |
| Coordenadas do remetente | `capsules/{id}.senderLocation` | **Opcional** |
| Proximidade para abrir | `letters/{id}.openRequiresProximity` | **Opcional** |

> **GDPR/LGPD:** Localização é dado sensível. O consentimento já é granular (por carta), o que é adequado. Recomendação: adicionar texto explicativo no momento da captura.

### 1.3 Conteúdo Gerado pelo Usuário (UGC)
| Tipo | Coleção / Storage | Campos principais |
|------|-------------------|-------------------|
| Cartas (texto) | `letters/{id}` | title, message, emotionalState |
| Cartas (manuscritas) | Storage: `handwritten/{uid}_{ts}.jpg` | handwrittenImageUrl |
| Cartas (voz) | Storage: `voiceLetters/{uid}_{ts}.m4a` | voiceUrl |
| Cápsulas | `capsules/{id}` | title, message, theme, photos |
| Fotos de cápsulas | Storage: `capsulePhotos/{uid}_{ts}.jpg` | photos[] |
| Comentários | `comments/{id}` | message, userUid, letterId |
| Curtidas | `likes/{id}` | userUid, letterId |

### 1.4 Dados Sociais
| Tipo | Coleção | Campos |
|------|---------|--------|
| Seguidores/Seguindo | `follows/{id}` | followerUid, followingUid |
| Bloqueios | `blocks/{id}` | blockedBy, blockedUid |

### 1.5 Dados de Billing (Stripe)
| Campo | Coleção |
|-------|---------|
| stripeCustomerId | `users/{uid}` |
| stripeSubscriptionId | `users/{uid}` |
| subscriptionTier | `users/{uid}` |
| subscriptionStatus | `users/{uid}` |

> **Nota:** Os dados de pagamento (cartão, etc.) ficam no Stripe, não no Firestore. Na deleção, cancelar assinatura via Stripe API e opcionalmente deletar o Customer no Stripe.

### 1.6 Dados Técnicos / Dispositivo
| Campo | Coleção |
|-------|---------|
| FCM Token | `users/{uid}.fcmToken` |
| Plataforma (feedback) | `feedback/{id}.platform` |
| App locale | `feedback/{id}.appLocale` |

### 1.7 Dados de Moderação & Feedback
| Tipo | Coleção | Relação com UID |
|------|---------|-----------------|
| Reports (denúncias) | `reports/{id}` | reporterUid |
| Feedback do produto | `feedback/{id}` | uid |
| Incidentes moderação | `moderationIncidents/{id}` | Admin-only |
| Reviews moderação | `moderationReviews/{id}` | Admin-only |

### 1.8 Gamificação
| Tipo | Coleção |
|------|---------|
| Badges desbloqueados | `users/{uid}/badgeUnlocks/{badgeId}` |
| Notificações in-app | `users/{uid}/notifications/{notifId}` |

---

## 2. Requisitos Legais

### 2.1 GDPR (Regulamento Geral de Proteção de Dados — UE)
- **Art. 17 — Direito ao apagamento ("right to be forgotten"):** O usuário pode solicitar deleção de todos os seus dados pessoais.
- **Art. 20 — Portabilidade:** O usuário pode solicitar exportação dos seus dados em formato legível por máquina.
- **Art. 7 — Consentimento:** Deve ser livre, específico, informado e inequívoco.
- **Art. 13/14 — Transparência:** O usuário deve saber quais dados são coletados e por quê.
- **Prazo de execução:** 30 dias corridos para atender solicitação de deleção/exportação (Art. 12 §3).

### 2.2 LGPD (Lei Geral de Proteção de Dados — Brasil)
- **Art. 18 — Direitos do titular:** Confirmação, acesso, correção, anonimização, portabilidade, eliminação.
- **Art. 15 — Término do tratamento:** Dados devem ser eliminados após o fim da finalidade.
- **Art. 8 — Consentimento:** Deve ser fornecido por escrito ou por outro meio que demonstre a manifestação de vontade do titular.
- **Prazo de execução:** 15 dias úteis para atender solicitação de deleção/exportação (ANPD 2019 recomendação).

### 2.3 CCPA/CPRA (California Consumer Privacy Act — Califórnia/EUA)
- **Direito de Saber:** O usuário pode solicitar quais dados pessoais são coletados.
- **Direito de Exclusão:** O usuário pode solicitar deleção dos seus dados pessoais.
- **Direito de Correção:** O usuário pode solicitar correção de dados imprecisos.
- **Opt-out de venda/compartilhamento:** O usuário pode requerer que não vendamos dados (Whenote não vende dados).
- **Prazo de execução:** 45 dias para atender solicitação de deleção/acesso/correção.

### 2.4 COPPA (Children's Online Privacy Protection Act — EUA)
- **Idade mínima:** 13 anos para criar conta sem consentimento parental.
- **Verificação:** Não é obrigatória a verificação de idade com documento, mas deve haver declaração do usuário.
- **Ação necessária:** Checkbox no registro: "Confirmo que tenho 13 anos ou mais."

---

## 3. Fluxo de Deleção de Conta — Proposta

### 3.1 Diálogo de Escolha (antes de deletar)

O usuário deve ver um modal com **duas opções** para o tratamento das suas cartas/cápsulas:

**Opção A — "Excluir Tudo"**
- Deleta todas as cartas enviadas e recebidas
- Deleta todas as cápsulas (próprias e contribuições)
- Deleta comentários, curtidas, follows
- Deleta todos os arquivos no Storage
- Remove o perfil e Auth

**Opção B — "Anonimizar minhas cartas"**
- Mantém as cartas/cápsulas existentes no sistema (para os destinatários)
- Substitui `senderName` por "Usuário removido" / "Deleted user"
- Substitui `senderUid` por string vazia ou placeholder
- Remove `senderLocation`, `handwrittenImageUrl` (se identifica o remetente)
- Mantém `voiceUrl` apenas se o receptor já abriu a carta
- Deleta perfil, follows, comments, likes, badges, notificações
- Remove o Auth

### 3.2 Etapas Técnicas (Cloud Function)

```
deleteUserAccount(uid, mode: 'delete_all' | 'anonymize')
```

**Ordem de execução (atômica via Cloud Function):**

1. **Re-autenticação** — Verificar que o token é recente (< 5 min) no client-side antes de chamar
2. **Cancelar Stripe** — Se `stripeCustomerId` existe, cancelar assinatura via Stripe API
3. **Processar cartas enviadas** (`letters` where `senderUid == uid`):
   - `delete_all`: deletar documentos + Storage files
   - `anonymize`: atualizar `senderName` → "Deleted user", limpar `senderUid`, remover `senderLocation`
4. **Processar cartas recebidas** (`letters` where `receiverUid == uid`):
   - `delete_all`: deletar documentos + Storage files
   - `anonymize`: atualizar `receiverName` → "Deleted user", limpar `receiverUid`
5. **Processar cápsulas** (`capsules` where `senderUid == uid` OR `participantUids` contains uid):
   - `delete_all`: deletar documentos + Storage files (se é o único participante); se coletiva, remover apenas a contribuição
   - `anonymize`: substituir nome nos `participantNames`, remover uid dos `participantUids`
6. **Deletar comentários** (`comments` where `userUid == uid`)
7. **Deletar curtidas** (`likes` where `userUid == uid`) — atualizar `likeCount` nas cartas afetadas
8. **Deletar follows** (`follows` where `followerUid == uid` OR `followingUid == uid`) — decrementar counters
9. **Deletar blocks** (`blocks` where `blockedBy == uid`)
10. **Deletar reports** (`reports` where `reporterUid == uid`)
11. **Deletar feedback** (`feedback` where `uid == uid`)
12. **Deletar subcoleções** (`users/{uid}/badgeUnlocks/*`, `users/{uid}/notifications/*`)
13. **Deletar Storage** — `avatars/{uid}.jpg` + quaisquer arquivos em `handwritten/`, `voiceLetters/`, `capsulePhotos/` com prefixo uid
14. **Deletar documento do usuário** (`users/{uid}`)
15. **Deletar Firebase Auth** — `admin.auth().deleteUser(uid)`
16. **Log de auditoria** — Gravar registro da deleção (sem PII) para compliance

### 3.3 Período de Carência (Grace Period)

**Recomendação:** 30 dias de "soft delete" antes da deleção permanente.

- Ao solicitar deleção, marcar `users/{uid}.deletionRequestedAt = timestamp`
- Desativar a conta imediatamente (bloquear login)
- Agendar Cloud Function para execução em 30 dias
- Enviar email de confirmação com link para cancelar
- Se cancelar dentro de 30 dias: reativar conta
- Se não cancelar: executar deleção permanente

> **GDPR Art. 17:** permite prazo razoável. 30 dias é aceito.
> **LGPD Art. 18:** eliminação deve ser feita "em prazo razoável".

---

## 4. Checkboxes e Consentimentos Necessários

### 4.1 No Registro (Sign Up)
- [ ] **Termos de Uso:** "Li e aceito os [Termos de Uso] e a [Política de Privacidade]" — **Obrigatório**
- [ ] **Idade mínima (COPPA):** "Confirmo que tenho 13 anos ou mais" — **Obrigatório**

### 4.2 No Envio de Carta (quando GPS ativo)
- Consentimento já é implícito pela ação do usuário (opt-in por carta). ✅ Adequado.
- **Recomendação:** Adicionar tooltip/texto: "Sua localização será salva com esta carta."

### 4.3 Na Deleção de Conta
- [ ] **Confirmação:** "Entendo que esta ação é irreversível após 30 dias"
- Seleção: "Excluir Tudo" vs "Anonimizar minhas cartas"

### 4.4 Consentimento de Marketing (se aplicável no futuro)
- [ ] "Aceito receber emails com novidades do Whenote" — **Opcional**, desmarcado por padrão

---

## 5. Exportação de Dados (Portabilidade)

**GDPR Art. 20 / LGPD Art. 18 V:** O usuário tem direito a receber seus dados em formato legível.

### Dados a exportar:
- Perfil (JSON)
- Cartas enviadas (JSON + anexos)
- Cápsulas criadas (JSON + fotos)
- Comentários (JSON)
- Curtidas (JSON)
- Lista de seguidores/seguindo (JSON)
- Badges (JSON)

### Formato:
- Arquivo ZIP contendo JSONs + media files
- Gerado via Cloud Function
- Download disponível por 7 dias após geração
- **Tela:** botão "Exportar meus dados" em Settings (já existe estrutura de export)

---

## 6. Retenção de Dados por Categoria

| Dado | Retenção | Justificativa |
|------|----------|---------------|
| Perfil do usuário | Até deleção da conta | Necessário para funcionamento |
| Cartas/Cápsulas | Até deleção ou anonimização | Conteúdo central do app |
| Comentários | Até deleção da conta/comentário | Engajamento |
| Curtidas | Até deleção da conta | Engajamento |
| Follows | Até deleção da conta/unfollow | Social graph |
| FCM Token | Sobrescrito a cada login; deletado com conta | Push notifications |
| Localização (GPS) | Armazenada apenas quando opt-in; deletada/anonimizada com conta | Feature opt-in |
| Dados de billing | Cancelados no Stripe na deleção | Assinatura |
| Reports | 90 dias após resolução, depois anonimizados | Moderação e segurança | ✅ `anonymizeResolvedReports` (04:00 UTC) |
| Feedback | 1 ano após envio, depois anonimizado | Melhoria do produto | ✅ `anonymizeOldFeedback` (05:00 UTC) |
| Logs de moderação | 2 anos, depois eliminados | Obrigação legal/compliance | ✅ `purgeOldModerationLogs` (04:30 UTC) |
| Analytics (Firebase) | Conforme política do Firebase (14 meses padrão) | Métricas agregadas |
| Logs de auditoria (deleção) | 3 anos (sem PII — apenas uid hash + timestamp) | Prova de compliance |

---

## 7. Implementação — Prioridades

### P0 (Crítico — antes do launch público)
1. ✅ Checkbox de idade mínima (13+) no registro
2. ✅ Link para Termos de Uso e Política de Privacidade no registro
3. ✅ Cloud Function `deleteUserAccount` com re-auth + limpeza completa
4. ✅ Corrigir fluxo de deleção no client (re-auth, try-catch, diálogo de escolha)
5. ✅ Exportação de dados completa (JSON + signed URLs, server-side) — `functions/src/export_user_data.ts` (testar)

### P1 (Importante — primeiros 30 dias)
6. ✅ Período de carência de 15 dias corridos (soft delete) — `functions/src/request_deletion.ts` + `scheduled_deletion.ts` (testar)
7. ✅ Email de confirmação de deleção — SendGrid via `request_deletion.ts` (testar)
8. ✅ Preservação de cartas/cápsulas locked com openDate futuro — `delete_account.ts` (testar)
9. 🔲 Tooltip de localização no envio de carta

### P2 (Desejável — roadmap)
10. 🔲 Dashboard de privacidade (ver quais dados estão armazenados)
11. ✅ Retenção automática — `anonymizeResolvedReports` (reports 90 dias) + `purgeOldModerationLogs` (moderation 2 anos) — implementado 02/05/2026

---

## 8. Fluxo Atual de Exclusão — Implementado (12/04/2026)

Todos os problemas anteriores (sem re-auth, sem try-catch, sem cleanup completo) foram corrigidos. O fluxo atual é:

1. **Re-autenticação** via `AccountDeletionService.reauthenticateWithPassword()`
2. **Export automático** server-side via `exportUserData` Cloud Function (JSON + signed URLs, email via SendGrid)
3. **Soft delete** via `requestAccountDeletion` (marca `accountStatus = 'pending_deletion'`, prazo 15 dias corridos)
4. **Sign out** local
5. **Scheduled function** `processScheduledDeletions` (diária, 03:00 UTC) executa a exclusão após o prazo
6. **Cartas/cápsulas locked** com `openDate` futuro são sempre preservadas (anonimizadas), voice removido
7. **Cancelamento** possível durante os 15 dias via `cancelAccountDeletion`

Referências: `settings_screen.dart`, `account_deletion_service.dart`, `deletion_request_service.dart`, `delete_account.ts`, `request_deletion.ts`, `scheduled_deletion.ts`, `export_user_data.ts`

---

## 9. Cloud Functions — Estrutura Atual

| Function | Tipo | Ficheiro | Horário |
|----------|------|----------|---------|
| `deleteUserAccount` | onCall | `delete_account.ts` (callable direto, legado/admin) | — |
| `exportUserData` | onCall | `export_user_data.ts` (export JSON + email) | — |
| `requestAccountDeletion` | onCall | `request_deletion.ts` (soft delete 15 dias) | — |
| `cancelAccountDeletion` | onCall | `request_deletion.ts` (reverter para active) | — |
| `processScheduledDeletions` | onSchedule | `scheduled_deletion.ts` | 03:00 UTC |
| `anonymizeResolvedReports` | onSchedule | `anonymize_resolved_reports.ts` | 04:00 UTC |
| `purgeOldModerationLogs` | onSchedule | `purge_old_moderation_logs.ts` | 04:30 UTC |
| `anonymizeOldFeedback` | onSchedule | `anonymize_old_feedback.ts` | 05:00 UTC |

Lógica core extraída em `executeAccountDeletion()` (reutilizada pelo callable e scheduler).

### 9.1 Scheduled Functions — Custos e Optimizações

As três scheduled functions executam em off-peak (03:00–04:30 UTC) para minimizar conflitos com tráfego de utilizadores.

**`anonymizeResolvedReports`** — Anonimiza reports resolvidos há >90 dias (remove `reporterUid`, `detail`, `resolvedByUid`; mantém metadata estatística).

- **Query de janela temporal (24h):** em vez de ler todos os reports históricos resolvidos há >90 dias (custo que cresce linearmente), a query usa uma janela: reports com `resolvedAt` entre 91 e 90 dias atrás. Isso mantém o número de reads diários constante (~poucos docs/dia) independentemente do volume acumulado.
- **Backfill com `select()` projection:** uma segunda query limitada (`limit(450)`) apanha reports anteriores ao deploy da function. Usa `select("anonymizedAt")` para carregar apenas o campo necessário, minimizando bandwidth. Processa um batch por execução até esgotar.
- **Composite index:** `reports[status ASC, resolvedAt ASC]` em `firestore.indexes.json`.
- **Custo steady-state:** ~$0.0001/dia (negligível, dentro do free tier).

**`purgeOldModerationLogs`** — Elimina documentos de `moderationIncidents` e `moderationReviews` com `createdAt` > 2 anos.

- **`select()` vazio:** a query usa `.select()` sem argumentos, retornando apenas referências de documentos sem dados de campos. Como só precisamos do `ref` para deletar, isso elimina transferência de bandwidth dos campos PII (text, message, authorDisplayName, etc.).
- **Paginação com `limit()` + loop:** processa 450 docs por batch, repetindo até não haver mais documentos elegíveis. Evita carregar todos os documentos em memória de uma vez.
- **Single-field query:** `createdAt < cutoff` usa o índice automático do Firestore (sem composite index adicional).
- **Custo steady-state:** ~$0.0001/dia (documentos com >2 anos são raros nos primeiros anos de operação).

**`anonymizeOldFeedback`** — Anonimiza feedback com `createdAt` > 1 ano (remove `uid`, `message`; mantém `type`, `appLocale`, `platform` para estatísticas de produto).

- **Query de janela temporal (24h):** feedback com `createdAt` entre 366 e 365 dias atrás. Custo constante.
- **Backfill com `select()` projection:** `select("anonymizedAt")` + `limit(450)` para feedback anterior ao deploy.
- **Single-field query:** `createdAt` usa índice automático do Firestore.
- **Custo steady-state:** ~$0.0001/dia.

**Referência de preços Firestore (us-central1):**

| Operação | Preço | Free tier diário |
|----------|-------|------------------|
| Leitura | $0.06 / 100k docs | 50.000 |
| Escrita | $0.18 / 100k docs | 20.000 |
| Eliminação | $0.02 / 100k docs | 20.000 |

---

## 10. Referências

- [GDPR — Regulation (EU) 2016/679](https://gdpr-info.eu/)
- [LGPD — Lei nº 13.709/2018](https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm)
- [COPPA — 16 CFR Part 312](https://www.ftc.gov/legal-library/browse/rules/childrens-online-privacy-protection-rule-coppa)
- [Firebase — Delete user data](https://firebase.google.com/docs/auth/admin/manage-users#delete_a_user)
- [Stripe — Cancel subscriptions](https://docs.stripe.com/api/subscriptions/cancel)
