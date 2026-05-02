# Whenote — Proteção Legal e Privacidade
### Abril 2026 (atualizado: 12 de abril de 2026)

---

## Status de Implementação

| Item | Status | Referência |
|------|--------|------------|
| Política de Privacidade (LGPD+GDPR+CCPA) | ✅ Implementada | `lib/l10n/app_*.arb` (17 seções, 3 idiomas) |
| Termos de Uso + cláusula encerramento | ✅ Implementada | `lib/l10n/app_*.arb` (8 seções, 3 idiomas) |
| Aviso de cartas pendentes na exclusão | ✅ Implementada | `settings_screen.dart` (banner warning) |
| Plano de contingência 90 dias | ✅ Documentado | secção 1 abaixo |
| Página web pública (sem login) | ✅ Criada | `hosting/public/privacy.html` + `terms.html` |
| Fundo de Continuidade | ✅ Documentado | Termos de Uso §7 + secção 4 abaixo |
| Política de retenção de dados | ✅ Documentada | [`DATA_RETENTION_POLICY.md`](DATA_RETENTION_POLICY.md) |
| COPPA / GDPR Art. 8 (idade mínima por jurisdição) | ✅ Date picker + verificação automática | `register_screen.dart`, `login_screen.dart`, `age_verification.dart` |
| Consentimento analytics (ePrivacy / UK PECR) | ✅ Banner EU/EEA/UK + auto-grant resto | `consent_constants.dart`, `analytics_consent_provider.dart`, `analytics_consent_banner.dart` |
| Cloud Function deleteUserAccount | ✅ Implementada | `functions/src/delete_account.ts` |
| Domínio `whenote.app` registado (Cloudflare) | ✅ Ativo | DNS gerido na Cloudflare; conectado ao Firebase Hosting |
| Revisão com advogado | 🔲 Pendente | — |
| Emails do domínio (Cloudflare Email Routing) | ✅ Ativo | 7 endereços → redirecionamento para `y.m.lima19@gmail.com` |
| Export automático ao deletar | ✅ Implementada (testar) | `functions/src/export_user_data.ts` + `deletion_request_service.dart` |
| Export completo de dados (GDPR Art. 20) | ✅ Implementado | `complete_export_service.dart` — ZIP com JSONs + media; gratuito para todos |
| Anonimização de reports (90 dias) | ✅ Implementado | `anonymize_resolved_reports.ts` — scheduled daily 04:00 UTC; remove PII, mantém stats |
| Purge de logs de moderação (2 anos) | ✅ Implementado | `purge_old_moderation_logs.ts` — scheduled daily 04:30 UTC; deleta incidents + reviews |
| Exclusão com prazo 15 dias (soft delete) | ✅ Implementada (testar) | `functions/src/request_deletion.ts` + `scheduled_deletion.ts` |
| Cartas locked sobrevivem exclusão | ✅ Implementada (testar) | `functions/src/delete_account.ts` (preservação automática) |
| Central de privacidade no app | ✅ Implementada (testar) | `lib/features/profile/presentation/screens/privacy_center_screen.dart` + settings |

### Testes Pendentes — Privacy & Data Lifecycle (12/04/2026)

