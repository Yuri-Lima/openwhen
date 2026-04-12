# OpenWhen — Plano de Lançamento Android (Google Play Store)

### Criado: 12 de abril de 2026

**Objetivo:** Publicar o OpenWhen na Google Play Store (produção pública ou closed/open testing).

**Referências:** [PRODUCTION.md](PRODUCTION.md) (checklist A–G), [MVP_CHECKLIST.md](MVP_CHECKLIST.md), [DEVICE_TESTING.md](DEVICE_TESTING.md), [LEGAL.md](LEGAL.md), [BUSINESS.md](BUSINESS.md).

---

## Visão geral das fases

| # | Fase | Estimativa | Depende de |
|---|------|-----------|------------|
| 1 | Pré-requisitos e pendências de código | 3–5 dias | — |
| 2 | Conta Google Play e identidade | 1–2 dias | — |
| 3 | Keystore e assinatura | 30 min | Fase 2 |
| 4 | Firebase e backend — deploy de produção | 1–2 horas | — |
| 5 | Build de release Android | 1 hora | Fases 3 + 4 |
| 6 | Ficha da loja (Store Listing) | 2–3 dias | Fase 2 |
| 7 | Políticas e formulários do Google Play | 1–2 horas | Fase 6 |
| 8 | QA em dispositivo real | 1–2 dias | Fase 5 |
| 9 | Submissão e revisão | 1–7 dias (Google) | Fases 5–8 |
| 10 | Pós-lançamento | Contínuo | Fase 9 |

**Tempo total estimado (trabalho ativo): ~7–12 dias úteis**, considerando que as fases 1, 2, 4 e 6 podem correr em paralelo.

---

## Fase 1 — Pré-requisitos e pendências de código

Itens que devem estar resolvidos antes de gerar o build de release.

### 1.1 Bloqueadores identificados

| Item | Status | Ação necessária | Referência |
|------|--------|-----------------|------------|
| **Moderação de cartas (Camada 2 — IA no envio)** | 🔴 Pendente | Implementar score de risco via OpenAI antes de salvar no Firestore. Google Play exige moderação de UGC. | MVP_CHECKLIST.md §Moderação |
| **Sign in with Apple** | 🟡 Pendente | Obrigatório para iOS (Apple exige), mas Google Play também recomenda. Pode ser pós-launch Android se necessário. | MVP_CHECKLIST.md §Importante |
| **DNS do remetente de email (Firebase Auth)** | ⏳ DNS pendente | Adicionar 4 registros DNS no Cloudflare para trocar remetente para `noreply@openwhen.live`. | PRODUCTION.md §Email |
| **Deploy da action page de email** | ⏳ Pendente | `firebase deploy --only hosting` para publicar `hosting/public/auth/action.html`. | PRODUCTION.md §Email |
| **Verificação de email no cadastro** | ✅ Implementado | `sendEmailVerification()` no registo + guard `requireVerifiedEmail()` bloqueia cartas/comentários/cápsulas até verificação. Soft-block (login permitido). | MVP_CHECKLIST.md §Email |

### 1.2 Recomendados (não bloqueadores, mas importantes)

| Item | Nota |
|------|------|
| Notificações de engajamento (likes, comments, follows) | Cloud Functions pendentes. Não bloqueia lançamento mas afeta retenção. |
| Export automático ao deletar conta | Google Play data deletion requirement (2024+). Verificar se a Cloud Function `deleteUserAccount` já atende. |
| Revisar Termos com advogado | Recomendado antes de escalar; pode ser pós-launch se necessário. |

### 1.3 Versão do app

Atualizar `pubspec.yaml` antes do build de release:

```yaml
version: 1.0.0+1   # → ex: 1.0.0+1 (versionName 1.0.0, versionCode 1)
```

Cada nova submissão ao Play Store exige `versionCode` incrementado.

---

## Fase 2 — Conta Google Play e identidade

### 2.1 Criar conta Google Play Console

