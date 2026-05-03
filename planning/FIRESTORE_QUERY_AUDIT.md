# Plano de Auditoria — Queries Firestore

> **Objetivo:** Prevenir queries ineficientes ao Firestore antes que cheguem a produção.
> Criado após a descoberta de `StreamBuilder<QuerySnapshot>` que baixava todos os docs de `follows` só para contar `.length` — quando `followersCount`/`followingCount` já existiam denormalizados no doc do user.
>
> **Revisão v2 (2026-04-13):** Auditoria expandida após revisão cruzada. Adicionados 7 ficheiros com problemas não detetados na v1, corrigida classificação de `following_feed_merged_stream.dart`, e **descoberta crítica**: counters `followersCount`/`followingCount` não são mantidos por nenhuma Cloud Function.

---

## 1. Problema de Origem

Dois perfis (`profile_screen.dart` e `user_profile_screen.dart`) usavam:

```dart
StreamBuilder<QuerySnapshot>(
  stream: firestore.collection('follows')
      .where('followingUid', isEqualTo: uid)
      .snapshots(),   // ← TODOS os docs
  builder: (ctx, snap) {
    final count = snap.data?.docs.length ?? 0;  // ← só para .length
  },
)
```

**Custo real:** 5.000 seguidores = 5.000 reads por cada abertura de perfil, repetido em tempo real via listener.

**Solução correta:** Ler `followersCount` / `followingCount` do documento do próprio user (1 read) — **mas só depois de garantir que estes campos são mantidos** (ver §7).

---

## 2. Padrões Anti-Pattern a Verificar

### 2.1 — Collection read só para contar

| Sinal | Exemplo |
|-------|---------|
| `.snapshots()` ou `.get()` seguido de `.docs.length` | `snap.data!.docs.length` |
| Nenhum campo dos docs é usado além do count | O builder só mostra um `Text('$count')` |

**Regra:** Se só precisa do count → usar campo denormalizado (se mantido!) ou `AggregateQuery.count()`.

### 2.2 — Query sem `.limit()` em coleção que cresce

| Sinal | Risco |
|-------|-------|
| `.collection(X).where(...).snapshots()` sem `.limit()` | Listener ativo sobre N docs ilimitados |
| `.collection(X).where(...).get()` sem `.limit()` | Fetch único mas sem teto |

**Regra:** Toda query a coleção (não documento) DEVE ter `.limit()` ou paginação com `startAfterDocument()`.

**Exceção:** Queries de export/privacy (GDPR/LGPD) que precisam de todos os dados — estas devem ser movidas para Cloud Function server-side.

### 2.3 — Dados denormalizados existem mas não são mantidos

> **ALERTA:** A verificação revelou que vários counters denormalizados **não têm Cloud Functions** que os mantenham. Usar um counter que não é mantido resulta em dados incorretos — pior do que a query pesada.

| Campo Denormalizado | Onde Vive | Mantido Por | Estado Real |
|---------------------|-----------|-------------|-------------|
| `followersCount` | `users/{uid}` | **NINGUÉM** | ❌ Nunca incrementado em follow |
| `followingCount` | `users/{uid}` | **NINGUÉM** | ❌ Nunca incrementado em follow |
| `lettersCount` | `users/{uid}` | **NINGUÉM** | ❌ Inicializado a 0, nunca atualizado |
| `lettersSentCount` | `users/{uid}` | Client-side (`letter_send_service.dart` L52) | ⚠️ Só incrementa, nunca decrementa |
| `openedLettersCount` | `users/{uid}` | Client-side (`badge_unlock_service.dart`) | ⚠️ Increment-only (ok, abertura é permanente) |
| `likeCount` | `letters/{id}` | Client-side (`feed_screen.dart`) | ⚠️ Inc/dec client-side, risco de race condition |
| `commentCount` | `letters/{id}` | Client-side (`comments_screen.dart`) | ⚠️ Só incrementa no create |

