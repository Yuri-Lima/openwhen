# OpenWhen — Roadmap de produto

Este documento organiza entregas por fase. Prioridades: **P0** (crítico), **P1** (importante), **P2** (desejável).

**Estado vs. checklist:** o rastreio fino (marcado `[x]` / `[ ]`) está em [`MVP_CHECKLIST.md`](MVP_CHECKLIST.md). Este roadmap resume por fase; em caso de divergência, prevalece o checklist.

---

## Fase 1 — MVP core (concluída)

Foco original: experiência completa de cartas + cápsulas, estabilidade e segurança. Itens **P0** abaixo estão entregues no código e marcados no checklist (🔴 Crítico).


| Entrega                                                                    | Prioridade | Status    | Notas                                                                |
| -------------------------------------------------------------------------- | ---------- | --------- | -------------------------------------------------------------------- |
| Tela de abertura da cápsula (animação, revelar Q&A, publicar após revisão) | P0         | Concluído | Fecha o loop da feature cápsulas                                     |
| Avatar de perfil (upload; web + mobile)                                    | P0         | Concluído | `file_picker` / Storage                                              |
| Notificações FCM                                                           | P0         | Concluído | Lembretes e eventos de abertura                                      |
| Testes em dispositivo real (iOS/Android)                                   | P0         | Concluído | Ver [`DEVICE_TESTING.md`](DEVICE_TESTING.md)                         |
| Regras Firestore de produção                                               | P0         | Concluído | `firestore.rules` + `storage.rules`; deploy e validação              |


---

## Fase 2 — Engajamento (foco atual)

Retenção, descoberta e hábito de uso. Itens **concluídos** alinhados a [`MVP_CHECKLIST.md`](MVP_CHECKLIST.md) (🟡 Importante).


| Entrega                                                                            | Prioridade | Status    | Esforço (est.) | Notas                                                                                                                                                                                 |
| ---------------------------------------------------------------------------------- | ---------- | --------- | -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Fotos na cápsula (mobile; desabilitado no Chrome se necessário)                    | P1         | Concluído | Médio          | `image_picker`                                                                                                                                                                      |
| Compartilhamento Stories/Reels                                                     | P1         | Concluído | Alto           | Instagram Stories (nativo iOS/Android) + fallback; ver [`ARCHITECTURE.md`](ARCHITECTURE.md) e `lib/shared/social/`                                                                                                      |
| Tela “Cartas recebidas” separada                                                   | P1         | Concluído | Médio          | Clareza no cofre                                                                                                                                                                    |
| Badges / gamificação                                                               | P1         | Pendente  | Médio          | Metas leves, não paywall                                                                                                                                                            |
| Temas do app (paletas + automático/sistema)                                        | P1         | Concluído | Baixo          | Evolução do “toggle claro/escuro”; `open_when_palette.dart`, Configurações                                                                                                            |
| Feed em 3 camadas                                                                  | P1         | Pendente  | Alto           | Camadas de conteúdo / prioridade                                                                                                                                                    |
| Carta multimodal (OCR em foto; transcrição de áudio)                             | P1         | Pendente  | Médio          | Alinha com fotos/voz; vídeo→carta fica para fase posterior (storage, UX, custo)                                                                                                     |
| Multilíngue (pt-BR, en, es)                                                        | P1         | Concluído | Alto           | Também no checklist 🟡; expansão para mais locales → Fase 3                                                                                                                          |
| **Nox Card** (card da coruja por nível — sem valor exato; animação compartilhável) | P1         | Pendente  | Alto           | Viralidade (TikTok / Instagram); reforça marca; integração com **OpenWhen Gift** para níveis; depende de **Stories/Reels** e nome do mascote (TBD) — ver `[BUSINESS.md](BUSINESS.md)` |

**Exportar cartas (PDF / ZIP)** está no checklist como 🟡 Importante; no roadmap macro consta na Fase 3 (ver tabela abaixo) — mesmo escopo, dupla referência intencional.


---

## Fase 3 — Crescimento

Foco: expansão de produto e mercado.


