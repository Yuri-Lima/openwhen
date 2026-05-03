# Plano de Implementação — Consentimento de Analytics (EU/UK)

**Data:** 2026-05-02
**Status:** Aprovação pendente
**Prioridade:** Alta (compliance legal)

---

## 1. Contexto Legal

### Directiva ePrivacy (2002/58/CE) + UK PECR
O Firebase Analytics usa cookies e identificadores persistentes (App Instance ID) para rastrear eventos. Na UE e no UK, a recolha destes dados requer **consentimento prévio explícito** (opt-in) do utilizador antes de qualquer processamento. Isto aplica-se a:
- Firebase Analytics (eventos, screen views, user properties)
- Firebase Crashlytics (não afetado — base legal de "interesse legítimo" para estabilidade)

### Problema Atual
`analytics_service.dart` inicializa `FirebaseAnalytics.instance` incondicionalmente. No momento em que o Firebase é inicializado em `main.dart` (linha 83), o SDK já começa a recolher dados — sem qualquer verificação de consentimento ou detecção de jurisdição.

### Requisito Legal
1. Analytics **desativado por defeito** para utilizadores EU/EEA/UK
2. Banner de consentimento **antes** de qualquer recolha
3. Opção de revogar o consentimento a qualquer momento (Settings)
4. Registo auditável do consentimento (data + escolha)

---

## 2. Decisões de Design

| Decisão | Escolha | Razão |
|---------|---------|-------|
| Complexidade do banner | **Simples** (Aceitar / Recusar) | Apenas analytics; sem categorias múltiplas |
| Storage | **SharedPreferences + Firestore** | Leitura rápida no arranque + persistência cross-device |
| Detecção de jurisdição | Reutilizar `age_verification.dart` | Set `_euEeaUkCountries` já tem os 31 países |
| Scope | Apenas Firebase Analytics | Crashlytics usa base legal diferente (interesse legítimo) |
| Comportamento fora EU/UK | Analytics ativado automaticamente, sem banner | COPPA e LGPD não exigem consentimento para analytics anonimizado |

---

## 3. Arquitetura

### Ficheiros a criar (3 novos)

| Ficheiro | Responsabilidade |
|----------|-----------------|
| `lib/core/consent/analytics_consent_provider.dart` | Riverpod Notifier + SharedPreferences + sync Firestore |
| `lib/core/consent/analytics_consent_banner.dart` | Widget do banner (overlay na base do ecrã) |
| `lib/core/consent/consent_constants.dart` | Enum `AnalyticsConsentStatus` + chaves SharedPrefs |

### Ficheiros a modificar (5 existentes)

| Ficheiro | Alteração |
|----------|-----------|
| `lib/core/services/analytics_service.dart` | Adicionar `setEnabled(bool)` e guard em todos os métodos |
| `lib/core/utils/age_verification.dart` | Exportar `isEuEeaUkJurisdiction()` (função pública) |
| `lib/features/auth/models/app_user.dart` | Adicionar campo `analyticsConsent` (String?, nullable) |
| `lib/main.dart` | Desativar analytics no arranque; inicializar consent |
| `lib/features/profile/presentation/screens/settings_screen.dart` | Toggle de analytics nas definições de privacidade |

### Chaves i18n (4 ficheiros .arb × 4 chaves)

| Chave | EN |
|-------|-----|
| `analyticsConsentTitle` | "Help us improve" |
| `analyticsConsentBody` | "We use anonymous analytics to understand how the app is used. No personal data is collected. You can change this anytime in Settings." |
| `analyticsConsentAccept` | "Accept" |
| `analyticsConsentDecline` | "No thanks" |
| `settingsAnalyticsToggle` | "Usage analytics" |
| `settingsAnalyticsDescription` | "Allow anonymous usage data to help improve the app" |

---

## 4. Fluxo Detalhado

### 4.1 Arranque do App (`main.dart`)

```
Firebase.initializeApp()
  ↓
FirebaseAnalytics.setAnalyticsCollectionEnabled(false)  ← NOVO: desativar imediatamente
  ↓
runApp() com ProviderScope
```

