# Comandos Flutter neste projeto

Projeto Flutter padrão; rode os comandos na raiz do repositório (onde está o `pubspec.yaml`).

## Essenciais

| Comando | Uso |
|--------|-----|
| `flutter pub get` | Baixa/atualiza dependências do `pubspec.yaml`. |
| `flutter run` | Compila e roda o app (escolhe o device ou usa o único disponível). |
| `flutter run -d <id>` | Roda em um device específico (veja o ID com `flutter devices`). |
| `flutter build apk` | Build de release Android. |
| `flutter build ios` | Build de release iOS (no macOS, com Xcode). |
| `flutter clean` | Limpa artefatos de build; útil se algo parecer “preso” no cache. |
| `flutter gen-l10n` | Regenera `lib/l10n/app_localizations*.dart` após editar ficheiros `.arb` (ver `l10n.yaml`). |

## Build / run com variáveis (`--dart-define`)

O projeto lê flags em **tempo de compilação** (não são comandos novos do Flutter — são argumentos ao `run` / `build`). Lista completa e notas de produção: [`planning/PRODUCTION.md`](planning/PRODUCTION.md).

| Variável | Obrigatória? | Uso típico neste projeto |
|----------|----------------|---------------------------|
| `FB_APP_ID` | Não | Instagram Stories nativo (Meta App ID). |
| `BILLING_ENABLED` | Não (default `false`) | Ativar checkout Stripe no cliente. |
| `FUNCTIONS_REGION` | Não (default `us-central1`) | Região das Cloud Functions: **billing**, **moderação** (`moderateContent`), **admin** — mesmo valor em [`lib/core/billing/firebase_functions_region.dart`](lib/core/billing/firebase_functions_region.dart). |

Exemplos:

```bash
# Desenvolvimento com Instagram + billing + região explícita
flutter run -d chrome \
  --dart-define=FB_APP_ID=1234567890123456 \
  --dart-define=BILLING_ENABLED=true \
  --dart-define=FUNCTIONS_REGION=us-central1
```

```bash
flutter build apk --release \
  --dart-define=FB_APP_ID=1234567890123456 \
  --dart-define=FUNCTIONS_REGION=us-central1
```

**Nota:** chaves de API (OpenAI, Stripe secret, etc.) não vão no `dart-define` — ficam nas **Cloud Functions** (runtime). O cliente só precisa de `FUNCTIONS_REGION` alinhado ao deploy.

## Qualidade e diagnóstico

| Comando | Uso |
|--------|-----|
| `flutter analyze` | Análise estática (lints do `analysis_options.yaml`). |
| `flutter test` | Roda testes em `test/`. |
| `dart format lib` | Formata o código em `lib/` (ou `dart format .` para o projeto todo). |
| `flutter doctor -v` | Verifica SDK, Xcode, Android toolchain, dispositivos, etc. |

## Dispositivos e dependências

| Comando | Uso |
|--------|-----|
| `flutter devices` | Lista emuladores, simuladores e aparelhos físicos. |
| `flutter pub outdated` | Mostra pacotes desatualizados. |
| `flutter pub upgrade` | Atualiza pacotes dentro dos limites do `pubspec`. |

## Durante o `flutter run`

No terminal onde o app está em execução:

- **`r`** — hot reload  
- **`R`** — hot restart  
- **`q`** — encerrar  

## Firebase (CLI separada)

Deploy de regras/hosting usa a [Firebase CLI](https://firebase.google.com/docs/cli) (`firebase deploy`), não o Flutter.

## Ajuda integrada

```bash
flutter help
flutter help run
```