**Regra:** Antes de usar um counter denormalizado, confirmar que (a) existe e (b) é mantido corretamente. Counters client-side são vulneráveis a race conditions em acessos concorrentes.

### 2.4 — Listener ativo quando bastava um `.get()`

| Sinal | Risco |
|-------|-------|
| `StreamBuilder` com dados que não mudam durante a vida da tela | Reads contínuos sem necessidade |
| Check de follow state feito com `.snapshots()` em vez de `.get()` | Listener permanente |

**Regra:** Usar `.snapshots()` (stream) apenas quando o dado precisa de atualização em tempo real visível ao user. Caso contrário, `.get()` + refresh manual.

### 2.5 — Query duplicada em múltiplos widgets

| Sinal | Risco |
|-------|-------|
| Mesmo `.collection().where().snapshots()` em 2+ widgets na mesma árvore | Listeners duplicados = reads × 2 |

**Regra:** Centralizar em provider (Riverpod) ou passá-lo como parâmetro de cima para baixo.

### 2.6 — `whereIn` sem validação de tamanho do array

| Sinal | Risco |
|-------|-------|
| `whereIn` com array que pode exceder 30 elementos | Firestore rejeita arrays > 30 em `whereIn` |

**Regra:** Validar que chunks de `whereIn` respeitam o limite de 30 (Firestore) e idealmente usar chunks de 10.

### 2.7 — Export/Privacy queries sem paginação server-side

| Sinal | Risco |
|-------|-------|
| `.get()` sem `.limit()` em contexto de export de dados do user | Carrega tudo em memória no client |

**Regra:** Para operações de export (GDPR/LGPD), usar Cloud Function dedicada com paginação em batches, ou pelo menos processar em chunks client-side.

---

## 3. Achados Atuais no Codebase

### 3.1 — Problemas Encontrados

#### Prioridade CRÍTICA

| # | Arquivo | Problema | Custo Estimado |
|---|---------|----------|----------------|
| C1 | Cloud Functions (ausentes) | `followersCount` e `followingCount` **não são mantidos** por nenhuma Cloud Function em operações normais de follow/unfollow. Só são decrementados em `delete_account.ts`. Qualquer tela que use estes campos mostra valores incorretos. | Dados errados em produção |

#### Prioridade ALTA

| # | Arquivo | Problema | Custo Estimado |
|---|---------|----------|----------------|
| A1 | `vault_screen.dart` (L344-425) | 4× `.snapshots()` sem `.limit()` em `letters` — 4 listeners simultâneos na mesma tela (received locked, received opened, sent locked, sent opened) | 4×N reads por update |
| A2 | `letter_export_data.dart` (L10-19) | 2× `.get()` sem `.limit()` em `letters` — carrega TODAS as cartas abertas. Nota: é export, precisa de todos os docs → solução é paginação em batches, não truncar | N reads (N = total cartas) |
| A3 | `capsule_vault_streams.dart` (L21-38) | 2× `.snapshots()` sem `.limit()` em `capsules` — listener ativo sobre todas as cápsulas trancadas | N reads por update |
| A4 | `privacy_center_screen.dart` (L66-77) | 10× `.get()` sem `.limit()` em `Future.wait` — carrega TODOS os dados do user de 8 coleções em paralelo. Feature GDPR/LGPD: precisa dos dados, mas deve ser movida para Cloud Function server-side | Σ(todas coleções) reads |

#### Prioridade MÉDIA