**Regra:** analytics começa **sempre desativado**. A ativação só acontece depois de verificar o consentimento.

### 4.2 Primeira vez (sem consent guardado)

```
ConsentProvider.build()
  ↓
Ler SharedPreferences('analytics_consent_status')
  ↓ (null — primeira vez)
Verificar jurisdição via _extractCountryCode()
  ↓
EU/EEA/UK? → mostrar banner na primeira navegação
Resto?     → auto-grant + enable analytics + guardar 'granted'
```

### 4.3 Banner (EU/EEA/UK)

Banner não-intrusivo na base do ecrã (não bloqueia a app). Dois botões:
- **"Aceitar"** → gravar `granted` + `setAnalyticsCollectionEnabled(true)` + sync Firestore
- **"Recusar"** → gravar `denied` + analytics permanece desativado + sync Firestore

### 4.4 Visitas subsequentes

```
ConsentProvider.build()
  ↓
Ler SharedPreferences('analytics_consent_status')
  ↓ ('granted' | 'denied')
Aplicar diretamente: enable(true) ou manter disabled
  ↓
Sem banner
```

### 4.5 Revogar/alterar consentimento (Settings)

Na tela de Settings, secção Privacidade:
- Toggle "Usage analytics" (ON/OFF)
- Visível **apenas** para utilizadores EU/EEA/UK (para os outros, analytics está sempre ativo e não há toggle)
- Ao alterar: atualiza SharedPrefs + Firestore + chama `setAnalyticsCollectionEnabled()`

---

## 5. Implementação por Ficheiro

### 5.1 `consent_constants.dart`

```dart
enum AnalyticsConsentStatus {
  pending,   // nunca respondeu
  granted,   // aceitou analytics
  denied,    // recusou analytics
}

const kAnalyticsConsentKey = 'analytics_consent_status';
```

### 5.2 `analytics_consent_provider.dart`

Riverpod `Notifier<AnalyticsConsentStatus>` seguindo o padrão de `locale_provider.dart`:
- `build()` → estado inicial `pending`, carrega de SharedPrefs via `Future.microtask`
- `setConsent(AnalyticsConsentStatus)` → atualiza state + SharedPrefs + Firestore + `AnalyticsService.setEnabled()`
- `_syncToFirestore()` → best-effort write de `analyticsConsent` e `analyticsConsentDate` para `users/{uid}`

### 5.3 `age_verification.dart` — nova função pública

```dart
/// Returns true if the device locale indicates an EU/EEA/UK jurisdiction.
bool isEuEeaUkJurisdiction([String? overrideLocale]) {
  final country = _extractCountryCode(overrideLocale);
  if (country == null) return true; // fail-safe: assume EU
  return _euEeaUkCountries.contains(country);
}
```

**Nota:** `_extractCountryCode` já existe mas é privada. Precisamos apenas adicionar a função wrapper pública. O fail-safe é `true` (assume EU) — é mais seguro legalmente mostrar o banner a mais do que a menos.

### 5.4 `analytics_service.dart` — alterações

```dart
class AnalyticsService {
  static final _analytics = FirebaseAnalytics.instance;
  static bool _enabled = false;  // NOVO: guard

  /// Called once at app startup — disables collection by default.
  static Future<void> disableByDefault() async {
    _enabled = false;
    await _analytics.setAnalyticsCollectionEnabled(false);
  }

  /// Called when consent is determined.
  static Future<void> setEnabled(bool enabled) async {
    _enabled = enabled;
    await _analytics.setAnalyticsCollectionEnabled(enabled);
  }

  // Guard em todos os métodos:
  static Future<void> logLogin({String method = 'email'}) async {
    if (!_enabled) return;
    await _analytics.logLogin(loginMethod: method);
  }
  // ... (mesmo padrão para os 18+ métodos existentes)
}
```

### 5.5 `app_user.dart` — novo campo

