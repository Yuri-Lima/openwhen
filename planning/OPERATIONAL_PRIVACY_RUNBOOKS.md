# Runbooks Operacionais de Privacidade — Whenote

> **Última atualização:** 2026-05-02
> **Responsável:** DPO / Operações
> **Contactos de privacidade:** `dpo@whenote.app`, `privacidade@whenote.app`, `privacy@whenote.app`

---

## 1. Tratamento de Pedidos de Objeção ao Processamento (GDPR Art. 21)

### Contexto
A Seção 10 da Política de Privacidade garante o direito de "object to processing based on legitimate interest (Art. 21)". O utilizador pode exercer este direito via email (`privacidade@whenote.app`) ou via a Central de Privacidade no app.

### Bases legais de interesse legítimo no Whenote
- Moderação de conteúdo (prevenção de abuso)
- Prevenção de fraude (verificação de idade, rate limits)
- Melhoria do produto (analytics, se consentido — esta já é opt-in, não se aplica Art. 21)

### Procedimento

**Prazo:** Responder em até 30 dias (prorrogável por mais 60 dias se justificado e comunicado).

1. **Receção do pedido**
   - Email chega a `privacidade@whenote.app` (redireccionado para `y.m.lima19@gmail.com`)
   - Confirmar receção em 48h úteis com template (ver Anexo A)
   - Registar no spreadsheet de pedidos DSAR (Data Subject Access Request)

2. **Verificação de identidade**
   - Pedir ao utilizador que confirme o email associado à conta Whenote
   - Se necessário, pedir screenshot do perfil ou do email de registro

3. **Avaliação**
   - Identificar qual processamento o utilizador está a objetar
   - Avaliar se existe "compelling legitimate ground" que se sobreponha (Art. 21(1))
   - Para moderação de conteúdo: a objeção **não** pode ser aceite se o processamento visa "the establishment, exercise or defence of legal claims" (Art. 21(1) in fine)
   - Para analytics: o utilizador já tem opt-out via Settings → desativar é suficiente

4. **Execução**
   - Se a objeção é aceite: usar a funcionalidade de **Restrição de Processamento** (Art. 18) implementada no app — definir `accountStatus: 'restricted'` via Firebase Console ou script admin
   - Se a objeção é parcialmente aceite: documentar quais processamentos foram parados e quais continuam (com justificação)
   - Se a objeção é recusada: comunicar ao utilizador com fundamentação escrita (template Anexo B)

5. **Registo**
   - Documentar decisão, fundamentação e data no spreadsheet DSAR
   - Guardar cópia da correspondência por 3 anos (prazo de prescrição)

### Anexo A — Template de Confirmação de Receção

> Subject: [Whenote] Confirmação do seu pedido de objeção ao processamento
>
> Caro(a) [Nome],
>
> Confirmamos a receção do seu pedido de objeção ao processamento dos seus dados pessoais, recebido em [DATA].
>
> O seu pedido será analisado no prazo de 30 dias, conforme previsto no Artigo 12(3) do RGPD. Caso necessitemos de informação adicional para verificar a sua identidade, entraremos em contacto.
>
> Referência interna: [ID]
>
> Atenciosamente,
> Equipa Whenote
> dpo@whenote.app

### Anexo B — Template de Recusa Fundamentada

> Subject: [Whenote] Resposta ao seu pedido de objeção — Referência [ID]
>
> Caro(a) [Nome],
>
> Após análise do seu pedido de objeção ao processamento de [descrever dados/processamento], informamos que não é possível cessar este processamento pelas seguintes razões:
>
> [FUNDAMENTAÇÃO — ex.: "O processamento de moderação de conteúdo é necessário para o cumprimento de obrigações legais (Art. 6(1)(c) do RGPD) e para a proteção de interesses legítimos de terceiros, nomeadamente a segurança dos demais utilizadores."]
>
> Informamos que tem o direito de apresentar reclamação junto da autoridade de controlo competente (em Portugal: CNPD — www.cnpd.pt; no Brasil: ANPD — www.gov.br/anpd).
>
> Atenciosamente,
> Equipa Whenote
> dpo@whenote.app

---

