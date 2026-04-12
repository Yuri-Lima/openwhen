# OpenWhen — Plano de Implementação: Moderação de Cartas e Cápsulas

### Criado: 12 de abril de 2026 · Implementado: 12 de abril de 2026

**Objetivo:** Moderação de conteúdo em cartas e cápsulas via IA antes do lançamento na Google Play Store.

**Decisão:** Sem filtro lexical (Camada 1) em cartas e cápsulas. A moderação é feita **exclusivamente pela IA (OpenAI Moderation API) no momento do envio**. Thresholds como constantes de compilação em `dart_defines.json` (zero custo runtime).

**Referências:** [CONTENT_MODERATION.md](CONTENT_MODERATION.md), [ARCHITECTURE.md](ARCHITECTURE.md), [MVP_CHECKLIST.md](MVP_CHECKLIST.md).

---

## Estado — Implementação concluída ✅

### Ficheiros criados

| Ficheiro | Descrição |
|----------|-----------|
| `lib/core/moderation/send_moderation_helper.dart` | Helper centralizado: chama Cloud Function, classifica severity usando thresholds de `dart_defines.json`, retorna `ModerationDecision` |

### Ficheiros alterados

| Ficheiro | Alteração |
|----------|-----------|
| `functions/src/moderation/moderate_content.ts` | Adicionado cálculo + retorno de `maxScore` (max dos categoryScores do OpenAI) |
| `lib/core/moderation/moderation_functions_service.dart` | `ModerationCallResult` agora parseia `maxScore` (double?) |
| `lib/features/letters/data/letter_send_step.dart` | Adicionado `moderation` ao enum (primeiro passo do envio) |
| `lib/features/letters/presentation/screens/write_letter_screen.dart` | Bloco de moderação IA em `_saveLetter()` antes de qualquer escrita Firestore |
| `lib/features/capsules/presentation/screens/create_capsule_screen.dart` | Bloco de moderação IA em `_saveCapsule()` antes do `.set()` |
| `lib/l10n/app_pt_BR.arb` | 11 strings de moderação (carta + cápsula) |
| `lib/l10n/app_pt.arb` | 11 strings de moderação (PT-PT) |
| `lib/l10n/app_en.arb` | 11 strings de moderação (EN) |
| `lib/l10n/app_es.arb` | 11 strings de moderação (ES) |
| `config/dart_defines.json` | `MODERATION_WARNING_THRESHOLD` + `MODERATION_BLOCK_THRESHOLD` |
| `config/dart_defines_dev.json` | Idem |
| `config/dart_defines.example.json` | Idem |

---

## Arquitectura

### Fluxo de envio (carta e cápsula)

```
Utilizador clica "Enviar"
  │
  ├─ Validações locais (título, mensagem, destinatário, etc.)
  ├─ Prompt de localização/proximidade
  │
  ├─ ── MODERAÇÃO IA ──────────────────────────────
  │   │
  │   ├─ Verificar config: aiModerationEnabled? SKIP_AI_MODERATION?
  │   │   └─ Se desativado → ModerationDecision.skipped → prossegue
  │   │
  │   ├─ Chamar Cloud Function `moderateContent` via CallableQueue
  │   │   └─ Servidor: OpenAI v1/moderations → retorna flagged + maxScore
  │   │
  │   └─ Classificar no cliente (thresholds de dart_defines.json):
  │       ├─ maxScore < 0.40 → allowed → prossegue
  │       ├─ 0.40 ≤ maxScore < 0.70 → warning → dialog "Revisar / Enviar assim mesmo"
  │       ├─ maxScore ≥ 0.70 OU flagged → blocked → dialog bloqueio
  │       └─ Exceção + failClosed → unavailable → SnackBar
  │
  ├─ Upload de voz (se aplicável)
  ├─ Carregar perfil do remetente
  ├─ Verificar amizade
  └─ Salvar no Firestore (commitLetterSend / .set)
```

### Thresholds (compile-time)

| Variável | Default | Significado |
|----------|---------|-------------|
| `MODERATION_WARNING_THRESHOLD` | `0.40` | Score ≥ este → dialog de aviso (utilizador decide) |
| `MODERATION_BLOCK_THRESHOLD` | `0.70` | Score ≥ este OU `flagged` → bloqueio |

Definidos em `config/dart_defines.json` e lidos via `double.fromEnvironment()` — constantes de compilação, zero custo em runtime.

### Decisões de design

| Decisão | Escolha | Motivo |
|---------|---------|--------|
| Sem filtro lexical em cartas/cápsulas | IA apenas | Decisão do Yuri — evita falsos positivos |
| Thresholds em dart_defines | Compile-time | Performance máxima; ajustável com rebuild |
| Warning: utilizador decide | Dialog com 2 opções | Respeitar agência do utilizador |
| Human review queue | Só comentários (v1) | Cartas são privadas (remetente → destinatário) |
| Moderação cápsulas coletivas | Só texto do criador (v1) | multiContributor é futuro |

---

## Ação manual necessária (Yuri)

1. **Regenerar l10n:** Executar no terminal do Cursor:
   ```bash
   flutter gen-l10n
   ```

2. **Deploy Cloud Functions** (se OPENAI_API_KEY já estiver configurada):
   ```bash
   firebase deploy --only functions
   ```

3. **Se OPENAI_API_KEY não estiver configurada:**
   ```bash
   firebase functions:secrets:set OPENAI_API_KEY
   firebase deploy --only functions
   ```

---

## Testes

| Teste | Como | Resultado esperado |
|-------|------|-------------------|
| IA bloqueia carta ofensiva | Enviar carta com conteúdo de assédio | Dialog de bloqueio (🦉), carta NÃO salva |
| IA permite carta normal | Enviar carta de amor | Carta salva normalmente |
| IA warning (zona cinzenta) | Enviar carta com tom agressivo leve | Dialog com "Revisar carta" / "Enviar assim mesmo" |
| "Enviar assim mesmo" | Clicar no botão no dialog warning | Carta salva |
| "Revisar carta" | Clicar no botão no dialog warning | Volta à edição |
| IA indisponível + failClosed | Sem OPENAI_API_KEY | SnackBar, carta NÃO salva |
| IA indisponível + failOpen | `aiModerationFailClosed: false` em systemConfig | Carta salva |
| IA desativada | `aiModerationEnabled: false` em systemConfig | Carta salva sem chamada à IA |
| `SKIP_AI_MODERATION=true` | Build com dart_defines_dev.json | Carta salva sem chamada à IA |
| Cápsula — bloqueio | Criar cápsula com conteúdo ofensivo | Dialog bloqueio, cápsula NÃO criada |
| Cápsula — warning | Criar cápsula com tom ambíguo | Dialog com opção de revisar |
| Cápsula — normal | Criar cápsula normal | Criada sem interrupção |
| Comentários inalterados | Postar comentário ofensivo | Filtro lexical + IA (comportamento existente) |

---

*Implementação concluída em 12 de abril de 2026.*