| Teste | Cenário | O que validar |
|-------|---------|---------------|
| Export completo | Utilizador com cartas, cápsulas, comentários, likes, follows | JSON contém todos os dados; signed URL funciona; email chega com link |
| Export com media | Cartas com voice e handwritten | `mediaFiles[].signedUrl` preenchidos e acessíveis |
| Soft delete request | Confirmar exclusão com re-auth | `accountStatus` muda para `pending_deletion`; email de confirmação chega; `deletionScheduledFor` = now + 15 dias |
| Bloqueio de envio | Conta em `pending_deletion` tenta enviar carta | Envio bloqueado (verificar `canSendContent` no client) |
| Banner UI | Login com conta `pending_deletion` | Banner vermelho aparece com dias restantes e botão cancelar |
| Cancelamento | Clicar "Cancelar exclusão" durante grace period | `accountStatus` volta a `active`; campos de deletion limpos; banner desaparece |
| Rate limit | 4º pedido de exclusão no mesmo mês | Erro `resource-exhausted` retornado |
| Scheduled deletion | Simular `deletionScheduledFor` no passado | `processScheduledDeletions` executa; dados deletados/anonimizados; audit log criado |
| Cartas locked (delete_all) | Remetente com carta locked + openDate futuro pede delete_all | Carta preservada como anónima; voice removido; handwritten migrado para `anon_` prefix |
| Cartas locked (anonymize) | Remetente com carta locked pede anonymize | Carta anonimizada; media tratado igual ao delete_all |
| Cápsulas locked | Cápsula com openDate futuro | Mesmo comportamento das cartas; fotos migradas |
| Fallback imediato | `requestImmediateDeletion` (admin/legacy) | Exclusão direta funciona como antes (sem grace period) |
| Central de privacidade — carregamento | Utilizador com dados diversos abre a Central | Todas as seções carregam; contagens corretas; sem erros |
| Central de privacidade — vazio | Utilizador novo (sem cartas/cápsulas) abre a Central | Seções mostram "0" ou lista vazia; sem crash |
| Central de privacidade — navegação | Aceder via Configurações → Central de Privacidade | Tela abre corretamente; botão voltar funciona |

---

## Legislações Aplicáveis

- **LGPD** — Lei Geral de Proteção de Dados (Brasil, Lei nº 13.709/2018)
- **GDPR** — General Data Protection Regulation (UE, Regulamento 2016/679)
- **CCPA/CPRA** — California Consumer Privacy Act + California Privacy Rights Act (EUA, Cal. Civ. Code §§ 1798.100–1798.199.100)
- **COPPA** — Children's Online Privacy Protection Act (EUA, 16 CFR Part 312)
- **Marco Civil da Internet** — Lei nº 12.965/2014 (Brasil)

---

## 1. Garantia de Entrega das Cartas

### O problema
O Whenote faz uma promessa implícita ao usuário — "sua carta será entregue na data escolhida". Se o app fechar antes disso, podemos ser responsabilizados.

### Cláusula nos Termos de Uso (Seção 7 — implementada)
"O Whenote empreende todos os esforços para garantir a entrega de todas as cartas e cápsulas nas datas escolhidas pelo remetente. Em caso de descontinuação planejada dos serviços, a Empresa se compromete a notificar todos os usuários com no mínimo 90 dias de antecedência."

### 1.1. Gatilhos de Ativação

O plano de contingência será ativado quando qualquer uma destas situações ocorrer:
- Decisão voluntária dos fundadores de encerrar o serviço
- Incapacidade financeira de manter a infraestrutura por mais de 3 meses
- Ordem judicial ou regulatória que impeça a continuidade do serviço
- Aquisição por terceiro que não assuma os compromissos de continuidade

### 1.2. Cronograma de Encerramento (90 dias)

#### Dia 0 — Decisão e Preparação Interna

- [ ] Decisão formal documentada por escrito
- [ ] Inventário de todas as cartas e cápsulas com datas de abertura futuras
- [ ] Inventário de todos os usuários ativos (com e-mail verificado)
- [ ] Preparação do e-mail de notificação (PT-BR, EN, ES)
- [ ] Bloqueio de novos cadastros
- [ ] Desativação de funcionalidades de pagamento (Stripe)

#### Dia 1 — Notificação aos Usuários

- [ ] Envio de e-mail a todos os usuários cadastrados com:
  - Explicação clara do encerramento
  - Data exata do encerramento (Dia 90)
  - Instruções para exportar dados
  - Link direto para exportação no app
  - Informações sobre o que acontece com cartas pendentes
  - Contato para dúvidas: suporte@whenote.app
- [ ] Notificação push via FCM a todos os dispositivos
- [ ] Banner permanente no app informando sobre o encerramento
- [ ] Atualização dos Termos de Uso com data de encerramento

#### Dias 1–60 — Período de Exportação Ativa