## 2. Notificação de Mudança de Política de Privacidade / Termos de Uso (Seção 16)

### Compromisso
A Seção 16 da Política de Privacidade promete: "notify you via in-app notification and/or email at least 15 days before the changes take effect."

### Procedimento

1. **Preparação (D-30 a D-15 antes da data efetiva)**
   - Redigir nova versão da Política de Privacidade / Termos de Uso
   - Marcar claramente as alterações (diff)
   - Se possível, obter revisão jurídica
   - Atualizar a data no cabeçalho do documento
   - Atualizar os ficheiros ARB (4 idiomas: en, pt, pt_BR, es)
   - Atualizar as páginas web (`hosting/public/privacy.html`, `terms.html`)

2. **Notificação in-app + email (D-15)**
   - Criar documento `systemConfig/policyUpdate` no Firestore com:
     ```json
     {
       "active": true,
       "termsVersion": "2026-XX-XX",
       "privacyVersion": "2026-XX-XX",
       "effectiveDate": "2026-XX-XX (Timestamp)",
       "notifiedAt": "2026-XX-XX (Timestamp)",
       "summaryEn": "Brief summary of changes",
       "summaryPt": "Resumo breve das alterações",
       "summaryEs": "Resumen breve de los cambios",
       "changesUrl": "https://whenote.app/privacy.html",
       "emailBatchStatus": "pending"
     }
     ```
   - **In-app (automático):** o `policyUpdateProvider` (Riverpod `StreamProvider`) deteta o documento e aplica o modelo de 3 estados:
     - `upcomingChange` (antes da `effectiveDate`): `PolicyUpdateBanner` — banner informativo não-bloqueante com animação slide-up
     - `requiresReConsent` (após `effectiveDate`): `PolicyReConsentScreen` — dialog full-screen bloqueante (`PopScope(canPop: false)`); utilizador só pode aceitar ou fazer logout
     - `upToDate`: sem UI adicional
   - **Email (automático):** ao definir `emailBatchStatus: "pending"`, a Cloud Function `sendPolicyUpdateEmails` (`onDocumentWritten`) dispara batch de emails via SendGrid com template HTML branded, multi-idioma (en/pt/es), throttle 50 emails/s, paginação 200 users. Progresso registado em `emailBatchSentCount`; estado final: `completed` ou `failed`.
   - **Ficheiros relevantes:** `lib/core/policy/policy_update_provider.dart`, `policy_reconsent_screen.dart`, `policy_update_banner.dart`, `functions/src/send_policy_update_emails.ts`

3. **Publicação (D-0)**
   - Deploy dos ficheiros ARB atualizados (requer app update via stores)
   - Deploy das páginas web: `firebase deploy --only hosting`
   - Após todos os utilizadores aceitarem (ou período razoável), desativar: `systemConfig/policyUpdate.active = false`

4. **Registo**
   - Documentar no CHANGELOG.md
   - Guardar snapshot da versão anterior (git tag: `policy-v{N}`)
   - Atualizar `policy_constants.dart` com novas versões (`kCurrentTermsVersion`, `kCurrentPrivacyVersion`)

---

## 3. Notificação de Violação de Dados (Breach Notification — GDPR Art. 33/34, LGPD Art. 48)

### Obrigações legais
- **GDPR Art. 33:** Notificar a autoridade de supervisão em até **72 horas** após tomar conhecimento
- **GDPR Art. 34:** Notificar os titulares de dados afetados "sem demora injustificada" se alto risco
- **LGPD Art. 48:** Notificar a ANPD e os titulares em "prazo razoável" (regulamento ANPD: 2 dias úteis)

### Definição de breach
Qualquer violação de segurança que leve à destruição, perda, alteração, divulgação ou acesso não autorizado a dados pessoais.

### Procedimento

#### Fase 1 — Deteção e Contenção (0-4h)

1. **Deteção**
   - Fonte: alerta de segurança, relatório de utilizador, auditoria interna, notificação de terceiro
   - Registar hora exata de tomada de conhecimento (**T=0** para o prazo de 72h)

