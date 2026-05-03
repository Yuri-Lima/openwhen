# Whenote — Plano: Compartilhar Carta via Link

> **Status:** ✅ Implementado (2026-05-03)  
> **Prioridade:** P1 (Crescimento orgânico — Semana 3 / Mês 2 do roadmap)  
> **Estimativa:** ~2–3 semanas de desenvolvimento  
> **Dependências:** Deep link infra (✅ pronto), Firebase Hosting (✅ pronto), `claimExternalLetters` (✅ pronto)

---

## 1. Problema

Atualmente existem duas formas de enviar uma carta:

1. **@username** — o destinatário já tem conta no Whenote.
2. **Email** — o destinatário recebe convite por SendGrid com deep link.

**Cenários não cobertos:**

- O remetente não sabe o email do destinatário (ex.: amigo próximo cujo email desconhece).
- O destinatário não tem email acessível (ex.: familiar mais velho, criança sob supervisão).
- O remetente quer enviar via **WhatsApp, Telegram, Instagram DM, SMS** — canais onde email não funciona.
- O remetente quer **máxima flexibilidade**: copiar um link e colar onde quiser.

**Oportunidade:** um link partilhável resolve todos estes cenários de uma só vez e funciona como motor de **crescimento orgânico** (cada link é um convite natural para o app).

---

## 2. Proposta

Adicionar uma terceira opção de envio: **"Gerar link"**. O remetente recebe um URL curto e pode partilhá-lo por qualquer canal. Quando o destinatário clica:

1. Se **tem o app instalado** → abre direto na carta (Universal Link / App Link).
2. Se **não tem** → abre uma **landing page web** com preview emocional + CTA para download → após instalar e criar conta, a carta é vinculada automaticamente ao seu cofre.

---

## 3. Fluxo Detalhado

### 3.1 Remetente gera o link (Flutter)

Na tela de envio (`write_letter_screen.dart`), onde hoje há campo de `@username` e campo de email, adicionar um terceiro botão/opção:

```
┌───────────────────────────────────┐
│  Como enviar?                     │
│                                   │
│  🔍 Buscar @username              │
│  ✉️  Enviar por email             │
│  🔗 Gerar link para compartilhar  │  ← NOVO
└───────────────────────────────────┘
```

**Ao selecionar "Gerar link":**

1. O app chama a callable `generateShareLink({ letterId })`.
2. A Cloud Function:
   - Gera um `shareToken` (UUID v4 ou nanoid de 12 chars).
   - Salva no documento da carta: `shareToken`, `shareMode: "link"`, `shareCreatedAt`.
   - Retorna a URL: `https://whenote.app/open/{shareToken}`.
3. O app exibe o link com opções:
   - **Copiar** (clipboard) — padrão.
   - **Compartilhar** (share_plus) — abre share sheet nativa do SO.
4. A carta é criada **sem** `receiverUid` e **sem** `receiverEmail` — o campo `shareMode: "link"` indica que o destinatário será vinculado depois.

### 3.2 Landing Page Web (Firebase Hosting)

Servida em `whenote.app/open/{shareToken}`. Uma página estática (HTML + JS mínimo) que:

1. **Consulta** a Cloud Function `getSharePreview({ token })` para obter metadados públicos:
   - Nome do remetente (ou "Alguém especial").
   - Data de abertura (ou "Uma surpresa te espera").
   - Estado emocional (cor/tema da carta, sem conteúdo).
   - **Nunca** retorna o conteúdo da carta.
2. **Renderiza** um preview emocional:
   ```
   ┌──────────────────────────────────┐
   │      🦉 Whenote                  │
   │                                  │
   │  [Nome] selou uma carta          │
   │  para você.                      │
   │                                  │
   │  📅 Abre em 23 de dezembro       │
   │                                  │
   │  ┌────────────────────────────┐  │
   │  │  Baixar Whenote (grátis)   │  │
   │  └────────────────────────────┘  │
   │                                  │
   │  Já tem? Abrir no app →          │
   └──────────────────────────────────┘
   ```