| # | Arquivo | Problema | Custo Estimado |
|---|---------|----------|----------------|
| M1 | `user_profile_screen.dart` (L46-50) | `.get()` em `follows` sem `.limit(1)` no toggle unfollow — risco de delete em loop se duplicatas | 1-M reads |
| M2 | `user_profile_screen.dart` (L162-166) | Follow state check usa `.snapshots()` em vez de `.get().limit(1)` — listener permanente para verificar se segue alguém | 1 read contínuo |
| M3 | `user_profile_screen.dart` (L258-263) | Cartas públicas do user `.snapshots()` sem `.limit()` | N reads por update |
| M4 | `profile_screen.dart` (L315-320) | Cartas públicas do próprio perfil `.snapshots()` sem `.limit()` | N reads por update |
| M5 | `comments_screen.dart` (L244-248) | Comentários por carta `.snapshots()` sem `.limit()` — pode crescer indefinidamente | N reads por update |
| M6 | `letter_requests_screen.dart` (L224-228) | Pedidos de carta pendentes `.snapshots()` sem `.limit()` | N reads por update |
| M7 | `following_feed_merged_stream.dart` (L48-51) | Listener de follows sem `.limit()` — carrega TODOS os follows do user. As queries de letters têm `.limit()` mas esta não | N reads (N = follows) |

### 3.2 — Já Otimizado (referência)

| Área | Padrão Usado | Ficheiro | Nota |
|------|-------------|---------|------|
| Feed Explorar | `.limit()` + `startAfterDocument()` cursor pagination | `explore_feed_paged.dart` | Limite vem do caller — funciona mas é frágil se chamado sem limite |
| Feed Seguindo (letters) | `whereIn` chunks de 10 + limit por chunk | `following_feed_merged_stream.dart` | ⚠️ Só as queries de letters são limitadas; o listener de follows não é (ver M7) |
| User Search | Prefix range + `array-contains` com `.limit(30)` | `user_search_service.dart` | ✅ |
| Followers list | Cursor pagination 20/página + `whereIn` chunks | `followers_paginator.dart` | ✅ |
| Follow state batch | `whereIn` chunks de 10 | `user_search_follows.dart` | ✅ Bounded pelo tamanho do chunk |
| Notificações | `.limit(50)` + `orderBy` | `moderation_notifications_screen.dart` | ✅ |
| Drafts — count | `.count()` aggregate (sem fetch de docs) | `draft_service.dart` L107-112 | ✅ Usa `AggregateQuery.count()` |
| Drafts — list | `.where('senderUid').orderBy('expiresAt').get()` | `draft_service.dart` L69-73 | ⚠️ Sem `.limit()` — bounded pelo soft-limit de 10 drafts/user (`draftCount`); risco baixo mas considerar `.limit(15)` como safety net |
| Drafts — stream | `.where('senderUid').orderBy('expiresAt').snapshots()` | `draft_service.dart` L90-93 | ⚠️ Listener sem `.limit()` — mesmo bounded implícito de 10; considerar `.limit(15)` |
| Drafts — cleanup | `.where('senderUid').where('expiresAt', isLessThan: now).get()` | `draft_service.dart` L142-145 | ✅ Compound query + batch delete; chamado uma vez no app start |

---

## 4. Checklist — Aplicar Antes de Cada PR

Usar esta checklist ao criar ou revisar qualquer código que toque no Firestore:

### A. Query Bounds
- [ ] Toda query a **coleção** tem `.limit()` ou paginação?
- [ ] Se é um listener (`.snapshots()`), o limite é razoável para o pior caso?
- [ ] Existe time-window filter (e.g. `openedAt > 30 dias atrás`) quando aplicável?
- [ ] Queries `whereIn` validam que o array não excede 30 elementos (chunks ≤ 10 recomendado)?

### B. Denormalização
- [ ] O dado que preciso já existe como campo denormalizado num documento pai?
- [ ] Se sim, **confirmei que o counter é mantido** (Cloud Function ou transaction) e não está stale?
- [ ] Se o counter não é mantido, NÃO usar — preferir `AggregateQuery.count()` ou query limitada

### C. Stream vs Get
- [ ] O dado precisa de atualização em tempo real? → `.snapshots()`
- [ ] O dado é lido uma vez (check, export, toggle)? → `.get()` com `.limit()`
- [ ] Para export de dados (GDPR/LGPD), considerei Cloud Function server-side com paginação em batches?