- [ ] Funcionalidade de exportação de dados (ZIP) disponível e destacada
- [ ] Cloud Function de exportação automática para usuários que solicitarem via e-mail
- [ ] Entrega de todas as cartas com `openDate` <= Dia 90
  - Cartas com data de abertura dentro do período: entrega antecipada com aviso
  - Cartas com data de abertura após Dia 90: notificação ao destinatário com conteúdo
- [ ] Entrega de todas as cápsulas com `openDate` <= Dia 90
- [ ] E-mail lembrete no Dia 30 e no Dia 60

#### Dia 60 — Lembrete Final

- [ ] E-mail de lembrete: "Faltam 30 dias para o encerramento"
- [ ] Notificação push
- [ ] Para cartas com `openDate` > Dia 90:
  - Opção A: Entregar antecipadamente com aviso ao destinatário
  - Opção B: Enviar conteúdo por e-mail ao destinatário (se tiver e-mail)
  - Opção C: Incluir no arquivo de exportação do remetente

#### Dia 80 — Última Chance

- [ ] E-mail: "Faltam 10 dias — exporte seus dados agora"
- [ ] Desativação de novas funcionalidades (não é mais possível criar cartas/cápsulas)
- [ ] Feed e funcionalidades sociais desativados
- [ ] Apenas visualização e exportação funcionam

#### Dia 90 — Encerramento

- [ ] App entra em modo read-only com mensagem de encerramento
- [ ] Último e-mail com link de download dos dados (se exportação automática habilitada)
- [ ] Cancelamento de todas as assinaturas Stripe ativas

#### Dia 90 + 7 dias — Exclusão

- [ ] Exclusão permanente de todos os dados do Firestore
- [ ] Exclusão de todos os arquivos do Firebase Storage
- [ ] Exclusão de todos os registros do Firebase Auth
- [ ] Manutenção apenas dos `deletionAuditLogs` (hasheados, sem PII) por 3 anos
- [ ] Remoção do app das lojas (App Store e Google Play)
- [ ] Desativação do projeto Firebase

### 1.3. Tratamento de Cartas Pendentes

#### Cartas com openDate dentro do período de 90 dias
- Entregues normalmente no cronograma original
- Destinatário recebe aviso adicional sobre o encerramento

#### Cartas com openDate após o encerramento
Prioridade de resolução:
1. **Entrega antecipada** com notificação ao destinatário explicando a situação
2. **Envio por e-mail** se o destinatário tem e-mail cadastrado
3. **Inclusão no pacote de exportação** do remetente
4. **Último recurso:** notificação ao remetente de que a carta não pôde ser entregue

#### Cartas externas (destinatário sem conta)
- E-mail enviado ao destinatário externo com o conteúdo da carta
- Link para download expira em 30 dias após o Dia 90

### 1.4. Comunicação

#### Canais
- E-mail (primário — atinge 100% dos usuários com e-mail verificado)
- Notificação push FCM (secundário)
- Banner in-app (terciário)
- Redes sociais (complementar)

#### Idiomas
- Todas as comunicações em PT-BR, EN e ES

#### Tom
- Transparente e honesto
- Agradecimento aos usuários
- Instruções claras e práticas
- Sem linguagem jurídica excessiva

### 1.5. Responsabilidades

| Tarefa | Responsável |
|--------|-------------|
| Decisão e comunicação estratégica | Diego |
| Implementação técnica (export, entrega, exclusão) | Yuri |
| E-mails e notificações | Diego + Yuri |
| Compliance legal | Diego (com assessoria jurídica) |
| Desativação de pagamentos (Stripe) | Yuri |
| Remoção das lojas | Diego |
| Manutenção dos audit logs | Yuri |

### 1.6. Testes do Plano

Antes do lançamento, validar:
- [ ] Cloud Function de exportação de dados funciona e gera ZIP completo
- [ ] E-mail de notificação é enviado corretamente nos 3 idiomas
- [ ] Entrega antecipada de cartas funciona
- [ ] Fluxo de exclusão total do Firestore funciona sem resíduos
- [ ] `deletionAuditLogs` registra corretamente sem PII

---

## 2. Deletar Conta — Regras