3. **Comportamento dos botões:**
   - **"Baixar Whenote"** → redireciona para App Store / Play Store (detecta SO via User-Agent).
   - **"Abrir no app"** → tenta o deep link `whenote://open/{shareToken}` (custom scheme) ou o Universal Link (`https://whenote.app/open/{shareToken}` — já configurado no intent filter).
4. **Open Graph / meta tags** para preview bonito ao colar link no WhatsApp/Telegram:
   ```html
   <meta property="og:title" content="Você recebeu uma carta selada 🦉" />
   <meta property="og:description" content="[Nome] escreveu algo especial para você no Whenote." />
   <meta property="og:image" content="https://whenote.app/assets/og-share-card.png" />
   ```

### 3.3 Destinatário abre o app (Flutter)

**Cenário A — Já tem conta e app instalado:**

1. Universal Link / App Link intercepta `whenote.app/open/{shareToken}`.
2. `DeepLinkCoordinator` extrai o token da URL.
3. Chama callable `claimShareLink({ shareToken })`.
4. Cloud Function vincula a carta: `receiverUid = currentUser.uid`.
5. Navega para a tela da carta (ou cofre, se ainda está trancada).

**Cenário B — Não tem conta:**

1. Landing page → download do app → instala → abre.
2. `PendingDeepLink` (já implementado) armazena a URL de `open/{shareToken}`.
3. Utilizador faz registo/login.
4. `DeepLinkCoordinator.handlePendingAfterSignIn()` detecta o token pendente.
5. Chama `claimShareLink({ shareToken })` → carta vinculada.
6. Navega para o cofre com a carta.

### 3.4 Notificação ao remetente

Quando o destinatário faz claim:
- Cloud Function envia **push notification** ao remetente: "Sua carta foi recebida! 🦉"
- Atualiza campo `receiverHasAccount: true` no documento da carta.

---

## 4. Modelo de Dados (Firestore)

### 4.1 Novos campos em `letters/{id}`

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `shareToken` | `string \| null` | Token único do link partilhável (indexado, único) |
| `shareMode` | `string \| null` | `"link"` se enviado por link, `null`/`"email"`/`"username"` nos modos antigos |
| `shareCreatedAt` | `Timestamp \| null` | Quando o link foi gerado |
| `shareClaimedAt` | `Timestamp \| null` | Quando o destinatário fez claim |
| `shareClaimedBy` | `string \| null` | UID de quem fez claim (redundante com `receiverUid`, mas útil para audit) |

### 4.2 Índice Firestore

```
Collection: letters
Field: shareToken (Ascending)
Query scope: Collection
```

Necessário para a query `where('shareToken', '==', token).limit(1)` da Cloud Function.

### 4.3 Regras Firestore (adições)

```javascript
// Dentro de match /letters/{letterId}
// Permitir leitura se o utilizador é o claim do share
allow read: if resource.data.receiverUid == request.auth.uid
          || resource.data.senderUid == request.auth.uid
          || (resource.data.isPublic == true && resource.data.status == 'opened');
// shareToken, shareMode, shareClaimedAt, shareClaimedBy — backend-only (como inviteEmailStatus)
allow update: if ... && !request.resource.data.diff(resource.data).affectedKeys()
  .hasAny(['shareToken', 'shareMode', 'shareCreatedAt', 'shareClaimedAt', 'shareClaimedBy']);
```

---

## 5. Cloud Functions (novas)

### 5.1 `generateShareLink` (callable)

```
Input:  { letterId: string }
Auth:   Requer auth; uid deve ser o senderUid da carta
Logic:
  1. Verifica se a carta existe e pertence ao caller
  2. Se já tem shareToken → retorna o link existente (idempotente)
  3. Gera shareToken (nanoid, 12 chars, URL-safe)
  4. Atualiza documento: shareToken, shareMode, shareCreatedAt
  5. Retorna { url: "https://whenote.app/open/{shareToken}" }
Output: { url: string }
```

### 5.2 `getSharePreview` (HTTP — público)

