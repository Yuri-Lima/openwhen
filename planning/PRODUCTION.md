# OpenWhen — Checklist e configuração para produção

Este documento reúne **tudo o que precisa de estar definido** para compilar, publicar e operar o app em **modo produção**: ficheiros locais, variáveis de build (`dart-define`), Firebase, Meta/Instagram, billing opcional, assinaturas móveis e referências ao resto da documentação. A **checklist acionável** (por fases A–G) está na [secção 8](#8-checklist-de-produção-completa).

**Relacionado:** [README.md](../README.md) (Firebase, CLI), [DEVICE_TESTING.md](DEVICE_TESTING.md) (QA em dispositivo), [TROUBLESHOOTING.md](TROUBLESHOOTING.md) (envio de carta, `permission-denied`, ecrã admin), [ARCHITECTURE.md](ARCHITECTURE.md) (stack, moderação, Instagram Stories), [functions/README.md](../functions/README.md) (Stripe, moderação por IA e Cloud Functions).

---

## 1. Ficheiros obrigatórios no cliente (Firebase)

| Ficheiro | Função |
|----------|--------|
| `lib/firebase_options.dart` | Configuração FlutterFire (todas as plataformas). **Obrigatório** para correr o app. |
| `android/app/google-services.json` | Projeto Firebase Android. |
| `ios/Runner/GoogleService-Info.plist` | Projeto Firebase iOS. |

Neste repositório, os três ficheiros estão **versionados** para o projeto **`openwhen-923f5`**. Sem eles (ou sem versões coerentes entre si), o build ou o runtime Firebase falham. Para **outro** projeto Firebase (ou após mudar bundle IDs / package name), regenerar com [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/) alinhado ao projeto de produção.

Identificadores do projeto atual estão descritos em [README.md](../README.md#firebase-configuration) (tabela Project identifiers).

---

## 2. Variáveis de build Flutter (`--dart-define`)

O código lê constantes em tempo de compilação. **Passar todas as que forem necessárias** no mesmo comando de build/release (CI incluído).

| Variável | Obrigatória? | Valor típico / default | Onde é usada |
|----------|----------------|-------------------------|--------------|
| `FB_APP_ID` | **Recomendada** para partilha nativa Instagram Stories | Meta (Facebook) **App ID** numérico | [`lib/core/config/facebook_app_config.dart`](../lib/core/config/facebook_app_config.dart) |
| `BILLING_ENABLED` | Não (default `false`) | `true` só quando Stripe + Functions estão prontos | [`lib/core/billing/billing_feature_flags.dart`](../lib/core/billing/billing_feature_flags.dart) |
| `FUNCTIONS_REGION` | Não | Default `us-central1`; alterar se as Cloud Functions estiverem noutra região | [`lib/core/billing/firebase_functions_region.dart`](../lib/core/billing/firebase_functions_region.dart) |

### Comportamento se não definir

- **`FB_APP_ID` em falta:** a partilha para Instagram Stories continua a funcionar via **fallback** (folha de partilha do sistema com PNG + texto). O fluxo **nativo** (abrir diretamente o Instagram Stories) **não** é usado.
- **`BILLING_ENABLED` omitido ou `false`:** não há chamadas a checkout/portal Stripe; evita erros até billing estar configurado.
- **`FUNCTIONS_REGION` omitido:** usa-se `us-central1` para chamadas `cloud_functions` (billing, moderação, admin).

### Exemplos de comando

```bash
# Desenvolvimento com Instagram nativo (substituir pelo App ID real)
flutter run --dart-define=FB_APP_ID=1234567890123456

# Release APK com Instagram + billing ativo (exemplo)
flutter build apk --release \
  --dart-define=FB_APP_ID=1234567890123456 \
  --dart-define=BILLING_ENABLED=true \
  --dart-define=FUNCTIONS_REGION=us-central1
```

```bash
# iOS release (ajustar signing no Xcode / CI)
flutter build ios --release \
  --dart-define=FB_APP_ID=1234567890123456
```

**CI/CD:** definir as mesmas variáveis no pipeline (Codemagic, GitHub Actions, etc.) para não publicar builds de loja sem `FB_APP_ID` se quiserem o fluxo nativo Instagram.

**Segurança:** o **App ID** de cliente é tratado como público (como em SDKs). **Nunca** colocar **App Secret** ou chaves Stripe no código Dart — apenas em servidor / Cloud Functions (ver [`functions/README.md`](../functions/README.md)).

---

## 3. Instagram / Meta (Facebook App ID)

1. Criar ou usar uma app no [Meta for Developers](https://developers.facebook.com/) com o produto **Instagram** / **Sharing to Stories** conforme a [documentação atual](https://developers.facebook.com/docs/instagram/sharing-to-stories/).
2. Copiar o **Facebook App ID** (número) e injetá-lo como `FB_APP_ID` no build (secção 2).
3. O repositório já inclui:
   - **iOS:** `LSApplicationQueriesSchemes` para `instagram` e `instagram-stories` em `Info.plist`.
   - **Android:** `FileProvider`, `<queries>` para `com.instagram.android`, intent `com.instagram.share.ADD_TO_STORY`.

Revalidar após mudanças de política da Meta (ver notas em [ARCHITECTURE.md](ARCHITECTURE.md) — secção “Partilha social / Instagram Stories”).

---

## 4. Firebase (produção)

**Checklist rápido — `firebase deploy` vs lojas:** `npx -y firebase-tools@latest deploy` na raiz (ver [`firebase.json`](../firebase.json)) publica **Hosting** (estáticos em `hosting/public`), **Cloud Functions**, **regras e índices Firestore** e **regras Storage** — não envia binários iOS/Android. Para TestFlight, App Store e Google Play, ver [secção 7](#7-assinatura-e-publicação-nas-lojas-resumo).

| Ação | Comando / nota |
|------|----------------|
| Deploy de regras Firestore e Storage | `firebase deploy --only firestore:rules,storage` (e índices se necessário: `firestore:indexes`) |
| Validar permissões | Garantir que fluxos principais não devolvem `PERMISSION_DENIED` (ver [DEVICE_TESTING.md](DEVICE_TESTING.md)) |
| **`permission-denied` ao enviar carta** | Regras em `firestore.rules` (cartas, `users`, `badgeUnlocks`) devem estar deployadas e alinhadas ao repo; ver [TROUBLESHOOTING.md](TROUBLESHOOTING.md) §1 |
| **`systemConfig/app`** | Documento de flags remotas: `reportsEnabled`, `aiModerationEnabled`, `aiModerationFailClosed`, etc. Criar/editar na consola ou Admin SDK (o cliente não escreve). Ver [ARCHITECTURE.md](ARCHITECTURE.md) (secção “Config remota”). |

### Domínio personalizado

O domínio **`openwhen.life`** está registado na **Cloudflare** (DNS gerido lá) e conectado ao **Firebase Hosting**. Serve as páginas públicas (`privacy.html`, `terms.html`), o `assetlinks.json` (Android App Links) e resolve deep links (`/letter/...`, `/capsule/...`). Se necessário reconfigurar: Firebase Console → Hosting → Custom domain; Cloudflare → DNS → registos CNAME/A conforme instruções do Firebase.

**Emails:** 7 endereços do domínio (`privacy@`, `privacidade@`, `suporte@`, `dpo@`, `juridico@`, `info@`, `noreply@`) estão configurados via **Cloudflare Email Routing** e redirecionam para `y.m.lima19@gmail.com`. O `noreply@openwhen.life` é também o remetente padrão do SendGrid (Cloud Functions). Configuração: Cloudflare Dashboard → Email → Email Routing → Custom addresses.

Detalhes de projeto, CLI e emuladores: [README.md](../README.md#firebase-configuration).

### Firestore — custo e padrões

| Área | Nota |
|------|------|
| **Feed público** | Query com `limit` + janela em `openedAt` ([`feed_config.dart`](../lib/core/constants/feed_config.dart)); evita leituras globais ilimitadas. **Explorar:** primeira página em stream + mais páginas com `get()` + `startAfter` ao fazer scroll (custo por página extra). **Destaques:** mesma query limitada; ordenação por engajamento só no cliente, com teto de documentos. **Seguindo:** até **ceil(n/10)** queries/listeners por atualização (n = contas seguidas), por limite `whereIn` do Firestore — monitorizar em contas com muitos follows. |
| **Busca (lista de utilizadores)** | [`UserSearchService`](../lib/core/user_search/user_search_service.dart) — **não** há `get()` na coleção `users` para pesquisa; usa queries com `limit` (prefixo em `username` + `searchTokens` com `array-contains`). **Até ~abril/2026** o cliente carregava todos os documentos de `users` — ver [`CHANGELOG.md`](CHANGELOG.md). Seguir/Seguindo na tela Buscar: leituras em **batch** (`whereIn` em chunks), não um listener por linha. Pull-to-refresh com throttle (~3 s). Utilizadores sem `searchTokens` (dados antigos) continuam encontráveis por prefixo de `@username` até guardarem o perfil. |
| **Exportação (Pro)** | Cartas apenas onde o utilizador é remetente ou destinatário e `status == opened`; links `musicUrl` validados com allowlist ([`music_url.dart`](../lib/shared/utils/music_url.dart)). |

---

## 5. Cloud Functions — billing (Stripe) e moderação por IA

- **Stripe:** variáveis de **runtime** no Google Cloud (tabela em **[`functions/README.md`](../functions/README.md)**). No **cliente**, billing só com `--dart-define=BILLING_ENABLED=true` quando Stripe e funções estiverem prontos.
- **Descrição do produto para onboarding Stripe (KYC):** texto curto/long em inglês (e referência em PT) em **[`planning/BUSINESS.md`](BUSINESS.md)** — secção *“Texto para onboarding Stripe”* — alinhado a assinaturas (tiers **Amanhã** / **Brisa** / **Horizonte**), Checkout + Portal, e serviços digitais apenas.
- **Moderação por IA:** `OPENAI_API_KEY` e opcionalmente `MODERATION_PROVIDER` nas mesmas Functions; o cliente chama `moderateContent` quando `aiModerationEnabled` é `true` em **`systemConfig/app`**. Sem chave, o servidor aplica fallback conforme `aiModerationFailClosed` e regista incidentes em `moderationIncidents`. Superadmin vê provedor e estado das credenciais via `adminGetModerationInfo` (app **Configurações → Moderação**). Detalhes: [ARCHITECTURE.md](ARCHITECTURE.md), [functions/README.md](../functions/README.md).
- **Região:** alinhar `FUNCTIONS_REGION` no build Flutter com a região deployada (`us-central1` por defeito).

### SendGrid — webhook de email bounce

Para que o app receba notificações de bounce/dropped dos emails de convite para destinatários externos:

1. ✅ **Instalar dependência:** `cd functions && npm install @sendgrid/eventwebhook`
2. ✅ **Secrets Firebase (Functions v2):**
   - `firebase functions:secrets:set SENDGRID_API_KEY` — migrado de `.env` para Secret Manager (2026-04-11). **Atenção:** `SENDGRID_API_KEY` **não pode** estar em `functions/.env` e no Secret Manager ao mesmo tempo — Cloud Run rejeita com "Secret environment variable overlaps non secret environment variable".
   - `firebase functions:secrets:set SENDGRID_WEBHOOK_VERIFICATION_KEY` — copiar do painel SendGrid (passo 4)
3. ✅ **Deploy:** `firebase deploy --only functions`
4. ✅ **Painel SendGrid** → Settings → Mail Settings → Event Webhook:
   - Nome: "OpenWhen Email Events"
   - URL: `https://us-central1-openwhen-923f5.cloudfunctions.net/onSendGridWebhook`
   - Eventos: Bounced, Dropped, Deferred, Delivered
   - **Signed Event Webhook** habilitado (verification key copiada para o passo 2)
   - Webhook ID: `a25e23d6-27fd-4b54-bca3-e82e7857cb43`
5. ✅ **Deploy rules:** `firebase deploy --only firestore:rules` (campos imutáveis protegidos)
6. ✅ **`preferredLanguage`:** campo sincronizado com Firestore via `locale_provider.dart` quando o utilizador muda o idioma; incluído na criação de conta. Webhook faz fallback: `preferredLanguage` → `language` (2 chars) → `"en"`.

Cloud Functions envolvidas: `onSendGridWebhook` (webhook HTTP), `onLetterCreatedSendExternalInviteEmail` (trigger Firestore), `resendExternalInviteEmail` (callable com rate limiting). Detalhes: [ARCHITECTURE.md](ARCHITECTURE.md) (secção "Entrega de email externo") e [`EMAIL_VALIDATION_PLAN.md`](EMAIL_VALIDATION_PLAN.md).

### Nota (futuro): filas e workers

Não é requisito atual. Se um dia aparecerem **trabalhos pesados ou longos**, **filas com requisitos fortes** (ordem, retries elaborados, throughput alto) ou **integração fora do ecossistema Firebase/GCP**, vale relembrar: no Google Cloud o caminho habitual é **Pub/Sub** + subscribers (Cloud Functions ou Cloud Run), **Cloud Tasks** para tarefas adiadas com retries, e **Cloud Scheduler** para cron. **RabbitMQ** (ou outra fila AMQP) e **workers** dedicados só fazem sentido quando houver necessidade explícita ou equipa/infra já orientada a isso — acrescentam operação e integração extra face ao stack atual.

---

## 6. Notificações push (FCM)

- **iOS:** conta Apple Developer, capability **Push Notifications** no Xcode, APNs configurado no Firebase Console (ver [DEVICE_TESTING.md](DEVICE_TESTING.md)).
- **Android:** `POST_NOTIFICATIONS` em Android 13+; testar em dispositivo real.

---

## 7. Assinatura e publicação nas lojas (resumo)

| Plataforma | O que verificar |
|------------|-----------------|
| **Android** | Keystore de release, `applicationId` / `namespace` em `build.gradle.kts`, Play Console (ficheiros de política, screenshots). |
| **iOS** | Certificados e perfis no Apple Developer, **Signing & Capabilities** no Xcode, App Store Connect. |

Comandos específicos de build seguem a documentação oficial do Flutter; as variáveis `dart-define` da secção 2 aplicam-se a **todos** os `flutter build` de release.

---

## 8. Checklist de produção (completa)

Use esta lista como roteiro antes de submeter builds às lojas ou de declarar o ambiente “produção”. Detalhes e comandos estão nas secções [1](#1-ficheiros-obrigatórios-no-cliente-firebase)–[7](#7-assinatura-e-publicação-nas-lojas-resumo); regressão em dispositivo: [DEVICE_TESTING.md](DEVICE_TESTING.md); critérios MVP: [MVP_CHECKLIST.md](MVP_CHECKLIST.md).

**Ordem sugerida:** A (identidade e build) → B (segredos e ficheiros) → C (Firebase e backend) → D (flags de produto) → E (push) → F (lojas e conformidade) → G (QA final).

```mermaid
flowchart LR
  A[IdentidadeBuild] --> B[SegredosFicheiros]
  B --> C[FirebaseBackend]
  C --> D[FlagsProduto]
  D --> E[PushPermissoes]
  E --> F[LojasConformidade]
  F --> G[QARelease]
```

### A. Identidade e build

- [ ] **Bundle ID** (iOS) e **`applicationId`** / `namespace` (Android) finais; registados no Firebase, App Store Connect e Google Play Console.
- [ ] Após alterar identificadores: regenerar **`firebase_options.dart`** e ficheiros nativos (`google-services.json`, `GoogleService-Info.plist`) com [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/) alinhado ao projeto de produção (ver secção [1](#1-ficheiros-obrigatórios-no-cliente-firebase)).
- [ ] **Keystore** de release Android configurado e `signingConfigs` de **release** a apontar para esse keystore (não usar apenas a assinatura debug em builds de loja; ver secção [7](#7-assinatura-e-publicação-nas-lojas-resumo)).
- [ ] **`pubspec.yaml`:** `version` (`nome+build`) atualizado para a submissão (version code Android / build number iOS).
- [ ] Comandos **`flutter build … --release`** incluem todos os `--dart-define` necessários (secção [2](#2-variáveis-de-build-flutter---dart-define)); CI/CD com as mesmas variáveis.

### B. Segredos e ficheiros locais

- [ ] `lib/firebase_options.dart`, `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist` presentes e alinhados ao **projeto Firebase de produção** (secção [1](#1-ficheiros-obrigatórios-no-cliente-firebase)).
- [ ] Nenhum **segredo** de servidor (Stripe secret, OpenAI, etc.) no código cliente ou no repositório público — apenas em Cloud Functions / ambiente seguro ([`functions/README.md`](../functions/README.md)).

### C. Firebase e backend

- [ ] `firebase deploy` de **Firestore rules**, **Storage rules** e **índices** (`firestore:indexes` se aplicável) validado em staging e repetido para produção (secção [4](#4-firebase-produção)).
- [ ] Documento **`systemConfig/app`** em Firestore criado/revisado (`reportsEnabled`, `aiModerationEnabled`, `aiModerationFailClosed`, etc.) conforme [ARCHITECTURE.md](ARCHITECTURE.md).
- [ ] **Cloud Functions:** variáveis de runtime (Stripe, moderação) configuradas no Google Cloud; `firebase deploy --only functions` após alterar envs quando necessário (secção [5](#5-cloud-functions--billing-stripe-e-moderação-por-ia)).

### D. Funcionalidades e flags de build

- [ ] **`FB_APP_ID`** definido nos builds que devem usar Instagram Stories **nativo**, ou decisão explícita de aceitar só o **fallback** (folha de partilha; secções [2](#2-variáveis-de-build-flutter---dart-define) e [3](#3-instagram--meta-facebook-app-id)).
- [ ] Se **billing** ativo: `BILLING_ENABLED=true`, `FUNCTIONS_REGION` igual à região deployada, envs Stripe nas Functions (secção [5](#5-cloud-functions--billing-stripe-e-moderação-por-ia)).
- [ ] Se **moderação por IA** ativa: `OPENAI_API_KEY` (e `MODERATION_PROVIDER` se não for o default) nas Functions; flags em `systemConfig/app` coerentes; deploy de functions após mudanças (secção [5](#5-cloud-functions--billing-stripe-e-moderação-por-ia)).

### E. Push e permissões

- [ ] **iOS:** capability **Push Notifications**, APNs ligado ao Firebase Console (secção [6](#6-notificações-push-fcm)).
- [ ] **Android 13+:** fluxo de permissão de notificações testado em dispositivo real (secção [6](#6-notificações-push-fcm)).

### F. Lojas e conformidade

- [ ] URLs de **política de privacidade** e **termos de utilização** prontas e indicadas nas fichas (Play Console e App Store Connect); texto de negócio/alinhamento em [BUSINESS.md](BUSINESS.md) se aplicável.
- [ ] **Google Play:** formulário Data safety, classificação de conteúdo, ícones e screenshots conforme políticas atuais.
- [ ] **App Store:** questionário de privacidade da app; rever **`Info.plist`**: textos de uso (câmera, localização, microfone, etc.) coerentes com o comportamento real; **`UIBackgroundModes`** apenas com modos efetivamente necessários (evita perguntas extra na revisão).

### G. QA antes do release

- [ ] Regressão em **dispositivos reais** iOS e Android conforme [DEVICE_TESTING.md](DEVICE_TESTING.md) (login, feed, cofre, cartas/cápsulas, localização, push, Instagram conforme build).
- [ ] Se aplicável ao release, critérios [MVP_CHECKLIST.md](MVP_CHECKLIST.md) verificados.

---

## 9. Histórico de alterações deste guia

- **2026-03:** secção [8](#8-checklist-de-produção-completa) expandida em checklist A–G (identidade/keystore, segredos, Firebase, flags, push, lojas, QA); diagrama de ordem sugerida; referências cruzadas a DEVICE_TESTING e MVP_CHECKLIST.
- **2026-03:** nota futura “filas e workers” (Pub/Sub, Cloud Tasks, RabbitMQ) na secção 5.
- **2026-03 (feed):** tabela “Firestore — custo” alargada com Explorar (paginação), Destaques (sort no cliente) e Seguindo (custo `ceil(n/10)`).
- **2026-03:** documento criado para consolidar `FB_APP_ID`, `BILLING_ENABLED`, `FUNCTIONS_REGION` e requisitos Firebase/lojas.
- **2026-03 (moderação IA):** secção 5 alargada (Stripe + moderação); Firestore `systemConfig/app`; checklist com IA; relações com ARCHITECTURE / functions README.
- **2026-04:** domínio `openwhen.life` (Cloudflare → Firebase Hosting) documentado na secção 4.
