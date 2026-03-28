# Contexto do Projeto — openwhen

## Stack
- **Framework:** Flutter (Dart)
- **Backend:** Firebase (Firestore, Storage, Auth)
- **Remote Git:** origin

## Branches Git
| Branch | Papel |
|--------|-------|
| `master` | Branch principal de trabalho local |
| `main` | Branch sincronizada com `origin/main` |

---

## 🔀 Comandos Git Personalizados

### "atualize master"
Atualiza a branch `master` local com o que há em `origin/main`:
```bash
git checkout main && git pull origin main && git checkout master && git merge main
```

### "atualize main"
Atualiza a `main` local com a `master` e depois com `origin/main`:
```bash
git checkout main && git merge master && git pull origin main && git checkout master
```

---

## 📋 Workflow de Commit (obrigatório)

### Ao finalizar uma tarefa de desenvolvimento:
1. **Claude DEVE** anotar o hash atual com `git rev-parse HEAD` antes de iniciar qualquer tarefa
2. Após a tarefa estar funcionando, **sempre perguntar:**
   > "✅ Deseja fazer um commit para salvar na master local?"
3. **Se sim:** `git add -A && git commit -m "feat/fix/docs: descrição"`
4. **Se não:** `git reset --hard <hash_antes_da_tarefa>`

### Ao corrigir um erro (bug fix):
1. **Claude DEVE** anotar o hash atual antes de iniciar a correção
2. **Se corrigiu com sucesso:** perguntar se quer commitar
3. **Se não corrigiu:** reverter automaticamente sem perguntar
   > "❌ Correção não funcionou. Revertendo para o estado anterior..."

---

## 📝 Padrão de Mensagens de Commit
```
feat: nova funcionalidade
fix: correção de bug
docs: alteração de documentação
refactor: refatoração sem mudança de comportamento
style: formatação/estilos
test: adição/alteração de testes
chore: tarefas de manutenção
```

---

## 🖥️ Ambiente de Execução

**Todos os comandos de terminal (git, flutter, dart, firebase, etc.) devem ser executados dentro do diretório do projeto:**

```
/sessions/gallant-fervent-curie/mnt/openwhen
```

Ou seja, todo comando Bash deve iniciar com:
```bash
cd /sessions/gallant-fervent-curie/mnt/openwhen && <comando>
```

Este projeto está rodando no **Cursor** (editor externo). Qualquer alteração de arquivo ou comando deve considerar que o ambiente ativo é este diretório.

### ⚠️ Limitação de Remote Git (proxy)

O ambiente sandbox do Claude **não tem acesso à internet**, portanto os seguintes comandos **falham** no sandbox:
`git pull`, `git push`, `git fetch`

**Regra para comandos com remote:** Claude deve informar o comando exato e pedir para o usuário executar no terminal do Cursor.

Comandos **locais** (sem remote) funcionam normalmente no sandbox:
`git checkout`, `git merge`, `git commit`, `git add`, `git reset`, `git branch`, `git log`, `git status`, `git stash`

### 🖥️ Computer Use — Terminal do Cursor

Claude **não consegue** interagir com o terminal do Cursor a menos que o **Computer Use** esteja ativado.

Para ativar: `Settings → Desktop app → Computer use`

Quando ativado, Claude poderá digitar comandos diretamente no terminal do Cursor (incluindo comandos com remote), eliminando completamente o bloqueio de proxy do sandbox.

---

## 🌐 Acesso ao Navegador

Sempre que houver necessidade de abrir ou interagir com o navegador web (pesquisas, documentação, Firebase Console, etc.), **usar o Google Chrome**, pois o usuário possui a extensão do Claude instalada nele. Isso permite controle direto do browser via ferramentas de automação (Claude in Chrome).

---

## ⚠️ Regras Importantes
- Nunca commitar sem confirmação do usuário
- Nunca resolver conflitos de merge automaticamente — sempre pedir orientação
- Sempre informar em qual branch estamos após operações de checkout
- Sempre mostrar o hash do commit após cada commit ou reset
