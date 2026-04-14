# Abertura da Empresa — Delaware C-Corp (Holding)

> **Para:** Diego Rocha & Yuri Lima
> **Data:** 13/04/2026
> **Objetivo:** Criar uma holding americana que será a empresa-mãe do OpenWhen e de todos os apps futuros.

---

## 1. Por Que Uma Holding Acima do OpenWhen

A ideia é correta e estratégica. Em vez de "OpenWhen Inc.", vocês abrem uma **empresa-mãe genérica** que possui todos os produtos:

```
When Labs, Inc. (Delaware C-Corp) ← EMPRESA QUE ABRIRÃO
  ├── OpenWhen (app de cartas temporizadas)
  ├── Futuro App 2
  └── Futuro App N
```

**Vantagens desta estrutura:**
- Um único CNPJ americano para todos os produtos
- Investidores entram na holding, não em cada app separado
- Contabilidade consolidada
- Marca flexível — "When Labs" não prende o nome a um produto específico
- Se um produto fracassar, a empresa continua
- Se um produto vira spin-off com investidor próprio, é simples separar depois

**Quando criar estrutura separada por produto:**
Só faz sentido criar empresas filhas separadas quando:
- Um produto tem investidores diferentes dos outros
- Times com equity splits diferentes
- Necessidade de venda parcial de um produto sem afetar os outros
- Volume de receita que justifica o custo de contabilidade separada

Para o momento atual (2 founders, sem investidores externos): **uma C-Corp faz tudo.**

---

## 2. Nome da Empresa

O nome deve ser:
- Genérico o suficiente para cobrir múltiplos apps
- Alinhado com a visão do OpenWhen (tempo, emoção, futuro)
- Disponível como domínio .com e @handle

**Sugestões (verificar disponibilidade antes de decidir):**

| Nome | Conceito | Domínio provável |
|------|---------|-----------------|
| **When Labs, Inc.** | Labs de produtos sobre o tempo | whenlabs.com |
| **Sealed Digital, Inc.** | Digital que preserva momentos | sealeddigital.com |
| **Tomorrow Labs, Inc.** | Labs do futuro | tomorrowlabs.com |
| **Deep Time, Inc.** | Tempo profundo, duradouro | deeptime.com |
| **Temporal Labs, Inc.** | Produtos sobre tempo | temporallabs.com |
| **Open Time, Inc.** | Derivado do OpenWhen | opentime.com |

**Recomendação:** `When Labs, Inc.` — curto, memorável, alinhado ao DNA do OpenWhen, genérico o suficiente para qualquer app.

---

## 3. Quando Abrir

**Abrir quando ocorrer O PRIMEIRO dos seguintes:**

1. ✅ Quando vocês forem aceitar o **primeiro pagamento** de usuário (ativar billing)
2. ✅ Quando forem **publicar na App Store** (contrato com Apple exige pessoa jurídica)
3. ✅ Quando forem **contratar alguém** (mesmo freelancer com contrato formal)
4. ✅ Quando forem **buscar investimento** (investidores exigem empresa formada)
5. ✅ Quando forem **assinar contrato** em nome do produto (parcerias, SLAs)

**NÃO abrir ainda se:** o app ainda está em beta fechado com amigos e não há nenhum dos itens acima.

**Estimativa para vocês:** provavelmente 3-6 meses a partir de agora, quando o beta aberto mostrar tração e vocês ativarem monetização.

**Custo de esperar:** zero. Stripe Atlas continua disponível quando vocês precisarem.

**Custo de abrir cedo demais:** $500 agora + $450/ano de franchise tax + tempo de contabilidade em empresa sem receita.

---

## 4. Como Abrir — Passo a Passo

### Opção recomendada: Stripe Atlas

