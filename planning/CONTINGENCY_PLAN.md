# OpenWhen — Plano de Contingência (Service Wind-Down)

> **Última atualização:** 2026-04-10
> **Responsáveis:** Diego Rocha (CEO), Yuri Lima (CTO)
> **Legislações aplicáveis:** LGPD, GDPR, CCPA/CPRA

---

## 1. Objetivo

Garantir que, em caso de encerramento planejado do serviço OpenWhen, todos os compromissos com os usuários sejam cumpridos:
- Cartas e cápsulas entregues nas datas prometidas
- Dados exportados e acessíveis antes da exclusão
- Privacidade protegida durante e após o encerramento
- Conformidade legal mantida durante todo o processo

---

## 2. Gatilhos de Ativação

O plano de contingência será ativado quando qualquer uma destas situações ocorrer:
- Decisão voluntária dos fundadores de encerrar o serviço
- Incapacidade financeira de manter a infraestrutura por mais de 3 meses
- Ordem judicial ou regulatória que impeça a continuidade do serviço
- Aquisição por terceiro que não assuma os compromissos de continuidade

---

## 3. Cronograma de Encerramento (90 dias)

### Dia 0 — Decisão e Preparação Interna

- [ ] Decisão formal documentada por escrito
- [ ] Inventário de todas as cartas e cápsulas com datas de abertura futuras
- [ ] Inventário de todos os usuários ativos (com e-mail verificado)
- [ ] Preparação do e-mail de notificação (PT-BR, EN, ES)
- [ ] Bloqueio de novos cadastros
- [ ] Desativação de funcionalidades de pagamento (Stripe)

### Dia 1 — Notificação aos Usuários

- [ ] Envio de e-mail a todos os usuários cadastrados com:
  - Explicação clara do encerramento
  - Data exata do encerramento (Dia 90)
  - Instruções para exportar dados
  - Link direto para exportação no app
  - Informações sobre o que acontece com cartas pendentes
  - Contato para dúvidas: suporte@openwhen.live
- [ ] Notificação push via FCM a todos os dispositivos
- [ ] Banner permanente no app informando sobre o encerramento
- [ ] Atualização dos Termos de Uso com data de encerramento

### Dias 1–60 — Período de Exportação Ativa

- [ ] Funcionalidade de exportação de dados (ZIP) disponível e destacada
- [ ] Cloud Function de exportação automática para usuários que solicitarem via e-mail
- [ ] Entrega de todas as cartas com `openDate` <= Dia 90
  - Cartas com data de abertura dentro do período: entrega antecipada com aviso
  - Cartas com data de abertura após Dia 90: notificação ao destinatário com conteúdo
- [ ] Entrega de todas as cápsulas com `openDate` <= Dia 90
- [ ] E-mail lembrete no Dia 30 e no Dia 60

### Dia 60 — Lembrete Final

- [ ] E-mail de lembrete: "Faltam 30 dias para o encerramento"
- [ ] Notificação push
- [ ] Para cartas com `openDate` > Dia 90:
  - Opção A: Entregar antecipadamente com aviso ao destinatário
  - Opção B: Enviar conteúdo por e-mail ao destinatário (se tiver e-mail)
  - Opção C: Incluir no arquivo de exportação do remetente

### Dia 80 — Última Chance

- [ ] E-mail: "Faltam 10 dias — exporte seus dados agora"
- [ ] Desativação de novas funcionalidades (não é mais possível criar cartas/cápsulas)
- [ ] Feed e funcionalidades sociais desativados
- [ ] Apenas visualização e exportação funcionam

### Dia 90 — Encerramento

- [ ] App entra em modo read-only com mensagem de encerramento
- [ ] Último e-mail com link de download dos dados (se exportação automática habilitada)
- [ ] Cancelamento de todas as assinaturas Stripe ativas

### Dia 90 + 7 dias — Exclusão

- [ ] Exclusão permanente de todos os dados do Firestore
- [ ] Exclusão de todos os arquivos do Firebase Storage
- [ ] Exclusão de todos os registros do Firebase Auth
- [ ] Manutenção apenas dos `deletionAuditLogs` (hasheados, sem PII) por 3 anos
- [ ] Remoção do app das lojas (App Store e Google Play)
- [ ] Desativação do projeto Firebase

