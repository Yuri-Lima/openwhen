# Admin e moderação — guia de configuração

Este documento descreve o fluxo completo para: **deploy**, **segredo de bootstrap**, **tornar-te admin** e **usar o painel de moderação** no OpenWhen.

---

## 1. O que já existe no código

- **Denúncias** (`reports`): menu ⋯ no feed e em comentários; escreve em Firestore com schema fixo.
- **Painel**: Configurações → entrada de moderação (só aparece com claim `admin` no token).
- **Cloud Functions** (`functions/src/admin.ts`):
  - `bootstrapAdminClaim` — define `admin: true` no utilizador autenticado (precisa de segredo).
  - `adminListPendingReports`, `adminResolveReport`, `adminListRecentFeedback` — só com claim `admin`.

---

## 2. Deploy (Firebase)

```bash
cd /caminho/do/OpenWhen
firebase deploy --only firestore:rules,firestore:indexes,functions
```

Confirma que as funções aparecem no projeto (ex.: `bootstrapAdminClaim`, `us-central1`).

---

## 3. Variável `ADMIN_BOOTSTRAP_SECRET` (produção)

A função **`bootstrapAdminClaim`** lê `process.env.ADMIN_BOOTSTRAP_SECRET`. Sem isto, responde `bootstrap_not_configured`.

**Onde configurar (Functions 2ª gén. = Cloud Run):**

1. [Google Cloud Console](https://console.cloud.google.com/run) → projeto correto.
2. Serviço cujo nome corresponde a **`bootstrapadminclaim`** (ou nome semelhante).
3. **Editar e implementar nova revisão** → separador **Variables & Secrets**.
4. **Add variable**: nome `ADMIN_BOOTSTRAP_SECRET`, valor = string longa e aleatória (guarda-a num gestor de passwords).
5. **Deploy**.

Não commits este valor no repositório.

---

## 4. Tornar a tua conta “admin” (uma vez)

Tens de estar **autenticado** como o utilizador que queres promover e chamar `bootstrapAdminClaim` com o **mesmo** segredo que configuraste no passo 3.

### Opção A — Recomendada: app Flutter

Com sessão iniciada na app:

```dart
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

await FirebaseFunctions.instanceFor(region: 'us-central1')
    .httpsCallable('bootstrapAdminClaim')
    .call({'secret': 'O_TEU_ADMIN_BOOTSTRAP_SECRET'});

await FirebaseAuth.instance.currentUser?.getIdToken(true);
```

Remove este código depois de usar (ou restringe a builds de debug).

### Opção B — `curl` com ID token

1. Obtém um **ID token** do Firebase Auth para o teu utilizador (JWT curto, expira ~1 h).

   - **Script local** (não versionado): copia `scripts/bootstrap-token.example.sh` para `scripts/bootstrap-token.local.sh` (está no `.gitignore`), preenche os `export` no ficheiro local e executa `./scripts/bootstrap-token.local.sh`. Na resposta JSON usa o campo **`idToken`**.

2. Chama o callable HTTP (região e projeto iguais ao deploy):

```bash
curl -s -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer COLA_AQUI_O_idToken" \
  "https://us-central1-SEU_PROJECT_ID.cloudfunctions.net/bootstrapAdminClaim" \
  -d '{"data":{"secret":"O_MESMO_SEGREDO_QUE_ADMIN_BOOTSTRAP_SECRET"}}'
```

Substitui `SEU_PROJECT_ID` (ex.: `openwhen-923f5`).

### Depois do sucesso

- **Atualiza o token**: termina sessão e volta a entrar na app, ou força `getIdToken(true)`.
- Abre **Configurações**: deve aparecer a entrada de **moderação (admin)**.

---

## 5. Flags remotas (opcional)

Documento Firestore **`systemConfig/app`** (leitura só para utilizadores autenticados; escrita só via Admin SDK / futuras funções):

- `reportsEnabled`: se `false`, esconde os menus de denúncia. Se o documento não existir, o app assume tudo ativo.

---

## 6. Segurança — boas práticas

- Não commits **passwords**, **refresh tokens** nem **ID tokens** em ficheiros versionados.
- A **Web API Key** do Firebase é pública na app, mas não a espalhes desnecessariamente.
- Se expuseres **password** ou **tokens** (chat, issues, prints), **altera a password** e considera tokens como comprometidos.
- Depois do primeiro admin, podes **alterar ou remover** `ADMIN_BOOTSTRAP_SECRET` no Cloud Run e documentar outra forma de promover contas (ex.: script Admin SDK só na tua máquina).

---

## 7. Referências no repositório

| Ficheiro | Conteúdo |
|----------|----------|
| [`functions/README.md`](../functions/README.md) | Variáveis de ambiente (Stripe, `ADMIN_BOOTSTRAP_SECRET`) |
| [`functions/src/admin.ts`](../functions/src/admin.ts) | Lógica dos callables de moderação |
| [`scripts/bootstrap-token.example.sh`](../scripts/bootstrap-token.example.sh) | Modelo para obter `idToken` via REST (copiar para `.local.sh`) |
| [`lib/features/admin/presentation/admin_moderation_screen.dart`](../lib/features/admin/presentation/admin_moderation_screen.dart) | UI do painel |

---

## 8. Resolução de problemas

| Erro / sintoma | Causa provável |
|----------------|----------------|
| `bootstrap_not_configured` | `ADMIN_BOOTSTRAP_SECRET` não definido no serviço Cloud Run ou revisão não deployada |
| `invalid_secret` | O `secret` no body não coincide com a variável de ambiente |
| `permission-denied` / `admin_required` (nas outras funções) | Token sem claim `admin`; faz logout/login ou `getIdToken(true)` |
| `unauthenticated` | Pedido sem utilizador Firebase (sem `Authorization: Bearer` válido) |
| Menu admin não aparece | Claim ainda não no token; novo login ou refresh do token |

---

*Última actualização: alinhado com o fluxo actual de deploy e scripts do repositório.*