### Implementação atual (Cloud Function `deleteUserAccount`)
Dois modos oferecidos ao usuário:
- **Excluir Tudo:** remove perfil, cartas, cápsulas, comentários, curtidas, follows, bloqueios, denúncias, feedback, badges, notificações, arquivos Storage, Auth
- **Anonimizar:** preserva cartas/cápsulas para destinatários com nome substituído por "Usuário removido"

### Aviso de cartas pendentes (implementado)
Banner amarelo no bottom sheet de exclusão informando sobre cartas locked enviadas/recebidas e diferenças entre os dois modos.

### Cartas publicadas no feed
- Removidas do feed ao deletar conta (modo "Excluir Tudo")
- Anonimizadas no feed (modo "Anonimizar")
- LGPD/GDPR — direito ao esquecimento
- Destinatário que exportou mantém sua cópia

### Cartas enviadas ainda não abertas (locked)
- Modo "Anonimizar": entrega mantida com nome "Usuário removido"
- Modo "Excluir Tudo": cartas removidas
- Aviso obrigatório na tela de deletar conta ✅

---

## 3. Direitos dos Usuários por Lei

### LGPD — Brasil (Art. 18) — detalhado na Política de Privacidade §10
- Confirmação, acesso, correção, anonimização, portabilidade, eliminação
- Informação sobre compartilhamento, revogação de consentimento
- Resposta em até **15 dias úteis**
- Reclamação: ANPD (gov.br/anpd)

### GDPR — Europa (Arts. 15–22) — detalhado na Política de Privacidade §10
- Acesso, retificação, apagamento, limitação, portabilidade, oposição
- Direitos sobre decisões automatizadas (Art. 22) — moderação IA
- Resposta em até **30 dias**
- Reclamação: autoridade supervisora local

### CCPA/CPRA — Califórnia/EUA — detalhado na Política de Privacidade §10
- Direito de Saber, Direito de Exclusão (45 dias), Direito de Correção
- Opt-out de venda/compartilhamento — "Não vendemos PI"
- Limitar uso de PI sensíveis, Não discriminação
- Agente autorizado
- Reclamação: AG da Califórnia (oag.ca.gov/privacy)

---

## 4. Fundo de Continuidade

### Conceito
Reserva financeira mantida pela Empresa para garantir a infraestrutura mínima necessária para entregar cartas já comprometidas, mesmo sem receita.

### Meta
- **Mínimo:** cobrir custos de Firebase/GCP + domínio por 2 anos
- **Custos fixos conhecidos:**
  - Domínio `whenote.app` (Cloudflare): **$28.20/ano** (renova anualmente, expira Apr 10, 2027)
  - Cloudflare Email Routing (7 endereços → Gmail): **gratuito** (incluído no plano Free)
- **Estimativa de custo mensal** (a ser atualizada conforme escala):
  - Firestore reads/writes: ~$X/mês
  - Cloud Storage: ~$X/mês
  - Cloud Functions: ~$X/mês
  - FCM: gratuito
  - **Total estimado:** a calcular após primeiros 3 meses de operação
- **Reserva mínima para 2 anos:** $56.40 (domínio) + custos Firebase estimados

### Data-alvo
- **Início da acumulação:** quando o app gerar receita (estimativa: Q3 2026)
- **Meta de 2 anos:** ter reserva suficiente até Q3 2028
- **Custo mínimo estimado (2 anos):** $56.40 (domínio) + custos Firebase (a calcular após 3 meses de operação)
- **Tracking de custos:** ver [`custos/GASTOS.md`](custos/GASTOS.md)

### Política de Alimentação
- A partir do momento em que o app gerar receita:
  - 5% da receita mensal líquida destinada ao Fundo
  - Revisão trimestral do saldo vs. custo projetado
  - Transparência: saldo informado nos Termos de Uso quando atingir meta

### Documentação
- Saldo e custos registados em planilha interna
- Relatório trimestral disponível para auditoria
- Menção nos Termos de Uso quando o fundo estiver ativo

---

## 5. Política de Privacidade — Estrutura Atual (17 seções)