```
Input:  ?token={shareToken}  (query param)
Auth:   Sem auth (público — é a landing page que chama)
Logic:
  1. Query letters where shareToken == token, limit 1
  2. Se não encontra → 404
  3. Se encontra → retorna preview sanitizado:
     - senderDisplayName (ou "Alguém especial" se remetente preferir anonimato)
     - openDate (formatado)
     - emotionalState (cor/ícone)
     - isClaimed (bool)
     - NÃO retorna: título, mensagem, receiverUid, senderUid
Output: { senderName, openDate, emotion, isClaimed }
```

### 5.3 `claimShareLink` (callable)

```
Input:  { shareToken: string }
Auth:   Requer auth + email verificado
Logic:
  1. Query letters where shareToken == token, limit 1
  2. Validações:
     - Carta existe
     - Carta ainda não foi claimed (receiverUid == null)
     - Caller não é o próprio remetente
  3. Atualiza documento:
     - receiverUid = caller.uid
     - receiverHasAccount = true
     - shareClaimedAt = now
     - shareClaimedBy = caller.uid
  4. Envia FCM ao senderUid: "Sua carta foi recebida! 🦉"
  5. Retorna { letterId, status: "claimed" }
Output: { letterId: string, status: string }
Erros:
  - ALREADY_CLAIMED: carta já tem destinatário
  - SELF_CLAIM: não pode receber própria carta
  - NOT_FOUND: token inválido
```

---

## 6. Segurança

| Risco | Mitigação |
|-------|-----------|
| **Brute-force de tokens** | nanoid 12 chars (62^12 ≈ 3×10²¹ combinações); rate limiting no `getSharePreview` (ex.: 60 req/min por IP via Cloud Functions) |
| **Token leak → pessoa errada lê carta** | O token apenas permite **claim** (vincular ao uid). A carta só é legível após claim, e só pelo `receiverUid`. Se alguém fizer claim indevido, o remetente pode revogar (ver 6.1) |
| **Spam de links** | Limite de cartas por link por utilizador (ex.: max 50 cartas com `shareMode: "link"` ativas) |
| **Scraping de previews** | Preview não contém conteúdo da carta; apenas nome do remetente e data |
| **Remetente quer revogar** | Campo `shareRevoked: true` → landing page mostra "Este link não está mais ativo" |

### 6.1 Revogar link (opcional na v1)

O remetente pode, na tela de detalhe da carta (antes do claim):
- **Revogar link** → `shareRevoked: true`, landing page retorna 410.
- **Gerar novo link** → novo `shareToken`, antigo invalidado.

---

## 7. Fases de Implementação

### Fase A — Backend ✅ Concluída

1. ✅ Cloud Functions: `generateShareLink`, `getSharePreview`, `claimShareLink`, `revokeShareLink`
2. ✅ Índice Firestore para `shareToken` + compostos (`senderUid+shareMode`, `senderUid+shareMode+shareRevoked`)
3. ✅ `firestore.rules` — campos `share*` protegidos como backend-only
4. ⏳ Testes unitários das Cloud Functions (pendente)

### Fase B — Landing Page ✅ Concluída

1. ✅ Landing page dinâmica (`hosting/public/open/index.html`) com fetch a `getSharePreview`
2. ✅ OG meta tags estáticas (v1 — crawlers não executam JS)
3. ✅ Detecção de SO para redirect App Store / Play Store
4. ⏳ Deploy no Firebase Hosting (pendente — aguarda commit + push)
5. ⏳ Testar previews no WhatsApp, Telegram, iMessage, Twitter (QA manual)

### Fase C — Flutter ✅ Concluída

1. ✅ UI: terceira opção "Gerar link" na `write_letter_screen.dart`
2. ✅ `ShareLinkService` em `lib/core/linking/share_link_service.dart`
3. ✅ `DeepLinkCoordinator` reconhece `/open/{token}` + `PendingDeepLink.pendingShareToken`
4. ✅ Dialog de "link copiado" com copy + share sheet nativa
5. ✅ Banner de estado do link na `letter_detail_screen.dart` (pending/claimed/revoked)

### Fase D — Notificações e Polish ✅ Concluída

