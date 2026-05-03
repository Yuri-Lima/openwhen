# Plano — Lista de Seguidores / Seguindo

**Data:** 2026-04-12
**Status:** ✅ Concluído (implementado — ver MVP_CHECKLIST.md)

---

## 1. Objetivo

Permitir que o utilizador veja a lista completa de quem o segue (seguidores) e de quem ele segue (seguindo), clicando nos contadores que já existem no perfil. A lista deve usar **lazy loading com paginação por cursor** para funcionar bem mesmo com milhares de seguidores.

---

## 2. Situação Atual

| Item | Estado |
|------|--------|
| Contadores no perfil próprio (`profile_screen.dart`) | ✅ Existem (linhas 215-217) — usam `StreamBuilder<QuerySnapshot>` que carrega **todos** os docs só para contar `.length` |
| Contadores no perfil alheio (`user_profile_screen.dart`) | ✅ Existem (linhas 214-216) — mesmo padrão |
| Contagem desnormalizada no doc do user (`followersCount`, `followingCount`) | ✅ Existe no Firestore (criada em `auth_repository.dart`) mas **não está sendo usada** nos perfis |
| Tela de lista de seguidores | ❌ Não existe |
| Padrão de paginação no app | ✅ `FeedConfig.explorePageSize = 20` + `startAfter` no feed Explorar |
| Chunking de `whereIn` | ✅ `user_search_follows.dart` (chunks de 10) |
| Regras Firestore para `follows` | ✅ `allow read: if signedIn()` — qualquer user logado pode ler |

### Problema de performance atual (bônus)

Os dois perfis fazem `snapshots()` na coleção `follows` inteira do user **só para contar** — isso é um listener real-time que lê N documentos. Com 5k seguidores = 5k reads por abertura de perfil. O user doc já tem `followersCount`/`followingCount` denormalizados — devemos usá-los.

---

## 3. Arquitetura da Solução

### 3.1 Novo ficheiro: `followers_list_screen.dart`

**Local:** `lib/features/profile/presentation/screens/followers_list_screen.dart`

**Parâmetros:**
```dart
class FollowersListScreen extends StatefulWidget {
  final String userId;           // UID do perfil sendo visualizado
  final bool initialTabFollowers; // true = aba Seguidores, false = aba Seguindo

  const FollowersListScreen({
    required this.userId,
    this.initialTabFollowers = true,
  });
}
```

**UI:** `DefaultTabController` com 2 abas:
- **Seguidores** — quem segue este user (`followingUid == userId`)
- **Seguindo** — quem este user segue (`followerUid == userId`)

Cada aba contém um `ListView.builder` com lazy loading.

### 3.2 Serviço de paginação: `followers_paginator.dart`

**Local:** `lib/features/profile/domain/followers_paginator.dart`

```dart
class FollowersPaginator {
  static const int pageSize = 20;

  final FirebaseFirestore _firestore;
  final String userId;
  final bool isFollowersList; // true = seguidores, false = seguindo

  DocumentSnapshot? _lastDoc;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  /// Retorna lista de UIDs da próxima página.
  Future<List<String>> fetchNextPage() async {
    if (!_hasMore) return [];

    Query query = _firestore
        .collection('follows')
        .where(
          isFollowersList ? 'followingUid' : 'followerUid',
          isEqualTo: userId,
        )
        .orderBy('createdAt', descending: true)
        .limit(pageSize);

    if (_lastDoc != null) {
      query = query.startAfterDocument(_lastDoc!);
    }

    final snap = await query.get();
    if (snap.docs.length < pageSize) _hasMore = false;
    if (snap.docs.isNotEmpty) _lastDoc = snap.docs.last;

    // Extrair UID do outro lado da relação
    return snap.docs.map((d) {
      final data = d.data() as Map<String, dynamic>;
      return (isFollowersList ? data['followerUid'] : data['followingUid']) as String;
    }).toList();
  }

  void reset() {
    _lastDoc = null;
    _hasMore = true;
  }
}
```

