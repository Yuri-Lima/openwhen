# Comandos Flutter neste projeto

Projeto Flutter padrão; rode os comandos na raiz do repositório (onde está o `pubspec.yaml`).

**Baseline de SDK:** [`README.md`](README.md) (badges e pré-requisitos). Para o ambiente local: `flutter --version` (Dart mínimo no `pubspec.yaml`: `^3.11.1`).

## Essenciais

| Comando | Uso |
|--------|-----|
| `flutter pub get` | Baixa/atualiza dependências do `pubspec.yaml`. |
| `flutter run` | Compila e roda o app (escolhe o device ou usa o único disponível). |
| `flutter run -d <id>` | Roda em um device específico (veja o ID com `flutter devices`). |
| `flutter build apk` | Build de release Android. |
| `flutter build ios` | Build de release iOS (no macOS, com Xcode). |
| `flutter build ipa` | Gera um **.ipa** pronto para **TestFlight** / **App Store Connect** (só macOS + Xcode). Ver secção abaixo. |
| `flutter clean` | Limpa artefatos de build; útil se algo parecer “preso” no cache. |
| `flutter gen-l10n` | Regenera `lib/l10n/app_localizations*.dart` após editar ficheiros `.arb` (ver `l10n.yaml`). |

### Localização (`gen-l10n`)

- **Fonte de verdade:** edita apenas os `.arb` em `lib/l10n/`. O template principal é `app_pt_BR.arb` ([`l10n.yaml`](l10n.yaml)); **todas** as chaves novas devem existir nesse ficheiro e nos outros locales (`app_en.arb`, `app_es.arb`, `app_pt.arb`), senão o gerador omite getters ou ficas com desvios.
- **Não edites à mão** `app_localizations*.dart` — o próximo `flutter gen-l10n` ou `flutter pub get` (com `generate: true`) sobrescreve esses ficheiros.
- **Fluxo:** alterar `.arb` → `flutter gen-l10n` → commit em conjunto dos `.arb` e dos `.dart` gerados.
- **Verificar sincronização (opcional, CI ou local):** após `flutter pub get` e `flutter gen-l10n`, o working tree não deve ter diferenças em `lib/l10n/`; podes usar `git diff --exit-code -- lib/l10n/` para falhar o build se alguém tiver commitado `.dart` dessincronizados dos `.arb`.
| `dart run flutter_launcher_icons` | Regenera ícones do launcher Android (`mipmap-*`) e iOS (`AppIcon.appiconset`) a partir de `assets/branding/app_icon.png` (config em `pubspec.yaml`). Rode na raiz após alterar a arte-mestre. |

### `flutter build ipa` (iOS — pacote para a Apple)

Usa o **Xcode** por baixo dos panos para compilar o `Runner` e produzir um ficheiro **`.ipa`** (aplicação assinada) que podes enviar para a **App Store Connect** (via Xcode Organizer, **Transporter**, ou CI).

| Aspeto | Detalhe |
|--------|---------|
| **Plataforma** | Só **macOS**, com **Xcode** instalado e aceite da licença (`sudo xcodebuild -license` se necessário). |
| **Assinatura** | O projeto deve ter **Signing & Capabilities** correto no `ios/Runner.xcodeproj` (Team, bundle ID, perfis). O Flutter reutiliza essa configuração. |
| **Saída típica** | `build/ios/ipa/*.ipa` (nome costuma incluir o `CFBundleName` / app). |
| **vs `flutter build ios`** | `build ios` gera o **app** em `build/ios/iphoneos/`; **`build ipa`** empacota em **.ipa** para distribuição na Apple. |
| **Versão** | `version` em `pubspec.yaml` → **CFBundleShortVersionString**; **build number** → número de build (incrementa a cada upload para a mesma versão na App Store Connect). |

Comandos úteis:

```bash
# Release padrão (adequado para TestFlight / submissão)
flutter build ipa --release --dart-define-from-file=config/dart_defines.json
```

Opções frequentes (ver `flutter build ipa -h`):

- **`--export-options-plist=<caminho>`** — ficheiro plist com método de exportação (`app-store`, `ad-hoc`, `development`, etc.), team ID, etc., se precisares de controlar o **export** além do default.
- **`--build-name` / `--build-number`** — sobrescrever versão/build sem editar o `pubspec.yaml` para esse build.