### D. Eficiência do Builder
- [ ] O `StreamBuilder`/`FutureBuilder` usa dados além do `.length`?
- [ ] Se só preciso do count, estou a usar counter denormalizado **mantido** ou `AggregateQuery.count()`?
- [ ] O builder está no nível mais baixo possível da árvore de widgets? (evita rebuilds desnecessários)

### E. Deduplicação
- [ ] Existe outro widget/provider que já faz esta mesma query?
- [ ] Se sim, consigo reutilizar via provider Riverpod em vez de duplicar?

---

## 5. Padrões Recomendados (Copiar-Colar)

### Counter denormalizado (APENAS se mantido por Cloud Function)
```dart
// ✅ CORRETO — 1 read (se o counter é mantido!)
StreamBuilder<DocumentSnapshot>(
  stream: firestore.collection('users').doc(uid).snapshots(),
  builder: (ctx, snap) {
    final data = snap.data?.data() as Map<String, dynamic>?;
    final followers = data?['followersCount'] ?? 0;
    return Text('$followers');
  },
)

// ❌ ERRADO — N reads
StreamBuilder<QuerySnapshot>(
  stream: firestore.collection('follows')
      .where('followingUid', isEqualTo: uid).snapshots(),
  builder: (ctx, snap) {
    final followers = snap.data?.docs.length ?? 0;
    return Text('$followers');
  },
)

// ✅ ALTERNATIVA SEGURA (se counter não é mantido) — 1 read
final countSnap = await firestore
    .collection('follows')
    .where('followingUid', isEqualTo: uid)
    .count()
    .get();
final followers = countSnap.count ?? 0;
```

### Query com limit e paginação
```dart
// ✅ Primeira página
final page = await firestore
    .collection('letters')
    .where('senderUid', isEqualTo: uid)
    .orderBy('createdAt', descending: true)
    .limit(20)
    .get();

// ✅ Próxima página
final next = await firestore
    .collection('letters')
    .where('senderUid', isEqualTo: uid)
    .orderBy('createdAt', descending: true)
    .startAfterDocument(page.docs.last)
    .limit(20)
    .get();
```

### Check de existência (1 doc)
```dart
// ✅ CORRETO — .get() com .limit(1) para check pontual
final snap = await firestore
    .collection('follows')
    .where('followerUid', isEqualTo: myUid)
    .where('followingUid', isEqualTo: targetUid)
    .limit(1)
    .get();
final isFollowing = snap.docs.isNotEmpty;

// ❌ ERRADO — .snapshots() para check que só precisa de leitura única
StreamBuilder<QuerySnapshot>(
  stream: firestore.collection('follows')
      .where('followerUid', isEqualTo: myUid)
      .where('followingUid', isEqualTo: targetUid)
      .snapshots(),  // listener permanente desnecessário
  // ...
)
```

### Export em batches (para GDPR/Privacy)
```dart
// ✅ CORRETO — processar em batches
Future<List<Map<String, dynamic>>> exportAllInBatches(
  String uid, String collection, String field,
) async {
  final all = <Map<String, dynamic>>[];
  DocumentSnapshot? lastDoc;
  while (true) {
    var query = firestore
        .collection(collection)
        .where(field, isEqualTo: uid)
        .orderBy(FieldPath.documentId)
        .limit(500);
    if (lastDoc != null) query = query.startAfterDocument(lastDoc);
    final snap = await query.get();
    all.addAll(snap.docs.map((d) => d.data()));
    if (snap.docs.length < 500) break;
    lastDoc = snap.docs.last;
  }
  return all;
}
```

---

## 6. Comando de Auditoria Rápida

Para encontrar potenciais problemas no codebase, executar:

