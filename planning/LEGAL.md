# OpenWhen — Proteção Legal e Privacidade
### Abril 2026 (atualizado: 10 de abril de 2026)

---

## Status de Implementação

| Item | Status | Referência |
|------|--------|------------|
| Política de Privacidade (LGPD+GDPR+CCPA) | ✅ Implementada | `lib/l10n/app_*.arb` (17 seções, 3 idiomas) |
| Termos de Uso + cláusula encerramento | ✅ Implementada | `lib/l10n/app_*.arb` (8 seções, 3 idiomas) |
| Aviso de cartas pendentes na exclusão | ✅ Implementada | `settings_screen.dart` (banner warning) |
| Plano de contingência 90 dias | ✅ Documentado | [`CONTINGENCY_PLAN.md`](CONTINGENCY_PLAN.md) |
| Página web pública (sem login) | ✅ Criada | `hosting/public/privacy.html` + `terms.html` |
| Fundo de Continuidade | ✅ Documentado | Termos de Uso §7 + [`CONTINGENCY_PLAN.md`](CONTINGENCY_PLAN.md) §5 |
| Política de retenção de dados | ✅ Documentada | [`DATA_RETENTION_POLICY.md`](DATA_RETENTION_POLICY.md) |
| COPPA (idade 13+) | ✅ Checkbox no registro | `register_screen.dart` |
| Cloud Function deleteUserAccount | ✅ Implementada | `functions/src/delete_account.ts` |
| Revisão com advogado | 🔲 Pendente | — |
| Configurar caixas de email reais | 🔲 Pendente | privacy@, privacidade@, dpo@ |
| Export automático ao deletar | 🔲 Pendente (Yuri) | — |
| Central de privacidade no app | 🔲 Pendente (Yuri) | — |

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
O OpenWhen faz uma promessa implícita ao usuário — "sua carta será entregue na data escolhida". Se o app fechar antes disso, podemos ser responsabilizados.

### Cláusula nos Termos de Uso (Seção 7 — implementada)
"O OpenWhen empreende todos os esforços para garantir a entrega de todas as cartas e cápsulas nas datas escolhidas pelo remetente. Em caso de descontinuação planejada dos serviços, a Empresa se compromete a notificar todos os usuários com no mínimo 90 dias de antecedência."

### Plano de contingência — ver [`CONTINGENCY_PLAN.md`](CONTINGENCY_PLAN.md)
- Notificação por email + push + banner com 90 dias de antecedência
- Export automático de todas as cartas disponível pelo app
- Entrega antecipada de cartas com openDate dentro do período
- Após 90+7 dias — dados deletados permanentemente
- Audit logs mantidos por 3 anos (sem PII)

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

Documentado nos Termos de Uso (Seção 7) e detalhado em [`CONTINGENCY_PLAN.md`](CONTINGENCY_PLAN.md) §5.

- **Meta:** reserva para cobrir Firebase/GCP por **2 anos**
- **Alimentação:** 5% da receita mensal líquida (quando houver receita)
- **Transparência:** saldo informado nos Termos quando atingir meta
- **Revisão:** trimestral

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
15. Tecnologias de Rastreamento (Firebase Analytics, Crashlytics, GPC)
16. Alterações na Política (aviso 15 dias)
17. Contato (DPO, privacidade, legal, autoridades)

---

## 6. Documentos Relacionados

- [`DATA_RETENTION_POLICY.md`](DATA_RETENTION_POLICY.md) — Política detalhada de retenção e exclusão
- [`CONTINGENCY_PLAN.md`](CONTINGENCY_PLAN.md) — Plano de contingência de encerramento (90 dias)
- [`MVP_CHECKLIST.md`](MVP_CHECKLIST.md) — Checklist com itens legais e seus status
- `hosting/public/privacy.html` — Página web pública da Política de Privacidade
- `hosting/public/terms.html` — Página web pública dos Termos de Uso

---
*Documento criado por Diego Rocha — CEO & Founder OpenWhen*
*Atualizado em 10 de abril de 2026*