---

## 4. Tratamento de Cartas Pendentes

### Cartas com openDate dentro do período de 90 dias
- Entregues normalmente no cronograma original
- Destinatário recebe aviso adicional sobre o encerramento

### Cartas com openDate após o encerramento
Prioridade de resolução:
1. **Entrega antecipada** com notificação ao destinatário explicando a situação
2. **Envio por e-mail** se o destinatário tem e-mail cadastrado
3. **Inclusão no pacote de exportação** do remetente
4. **Último recurso:** notificação ao remetente de que a carta não pôde ser entregue

### Cartas externas (destinatário sem conta)
- E-mail enviado ao destinatário externo com o conteúdo da carta
- Link para download expira em 30 dias após o Dia 90

---

## 5. Fundo de Continuidade

### Conceito
Reserva financeira mantida pela Empresa para garantir a infraestrutura mínima necessária para entregar cartas já comprometidas, mesmo sem receita.

### Meta
- **Mínimo:** cobrir custos de Firebase/GCP + domínio por 2 anos
- **Custos fixos conhecidos:**
  - Domínio `openwhen.live` (Cloudflare): **$28.20/ano** (renova anualmente, expira Apr 10, 2027)
  - Cloudflare Email Routing (7 endereços → Gmail): **gratuito** (incluído no plano Free)
- **Estimativa de custo mensal** (a ser atualizada conforme escala):
  - Firestore reads/writes: ~$X/mês
  - Cloud Storage: ~$X/mês
  - Cloud Functions: ~$X/mês
  - FCM: gratuito
  - **Total estimado:** a calcular após primeiros 3 meses de operação
- **Reserva mínima para 2 anos:** $56.40 (domínio) + custos Firebase estimados

### Política de Alimentação
- A partir do momento em que o app gerar receita:
  - 5% da receita mensal líquida destinada ao Fundo
  - Revisão trimestral do saldo vs. custo projetado
  - Transparência: saldo informado nos Termos de Uso quando atingir meta

### Documentação
- Saldo e custos registrados em planilha interna
- Relatório trimestral disponível para auditoria
- Menção nos Termos de Uso quando o fundo estiver ativo

---

## 6. Aspectos Legais

### LGPD
- Notificação à ANPD se aplicável (art. 48 em caso de incidentes)
- Direito de acesso e portabilidade garantido durante todo o período de 90 dias
- Prazo de exclusão: imediato após Dia 90 + 7

### GDPR
- Notificação a autoridades supervisoras se aplicável
- Direitos do titular mantidos durante o período de wind-down
- SCCs e DPAs com processadores permanecem válidos até exclusão final

### CCPA
- Direito de exclusão atendido automaticamente pelo encerramento
- Notificação a consumidores da Califórnia conforme California Civil Code § 1798.82

---

## 7. Comunicação

### Canais
- E-mail (primário — atinge 100% dos usuários com e-mail verificado)
- Notificação push FCM (secundário)
- Banner in-app (terciário)
- Redes sociais (complementar)

### Idiomas
- Todas as comunicações em PT-BR, EN e ES

### Tom
- Transparente e honesto
- Agradecimento aos usuários
- Instruções claras e práticas
- Sem linguagem jurídica excessiva

---

## 8. Responsabilidades

| Tarefa | Responsável |
|--------|-------------|
| Decisão e comunicação estratégica | Diego |
| Implementação técnica (export, entrega, exclusão) | Yuri |
| E-mails e notificações | Diego + Yuri |
| Compliance legal | Diego (com assessoria jurídica) |
| Desativação de pagamentos (Stripe) | Yuri |
| Remoção das lojas | Diego |
| Manutenção dos audit logs | Yuri |

---

## 9. Testes do Plano

Antes do lançamento, validar:
- [ ] Cloud Function de exportação de dados funciona e gera ZIP completo
- [ ] E-mail de notificação é enviado corretamente nos 3 idiomas
- [ ] Entrega antecipada de cartas funciona
- [ ] Fluxo de exclusão total do Firestore funciona sem resíduos
- [ ] `deletionAuditLogs` registra corretamente sem PII

---

*Documento criado por Diego Rocha e Yuri Lima — OpenWhen*
*Abril 2026*