### 3.3 Fetch de perfis em batch

Após obter a página de UIDs, buscar os dados de cada user:

```dart
/// Busca perfis em chunks de 10 (limite whereIn do Firestore).
Future<List<AppUser>> fetchUserProfiles(List<String> uids) async {
  final results = <AppUser>[];
  for (var i = 0; i < uids.length; i += 10) {
    final chunk = uids.sublist(i, min(i + 10, uids.length));
    final snap = await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: chunk)
        .get();
    results.addAll(snap.docs.map((d) => AppUser.fromFirestore(d)));
  }
  return results;
}
```

### 3.4 Widget de cada item: `follower_tile.dart`

**Local:** `lib/features/profile/presentation/widgets/follower_tile.dart`

Cada tile mostra:
- Avatar circular (com fallback)
- Nome + @username
- Botão Seguir/Seguindo (se não for o próprio user)

Tap no tile → navega para `UserProfileScreen(userId: uid)`.

### 3.5 Tornar contadores clicáveis

Em **ambos** os perfis (`profile_screen.dart` e `user_profile_screen.dart`):

Trocar `_buildCounter(label, value)` por `_buildTappableCounter(label, value, onTap)` — wrapping com `GestureDetector` ou `InkWell`.

```dart
Widget _buildTappableCounter(String label, int value, VoidCallback onTap) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Text(value.toString(), style: GoogleFonts.dmSerifDisplay(...)),
          const SizedBox(height: 2),
          Text(label, style: GoogleFonts.dmSans(...)),
        ],
      ),
    ),
  );
}
```

Ao clicar em "Seguidores" → `Navigator.push(FollowersListScreen(userId: uid, initialTabFollowers: true))`
Ao clicar em "Seguindo" → `Navigator.push(FollowersListScreen(userId: uid, initialTabFollowers: false))`

### 3.6 Otimização: usar contagem desnormalizada

Substituir os `StreamBuilder<QuerySnapshot>` que contam `.docs.length` pelo campo já existente no documento do user:

```dart
// ANTES (lê N docs):
StreamBuilder<QuerySnapshot>(
  stream: firestore.collection('follows').where('followingUid', isEqualTo: uid).snapshots(),
  builder: (_, snap) => Text('${snap.data?.docs.length ?? 0}'),
)

// DEPOIS (lê 1 campo do doc já carregado):
final followers = (data?['followersCount'] as num?)?.toInt() ?? 0;
```

O doc do user já está sendo lido via `StreamBuilder` no topo do perfil — basta usar os campos `followersCount` / `followingCount` que já vêm nele.

---

## 4. Índices Firestore Necessários

A query de paginação ordena por `createdAt`, então precisamos de índices compostos:

| Coleção | Campos | Ordem |
|---------|--------|-------|
| `follows` | `followingUid` (==) + `createdAt` (desc) | Para listar seguidores |
| `follows` | `followerUid` (==) + `createdAt` (desc) | Para listar seguindo |

**Verificar:** estes índices podem já existir. Se não, adicionar em `firestore.indexes.json` e fazer deploy.

---

## 5. Localização (i18n)

Novas strings nos 3 ARBs (`app_pt_BR.arb`, `app_en.arb`, `app_es.arb`):

| Key | pt-BR | en | es |
|-----|-------|----|----|
| `followersListTitle` | Seguidores | Followers | Seguidores |
| `followingListTitle` | Seguindo | Following | Siguiendo |
| `followersTabFollowers` | Seguidores | Followers | Seguidores |
| `followersTabFollowing` | Seguindo | Following | Siguiendo |
| `followersEmpty` | Nenhum seguidor ainda | No followers yet | Aún no hay seguidores |
| `followingEmpty` | Não segue ninguém ainda | Not following anyone yet | Aún no sigue a nadie |
| `followButton` | Seguir | Follow | Seguir |
| `followingButton` | Seguindo | Following | Siguiendo |

---

## 6. Ficheiros a Criar / Modificar