A política completa está implementada nos arquivos de localização (`lib/l10n/app_*.arb`) e exibida em `legal_screen.dart`. Estrutura:

1. Definições (termos LGPD/GDPR/CCPA)
2. Dados que Coletamos (inventário completo real)
3. Como Coletamos (direto, automático, terceiros)
4. Bases Legais (LGPD Art. 7 + GDPR Art. 6)
5. Finalidades do Tratamento
6. Decisões Automatizadas (IA/OpenAI, Art. 22 GDPR)
7. Compartilhamento e Terceiros (Firebase, OpenAI, SendGrid, Stripe, Google Fonts)
8. Transferências Internacionais (SCCs, Schrems II)
9. Retenção de Dados (períodos por categoria)
10. Seus Direitos (LGPD / GDPR / CCPA-CPRA separados)
11. Exclusão de Conta (dois modos)
12. Portabilidade e Exportação (ZIP/JSON)
13. Privacidade de Crianças (COPPA, 13+)
14. Medidas de Segurança (TLS 1.3, App Check, breach 72h)
15. Tecnologias de Rastreamento (Firebase Analytics, Crashlytics, App Check)
16. Alterações na Política (aviso 15 dias)
17. Contato (DPO, privacidade, legal, autoridades)

---

## 6. Domínio e Hosting

O domínio **`whenote.app`** está registado e gerido na **Cloudflare** (renova anualmente, expira Apr 10, 2027 — $28.20/ano). O DNS aponta para o **Firebase Hosting**, que serve as páginas web públicas (`privacy.html`, `terms.html`) e o ficheiro `assetlinks.json` (Android App Links). Os deep links do app (`https://whenote.app/letter/...`, `https://whenote.app/capsule/...`) são resolvidos pelo Firebase Hosting + entitlements iOS e intent-filters Android.

> ⚠️ **Renovação obrigatória:** domínio expira em 10 de abril de 2027. Configurar lembrete no Cloudflare (auto-renew) ou calendário (90, 30 e 7 dias antes).

### Emails do domínio

Os emails referenciados nos documentos legais estão ativos via **Cloudflare Email Routing** (redirecionamento para `y.m.lima19@gmail.com`):

| Endereço | Finalidade |
|----------|------------|
| `privacy@whenote.app` | Solicitações de privacidade (inglês) |
| `privacidade@whenote.app` | Solicitações de privacidade (português) |
| `suporte@whenote.app` | Suporte geral |
| `dpo@whenote.app` | Encarregado de Proteção de Dados |
| `juridico@whenote.app` | Departamento jurídico |
| `info@whenote.app` | Informações gerais |
| `noreply@whenote.app` | Remetente de emails transacionais (SendGrid) |

**Nota:** quando o volume justificar, migrar para caixas dedicadas (ex: Google Workspace ou Zoho). O redirecionamento Cloudflare é suficiente para a fase atual.

---

## 7. Whenote Physical — Considerações Legais para Envio Físico

**Contexto:** o roadmap prevê a possibilidade futura de enviar cartas impressas reais e/ou produtos/presentes físicos ao destinatário, com entrega programada para a data de abertura. Esta secção documenta as áreas legais que devem ser investigadas **antes** de activar qualquer feature de envio físico.

### 7.1. Regulamentação de Envio Postal

| Região | Regulador / Lei | Pontos a investigar |
|--------|-----------------|---------------------|
| Brasil | Correios / ANATEL / CDC (Código de Defesa do Consumidor) | Responsabilidade por atraso/extravio; prazos de entrega; direito de arrependimento (7 dias — Art. 49 CDC) para compras online de produtos |
| EUA | USPS / FTC / State consumer protection laws | Shipping disclosure rules (FTC Mail Order Rule — 16 CFR Part 435); liability; return policies |
| Internacional | Convenções postais (UPU); alfândega | Declaração aduaneira; itens proibidos por país; impostos de importação |

### 7.2. Tributação

