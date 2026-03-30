# OpenWhen — Checklist e configuração para produção

Este documento reúne **tudo o que precisa de estar definido** para compilar, publicar e operar o app em **modo produção**: ficheiros locais, variáveis de build (`dart-define`), Firebase, Meta/Instagram, billing opcional, assinaturas móveis e referências ao resto da documentação.

**Relacionado:** [README.md](../README.md) (Firebase, CLI), [DEVICE_TESTING.md](DEVICE_TESTING.md) (QA em dispositivo), [ARCHITECTURE.md](ARCHITECTURE.md) (stack e Instagram Stories), [functions/README.md](../functions/README.md) (Stripe e Cloud Functions).

---

## 1. Ficheiros obrigatórios (não versionados no remoto)

| Ficheiro | Função |
|----------|--------|
| `lib/firebase_options.dart` | Configuração FlutterFire (todas as plataformas). **Obrigatório** para correr o app. |
| `android/app/google-services.json` | Projeto Firebase Android. |
| `ios/Runner/GoogleService-Info.plist` | Projeto Firebase iOS. |

Sem estes ficheiros, o build ou o runtime Firebase falham. Obter com a equipa ou regenerar com [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/) alinhado ao projeto Firebase de produção.

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
- **`FUNCTIONS_REGION` omitido:** usa-se `us-central1` para chamadas `cloud_functions` (billing).

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

| Ação | Comando / nota |
|------|----------------|
| Deploy de regras Firestore e Storage | `firebase deploy --only firestore:rules,storage` (e índices se necessário: `firestore:indexes`) |
| Validar permissões | Garantir que fluxos principais não devolvem `PERMISSION_DENIED` (ver [DEVICE_TESTING.md](DEVICE_TESTING.md)) |

Detalhes de projeto, CLI e emuladores: [README.md](../README.md#firebase-configuration).

### Firestore — custo e padrões

| Área | Nota |
|------|------|
| **Feed público** | Query com `limit` + janela em `openedAt` ([`feed_config.dart`](../lib/core/constants/feed_config.dart)); evita leituras globais ilimitadas. **Explorar:** primeira página em stream + mais páginas com `get()` + `startAfter` ao fazer scroll (custo por página extra). **Destaques:** mesma query limitada; ordenação por engajamento só no cliente, com teto de documentos. **Seguindo:** até **ceil(n/10)** queries/listeners por atualização (n = contas seguidas), por limite `whereIn` do Firestore — monitorizar em contas com muitos follows. |
| **Busca (lista de utilizadores)** | Cada linha pode subscrever `follows` para o estado Seguir/Seguindo — até **N** listeners por ecrã; o pull-to-refresh tem **throttle** (~3 s). |
| **Exportação (Pro)** | Cartas apenas onde o utilizador é remetente ou destinatário e `status == opened`; links `musicUrl` validados com allowlist ([`music_url.dart`](../lib/shared/utils/music_url.dart)). |

---

## 5. Cloud Functions e billing (Stripe) — opcional até monetização

- Variáveis de **runtime** no Google Cloud (Stripe, webhook, etc.): tabela e deploy em **[`functions/README.md`](../functions/README.md)**.
- No **cliente Flutter**, billing só deve ser ativado com `--dart-define=BILLING_ENABLED=true` quando Stripe e funções estiverem configurados e testados.
- Região das funções: alinhar `FUNCTIONS_REGION` com a região real deployada.

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

## 8. Checklist rápido antes de “ir a produção”

- [ ] `firebase_options.dart`, `google-services.json`, `GoogleService-Info.plist` presentes e alinhados ao projeto Firebase de produção.
- [ ] `firebase deploy` das regras (e índices) validado.
- [ ] `FB_APP_ID` definido nos builds que devem abrir Instagram nativamente (ou aceite explícito de só fallback).
- [ ] Se billing ativo: `BILLING_ENABLED=true`, `FUNCTIONS_REGION` correto, variáveis em Cloud Functions (Stripe) configuradas.
- [ ] Push: APNs (iOS) e testes em dispositivo real ([DEVICE_TESTING.md](DEVICE_TESTING.md)).
- [ ] Assinatura release Android/iOS e metadados de loja preparados.

---

## 9. Histórico de alterações deste guia

- **2026-03 (feed):** tabela “Firestore — custo” alargada com Explorar (paginação), Destaques (sort no cliente) e Seguindo (custo `ceil(n/10)`).
- **2026-03:** documento criado para consolidar `FB_APP_ID`, `BILLING_ENABLED`, `FUNCTIONS_REGION` e requisitos Firebase/lojas.