**Por que Stripe Atlas:**
- $500 — mais barato que contratar advogado
- Documentos padrão de mercado (Certificate of Incorporation, bylaws, stock certificates, IP assignment)
- EIN (CNPJ americano) incluído
- Conta Mercury Bank facilita a abertura
- Vocês já usam Stripe — integração natural

### Passo a passo completo

**Semana 1 — Preparação (antes de ir ao Stripe Atlas)**

1. Decidir o nome da empresa e verificar disponibilidade:
   - Delaware Division of Corporations: https://icis.corp.delaware.gov
   - USTPO (marcas registradas): https://www.uspto.gov/trademarks/search
   - Domínio .com: Cloudflare Registrar ou Namecheap

2. Definir o equity split entre os founders **antes** de criar a empresa:
   - Padrão para 2 co-founders: 50/50 ou 60/40
   - Se um founder contribuiu mais (tempo, capital, IP), ajustar
   - Isso fica nos documentos de fundação — muito mais difícil de mudar depois

3. Decidir o vesting schedule:
   - **Padrão de mercado:** 4 anos, 1 ano de cliff
   - Significa: se um founder sair no ano 1, não leva nada; após o cliff, veste proporcionalmente
   - Protege ambos os founders — se um sair cedo, o outro não fica com sócio inativo com 50% da empresa

4. Preparar descrição do negócio em inglês (usar o texto do `BUSINESS.md`)

**Semana 2 — Abertura no Stripe Atlas**

1. Acessar: https://stripe.com/atlas
2. Preencher:
   - Nome da empresa
   - Nomes, emails e endereços dos founders
   - Percentual de equity de cada founder
   - Descrição do negócio
   - Número de shares autorizadas (padrão: 10.000.000)
3. Pagar $500 (cartão de crédito)
4. Assinar digitalmente os documentos (PDF)
5. Aguardar 5-7 dias úteis para registro em Delaware

**Semana 3 — Pós-formação**

1. **URGENTE: Formulário 83(b) — prazo de 30 dias após formação**
   - Esse formulário é CRÍTICO para founders com vesting
   - Se não enviar no prazo, paga imposto americano sobre cada tranche de vesting ao longo de 4 anos (mesmo que as ações não valham nada ainda)
   - Com o 83(b), você elege pagar imposto agora sobre valor nominal ($0,001/share) — praticamente zero
   - Stripe Atlas explica como enviar — normalmente por carta registrada para o IRS
   - **Não esquecer. Sem exceção.**

2. Abrir conta no **Mercury Bank** (mercury.com):
   - 100% online, gratuito para startups
   - Sem mínimo de saldo
   - Integra diretamente com Stripe
   - Aceita founders internacionais
   - Funciona com EIN (sem precisar de SSN americano)

3. Comprar as ações da empresa:
   - Cada founder compra suas ações ao valor nominal: geralmente $0,001 por share
   - Para 5.000.000 shares a $0,001 = $5.000 de capital inicial
   - Isso pode ser feito via transferência para a conta Mercury da empresa

4. Assinar o **IP Assignment Agreement**:
   - Transfere todo o IP (código, marca, design) que vocês criaram ANTES da empresa para a empresa
   - Stripe Atlas inclui este documento
   - Sem isso, a empresa não possui o produto tecnicamente

5. Atualizar o Stripe com dados da empresa (substituir conta pessoal)

**Mensalmente — após abertura**

- Guardar todos os recibos e extratos em pasta organizada (Google Drive)
- Separar gastos pessoais dos gastos da empresa — NUNCA misturar
- Usar a conta Mercury exclusivamente para gastos do negócio

**Anualmente**

- **Delaware Franchise Tax + Annual Report** — vence 1 de março
  - Tip importante: usar o método "Assumed Par Value Capital" em vez do método padrão de shares autorizadas
  - Com 10M shares autorizadas, o método padrão cobra ~$80.000/ano(!)
  - O método correto cobra ~$400-450/ano para empresas pequenas
  - Stripe Atlas avisa sobre isso, mas certifique-se de usar o método certo
