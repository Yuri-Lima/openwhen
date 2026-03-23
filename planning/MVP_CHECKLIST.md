# OpenWhen — Checklist do MVP

Use este arquivo para acompanhamento diário. Marque `[x]` quando concluído.

**Legenda:** 🔴 crítico · 🟡 importante · 🟢 pós-MVP

---

## 🔴 Crítico (bloqueadores do MVP “completo”)

- [ ] Tela de **abertura da cápsula** (animação, revelar perguntas/respostas, fluxo de publicar após revisão)
- [ ] **Avatar de perfil** com upload (funcional em web e mobile)
- [ ] **Notificações FCM** (configuração, permissões, handlers)
- [ ] **Testes em celular real** (build iOS/Android, fluxos principais)
- [ ] **Regras Firestore de produção** (deploy e validação)

---

## 🟡 Importante (logo após o núcleo do MVP)

- [ ] Fotos na cápsula (mobile; comportamento explícito no web)
- [ ] Compartilhamento Stories/Reels
- [ ] Tela **Cartas recebidas** dedicada
- [ ] Badges / gamificação leve
- [ ] Toggle **tema claro/escuro**
- [ ] Feed em **3 camadas**
- [ ] Exportar cartas (PDF / ZIP)

---

## 🟢 Pós-MVP

- [ ] Cápsula coletiva
- [ ] Música de fundo
- [ ] Voz gravada
- [ ] Multilíngue (ex.: en-US)
- [ ] Moderação por IA
- [ ] Premium pay-per-feature (após ~10k usuários)

---

## Concluído (referência)

### Autenticação e onboarding

- [x] Splash
- [x] Onboarding
- [x] Login
- [x] Cadastro

### Cartas e cofre

- [x] Escrever carta
- [x] Cofre com abas (Aguardando / Abertas / Cápsulas)
- [x] Detalhe da carta
- [x] Animação de abertura por estado emocional
- [x] Leitura da carta
- [x] Pedidos de carta
- [x] QR Code (gerar e compartilhar)

### Cápsulas do tempo

- [x] Fluxo criar cápsula (Tema → Perguntas → Detalhes)
- [x] Persistência em Firestore (`capsules`)
- [x] Listagem no Cofre (aba Cápsulas)
- [x] FAB com bottom sheet: Carta ou Cápsula

### Social e perfil

- [x] Feed estilo Instagram
- [x] Curtidas e comentários em tempo real
- [x] Filtros por emoção (feed)
- [x] Seguidores (`follows`)
- [x] Conta pública/privada
- [x] Perfil próprio e de outros
- [x] Busca por @username
- [x] Bloqueios (`blocks`)
- [x] Comentários com moderação
- [x] Configurações
- [x] Termos, Privacidade, Sobre, Ajuda

### Infra

- [x] Firebase (Auth, Firestore, Storage, FCM dependência no projeto)
- [x] Índices Firestore deployados (incl. cápsulas)

---

**Progresso MVP (estimativa):** ~92% — pendências principais na seção 🔴 Crítico.