1. ✅ FCM push + notificação in-app ao remetente quando carta é claimed
2. ⏳ Animação/feedback na UI quando carta é claimed em tempo real (futuro)
3. ✅ Banner na landing page se carta já foi claimed
4. ✅ Localização (en, pt, pt-BR, es) para UI Flutter; landing page em inglês (v1)

### Fase E — Verificação e QA ⏳ Pendente (testes manuais em dispositivo)

1. ⏳ Teste end-to-end: gerar link → clicar → instalar → claim
2. ⏳ Teste com app já instalado (Universal Link / App Link)
3. ✅ Review de segurança: transaction no claim, self-claim, double-claim, rate limiting, token collision check
4. ⏳ Teste de preview OG em WhatsApp, Telegram, iMessage, Twitter/X
5. ⏳ Teste de revogação de link
6. ⏳ Verificar que cartas com `shareMode: "link"` aparecem no cofre do remetente

---

## 8. Impacto no Código Existente

| Ficheiro / Módulo | Mudança |
|-------------------|---------|
| `write_letter_screen.dart` | Adicionar opção "Gerar link" na seleção de destinatário |
| `letter_send_service.dart` | Suportar envio sem `receiverUid` nem `receiverEmail` (apenas `shareMode: "link"`) |
| `deep_link_coordinator.dart` | Reconhecer `/open/{token}` e chamar `claimShareLink` |
| `deep_link_bootstrap.dart` | Registrar padrão `/open/*` |
| `external_letters_service.dart` | Adicionar `claimShareLink()` (ou criar `share_link_service.dart`) |
| `letter_detail_screen.dart` | Mostrar estado do link para o remetente |
| `vault_screen.dart` | Exibir cartas recebidas via link normalmente (sem mudança se `receiverUid` está preenchido após claim) |
| `firestore.rules` | Proteger campos `share*` como backend-only |
| `functions/src/` | 3 novas funções (generate, preview, claim) |
| `public/` (Hosting) | Nova landing page + assets OG |

---

## 9. Métricas de Sucesso

| Métrica | Target (30 dias) |
|---------|-------------------|
| Links gerados | Monitorar volume vs. envios por email/username |
| Taxa de claim (link → carta recebida) | > 30% |
| Novos registos via link | Comparar com registos orgânicos |
| Tempo médio link → claim | < 48h |
| Taxa de rejeição da landing page | < 60% |

---

## 10. Alinhamento com Roadmap

Este plano implementa diretamente dois itens do `ROADMAP.md`:

- **Semana 3 — Crescimento orgânico:** infraestrutura de link partilhável.
- **Mês 2 — Pós primeiros usuários:** "Landing page web para quem recebe carta sem ter conta."

Também reforça o **card compartilhável ao enviar** (Semana 2) — o remetente pode partilhar o link junto com o card nos Stories.

---

## 11. Gaps Identificados no Review — Todos Resolvidos

### GAP 1 ✅ — Android intent filter para `/open`
Adicionado `<intent-filter>` com `android:pathPrefix="/open"` em `AndroidManifest.xml`.

### GAP 2 ✅ — iOS AASA atualizado
Path `/open/*` adicionado a `hosting/public/.well-known/apple-app-site-association`.

### GAP 3 ✅ — Firebase Hosting rewrite
Rewrite `"/open/**" → "/open/index.html"` e `"/api/share-preview" → function getSharePreview` adicionados a `firebase.json`.

### GAP 4 ✅ — Landing page dinâmica criada
`hosting/public/open/index.html` com fetch a `getSharePreview`, preview emocional, estados (loading/main/claimed/revoked/rate-limited/error), dark mode, OG tags estáticas.

### GAP 5 ✅ — Token via `crypto.randomBytes`
Usa `randomBytes(9).toString('base64url')` — 12 chars URL-safe, sem dependência externa. Inclui collision check (3 tentativas).

### GAP 6 ✅ — Validação bypassed para link mode
Estado `_shareViaLink = true` bypassa validação de destinatário em `write_letter_screen.dart`.

