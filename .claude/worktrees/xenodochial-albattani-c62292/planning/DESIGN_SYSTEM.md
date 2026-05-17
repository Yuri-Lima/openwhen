# Whenote — Design system

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
- **Kit de ícones SVG:** ficheiros em [`assets/icons/`](../assets/icons/) (traços com `currentColor` — envelope, carta, cápsula, coração, cadeados, sino, brilhos, lacre simplificado, presente). Constantes e widget em [`lib/shared/icons/whenote_icons.dart`](../lib/shared/icons/whenote_icons.dart): `WhenoteIcons.*` e `WhenoteSvgIcon` (`flutter_svg`). Cores seguem o tema (`IconTheme` / parâmetro `color`).
- **Ícone do app (launcher):** arte-mestre [`assets/branding/app_icon.png`](../assets/branding/app_icon.png) (1024×1024). Geração de mipmaps Android e `AppIcon.appiconset` iOS via **flutter_launcher_icons** (secção no `pubspec.yaml`). Após trocar a PNG: `dart run flutter_launcher_icons` na raiz do projeto. Android adaptativo: fundo `#EDE5D8` (alinhado ao papel do produto).
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

## Conquistas (escudos / brasões)

Implementação em [`profile_badges_strip.dart`](../lib/features/gamification/profile_badges_strip.dart). Cada conquista é renderizada como um **escudo** desenhado com `CustomPainter` (`_ShieldPainter`) usando curvas Bézier — formato de brasão largo no topo e pontiagudo na base.

### Cores por categoria

| Categoria | Cor | Conquistas |
|-----------|-----|------------|
| Dourado (marcos) | `#F59E0B` fill/stroke/icon | 1.ª carta enviada, 1.ª abertura, 1.ª recebida |
| Roxo (social) | `#8B5CF6` | 1.ª no feed, 10 curtidas |
| Verde (volume) | `#10B981` | 5 cartas, 10 cartas |
| Coral (especial) | `#E24B4A` | Voz |
| Azul (engajamento) | `#3B82F6` | Perfil completo |
| Amber (dedicação) | `#EF9F27` | 3 dias seguidos |
| Bloqueado | `pal.inkFaint` (tema) | Conquistas não desbloqueadas |

### Estados

- **Desbloqueado:** fill translúcido (`alpha 0x33`), stroke semitransparente (`alpha 0xAA`), ícone opaco. Label em `pal.inkSoft`.
- **Bloqueado:** fill e stroke derivados de `pal.inkFaint` com alphas baixos. Borda tracejada (dash 4 + gap 3 no `PathMetrics`). Ícone translúcido. Label "???".

### Adaptação por tema

As cores dos escudos desbloqueados são saturadas e fixas (funcionam sobre qualquer fundo). As cores bloqueadas e os labels adaptam-se ao tema via `_BadgeColors.lockedFrom(pal)`, `pal.inkSoft` e `pal.inkFaint` — funcionam nos 4 temas (Classic, Dark, Midnight, Sepia).

### Interação

Tap abre `showModalBottomSheet` com: escudo ampliado (64×76), título em `DM Serif Display`, descrição ou dica de desbloqueio em `DM Sans`, e data formatada (`DateFormat.yMMMd` localizado). Fundo do sheet: `pal.card` com borda na cor do escudo (desbloqueado) ou `pal.border` (bloqueado).

---

## Regra de produto — Carta vs Cápsula

| | Carta | Cápsula |
|---|--------|---------|
| Destinatário | Outra pessoa | Só você, ou **coletiva**: convidados abrem na mesma data (só o autor preenche o conteúdo) |
| Publicar no feed | Escolha do usuário | Só após revisar ao abrir |
| Conteúdo completo | Pode ser público | Usuário decide ao abrir |

---

## Tagline

*Escreva hoje. Sinta amanhã.*
