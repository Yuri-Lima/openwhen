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