| Entrega                                                                                   | Prioridade | Esforço (est.) | Notas                                                                                                            |
| ----------------------------------------------------------------------------------------- | ---------- | -------------- | ---------------------------------------------------------------------------------------------------------------- |
| Cápsula coletiva                                                                          | P2         | Alto           | Multi-usuário, permissões                                                                                        |
| Música de fundo                                                                           | P2         | Médio          | Licenciamento                                                                                                    |
| Voz gravada                                                                               | P2         | Médio          | Storage + UX — distinto da **mensagem de voz** já suportada em cartas (MVP)                                      |
| Multilíngue (locales adicionais além de pt-BR / en / es)                                  | P2         | Alto           | Base i18n já entregue (Fase 2); aqui expansão (ex.: mais idiomas ou variantes regionais)                          |
| Perfis familiares (membros, data de nascimento, fotos)                                    | P2         | Médio          | Modelo de dados (limites, relação opcional); Storage; UX para menores e consentimento                            |
| Recomendações por comportamento (trilha de ações, cartas públicas, curtidas, comentários) | P2         | Alto           | Opt-in; minimização de dados; base analítica sólida                                                              |
| Sugestões de ações por IA (círculo familiar, datas, contexto)                             | P2         | Alto           | Pode reutilizar motor de recomendações; política clara sobre uso de fotos                                        |
| Moderação assistida (IA)                                                                  | P2         | Alto           | Política + custo                                                                                                 |
| Humor do dia / leitura facial (inferência emocional + sugestões)                          | P2         | Alto           | Opt-in explícito; compliance regional; preferir revisão jurídica e fornecedor com DPA ou processamento on-device |
| Exportar cartas (PDF / ZIP)                                                               | P2         | Médio          | Privacidade e performance                                                                                        |


---

## Fase 4 — Monetização

**Pré-requisito sugerido:** ~10k usuários ativos (alinhado à estratégia freemium → pay-per-feature).

**Infra já no repositório (scaffold):** subscrição por tiers (**Amanhã** / **Brisa** / **Horizonte**) com **Stripe Checkout**, **Customer Portal**, webhooks e **Firebase Cloud Functions**; estado em `users/{uid}`; cliente Flutter em `lib/core/billing/`. O fluxo de pagamento no app fica **desactivado por defeito** (`BILLING_ENABLED=false`) até configuração Stripe e deploy — ver [`functions/README.md`](../functions/README.md) e secção em [`ARCHITECTURE.md`](ARCHITECTURE.md).

| Entrega                                                                                                         | Prioridade | Esforço (est.) | Notas                                                                                                                                                                                                                                                                                                                                                                                                                 |
| --------------------------------------------------------------------------------------------------------------- | ---------- | -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Pay-per-feature premium                                                                                         | —          | Alto           | Stripe / IAP conforme loja                                                                                                                                                                                                                                                                                                                                                                                            |
| **OpenWhen Gift** (Presente Selado / Gift When): valor financeiro selado à carta; liberação na data de abertura | —          | Alto           | **Fase 1 (MVP Gift):** Stripe Connect — retenção do valor até a abertura; Brasil e EUA; sem banco próprio; conta Connect aprovada; termos de uso e política de reembolso; pesquisa legal *money transmission* (EUA). Estimativa ~2–3 meses de desenvolvimento. Modelo de receita e posicionamento: `[BUSINESS.md](BUSINESS.md)`. Checklist de execução: `[MVP_CHECKLIST.md](MVP_CHECKLIST.md)` (Futuro — Gift & Nox). |
| Analytics de produto                                                                                            | —          | Médio          | Funis, retenção, conversão                                                                                                                                                                                                                                                                                                                                                                                            |


**Expansão Gift (após MVP do Gift):** PIX e carteiras digitais (BR); Wise (transferências internacionais); Apple Pay / Google Pay; parcerias bancárias; API bancária própria; licença de *money transmission* nos EUA (fase tardia). Códigos de resgate ou créditos para **premium** podem reutilizar a mesma stack de pagamentos — detalhar na implementação.

---

## Como usar este roadmap

- Acompanhe o detalhamento de MVP em `[MVP_CHECKLIST.md](MVP_CHECKLIST.md)`.
- Mudanças de escopo: atualizar esta tabela e o changelog em `[CHANGELOG.md](CHANGELOG.md)`.
- **Novas ideias de produto:** preferir linhas neste roadmap (+ parágrafo em `[BUSINESS.md](BUSINESS.md)` se houver impacto em receita ou mercado) e itens em `[MVP_CHECKLIST.md](MVP_CHECKLIST.md)`; evitar um arquivo `.md` dedicado por feature — reservar arquivos em `planning/` a temas transversais (ex.: design system, testes em dispositivo).
- Funcionalidades de **IA com perfilamento, fotos de terceiros ou biometria/emotion** (recomendações, círculo familiar, face): revisar **privacidade, bases legais e fornecedores** antes do lançamento.

