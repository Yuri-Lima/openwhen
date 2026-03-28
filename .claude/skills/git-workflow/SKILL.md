# Git Workflow Skill — Rotina de Branches (openwhen)

## Visão Geral
Esta skill define os comandos e comportamentos de git para o projeto **openwhen**. O remote padrão é `origin`. As branches principais são `master` (branch de trabalho local) e `main` (branch sincronizada com origin).

---

## Comando: "atualize master"

Quando o usuário disser **"atualize master"** (ou variações como "atualiza master", "update master"):

**Objetivo:** Trazer as atualizações de `origin/main` para a branch `master` local.

```bash
# 1. Ir para a branch main e puxar as atualizações remotas
git checkout main
git pull origin main

# 2. Voltar para master e fazer o merge com a main atualizada
git checkout master
git merge main
```

**Comportamento esperado:**
- Informar o usuário sobre o resultado de cada etapa
- Se houver conflitos no merge, listar os arquivos em conflito e pedir orientação
- Confirmar ao final qual é o HEAD da master após a operação

---

## Comando: "atualize main"

Quando o usuário disser **"atualize main"** (ou variações como "atualiza main", "update main"):

**Objetivo:** Atualizar a branch `main` local com o conteúdo da `master` local e depois sincronizar com `origin/main`.

```bash
# 1. Ir para a branch main
git checkout main

# 2. Fazer merge da master local na main
git merge master

# 3. Atualizar com a origin/main
git pull origin main
```

**Comportamento esperado:**
- Informar o usuário sobre o resultado de cada etapa
- Se houver conflitos, listar os arquivos e pedir orientação
- Confirmar ao final qual é o HEAD da main após a operação
- Voltar para a branch master ao final (se o usuário estava em master antes)

---

## Workflow: Fim de Tarefa (MVP/Projeto)

Quando o usuário indicar que **finalizou uma tarefa** de desenvolvimento (ex: "terminei", "tarefa concluída", "tá funcionando", "implementei X", "feature pronta"):

### Passo 1 — Verificar o estado antes
Claude DEVE anotar internamente o hash do commit atual ANTES de iniciar qualquer tarefa:
```bash
git rev-parse HEAD
# Guardar este hash como CHECKPOINT
```

### Passo 2 — Perguntar sobre o commit
Após a tarefa ser concluída e funcionando, SEMPRE perguntar:

> "✅ Tarefa concluída! Deseja salvar as alterações com um commit na sua master local?
>
> - **Sim** → faço o commit com uma mensagem descritiva
> - **Não** → reverto todas as alterações feitas nesta tarefa"

### Passo 3a — Se o usuário confirmar (sim):
```bash
git add -A
git commit -m "[tipo]: descrição clara do que foi feito"
```
- Sugerir uma mensagem de commit descritiva com base no que foi implementado
- Usar prefixos: `feat:`, `fix:`, `docs:`, `refactor:`, `style:`, `test:`
- Confirmar o hash do novo commit ao usuário

### Passo 3b — Se o usuário recusar (não):
```bash
# Reverter para o estado anterior à tarefa
git reset --hard <CHECKPOINT_HASH>
```
- Informar ao usuário que as alterações foram revertidas
- Confirmar o estado atual do repositório

---

## Workflow: Correção de Erro (Bug Fix)

Quando o usuário pedir para **corrigir um erro/bug** e Claude iniciar a tentativa:

### Passo 1 — Registrar ponto de partida
ANTES de qualquer alteração de código para correção de bug, Claude deve:
```bash
git rev-parse HEAD
# Guardar este hash como BUGFIX_CHECKPOINT
```

### Passo 2a — Se o erro for corrigido com sucesso:
Perguntar ao usuário:

> "🐛 Erro corrigido! Deseja salvar a correção com um commit?"
>
> - **Sim** → faço o commit da correção
> - **Não** → reverto para antes da tentativa de correção"

Se confirmar:
```bash
git add -A
git commit -m "fix: [descrição do erro corrigido]"
```

### Passo 2b — Se a correção NÃO funcionar:
Automaticamente reverter sem perguntar:
```bash
git reset --hard <BUGFIX_CHECKPOINT>
```
Informar ao usuário:
> "❌ A tentativa de correção não resolveu o problema. Revertendo para o estado anterior à tentativa..."

---

## Regras Gerais

1. **Nunca fazer commit sem perguntar** ao usuário primeiro (exceto em casos de reversão automática por falha)
2. **Sempre registrar o hash do commit** antes de iniciar uma tarefa ou correção
3. **Sempre informar o resultado** de cada operação git com o hash do commit resultante
4. **Em caso de conflitos de merge**, NUNCA tentar resolver automaticamente — sempre apresentar os arquivos em conflito e pedir orientação
5. **Após qualquer operação de branch switching**, verificar em qual branch estamos com `git branch` e informar o usuário
6. **Mensagens de commit** devem ser descritivas e em português ou inglês conforme o padrão já usado no projeto

---

## Fluxo de Branches do Projeto

```
origin/main (remoto)
      ↑↓ (git pull/push)
    main (local)
      ↑↓ (merge)
   master (local) ← branch de trabalho principal
```

- `master` = branch onde o desenvolvimento acontece localmente
- `main` = branch intermediária, sincronizada com `origin/main`
- Commits de trabalho ficam em `master`
- `main` serve como ponte entre `master` e o repositório remoto