### GAP 7 ✅ — Guard no trigger de email
`external_letters.ts`: `if (data.deliveryMode === "link" || data.shareMode === "link") return;`

### GAP 8 ✅ — Banner de link em vez de email bounce
`letter_detail_screen.dart`: banner de email excluído para `_isSharedViaLink`; banner dedicado com 3 estados (pending/claimed/revoked) + botões copy/share.

### GAP 9 ✅ — OG meta tags estáticas (v1)
Implementadas como planejado. Evolução para SSR se métricas justificarem.

### GAP 10 ✅ — DeepLinkCoordinator chama ambos os claims
`handlePendingAfterSignIn` chama `claimExternalLetters()` (email) + `claimShareLink()` (se `pendingShareToken != null`).

### GAP 11 ✅ — Modelo Letter atualizado
Campos `shareToken`, `shareMode`, `shareClaimedAt`, `shareRevoked` adicionados a `letter.dart` + `fromFirestore`.

### GAP 12 ✅ — Claim exclusivamente via Cloud Function
`claimShareLink` callable com Admin SDK, dentro de `db.runTransaction()`. Campos `share*` protegidos nas `firestore.rules`.

---

## 12. Notas de Compatibilidade (código existente — referência)

Após análise do código atual, os seguintes pontos requerem atenção na implementação:

### 11.1 `PendingDeepLink.storeFromUri` — novo padrão `/open/{token}`

O parser atual (`pending_deep_link.dart`) só reconhece `/letter/{id}` e `/capsule/{id}`. É necessário adicionar suporte para `/open/{token}`:

```dart
// Novo bloco em storeFromUri:
static String? pendingShareToken; // ← novo campo

if (segs.length >= 2 && segs[0] == 'open') {
  pendingShareToken = segs[1];
  pendingLetterId = null;
  pendingCapsuleId = null;
  return;
}
```

### 11.2 `Letter` model — `receiverUid` é `required` e não-nullable

O modelo `Letter` em `letter.dart` define `receiverUid` como `final String` (não nullable). Para cartas com `shareMode: "link"` antes do claim, o valor será `''` (string vazia) — **é assim que já funciona** para cartas externas por email (`data['receiverUid'] ?? ''`). Não precisa mudar o modelo.

### 11.3 `write_letter_screen.dart` — `letterData` já suporta `receiverUid: ''`

Na linha 857, `'receiverUid': _receiverUid ?? ''` — cartas por link terão `_receiverUid = null`, resultando em `''`. O campo `deliveryMode` pode ser `'link'` (novo valor além de `'external'`).

### 11.4 `DeepLinkCoordinator` — novo fluxo de claim

O `handlePendingAfterSignIn` precisa de um bloco adicional para `pendingShareToken`:
1. Se `pendingShareToken != null` → chamar `claimShareLink({ shareToken })`.
2. O claim retorna o `letterId` → navegar para `LetterDetailScreen`.

### 11.5 `deep_link_bootstrap.dart` — Android/iOS intent filters

Os intent filters em `AndroidManifest.xml` já cobrem `https://whenote.app/*`, mas é prudente verificar que `/open/*` não está excluído por algum path pattern restritivo. O iOS (AASA) tipicamente cobre todo o domínio se configurado com `applinks:whenote.app`.

### 11.6 Firestore Rules — campos protegidos

Os campos `share*` devem ser adicionados à mesma lista de campos protegidos (backend-only) onde já estão `inviteEmailStatus*`, `deliveryMode`, `lastResendAt`, etc. nas `firestore.rules`.

---

## 13. Considerações Futuras

- **QR Code físico:** gerar QR code a partir do `shareToken` — impresso em merchandising, cartões, eventos.
- **Link com expiração:** `shareExpiresAt` para links temporários.
- **Link com senha:** `sharePin` para proteção adicional (ex.: "o destinatário precisa inserir um código").
- **Analytics por link:** rastrear cliques, opens, conversões (pixel na landing page + Firestore).
- **Múltiplos destinatários por link:** link que pode ser claimed por N pessoas (cartas coletivas / broadcast).
