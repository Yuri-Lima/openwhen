# Whenote — Moderação de Conteúdo

> Documento consolidado — Abril 2026
> Responsáveis: Diego Rocha (CEO), Yuri Lima (CTO)

---

## 1. Filosofia

O Whenote existe para conectar pessoas com amor, superação e conexão genuína. Uma carta temporizada tem um poder único — ela chega num momento específico, quando a pessoa pode estar vulnerável, e o remetente não sabe o estado emocional do destinatário naquele momento.

Uma carta agressiva ou cruel que abre no aniversário de alguém, ou num momento difícil, pode causar dano real — incluindo consequências graves para pessoas em estado emocional vulnerável.

**Posicionamento:** O Whenote é o app que só permite amor, superação e conexão.
*"O único app onde você só pode enviar amor."*

### O Que Queremos Proteger

✅ **Permitido — expressão humana genuína:**
- Tristeza, saudade, despedida
- Dificuldades e sofrimento em contexto de apoio
- Críticas construtivas com amor
- Emoções difíceis mas honestas
- "Sei que você está sofrendo mas não está sozinho"
- "Essa fase difícil vai passar"

❌ **Bloqueado — dano emocional intencional:**
- Agressão e humilhação direcionada
- Ameaças de qualquer natureza
- Conteúdo que denigre ou diminui o destinatário
- Mensagens que possam induzir pensamentos autodestrutivos
- "Você é um fracasso"
- "Ninguém te ama"
- "Você deveria desaparecer"

### O Que NÃO Fazer

- Não bloquear tristeza, saudade ou emoções difíceis
- Não bloquear palavras fora de contexto
- Não ser agressivo nas mensagens de aviso
- Não punir o usuário — educar com gentileza
- Não moderar cartas privadas sem o consentimento implícito do envio

### Contexto de Saúde Mental

Pessoas em estado emocional vulnerável podem receber cartas em momentos críticos. O sistema de moderação é uma camada de proteção real, não apenas uma feature de produto.

Em casos extremos de conteúdo que induza automutilação ou pensamentos suicidas, o sistema deve:
1. Bloquear o envio
2. Mostrar recursos de apoio ao remetente
3. Registar o incidente para revisão (sem expor o conteúdo)

### Por Que Isto Importa Para o Negócio

1. Diferencial único — nenhum app de mensagens tem esta política
2. Posicionamento premium — "O app que só permite amor"
3. Proteção legal — reduz responsabilidade por dano causado pela plataforma
4. Confiança dos utilizadores — pais confiam em deixar filhos usar
5. App Store — Apple valoriza apps que protegem bem-estar dos utilizadores

---

## 2. Moderação de Texto (Cartas e Cápsulas) — ✅ Implementado

### Decisão

Filtr lexical leve (**Camada 1**) em cartas e cápsulas: mesma lista e mesma mensagem l10n que comentários (`commentsModerationWarning` nos ARBs), aplicada **antes** da chamada à IA. Depois segue-se a moderação **OpenAI Moderation API** no envio (**Camada 2**).

Código partilhado: `lib/core/moderation/banned_lexical_words.dart` (`textContainsBannedLexicalWord`). Comentários continuam lexical + IA; cartas/cápsulas: lexical → IA conforme thresholds.

**Implementação IA (thresholds):** 12 de abril de 2026 · **Camada lexical cartas/cápsulas:** 28 abril 2026

### Arquitectura / Fluxo