- **Brasil:** ICMS sobre produtos físicos vendidos; ISS sobre serviço de intermediação; Nota Fiscal obrigatória (NF-e ou NFC-e)
- **EUA:** Sales tax (varia por estado); nexus rules se Whenote fizer fulfillment de produtos
- **Cross-border:** impostos de importação/exportação; responsabilidade do remetente vs. destinatário (Incoterms se aplicável)
- **Stripe:** activar Stripe Tax ou integrar com serviço de cálculo de impostos (TaxJar, Avalara)

### 7.3. Produtos Proibidos e Política de Itens Aceites

Criar política explícita de itens que **não podem** ser enviados via Whenote Physical:

- Armas, munições, explosivos
- Substâncias controladas, drogas, medicamentos sem receita
- Materiais perigosos (inflamáveis, corrosivos, radioactivos)
- Animais vivos
- Itens perecíveis sem cadeia de frio (avaliar caso a caso para alimentos)
- Materiais obscenos ou ilegais
- Dinheiro em espécie, documentos de identidade

A lista deve ser alinhada com as políticas dos Correios/USPS e do parceiro de fulfillment.

### 7.4. Responsabilidade e Seguros

- **Extravio/dano:** quem é responsável — Whenote, o parceiro de fulfillment, ou a transportadora?
- **Seguro de envio:** obrigatório acima de determinado valor? Incluído no preço ou opcional?
- **Custódia de itens (Physical 3):** se o utilizador envia um objecto pessoal para armazenamento temporário, Whenote assume responsabilidade — necessário seguro e termos de custódia claros
- **Prazo de reclamação:** definir prazo para o destinatário reportar problemas (ex.: 7 dias após recepção)

### 7.5. Termos de Uso e Política de Privacidade — Actualizações Necessárias

Quando a feature for activada, actualizar:

- [ ] **Termos de Uso:** nova secção sobre envio físico, responsabilidades, política de reembolso/devolução, itens proibidos
- [ ] **Política de Privacidade:** recolha de endereço físico do destinatário (dado pessoal sensível); base legal (consentimento ou execução contratual); partilha com parceiro logístico; retenção e eliminação do endereço após entrega
- [ ] **Stripe KYC:** actualizar descrição do negócio para incluir "tangible goods" (ver [`BUSINESS.md`](BUSINESS.md))
- [ ] **Páginas web públicas:** `terms.html` e `privacy.html` actualizados

### 7.6. Protecção de Dados do Destinatário

O envio físico exige recolher o **endereço postal do destinatário** — dado pessoal que pode ser sensível. Pontos a garantir:

- Consentimento claro ou base legal para recolha do endereço (LGPD Art. 7; GDPR Art. 6)
- Endereço partilhado **apenas** com o parceiro logístico, não com o remetente (preservar surpresa)
- Endereço eliminado após confirmação de entrega (minimização de dados)
- Opção para o destinatário recusar entregas físicas (opt-out)

### 7.7. Status

| Item | Status |
|------|--------|
| Pesquisa legal (envio postal BR) | 🔲 Pendente |
| Pesquisa legal (envio postal EUA) | 🔲 Pendente |
| Política de itens aceites/proibidos | 🔲 Pendente |
| Termos de Uso actualizados (envio físico) | 🔲 Pendente |
| Política de Privacidade actualizada (endereço) | 🔲 Pendente |
| Revisão com advogado (envio físico) | 🔲 Pendente |

---

## 8. Documentos Relacionados

- [`DATA_RETENTION_POLICY.md`](DATA_RETENTION_POLICY.md) — Política detalhada de retenção e exclusão
- [`MVP_CHECKLIST.md`](MVP_CHECKLIST.md) — Checklist com itens legais e seus status
- `hosting/public/privacy.html` — Página web pública da Política de Privacidade
- `hosting/public/terms.html` — Página web pública dos Termos de Uso

**Nota:** O conteúdo do plano de contingência de encerramento foi consolidado nas secções 1 e 4 deste documento.

---
*Documento criado por Diego Rocha — CEO & Founder Whenote*
*Atualizado em 12 de abril de 2026 (consolidado com CONTINGENCY_PLAN.md)*