```bash
# Queries sem .limit() em coleções (streams)
grep -rn '\.snapshots()' lib/ | grep -v 'doc(' | grep -v '.limit('

# Queries sem .limit() em coleções (gets)
grep -rn '\.get()' lib/ | grep -v 'doc(' | grep -v '.limit('

# .docs.length (possível count via query)
grep -rn '\.docs\.length' lib/

# FieldValue.increment client-side (possível race condition)
grep -rn 'FieldValue.increment' lib/

# Counters que deviam ser server-side
grep -rn 'followersCount\|followingCount\|lettersCount' lib/
```

---

## 7. Campos Denormalizados — Inventário Verificado

| Campo | Documento | Quem Mantém | Incrementa | Decrementa | Estado |
|-------|-----------|-------------|------------|------------|--------|
| `followersCount` | `users/{uid}` | **Ninguém** | ❌ Nunca | Só em `delete_account.ts` | ❌ **BROKEN** |
| `followingCount` | `users/{uid}` | **Ninguém** | ❌ Nunca | Só em `delete_account.ts` | ❌ **BROKEN** |
| `lettersCount` | `users/{uid}` | **Ninguém** | ❌ Nunca | N/A | ❌ **ABANDONADO** |
| `lettersSentCount` | `users/{uid}` | Client (`letter_send_service.dart` L52) | ✅ `FieldValue.increment(1)` | ❌ Nunca | ⚠️ Parcial |
| `openedLettersCount` | `users/{uid}` | Client (`badge_unlock_service.dart`) | ✅ Increment-only | N/A (ok) | ✅ OK |
| `likeCount` | `letters/{id}` | Client (`feed_screen.dart`) | ✅ `+1` | ✅ `-1` | ⚠️ Race condition possível |
| `commentCount` | `letters/{id}` | Client (`comments_screen.dart`) | ✅ `+1` | ❌ Nunca (no delete) | ⚠️ Parcial |

### Ações Necessárias

1. **CRÍTICO:** Criar Cloud Functions `onFollowCreate` e `onFollowDelete` para manter `followersCount`/`followingCount`, OU remover estes campos e usar `AggregateQuery.count()` nas telas de perfil
2. **ALTA:** Decidir se `lettersCount` é necessário — se sim, criar manutenção; se não, remover o campo
3. **MÉDIA:** Considerar migrar `likeCount` e `commentCount` para Cloud Functions para evitar race conditions em likes/comments concorrentes
4. **MÉDIA:** Garantir que `commentCount` decrementa quando um comentário é eliminado

---

## 8. Próximos Passos

### Fase 1 — Correções Críticas
1. **Criar Cloud Functions** `onFollowCreate`/`onFollowDelete` para `followersCount`/`followingCount` (ou migrar para `AggregateQuery.count()`)
2. Correr script de backfill para acertar counters existentes

### Fase 2 — Correções Alta Prioridade
3. `vault_screen.dart` — Adicionar `.limit()` ou paginação aos 4 listeners
4. `letter_export_data.dart` — Implementar paginação em batches (não truncar)
5. `capsule_vault_streams.dart` — Adicionar `.limit()` aos 2 streams
6. `privacy_center_screen.dart` — Migrar para Cloud Function server-side ou processar em batches

### Fase 3 — Correções Média Prioridade
7. `user_profile_screen.dart` — (a) `.limit(1)` no unfollow, (b) `.get()` em vez de `.snapshots()` no follow state, (c) `.limit()` nas cartas públicas
8. `profile_screen.dart` — `.limit()` nas cartas públicas
9. `comments_screen.dart` — `.limit()` nos comentários
10. `letter_requests_screen.dart` — `.limit()` nos pedidos pendentes
11. `following_feed_merged_stream.dart` — `.limit()` no listener de follows

### Fase 4 — Prevenção
12. Adicionar esta checklist (§4) ao processo de code review
13. Executar os comandos de auditoria (§6) periodicamente ou integrar em CI
14. Considerar lint rule customizada para detetar `.snapshots()` sem `.limit()` em collection queries
