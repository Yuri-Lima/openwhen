# OpenWhen — Roadmap de produto

Este documento organiza entregas por fase. Prioridades: **P0** (crítico), **P1** (importante), **P2** (desejável).

---

## Fase 1 — MVP core (atual ~92%)

Foco: experiência completa de cartas + cápsulas, estabilidade e segurança antes de escalar.

| Entrega | Prioridade | Esforço (est.) | Notas |
|--------|------------|----------------|-------|
| Tela de abertura da cápsula (animação, revelar Q&A, publicar após revisão) | P0 | Alto | Fecha o loop da feature cápsulas |
| Avatar de perfil (upload; web + mobile) | P0 | Médio | `file_picker` / Storage |
| Notificações FCM | P0 | Médio | Lembretes e eventos de abertura |
| Testes em dispositivo real (iOS/Android) | P0 | Médio | Validação além do Chrome |
| Regras Firestore de produção | P0 | Médio | Bloquear acessos indevidos, validar writes |

---

## Fase 2 — Engajamento

Foco: retenção, descoberta e hábito de uso.

| Entrega | Prioridade | Esforço (est.) | Notas |
|--------|------------|----------------|-------|
| Fotos na cápsula (mobile; desabilitado no Chrome se necessário) | P1 | Médio | `image_picker` |
| Compartilhamento Stories/Reels | P1 | Alto | Integração nativa por plataforma |
| Tela “Cartas recebidas” separada | P1 | Médio | Clareza no cofre |
| Badges / gamificação | P1 | Médio | Metas leves, não paywall |
| Toggle tema claro/escuro | P1 | Baixo | Extensão do design system |
| Feed em 3 camadas | P1 | Alto | Camadas de conteúdo / prioridade |
| Carta multimodal (OCR em foto; transcrição de áudio) | P1 | Médio | Alinha com fotos/voz; vídeo→carta fica para fase posterior (storage, UX, custo) |

---

## Fase 3 — Crescimento

Foco: expansão de produto e mercado.

| Entrega | Prioridade | Esforço (est.) | Notas |
|--------|------------|----------------|-------|
| Cápsula coletiva | P2 | Alto | Multi-usuário, permissões |
| Música de fundo | P2 | Médio | Licenciamento |
| Voz gravada | P2 | Médio | Storage + UX |
| Multilíngue (ex.: en-US) | P2 | Alto | i18n em todo o app |
| Perfis familiares (membros, data de nascimento, fotos) | P2 | Médio | Modelo de dados (limites, relação opcional); Storage; UX para menores e consentimento |
| Recomendações por comportamento (trilha de ações, cartas públicas, curtidas, comentários) | P2 | Alto | Opt-in; minimização de dados; base analítica sólida |
| Sugestões de ações por IA (círculo familiar, datas, contexto) | P2 | Alto | Pode reutilizar motor de recomendações; política clara sobre uso de fotos |
| Moderação assistida (IA) | P2 | Alto | Política + custo |
| Humor do dia / leitura facial (inferência emocional + sugestões) | P2 | Alto | Opt-in explícito; compliance regional; preferir revisão jurídica e fornecedor com DPA ou processamento on-device |
| Exportar cartas (PDF / ZIP) | P2 | Médio | Privacidade e performance |

---

## Fase 4 — Monetização

**Pré-requisito sugerido:** ~10k usuários ativos (alinhado à estratégia freemium → pay-per-feature).

| Entrega | Prioridade | Esforço (est.) | Notas |
|--------|------------|----------------|-------|
| Pay-per-feature premium | — | Alto | Stripe / IAP conforme loja |
| Cartões-presente (compra + resgate / adicionar código) | — | Alto | Alinhado a Stripe / lojas; créditos ou desbloqueio de recursos premium — detalhar na implementação |
| Analytics de produto | — | Médio | Funis, retenção, conversão |

---

## Como usar este roadmap

- Acompanhe o detalhamento de MVP em [`MVP_CHECKLIST.md`](MVP_CHECKLIST.md).
- Mudanças de escopo: atualizar esta tabela e o changelog em [`CHANGELOG.md`](CHANGELOG.md).
- Funcionalidades de **IA com perfilamento, fotos de terceiros ou biometria/emotion** (recomendações, círculo familiar, face): revisar **privacidade, bases legais e fornecedores** antes do lançamento.