```
Utilizador clica "Enviar"
  │
  ├─ Validações locais (título, mensagem, destinatário, etc.)
  ├─ Prompt de localização/proximidade
  │
  ├─ Lista lexical (`textContainsBannedLexicalWord`) → se match → SnackBar `commentsModerationWarning` (ARB) e **não envia**
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

### Thresholds

| Variável | Default | Significado |
|----------|---------|-------------|
| `MODERATION_WARNING_THRESHOLD` | `0.40` | Score ≥ este → dialog de aviso (utilizador decide) |
| `MODERATION_BLOCK_THRESHOLD` | `0.70` | Score ≥ este OU `flagged` → bloqueio |

Definidos em `config/dart_defines.json` e lidos via `double.fromEnvironment()` — constantes de compilação, zero custo em runtime.

### Decisões de Design

| Decisão | Escolha | Motivo |
|---------|---------|--------|
| Lista lexical antes da IA (cartas/cápsulas/comentários) | `banned_lexical_words.dart` + `commentsModerationWarning` | Alinhamento com comentários; mensagens sempre localizadas (4 ARBs) |
| Thresholds em dart_defines | Compile-time | Performance máxima; ajustável com rebuild |
| Warning: utilizador decide | Dialog com 2 opções | Respeitar agência do utilizador |
| Human review queue | Só comentários (v1) | Cartas são privadas (remetente → destinatário) |
| Moderação cápsulas coletivas | Só texto do criador (v1) | multiContributor é futuro |

### Ficheiros Criados

| Ficheiro | Descrição |
|----------|-----------|
| `lib/core/moderation/send_moderation_helper.dart` | Helper centralizado: chama Cloud Function, classifica severity usando thresholds de `dart_defines.json`, retorna `ModerationDecision` |
| `lib/core/moderation/banned_lexical_words.dart` | Camada lexical pt/en/es: `textContainsBannedLexicalWord` (partilhado com comentários, cartas e cápsulas) |

### Ficheiros Alterados

| Ficheiro | Alteração |
|----------|-----------|
| `functions/src/moderation/moderate_content.ts` | Adicionado cálculo + retorno de `maxScore` (max dos categoryScores do OpenAI) |
| `lib/core/moderation/moderation_functions_service.dart` | `ModerationCallResult` agora parseia `maxScore` (double?) |
| `lib/features/letters/data/letter_send_step.dart` | Adicionado `moderation` ao enum (primeiro passo do envio) |
| `lib/features/letters/presentation/screens/write_letter_screen.dart` | Camada lexical antes da IA em `_saveLetter()`; moderação IA antes de qualquer escrita Firestore |
| `lib/features/capsules/presentation/screens/create_capsule_screen.dart` | Camada lexical antes da IA em `_saveCapsule()`; moderação IA antes do `.set()` |
| `lib/features/feed/presentation/screens/comments_screen.dart` | Usa `textContainsBannedLexicalWord` em vez de mapas duplicados |
| `lib/l10n/app_pt_BR.arb` | 11 strings de moderação (carta + cápsula) |
| `lib/l10n/app_pt.arb` | 11 strings de moderação (PT-PT) |
| `lib/l10n/app_en.arb` | 11 strings de moderação (EN) |
| `lib/l10n/app_es.arb` | 11 strings de moderação (ES) |
| `config/dart_defines.json` | `MODERATION_WARNING_THRESHOLD` + `MODERATION_BLOCK_THRESHOLD` |
| `config/dart_defines_dev.json` | Idem |
| `config/dart_defines.example.json` | Idem |

### Testes

| Teste | Como | Resultado esperado |
|-------|------|-------------------|
| IA bloqueia carta ofensiva | Enviar carta com conteúdo de assédio | Dialog de bloqueio, carta NÃO salva |
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

## 3. Moderação de Comentários

Comentários mantêm filtro lexical (Camada 1) + IA (Camada 2). `SKIP_AI_MODERATION` aplica-se apenas a comentários.

---

## 4. Moderação de Media (Imagens e Áudio) — ✅ Implementado

**Implementação concluída:** 12 de abril de 2026

### Imagens — OpenAI omni-moderation-latest (gratuito)

#### Pontos de Upload

| Upload | Storage Path | Onde no código |
|--------|-------------|----------------|
| **Avatar / foto de perfil** | `avatars/{uid}.jpg` | `avatar_service.dart` |
| **Fotos de cápsula** (até 5) | `capsules/photos/{uid}_{ts}.jpg` | `create_capsule_screen.dart` |
| **Carta manuscrita** | `handwritten/{uid}_{ts}.jpg` | `write_letter_screen.dart` |

#### API e Arquitectura

| Aspecto | Detalhe |
|---------|---------|
| **API** | `POST https://api.openai.com/v1/moderations` |
| **Modelo** | `omni-moderation-latest` (multi-modal: texto + imagem) |
| **Input** | Base64 ou URL da imagem |
| **Categorias** | 13 categorias: sexual, harassment, hate, violence, self-harm, illicit, etc. |
| **Preço** | **Gratuito** |
| **Retorno** | `flagged`, `categories`, `category_scores` |

**Vantagem:** O projeto já usa a API de moderação OpenAI para texto. Basta trocar o modelo para `omni-moderation-latest` e enviar a imagem junto. A infra já está pronta.

#### Fluxo de Moderação

```
Utilizador faz upload (cliente)
  │
  ├─ Firebase Storage recebe ficheiro
  │
  └─ Trigger: onObjectFinalized (Cloud Function)
      │
      ├─ Verificar path:
      │   ├─ avatars/* → moderar imagem
      │   ├─ capsules/photos/* → moderar imagem
      │   └─ handwritten/* → moderar imagem
      │
      ├─ Chamar OpenAI: v1/moderations (omni-moderation-latest) com URL da imagem
      │
      └─ Se flagged:
          ├─ Deletar ficheiro do Storage
          ├─ Registar incidente em moderationIncidents
          └─ Notificar utilizador via users/{uid}/notifications
```

### Áudio — Whisper + Moderação de Texto

#### Ponto de Upload

| Upload | Storage Path | Onde no código |
|--------|-------------|----------------|
| **Voz na carta** (≤60s, AAC) | `voiceLetters/{uid}_{ts}.m4a` | `voice_letter_io.dart` |

#### APIs e Custo