### Criar:
| Ficheiro | Descrição |
|----------|-----------|
| `lib/features/profile/domain/followers_paginator.dart` | Serviço de paginação cursor-based |
| `lib/features/profile/presentation/screens/followers_list_screen.dart` | Tela com tabs Seguidores/Seguindo |
| `lib/features/profile/presentation/widgets/follower_tile.dart` | Widget de cada item da lista |

### Modificar:
| Ficheiro | Mudança |
|----------|---------|
| `lib/features/profile/presentation/screens/profile_screen.dart` | (1) Tornar contadores clicáveis → navegar para `FollowersListScreen`; (2) Usar `followersCount`/`followingCount` do doc em vez de `StreamBuilder` que conta docs |
| `lib/features/profile/presentation/screens/user_profile_screen.dart` | Mesmas mudanças |
| `lib/l10n/app_pt_BR.arb` | Novas strings |
| `lib/l10n/app_en.arb` | Novas strings |
| `lib/l10n/app_es.arb` | Novas strings |
| `firestore.indexes.json` | Adicionar índices compostos (se não existirem) |

---

## 7. Fluxo do Utilizador

```
Perfil (próprio ou alheio)
  └─ Toca em "42 Seguidores"
       └─ FollowersListScreen abre na aba "Seguidores"
            ├─ Carrega primeiros 20 seguidores
            ├─ Scroll para baixo → carrega mais 20 (lazy load)
            ├─ Toca num user → UserProfileScreen
            └─ Botão Seguir/Deixar de seguir em cada tile

  └─ Toca em "28 Seguindo"
       └─ FollowersListScreen abre na aba "Seguindo"
            └─ (mesmo fluxo)
```

---

## 8. Estimativa de Custo Firestore

| Ação | Reads |
|------|-------|
| Abrir lista (1ª página) | 1 query follows (20 docs) + 2 queries users (20 docs em chunks de 10) = ~3 reads billed |
| Scroll (próxima página) | Idem: ~3 reads |
| Comparação: perfil atual (StreamBuilder) | 1 listener × N docs (se 5k followers = 5k reads **por abertura**) |

**Economia:** a otimização do contador (usar campo denormalizado) elimina os listeners pesados.

---

## 9. Ordem de Implementação

1. **`followers_paginator.dart`** — lógica de paginação isolada e testável
2. **`follower_tile.dart`** — widget reutilizável
3. **`followers_list_screen.dart`** — tela completa com tabs + lazy load
4. **Strings i18n** — adicionar nos 3 ARBs
5. **`profile_screen.dart`** — tornar contadores clicáveis + otimizar para usar contagem denormalizada
6. **`user_profile_screen.dart`** — mesmas mudanças
7. **Índices Firestore** — verificar/criar + deploy
8. **Testes manuais** — perfil com 0, 1, muitos seguidores; scroll; navegação

---

## 10. Checklist de Implementação

- [ ] Criar `followers_paginator.dart` com paginação cursor-based (pageSize = 20)
- [ ] Criar `follower_tile.dart` (avatar, nome, username, botão seguir)
- [ ] Criar `followers_list_screen.dart` com TabBar (Seguidores/Seguindo) + lazy load
- [ ] Adicionar check de follow status (o current user segue cada item?) via `fetchFollowingUidsForTargets`
- [ ] Adicionar strings i18n nos 3 ARBs (pt-BR, en, es)
- [ ] `profile_screen.dart`: tornar contadores Seguidores/Seguindo clicáveis
- [ ] `profile_screen.dart`: substituir `StreamBuilder` de contagem por campo denormalizado
- [ ] `user_profile_screen.dart`: tornar contadores clicáveis
- [ ] `user_profile_screen.dart`: substituir `StreamBuilder` de contagem por campo denormalizado
- [ ] Verificar/criar índices compostos em `firestore.indexes.json`
- [ ] Testar: perfil com 0 seguidores (estado vazio)
- [ ] Testar: scroll para próxima página (lazy load)
- [ ] Testar: tap em user → navega para perfil
- [ ] Testar: botão seguir/unfollow funciona na lista
