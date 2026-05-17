# Avaliação de Impacto sobre a Proteção de Dados (DPIA)
## Processamento de Dados de Localização — Whenote

> **Versão:** 1.0
> **Data:** 2026-05-02
> **Responsável:** Yuri Lima (Controlador / DPO interino)
> **Base legal:** GDPR Art. 35, LGPD Art. 38
> **Status:** Concluída — risco residual BAIXO

---

## 1. Descrição do Processamento

### 1.1 Natureza
O Whenote permite que os utilizadores anexem voluntariamente a sua localização GPS (latitude/longitude) a cartas e cápsulas do tempo. A localização é capturada no dispositivo do utilizador via APIs nativas (CoreLocation no iOS, Geolocator no Android) e armazenada no Firestore como um `GeoPoint`.

### 1.2 Finalidade
- Permitir que o destinatário saiba de onde a carta foi enviada (contexto emocional/narrativo)
- Funcionalidade opcional de "abrir com proximidade": a carta só pode ser aberta quando o destinatário está próximo de um local específico definido pelo remetente

### 1.3 Dados processados
| Campo | Tipo | Precisão | Armazenamento |
|-------|------|----------|---------------|
| `senderLocation` | GeoPoint (lat/lng) | ~10m (GPS nativo) | `letters/{id}`, `capsules/{id}` no Firestore |
| `openRequiresProximity` | boolean | — | `letters/{id}` |
| `proximityLocation` | GeoPoint | ~10m | `letters/{id}` (quando proximity enabled) |
| `proximityRadiusMeters` | number | — | `letters/{id}` |

### 1.4 Volume estimado
- Proporção de cartas com localização: estimado < 30% (opt-in por carta)
- Volume total esperado no primeiro ano: < 50.000 cartas com localização

### 1.5 Base legal
- **Consentimento explícito (Art. 6(1)(a) + Art. 9(2)(a))** — o utilizador ativa a localização voluntariamente para cada carta/cápsula individual. Não há default ativado.

---

## 2. Necessidade e Proporcionalidade

### 2.1 É necessário?
Sim. A localização é um elemento central da proposta de valor do app (cartas com contexto geográfico, abertura por proximidade). Sem esta funcionalidade, o utilizador perde a capacidade de partilhar de onde escreveu.

### 2.2 É proporcional?
Sim, pelas seguintes razões:
- **Opt-in granular:** O utilizador decide carta a carta se quer incluir localização. Não há tracking contínuo.
- **Captura pontual:** A localização é capturada uma única vez no momento do envio, não é monitorizada ao longo do tempo.
- **Sem perfil de movimentação:** O sistema não cruza localizações de diferentes cartas para inferir padrões de deslocação.
- **Sem partilha com terceiros:** A localização não é enviada a APIs externas, serviços de mapas ou redes de publicidade.

### 2.3 Alternativas consideradas
| Alternativa | Descartada porque |
|-------------|-------------------|
| Usar apenas cidade/país (geocoding reverso) | Perde a funcionalidade de proximidade; adiciona dependência de API externa (Google Maps) |
| Não oferecer localização | Elimina funcionalidade core que diferencia o app |
| Localização apenas do remetente, sem proximidade | Reduz risco mas elimina funcionalidade de proximidade que já está implementada e é opt-in |

---

## 3. Identificação de Riscos

| # | Risco | Probabilidade | Impacto | Risco bruto |
|---|-------|---------------|---------|-------------|
| R1 | Acesso não autorizado a coordenadas GPS no Firestore | Baixa | Alto | MÉDIO |
| R2 | Correlação de localização entre cartas para inferir rotinas | Muito baixa | Médio | BAIXO |
| R3 | Exportação de dados inclui coordenadas (portabilidade vs. privacidade) | Baixa | Baixo | BAIXO |
| R4 | Cartas públicas com localização revelam endereço do remetente | Média | Alto | MÉDIO |
| R5 | Dados de localização retidos indefinidamente | Baixa | Médio | BAIXO |

---

## 4. Medidas de Mitigação

| # | Risco | Medida implementada | Risco residual |
|---|-------|---------------------|----------------|
| R1 | Acesso não autorizado | Firestore Security Rules: só remetente, destinatário ou cartas públicas abertas podem ler. Autenticação obrigatória + email verificado para criar cartas. | BAIXO |
| R2 | Correlação de localização | Cada carta é independente. Não há API de consulta geográfica. O feed público não indexa por localização. | MUITO BAIXO |
| R3 | Exportação inclui coordenadas | Correto por design: GDPR Art. 20 exige portabilidade completa. O utilizador forneceu os dados, tem direito a exportá-los. | ACEITE (compliance) |
| R4 | Cartas públicas com localização | O utilizador escolhe separadamente (1) incluir localização e (2) tornar pública. São duas decisões independentes. Recomendação futura: tooltip de aviso quando ambas estão ativas. | BAIXO |
| R5 | Retenção indefinida | A localização é parte do conteúdo da carta e tem o mesmo ciclo de vida. Na deleção de conta, as cartas (e localização) são eliminadas ou anonimizadas conforme o modo escolhido. | BAIXO |

### Medidas adicionais implementadas
- **Info.plist:** `NSLocationWhenInUseUsageDescription` e `NSLocationAlwaysAndWhenInUseUsageDescription` (ambas com o mesmo texto). A chave "Always" é exigida pela Apple quando qualquer dependência referencia `CLLocationManager`, mas o app só pede permissão `whenInUse` em runtime — nunca solicita acesso contínuo em background.
- **Moderação de media:** Cloud Function `moderateUploadedFile` verifica uploads mas não processa coordenadas GPS (não são imagens/áudio).
- **Hash em audit logs:** UIDs pseudonimizados com HMAC-SHA-256 nos logs de deleção, impedindo correlação com localização.

---

## 5. Consulta ao DPO / Titulares

### 5.1 DPO
O DPO interino (Yuri Lima) é também o controlador/desenvolvedor. Para efeitos desta DPIA, a avaliação foi feita com conhecimento direto da implementação técnica. Recomendação: obter revisão por consultor jurídico externo antes do lançamento público.

### 5.2 Titulares dos dados
Não foi realizada consulta formal aos titulares. Justificação: o processamento é totalmente opt-in, granular (por carta), e o utilizador tem controlo total sobre quando e se partilha a localização.

---

## 6. Conclusão

O processamento de dados de localização no Whenote apresenta **risco residual BAIXO** após as medidas de mitigação implementadas. Os principais fatores atenuantes são:

- Consentimento opt-in granular (por carta, não global)
- Captura pontual (não tracking contínuo)
- Sem partilha com terceiros ou APIs externas
- Firestore Security Rules robustas
- Deleção/anonimização na exclusão de conta

### Recomendações pendentes
1. Adicionar tooltip de aviso quando o utilizador ativa localização numa carta pública
2. Obter revisão jurídica externa desta DPIA
3. Reavaliar esta DPIA anualmente ou quando houver alteração significativa no processamento

---

## 7. Registo de Revisões

| Data | Versão | Alteração |
|------|--------|-----------|
| 2026-05-02 | 1.0 | Versão inicial |