```dart
/// Analytics consent: 'granted' | 'denied' | null (legacy/pending).
final String? analyticsConsent;

/// When the user gave or changed analytics consent.
final DateTime? analyticsConsentDate;
```

Nullable para retrocompatibilidade. Adicionado a `fromFirestore()` e `toFirestore()`.

### 5.6 `main.dart` — arranque seguro

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(...);
  await AnalyticsService.disableByDefault();  // ← NOVO: antes de tudo
  // ... resto igual
}
```

### 5.7 `analytics_consent_banner.dart` — widget

Banner fixo na base, sobreposto ao conteúdo (não modal):
- `Container` com fundo sólido, border-top, padding
- Texto descritivo + 2 botões (Aceitar / Recusar)
- Mostrado via `Overlay` ou `Stack` no `MyApp` quando `consentStatus == pending && isEuEeaUk`
- Animação slide-up + fade-out ao responder

### 5.8 `settings_screen.dart` — toggle

Na secção de privacidade existente, adicionar `SwitchListTile`:
- Título: `settingsAnalyticsToggle`
- Subtítulo: `settingsAnalyticsDescription`
- Valor: `consentStatus == granted`
- `onChanged` → `consentProvider.setConsent(granted | denied)`
- Visibilidade: apenas se `isEuEeaUkJurisdiction()`

---

## 6. Campos Firestore

No documento `users/{uid}`, adicionados:

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `analyticsConsent` | `string?` | `'granted'` \| `'denied'` \| `null` |
| `analyticsConsentDate` | `Timestamp?` | Data da última escolha |

**Firestore Rules:** estes campos devem ser **write-only pelo cliente** (o utilizador pode atualizar o seu próprio consentimento). Leitura permitida apenas pelo próprio utilizador e por admin.

---

## 7. Ordem de Implementação

| Etapa | Ficheiros | Dependências |
|-------|-----------|-------------|
| 1 | `consent_constants.dart` | — |
| 2 | `age_verification.dart` (adicionar `isEuEeaUkJurisdiction`) | — |
| 3 | `analytics_service.dart` (guard + `disableByDefault` + `setEnabled`) | — |
| 4 | `app_user.dart` (campos consent) | — |
| 5 | `analytics_consent_provider.dart` | Etapas 1–3 |
| 6 | `main.dart` (chamar `disableByDefault`) | Etapa 3 |
| 7 | Chaves i18n (4 .arb + gen-l10n) | — |
| 8 | `analytics_consent_banner.dart` | Etapas 5, 7 |
| 9 | `settings_screen.dart` (toggle) | Etapas 2, 5, 7 |
| 10 | Testes manuais + verificação | Tudo |

---

## 8. Pontos de Atenção

1. **Fail-safe:** se `_extractCountryCode` retornar `null` (locale não parseável), assume EU e mostra banner. É preferível pedir consentimento a mais do que a menos.

2. **Crashlytics não é afetado:** base legal de "interesse legítimo" para garantir estabilidade do app. Não precisa de consentimento.

3. **Retrocompatibilidade:** utilizadores existentes que nunca viram o banner terão `analyticsConsent: null`. Na próxima abertura do app, o banner aparecerá (se EU/UK) ou analytics será auto-granted (se não-EU).

4. **Firebase Analytics automatic events:** mesmo com `setAnalyticsCollectionEnabled(false)`, convém verificar se `firebase_analytics` tem `analytics_collection_deactivated` no `GoogleService-Info.plist` para garantir que o SDK não envia `first_open` antes do código Dart executar.

5. **Timing no arranque:** `setAnalyticsCollectionEnabled(false)` é chamado em `main()` **antes** de `runApp()`, minimizando a janela em que o SDK poderia enviar eventos automáticos.

6. **App Tracking Transparency (iOS):** este plano não cobre ATT (`requestTrackingAuthorization`). Firebase Analytics com `setAnalyticsCollectionEnabled(false)` não requer ATT. Se no futuro integrares SDKs de publicidade, ATT será necessário como etapa adicional.