- Declaração de IR americana (Form 1120) — com contador especializado em startups
- Declaração brasileira — tributação de CFC (Controlled Foreign Corporation) pode se aplicar

---

## 5. Considerações para Founders Brasileiros

Abrir uma empresa americana como cidadão/residente brasileiro tem implicações fiscais no Brasil que precisam de atenção:

**Regra geral:** receitas e lucros de empresa controlada no exterior precisam ser declarados no IR brasileiro. As regras de CFC (Lei 12.973/2014) podem exigir tributação no Brasil mesmo sem distribuição de lucros.

**Para a fase atual (pré-receita):**
- Custo fiscal: zero ou mínimo (empresa sem lucro)
- Obrigação declaratória: existe (DCB — Declaração de Capitais Brasileiros no Exterior no Banco Central se o investimento > $1.000.000; abaixo disso, somente DIRPF)
- Declarar no IRPF: sim, a participação na empresa estrangeira precisa constar na declaração como "bem no exterior"

**Quando tiver receita:**
- Contratar um contador brasileiro com experiência em empresas offshore
- Ou usar serviços especializados como o da Valora ou da Accountant.io
- NÃO usar um contador brasileiro sem experiência com offshore — vai errar

**O que NÃO fazer:**
- Esconder a empresa no IR brasileiro — risco de multa de 150% + juros
- Misturar conta pessoal com conta da empresa
- Distribuir lucros para conta pessoal sem estrutura adequada

---

## 6. Custos Totais Estimados

| Item | Quando | Valor |
|------|--------|-------|
| Stripe Atlas | Abertura | $500 |
| Mercury Bank | Abertura | Gratuito |
| Compra das shares (capital) | Abertura | ~$10 |
| **Delaware Franchise Tax** (annual) | Todo março | ~$450/ano |
| Registered Agent (após 1° ano Stripe Atlas) | Anual | $50-150/ano |
| Contador americano (Form 1120) | Anual | $500-2.000/ano |
| Contador brasileiro (CFC) | Anual | $500-1.500/ano |
| **Total primeiro ano** | | **~$1.500-2.500** |
| **Total anos seguintes** | | **~$1.500-4.000/ano** |

---

## 7. Checklist de Abertura

- [ ] Decidir nome da empresa e verificar disponibilidade
- [ ] Definir equity split entre founders
- [ ] Definir vesting schedule (recomendado: 4 anos, 1 ano cliff)
- [ ] Identificar todos os ativos de IP a transferir (código, marca, domínios)
- [ ] Abrir via Stripe Atlas ($500)
- [ ] **Enviar formulário 83(b) em até 30 dias após formação** ← CRÍTICO
- [ ] Abrir Mercury Bank
- [ ] Comprar as shares ao valor nominal
- [ ] Assinar IP Assignment Agreement
- [ ] Atualizar Stripe com dados da empresa
- [ ] Configurar contabilidade básica (planilha de gastos por mês)
- [ ] Declarar participação no IR brasileiro

---

## 8. Recursos Úteis

| Recurso | URL |
|---------|-----|
| Stripe Atlas | https://stripe.com/atlas |
| Mercury Bank | https://mercury.com |
| Delaware Franchise Tax Calculator | https://icis.corp.delaware.gov/Ecorp/EntitySearch/NameSearch.aspx |
| IRS EIN (se não usar Stripe Atlas) | https://www.irs.gov/businesses/small-businesses-self-employed/apply-for-an-employer-identification-number-ein-online |
| USPTO Trademark Search | https://www.uspto.gov/trademarks/search |
| Guia 83(b) para founders | https://carta.com/blog/83b-election/ |

---

*Documento criado em 13/04/2026 · Diego Rocha & Claude · OpenWhen*
*Relacionado: [`BUSINESS.md`](BUSINESS.md) · [`MONETIZACAO.md`](MONETIZACAO.md)*