Depois do build: envia o **.ipa** para o App Store Connect (Xcode **Window → Organizer**, app **Transporter**, ou `xcrun altool` / API). Documentação Apple: [Upload builds](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds/).

## Build / run com variáveis (`--dart-define-from-file`)

O projeto centraliza todas as flags de compilação em ficheiros JSON dentro de `config/`. Lista completa e notas de produção: [`planning/PRODUCTION.md`](planning/PRODUCTION.md).

### Ficheiros de configuração

| Ficheiro | Ambiente | Versionado? |
|----------|----------|-------------|
| `config/dart_defines.json` | **Produção** | Não (`.gitignore`) |
| `config/dart_defines_dev.json` | **Desenvolvimento** | Não (`.gitignore`) |
| `config/dart_defines.example.json` | Template para novos devs | **Sim** |

Para começar, copia o template e preenche os valores:
```bash
cp config/dart_defines.example.json config/dart_defines.json
cp config/dart_defines.example.json config/dart_defines_dev.json
```

### Variáveis disponíveis

| Variável | Tipo | Uso neste projeto |
|----------|------|-------------------|
| `FB_APP_ID` | `String` | Instagram Stories nativo (Meta App ID). |
| `BILLING_ENABLED` | `bool` | Ativar checkout Stripe no cliente. |
| `FUNCTIONS_REGION` | `String` | Região das Cloud Functions: **billing**, **moderação** (`moderateContent`), **admin**. |
| `SKIP_AI_MODERATION` | `bool` | Debug: pula a Cloud Function `moderateContent` nos comentários. |

### Exemplos

```bash
# Desenvolvimento (com SKIP_AI_MODERATION=true)
flutter run --dart-define-from-file=config/dart_defines_dev.json

# Release iOS (produção)
flutter build ios --release --dart-define-from-file=config/dart_defines.json

# Release Android (produção)
flutter build apk --release --dart-define-from-file=config/dart_defines.json
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

## iOS / CocoaPods

Quando os pods do iOS ficam desatualizados, o build falha com erros de linking ou versões incompatíveis (frequente após atualizar o `pubspec.yaml` com novos plugins Firebase ou mudar de versão do SDK). Corre isto na raiz do projeto:

```bash
cd ios && pod repo update && pod update Firebase && cd ..
```

| Passo | O que faz |
|-------|-----------|
| `cd ios` | Entra na pasta `ios/` onde está o `Podfile` e o workspace Xcode. |
| `pod repo update` | Atualiza o **spec repo** local do CocoaPods (índice de todos os pods disponíveis e suas versões). Sem isto, o `pod update` pode não encontrar versões recentes. |
| `pod update Firebase` | Re-resolve e atualiza **apenas** os pods do grupo Firebase (`FirebaseAuth`, `FirebaseFirestore`, `FirebaseStorage`, etc.) para as últimas versões compatíveis com o `Podfile.lock`. |
| `cd ..` | Volta à raiz do projeto para continuares com `flutter run` / `flutter build`. |

> **Dica:** se quiseres atualizar **todos** os pods (não só Firebase), troca `pod update Firebase` por `pod update` (sem argumento).

## Durante o `flutter run`

No terminal onde o app está em execução:

- **`r`** — hot reload  
- **`R`** — hot restart  
- **`q`** — encerrar  

## Firebase (CLI separada)

Deploy de regras/hosting usa a [Firebase CLI](https://firebase.google.com/docs/cli) (`firebase deploy`), não o Flutter.

| Comando | Uso |
|--------|-----|
| `firebase deploy --only hosting` | Publica as páginas web estáticas (`hosting/public/`) — inclui `privacy.html`, `terms.html` e `.well-known/`. |
| `firebase deploy --only firestore:rules,storage` | Deploy das regras Firestore + Storage. |
| `firebase deploy --only functions` | Deploy das Cloud Functions (`functions/`). |
| `firebase deploy` | Deploy de tudo (hosting + rules + functions). |

## Ajuda integrada

```bash
flutter help
flutter help run
```
