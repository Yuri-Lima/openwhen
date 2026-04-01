# Baseline de performance (OpenWhen)

Use este guia para **registrar métricas antes e depois** de alterações de lazy load, code splitting ou otimizações de Firestore.

**O que está implementado** (código + desenho): secção *Performance e carregamento diferido* em [`ARCHITECTURE.md`](ARCHITECTURE.md) — `deferred_screens.dart`, `letter_export_deferred.dart`, cofre por aba visível.

## Web — tamanho do bundle

Após `flutter build web --release`:

- Listar artefactos principais: `ls -la build/web/*.js` (ou `main.dart.js` e ficheiros `*.part.js` gerados pelo compiler com deferred imports).
- Anotar o tamanho em bytes do entry e de cada chunk deferido (comparar entre commits).

## Web / mobile — primeiro frame

- **Flutter DevTools** → Performance → timeline: tempo até primeiro frame útil após cold start.
- Opcional: `flutter run --profile` e observar `FrameTiming` no DevTools.

## Firestore — listeners ao abrir o Cofre

- **Firebase Console** → Firestore → Usage (agregado; não mostra por ecrã).
- Para depuração local: temporariamente registar em `debugPrint` quando `StreamBuilder` subscreve (ou usar emulador + logs de regras).

**Heurística esperada:** com abas do cofre lazy, ao abrir só a aba visível devem existir queries/listeners dessa aba (não das três em simultâneo).

## Firestore — busca de utilizadores

- **Antes (~abril/2026):** a tela Buscar, convites em cápsula coletiva e busca de destinatário na carta usavam `collection('users').get()` — leitura **O(N)** no total de utilizadores por ação.
- **Agora:** [`UserSearchService`](../lib/core/user_search/user_search_service.dart) — no máximo **~2** queries indexadas por pesquisa (prefixo `username` + `searchTokens`), cada uma com **limit** (30); ver [`ARCHITECTURE.md`](ARCHITECTURE.md) e [`CHANGELOG.md`](CHANGELOG.md).

## Registo sugerido

| Data | Commit | main.dart.js (bytes) | Chunks deferidos (nomes + bytes) | Notas |
|------|--------|------------------------|-----------------------------------|-------|
|      |        |                        |                                   |       |