| Aspecto | Detalhe |
|---------|---------|
| **Transcrição** | `POST https://api.openai.com/v1/audio/transcriptions` |
| **Modelo** | `whisper-1` |
| **Formatos** | MP3, MP4, M4A, WAV, WebM (✅ M4A do Whenote é suportado) |
| **Limite** | 25 MB (voice letters são ≤5 MB — ok) |
| **Preço** | ~$0.006/min |
| **Fluxo** | Transcrever → texto → `v1/moderations` (gratuito) |

**Custo estimado:** 100 cartas de voz/mês (60s cada) → ~$0.30–$0.60/mês

#### Fluxo de Moderação

```
Utilizador faz upload de áudio
  │
  ├─ Firebase Storage recebe ficheiro
  │
  └─ Trigger: onObjectFinalized (Cloud Function)
      │
      ├─ Verificar path: voiceLetters/*
      │
      ├─ Transcrever com Whisper → texto
      │
      ├─ Moderar texto com v1/moderations
      │
      └─ Se flagged:
          ├─ Deletar ficheiro do Storage
          ├─ Registar incidente
          └─ Notificar utilizador
```

### Ficheiros Criados/Alterados

**Ficheiros criados:**
- `functions/src/moderation/moderate_storage.ts` — Cloud Function `moderateUploadedFile` com trigger `onObjectFinalized`

**Ficheiros alterados:**
- `functions/src/moderation/openai_adapter.ts` — Adicionados `moderateImageWithOpenAI()` (omni-moderation-latest) e `transcribeAudioWithWhisper()` (Whisper API)
- `functions/src/moderation/notification_copy.ts` — Adicionada `copyMediaRemoved()` com copy em 3 idiomas (en, pt, es)
- `functions/src/index.ts` — Exportação de `moderateUploadedFile`
- `lib/l10n/app_en.arb`, `app_es.arb`, `app_pt.arb`, `app_pt_BR.arb` — 6 strings cada para notificações de mídia removida

**Bug fix:**
- `lib/features/profile/presentation/screens/profile_screen.dart` — Removido método morto `_pickAndUploadAvatar()` que usava path incorreto `avatars/$uid/avatar.jpg` (deveria ser `avatars/$uid.jpg`)

---

## 5. Mensagens para o Utilizador

### Texto — Cartas e Cápsulas

**Aviso em tempo real (palavra detectada):**
> "O Whenote existe para conectar com amor 🦉"

**Aviso de revisão (score 0.40–0.70):**
> "Sua carta tem um tom que pode machucar quem recebe.
> Quer revisar antes de selar? O momento em que essa carta
> vai ser lida pode ser delicado."
> [Revisar] [Enviar mesmo assim]

**Bloqueio (score ≥ 0.70):**
> "Esta carta não pode ser enviada.
> O Whenote existe para conectar pessoas com amor,
> superação e conexão genuína.
> Palavras que machucam não têm lugar aqui. 🦉"

### Media — Imagens e Áudio Removidos

Quando uma imagem ou áudio é removido por moderação:
> "Uma imagem que você enviou foi removida por não atender às diretrizes do Whenote."
> (ou "Um áudio que você enviou foi removido...")

---

## 6. Configuração e Flags

| Flag / Variável | Onde | Função |
|---|---|---|
| `aiModerationEnabled` | `systemConfig/app` (Firestore) | Liga/desliga moderação IA |
| `aiModerationFailClosed` | `systemConfig/app` (Firestore) | Se IA falhar: bloqueia (true) ou permite (false) |
| `SKIP_AI_MODERATION` | `dart_defines_dev.json` | Só dev — pula moderação |
| `MODERATION_WARNING_THRESHOLD` | `dart_defines.json` | Score ≥ 0.40 → warning |
| `MODERATION_BLOCK_THRESHOLD` | `dart_defines.json` | Score ≥ 0.70 → block |
| `OPENAI_API_KEY` | Firebase Functions secrets | Chave da API OpenAI |

---

## 7. Deploy Necessário

```bash
firebase deploy --only functions
flutter gen-l10n
```

---

## 8. Decisões Pendentes (Media)

| # | Decisão | Opções | Status |
|---|---------|--------|--------|
| 1 | **Imagem flagged: deletar ou quarentena?** | (a) Deletar (b) Mover para `quarantine/` | Implementado: (a) Deletar |
| 2 | **Moderação síncrona ou assíncrona?** | (a) Trigger Storage (async) (b) No cliente antes do upload | Implementado: (a) Trigger |
| 3 | **Modelo OpenAI** | (a) `omni-moderation-latest` (b) Google Vision | Implementado: (a) OpenAI |
| 4 | **Áudio: transcrever e moderar, ou só moderar?** | (a) Whisper + moderation (b) Só moderation | Implementado: (a) Whisper + moderation |
| 5 | **Thresholds de imagem iguais aos de texto?** | (a) Mesmos (b) Diferentes | Implementado: (a) Mesmos para v1 |

---

*Documento consolidado em Abril 2026 — substitui CONTENT_MODERATION.md, MODERATION_IMPLEMENTATION_PLAN.md e MEDIA_MODERATION_PLAN.md*
