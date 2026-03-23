# Changelog

Todas as mudanças notáveis neste projeto serão documentadas aqui.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/),
e este projeto adere ao [Semantic Versioning](https://semver.org/lang/pt-BR/) onde aplicável.

---

## [0.9.0] - 2026-03-23

### Contexto

Release de referência alinhada ao estado do MVP (~**92%**). Consolida funcionalidades já implementadas no repositório e documentação em `planning/`.

### Added (usuário)

- Onboarding, autenticação (login/cadastro), splash
- Feed com curtidas, comentários e filtros por emoção
- Cofre com abas: aguardando, abertas e **cápsulas**
- Escrever cartas, detalhe, leitura e animação de abertura
- Pedidos de carta, QR Code e compartilhamento
- Perfil (próprio e outros), busca por @username, configurações
- Telas legais (termos, privacidade, sobre, ajuda)
- **Cápsulas do tempo:** fluxo em 3 passos (Tema → Perguntas → Detalhes), persistência Firestore, listagem no cofre
- FAB com bottom sheet: nova carta ou nova cápsula
- Seguidores, bloqueios, moderação em comentários

### Added (projeto)

- Pasta `planning/` com roadmap, checklist de MVP, arquitetura, design system, negócio e changelog
- README voltado a desenvolvedores e investidores

### Known limitations / próximos passos

- Tela dedicada de **abertura da cápsula** (revelação + publicar após revisão)
- **Avatar** com upload estável em web e mobile
- **FCM** end-to-end
- **Regras Firestore** de produção e testes em dispositivo real

[0.9.0]: https://github.com/Yuri-Lima/openwhen/releases
