# OpenWhen — Design system

Referência para UI consistente entre telas. Implementação principal: [`lib/shared/theme/app_theme.dart`](../lib/shared/theme/app_theme.dart) e estilos locais em telas específicas (ex.: cápsulas).

---

## Cores (`AppColors`)

| Token | Hex | Uso |
|-------|-----|-----|
| `bg` | `#F7F4F0` | Fundo do app / scaffold |
| `white` | `#FFFFFF` | Superfícies, texto sobre escuro |
| `ink` | `#1A1714` | Texto principal |
| `inkSoft` | `#6B6560` | Texto secundário |
| `inkFaint` | `#C4BFB9` | Placeholder, ícones desativados |
| `accent` | `#C0392B` | Ações primárias, FAB, destaques |
| `accentWarm` | `#F0EAE4` | Fundos de destaque suaves |
| `accentDark` | `#A93226` | Hover / pressed do accent |
| `gold` | `#C9A84C` | Destaques dourados |
| `goldLight` | `#F5EDD6` | Fundos claros dourados |
| `border` | `#EDE8E3` | Bordas de cards e divisórias |
| `divider` | `#F5F0EB` | Divisores leves |
| `cardBorder` | `#EDE8E3` | Alias de borda para cards |

---

## Tipografia

| Uso | Família | Notas |
|-----|---------|--------|
| Títulos / display | **DM Serif Display** | Itálico em `displayLarge`; hierarquia em `titleLarge` |
| Interface | **DM Sans** | `bodyLarge`, `bodyMedium`, `labelLarge`, estilos de navegação |

Fontes carregadas via `google_fonts`.

---

## Componentes globais

- **Marca / lacre (coruja):** `OwlLogo` (envelope completo ou só lacre) e **`OwlSealOpeningAnimation`** para o fluxo interativo (abertura da carta, login). Implementação em [`lib/shared/widgets/owl_logo.dart`](../lib/shared/widgets/owl_logo.dart) — lacre de cera, rosto, asas/corpo opcionais na animação; tamanhos atuais definidos nas telas (ex.: abertura ~52, login ~56).
- **Coruja + feedback (headers):** [`OwlFeedbackAffordance`](../lib/shared/widgets/owl_feedback_affordance.dart) — o alvo tocável é o próprio glifo da coruja (sem ícone separado); inclui animação idle (oscilação + micro-vibração amortecida, intervalos aleatórios por montagem do widget). O sheet partilhado com o botão global está em [`feedback_entry_button.dart`](../lib/shared/widgets/feedback_entry_button.dart) (`showFeedbackSheet`, `FeedbackEntryButton`).
- **FAB:** cor `accent`, cantos arredondados (16), ícone claro sobre accent.
- **Botões elevados:** fundo `ink`, texto branco, padding generoso, raio 16.
- **Botões outline:** borda `inkFaint`, texto `inkSoft`.
- **Bottom navigation:** fundo branco, selecionado `ink`, não selecionado `inkFaint`.

Padrão visual: **header escuro com gradiente** nas telas principais (implementação por tela).

---

## Cápsulas — temas

Definidos em `CreateCapsuleScreen` (`kCapsuleThemes`). Cada tema tem **5 perguntas**; o usuário escolhe **mínimo 2, máximo 5**.

| ID | Emoji | Label | Cor |
|----|-------|-------|-----|
| `memories` | 🧠 | Memórias | `#6B6560` |
| `goals` | 🎯 | Metas | `#C0392B` |
| `feelings` | 💛 | Sentimentos | `#C9A84C` |
| `relationships` | 👥 | Relacionamentos | `#5B8DB8` |
| `growth` | 🌱 | Crescimento | `#4A8C6F` |

---

## Regra de produto — Carta vs Cápsula

| | Carta | Cápsula |
|---|--------|---------|
| Destinatário | Outra pessoa | Você mesmo ou grupo fechado |
| Publicar no feed | Escolha do usuário | Só após revisar ao abrir |
| Conteúdo completo | Pode ser público | Usuário decide ao abrir |

---

## Tagline

*Escreva hoje. Sinta amanhã.*