1. Aceder a [play.google.com/console](https://play.google.com/console)
2. Registar como **Organização** (Delaware C-Corp — OpenWhen via Stripe Atlas)
   - Serão pedidos: nome legal da empresa, endereço, DUNS number (se aplicável), website
   - **Taxa única: $25 USD**
3. Verificar identidade (Google pode pedir documentos da empresa)
4. Aceitar o Developer Distribution Agreement

> **⚠️ Yuri precisa fazer:** Este passo é manual e requer pagamento + verificação de identidade. Pode demorar 1–7 dias para aprovação.

### 2.2 Criar o app no Play Console

1. Play Console → **Create app**
2. Preencher:
   - **App name:** OpenWhen
   - **Default language:** Português (Brasil) — com suporte a en, es
   - **App or game:** App
   - **Free or paid:** Free
3. Confirmar declarações (políticas do Google Play)

### 2.3 applicationId final

O `applicationId` atual é **`com.openwhen.app`** — este será o identificador permanente na Play Store. Confirmar que é o desejado antes de publicar (não pode ser alterado depois).

---

## Fase 3 — Keystore e assinatura

### 3.1 Gerar upload keystore

```bash
keytool -genkey -v \
  -keystore upload-keystore.jks \
  -storetype JKS \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload
```

**Dados a preencher:** nome, organização (OpenWhen Inc.), localização, senha segura.

> **⚠️ CRÍTICO:** Guardar o keystore e as senhas em local seguro (1Password, cofre). Se perder o keystore, não consegue atualizar o app na Play Store (a menos que use Play App Signing).

### 3.2 Criar `android/key.properties`

```properties
storePassword=SUA_SENHA_SEGURA
keyPassword=SUA_SENHA_SEGURA
keyAlias=upload
storeFile=../app/upload-keystore.jks
```

Colocar o ficheiro `upload-keystore.jks` em `android/app/`.

### 3.3 Ativar Google Play App Signing (recomendado)

Na primeira vez que fizer upload de um AAB/APK, o Play Console oferece **Play App Signing**:
- Google gere a chave de assinatura final
- Tu usas apenas a "upload key" (o keystore acima)
- Se perder a upload key, Google pode gerar uma nova
- **Recomendação: ATIVAR**

---

## Fase 4 — Firebase e backend (deploy de produção)

### 4.1 Deploy de regras e Cloud Functions

Executar no terminal (Yuri, manualmente):

```bash
# Na raiz do projeto
firebase deploy --only firestore:rules,storage
firebase deploy --only firestore:indexes
firebase deploy --only functions
firebase deploy --only hosting
```

### 4.2 Verificar systemConfig/app

No Firebase Console → Firestore → `systemConfig/app`, garantir que existem os campos:

| Campo | Valor recomendado para launch |
|-------|-------------------------------|
| `reportsEnabled` | `true` |
| `aiModerationEnabled` | `true` (se Camada 2 implementada) ou `false` |
| `aiModerationFailClosed` | `true` (bloqueia se IA falhar — mais seguro) |

### 4.3 Verificar google-services.json

O ficheiro `android/app/google-services.json` contém 3 package names. Confirmar que `com.openwhen.app` é o client ativo. Os outros (`com.example.openwhen`, `com.openwhen.mobile`) podem ser removidos do projeto Firebase se não forem mais usados — limpeza opcional.

### 4.4 Firebase App Check (recomendado)

Ativar App Check para Android com **Play Integrity** no Firebase Console:
1. Firebase Console → App Check → Registar app Android
2. Selecionar provider **Play Integrity**
3. Ativar enforcement para Firestore, Storage, Auth (gradualmente — testar antes)

### 4.5 Crashlytics

Já incluído nas dependências (`firebase_crashlytics`). Verificar no Firebase Console que o dashboard do Crashlytics está ativo para a app Android.

---

## Fase 5 — Build de release Android

### 5.1 Gerar App Bundle (AAB)

O Google Play **exige AAB** (não APK) desde agosto 2021.

```bash
cd /caminho/do/projeto

flutter build appbundle --release \
  --dart-define-from-file=config/dart_defines.json
```

O ficheiro gerado estará em: `build/app/outputs/bundle/release/app-release.aab`

### 5.2 Verificações pré-upload

- [ ] Testar o AAB localmente com `bundletool`:
  ```bash
  bundletool build-apks --bundle=app-release.aab --output=test.apks --local-testing
  bundletool install-apks --apks=test.apks
  ```
- [ ] Confirmar que `versionCode` é pelo menos 1 e `versionName` reflete a versão desejada
- [ ] Confirmar que o build usa signing de release (não debug)

---

## Fase 6 — Ficha da loja (Store Listing)

### 6.1 Informações obrigatórias

| Campo | Valor sugerido |
|-------|---------------|
| **App name** | OpenWhen |
| **Short description** (80 chars) | "Escreva hoje. Sinta amanhã. Cartas temporizadas e cápsulas do tempo." |
| **Full description** (4000 chars) | Ver rascunho abaixo |
| **App icon** | 512×512 PNG (hi-res) — gerar a partir de `assets/branding/app_icon.png` |
| **Feature graphic** | 1024×500 PNG — banner promocional (precisa ser criado) |
| **Screenshots** | Mínimo 2, recomendado 8. Resoluções: telefone (16:9 ou 9:16), tablet (opcional) |
| **App category** | Social |
| **Contact email** | suporte@openwhen.live |
| **Privacy policy URL** | https://openwhen.live/privacy.html |

### 6.2 Rascunho da descrição completa

> **OpenWhen — Escreva hoje. Sinta amanhã.**
>
> Já pensou em enviar uma carta que só será aberta no momento certo? Com o OpenWhen, você escreve mensagens com data marcada — cartas de amor, apoio, surpresa ou motivação — que o destinatário só poderá ler quando chegar a hora.
>
> **Cartas temporizadas:** Escreva com texto, áudio ou localização e escolha quando será aberta. A carta fica selada até o momento certo.
>
> **Cápsulas do tempo:** Crie cápsulas com perguntas guiadas para você ou para um grupo. Responda agora, reveja no futuro.
>
> **Feed emocional:** Compartilhe cartas abertas com a comunidade. Curta, comente e conecte-se com pessoas que sentem como você.
>
> **QR Code:** Imprima e cole em presentes, álbuns ou qualquer lugar. Quem escanear recebe a carta no momento certo.
>
> Disponível em Português, English e Español.

### 6.3 Screenshots

Capturar screenshots das telas principais nos 3 idiomas (priorizar pt-BR):

1. Tela de onboarding / splash
2. Feed (Explorar)
3. Escrever carta
4. Cofre (abas)
5. Abertura da carta (animação do selo/coruja)
6. Cápsula do tempo
7. Perfil com badges
8. Configurações / temas

> **⚠️ Yuri + Diego:** Screenshots precisam ser capturadas em dispositivo real ou emulador com resolução adequada. Ferramentas como `screenshots` (Flutter) ou gravação manual.

### 6.4 Feature Graphic

Dimensão obrigatória: **1024×500 px**. Sugestão: fundo na cor `#EDE5D8` (beige do app), logo da coruja centralizada, tagline "Escreva hoje. Sinta amanhã."

> **⚠️ Precisa ser criado** — pode usar Canva, Figma ou similar.

---

## Fase 7 — Políticas e formulários do Google Play

### 7.1 Classificação de conteúdo (Content Rating)

No Play Console → **Content rating** → Preencher questionário IARC:
- O app tem conteúdo gerado por utilizadores? **Sim** (cartas, comentários, feed)
- O app permite comunicação entre utilizadores? **Sim** (envio de cartas, comentários)
- O app recolhe dados pessoais? **Sim** (email, localização opcional, fotos)
- Resultado esperado: **Teen** ou **Everyone 10+** (dependendo das respostas)

### 7.2 Data Safety (obrigatório desde 2022)

Preencher o formulário "Data safety" com base nos dados reais:

| Tipo de dado | Recolhido | Compartilhado | Obrigatório | Pode deletar |
|-------------|-----------|---------------|-------------|-------------|
| Email | Sim | Não | Sim (Auth) | Sim |
| Nome / username | Sim | Sim (feed público) | Sim | Sim |
| Foto de perfil | Sim | Sim (feed) | Não | Sim |
| Mensagens (cartas) | Sim | Sim (feed, destinatário) | Sim (core) | Sim |
| Localização aproximada | Sim | Não | Não | Sim |
| Localização precisa | Sim | Não | Não (opt-in) | Sim |
| Áudio (voz) | Sim | Sim (destinatário) | Não | Sim |
| Crash logs | Sim (Crashlytics) | Sim (Firebase/Google) | — | — |
| Analytics | Sim (Firebase Analytics) | Sim (Firebase/Google) | — | — |
| Device IDs (FCM) | Sim | Não | — | Sim |

**Encriptação em trânsito:** Sim (TLS 1.3, Firebase)
**Deletion request mechanism:** Sim (in-app + email `privacy@openwhen.live`)

### 7.3 Ads declaration

O app **não contém anúncios** — declarar como tal.

### 7.4 Target audience

- **Idade mínima:** 13 anos (COPPA — já verificado no registro com checkbox)
- Target: 18+ (declarar no formulário — mesmo com 13+ permitido, o público-alvo é adulto jovem)
- **Não é "Designed for Children"** — não marcar como app infantil

### 7.5 App access (se necessário)

Se o revisor do Google precisar de credenciais para testar:
- Criar conta de teste: `reviewer@openwhen.live` / senha segura
- Ou fornecer instruções de como criar conta no app
- Preencher no Play Console → **App content → App access**

### 7.6 Government apps declaration

Não aplicável.

### 7.7 Financial features declaration

Não aplicável (billing desativado no lançamento).

### 7.8 Data deletion policy (obrigatório desde 2024)

URL da página de política: `https://openwhen.live/privacy.html`
O app já tem funcionalidade de deletar conta (Configurações → Excluir conta) com Cloud Function `deleteUserAccount`. Informar a URL e o mecanismo in-app no formulário.

---

## Fase 8 — QA em dispositivo real

Seguir o protocolo de [DEVICE_TESTING.md](DEVICE_TESTING.md), com atenção especial a:

### 8.1 Checklist Android pré-submissão

- [ ] Login (email/senha) funciona
- [ ] Verificação de email funciona (receber email, clicar link, voltar ao app)
- [ ] Feed carrega (Explorar, Destaques, Seguindo)
- [ ] Criar carta (com/sem localização, com/sem áudio)
- [ ] Enviar carta a destinatário existente e externo (email)
- [ ] Cofre exibe cartas em todas as abas
- [ ] Abrir carta (animação do selo, leitura)
- [ ] Abrir carta com restrição de localização (10m)
- [ ] Criar e abrir cápsula do tempo
- [ ] Perfil: upload de avatar, edição de bio
- [ ] Busca de utilizadores (@username)
- [ ] Follow / unfollow / block
- [ ] Comentários e likes no feed
- [ ] Notificações push (Android 13+ — permissão runtime)
- [ ] Compartilhar Instagram Stories (com `FB_APP_ID`)
- [ ] QR Code: gerar e escanear
- [ ] Deep links: `https://openwhen.live/letter/xxx` abre no app
- [ ] Configurações: trocar tema, trocar idioma, logout
- [ ] Deletar conta (ambos os modos)
- [ ] Crash-free: verificar Crashlytics por 24h sem crashes

### 8.2 Dispositivos recomendados

- Pixel 6+ (ou emulador com Play Services)
- Samsung Galaxy (série A ou S — cobertura de mercado BR)
- Android 10 (API 29) — verificar minSdkVersion
- Android 14/15 (API 34/35) — último Android

---

## Fase 9 — Submissão e revisão

### 9.1 Faixas de teste (recomendado)

| Faixa | Uso |
|-------|-----|
| **Internal testing** | Até 100 testers (equipe). Sem revisão do Google. Deploy imediato. |
| **Closed testing** | Grupo limitado de beta testers. Revisão do Google (mais rápida). |
| **Open testing** | Qualquer pessoa pode participar. Revisão do Google. |
| **Production** | Público geral. Revisão completa do Google (1–7 dias). |

**Recomendação:** Começar com **Internal testing** → **Closed testing** (convidar ~20–50 beta testers) → **Production**.

### 9.2 Upload do AAB

1. Play Console → **Release** → **Production** (ou testing track)
2. **Create new release**
3. Upload do `app-release.aab`
4. Preencher release notes (em pt-BR, en, es)
5. **Review and rollout**

### 9.3 Revisão do Google

- Primeira submissão: pode demorar **até 7 dias** (apps novas)
- Submissões seguintes: geralmente **1–3 dias**
- Se rejeitado: Google indica o motivo; corrigir e resubmeter

### 9.4 Motivos comuns de rejeição (atenção)

| Motivo | Como evitar |
|--------|-------------|
| UGC sem moderação | Implementar moderação de cartas (Fase 1, item 1.1) |
| Privacy policy ausente ou incompleta | ✅ Já temos — verificar URL acessível |
| Metadata inappropriate | Não usar termos enganosos na descrição |
| Broken functionality | QA extensivo (Fase 8) |
| Data safety inaccurate | Preencher com precisão (Fase 7.2) |
| Missing data deletion | ✅ Já temos — confirmar que funciona |
| Login issues | Testar fluxo completo de auth |

---

## Fase 10 — Pós-lançamento

### 10.1 Monitorização

| Ferramenta | O que monitorar |
|------------|----------------|
| **Firebase Crashlytics** | Crash rate (meta: <1%), ANRs |
| **Firebase Analytics** | DAU, retenção D1/D7/D30, funnels |
| **Play Console** | Reviews, ratings, uninstall rate, ANR rate |
| **Firebase Performance** | App start time, network latency |

### 10.2 Primeiras 48h

- Verificar Crashlytics por crashes novos
- Responder a reviews na Play Store (especialmente negativos)
- Monitorizar Firestore usage/billing no Firebase Console
- Verificar que push notifications estão a funcionar para utilizadores reais

### 10.3 Primeira semana

- Analisar funil de onboarding (quantos criam conta → quantos enviam primeira carta)
- Identificar drop-offs
- Preparar hotfix release se necessário

### 10.4 Roadmap pós-lançamento

| Prioridade | Item |
|-----------|------|
| P0 | Sign in with Apple (se não feito antes) |
| P0 | Notificações de engajamento (likes/comments/follows) |
| P1 | Carta multimodal (OCR, transcrição) |
| P1 | Nox Card (viralidade) |
| P2 | Premium pay-per-feature (~10k users) |

---

## Resumo de ações por responsável

### Yuri (dev + ops)

1. [ ] Resolver pendências de código (Fase 1.1)
2. [ ] Registar conta Google Play Console ($25)
3. [ ] Gerar keystore e configurar `key.properties`
4. [ ] Adicionar 4 registros DNS no Cloudflare (email Firebase Auth)
5. [ ] Executar deploys Firebase (`rules`, `functions`, `hosting`)
6. [ ] Gerar AAB de release
7. [ ] QA em dispositivo real
8. [ ] Preencher formulários no Play Console
9. [ ] Submeter release

### Diego (design + conteúdo)

1. [ ] Criar Feature Graphic (1024×500)
2. [ ] Capturar screenshots (8 telas, 3 idiomas — priorizar pt-BR)
3. [ ] Revisar textos da ficha da loja (descrição curta/longa)
4. [ ] Preparar release notes
5. [ ] Definir estratégia de beta testers (quem convidar para closed testing)

### Ambos

1. [ ] Decidir se lança com moderação IA ativa ou se aceita risco de revisão manual
2. [ ] Decidir se faz closed testing antes ou vai direto para production
3. [ ] Revisar Data Safety form juntos
4. [ ] Definir conta de teste para o revisor do Google

---

## Ordem de execução sugerida (timeline)

```
Semana 1:
├── Yuri: Registar Play Console + gerar keystore
├── Yuri: Resolver pendências código (moderação, email DNS, action page)
├── Diego: Criar Feature Graphic + capturar screenshots
└── Ambos: Revisar descrição da loja

Semana 2:
├── Yuri: Deploy Firebase (rules, functions, hosting)
├── Yuri: Build AAB + QA em dispositivo
├── Diego: Finalizar screenshots nos 3 idiomas
├── Ambos: Preencher formulários Play Console
└── Yuri: Upload para Internal Testing

Semana 3:
├── Ambos: Testar via Internal Testing (equipe)
├── Yuri: Corrigir bugs encontrados
├── Yuri: Promover para Closed Testing (beta testers)
└── Monitorar feedback

Semana 4:
├── Yuri: Corrigir issues do beta
├── Yuri: Submeter para Production
└── Aguardar revisão Google (1-7 dias)
```

---

*Documento criado em 12 de abril de 2026. Atualizar conforme o progresso.*