2. **Contenção imediata**
   - Revogar credenciais comprometidas (Firebase Console → Authentication)
   - Desativar API keys / secrets afetados (GCP Console → APIs & Credentials)
   - Se dados em trânsito: desativar Cloud Functions afetadas (`firebase functions:delete <name>`)
   - Se Storage comprometido: alterar regras de Storage para bloquear acesso

3. **Avaliação inicial**
   - Que dados foram afetados? (PII, conteúdo, financeiros?)
   - Quantos utilizadores afetados?
   - Ainda está em curso ou já foi contido?
   - Qual o vetor de ataque?

#### Fase 2 — Avaliação de Risco (4-24h)

4. **Classificação do risco**
   - **Baixo risco:** Dados sem PII, ou PII já pseudonimizada/encriptada, sem impacto provável
   - **Risco:** PII exposta (emails, nomes) mas sem dados sensíveis
   - **Alto risco:** Dados sensíveis (localização GPS, conteúdo de cartas, dados financeiros Stripe)

5. **Decisão de notificação**
   - Baixo risco → documentar internamente, não notificar autoridade (Art. 33(1) exceção)
   - Risco → notificar autoridade em 72h, não notificar titulares
   - Alto risco → notificar autoridade em 72h + notificar titulares afetados

#### Fase 3 — Notificação (24-72h)

6. **Notificação à autoridade de supervisão**
   - **Portugal (CNPD):** https://www.cnpd.pt/formularios/ — formulário online
   - **Brasil (ANPD):** https://www.gov.br/anpd/pt-br — formulário de comunicação de incidente
   - **EU (lead authority):** CNPD (sede da empresa)
   - Conteúdo obrigatório (Art. 33(3)):
     - Natureza da violação
     - Categorias e número aproximado de titulares afetados
     - Nome e contacto do DPO: `dpo@whenote.app`
     - Consequências prováveis
     - Medidas tomadas ou propostas

7. **Notificação aos titulares (se alto risco)**
   - Via email individual a cada utilizador afetado
   - Template (ver Anexo C)
   - Via notificação in-app (collection `notifications`)
   - Linguagem clara e simples (Art. 34(2))

8. **Notificação a processadores**
   - Se o breach envolveu dados processados por terceiros (Google/Firebase, OpenAI, Stripe):
     - Contactar o DPO/equipa de segurança do processador
     - Solicitar relatório de incidente

#### Fase 4 — Pós-incidente (72h+)

9. **Relatório interno**
   - Documentar: timeline, causa raiz, dados afetados, ações tomadas, lições aprendidas
   - Guardar por mínimo 5 anos (Art. 33(5))

10. **Medidas corretivas**
    - Implementar correções técnicas
    - Atualizar procedimentos de segurança
    - Se necessário: rotação de secrets, atualização de Firestore rules, patch de vulnerabilidade

### Anexo C — Template de Notificação a Titulares

> Subject: [Whenote] Aviso Importante de Segurança
>
> Caro(a) utilizador(a),
>
> Estamos a contactá-lo(a) para informar sobre um incidente de segurança que afetou a sua conta Whenote.
>
> **O que aconteceu:**
> [Descrição clara do incidente]
>
> **Que dados foram afetados:**
> [Lista dos tipos de dados: email, nome, conteúdo de cartas, etc.]
>
> **O que fizemos:**
> [Medidas de contenção e correção já tomadas]
>
> **O que pode fazer:**
> - Altere a sua password em Configurações → Conta
> - Se usa a mesma password noutros serviços, altere-a também
> - Esteja atento(a) a emails ou mensagens suspeitas
>
> **Contacto:**
> Para questões sobre este incidente, contacte o nosso DPO: dpo@whenote.app
>
> Lamentamos sinceramente este incidente e estamos empenhados em proteger os seus dados.
>
> Equipa Whenote

---

## 4. Contactos e Autoridades

| Entidade | Contacto |
|----------|----------|
| DPO Whenote | dpo@whenote.app |
| Privacidade (geral) | privacidade@whenote.app / privacy@whenote.app |
| Suporte | support@whenote.app |
| Representante EU | eu-representative@whenote.app |
| CNPD (Portugal) | https://www.cnpd.pt |
| ANPD (Brasil) | https://www.gov.br/anpd |
| ICO (UK) | https://ico.org.uk |
