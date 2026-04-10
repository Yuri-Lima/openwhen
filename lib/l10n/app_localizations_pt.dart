// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'OpenWhen';

  @override
  String get splashTagline => 'Cartas para o futuro';

  @override
  String errorGeneric(String error) {
    return 'Erro: $error';
  }

  @override
  String get snackFillAllFields => 'Preencha todos os campos!';

  @override
  String get actionSave => 'Salvar';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionDelete => 'Excluir';

  @override
  String get actionContinue => 'Continuar';

  @override
  String get actionShare => 'Compartilhar';

  @override
  String get actionCopy => 'Copiar';

  @override
  String get actionOk => 'OK';

  @override
  String get locationAskShareTitle => 'Partilhar a sua localização?';

  @override
  String get locationAskShareBody =>
      'O destinatário pode ver onde estava ao enviar e copiar uma ligação do Maps. Também pode exigir abertura apenas num raio de 10 metros deste ponto.';

  @override
  String get locationAskShareAllow => 'Partilhar localização';

  @override
  String get locationAskShareDeny => 'Não partilhar';

  @override
  String get locationAskRestrictTitle => 'Exigir estar no local para abrir?';

  @override
  String get locationAskRestrictBody =>
      'O destinatário só poderá abrir isto num raio de 10 metros do ponto que partilhou.';

  @override
  String get locationAskRestrictYes => 'Sim, em 10 m';

  @override
  String get locationAskRestrictNo => 'Não';

  @override
  String get locationCaptureFailed =>
      'Não foi possível obter a localização. A enviar sem ela.';

  @override
  String get locationShareTileTitle => 'Local do remetente';

  @override
  String get locationShareTileSubtitle =>
      'Toque para copiar a ligação do Google Maps';

  @override
  String get locationCopiedSnack => 'Copiado para a área de transferência';

  @override
  String get locationProximityTooFarTitle => 'Longe demais';

  @override
  String get locationProximityTooFarBody =>
      'Só é possível abrir isto num raio de 10 metros do local partilhado. Aproxime-se e tente de novo.';

  @override
  String get locationProximityNeedLocationTitle => 'Localização necessária';

  @override
  String get locationProximityNeedLocationBody =>
      'Ative os serviços de localização e permita que o OpenWhen aceda à sua localização para abrir isto.';

  @override
  String get navFeed => 'Feed';

  @override
  String get navSearch => 'Buscar';

  @override
  String get navVault => 'Cofre';

  @override
  String get navProfile => 'Perfil';

  @override
  String get homeWriteLetter => 'Escrever Carta';

  @override
  String get homeWriteLetterSubtitle => 'Para alguem especial';

  @override
  String get homeNewCapsule => 'Nova Capsula do Tempo';

  @override
  String get homeNewCapsuleSubtitle => 'Para voce mesmo ou um grupo';

  @override
  String get onboardingTag1 => 'CARTAS PARA O FUTURO';

  @override
  String get onboardingTitle1 => 'Palavras que chegam\nna hora certa';

  @override
  String get onboardingSubtitle1 =>
      'Escreva uma carta hoje. Escolha quando ela será aberta. Deixe o tempo fazer sua magia.';

  @override
  String get onboardingTag2 => 'SEU COFRE DIGITAL';

  @override
  String get onboardingTitle2 => 'Bloqueada até o\nmomento perfeito';

  @override
  String get onboardingSubtitle2 =>
      'A carta fica guardada com segurança até a data que você escolher — pode ser amanhã, ou daqui a 10 anos.';

  @override
  String get onboardingTag3 => 'COMPARTILHE AMOR';

  @override
  String get onboardingTitle3 => 'Inspire outras pessoas\ncom sua história';

  @override
  String get onboardingSubtitle3 =>
      'Cartas abertas podem ir para o feed público. Espalhe amor, amizade e emoção para o mundo.';

  @override
  String get onboardingCreateFirst => 'Criar minha primeira carta';

  @override
  String get onboardingAlreadyHaveAccount => 'Já tenho uma conta';

  @override
  String get loginHeroLetters => 'CARTAS PARA O FUTURO';

  @override
  String get loginHeroCreateAccount => 'CRIE SUA CONTA GRÁTIS';

  @override
  String get loginTabSignIn => 'Entrar';

  @override
  String get loginTabCreateAccount => 'Criar conta';

  @override
  String get hintEmail => 'seu@email.com';

  @override
  String get labelEmail => 'E-mail';

  @override
  String get hintPassword => 'sua senha';

  @override
  String get labelPassword => 'Senha';

  @override
  String get loginForgotPassword => 'Esqueceu a senha?';

  @override
  String get loginButtonSignIn => 'Entrar';

  @override
  String get loginRegisterBlurb =>
      'Crie sua conta em um único passo: nome, e-mail e senha na próxima tela.';

  @override
  String get loginBullet1 => 'Cartas para abrir no futuro';

  @override
  String get loginBullet2 => 'Cofre seguro e feed opcional';

  @override
  String get loginBullet3 => 'Grátis para começar';

  @override
  String get loginCreateAccount => 'Criar minha conta';

  @override
  String get loginAlreadyHaveAccount => 'Já tenho conta — entrar';

  @override
  String get loginOrContinueWith => 'ou continue com';

  @override
  String get loginLegalFooter =>
      'Ao entrar você aceita os Termos de Uso e a Política de Privacidade.';

  @override
  String get registerSuccess =>
      'Conta criada! Verifique seu email e faça login para continuar.';

  @override
  String get hintName => 'seu nome';

  @override
  String get labelName => 'Nome';

  @override
  String get hintCreatePassword => 'crie uma senha';

  @override
  String get registerCreateAccount => 'Criar minha conta';

  @override
  String get registerAlreadyHaveAccount => 'Já tenho uma conta';

  @override
  String get registerLegalFooter =>
      'Ao criar sua conta você aceita os Termos de Uso e a Política de Privacidade.';

  @override
  String get feedPublicHeader => 'FEED PÚBLICO';

  @override
  String get feedFilterAll => 'Para todos';

  @override
  String get feedFilterLove => 'Amor';

  @override
  String get feedFilterFriendship => 'Amizade';

  @override
  String get feedFilterFamily => 'Família';

  @override
  String get feedLayerExplore => 'Explorar';

  @override
  String get feedLayerHighlights => 'Destaques';

  @override
  String get feedLayerFollowing => 'Seguindo';

  @override
  String get feedFiltersButton => 'Feed';

  @override
  String get feedFiltersSheetTitle => 'Escolher feed';

  @override
  String get feedFiltersButtonSemantic => 'Abrir filtros do tipo de feed';

  @override
  String get feedCustomizePinnedFilters => 'Fixar filtros rápidos…';

  @override
  String get feedCustomizePinnedFiltersHint =>
      'Escolha até 3 chips de humor na barra';

  @override
  String get feedPinFiltersSheetTitle => 'Fixar filtros rápidos';

  @override
  String get feedPinFiltersMaxNote =>
      'Até 3 filtros. A ordem segue a sua seleção.';

  @override
  String get feedPinFiltersSave => 'Guardar';

  @override
  String get feedFollowingEmptyTitle => 'Nenhuma carta de quem você segue';

  @override
  String get feedFollowingEmptySubtitle =>
      'Siga perfis para ver as cartas públicas deles aqui.';

  @override
  String get feedFollowingSignedOutTitle => 'Entre para ver este feed';

  @override
  String get feedFollowingSignedOutSubtitle =>
      'A aba Seguindo mostra cartas públicas de quem você segue.';

  @override
  String get feedLoadError =>
      'Não foi possível carregar o feed. Tente novamente.';

  @override
  String get feedLoadMore => 'Carregar mais';

  @override
  String get feedEmptyTitle => 'Nenhuma carta pública ainda';

  @override
  String get feedEmptySubtitle =>
      'Seja o primeiro a compartilhar\numa carta com o mundo';

  @override
  String get feedFilterEmptyTitle => 'Nenhuma carta neste filtro';

  @override
  String get feedFilterEmptySubtitle =>
      'Tente outro filtro ou volte para \"Para todos\"';

  @override
  String feedCardTo(String name) {
    return 'Para: $name';
  }

  @override
  String get feedCardFeatured => '✦ Destaque';

  @override
  String feedOpenedOnDate(String date) {
    return 'Aberta em $date';
  }

  @override
  String feedViewAllComments(int count) {
    return 'Ver todos os $count comentários';
  }

  @override
  String get commentsTitle => 'Comentários';

  @override
  String get commentsEmptyTitle => 'Nenhum comentário ainda';

  @override
  String get commentsEmptySubtitle => 'Seja o primeiro a comentar';

  @override
  String get commentsInputHint => 'Escreva com amor... 💌';

  @override
  String get commentsModerationWarning =>
      'Sua mensagem contém palavras inadequadas. O OpenWhen é um espaço de amor e respeito. 💌';

  @override
  String get commentsModerationAiBlocked =>
      'Este comentário não passou na moderação automática. Reformule com respeito.';

  @override
  String get commentsModerationUnavailable =>
      'A moderação automática não está disponível no momento. Tente de novo em instantes.';

  @override
  String get vaultTitle => 'Meu Cofre';

  @override
  String get vaultSubtitle => 'SUAS CARTAS E CAPSULAS';

  @override
  String get vaultTabReceived => 'Recebidas';

  @override
  String get vaultTabSent => 'Enviadas';

  @override
  String get vaultTabCapsules => 'Capsulas';

  @override
  String get vaultEmptyReceivedTitle => 'Nenhuma carta recebida ainda';

  @override
  String get vaultEmptyReceivedSubtitle =>
      'Quando alguem te enviar uma carta\nela aparecera aqui';

  @override
  String get vaultEmptyReceivedCta =>
      'Compartilhe seu perfil para as pessoas poderem te enviar cartas.';

  @override
  String get vaultEmptyReceivedCtaButton => 'Abrir perfil';

  @override
  String get vaultLetterChipPrivate => '🔒 Privada · Tornar pública';

  @override
  String get vaultLetterChipPublic => '🌍 Pública · Tornar privada';

  @override
  String get vaultLetterSheetMakePublic => 'Tornar pública';

  @override
  String get vaultLetterSheetMakePrivate => 'Tornar privada';

  @override
  String get vaultLetterSheetDelete => 'Remover do cofre';

  @override
  String get vaultLetterSheetFavoriteSoon => 'Favoritar (em breve)';

  @override
  String get vaultLetterDeleteTitle => 'Remover carta?';

  @override
  String get vaultLetterDeleteMessage =>
      'A carta sai do seu cofre e do feed público, se estiver compartilhada.';

  @override
  String get vaultMenuHint =>
      'Dica: toque em ⋯ no card para mudar privacidade ou excluir.';

  @override
  String get vaultMenuHintGotIt => 'Entendi';

  @override
  String get vaultCountdownReady => 'Pronta para abrir!';

  @override
  String vaultCountdownDays(int count) {
    return 'Abre em $count dias';
  }

  @override
  String vaultCountdownHours(int count) {
    return 'Abre em $count horas';
  }

  @override
  String vaultCountdownMinutes(int count) {
    return 'Abre em $count minutos';
  }

  @override
  String get vaultEmptyWaitingTitle => 'Nenhuma carta esperando';

  @override
  String get vaultEmptyWaitingSubtitle =>
      'Quando alguem te enviar uma carta\nela aparecera aqui';

  @override
  String get vaultEmptyOpenedTitle => 'Nenhuma carta aberta ainda';

  @override
  String get vaultEmptyOpenedSubtitle => 'Suas cartas abertas\naparecera aqui';

  @override
  String get vaultEmptySentTitle => 'Nenhuma carta enviada';

  @override
  String get vaultEmptySentSubtitle =>
      'As cartas que voce enviar\naparecera aqui';

  @override
  String get vaultStatusWaiting => 'Aguardando';

  @override
  String get vaultStatusPending => 'Pendente';

  @override
  String get vaultStatusOpened => 'Aberta';

  @override
  String get vaultStatusReady => 'Pronta!';

  @override
  String get vaultStatusLocked => 'Bloqueada';

  @override
  String vaultTo(String name) {
    return 'Para: $name';
  }

  @override
  String vaultFrom(String name) {
    return 'De: $name';
  }

  @override
  String get vaultAlreadyOpened => 'Ja foi aberta!';

  @override
  String get vaultPendingRecipient =>
      'Aguardando o destinatario aceitar a carta';

  @override
  String get vaultOpenLetter => 'Abrir carta';

  @override
  String get vaultLetterOpened => 'Carta aberta';

  @override
  String get vaultReadFullLetter => 'Ler carta completa';

  @override
  String get vaultOpenCapsule => 'Abrir Capsula';

  @override
  String get vaultViewFullCapsule => 'Ver capsula completa';

  @override
  String get vaultEmptyCapsulesTitle => 'Nenhuma capsula ainda';

  @override
  String get vaultEmptyCapsulesSubtitle =>
      'Crie sua primeira capsula do tempo\ne guarde memorias para o futuro';

  @override
  String get vaultCreateCapsule => 'Criar Capsula';

  @override
  String vaultPhotoCount(int count) {
    return '$count foto(s)';
  }

  @override
  String vaultAnswerCount(int count) {
    return '$count resposta(s)';
  }

  @override
  String vaultCapsuleOpenedOn(String date) {
    return 'Aberta em $date';
  }

  @override
  String get vaultCapsuleSealed => 'Selada';

  @override
  String get capsulePhotoAdd => 'Adicionar foto';

  @override
  String get capsulePhotoHint => 'Toque para adicionar uma foto a sua capsula';

  @override
  String get capsulePhotoWebDisabled =>
      'Fotos disponiveis apenas no app mobile';

  @override
  String get capsulePhotoRemove => 'Remover foto';

  @override
  String get capsulePhotoErrorUpload => 'Erro ao enviar foto. Tente novamente.';

  @override
  String capsulePhotoMax(int count) {
    return 'Maximo de $count fotos atingido';
  }

  @override
  String get vaultFilterTitle => 'Filtrar e ordenar';

  @override
  String get vaultFilterSearchHint => 'Buscar por titulo ou nome...';

  @override
  String get vaultFilterSortLabel => 'Ordenar por';

  @override
  String get vaultFilterApply => 'Aplicar';

  @override
  String get vaultFilterClear => 'Limpar filtros';

  @override
  String get vaultFilterOpenDateFrom => 'Abre a partir de';

  @override
  String get vaultFilterOpenDateTo => 'Abre ate';

  @override
  String get vaultFilterClearDate => 'Limpar data';

  @override
  String get vaultFilterPendingOnly => 'Somente pendentes de aceite';

  @override
  String get vaultFilterThemesLabel => 'Temas';

  @override
  String get vaultFilterDirectionAll => 'Todas';

  @override
  String get vaultFilterDirectionReceived => 'Recebidas';

  @override
  String get vaultFilterDirectionSent => 'Enviadas';

  @override
  String get vaultFilterEmptyTitle => 'Nenhum item com este filtro';

  @override
  String get vaultFilterEmptySubtitle =>
      'Ajuste a busca ou limpe os filtros para ver tudo de novo';

  @override
  String get vaultFilterActiveBadge => 'Filtrado';

  @override
  String get vaultSortWaitingOpenDateAsc => 'Data de abertura (mais proxima)';

  @override
  String get vaultSortWaitingOpenDateDesc => 'Data de abertura (mais distante)';

  @override
  String get vaultSortWaitingCreatedDesc => 'Criacao (mais recente)';

  @override
  String get vaultSortWaitingCreatedAsc => 'Criacao (mais antiga)';

  @override
  String get vaultSortWaitingTitleAsc => 'Titulo (A-Z)';

  @override
  String get vaultSortOpenedOpenedAtDesc => 'Aberta em (mais recente)';

  @override
  String get vaultSortOpenedOpenedAtAsc => 'Aberta em (mais antiga)';

  @override
  String get vaultSortOpenedOpenDateDesc => 'Data planejada (mais distante)';

  @override
  String get vaultSortOpenedOpenDateAsc => 'Data planejada (mais proxima)';

  @override
  String get vaultSortOpenedTitleAsc => 'Titulo (A-Z)';

  @override
  String get vaultSortSentOpenDateAsc => 'Data de abertura (mais proxima)';

  @override
  String get vaultSortSentOpenDateDesc => 'Data de abertura (mais distante)';

  @override
  String get vaultSortSentCreatedDesc => 'Criacao (mais recente)';

  @override
  String get vaultSortSentCreatedAsc => 'Criacao (mais antiga)';

  @override
  String get vaultSortSentTitleAsc => 'Titulo (A-Z)';

  @override
  String get vaultSortCapsulesOpenDateAsc => 'Data de abertura (mais proxima)';

  @override
  String get vaultSortCapsulesOpenDateDesc =>
      'Data de abertura (mais distante)';

  @override
  String get vaultSortCapsulesCreatedDesc => 'Criacao (mais recente)';

  @override
  String get vaultSortCapsulesCreatedAsc => 'Criacao (mais antiga)';

  @override
  String get vaultSortCapsulesTitleAsc => 'Titulo (A-Z)';

  @override
  String get capsuleThemeMemories => 'Memorias';

  @override
  String get capsuleThemeGoals => 'Metas';

  @override
  String get capsuleThemeFeelings => 'Sentimentos';

  @override
  String get capsuleThemeRelationships => 'Relacionamentos';

  @override
  String get capsuleThemeGrowth => 'Crescimento';

  @override
  String get capsuleThemeDefault => 'Capsula';

  @override
  String get writeLetterTitle => 'Escrever carta';

  @override
  String get writeLetterFeeling => 'COMO VOCÊ ESTÁ SE SENTINDO?';

  @override
  String get writeLetterEmotionLove => 'Amor';

  @override
  String get writeLetterEmotionAchievement => 'Conquista';

  @override
  String get writeLetterEmotionAdvice => 'Conselho';

  @override
  String get writeLetterEmotionNostalgia => 'Saudade';

  @override
  String get writeLetterEmotionFarewell => 'Despedida';

  @override
  String get writeLetterFieldTitle => 'Título';

  @override
  String get writeLetterFieldTitleHint => 'Ex: Abra quando sentir saudade';

  @override
  String get writeLetterTypeSection => 'TIPO DE CARTA';

  @override
  String get writeLetterTypeTyped => 'Digitada';

  @override
  String get writeLetterTypeHandwritten => 'Manuscrita';

  @override
  String get writeLetterFieldMessage => 'Sua mensagem';

  @override
  String get writeLetterPhotoTap => 'Toque para adicionar a foto da carta';

  @override
  String get writeLetterPhotoHint => 'Tire uma foto da sua carta escrita à mão';

  @override
  String get writeLetterRecipientSection => 'PARA QUEM?';

  @override
  String get writeLetterSearchHint => 'Buscar por @usuario ou nome...';

  @override
  String get writeLetterOrSendExternal => 'ou envie para quem não tem conta';

  @override
  String get writeLetterEmailHint => 'email@exemplo.com';

  @override
  String get writeLetterReceiverLink => 'Receberá um link para criar conta';

  @override
  String get writeLetterOpenDateLabel => 'Data de abertura';

  @override
  String get writeLetterPrivacyNote =>
      'Cartas enviadas são privadas. Só quem recebe pode escolher publicar no feed depois de abrir.';

  @override
  String get writeLetterSend => 'Enviar carta 💌';

  @override
  String get writeLetterSnackTitle => 'Preencha o título!';

  @override
  String get writeLetterSnackMessage => 'Escreva sua mensagem!';

  @override
  String get writeLetterSnackPhoto => 'Adicione a foto da carta!';

  @override
  String get writeLetterSnackRecipient => 'Escolha o destinatário!';

  @override
  String get writeLetterSnackEmotion => 'Escolha o estado emocional!';

  @override
  String get writeLetterSnackSentFriend => 'Carta enviada! 💌';

  @override
  String get writeLetterSnackSentPending =>
      'Carta enviada! Aguardando aprovação. 💌';

  @override
  String get writeLetterSnackSentExternal =>
      'Carta criada! Compartilhe o link com o destinatário. 💌';

  @override
  String get writeLetterSnackEmailInvalid => 'Digite um email válido!';

  @override
  String get writeLetterSnackStorageError =>
      'Ative o Firebase Storage para usar esta função';

  @override
  String get writeLetterMusicUrlLabel => 'Link da música (opcional)';

  @override
  String get writeLetterMusicUrlHint => 'https://open.spotify.com/...';

  @override
  String get writeLetterSnackMusicUrlInvalid =>
      'Use um link https:// válido para a música.';

  @override
  String get writeLetterMessageTapToExpand =>
      'Toque para escrever sua mensagem';

  @override
  String get writeLetterVoiceSection => 'Mensagem de voz (opcional)';

  @override
  String get writeLetterVoiceRecord => 'Gravar';

  @override
  String get writeLetterVoiceStop => 'Parar';

  @override
  String get writeLetterVoiceDiscard => 'Descartar áudio';

  @override
  String get writeLetterVoicePreview => 'Ouvir prévia';

  @override
  String get writeLetterVoiceMaxDuration => 'O limite é 1 minuto.';

  @override
  String get writeLetterVoicePermissionDenied =>
      'Permissão do microfone necessária para gravar.';

  @override
  String get writeLetterVoiceOpenSettings => 'Abrir configurações';

  @override
  String get writeLetterVoiceWillSend => 'Será enviada com a carta';

  @override
  String get writeLetterVoiceUploadError =>
      'Não foi possível enviar o áudio. Tente de novo.';

  @override
  String get writeLetterSendErrorLoadProfile =>
      'Não foi possível carregar o seu perfil. Tente novamente.';

  @override
  String get writeLetterSendErrorFriendshipCheck =>
      'Não foi possível verificar amizade. Tente novamente.';

  @override
  String get writeLetterSendErrorSave =>
      'Não foi possível salvar a carta. Tente novamente.';

  @override
  String get voiceLetterTitle => 'Mensagem de voz';

  @override
  String get voiceLetterSubtitle => 'Gravada pelo remetente';

  @override
  String get voiceLetterPlay => 'Ouvir';

  @override
  String get voiceLetterPause => 'Pausar';

  @override
  String get voiceLetterPlayError => 'Não foi possível reproduzir o áudio.';

  @override
  String get musicLinkTitle => 'Ouvir música';

  @override
  String get musicLinkSubtitle => 'Abre no app ou no navegador';

  @override
  String get musicLinkOpenError => 'Não foi possível abrir este link.';

  @override
  String get letterDetailHeaderFrom => 'UMA CARTA DE';

  @override
  String letterDetailTo(String name) {
    return 'para $name';
  }

  @override
  String letterDetailWrittenOn(String date) {
    return 'Escrita $date';
  }

  @override
  String letterDetailOpenedOn(String date) {
    return 'Aberta $date';
  }

  @override
  String get letterDetailQrTitle => 'Gerar QR Code';

  @override
  String get letterDetailQrSubtitle => 'Coloque no presente físico 🎁';

  @override
  String get letterDetailShareTitle => 'Compartilhar carta';

  @override
  String get letterDetailShareSubtitle =>
      'Instagram Stories ou folha de partilha';

  @override
  String get storyShareFallbackSnack =>
      'Folha de partilha aberta — escolha o Instagram ou outra app.';

  @override
  String get storyShareSheetTitle => 'Compartilhar cápsula';

  @override
  String get storyShareInstagramOption => 'Instagram Stories';

  @override
  String get storyShareTextOption => 'Texto (perguntas e respostas)';

  @override
  String get letterOpeningEmotionLove => 'Uma carta de amor espera por você 💕';

  @override
  String get letterOpeningEmotionAchievement =>
      'Uma conquista foi guardada para você 🏆';

  @override
  String get letterOpeningEmotionAdvice =>
      'Um conselho especial espera por você 🌿';

  @override
  String get letterOpeningEmotionNostalgia => 'Memórias guardadas para você 🍂';

  @override
  String get letterOpeningEmotionFarewell =>
      'Palavras de despedida esperaram por você 🦋';

  @override
  String letterOpeningWrittenOpenedToday(String date) {
    return 'Escrita $date  ·  Aberta hoje';
  }

  @override
  String get letterOpeningPublishFeed => '✦  Publicar no feed';

  @override
  String get letterOpeningKeepPrivate => 'Guardar só para mim';

  @override
  String get letterOpeningTapToOpen => 'TOQUE PARA ABRIR';

  @override
  String get requestsTitle => 'Pedidos de carta';

  @override
  String get requestsSubtitle => 'De pessoas que você não segue';

  @override
  String get requestsEmptyTitle => 'Nenhum pedido pendente';

  @override
  String get requestsEmptySubtitle =>
      'Quando alguém que você não segue\nte enviar uma carta, aparecerá aqui.';

  @override
  String get requestsSheetTitle => 'O que deseja fazer?';

  @override
  String requestsSheetLetterFrom(String name) {
    return 'Carta de $name';
  }

  @override
  String get requestsAccept => 'Aceitar carta';

  @override
  String get requestsDecline => 'Recusar carta';

  @override
  String requestsBlockUser(String name) {
    return 'Bloquear $name';
  }

  @override
  String get requestsSnackAccepted =>
      'Carta aceita! Ela aparecerá no seu cofre. 💌';

  @override
  String get requestsSnackDeclined => 'Carta recusada.';

  @override
  String get requestsSnackBlocked => 'Usuário bloqueado.';

  @override
  String get requestsSenderNotFollowing => 'Pessoa que você não segue';

  @override
  String get requestsBadgePending => 'Pendente';

  @override
  String get requestsRevealHint => 'Aceite para revelar a mensagem';

  @override
  String requestsOpensOn(String date) {
    return 'Abre em $date';
  }

  @override
  String get requestsViewOptions => 'Ver opções';

  @override
  String get qrScreenTitle => 'QR Code da carta';

  @override
  String get qrScreenSubtitle => 'Imprima e coloque no presente';

  @override
  String get qrCardHeadline => 'Uma carta especial espera por você';

  @override
  String qrCardMeta(String sender, String date) {
    return 'De $sender  ·  Abre $date';
  }

  @override
  String get qrScanHint => 'Escaneie para acessar a carta';

  @override
  String get qrHowToTitle => 'Como usar no presente físico';

  @override
  String get qrStep1 => 'Compartilhe o QR Code pelo WhatsApp ou imprima';

  @override
  String get qrStep2 => 'Coloque dentro ou na embalagem do presente';

  @override
  String get qrStep3 => 'A pessoa escaneia e descobre a carta';

  @override
  String get qrStep4 => 'A carta abre automaticamente na data certa';

  @override
  String get qrLinkCopied => 'Link copiado! 🔗';

  @override
  String qrShareText(String title, String link) {
    return '💌 Uma carta especial espera por você no OpenWhen!\n\n\"$title\"\n\nEscaneie o QR Code ou acesse: $link';
  }

  @override
  String get qrShareSubject => 'Uma carta especial espera por você 💌';

  @override
  String qrShareLinkOnly(String title, String link) {
    return '💌 Uma carta especial espera por você no OpenWhen!\n\n\"$title\"\n\nAcesse: $link';
  }

  @override
  String qrShareWhatsApp(String title, String link) {
    return '💌 Uma carta especial espera por você!\n\n\"$title\"\n\nAbra aqui: $link';
  }

  @override
  String get createCapsuleTitle => 'Nova Cápsula do Tempo';

  @override
  String createCapsuleStepProgress(int current, String stepName) {
    return 'Passo $current de 3 — $stepName';
  }

  @override
  String get createCapsuleStepTheme => 'Tema';

  @override
  String get createCapsuleStepMessage => 'Mensagem';

  @override
  String get createCapsuleStepWhen => 'Quando abrir';

  @override
  String get createCapsuleSeal => 'Selar Cápsula 🦉';

  @override
  String get createCapsuleThemeQuestion => 'Qual é a essência\ndessa cápsula?';

  @override
  String get createCapsuleThemeHint => 'Escolha um tema para sua cápsula.';

  @override
  String get createCapsuleAudienceTitle => 'Esta cápsula é para quem?';

  @override
  String get createCapsuleAudiencePersonal => 'Só para mim';

  @override
  String get createCapsuleAudienceCollective => 'Coletiva';

  @override
  String get createCapsuleCollectiveHint =>
      'Convide quem vai abrir esta cápsula consigo na mesma data. Só você escreve o conteúdo.';

  @override
  String get createCapsuleInviteSearchHint => 'Busque por nome ou @usuário';

  @override
  String get createCapsuleCollectiveNeedInvite =>
      'Adicione pelo menos uma pessoa para uma cápsula coletiva.';

  @override
  String createCapsuleMaxParticipants(int max) {
    return 'Uma cápsula pode ter no máximo $max pessoas (incluindo você).';
  }

  @override
  String get vaultCapsuleCollectiveBadge => 'Coletiva';

  @override
  String get capsuleDetailParticipantsHeading => 'Junto com';

  @override
  String get createCapsuleThemeMemoriesLabel => 'Memórias';

  @override
  String get createCapsuleThemeMemoriesSubtitle =>
      'Guarde o que não quer esquecer';

  @override
  String get createCapsuleThemeGoalsLabel => 'Metas';

  @override
  String get createCapsuleThemeGoalsSubtitle => 'Uma promessa para o futuro';

  @override
  String get createCapsuleThemeFeelingsLabel => 'Sentimentos';

  @override
  String get createCapsuleThemeFeelingsSubtitle =>
      'O que está dentro de você agora';

  @override
  String get createCapsuleThemeRelationshipsLabel => 'Relacionamentos';

  @override
  String get createCapsuleThemeRelationshipsSubtitle =>
      'As pessoas que importam';

  @override
  String get createCapsuleThemeGrowthLabel => 'Crescimento';

  @override
  String get createCapsuleThemeGrowthSubtitle => 'Quem você está se tornando';

  @override
  String get createCapsuleWriteHeading => 'Escreva para o\nseu eu do futuro';

  @override
  String get createCapsuleWriteHint =>
      'Escreva livremente. Sem regras. Só você e o futuro.';

  @override
  String get createCapsuleFieldTitle => 'Título';

  @override
  String get createCapsuleFieldTitleHint =>
      'Ex: Para o meu eu de daqui a 1 ano...';

  @override
  String get createCapsuleMusicUrlLabel => 'Link da música (opcional)';

  @override
  String get createCapsuleMusicUrlHint => 'https://music.youtube.com/...';

  @override
  String get createCapsuleFieldMessageHint =>
      'Querido eu do futuro...\n\nEscreva o que está sentindo, o que sonha, o que quer lembrar...';

  @override
  String createCapsuleCharCount(int count) {
    return '$count caracteres';
  }

  @override
  String get createCapsuleCharMin => ' (mínimo 10)';

  @override
  String get createCapsuleWhenHeading => 'Quando você\npoderá abrir?';

  @override
  String get createCapsuleWhenHint => 'Escolha uma data ou evento especial.';

  @override
  String get createCapsuleTypeDate => 'Data';

  @override
  String get createCapsuleTypeEvent => 'Evento';

  @override
  String get createCapsuleTypeBoth => 'Ambos';

  @override
  String get createCapsulePickDate => 'Escolher data';

  @override
  String get createCapsuleCustomEventHint => 'Ou descreva o evento...';

  @override
  String get createCapsulePublishToggle => 'Publicar no feed ao abrir';

  @override
  String get createCapsulePublishHint => 'Você decide depois de rever tudo';

  @override
  String get createCapsuleSuccessTitle => 'Cápsula selada!';

  @override
  String get createCapsuleSuccessBody =>
      'Suas palavras estão guardadas.\nSó você poderá abrir na hora certa.';

  @override
  String get createCapsuleSuccessViewVault => 'Ver meu Cofre';

  @override
  String get createCapsulePresetBirthday => 'Meu aniversário';

  @override
  String get createCapsulePresetAnniversary => 'Nosso aniversário';

  @override
  String get createCapsulePresetGraduation => 'Minha formatura';

  @override
  String get createCapsulePresetBaby => 'Nascimento do bebê';

  @override
  String get createCapsulePresetMoving => 'Nossa mudança';

  @override
  String get createCapsulePresetTrip => 'Fim da viagem';

  @override
  String get createCapsulePresetCareer => 'Nova fase profissional';

  @override
  String get createCapsulePresetChristmas => 'Natal';

  @override
  String get createCapsulePresetNewYear => 'Ano Novo';

  @override
  String get capsuleDetailYourCapsule => 'Sua capsula';

  @override
  String capsuleDetailDates(String createdDate, String openedDate) {
    return 'Criada em $createdDate  ·  Aberta em $openedDate';
  }

  @override
  String get capsuleDetailOnFeed => 'No feed';

  @override
  String get capsuleDetailShareSubtitle =>
      'Instagram Stories ou folha de partilha';

  @override
  String get capsuleDetailDeleteTitle => 'Excluir capsula';

  @override
  String get capsuleDetailDeleteSubtitle => 'Remove do cofre permanentemente';

  @override
  String get capsuleDetailDeleteConfirm => 'Excluir capsula?';

  @override
  String get capsuleDetailDeleteBody => 'Esta acao nao pode ser desfeita.';

  @override
  String get capsuleOpeningHeader => 'CAPSULA DO TEMPO';

  @override
  String get capsuleOpeningThemeMemories => 'Memorias guardadas para o futuro';

  @override
  String get capsuleOpeningThemeGoals => 'Suas metas esperam por voce';

  @override
  String get capsuleOpeningThemeFeelings => 'O que voce sentiu, guardado aqui';

  @override
  String get capsuleOpeningThemeRelationships => 'Conexoes que importam';

  @override
  String get capsuleOpeningThemeGrowth => 'Quem voce esta se tornando';

  @override
  String get capsuleOpeningPublishFeed => 'Publicar no feed';

  @override
  String get capsuleOpeningKeepPrivate => 'Guardar so para mim';

  @override
  String get capsuleOpeningTapToOpen => 'TOQUE PARA ABRIR';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profilePrivate => 'Privada';

  @override
  String get profilePublic => 'Pública';

  @override
  String get profileDefaultName => 'Usuário';

  @override
  String get profileStatFollowers => 'Seguidores';

  @override
  String get profileStatFollowing => 'Seguindo';

  @override
  String get profileStatSent => 'Enviadas';

  @override
  String get profileStatOpened => 'Abertas';

  @override
  String get profileBadgesTitle => 'CONQUISTAS';

  @override
  String get badgeFirstLetterSentTitle => 'Primeira carta';

  @override
  String get badgeFirstLetterSentDesc => 'Você enviou sua primeira carta.';

  @override
  String get badgeFirstLetterOpenedTitle => 'Primeira abertura';

  @override
  String get badgeFirstLetterOpenedDesc => 'Você abriu sua primeira carta.';

  @override
  String get badgeFirstPublicTitle => 'Primeira no feed';

  @override
  String get badgeFirstPublicDesc =>
      'Você compartilhou uma carta no feed público.';

  @override
  String get badgeLettersSentFiveTitle => '5 cartas';

  @override
  String get badgeLettersSentFiveDesc => 'Você enviou 5 cartas.';

  @override
  String get badgeLettersSentTenTitle => '10 cartas';

  @override
  String get badgeLettersSentTenDesc => 'Você enviou 10 cartas.';

  @override
  String get badgeVoiceLetterTitle => 'Voz';

  @override
  String get badgeVoiceLetterDesc => 'Você enviou uma carta com áudio.';

  @override
  String get profileStatLetters => 'Cartas';

  @override
  String get profileEmptyTitle => 'Nenhuma carta publicada';

  @override
  String get profileEmptySubtitle =>
      'Suas cartas abertas e publicas\naparecera aqui';

  @override
  String get editProfileTitle => 'Editar perfil';

  @override
  String get editProfileSectionName => 'NOME';

  @override
  String get editProfileSectionUsername => 'USERNAME';

  @override
  String get editProfileSectionBio => 'BIO';

  @override
  String get editProfileHintName => 'Seu nome completo';

  @override
  String get editProfileHintUsername => 'seu_username';

  @override
  String get editProfileHintBio => 'Conte um pouco sobre voce...';

  @override
  String get editProfileUsernameRules => 'Apenas letras, numeros e _';

  @override
  String get editProfileSaveChanges => 'Salvar alteracoes';

  @override
  String get editProfileErrorNameEmpty => 'Nome nao pode ser vazio';

  @override
  String get editProfileErrorUsernameEmpty => 'Username nao pode ser vazio';

  @override
  String get editProfileErrorUsernameShort =>
      'Username deve ter pelo menos 3 caracteres';

  @override
  String get editProfileErrorUsernameTaken => 'Este username ja esta em uso';

  @override
  String get editProfileSaved => 'Perfil atualizado!';

  @override
  String get userProfileFollowing => 'Seguindo';

  @override
  String get userProfileFollow => 'Seguir';

  @override
  String get userProfileEmptyLetters => 'Nenhuma carta pública ainda';

  @override
  String get searchTitle => 'Buscar pessoas';

  @override
  String get searchHint => 'Buscar por nome ou @username...';

  @override
  String get searchEmpty => 'Nenhum resultado';

  @override
  String get searchMinCharsHint => 'Digite pelo menos 2 caracteres para buscar';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get themeSection => 'TEMA DO APP';

  @override
  String get themeSystem => 'Automático (sistema)';

  @override
  String get themeSystemSubtitle => 'Claro ou escuro conforme o aparelho';

  @override
  String get themeClassic => 'Clássico';

  @override
  String get themeClassicSubtitle => 'Fundo claro e destaque vermelho';

  @override
  String get themeDark => 'Escuro';

  @override
  String get themeDarkSubtitle => 'Interface escura confortável';

  @override
  String get themeMidnight => 'Midnight';

  @override
  String get themeMidnightSubtitle => 'Azul profundo';

  @override
  String get themeSepia => 'Sépia';

  @override
  String get themeSepiaSubtitle => 'Tons quentes no papel';

  @override
  String get languageSection => 'IDIOMA';

  @override
  String get languageSystem => 'Automático (sistema)';

  @override
  String get languageSystemSubtitle =>
      'Usa o idioma do aparelho (pt, en ou es)';

  @override
  String get languagePt => 'Português (Brasil)';

  @override
  String get languageEn => 'English';

  @override
  String get languageEs => 'Español';

  @override
  String get activeLabel => 'Ativo';

  @override
  String get settingsMyAccount => 'MINHA CONTA';

  @override
  String get settingsProfilePhoto => 'Foto de perfil';

  @override
  String get settingsProfilePhotoSubtitle => 'Galeria ou remover';

  @override
  String get avatarChooseFromGallery => 'Escolher da galeria';

  @override
  String get avatarRemovePhoto => 'Remover foto';

  @override
  String get avatarPhotoRemovedSnack => 'Foto removida';

  @override
  String get avatarPhotoUpdatedSnack => 'Foto de perfil atualizada';

  @override
  String avatarUploadError(String error) {
    return 'Não foi possível enviar a foto: $error';
  }

  @override
  String settingsNotifPermissionStatus(String status) {
    return 'Status: $status';
  }

  @override
  String get qrFooterBrand => 'openwhen.life';

  @override
  String get qrShareWhatsAppLabel => 'WhatsApp';

  @override
  String get settingsEditProfile => 'Editar perfil';

  @override
  String get settingsChangePassword => 'Alterar senha';

  @override
  String get settingsPrivacySection => 'PRIVACIDADE E SEGURANÇA';

  @override
  String get settingsPrivateAccount => 'Conta privada';

  @override
  String get settingsPrivateAccountOn => 'Suas cartas não aparecem no feed';

  @override
  String get settingsPrivateAccountOff => 'Suas cartas podem aparecer no feed';

  @override
  String get settingsBlockedUsers => 'Usuários bloqueados';

  @override
  String get settingsWhoCanSend => 'Quem pode me enviar cartas';

  @override
  String get settingsWhoCanSendValue => 'Todos';

  @override
  String get settingsNotificationsSection => 'NOTIFICAÇÕES';

  @override
  String get settingsNotifSystemAlert => 'Permissões de alerta (sistema)';

  @override
  String get settingsNotifSystemAlertSubtitle =>
      'Necessário para receber push no celular';

  @override
  String get settingsNotifUpdated => 'Permissões de notificação atualizadas.';

  @override
  String get settingsNotifLikes => 'Curtidas';

  @override
  String get settingsNotifLikesSubtitle => 'Quando alguém curtir sua carta';

  @override
  String get settingsNotifComments => 'Comentários';

  @override
  String get settingsNotifCommentsSubtitle =>
      'Quando alguém comentar sua carta';

  @override
  String get settingsNotifFollowers => 'Novos seguidores';

  @override
  String get settingsNotifFollowersSubtitle =>
      'Quando alguém começar a te seguir';

  @override
  String get settingsNotifLetterUnlocked => 'Carta desbloqueada';

  @override
  String get settingsNotifLetterUnlockedSubtitle =>
      'Quando uma carta estiver pronta para abrir';

  @override
  String get settingsDataSection => 'DADOS E PRIVACIDADE';

  @override
  String get settingsExportLetters => 'Exportar minhas cartas';

  @override
  String get settingsExportLettersSubtitle =>
      'PDF ou zip com todas as cartas abertas';

  @override
  String get settingsDeleteAccount => 'Deletar conta';

  @override
  String get settingsDeleteAccountSubtitle => 'Esta ação é irreversível';

  @override
  String get settingsLegalSection => 'LEGAL E SUPORTE';

  @override
  String get settingsTerms => 'Termos de uso';

  @override
  String get settingsPrivacy => 'Política de privacidade';

  @override
  String get settingsHelp => 'Ajuda e suporte';

  @override
  String get settingsAbout => 'Sobre o OpenWhen';

  @override
  String get settingsAboutVersion => 'Versão 1.0.0';

  @override
  String get settingsLogout => 'Sair da conta';

  @override
  String get settingsEditProfileSheetTitle => 'Editar perfil';

  @override
  String get settingsEditProfileFieldName => 'Nome';

  @override
  String get settingsEditProfileFieldUsername => '@Username';

  @override
  String get settingsEditProfileFieldBio => 'Bio';

  @override
  String get settingsChangePasswordTitle => 'Alterar senha';

  @override
  String get settingsChangePasswordBody => 'Enviaremos um link para seu email.';

  @override
  String get settingsChangePasswordButton => 'Enviar email de redefinição';

  @override
  String settingsChangePasswordSent(String email) {
    return 'Email enviado para $email';
  }

  @override
  String get settingsExportTitle => 'Exportar cartas';

  @override
  String get settingsExportBody =>
      'Suas cartas abertas serão exportadas em formato PDF. Isso pode levar alguns minutos.';

  @override
  String get settingsExportButton => 'Exportar como ZIP';

  @override
  String get settingsExportZipSubtitle =>
      'Um PDF por carta, mais áudio e imagem manuscrita quando houver.';

  @override
  String settingsExportSuccess(int count) {
    return '$count cartas exportadas.';
  }

  @override
  String get settingsExportSnack => 'Preparando exportação…';

  @override
  String get letterDetailExportPdfTitle => 'Exportar PDF';

  @override
  String get letterDetailExportPdfSubtitle =>
      'Baixe uma cópia portátil desta carta';

  @override
  String get settingsDeleteTitle => 'Deletar conta';

  @override
  String get settingsDeleteBody =>
      'Esta ação é irreversível. Todas as suas cartas, seguidores e dados serão deletados permanentemente.';

  @override
  String get settingsDeletePendingLettersWarning =>
      'Importante: Você pode ter cartas bloqueadas aguardando entrega a destinatários ou cartas aguardando para serem recebidas. Se escolher \"Excluir Tudo\", cartas pendentes que você enviou não serão entregues e cartas que você ainda não abriu serão perdidas. Se escolher \"Anonimizar\", suas cartas enviadas continuarão sendo entregues, mas seu nome será substituído por \"Usuário removido\".';

  @override
  String get settingsDeleteConfirm => 'Confirmar exclusão';

  @override
  String get settingsBlockedTitle => 'Usuários bloqueados';

  @override
  String get settingsBlockedEmpty => 'Nenhum usuário bloqueado.';

  @override
  String get settingsBlockedUnblock => 'Desbloquear';

  @override
  String get legalTitleTerms => 'Termos de Uso';

  @override
  String get legalTitlePrivacy => 'Política de Privacidade';

  @override
  String get legalTitleAbout => 'Sobre o OpenWhen';

  @override
  String get legalTitleHelp => 'Ajuda e Suporte';

  @override
  String legalLastUpdate(String date) {
    return 'Última atualização: $date';
  }

  @override
  String get aboutTagline => 'Escreva hoje. Sinta amanhã.';

  @override
  String get aboutVersion => 'Versão 1.0.0 — Build 2026.03.22';

  @override
  String get aboutWhatIsTitle => 'O que é o OpenWhen';

  @override
  String get aboutWhatIsBody =>
      'O OpenWhen é uma plataforma digital de comunicação temporal e rede social emocional. Permite criar cartas digitais com data futura de abertura, combinando o valor sentimental de uma carta física com a viralidade de uma rede social moderna.';

  @override
  String get aboutSecurityTitle => 'Segurança e Privacidade';

  @override
  String get aboutSecurityBody =>
      'Desenvolvido em conformidade com a LGPD (Lei nº 13.709/2018) e o Marco Civil da Internet (Lei nº 12.965/2014). Seus dados são protegidos com criptografia de ponta e armazenados na infraestrutura Google Cloud Platform.';

  @override
  String get aboutComplianceTitle => 'Conformidade Legal';

  @override
  String get aboutComplianceBody =>
      'O OpenWhen opera em total conformidade com a legislação brasileira vigente, incluindo LGPD, Marco Civil da Internet, Código de Defesa do Consumidor (Lei nº 8.078/1990) e demais normas aplicáveis ao setor de tecnologia.';

  @override
  String get aboutCompanyTitle => 'Empresa';

  @override
  String get aboutCompanyBody =>
      'OpenWhen Tecnologia Ltda. — Empresa brasileira, com sede no Brasil. Foro de eleição: comarca de São Paulo/SP.';

  @override
  String get aboutContacts => 'Contatos';

  @override
  String get aboutContactSupport => 'Suporte geral';

  @override
  String get aboutContactPrivacy => 'Privacidade e LGPD';

  @override
  String get aboutContactLegal => 'Jurídico';

  @override
  String get aboutContactDpo => 'DPO';

  @override
  String get aboutCopyright =>
      '© 2026 OpenWhen Tecnologia Ltda. Todos os direitos reservados.';

  @override
  String get helpCenter => 'Central de Ajuda';

  @override
  String get helpCenterSubtitle =>
      'Encontre respostas para as dúvidas mais frequentes.';

  @override
  String get helpFaqSection => 'PERGUNTAS FREQUENTES';

  @override
  String get helpFaq1Q => 'Como enviar uma carta?';

  @override
  String get helpFaq1A =>
      'Toque no botão ✏️ na tela principal. Preencha o título, selecione o estado emocional, escreva sua mensagem, informe o e-mail do destinatário e defina a data de abertura. A carta ficará bloqueada até a data escolhida.';

  @override
  String get helpFaq2Q => 'O destinatário precisa ter conta no OpenWhen?';

  @override
  String get helpFaq2A =>
      'Sim. Atualmente o destinatário precisa ter uma conta cadastrada no OpenWhen para receber cartas. O envio para e-mails externos estará disponível em breve.';

  @override
  String get helpFaq3Q => 'Posso editar uma carta após o envio?';

  @override
  String get helpFaq3A =>
      'Não. As cartas ficam seladas imediatamente após o envio para preservar a autenticidade e integridade da mensagem, em analogia às cartas físicas. Esta é uma decisão de produto intencional.';

  @override
  String get helpFaq4Q => 'Como funciona o Feed Público?';

  @override
  String get helpFaq4A =>
      'Ao abrir uma carta, você pode optar por publicá-la no Feed Público. Essa autorização é individual por carta. Cartas privadas jamais são exibidas publicamente sem sua autorização expressa.';

  @override
  String get helpFaq5Q => 'Recebi uma carta de um desconhecido. O que fazer?';

  @override
  String get helpFaq5A =>
      'Cartas de pessoas que você não segue ficam em \"Pedidos de Carta\" no Cofre. Você pode aceitar, recusar ou bloquear o remetente sem que ele saiba da sua decisão.';

  @override
  String get helpFaq6Q => 'Como exportar minhas cartas?';

  @override
  String get helpFaq6A =>
      'Acesse Configurações > Dados e Privacidade > Exportar minhas cartas. Você receberá um arquivo com todas as suas cartas abertas, conforme direito de portabilidade garantido pelo art. 18, inciso V, da LGPD.';

  @override
  String get helpFaq7Q => 'Como deletar minha conta?';

  @override
  String get helpFaq7A =>
      'Acesse Configurações > Dados e Privacidade > Deletar conta. A exclusão é irreversível e todos os seus dados serão permanentemente removidos em até 30 dias, conforme art. 18, inciso VI, da LGPD.';

  @override
  String get helpFaq8Q => 'Encontrei um conteúdo ofensivo. Como denunciar?';

  @override
  String get helpFaq8A =>
      'Toque nos três pontos ao lado de qualquer carta ou comentário e selecione \"Denunciar\". Nossa equipe analisará o conteúdo em até 24 horas. Denúncias graves são tratadas com prioridade.';

  @override
  String get reportMenuLabel => 'Denunciar';

  @override
  String get reportSheetTitle => 'Denunciar conteúdo';

  @override
  String get reportSheetSubtitle =>
      'Diga o que está errado. Detalhes opcionais ajudam nossa equipe a analisar mais rápido.';

  @override
  String get reportReasonSpam => 'Spam ou enganoso';

  @override
  String get reportReasonHarassment => 'Assédio ou bullying';

  @override
  String get reportReasonHate => 'Discurso de ódio';

  @override
  String get reportReasonIllegal => 'Conteúdo ilegal';

  @override
  String get reportReasonOther => 'Outro';

  @override
  String get reportDetailLabel => 'Detalhes adicionais (opcional)';

  @override
  String get reportDetailHint => 'Contexto que ajuda a moderação…';

  @override
  String get reportSubmit => 'Enviar denúncia';

  @override
  String get reportSuccess => 'Obrigado — recebemos sua denúncia.';

  @override
  String get adminModerationTitle => 'Moderação';

  @override
  String get adminModerationReportsTab => 'Denúncias';

  @override
  String get adminModerationFeedbackTab => 'Feedback';

  @override
  String get adminModerationIncidentsTab => 'Alertas IA';

  @override
  String get adminModerationAiBannerTitle => 'Moderação por IA (servidor)';

  @override
  String get adminModerationProviderOpenai => 'OpenAI Moderation API';

  @override
  String get adminModerationCredentialsOk => 'Credenciais configuradas';

  @override
  String get adminModerationCredentialsMissing =>
      'Credenciais em falta (env das Functions)';

  @override
  String get adminModerationEmpty => 'Nada pendente.';

  @override
  String get adminModerationResolve => 'Arquivar';

  @override
  String get adminModerationConfirm => 'Marcar como analisado';

  @override
  String get adminModerationLoadError =>
      'Não foi possível carregar a fila de moderação.';

  @override
  String get adminEntrySettings => 'Moderação (admin)';

  @override
  String get adminModerationReviewsTab => 'Revisão humana';

  @override
  String get moderationNotificationsSection => 'Moderação';

  @override
  String get moderationNotificationsEntry => 'Notificações de moderação';

  @override
  String get moderationNotificationsTitle => 'Notificações de moderação';

  @override
  String get moderationNotificationsEmpty => 'Nenhuma notificação.';

  @override
  String get commentsModerationPendingReview =>
      'O comentário foi enviado para revisão. Será notificado quando for aprovado ou rejeitado.';

  @override
  String get commentsModerationQueueFailed =>
      'Não foi possível enviar para revisão. Tente novamente.';

  @override
  String get adminModerationApprove => 'Aprovar e publicar';

  @override
  String get adminModerationReject => 'Rejeitar';

  @override
  String get adminModerationFeedbackLabel =>
      'Mensagem ao utilizador (obrigatório ao rejeitar)';

  @override
  String get adminModerationFeedbackHint => 'Explique o que deve mudar…';

  @override
  String get adminModerationReviewsLoadError =>
      'Não foi possível carregar a fila de revisão.';

  @override
  String get helpNotFoundTitle => 'Não encontrou o que procurava?';

  @override
  String get helpNotFoundBody => 'Nossa equipe está disponível para ajudar:';

  @override
  String get helpResponseTime => 'Tempo de resposta';

  @override
  String get helpResponseTimeValue => 'até 2 dias úteis';

  @override
  String get feedbackTooltip => 'Enviar feedback';

  @override
  String get feedbackSemanticsLabel => 'Enviar feedback ou pedido de recurso';

  @override
  String get feedbackSheetTitle => 'Feedback';

  @override
  String get feedbackCategoryLabel => 'Categoria';

  @override
  String get feedbackTypeFeature => 'Recurso';

  @override
  String get feedbackTypeRecommendation => 'Ideia';

  @override
  String get feedbackTypeGeneral => 'Geral';

  @override
  String get feedbackMessageHint => 'O que você gostaria de compartilhar?';

  @override
  String feedbackCharCount(int current, int max) {
    return '$current / $max';
  }

  @override
  String get feedbackSubmit => 'Enviar';

  @override
  String get feedbackEmptyError => 'Digite uma mensagem.';

  @override
  String get feedbackTooLongError => 'Mensagem muito longa.';

  @override
  String get feedbackSuccess => 'Obrigado — recebemos seu feedback.';

  @override
  String get feedbackSignedOutHint =>
      'Você não está conectado. Vamos abrir o app de e-mail para você enviar para a nossa equipe.';

  @override
  String get feedbackCouldNotOpenEmail =>
      'Não foi possível abrir o e-mail. Contate suporte@openwhen.life.';

  @override
  String feedbackEmailBodyPrefix(String category) {
    return 'Categoria: $category';
  }

  @override
  String get keyboardDismissTooltip => 'Ocultar teclado';

  @override
  String get keyboardDismissSemanticsLabel => 'Fechar teclado';

  @override
  String get subscriptionSectionTitle => 'Plano e assinatura';

  @override
  String get subscriptionScreenTitle => 'Planos';

  @override
  String get subscriptionPlanAmanhaName => 'Amanhã';

  @override
  String get subscriptionPlanBrisaName => 'Brisa';

  @override
  String get subscriptionPlanHorizonteName => 'Horizonte';

  @override
  String get subscriptionPlanAmanhaPitch =>
      'O essencial para escrever hoje e sentir no tempo certo.';

  @override
  String get subscriptionPlanBrisaPitch =>
      'Partilha e expressão: mais profundidade no cofre e nas redes.';

  @override
  String get subscriptionPlanHorizontePitch =>
      'Arquivo, família e inteligência com transparência.';

  @override
  String get subscriptionCurrentPlanLabel => 'O seu plano atual';

  @override
  String get subscriptionSubscribeBrisa => 'Subscrever Brisa';

  @override
  String get subscriptionSubscribeHorizonte => 'Subscrever Horizonte';

  @override
  String get subscriptionManageBilling => 'Gerir assinatura e pagamento';

  @override
  String get subscriptionCheckoutError =>
      'Não foi possível abrir o pagamento. Tente novamente.';

  @override
  String get subscriptionPortalError =>
      'Não foi possível abrir o portal de faturação.';

  @override
  String get subscriptionUpgradeDialogTitle => 'Plano necessário';

  @override
  String subscriptionUpgradeDialogBody(String planName) {
    return 'Esta função exige o plano $planName ou superior.';
  }

  @override
  String get subscriptionUpgradeDialogViewPlans => 'Ver planos';

  @override
  String get subscriptionBillingDisabledBanner =>
      'O checkout de assinatura ainda não está ativado. Pode continuar a usar a app no plano Amanhã. Ative o billing no projeto quando o Stripe estiver pronto.';

  @override
  String get subscriptionBillingDisabledSnack =>
      'Pagamentos ainda não estão activos. Use BILLING_ENABLED=true quando o Stripe estiver configurado.';

  @override
  String get termsIntro =>
      'Estes Termos de Uso (\"Termos\") regulam o acesso e a utilização do aplicativo OpenWhen (\"Plataforma\"), desenvolvido e operado pela OpenWhen Tecnologia Ltda. (\"Empresa\"), inscrita no CNPJ sob o nº [XX.XXX.XXX/0001-XX], com sede no Brasil. A utilização da Plataforma implica a aceitação integral e irrestrita destes Termos, nos termos do art. 8º da Lei nº 12.965/2014 (Marco Civil da Internet) e da Lei nº 13.709/2018 (Lei Geral de Proteção de Dados — LGPD).';

  @override
  String get termsSection1Title => '1. DO OBJETO E NATUREZA DO SERVIÇO';

  @override
  String get termsSection1Body =>
      'O OpenWhen é uma plataforma digital de comunicação temporal que permite aos usuários criar, enviar, receber e armazenar mensagens eletrônicas (\"Cartas\") programadas para abertura em data futura determinada pelo remetente. O serviço possui natureza de intermediação digital de comunicação privada e, quando autorizado pelo usuário, de publicação em ambiente de rede social (\"Feed Público\"). A Empresa atua como provedora de aplicação, nos termos do art. 5º, inciso VII, do Marco Civil da Internet.';

  @override
  String get termsSection2Title => '2. DOS REQUISITOS PARA UTILIZAÇÃO';

  @override
  String get termsSection2Body =>
      'Para utilizar a Plataforma, o usuário deverá: (i) ter capacidade civil plena, nos termos do art. 3º do Código Civil Brasileiro (Lei nº 10.406/2002), ou ser assistido por responsável legal quando menor de 16 anos; (ii) fornecer dados verídicos no cadastro, sob pena de cancelamento imediato da conta, nos termos do art. 7º, inciso VI, do Marco Civil da Internet; (iii) manter a confidencialidade de suas credenciais de acesso, sendo responsável por todas as atividades realizadas em sua conta.';

  @override
  String get termsSection3Title =>
      '3. DAS OBRIGAÇÕES E RESPONSABILIDADES DO USUÁRIO';

  @override
  String get termsSection3Body =>
      'O usuário se compromete a utilizar a Plataforma em conformidade com a legislação vigente, especialmente: (i) a Lei nº 12.965/2014 (Marco Civil da Internet); (ii) a Lei nº 13.709/2018 (LGPD); (iii) o Código Penal Brasileiro no que tange a crimes contra a honra (arts. 138 a 140); (iv) a Lei nº 7.716/1989 (Lei de Crimes de Preconceito); e (v) o Estatuto da Criança e do Adolescente (ECA — Lei nº 8.069/1990). É expressamente vedado ao usuário publicar conteúdo que: (a) seja difamatório, calunioso ou injurioso; (b) incite violência, ódio ou discriminação de qualquer natureza; (c) viole direitos de propriedade intelectual de terceiros; (d) constitua assédio, cyberbullying ou perseguição; (e) envolva pornografia infantil ou conteúdo sexual envolvendo menores de idade.';

  @override
  String get termsSection4Title => '4. DA RESPONSABILIDADE CIVIL DA EMPRESA';

  @override
  String get termsSection4Body =>
      'A Empresa, na qualidade de provedora de aplicação, não se responsabiliza pelo conteúdo gerado pelos usuários (\"UGC — User Generated Content\"), nos termos do art. 19 do Marco Civil da Internet. A responsabilidade civil da Empresa somente será configurada mediante descumprimento de ordem judicial específica determinando a remoção de conteúdo. A Empresa adota mecanismos de moderação e denúncia, sem que isso implique assunção de responsabilidade editorial sobre o conteúdo dos usuários.';

  @override
  String get termsSection5Title => '5. DA PROPRIEDADE INTELECTUAL';

  @override
  String get termsSection5Body =>
      'O usuário é e permanece titular dos direitos autorais sobre o conteúdo que cria na Plataforma, nos termos da Lei nº 9.610/1998 (Lei de Direitos Autorais). Ao publicar conteúdo no Feed Público, o usuário concede à Empresa licença não exclusiva, irrevogável, gratuita e mundial para reproduzir, distribuir e exibir tal conteúdo exclusivamente no âmbito da Plataforma, podendo revogar tal licença mediante a exclusão do conteúdo ou encerramento da conta. A marca, logotipo, design e código-fonte do OpenWhen são de titularidade exclusiva da Empresa e protegidos pela Lei nº 9.279/1996 (Lei da Propriedade Industrial).';

  @override
  String get termsSection6Title => '6. DA VIGÊNCIA E RESCISÃO';

  @override
  String get termsSection6Body =>
      'O presente contrato vigorará por prazo indeterminado a partir do cadastro do usuário. O usuário poderá rescindir o contrato a qualquer momento mediante exclusão de sua conta nas configurações da Plataforma, nos termos do art. 7º, inciso IX, do Marco Civil da Internet. A Empresa reserva-se o direito de suspender ou encerrar contas que violem estes Termos, sem prejuízo das demais medidas legais cabíveis.';

  @override
  String get termsSection7Title =>
      '7. DA DESCONTINUAÇÃO DO SERVIÇO E GARANTIA DE ENTREGA DAS CARTAS';

  @override
  String get termsSection7Body =>
      'O OpenWhen empreende todos os esforços para garantir a entrega de todas as cartas e cápsulas nas datas escolhidas pelo remetente. Em caso de descontinuação planejada dos serviços, a Empresa se compromete a: (i) notificar todos os usuários cadastrados por e-mail e notificação no app com no mínimo 90 (noventa) dias de antecedência do encerramento definitivo; (ii) durante o período de aviso, disponibilizar a exportação de todos os dados do usuário (cartas, cápsulas, perfil, mídia) pelo app ou por e-mail; (iii) entregar todas as cartas bloqueadas cuja data de abertura caia dentro do período de aviso; (iv) após o período de 90 dias, excluir permanente e irreversivelmente todos os dados dos usuários dos seus servidores. A Empresa poderá estabelecer um Fundo de Continuidade — uma reserva financeira suficiente para manter a infraestrutura essencial (Firebase, armazenamento, funções de entrega) por pelo menos 2 (dois) anos mesmo que o app deixe de gerar receita. Quando estabelecido, a existência e o status deste fundo serão documentados nestes Termos. Este compromisso constitui uma garantia de produto, não uma obrigação legal, e poderá ser ajustado conforme a capacidade financeira da Empresa evolua.';

  @override
  String get termsSection8Title => '8. DAS DISPOSIÇÕES GERAIS';

  @override
  String get termsSection8Body =>
      'Estes Termos são regidos pelas leis da República Federativa do Brasil. Fica eleito o foro da comarca de São Paulo/SP para dirimir quaisquer controvérsias decorrentes deste instrumento, com renúncia expressa a qualquer outro foro, por mais privilegiado que seja. A nulidade de qualquer cláusula não afeta a validade das demais. Dúvidas e notificações devem ser encaminhadas para: juridico@openwhen.life. Última atualização: 10 de abril de 2026.';

  @override
  String get privacyIntro =>
      'Esta Política de Privacidade (\"Política\") descreve como a OpenWhen Tecnologia Ltda. (\"Empresa\", \"nós\", \"nos\", \"nosso\") coleta, trata, armazena e compartilha os dados pessoais dos usuários da plataforma e do aplicativo móvel OpenWhen (\"Plataforma\"). Esta Política tem alcance global e está em conformidade com: (a) a Lei Geral de Proteção de Dados — LGPD (Lei nº 13.709/2018); (b) o Regulamento Geral de Proteção de Dados da União Europeia — GDPR (Regulamento EU 2016/679); (c) a Lei de Privacidade do Consumidor da Califórnia e a Lei de Direitos de Privacidade da Califórnia — CCPA/CPRA (California Civil Code §§ 1798.100–1798.199.100); (d) o Marco Civil da Internet (Lei nº 12.965/2014); e (e) a Lei de Proteção da Privacidade Online das Crianças dos EUA — COPPA (16 CFR Part 312). A Empresa atua como Controladora de Dados (LGPD art. 5º VI / GDPR art. 4(7)) e como \"Business\" nos termos da CCPA. Data de vigência: 10 de abril de 2026.';

  @override
  String get privacySection1Title => '1. DEFINIÇÕES';

  @override
  String get privacySection1Body =>
      'Para os fins desta Política: \"Dados Pessoais\" significa qualquer informação relacionada a pessoa natural identificada ou identificável (LGPD art. 5º I / GDPR art. 4(1)); \"Informação Pessoal\" (PI) tem o significado definido na CCPA § 1798.140(v); \"Tratamento\" significa qualquer operação realizada com dados pessoais (LGPD art. 5º X / GDPR art. 4(2)); \"Titular dos Dados\" ou \"Consumidor\" significa qualquer pessoa natural cujos dados pessoais são tratados; \"Controlador\" significa a entidade que determina as finalidades e os meios do tratamento; \"Operador\" ou \"Processador\" significa a entidade que trata dados em nome do Controlador; \"Dados Pessoais Sensíveis\" significa dados relativos à origem racial ou étnica, convicção religiosa, opinião política, saúde, vida sexual ou dados biométricos/genéticos (LGPD art. 5º II / GDPR art. 9).';

  @override
  String get privacySection2Title => '2. DADOS QUE COLETAMOS';

  @override
  String get privacySection2Body =>
      'Coletamos as seguintes categorias de dados pessoais:\n\n(a) Dados de Cadastro: nome completo, nome de exibição, endereço de e-mail, nome de usuário, foto de perfil (opcional) e texto biográfico (opcional).\n\n(b) Conteúdo Gerado pelo Usuário: cartas (texto, título, estado emocional), imagens de cartas manuscritas (capturadas pela câmera), mensagens de voz (até 1 minuto, capturadas pelo microfone), cápsulas do tempo (texto, tema, fotos), comentários em cartas públicas e links opcionais de música.\n\n(c) Dados de Localização Precisa (opt-in): quando você opta por anexar uma localização a uma carta ou cápsula, coletamos suas coordenadas GPS precisas (latitude e longitude) e o momento da captura. Você também pode ativar um requisito de proximidade (aproximadamente 10 metros) para o destinatário abrir a carta. A coleta de localização é sempre opcional e solicitada por carta ou cápsula — nunca coletamos localização em segundo plano.\n\n(d) Dados Técnicos e de Dispositivo: endereço IP, identificador do dispositivo, sistema operacional, versão do app, token de notificação push (Firebase Cloud Messaging), plataforma do dispositivo (Android/iOS/web), idioma preferido e logs de acesso nos termos do art. 15 do Marco Civil da Internet.\n\n(e) Dados de Analytics: eventos de uso (cartas criadas, abertas, compartilhadas; cápsulas criadas, abertas; visualizações do feed; curtidas, comentários, follows; visualizações de perfil; alterações de tema e idioma), visualizações de tela e relatórios de falhas/erros, coletados via Firebase Analytics e Firebase Crashlytics.\n\n(f) Dados Sociais: relações de seguidores/seguindo, bloqueios entre usuários, curtidas em cartas públicas e comentários.\n\n(g) Dados de Cobrança: quando os recursos de assinatura estão habilitados, armazenamos seu identificador de cliente Stripe, identificador de assinatura, nível de assinatura (free/plus/pro) e status da assinatura. Dados de cartão de pagamento são processados e armazenados exclusivamente pelo Stripe e nunca passam pelos nossos servidores.\n\n(h) Dados de Moderação: denúncias de conteúdo enviadas por usuários (motivo, detalhe, conteúdo alvo), resultados de análise de moderação por IA (categorias sinalizadas e pontuações), registros de revisão humana de moderação e logs de incidentes de moderação.\n\n(i) Dados de Comunicação: mensagens de feedback do produto (incluindo metadados de plataforma e idioma do app) e solicitações de suporte.\n\n(j) Dados de Gamificação: registros de desbloqueio de badges e histórico de notificações no app.\n\nPara fins da CCPA, as categorias de PI coletadas nos últimos 12 meses incluem: identificadores (nome, e-mail, nome de usuário, ID do dispositivo); atividade de rede de internet/eletrônica (eventos de uso, logs de acesso); dados de geolocalização (GPS preciso quando opt-in); informações de áudio/visuais (mensagens de voz, fotos); e informações profissionais ou pessoais inferidas do conteúdo que você cria.';

  @override
  String get privacySection3Title => '3. COMO COLETAMOS DADOS';

  @override
  String get privacySection3Body =>
      '(a) Diretamente de você: quando você cria uma conta, escreve cartas ou cápsulas, envia fotos ou mensagens de voz, concede permissão de localização, envia feedback, publica comentários ou interage com outros usuários.\n\n(b) Automaticamente: dados técnicos e de dispositivo, eventos de analytics, relatórios de falhas e tokens de notificação push são coletados automaticamente quando você usa a Plataforma, por meio dos SDKs do Firebase integrados ao app.\n\n(c) De terceiros: atualizações de status de pagamento do Stripe (via webhooks) quando os recursos de assinatura estão ativos; atestação de dispositivo do Firebase App Check (Play Integrity no Android, DeviceCheck no iOS) para proteção contra abusos.';

  @override
  String get privacySection4Title => '4. BASES LEGAIS PARA O TRATAMENTO';

  @override
  String get privacySection4Body =>
      'Nos termos da LGPD (art. 7º) e do GDPR (art. 6), tratamos seus dados com base em:\n\n(a) Consentimento (LGPD art. 7º I / GDPR art. 6(1)(a)): manifestado no cadastro quando você aceita esta Política; para recursos opcionais como dados de localização e mensagens de voz, o consentimento é obtido no momento do uso.\n\n(b) Execução de Contrato (LGPD art. 7º V / GDPR art. 6(1)(b)): tratamento necessário para a prestação dos serviços da Plataforma — entrega de cartas, gerenciamento de cápsulas, recursos sociais e manutenção da sua conta.\n\n(c) Legítimo Interesse (LGPD art. 7º IX / GDPR art. 6(1)(f)): melhoria da Plataforma, prevenção a fraudes, moderação de conteúdo, segurança do serviço e analytics. Realizamos teste de proporcionalidade para garantir que nossos interesses não se sobreponham aos seus direitos fundamentais.\n\n(d) Obrigação Legal (LGPD art. 7º II / GDPR art. 6(1)(c)): retenção de logs de acesso por 6 meses (Marco Civil da Internet art. 15), cumprimento de ordens judiciais e requisitos regulatórios.\n\nNos termos da CCPA, a coleta e uso de PI está detalhada nas Seções 2, 6 e 8 desta Política. Não utilizamos nem divulgamos informações pessoais sensíveis para finalidades além das permitidas pela CCPA § 1798.121.';

  @override
  String get privacySection5Title => '5. FINALIDADES DO TRATAMENTO';

  @override
  String get privacySection5Body =>
      'Tratamos seus dados pessoais para as seguintes finalidades: (i) prestação e operação dos serviços da Plataforma (entrega de cartas, gerenciamento de cápsulas, feed social); (ii) personalização da experiência (temas, idioma, estados emocionais); (iii) envio de notificações relacionadas ao serviço (alertas de entrega de cartas, lembretes de abertura de cápsulas) via notificações push e, quando aplicável, e-mail; (iv) moderação de conteúdo para garantir um ambiente seguro e respeitoso; (v) analytics e melhoria contínua da Plataforma; (vi) prevenção a fraudes e garantia de segurança; (vii) processamento de pagamentos e gerenciamento de assinaturas (quando habilitados); (viii) cumprimento de obrigações legais e regulatórias; (ix) exercício regular de direitos em processos judiciais, administrativos ou arbitrais. Não utilizamos seus dados para publicidade de terceiros, perfilamento comportamental para segmentação de anúncios ou venda a corretores de dados.';

  @override
  String get privacySection6Title => '6. DECISÕES AUTOMATIZADAS E PERFILAMENTO';

  @override
  String get privacySection6Body =>
      'A Plataforma utiliza moderação automatizada de conteúdo alimentada por inteligência artificial (API de Moderação da OpenAI) para analisar conteúdo textual (como comentários) em busca de material potencialmente prejudicial. Este sistema pode: (a) permitir a publicação do conteúdo sem intervenção (pontuação de risco baixa); (b) apresentar um aviso gentil ao autor permitindo a publicação (pontuação de risco média); ou (c) bloquear a publicação do conteúdo (pontuação de risco alta). Quando a moderação humana está ativada, conteúdo sinalizado é encaminhado para revisão manual pela nossa equipe antes de uma decisão final. Nenhuma decisão automatizada é baseada em categorias de dados pessoais sensíveis. Nos termos do GDPR art. 22, você tem o direito de não ser submetido a decisões baseadas unicamente em tratamento automatizado que produzam efeitos jurídicos ou igualmente significativos. Você pode contestar qualquer decisão automatizada de moderação contatando privacidade@openwhen.life ou através do recurso de denúncia/feedback no app. Nos termos da LGPD art. 20, você pode solicitar a revisão de decisões automatizadas que afetem seus interesses.';

  @override
  String get privacySection7Title =>
      '7. COMPARTILHAMENTO DE DADOS E OPERADORES TERCEIROS';

  @override
  String get privacySection7Body =>
      'Não vendemos, alugamos ou comercializamos seus dados pessoais. Para fins da CCPA: não vendemos nem compartilhamos (conforme definido na CCPA § 1798.140(ad) e (ah)) informações pessoais de consumidores nos últimos 12 meses, e não temos conhecimento efetivo de venda ou compartilhamento de PI de consumidores menores de 16 anos. Os dados são compartilhados com as seguintes categorias de prestadores de serviço/operadores, cada um vinculado por acordos de processamento de dados:\n\n(a) Google LLC / Firebase: infraestrutura em nuvem (banco de dados Firestore, Cloud Storage para arquivos, Cloud Functions para lógica do servidor), serviços de autenticação, notificações push (FCM), analytics (Firebase Analytics), relatórios de falhas (Crashlytics) e atestação de dispositivo (App Check). O Google trata dados como Operador sob nossas instruções. Compromissos de privacidade do Google: https://firebase.google.com/support/privacy.\n\n(b) OpenAI, Inc.: conteúdo textual é enviado à API de Moderação da OpenAI exclusivamente para análise de segurança de conteúdo. Apenas o texto do conteúdo sendo moderado é transmitido — nenhum identificador de usuário, imagem ou dado de voz é enviado. A política de uso de dados da OpenAI para clientes da API estabelece que inputs da API não são usados para treinar modelos.\n\n(c) Twilio Inc. (SendGrid): endereços de e-mail de destinatários externos são processados para enviar e-mails de convite quando uma carta é endereçada a alguém que ainda não possui conta. Apenas o e-mail do destinatário, um nome de exibição do remetente e um título da carta são incluídos.\n\n(d) Stripe, Inc.: quando os recursos de assinatura/pagamento estão ativos, o Stripe processa dados de cartão de pagamento, identificadores de cliente e status de assinatura. Os dados do cartão são coletados diretamente pelo Stripe e nunca passam pelos nossos servidores.\n\n(e) Google Fonts: o app pode carregar fontes tipográficas dos servidores do Google, o que envolve o envio do seu endereço IP para o Google.\n\n(f) Autoridades públicas: podemos compartilhar dados com autoridades governamentais quando exigido por ordem judicial ou requisição legal fundamentada.\n\n(g) Transações corporativas: em caso de fusão, aquisição ou reestruturação, seus dados poderão ser transferidos à entidade sucessora, que ficará vinculada a esta Política.';

  @override
  String get privacySection8Title =>
      '8. TRANSFERÊNCIAS INTERNACIONAIS DE DADOS';

  @override
  String get privacySection8Body =>
      'Seus dados pessoais são armazenados em servidores operados pelo Google Cloud Platform, que podem estar localizados nos Estados Unidos ou em outros países fora do seu país de residência. Estas transferências são realizadas em conformidade com: (a) LGPD art. 33, mediante cláusulas contratuais padrão aprovadas pela Autoridade Nacional de Proteção de Dados (ANPD); (b) GDPR Capítulo V, com base em Cláusulas Contratuais Padrão (SCCs) adotadas pela Comissão Europeia (Decisão 2021/914) e, quando aplicável, medidas suplementares conforme a decisão Schrems II; (c) para operadores baseados nos EUA, compromissos contratuais que garantem proteção de dados equivalente à prevista na legislação aplicável. Para a OpenAI e o Stripe, os dados processados nos Estados Unidos estão sujeitos aos respectivos acordos de processamento de dados que incorporam SCCs.';

  @override
  String get privacySection9Title => '9. RETENÇÃO DE DADOS';

  @override
  String get privacySection9Body =>
      'Retemos seus dados pelo período mínimo necessário para as finalidades descritas nesta Política. Períodos específicos de retenção:\n\n• Dados de conta/perfil: retidos até a exclusão da conta.\n• Cartas e cápsulas: retidas até a exclusão pelo titular ou exclusão/anonimização da conta.\n• Comentários, curtidas, follows: retidos até exclusão pelo titular ou exclusão da conta.\n• Tokens de notificação push (FCM): sobrescritos a cada login; excluídos na exclusão da conta.\n• Dados de localização precisa: armazenados apenas quando opt-in; excluídos ou anonimizados na exclusão da conta.\n• Dados de cobrança (IDs Stripe): assinatura cancelada e IDs excluídos na exclusão da conta. O Stripe pode reter dados conforme sua própria política de retenção.\n• Denúncias de conteúdo: anonimizadas 90 dias após resolução.\n• Feedback do produto: anonimizado após 1 ano.\n• Logs de moderação: retidos por 2 anos (sem PII direta).\n• Dados de analytics (Firebase): retidos conforme política padrão do Firebase (14 meses para dados em nível de usuário).\n• Logs de auditoria de exclusão: retidos por 3 anos com identificadores hasheados (não reversíveis) apenas — sem PII.\n• Logs de acesso: retidos por 6 meses nos termos do art. 15 do Marco Civil da Internet.\n\nAo término destes períodos, os dados são permanentemente excluídos ou irreversivelmente anonimizados.';

  @override
  String get privacySection10Title => '10. SEUS DIREITOS';

  @override
  String get privacySection10Body =>
      'Seus direitos variam conforme sua jurisdição. Você pode exercer qualquer um dos direitos abaixo pelo app (Configurações > Dados e Privacidade), por e-mail para privacidade@openwhen.life (ou privacy@openwhen.life para inglês), ou contatando nosso DPO.\n\n— LGPD (Brasil — Art. 18): Você tem direito a: (i) confirmação da existência de tratamento; (ii) acesso aos dados; (iii) correção de dados incompletos ou inexatos; (iv) anonimização, bloqueio ou eliminação de dados desnecessários ou excessivos; (v) portabilidade a outro prestador de serviços; (vi) eliminação dos dados tratados com base no consentimento; (vii) informação sobre terceiros com quem os dados foram compartilhados; (viii) informação sobre a possibilidade de negar consentimento e suas consequências; (ix) revogação do consentimento. Prazo de resposta: 15 dias úteis. Você pode registrar reclamação junto à ANPD (Autoridade Nacional de Proteção de Dados): https://www.gov.br/anpd.\n\n— GDPR (UE/EEE — Arts. 15–22): Você tem direito a: (i) acesso (art. 15); (ii) retificação (art. 16); (iii) apagamento / direito ao esquecimento (art. 17); (iv) limitação do tratamento (art. 18); (v) portabilidade dos dados (art. 20); (vi) oposição ao tratamento baseado em interesse legítimo (art. 21); (vii) não ser submetido a decisões exclusivamente automatizadas, incluindo perfilamento (art. 22) — veja a Seção 6 acima; (viii) retirar o consentimento a qualquer momento (art. 7(3)). Prazo de resposta: 30 dias. Você pode apresentar reclamação à autoridade supervisora local.\n\n— CCPA/CPRA (Califórnia): Como consumidor da Califórnia, você tem direito a: (i) saber quais PI coletamos, usamos, divulgamos e vendemos (Direito de Saber); (ii) solicitar a exclusão de suas PI (Direito de Exclusão) — prazo de resposta: 45 dias; (iii) corrigir PI imprecisas (Direito de Correção); (iv) recusar a venda ou compartilhamento de PI — não vendemos nem compartilhamos suas PI, mas você pode enviar uma solicitação a qualquer momento; (v) limitar o uso de PI sensíveis — não utilizamos PI sensíveis além do necessário para prestar nossos serviços; (vi) não discriminação pelo exercício de seus direitos. Você pode designar um agente autorizado para enviar solicitações em seu nome. Verificamos solicitações usando o e-mail da sua conta. As categorias de PI coletadas, finalidades e divulgações a terceiros estão detalhadas nas Seções 2, 5 e 7.';

  @override
  String get privacySection11Title => '11. EXCLUSÃO DE CONTA';

  @override
  String get privacySection11Body =>
      'Você pode excluir sua conta a qualquer momento em Configurações > Dados e Privacidade > Excluir Conta. Antes da exclusão, você deverá se reautenticar por segurança. Serão oferecidos dois modos:\n\n(a) Excluir Tudo: remove permanentemente seu perfil, todas as cartas (enviadas e recebidas), cápsulas, comentários, curtidas, follows, bloqueios, denúncias, feedback, badges, notificações e todos os arquivos enviados (fotos, mensagens de voz, imagens manuscritas). Seu registro de autenticação no Firebase também é excluído.\n\n(b) Anonimizar: preserva cartas e cápsulas para seus destinatários, mas substitui seu nome por \"Usuário removido\" e remove suas informações identificáveis (ID de usuário, dados de localização, mídia pessoal). Seu perfil, conexões sociais, comentários e curtidas são excluídos.\n\nEm ambos os modos: (i) assinaturas Stripe ativas são canceladas; (ii) um log de auditoria não reversível é registrado (identificador hasheado + timestamp, sem PII) para fins de compliance; (iii) a exclusão é irreversível. Cartas bloqueadas que você já enviou podem continuar a ser entregues aos seus destinatários conforme nossos Termos de Uso — uma carta enviada é um presente confiado ao destinatário.';

  @override
  String get privacySection12Title => '12. PORTABILIDADE E EXPORTAÇÃO DE DADOS';

  @override
  String get privacySection12Body =>
      'Nos termos da LGPD art. 18 V e GDPR art. 20, você tem o direito de receber seus dados pessoais em formato estruturado, de uso comum e leitura automática. Você pode exportar seus dados em Configurações > Dados e Privacidade > Exportar Meus Dados. A exportação inclui: suas informações de perfil (JSON), todas as cartas enviadas (JSON + arquivos de mídia anexados), cápsulas criadas (JSON + fotos), seus comentários (JSON), curtidas (JSON), listas de seguidores/seguindo (JSON) e badges (JSON). A exportação é gerada como um arquivo ZIP. Você também pode solicitar uma exportação manual contatando privacidade@openwhen.life.';

  @override
  String get privacySection13Title => '13. PRIVACIDADE DE CRIANÇAS';

  @override
  String get privacySection13Body =>
      'O OpenWhen não é direcionado a crianças menores de 13 anos. Em conformidade com a COPPA (16 CFR Part 312), não coletamos intencionalmente informações pessoais de crianças menores de 13 anos. Durante o cadastro, os usuários devem confirmar que têm 13 anos ou mais. Se tomarmos conhecimento de que coletamos dados de uma criança menor de 13 anos sem consentimento parental verificável, excluiremos prontamente tais dados. Pais ou responsáveis que acreditam que seu filho forneceu dados pessoais a nós podem entrar em contato pelo e-mail privacidade@openwhen.life para solicitar a exclusão. Para usuários de 13 a 17 anos, recomendamos orientação dos pais ao usar a Plataforma.';

  @override
  String get privacySection14Title => '14. MEDIDAS DE SEGURANÇA';

  @override
  String get privacySection14Body =>
      'Implementamos medidas técnicas e organizacionais adequadas para proteger seus dados pessoais, incluindo: (a) criptografia em trânsito usando TLS 1.3 para todas as comunicações entre o app e nossos servidores; (b) criptografia em repouso para dados armazenados no Google Cloud/Firebase; (c) Firebase App Check (Play Integrity no Android, DeviceCheck no iOS) para proteger serviços de backend contra abusos; (d) controle de acesso baseado em funções limitando o acesso de colaboradores a dados pessoais; (e) Regras de Segurança do Firestore aplicando restrições de acesso a dados no nível do banco de dados; (f) monitoramento contínuo de segurança e logging. Em caso de violação de dados pessoais: nos termos do GDPR, notificaremos a autoridade supervisora competente em até 72 horas após tomar conhecimento da violação (art. 33) e os titulares afetados sem demora indevida quando a violação representar alto risco (art. 34); nos termos da LGPD, notificaremos a ANPD e os titulares afetados em prazo razoável (art. 48); nos termos da CCPA, notificaremos os consumidores californianos afetados conforme exigido pelo California Civil Code § 1798.82.';

  @override
  String get privacySection15Title => '15. TECNOLOGIAS DE RASTREAMENTO';

  @override
  String get privacySection15Body =>
      'A Plataforma não utiliza cookies tradicionais de navegador. No entanto, as seguintes tecnologias coletam dados automaticamente: (a) Firebase Analytics: coleta eventos de uso anônimos, visualizações de tela e propriedades do dispositivo usando identificadores móveis. Você pode redefinir seu identificador de publicidade nas configurações do dispositivo. O período de retenção do Firebase Analytics é de 14 meses. (b) Firebase Crashlytics: coleta relatórios de falhas incluindo estado do dispositivo, versão do app e rastreamento de pilha para nos ajudar a corrigir bugs. (c) Firebase App Check: verifica a integridade do dispositivo para proteção contra abusos automatizados. Estas tecnologias são essenciais para a operação, segurança e melhoria da Plataforma. Não utilizamos nenhuma tecnologia de rastreamento para publicidade ou rastreamento comportamental entre sites/apps. Respeitamos o sinal Global Privacy Control (GPC) como solicitação válida de opt-out nos termos da CCPA.';

  @override
  String get privacySection16Title => '16. ALTERAÇÕES NESTA POLÍTICA';

  @override
  String get privacySection16Body =>
      'Podemos atualizar esta Política periodicamente para refletir mudanças em nossas práticas, requisitos legais ou funcionalidades da Plataforma. Quando fizermos alterações materiais, iremos: (a) atualizar a \"Data de vigência\" no topo desta Política; (b) notificá-lo via notificação no app e/ou e-mail com pelo menos 15 dias de antecedência; (c) para alterações que exijam renovação de consentimento nos termos do GDPR ou da LGPD, solicitar seu consentimento expresso antes que as alterações entrem em vigor. O uso continuado da Plataforma após a data de vigência de uma atualização que não requeira consentimento constitui aceitação da Política revisada. Versões anteriores desta Política estão disponíveis mediante solicitação.';

  @override
  String get privacySection17Title => '17. FALE CONOSCO';

  @override
  String get privacySection17Body =>
      'Se você tem dúvidas sobre esta Política, deseja exercer seus direitos ou precisa reportar uma preocupação de privacidade, entre em contato:\n\n• Encarregado de Proteção de Dados (DPO): dpo@openwhen.life\n• Solicitações de privacidade (português): privacidade@openwhen.life\n• Solicitações de privacidade (inglês): privacy@openwhen.life\n• Departamento jurídico: juridico@openwhen.life\n• Suporte geral: suporte@openwhen.life\n\nBrasil — Você pode registrar reclamação junto à ANPD: https://www.gov.br/anpd\nUE/EEE — Você pode apresentar reclamação à autoridade supervisora de proteção de dados local.\nCalifórnia — Você pode contatar o Procurador-Geral da Califórnia: https://oag.ca.gov/privacy\n\nOpenWhen Tecnologia Ltda.\nÚltima atualização: 10 de abril de 2026.';

  @override
  String get letterPrivacyPublicLabel => 'Pública';

  @override
  String get letterPrivacyPublicSubtitle => 'Aparece no feed para todos';

  @override
  String get letterPrivacyPrivateLabel => 'Privada';

  @override
  String get letterPrivacyPrivateSubtitle => 'Só você pode ver';

  @override
  String get letterPrivacyActionMakePublic => 'Tornar pública';

  @override
  String get letterPrivacyActionMakePrivate => 'Tornar privada';

  @override
  String get letterDetailSentView => 'SUA CARTA ENVIADA';

  @override
  String get feedReadMore => 'Ler mais';

  @override
  String get feedReadFullLetter => 'Ler carta completa';

  @override
  String get feedCardToAnonymous => 'Para: alguém especial';

  @override
  String get vaultLetterSheetHideReceiver => 'Ocultar nome do destinatário';

  @override
  String get vaultLetterSheetShowReceiver => 'Mostrar nome do destinatário';

  @override
  String get feedRemoveFromFeed => 'Remover do feed';

  @override
  String get feedHideSenderName => 'Ocultar quem me enviou';

  @override
  String get feedShowSenderName => 'Mostrar quem me enviou';

  @override
  String get feedSenderAnonymous => 'Alguém especial';

  @override
  String get registerAcceptTermsPrefix => 'Li e aceito os ';

  @override
  String get registerAcceptTermsAnd => ' e a ';

  @override
  String get registerConfirmAge => 'Confirmo que tenho 13 anos ou mais';

  @override
  String get registerMustAcceptTerms =>
      'Você precisa aceitar os termos e confirmar sua idade para continuar';

  @override
  String get settingsDeleteChoiceTitle =>
      'O que deve acontecer com suas cartas?';

  @override
  String get settingsDeleteOptionDeleteAll => 'Apagar tudo';

  @override
  String get settingsDeleteOptionDeleteAllDesc =>
      'Todas as cartas, cápsulas e dados serão removidos permanentemente.';

  @override
  String get settingsDeleteOptionAnonymize => 'Anonimizar minhas cartas';

  @override
  String get settingsDeleteOptionAnonymizeDesc =>
      'Suas cartas permanecem para os destinatários, mas seu nome e dados são removidos.';

  @override
  String get settingsDeletePasswordLabel => 'CONFIRME SUA SENHA';

  @override
  String get settingsDeletePasswordHint => 'Digite sua senha atual';

  @override
  String get settingsDeleteIrreversibleConfirm =>
      'Entendo que esta ação é irreversível e todos os meus dados serão processados de acordo com minha escolha acima.';

  @override
  String get settingsDeleteProcessing => 'Deletando sua conta...';

  @override
  String get settingsDeleteWrongPassword => 'Senha incorreta. Tente novamente.';

  @override
  String get settingsDeleteReauthFailed =>
      'Falha na autenticação. Tente novamente.';

  @override
  String get settingsDeleteError =>
      'Falha ao deletar conta. Tente novamente mais tarde.';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appName => 'OpenWhen';

  @override
  String get splashTagline => 'Cartas para o futuro';

  @override
  String errorGeneric(String error) {
    return 'Erro: $error';
  }

  @override
  String get snackFillAllFields => 'Preencha todos os campos!';

  @override
  String get actionSave => 'Salvar';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionDelete => 'Excluir';

  @override
  String get actionContinue => 'Continuar';

  @override
  String get actionShare => 'Compartilhar';

  @override
  String get actionCopy => 'Copiar';

  @override
  String get actionOk => 'OK';

  @override
  String get locationAskShareTitle => 'Compartilhar sua localização?';

  @override
  String get locationAskShareBody =>
      'O destinatário pode ver onde você estava ao enviar e copiar um link do Maps. Você também pode exigir abertura apenas num raio de 10 metros deste ponto.';

  @override
  String get locationAskShareAllow => 'Compartilhar localização';

  @override
  String get locationAskShareDeny => 'Não compartilhar';

  @override
  String get locationAskRestrictTitle => 'Exigir estar no local para abrir?';

  @override
  String get locationAskRestrictBody =>
      'O destinatário só poderá abrir isto num raio de 10 metros do ponto que você compartilhou.';

  @override
  String get locationAskRestrictYes => 'Sim, em 10 m';

  @override
  String get locationAskRestrictNo => 'Não';

  @override
  String get locationCaptureFailed =>
      'Não foi possível obter a localização. Enviando sem ela.';

  @override
  String get locationShareTileTitle => 'Local do remetente';

  @override
  String get locationShareTileSubtitle =>
      'Toque para copiar o link do Google Maps';

  @override
  String get locationCopiedSnack => 'Copiado para a área de transferência';

  @override
  String get locationProximityTooFarTitle => 'Longe demais';

  @override
  String get locationProximityTooFarBody =>
      'Só é possível abrir isto num raio de 10 metros do local compartilhado. Aproxime-se e tente de novo.';

  @override
  String get locationProximityNeedLocationTitle => 'Localização necessária';

  @override
  String get locationProximityNeedLocationBody =>
      'Ative os serviços de localização e permita que o OpenWhen acesse sua localização para abrir isto.';

  @override
  String get navFeed => 'Feed';

  @override
  String get navSearch => 'Buscar';

  @override
  String get navVault => 'Cofre';

  @override
  String get navProfile => 'Perfil';

  @override
  String get homeWriteLetter => 'Escrever Carta';

  @override
  String get homeWriteLetterSubtitle => 'Para alguem especial';

  @override
  String get homeNewCapsule => 'Nova Capsula do Tempo';

  @override
  String get homeNewCapsuleSubtitle => 'Para voce mesmo ou um grupo';

  @override
  String get onboardingTag1 => 'CARTAS PARA O FUTURO';

  @override
  String get onboardingTitle1 => 'Palavras que chegam\nna hora certa';

  @override
  String get onboardingSubtitle1 =>
      'Escreva uma carta hoje. Escolha quando ela será aberta. Deixe o tempo fazer sua magia.';

  @override
  String get onboardingTag2 => 'SEU COFRE DIGITAL';

  @override
  String get onboardingTitle2 => 'Bloqueada até o\nmomento perfeito';

  @override
  String get onboardingSubtitle2 =>
      'A carta fica guardada com segurança até a data que você escolher — pode ser amanhã, ou daqui a 10 anos.';

  @override
  String get onboardingTag3 => 'COMPARTILHE AMOR';

  @override
  String get onboardingTitle3 => 'Inspire outras pessoas\ncom sua história';

  @override
  String get onboardingSubtitle3 =>
      'Cartas abertas podem ir para o feed público. Espalhe amor, amizade e emoção para o mundo.';

  @override
  String get onboardingCreateFirst => 'Criar minha primeira carta';

  @override
  String get onboardingAlreadyHaveAccount => 'Já tenho uma conta';

  @override
  String get loginHeroLetters => 'CARTAS PARA O FUTURO';

  @override
  String get loginHeroCreateAccount => 'CRIE SUA CONTA GRÁTIS';

  @override
  String get loginTabSignIn => 'Entrar';

  @override
  String get loginTabCreateAccount => 'Criar conta';

  @override
  String get hintEmail => 'seu@email.com';

  @override
  String get labelEmail => 'E-mail';

  @override
  String get hintPassword => 'sua senha';

  @override
  String get labelPassword => 'Senha';

  @override
  String get loginForgotPassword => 'Esqueceu a senha?';

  @override
  String get loginButtonSignIn => 'Entrar';

  @override
  String get loginRegisterBlurb =>
      'Crie sua conta em um único passo: nome, e-mail e senha na próxima tela.';

  @override
  String get loginBullet1 => 'Cartas para abrir no futuro';

  @override
  String get loginBullet2 => 'Cofre seguro e feed opcional';

  @override
  String get loginBullet3 => 'Grátis para começar';

  @override
  String get loginCreateAccount => 'Criar minha conta';

  @override
  String get loginAlreadyHaveAccount => 'Já tenho conta — entrar';

  @override
  String get loginOrContinueWith => 'ou continue com';

  @override
  String get loginLegalFooter =>
      'Ao entrar você aceita os Termos de Uso e a Política de Privacidade.';

  @override
  String get registerSuccess =>
      'Conta criada! Verifique seu email e faça login para continuar.';

  @override
  String get hintName => 'seu nome';

  @override
  String get labelName => 'Nome';

  @override
  String get hintCreatePassword => 'crie uma senha';

  @override
  String get registerCreateAccount => 'Criar minha conta';

  @override
  String get registerAlreadyHaveAccount => 'Já tenho uma conta';

  @override
  String get registerLegalFooter =>
      'Ao criar sua conta você aceita os Termos de Uso e a Política de Privacidade.';

  @override
  String get feedPublicHeader => 'FEED PÚBLICO';

  @override
  String get feedFilterAll => 'Para todos';

  @override
  String get feedFilterLove => 'Amor';

  @override
  String get feedFilterFriendship => 'Amizade';

  @override
  String get feedFilterFamily => 'Família';

  @override
  String get feedLayerExplore => 'Explorar';

  @override
  String get feedLayerHighlights => 'Destaques';

  @override
  String get feedLayerFollowing => 'Seguindo';

  @override
  String get feedFiltersButton => 'Feed';

  @override
  String get feedFiltersSheetTitle => 'Escolher feed';

  @override
  String get feedFiltersButtonSemantic => 'Abrir filtros do tipo de feed';

  @override
  String get feedCustomizePinnedFilters => 'Fixar filtros rápidos…';

  @override
  String get feedCustomizePinnedFiltersHint =>
      'Escolha até 3 chips de humor na barra';

  @override
  String get feedPinFiltersSheetTitle => 'Fixar filtros rápidos';

  @override
  String get feedPinFiltersMaxNote =>
      'Até 3 filtros. A ordem segue a sua seleção.';

  @override
  String get feedPinFiltersSave => 'Guardar';

  @override
  String get feedFollowingEmptyTitle => 'Nenhuma carta de quem você segue';

  @override
  String get feedFollowingEmptySubtitle =>
      'Siga perfis para ver as cartas públicas deles aqui.';

  @override
  String get feedFollowingSignedOutTitle => 'Entre para ver este feed';

  @override
  String get feedFollowingSignedOutSubtitle =>
      'A aba Seguindo mostra cartas públicas de quem você segue.';

  @override
  String get feedLoadError =>
      'Não foi possível carregar o feed. Tente novamente.';

  @override
  String get feedLoadMore => 'Carregar mais';

  @override
  String get feedEmptyTitle => 'Nenhuma carta pública ainda';

  @override
  String get feedEmptySubtitle =>
      'Seja o primeiro a compartilhar\numa carta com o mundo';

  @override
  String get feedFilterEmptyTitle => 'Nenhuma carta neste filtro';

  @override
  String get feedFilterEmptySubtitle =>
      'Tente outro filtro ou volte para \"Para todos\"';

  @override
  String feedCardTo(String name) {
    return 'Para: $name';
  }

  @override
  String get feedCardFeatured => '✦ Destaque';

  @override
  String feedOpenedOnDate(String date) {
    return 'Aberta em $date';
  }

  @override
  String feedViewAllComments(int count) {
    return 'Ver todos os $count comentários';
  }

  @override
  String get commentsTitle => 'Comentários';

  @override
  String get commentsEmptyTitle => 'Nenhum comentário ainda';

  @override
  String get commentsEmptySubtitle => 'Seja o primeiro a comentar';

  @override
  String get commentsInputHint => 'Escreva com amor... 💌';

  @override
  String get commentsModerationWarning =>
      'Sua mensagem contém palavras inadequadas. O OpenWhen é um espaço de amor e respeito. 💌';

  @override
  String get commentsModerationAiBlocked =>
      'Este comentário não passou na moderação automática. Reformule com respeito.';

  @override
  String get commentsModerationUnavailable =>
      'A moderação automática não está disponível no momento. Tente de novo em instantes.';

  @override
  String get vaultTitle => 'Meu Cofre';

  @override
  String get vaultSubtitle => 'SUAS CARTAS E CAPSULAS';

  @override
  String get vaultTabReceived => 'Recebidas';

  @override
  String get vaultTabSent => 'Enviadas';

  @override
  String get vaultTabCapsules => 'Capsulas';

  @override
  String get vaultEmptyReceivedTitle => 'Nenhuma carta recebida ainda';

  @override
  String get vaultEmptyReceivedSubtitle =>
      'Quando alguem te enviar uma carta\nela aparecera aqui';

  @override
  String get vaultEmptyReceivedCta =>
      'Compartilhe seu perfil para as pessoas poderem te enviar cartas.';

  @override
  String get vaultEmptyReceivedCtaButton => 'Abrir perfil';

  @override
  String get vaultLetterChipPrivate => '🔒 Privada · Tornar pública';

  @override
  String get vaultLetterChipPublic => '🌍 Pública · Tornar privada';

  @override
  String get vaultLetterSheetMakePublic => 'Tornar pública';

  @override
  String get vaultLetterSheetMakePrivate => 'Tornar privada';

  @override
  String get vaultLetterSheetDelete => 'Remover do cofre';

  @override
  String get vaultLetterSheetFavoriteSoon => 'Favoritar (em breve)';

  @override
  String get vaultLetterDeleteTitle => 'Remover carta?';

  @override
  String get vaultLetterDeleteMessage =>
      'A carta sai do seu cofre e do feed público, se estiver compartilhada.';

  @override
  String get vaultMenuHint =>
      'Dica: toque em ⋯ no card para mudar privacidade ou excluir.';

  @override
  String get vaultMenuHintGotIt => 'Entendi';

  @override
  String get vaultCountdownReady => 'Pronta para abrir!';

  @override
  String vaultCountdownDays(int count) {
    return 'Abre em $count dias';
  }

  @override
  String vaultCountdownHours(int count) {
    return 'Abre em $count horas';
  }

  @override
  String vaultCountdownMinutes(int count) {
    return 'Abre em $count minutos';
  }

  @override
  String get vaultEmptyWaitingTitle => 'Nenhuma carta esperando';

  @override
  String get vaultEmptyWaitingSubtitle =>
      'Quando alguem te enviar uma carta\nela aparecera aqui';

  @override
  String get vaultEmptyOpenedTitle => 'Nenhuma carta aberta ainda';

  @override
  String get vaultEmptyOpenedSubtitle => 'Suas cartas abertas\naparecera aqui';

  @override
  String get vaultEmptySentTitle => 'Nenhuma carta enviada';

  @override
  String get vaultEmptySentSubtitle =>
      'As cartas que voce enviar\naparecera aqui';

  @override
  String get vaultStatusWaiting => 'Aguardando';

  @override
  String get vaultStatusPending => 'Pendente';

  @override
  String get vaultStatusOpened => 'Aberta';

  @override
  String get vaultStatusReady => 'Pronta!';

  @override
  String get vaultStatusLocked => 'Bloqueada';

  @override
  String vaultTo(String name) {
    return 'Para: $name';
  }

  @override
  String vaultFrom(String name) {
    return 'De: $name';
  }

  @override
  String get vaultAlreadyOpened => 'Ja foi aberta!';

  @override
  String get vaultPendingRecipient =>
      'Aguardando o destinatario aceitar a carta';

  @override
  String get vaultOpenLetter => 'Abrir carta';

  @override
  String get vaultLetterOpened => 'Carta aberta';

  @override
  String get vaultReadFullLetter => 'Ler carta completa';

  @override
  String get vaultOpenCapsule => 'Abrir Capsula';

  @override
  String get vaultViewFullCapsule => 'Ver capsula completa';

  @override
  String get vaultEmptyCapsulesTitle => 'Nenhuma capsula ainda';

  @override
  String get vaultEmptyCapsulesSubtitle =>
      'Crie sua primeira capsula do tempo\ne guarde memorias para o futuro';

  @override
  String get vaultCreateCapsule => 'Criar Capsula';

  @override
  String vaultPhotoCount(int count) {
    return '$count foto(s)';
  }

  @override
  String vaultAnswerCount(int count) {
    return '$count resposta(s)';
  }

  @override
  String vaultCapsuleOpenedOn(String date) {
    return 'Aberta em $date';
  }

  @override
  String get vaultCapsuleSealed => 'Selada';

  @override
  String get capsulePhotoAdd => 'Adicionar foto';

  @override
  String get capsulePhotoHint => 'Toque para adicionar uma foto a sua capsula';

  @override
  String get capsulePhotoWebDisabled =>
      'Fotos disponiveis apenas no app mobile';

  @override
  String get capsulePhotoRemove => 'Remover foto';

  @override
  String get capsulePhotoErrorUpload => 'Erro ao enviar foto. Tente novamente.';

  @override
  String capsulePhotoMax(int count) {
    return 'Maximo de $count fotos atingido';
  }

  @override
  String get vaultFilterTitle => 'Filtrar e ordenar';

  @override
  String get vaultFilterSearchHint => 'Buscar por título ou nome...';

  @override
  String get vaultFilterSortLabel => 'Ordenar por';

  @override
  String get vaultFilterApply => 'Aplicar';

  @override
  String get vaultFilterClear => 'Limpar filtros';

  @override
  String get vaultFilterOpenDateFrom => 'Abre a partir de';

  @override
  String get vaultFilterOpenDateTo => 'Abre até';

  @override
  String get vaultFilterClearDate => 'Limpar data';

  @override
  String get vaultFilterPendingOnly => 'Somente pendentes de aceite';

  @override
  String get vaultFilterThemesLabel => 'Temas';

  @override
  String get vaultFilterDirectionAll => 'Todas';

  @override
  String get vaultFilterDirectionReceived => 'Recebidas';

  @override
  String get vaultFilterDirectionSent => 'Enviadas';

  @override
  String get vaultFilterEmptyTitle => 'Nenhum item com este filtro';

  @override
  String get vaultFilterEmptySubtitle =>
      'Ajuste a busca ou limpe os filtros para ver tudo de novo';

  @override
  String get vaultFilterActiveBadge => 'Filtrado';

  @override
  String get vaultSortWaitingOpenDateAsc => 'Data de abertura (mais próxima)';

  @override
  String get vaultSortWaitingOpenDateDesc => 'Data de abertura (mais distante)';

  @override
  String get vaultSortWaitingCreatedDesc => 'Criação (mais recente)';

  @override
  String get vaultSortWaitingCreatedAsc => 'Criação (mais antiga)';

  @override
  String get vaultSortWaitingTitleAsc => 'Título (A–Z)';

  @override
  String get vaultSortOpenedOpenedAtDesc => 'Aberta em (mais recente)';

  @override
  String get vaultSortOpenedOpenedAtAsc => 'Aberta em (mais antiga)';

  @override
  String get vaultSortOpenedOpenDateDesc => 'Data planejada (mais distante)';

  @override
  String get vaultSortOpenedOpenDateAsc => 'Data planejada (mais próxima)';

  @override
  String get vaultSortOpenedTitleAsc => 'Título (A–Z)';

  @override
  String get vaultSortSentOpenDateAsc => 'Data de abertura (mais próxima)';

  @override
  String get vaultSortSentOpenDateDesc => 'Data de abertura (mais distante)';

  @override
  String get vaultSortSentCreatedDesc => 'Criação (mais recente)';

  @override
  String get vaultSortSentCreatedAsc => 'Criação (mais antiga)';

  @override
  String get vaultSortSentTitleAsc => 'Título (A–Z)';

  @override
  String get vaultSortCapsulesOpenDateAsc => 'Data de abertura (mais próxima)';

  @override
  String get vaultSortCapsulesOpenDateDesc =>
      'Data de abertura (mais distante)';

  @override
  String get vaultSortCapsulesCreatedDesc => 'Criação (mais recente)';

  @override
  String get vaultSortCapsulesCreatedAsc => 'Criação (mais antiga)';

  @override
  String get vaultSortCapsulesTitleAsc => 'Título (A–Z)';

  @override
  String get capsuleThemeMemories => 'Memorias';

  @override
  String get capsuleThemeGoals => 'Metas';

  @override
  String get capsuleThemeFeelings => 'Sentimentos';

  @override
  String get capsuleThemeRelationships => 'Relacionamentos';

  @override
  String get capsuleThemeGrowth => 'Crescimento';

  @override
  String get capsuleThemeDefault => 'Capsula';

  @override
  String get writeLetterTitle => 'Escrever carta';

  @override
  String get writeLetterFeeling => 'COMO VOCÊ ESTÁ SE SENTINDO?';

  @override
  String get writeLetterEmotionLove => 'Amor';

  @override
  String get writeLetterEmotionAchievement => 'Conquista';

  @override
  String get writeLetterEmotionAdvice => 'Conselho';

  @override
  String get writeLetterEmotionNostalgia => 'Saudade';

  @override
  String get writeLetterEmotionFarewell => 'Despedida';

  @override
  String get writeLetterFieldTitle => 'Título';

  @override
  String get writeLetterFieldTitleHint => 'Ex: Abra quando sentir saudade';

  @override
  String get writeLetterTypeSection => 'TIPO DE CARTA';

  @override
  String get writeLetterTypeTyped => 'Digitada';

  @override
  String get writeLetterTypeHandwritten => 'Manuscrita';

  @override
  String get writeLetterFieldMessage => 'Sua mensagem';

  @override
  String get writeLetterPhotoTap => 'Toque para adicionar a foto da carta';

  @override
  String get writeLetterPhotoHint => 'Tire uma foto da sua carta escrita à mão';

  @override
  String get writeLetterRecipientSection => 'PARA QUEM?';

  @override
  String get writeLetterSearchHint => 'Buscar por @usuario ou nome...';

  @override
  String get writeLetterOrSendExternal => 'ou envie para quem não tem conta';

  @override
  String get writeLetterEmailHint => 'email@exemplo.com';

  @override
  String get writeLetterReceiverLink => 'Receberá um link para criar conta';

  @override
  String get writeLetterOpenDateLabel => 'Data de abertura';

  @override
  String get writeLetterPrivacyNote =>
      'Cartas enviadas são privadas. Só quem recebe pode escolher publicar no feed depois de abrir.';

  @override
  String get writeLetterSend => 'Enviar carta 💌';

  @override
  String get writeLetterSnackTitle => 'Preencha o título!';

  @override
  String get writeLetterSnackMessage => 'Escreva sua mensagem!';

  @override
  String get writeLetterSnackPhoto => 'Adicione a foto da carta!';

  @override
  String get writeLetterSnackRecipient => 'Escolha o destinatário!';

  @override
  String get writeLetterSnackEmotion => 'Escolha o estado emocional!';

  @override
  String get writeLetterSnackSentFriend => 'Carta enviada! 💌';

  @override
  String get writeLetterSnackSentPending =>
      'Carta enviada! Aguardando aprovação. 💌';

  @override
  String get writeLetterSnackSentExternal =>
      'Carta criada! Compartilhe o link com o destinatário. 💌';

  @override
  String get writeLetterSnackEmailInvalid => 'Digite um email válido!';

  @override
  String get writeLetterSnackStorageError =>
      'Ative o Firebase Storage para usar esta função';

  @override
  String get writeLetterMusicUrlLabel => 'Link da música (opcional)';

  @override
  String get writeLetterMusicUrlHint => 'https://open.spotify.com/...';

  @override
  String get writeLetterSnackMusicUrlInvalid =>
      'Use um link https:// válido para a música.';

  @override
  String get writeLetterMessageTapToExpand =>
      'Toque para escrever sua mensagem';

  @override
  String get writeLetterVoiceSection => 'Mensagem de voz (opcional)';

  @override
  String get writeLetterVoiceRecord => 'Gravar';

  @override
  String get writeLetterVoiceStop => 'Parar';

  @override
  String get writeLetterVoiceDiscard => 'Descartar áudio';

  @override
  String get writeLetterVoicePreview => 'Ouvir prévia';

  @override
  String get writeLetterVoiceMaxDuration => 'O limite é 1 minuto.';

  @override
  String get writeLetterVoicePermissionDenied =>
      'Permissão do microfone necessária para gravar.';

  @override
  String get writeLetterVoiceOpenSettings => 'Abrir configurações';

  @override
  String get writeLetterVoiceWillSend => 'Será enviada com a carta';

  @override
  String get writeLetterVoiceUploadError =>
      'Não foi possível enviar o áudio. Tente de novo.';

  @override
  String get writeLetterSendErrorLoadProfile =>
      'Não foi possível carregar o seu perfil. Tente novamente.';

  @override
  String get writeLetterSendErrorFriendshipCheck =>
      'Não foi possível verificar amizade. Tente novamente.';

  @override
  String get writeLetterSendErrorSave =>
      'Não foi possível salvar a carta. Tente novamente.';

  @override
  String get voiceLetterTitle => 'Mensagem de voz';

  @override
  String get voiceLetterSubtitle => 'Gravada pelo remetente';

  @override
  String get voiceLetterPlay => 'Ouvir';

  @override
  String get voiceLetterPause => 'Pausar';

  @override
  String get voiceLetterPlayError => 'Não foi possível reproduzir o áudio.';

  @override
  String get musicLinkTitle => 'Ouvir música';

  @override
  String get musicLinkSubtitle => 'Abre no app ou no navegador';

  @override
  String get musicLinkOpenError => 'Não foi possível abrir este link.';

  @override
  String get letterDetailHeaderFrom => 'UMA CARTA DE';

  @override
  String letterDetailTo(String name) {
    return 'para $name';
  }

  @override
  String letterDetailWrittenOn(String date) {
    return 'Escrita $date';
  }

  @override
  String letterDetailOpenedOn(String date) {
    return 'Aberta $date';
  }

  @override
  String get letterDetailQrTitle => 'Gerar QR Code';

  @override
  String get letterDetailQrSubtitle => 'Coloque no presente físico 🎁';

  @override
  String get letterDetailShareTitle => 'Compartilhar carta';

  @override
  String get letterDetailShareSubtitle =>
      'Instagram Stories ou folha de partilha';

  @override
  String get storyShareFallbackSnack =>
      'Folha de partilha aberta — escolha o Instagram ou outra app.';

  @override
  String get storyShareSheetTitle => 'Compartilhar cápsula';

  @override
  String get storyShareInstagramOption => 'Instagram Stories';

  @override
  String get storyShareTextOption => 'Texto (perguntas e respostas)';

  @override
  String get letterOpeningEmotionLove => 'Uma carta de amor espera por você 💕';

  @override
  String get letterOpeningEmotionAchievement =>
      'Uma conquista foi guardada para você 🏆';

  @override
  String get letterOpeningEmotionAdvice =>
      'Um conselho especial espera por você 🌿';

  @override
  String get letterOpeningEmotionNostalgia => 'Memórias guardadas para você 🍂';

  @override
  String get letterOpeningEmotionFarewell =>
      'Palavras de despedida esperaram por você 🦋';

  @override
  String letterOpeningWrittenOpenedToday(String date) {
    return 'Escrita $date  ·  Aberta hoje';
  }

  @override
  String get letterOpeningPublishFeed => '✦  Publicar no feed';

  @override
  String get letterOpeningKeepPrivate => 'Guardar só para mim';

  @override
  String get letterOpeningTapToOpen => 'TOQUE PARA ABRIR';

  @override
  String get requestsTitle => 'Pedidos de carta';

  @override
  String get requestsSubtitle => 'De pessoas que você não segue';

  @override
  String get requestsEmptyTitle => 'Nenhum pedido pendente';

  @override
  String get requestsEmptySubtitle =>
      'Quando alguém que você não segue\nte enviar uma carta, aparecerá aqui.';

  @override
  String get requestsSheetTitle => 'O que deseja fazer?';

  @override
  String requestsSheetLetterFrom(String name) {
    return 'Carta de $name';
  }

  @override
  String get requestsAccept => 'Aceitar carta';

  @override
  String get requestsDecline => 'Recusar carta';

  @override
  String requestsBlockUser(String name) {
    return 'Bloquear $name';
  }

  @override
  String get requestsSnackAccepted =>
      'Carta aceita! Ela aparecerá no seu cofre. 💌';

  @override
  String get requestsSnackDeclined => 'Carta recusada.';

  @override
  String get requestsSnackBlocked => 'Usuário bloqueado.';

  @override
  String get requestsSenderNotFollowing => 'Pessoa que você não segue';

  @override
  String get requestsBadgePending => 'Pendente';

  @override
  String get requestsRevealHint => 'Aceite para revelar a mensagem';

  @override
  String requestsOpensOn(String date) {
    return 'Abre em $date';
  }

  @override
  String get requestsViewOptions => 'Ver opções';

  @override
  String get qrScreenTitle => 'QR Code da carta';

  @override
  String get qrScreenSubtitle => 'Imprima e coloque no presente';

  @override
  String get qrCardHeadline => 'Uma carta especial espera por você';

  @override
  String qrCardMeta(String sender, String date) {
    return 'De $sender  ·  Abre $date';
  }

  @override
  String get qrScanHint => 'Escaneie para acessar a carta';

  @override
  String get qrHowToTitle => 'Como usar no presente físico';

  @override
  String get qrStep1 => 'Compartilhe o QR Code pelo WhatsApp ou imprima';

  @override
  String get qrStep2 => 'Coloque dentro ou na embalagem do presente';

  @override
  String get qrStep3 => 'A pessoa escaneia e descobre a carta';

  @override
  String get qrStep4 => 'A carta abre automaticamente na data certa';

  @override
  String get qrLinkCopied => 'Link copiado! 🔗';

  @override
  String qrShareText(String title, String link) {
    return '💌 Uma carta especial espera por você no OpenWhen!\n\n\"$title\"\n\nEscaneie o QR Code ou acesse: $link';
  }

  @override
  String get qrShareSubject => 'Uma carta especial espera por você 💌';

  @override
  String qrShareLinkOnly(String title, String link) {
    return '💌 Uma carta especial espera por você no OpenWhen!\n\n\"$title\"\n\nAcesse: $link';
  }

  @override
  String qrShareWhatsApp(String title, String link) {
    return '💌 Uma carta especial espera por você!\n\n\"$title\"\n\nAbra aqui: $link';
  }

  @override
  String get createCapsuleTitle => 'Nova Cápsula do Tempo';

  @override
  String createCapsuleStepProgress(int current, String stepName) {
    return 'Passo $current de 3 — $stepName';
  }

  @override
  String get createCapsuleStepTheme => 'Tema';

  @override
  String get createCapsuleStepMessage => 'Mensagem';

  @override
  String get createCapsuleStepWhen => 'Quando abrir';

  @override
  String get createCapsuleSeal => 'Selar Cápsula 🦉';

  @override
  String get createCapsuleThemeQuestion => 'Qual é a essência\ndessa cápsula?';

  @override
  String get createCapsuleThemeHint => 'Escolha um tema para sua cápsula.';

  @override
  String get createCapsuleAudienceTitle => 'Esta cápsula é para quem?';

  @override
  String get createCapsuleAudiencePersonal => 'Só para mim';

  @override
  String get createCapsuleAudienceCollective => 'Coletiva';

  @override
  String get createCapsuleCollectiveHint =>
      'Convide quem vai abrir esta cápsula consigo na mesma data. Só você escreve o conteúdo.';

  @override
  String get createCapsuleInviteSearchHint => 'Busque por nome ou @usuário';

  @override
  String get createCapsuleCollectiveNeedInvite =>
      'Adicione pelo menos uma pessoa para uma cápsula coletiva.';

  @override
  String createCapsuleMaxParticipants(int max) {
    return 'Uma cápsula pode ter no máximo $max pessoas (incluindo você).';
  }

  @override
  String get vaultCapsuleCollectiveBadge => 'Coletiva';

  @override
  String get capsuleDetailParticipantsHeading => 'Junto com';

  @override
  String get createCapsuleThemeMemoriesLabel => 'Memórias';

  @override
  String get createCapsuleThemeMemoriesSubtitle =>
      'Guarde o que não quer esquecer';

  @override
  String get createCapsuleThemeGoalsLabel => 'Metas';

  @override
  String get createCapsuleThemeGoalsSubtitle => 'Uma promessa para o futuro';

  @override
  String get createCapsuleThemeFeelingsLabel => 'Sentimentos';

  @override
  String get createCapsuleThemeFeelingsSubtitle =>
      'O que está dentro de você agora';

  @override
  String get createCapsuleThemeRelationshipsLabel => 'Relacionamentos';

  @override
  String get createCapsuleThemeRelationshipsSubtitle =>
      'As pessoas que importam';

  @override
  String get createCapsuleThemeGrowthLabel => 'Crescimento';

  @override
  String get createCapsuleThemeGrowthSubtitle => 'Quem você está se tornando';

  @override
  String get createCapsuleWriteHeading => 'Escreva para o\nseu eu do futuro';

  @override
  String get createCapsuleWriteHint =>
      'Escreva livremente. Sem regras. Só você e o futuro.';

  @override
  String get createCapsuleFieldTitle => 'Título';

  @override
  String get createCapsuleFieldTitleHint =>
      'Ex: Para o meu eu de daqui a 1 ano...';

  @override
  String get createCapsuleMusicUrlLabel => 'Link da música (opcional)';

  @override
  String get createCapsuleMusicUrlHint => 'https://music.youtube.com/...';

  @override
  String get createCapsuleFieldMessageHint =>
      'Querido eu do futuro...\n\nEscreva o que está sentindo, o que sonha, o que quer lembrar...';

  @override
  String createCapsuleCharCount(int count) {
    return '$count caracteres';
  }

  @override
  String get createCapsuleCharMin => ' (mínimo 10)';

  @override
  String get createCapsuleWhenHeading => 'Quando você\npoderá abrir?';

  @override
  String get createCapsuleWhenHint => 'Escolha uma data ou evento especial.';

  @override
  String get createCapsuleTypeDate => 'Data';

  @override
  String get createCapsuleTypeEvent => 'Evento';

  @override
  String get createCapsuleTypeBoth => 'Ambos';

  @override
  String get createCapsulePickDate => 'Escolher data';

  @override
  String get createCapsuleCustomEventHint => 'Ou descreva o evento...';

  @override
  String get createCapsulePublishToggle => 'Publicar no feed ao abrir';

  @override
  String get createCapsulePublishHint => 'Você decide depois de rever tudo';

  @override
  String get createCapsuleSuccessTitle => 'Cápsula selada!';

  @override
  String get createCapsuleSuccessBody =>
      'Suas palavras estão guardadas.\nSó você poderá abrir na hora certa.';

  @override
  String get createCapsuleSuccessViewVault => 'Ver meu Cofre';

  @override
  String get createCapsulePresetBirthday => 'Meu aniversário';

  @override
  String get createCapsulePresetAnniversary => 'Nosso aniversário';

  @override
  String get createCapsulePresetGraduation => 'Minha formatura';

  @override
  String get createCapsulePresetBaby => 'Nascimento do bebê';

  @override
  String get createCapsulePresetMoving => 'Nossa mudança';

  @override
  String get createCapsulePresetTrip => 'Fim da viagem';

  @override
  String get createCapsulePresetCareer => 'Nova fase profissional';

  @override
  String get createCapsulePresetChristmas => 'Natal';

  @override
  String get createCapsulePresetNewYear => 'Ano Novo';

  @override
  String get capsuleDetailYourCapsule => 'Sua capsula';

  @override
  String capsuleDetailDates(String createdDate, String openedDate) {
    return 'Criada em $createdDate  ·  Aberta em $openedDate';
  }

  @override
  String get capsuleDetailOnFeed => 'No feed';

  @override
  String get capsuleDetailShareSubtitle =>
      'Instagram Stories ou folha de partilha';

  @override
  String get capsuleDetailDeleteTitle => 'Excluir capsula';

  @override
  String get capsuleDetailDeleteSubtitle => 'Remove do cofre permanentemente';

  @override
  String get capsuleDetailDeleteConfirm => 'Excluir capsula?';

  @override
  String get capsuleDetailDeleteBody => 'Esta acao nao pode ser desfeita.';

  @override
  String get capsuleOpeningHeader => 'CAPSULA DO TEMPO';

  @override
  String get capsuleOpeningThemeMemories => 'Memorias guardadas para o futuro';

  @override
  String get capsuleOpeningThemeGoals => 'Suas metas esperam por voce';

  @override
  String get capsuleOpeningThemeFeelings => 'O que voce sentiu, guardado aqui';

  @override
  String get capsuleOpeningThemeRelationships => 'Conexoes que importam';

  @override
  String get capsuleOpeningThemeGrowth => 'Quem voce esta se tornando';

  @override
  String get capsuleOpeningPublishFeed => 'Publicar no feed';

  @override
  String get capsuleOpeningKeepPrivate => 'Guardar so para mim';

  @override
  String get capsuleOpeningTapToOpen => 'TOQUE PARA ABRIR';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profilePrivate => 'Privada';

  @override
  String get profilePublic => 'Pública';

  @override
  String get profileDefaultName => 'Usuário';

  @override
  String get profileStatFollowers => 'Seguidores';

  @override
  String get profileStatFollowing => 'Seguindo';

  @override
  String get profileStatSent => 'Enviadas';

  @override
  String get profileStatOpened => 'Abertas';

  @override
  String get profileBadgesTitle => 'CONQUISTAS';

  @override
  String get badgeFirstLetterSentTitle => 'Primeira carta';

  @override
  String get badgeFirstLetterSentDesc => 'Você enviou sua primeira carta.';

  @override
  String get badgeFirstLetterOpenedTitle => 'Primeira abertura';

  @override
  String get badgeFirstLetterOpenedDesc => 'Você abriu sua primeira carta.';

  @override
  String get badgeFirstPublicTitle => 'Primeira no feed';

  @override
  String get badgeFirstPublicDesc =>
      'Você compartilhou uma carta no feed público.';

  @override
  String get badgeLettersSentFiveTitle => '5 cartas';

  @override
  String get badgeLettersSentFiveDesc => 'Você enviou 5 cartas.';

  @override
  String get badgeLettersSentTenTitle => '10 cartas';

  @override
  String get badgeLettersSentTenDesc => 'Você enviou 10 cartas.';

  @override
  String get badgeVoiceLetterTitle => 'Voz';

  @override
  String get badgeVoiceLetterDesc => 'Você enviou uma carta com áudio.';

  @override
  String get profileStatLetters => 'Cartas';

  @override
  String get profileEmptyTitle => 'Nenhuma carta publicada';

  @override
  String get profileEmptySubtitle =>
      'Suas cartas abertas e publicas\naparecera aqui';

  @override
  String get editProfileTitle => 'Editar perfil';

  @override
  String get editProfileSectionName => 'NOME';

  @override
  String get editProfileSectionUsername => 'USERNAME';

  @override
  String get editProfileSectionBio => 'BIO';

  @override
  String get editProfileHintName => 'Seu nome completo';

  @override
  String get editProfileHintUsername => 'seu_username';

  @override
  String get editProfileHintBio => 'Conte um pouco sobre voce...';

  @override
  String get editProfileUsernameRules => 'Apenas letras, numeros e _';

  @override
  String get editProfileSaveChanges => 'Salvar alteracoes';

  @override
  String get editProfileErrorNameEmpty => 'Nome nao pode ser vazio';

  @override
  String get editProfileErrorUsernameEmpty => 'Username nao pode ser vazio';

  @override
  String get editProfileErrorUsernameShort =>
      'Username deve ter pelo menos 3 caracteres';

  @override
  String get editProfileErrorUsernameTaken => 'Este username ja esta em uso';

  @override
  String get editProfileSaved => 'Perfil atualizado!';

  @override
  String get userProfileFollowing => 'Seguindo';

  @override
  String get userProfileFollow => 'Seguir';

  @override
  String get userProfileEmptyLetters => 'Nenhuma carta pública ainda';

  @override
  String get searchTitle => 'Buscar pessoas';

  @override
  String get searchHint => 'Buscar por nome ou @username...';

  @override
  String get searchEmpty => 'Nenhum resultado';

  @override
  String get searchMinCharsHint => 'Digite pelo menos 2 caracteres para buscar';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get themeSection => 'TEMA DO APP';

  @override
  String get themeSystem => 'Automático (sistema)';

  @override
  String get themeSystemSubtitle => 'Claro ou escuro conforme o aparelho';

  @override
  String get themeClassic => 'Clássico';

  @override
  String get themeClassicSubtitle => 'Fundo claro e destaque vermelho';

  @override
  String get themeDark => 'Escuro';

  @override
  String get themeDarkSubtitle => 'Interface escura confortável';

  @override
  String get themeMidnight => 'Midnight';

  @override
  String get themeMidnightSubtitle => 'Azul profundo';

  @override
  String get themeSepia => 'Sépia';

  @override
  String get themeSepiaSubtitle => 'Tons quentes no papel';

  @override
  String get languageSection => 'IDIOMA';

  @override
  String get languageSystem => 'Automático (sistema)';

  @override
  String get languageSystemSubtitle =>
      'Usa o idioma do aparelho (pt, en ou es)';

  @override
  String get languagePt => 'Português (Brasil)';

  @override
  String get languageEn => 'English';

  @override
  String get languageEs => 'Español';

  @override
  String get activeLabel => 'Ativo';

  @override
  String get settingsMyAccount => 'MINHA CONTA';

  @override
  String get settingsProfilePhoto => 'Foto de perfil';

  @override
  String get settingsProfilePhotoSubtitle => 'Galeria ou remover';

  @override
  String get avatarChooseFromGallery => 'Escolher da galeria';

  @override
  String get avatarRemovePhoto => 'Remover foto';

  @override
  String get avatarPhotoRemovedSnack => 'Foto removida';

  @override
  String get avatarPhotoUpdatedSnack => 'Foto de perfil atualizada';

  @override
  String avatarUploadError(String error) {
    return 'Não foi possível enviar a foto: $error';
  }

  @override
  String settingsNotifPermissionStatus(String status) {
    return 'Status: $status';
  }

  @override
  String get qrFooterBrand => 'openwhen.life';

  @override
  String get qrShareWhatsAppLabel => 'WhatsApp';

  @override
  String get settingsEditProfile => 'Editar perfil';

  @override
  String get settingsChangePassword => 'Alterar senha';

  @override
  String get settingsPrivacySection => 'PRIVACIDADE E SEGURANÇA';

  @override
  String get settingsPrivateAccount => 'Conta privada';

  @override
  String get settingsPrivateAccountOn => 'Suas cartas não aparecem no feed';

  @override
  String get settingsPrivateAccountOff => 'Suas cartas podem aparecer no feed';

  @override
  String get settingsBlockedUsers => 'Usuários bloqueados';

  @override
  String get settingsWhoCanSend => 'Quem pode me enviar cartas';

  @override
  String get settingsWhoCanSendValue => 'Todos';

  @override
  String get settingsNotificationsSection => 'NOTIFICAÇÕES';

  @override
  String get settingsNotifSystemAlert => 'Permissões de alerta (sistema)';

  @override
  String get settingsNotifSystemAlertSubtitle =>
      'Necessário para receber push no celular';

  @override
  String get settingsNotifUpdated => 'Permissões de notificação atualizadas.';

  @override
  String get settingsNotifLikes => 'Curtidas';

  @override
  String get settingsNotifLikesSubtitle => 'Quando alguém curtir sua carta';

  @override
  String get settingsNotifComments => 'Comentários';

  @override
  String get settingsNotifCommentsSubtitle =>
      'Quando alguém comentar sua carta';

  @override
  String get settingsNotifFollowers => 'Novos seguidores';

  @override
  String get settingsNotifFollowersSubtitle =>
      'Quando alguém começar a te seguir';

  @override
  String get settingsNotifLetterUnlocked => 'Carta desbloqueada';

  @override
  String get settingsNotifLetterUnlockedSubtitle =>
      'Quando uma carta estiver pronta para abrir';

  @override
  String get settingsDataSection => 'DADOS E PRIVACIDADE';

  @override
  String get settingsExportLetters => 'Exportar minhas cartas';

  @override
  String get settingsExportLettersSubtitle =>
      'PDF ou zip com todas as cartas abertas';

  @override
  String get settingsDeleteAccount => 'Deletar conta';

  @override
  String get settingsDeleteAccountSubtitle => 'Esta ação é irreversível';

  @override
  String get settingsLegalSection => 'LEGAL E SUPORTE';

  @override
  String get settingsTerms => 'Termos de uso';

  @override
  String get settingsPrivacy => 'Política de privacidade';

  @override
  String get settingsHelp => 'Ajuda e suporte';

  @override
  String get settingsAbout => 'Sobre o OpenWhen';

  @override
  String get settingsAboutVersion => 'Versão 1.0.0';

  @override
  String get settingsLogout => 'Sair da conta';

  @override
  String get settingsEditProfileSheetTitle => 'Editar perfil';

  @override
  String get settingsEditProfileFieldName => 'Nome';

  @override
  String get settingsEditProfileFieldUsername => '@Username';

  @override
  String get settingsEditProfileFieldBio => 'Bio';

  @override
  String get settingsChangePasswordTitle => 'Alterar senha';

  @override
  String get settingsChangePasswordBody => 'Enviaremos um link para seu email.';

  @override
  String get settingsChangePasswordButton => 'Enviar email de redefinição';

  @override
  String settingsChangePasswordSent(String email) {
    return 'Email enviado para $email';
  }

  @override
  String get settingsExportTitle => 'Exportar cartas';

  @override
  String get settingsExportBody =>
      'Suas cartas abertas serão exportadas em formato PDF. Isso pode levar alguns minutos.';

  @override
  String get settingsExportButton => 'Exportar como ZIP';

  @override
  String get settingsExportZipSubtitle =>
      'Um PDF por carta, mais áudio e imagem manuscrita quando houver.';

  @override
  String settingsExportSuccess(int count) {
    return '$count cartas exportadas.';
  }

  @override
  String get settingsExportSnack => 'Preparando exportação…';

  @override
  String get letterDetailExportPdfTitle => 'Exportar PDF';

  @override
  String get letterDetailExportPdfSubtitle =>
      'Baixe uma cópia portátil desta carta';

  @override
  String get settingsDeleteTitle => 'Deletar conta';

  @override
  String get settingsDeleteBody =>
      'Esta ação é irreversível. Todas as suas cartas, seguidores e dados serão deletados permanentemente.';

  @override
  String get settingsDeletePendingLettersWarning =>
      'Importante: Você pode ter cartas bloqueadas aguardando entrega a destinatários ou cartas aguardando para serem recebidas. Se escolher \"Excluir Tudo\", cartas pendentes que você enviou não serão entregues e cartas que você ainda não abriu serão perdidas. Se escolher \"Anonimizar\", suas cartas enviadas continuarão sendo entregues, mas seu nome será substituído por \"Usuário removido\".';

  @override
  String get settingsDeleteConfirm => 'Confirmar exclusão';

  @override
  String get settingsBlockedTitle => 'Usuários bloqueados';

  @override
  String get settingsBlockedEmpty => 'Nenhum usuário bloqueado.';

  @override
  String get settingsBlockedUnblock => 'Desbloquear';

  @override
  String get legalTitleTerms => 'Termos de Uso';

  @override
  String get legalTitlePrivacy => 'Política de Privacidade';

  @override
  String get legalTitleAbout => 'Sobre o OpenWhen';

  @override
  String get legalTitleHelp => 'Ajuda e Suporte';

  @override
  String legalLastUpdate(String date) {
    return 'Última atualização: $date';
  }

  @override
  String get aboutTagline => 'Escreva hoje. Sinta amanhã.';

  @override
  String get aboutVersion => 'Versão 1.0.0 — Build 2026.03.22';

  @override
  String get aboutWhatIsTitle => 'O que é o OpenWhen';

  @override
  String get aboutWhatIsBody =>
      'O OpenWhen é uma plataforma digital de comunicação temporal e rede social emocional. Permite criar cartas digitais com data futura de abertura, combinando o valor sentimental de uma carta física com a viralidade de uma rede social moderna.';

  @override
  String get aboutSecurityTitle => 'Segurança e Privacidade';

  @override
  String get aboutSecurityBody =>
      'Desenvolvido em conformidade com a LGPD (Lei nº 13.709/2018) e o Marco Civil da Internet (Lei nº 12.965/2014). Seus dados são protegidos com criptografia de ponta e armazenados na infraestrutura Google Cloud Platform.';

  @override
  String get aboutComplianceTitle => 'Conformidade Legal';

  @override
  String get aboutComplianceBody =>
      'O OpenWhen opera em total conformidade com a legislação brasileira vigente, incluindo LGPD, Marco Civil da Internet, Código de Defesa do Consumidor (Lei nº 8.078/1990) e demais normas aplicáveis ao setor de tecnologia.';

  @override
  String get aboutCompanyTitle => 'Empresa';

  @override
  String get aboutCompanyBody =>
      'OpenWhen Tecnologia Ltda. — Empresa brasileira, com sede no Brasil. Foro de eleição: comarca de São Paulo/SP.';

  @override
  String get aboutContacts => 'Contatos';

  @override
  String get aboutContactSupport => 'Suporte geral';

  @override
  String get aboutContactPrivacy => 'Privacidade e LGPD';

  @override
  String get aboutContactLegal => 'Jurídico';

  @override
  String get aboutContactDpo => 'DPO';

  @override
  String get aboutCopyright =>
      '© 2026 OpenWhen Tecnologia Ltda. Todos os direitos reservados.';

  @override
  String get helpCenter => 'Central de Ajuda';

  @override
  String get helpCenterSubtitle =>
      'Encontre respostas para as dúvidas mais frequentes.';

  @override
  String get helpFaqSection => 'PERGUNTAS FREQUENTES';

  @override
  String get helpFaq1Q => 'Como enviar uma carta?';

  @override
  String get helpFaq1A =>
      'Toque no botão ✏️ na tela principal. Preencha o título, selecione o estado emocional, escreva sua mensagem, informe o e-mail do destinatário e defina a data de abertura. A carta ficará bloqueada até a data escolhida.';

  @override
  String get helpFaq2Q => 'O destinatário precisa ter conta no OpenWhen?';

  @override
  String get helpFaq2A =>
      'Sim. Atualmente o destinatário precisa ter uma conta cadastrada no OpenWhen para receber cartas. O envio para e-mails externos estará disponível em breve.';

  @override
  String get helpFaq3Q => 'Posso editar uma carta após o envio?';

  @override
  String get helpFaq3A =>
      'Não. As cartas ficam seladas imediatamente após o envio para preservar a autenticidade e integridade da mensagem, em analogia às cartas físicas. Esta é uma decisão de produto intencional.';

  @override
  String get helpFaq4Q => 'Como funciona o Feed Público?';

  @override
  String get helpFaq4A =>
      'Ao abrir uma carta, você pode optar por publicá-la no Feed Público. Essa autorização é individual por carta. Cartas privadas jamais são exibidas publicamente sem sua autorização expressa.';

  @override
  String get helpFaq5Q => 'Recebi uma carta de um desconhecido. O que fazer?';

  @override
  String get helpFaq5A =>
      'Cartas de pessoas que você não segue ficam em \"Pedidos de Carta\" no Cofre. Você pode aceitar, recusar ou bloquear o remetente sem que ele saiba da sua decisão.';

  @override
  String get helpFaq6Q => 'Como exportar minhas cartas?';

  @override
  String get helpFaq6A =>
      'Acesse Configurações > Dados e Privacidade > Exportar minhas cartas. Você receberá um arquivo com todas as suas cartas abertas, conforme direito de portabilidade garantido pelo art. 18, inciso V, da LGPD.';

  @override
  String get helpFaq7Q => 'Como deletar minha conta?';

  @override
  String get helpFaq7A =>
      'Acesse Configurações > Dados e Privacidade > Deletar conta. A exclusão é irreversível e todos os seus dados serão permanentemente removidos em até 30 dias, conforme art. 18, inciso VI, da LGPD.';

  @override
  String get helpFaq8Q => 'Encontrei um conteúdo ofensivo. Como denunciar?';

  @override
  String get helpFaq8A =>
      'Toque nos três pontos ao lado de qualquer carta ou comentário e selecione \"Denunciar\". Nossa equipe analisará o conteúdo em até 24 horas. Denúncias graves são tratadas com prioridade.';

  @override
  String get reportMenuLabel => 'Denunciar';

  @override
  String get reportSheetTitle => 'Denunciar conteúdo';

  @override
  String get reportSheetSubtitle =>
      'Diga o que está errado. Detalhes opcionais ajudam nossa equipe a analisar mais rápido.';

  @override
  String get reportReasonSpam => 'Spam ou enganoso';

  @override
  String get reportReasonHarassment => 'Assédio ou bullying';

  @override
  String get reportReasonHate => 'Discurso de ódio';

  @override
  String get reportReasonIllegal => 'Conteúdo ilegal';

  @override
  String get reportReasonOther => 'Outro';

  @override
  String get reportDetailLabel => 'Detalhes adicionais (opcional)';

  @override
  String get reportDetailHint => 'Contexto que ajuda a moderação…';

  @override
  String get reportSubmit => 'Enviar denúncia';

  @override
  String get reportSuccess => 'Obrigado — recebemos sua denúncia.';

  @override
  String get adminModerationTitle => 'Moderação';

  @override
  String get adminModerationReportsTab => 'Denúncias';

  @override
  String get adminModerationFeedbackTab => 'Feedback';

  @override
  String get adminModerationIncidentsTab => 'Alertas IA';

  @override
  String get adminModerationAiBannerTitle => 'Moderação por IA (servidor)';

  @override
  String get adminModerationProviderOpenai => 'OpenAI Moderation API';

  @override
  String get adminModerationCredentialsOk => 'Credenciais configuradas';

  @override
  String get adminModerationCredentialsMissing =>
      'Credenciais em falta (env das Functions)';

  @override
  String get adminModerationEmpty => 'Nada pendente.';

  @override
  String get adminModerationResolve => 'Arquivar';

  @override
  String get adminModerationConfirm => 'Marcar como analisado';

  @override
  String get adminModerationLoadError =>
      'Não foi possível carregar a fila de moderação.';

  @override
  String get adminEntrySettings => 'Moderação (admin)';

  @override
  String get adminModerationReviewsTab => 'Revisão humana';

  @override
  String get moderationNotificationsSection => 'Moderação';

  @override
  String get moderationNotificationsEntry => 'Notificações de moderação';

  @override
  String get moderationNotificationsTitle => 'Notificações de moderação';

  @override
  String get moderationNotificationsEmpty => 'Nenhuma notificação.';

  @override
  String get commentsModerationPendingReview =>
      'O comentário foi enviado para revisão. Será notificado quando for aprovado ou rejeitado.';

  @override
  String get commentsModerationQueueFailed =>
      'Não foi possível enviar para revisão. Tente novamente.';

  @override
  String get adminModerationApprove => 'Aprovar e publicar';

  @override
  String get adminModerationReject => 'Rejeitar';

  @override
  String get adminModerationFeedbackLabel =>
      'Mensagem ao utilizador (obrigatório ao rejeitar)';

  @override
  String get adminModerationFeedbackHint => 'Explique o que deve mudar…';

  @override
  String get adminModerationReviewsLoadError =>
      'Não foi possível carregar a fila de revisão.';

  @override
  String get helpNotFoundTitle => 'Não encontrou o que procurava?';

  @override
  String get helpNotFoundBody => 'Nossa equipe está disponível para ajudar:';

  @override
  String get helpResponseTime => 'Tempo de resposta';

  @override
  String get helpResponseTimeValue => 'até 2 dias úteis';

  @override
  String get feedbackTooltip => 'Enviar feedback';

  @override
  String get feedbackSemanticsLabel => 'Enviar feedback ou pedido de recurso';

  @override
  String get feedbackSheetTitle => 'Feedback';

  @override
  String get feedbackCategoryLabel => 'Categoria';

  @override
  String get feedbackTypeFeature => 'Recurso';

  @override
  String get feedbackTypeRecommendation => 'Ideia';

  @override
  String get feedbackTypeGeneral => 'Geral';

  @override
  String get feedbackMessageHint => 'O que você gostaria de compartilhar?';

  @override
  String feedbackCharCount(int current, int max) {
    return '$current / $max';
  }

  @override
  String get feedbackSubmit => 'Enviar';

  @override
  String get feedbackEmptyError => 'Digite uma mensagem.';

  @override
  String get feedbackTooLongError => 'Mensagem muito longa.';

  @override
  String get feedbackSuccess => 'Obrigado — recebemos seu feedback.';

  @override
  String get feedbackSignedOutHint =>
      'Você não está conectado. Vamos abrir o app de e-mail para você enviar para a nossa equipe.';

  @override
  String get feedbackCouldNotOpenEmail =>
      'Não foi possível abrir o e-mail. Contate suporte@openwhen.life.';

  @override
  String feedbackEmailBodyPrefix(String category) {
    return 'Categoria: $category';
  }

  @override
  String get keyboardDismissTooltip => 'Ocultar teclado';

  @override
  String get keyboardDismissSemanticsLabel => 'Fechar teclado';

  @override
  String get subscriptionSectionTitle => 'Plano e assinatura';

  @override
  String get subscriptionScreenTitle => 'Planos';

  @override
  String get subscriptionPlanAmanhaName => 'Amanhã';

  @override
  String get subscriptionPlanBrisaName => 'Brisa';

  @override
  String get subscriptionPlanHorizonteName => 'Horizonte';

  @override
  String get subscriptionPlanAmanhaPitch =>
      'O essencial para escrever hoje e sentir no tempo certo.';

  @override
  String get subscriptionPlanBrisaPitch =>
      'Partilha e expressão: mais profundidade no cofre e nas redes.';

  @override
  String get subscriptionPlanHorizontePitch =>
      'Arquivo, família e inteligência com transparência.';

  @override
  String get subscriptionCurrentPlanLabel => 'Seu plano atual';

  @override
  String get subscriptionSubscribeBrisa => 'Assinar Brisa';

  @override
  String get subscriptionSubscribeHorizonte => 'Assinar Horizonte';

  @override
  String get subscriptionManageBilling => 'Gerenciar assinatura e pagamento';

  @override
  String get subscriptionCheckoutError =>
      'Não foi possível abrir o pagamento. Tente novamente.';

  @override
  String get subscriptionPortalError =>
      'Não foi possível abrir o portal de cobrança.';

  @override
  String get subscriptionUpgradeDialogTitle => 'Plano necessário';

  @override
  String subscriptionUpgradeDialogBody(String planName) {
    return 'Esta função exige o plano $planName ou superior.';
  }

  @override
  String get subscriptionUpgradeDialogViewPlans => 'Ver planos';

  @override
  String get subscriptionBillingDisabledBanner =>
      'O checkout de assinatura ainda não está ativado. Você pode continuar usando o app no plano Amanhã. Ative o billing no projeto quando o Stripe estiver pronto.';

  @override
  String get subscriptionBillingDisabledSnack =>
      'Pagamentos ainda não estão ativos. Use BILLING_ENABLED=true quando o Stripe estiver configurado.';

  @override
  String get termsIntro =>
      'Estes Termos de Uso (\"Termos\") regulam o acesso e a utilização do aplicativo OpenWhen (\"Plataforma\"), desenvolvido e operado pela OpenWhen Tecnologia Ltda. (\"Empresa\"), inscrita no CNPJ sob o nº [XX.XXX.XXX/0001-XX], com sede no Brasil. A utilização da Plataforma implica a aceitação integral e irrestrita destes Termos, nos termos do art. 8º da Lei nº 12.965/2014 (Marco Civil da Internet) e da Lei nº 13.709/2018 (Lei Geral de Proteção de Dados — LGPD).';

  @override
  String get termsSection1Title => '1. DO OBJETO E NATUREZA DO SERVIÇO';

  @override
  String get termsSection1Body =>
      'O OpenWhen é uma plataforma digital de comunicação temporal que permite aos usuários criar, enviar, receber e armazenar mensagens eletrônicas (\"Cartas\") programadas para abertura em data futura determinada pelo remetente. O serviço possui natureza de intermediação digital de comunicação privada e, quando autorizado pelo usuário, de publicação em ambiente de rede social (\"Feed Público\"). A Empresa atua como provedora de aplicação, nos termos do art. 5º, inciso VII, do Marco Civil da Internet.';

  @override
  String get termsSection2Title => '2. DOS REQUISITOS PARA UTILIZAÇÃO';

  @override
  String get termsSection2Body =>
      'Para utilizar a Plataforma, o usuário deverá: (i) ter capacidade civil plena, nos termos do art. 3º do Código Civil Brasileiro (Lei nº 10.406/2002), ou ser assistido por responsável legal quando menor de 16 anos; (ii) fornecer dados verídicos no cadastro, sob pena de cancelamento imediato da conta, nos termos do art. 7º, inciso VI, do Marco Civil da Internet; (iii) manter a confidencialidade de suas credenciais de acesso, sendo responsável por todas as atividades realizadas em sua conta.';

  @override
  String get termsSection3Title =>
      '3. DAS OBRIGAÇÕES E RESPONSABILIDADES DO USUÁRIO';

  @override
  String get termsSection3Body =>
      'O usuário se compromete a utilizar a Plataforma em conformidade com a legislação vigente, especialmente: (i) a Lei nº 12.965/2014 (Marco Civil da Internet); (ii) a Lei nº 13.709/2018 (LGPD); (iii) o Código Penal Brasileiro no que tange a crimes contra a honra (arts. 138 a 140); (iv) a Lei nº 7.716/1989 (Lei de Crimes de Preconceito); e (v) o Estatuto da Criança e do Adolescente (ECA — Lei nº 8.069/1990). É expressamente vedado ao usuário publicar conteúdo que: (a) seja difamatório, calunioso ou injurioso; (b) incite violência, ódio ou discriminação de qualquer natureza; (c) viole direitos de propriedade intelectual de terceiros; (d) constitua assédio, cyberbullying ou perseguição; (e) envolva pornografia infantil ou conteúdo sexual envolvendo menores de idade.';

  @override
  String get termsSection4Title => '4. DA RESPONSABILIDADE CIVIL DA EMPRESA';

  @override
  String get termsSection4Body =>
      'A Empresa, na qualidade de provedora de aplicação, não se responsabiliza pelo conteúdo gerado pelos usuários (\"UGC — User Generated Content\"), nos termos do art. 19 do Marco Civil da Internet. A responsabilidade civil da Empresa somente será configurada mediante descumprimento de ordem judicial específica determinando a remoção de conteúdo. A Empresa adota mecanismos de moderação e denúncia, sem que isso implique assunção de responsabilidade editorial sobre o conteúdo dos usuários.';

  @override
  String get termsSection5Title => '5. DA PROPRIEDADE INTELECTUAL';

  @override
  String get termsSection5Body =>
      'O usuário é e permanece titular dos direitos autorais sobre o conteúdo que cria na Plataforma, nos termos da Lei nº 9.610/1998 (Lei de Direitos Autorais). Ao publicar conteúdo no Feed Público, o usuário concede à Empresa licença não exclusiva, irrevogável, gratuita e mundial para reproduzir, distribuir e exibir tal conteúdo exclusivamente no âmbito da Plataforma, podendo revogar tal licença mediante a exclusão do conteúdo ou encerramento da conta. A marca, logotipo, design e código-fonte do OpenWhen são de titularidade exclusiva da Empresa e protegidos pela Lei nº 9.279/1996 (Lei da Propriedade Industrial).';

  @override
  String get termsSection6Title => '6. DA VIGÊNCIA E RESCISÃO';

  @override
  String get termsSection6Body =>
      'O presente contrato vigorará por prazo indeterminado a partir do cadastro do usuário. O usuário poderá rescindir o contrato a qualquer momento mediante exclusão de sua conta nas configurações da Plataforma, nos termos do art. 7º, inciso IX, do Marco Civil da Internet. A Empresa reserva-se o direito de suspender ou encerrar contas que violem estes Termos, sem prejuízo das demais medidas legais cabíveis.';

  @override
  String get termsSection7Title =>
      '7. DA DESCONTINUAÇÃO DO SERVIÇO E GARANTIA DE ENTREGA DAS CARTAS';

  @override
  String get termsSection7Body =>
      'O OpenWhen empreende todos os esforços para garantir a entrega de todas as cartas e cápsulas nas datas escolhidas pelo remetente. Em caso de descontinuação planejada dos serviços, a Empresa se compromete a: (i) notificar todos os usuários cadastrados por e-mail e notificação no app com no mínimo 90 (noventa) dias de antecedência do encerramento definitivo; (ii) durante o período de aviso, disponibilizar a exportação de todos os dados do usuário (cartas, cápsulas, perfil, mídia) pelo app ou por e-mail; (iii) entregar todas as cartas bloqueadas cuja data de abertura caia dentro do período de aviso; (iv) após o período de 90 dias, excluir permanente e irreversivelmente todos os dados dos usuários dos seus servidores. A Empresa poderá estabelecer um Fundo de Continuidade — uma reserva financeira suficiente para manter a infraestrutura essencial (Firebase, armazenamento, funções de entrega) por pelo menos 2 (dois) anos mesmo que o app deixe de gerar receita. Quando estabelecido, a existência e o status deste fundo serão documentados nestes Termos. Este compromisso constitui uma garantia de produto, não uma obrigação legal, e poderá ser ajustado conforme a capacidade financeira da Empresa evolua.';

  @override
  String get termsSection8Title => '8. DAS DISPOSIÇÕES GERAIS';

  @override
  String get termsSection8Body =>
      'Estes Termos são regidos pelas leis da República Federativa do Brasil. Fica eleito o foro da comarca de São Paulo/SP para dirimir quaisquer controvérsias decorrentes deste instrumento, com renúncia expressa a qualquer outro foro, por mais privilegiado que seja. A nulidade de qualquer cláusula não afeta a validade das demais. Dúvidas e notificações devem ser encaminhadas para: juridico@openwhen.life. Última atualização: 10 de abril de 2026.';

  @override
  String get privacyIntro =>
      'Esta Política de Privacidade (\"Política\") descreve como a OpenWhen Tecnologia Ltda. (\"Empresa\", \"nós\", \"nos\", \"nosso\") coleta, trata, armazena e compartilha os dados pessoais dos usuários da plataforma e do aplicativo móvel OpenWhen (\"Plataforma\"). Esta Política tem alcance global e está em conformidade com: (a) a Lei Geral de Proteção de Dados — LGPD (Lei nº 13.709/2018); (b) o Regulamento Geral de Proteção de Dados da União Europeia — GDPR (Regulamento EU 2016/679); (c) a Lei de Privacidade do Consumidor da Califórnia e a Lei de Direitos de Privacidade da Califórnia — CCPA/CPRA (California Civil Code §§ 1798.100–1798.199.100); (d) o Marco Civil da Internet (Lei nº 12.965/2014); e (e) a Lei de Proteção da Privacidade Online das Crianças dos EUA — COPPA (16 CFR Part 312). A Empresa atua como Controladora de Dados (LGPD art. 5º VI / GDPR art. 4(7)) e como \"Business\" nos termos da CCPA. Data de vigência: 10 de abril de 2026.';

  @override
  String get privacySection1Title => '1. DEFINIÇÕES';

  @override
  String get privacySection1Body =>
      'Para os fins desta Política: \"Dados Pessoais\" significa qualquer informação relacionada a pessoa natural identificada ou identificável (LGPD art. 5º I / GDPR art. 4(1)); \"Informação Pessoal\" (PI) tem o significado definido na CCPA § 1798.140(v); \"Tratamento\" significa qualquer operação realizada com dados pessoais (LGPD art. 5º X / GDPR art. 4(2)); \"Titular dos Dados\" ou \"Consumidor\" significa qualquer pessoa natural cujos dados pessoais são tratados; \"Controlador\" significa a entidade que determina as finalidades e os meios do tratamento; \"Operador\" ou \"Processador\" significa a entidade que trata dados em nome do Controlador; \"Dados Pessoais Sensíveis\" significa dados relativos à origem racial ou étnica, convicção religiosa, opinião política, saúde, vida sexual ou dados biométricos/genéticos (LGPD art. 5º II / GDPR art. 9).';

  @override
  String get privacySection2Title => '2. DADOS QUE COLETAMOS';

  @override
  String get privacySection2Body =>
      'Coletamos as seguintes categorias de dados pessoais:\n\n(a) Dados de Cadastro: nome completo, nome de exibição, endereço de e-mail, nome de usuário, foto de perfil (opcional) e texto biográfico (opcional).\n\n(b) Conteúdo Gerado pelo Usuário: cartas (texto, título, estado emocional), imagens de cartas manuscritas (capturadas pela câmera), mensagens de voz (até 1 minuto, capturadas pelo microfone), cápsulas do tempo (texto, tema, fotos), comentários em cartas públicas e links opcionais de música.\n\n(c) Dados de Localização Precisa (opt-in): quando você opta por anexar uma localização a uma carta ou cápsula, coletamos suas coordenadas GPS precisas (latitude e longitude) e o momento da captura. Você também pode ativar um requisito de proximidade (aproximadamente 10 metros) para o destinatário abrir a carta. A coleta de localização é sempre opcional e solicitada por carta ou cápsula — nunca coletamos localização em segundo plano.\n\n(d) Dados Técnicos e de Dispositivo: endereço IP, identificador do dispositivo, sistema operacional, versão do app, token de notificação push (Firebase Cloud Messaging), plataforma do dispositivo (Android/iOS/web), idioma preferido e logs de acesso nos termos do art. 15 do Marco Civil da Internet.\n\n(e) Dados de Analytics: eventos de uso (cartas criadas, abertas, compartilhadas; cápsulas criadas, abertas; visualizações do feed; curtidas, comentários, follows; visualizações de perfil; alterações de tema e idioma), visualizações de tela e relatórios de falhas/erros, coletados via Firebase Analytics e Firebase Crashlytics.\n\n(f) Dados Sociais: relações de seguidores/seguindo, bloqueios entre usuários, curtidas em cartas públicas e comentários.\n\n(g) Dados de Cobrança: quando os recursos de assinatura estão habilitados, armazenamos seu identificador de cliente Stripe, identificador de assinatura, nível de assinatura (free/plus/pro) e status da assinatura. Dados de cartão de pagamento são processados e armazenados exclusivamente pelo Stripe e nunca passam pelos nossos servidores.\n\n(h) Dados de Moderação: denúncias de conteúdo enviadas por usuários (motivo, detalhe, conteúdo alvo), resultados de análise de moderação por IA (categorias sinalizadas e pontuações), registros de revisão humana de moderação e logs de incidentes de moderação.\n\n(i) Dados de Comunicação: mensagens de feedback do produto (incluindo metadados de plataforma e idioma do app) e solicitações de suporte.\n\n(j) Dados de Gamificação: registros de desbloqueio de badges e histórico de notificações no app.\n\nPara fins da CCPA, as categorias de PI coletadas nos últimos 12 meses incluem: identificadores (nome, e-mail, nome de usuário, ID do dispositivo); atividade de rede de internet/eletrônica (eventos de uso, logs de acesso); dados de geolocalização (GPS preciso quando opt-in); informações de áudio/visuais (mensagens de voz, fotos); e informações profissionais ou pessoais inferidas do conteúdo que você cria.';

  @override
  String get privacySection3Title => '3. COMO COLETAMOS DADOS';

  @override
  String get privacySection3Body =>
      '(a) Diretamente de você: quando você cria uma conta, escreve cartas ou cápsulas, envia fotos ou mensagens de voz, concede permissão de localização, envia feedback, publica comentários ou interage com outros usuários.\n\n(b) Automaticamente: dados técnicos e de dispositivo, eventos de analytics, relatórios de falhas e tokens de notificação push são coletados automaticamente quando você usa a Plataforma, por meio dos SDKs do Firebase integrados ao app.\n\n(c) De terceiros: atualizações de status de pagamento do Stripe (via webhooks) quando os recursos de assinatura estão ativos; atestação de dispositivo do Firebase App Check (Play Integrity no Android, DeviceCheck no iOS) para proteção contra abusos.';

  @override
  String get privacySection4Title => '4. BASES LEGAIS PARA O TRATAMENTO';

  @override
  String get privacySection4Body =>
      'Nos termos da LGPD (art. 7º) e do GDPR (art. 6), tratamos seus dados com base em:\n\n(a) Consentimento (LGPD art. 7º I / GDPR art. 6(1)(a)): manifestado no cadastro quando você aceita esta Política; para recursos opcionais como dados de localização e mensagens de voz, o consentimento é obtido no momento do uso.\n\n(b) Execução de Contrato (LGPD art. 7º V / GDPR art. 6(1)(b)): tratamento necessário para a prestação dos serviços da Plataforma — entrega de cartas, gerenciamento de cápsulas, recursos sociais e manutenção da sua conta.\n\n(c) Legítimo Interesse (LGPD art. 7º IX / GDPR art. 6(1)(f)): melhoria da Plataforma, prevenção a fraudes, moderação de conteúdo, segurança do serviço e analytics. Realizamos teste de proporcionalidade para garantir que nossos interesses não se sobreponham aos seus direitos fundamentais.\n\n(d) Obrigação Legal (LGPD art. 7º II / GDPR art. 6(1)(c)): retenção de logs de acesso por 6 meses (Marco Civil da Internet art. 15), cumprimento de ordens judiciais e requisitos regulatórios.\n\nNos termos da CCPA, a coleta e uso de PI está detalhada nas Seções 2, 6 e 8 desta Política. Não utilizamos nem divulgamos informações pessoais sensíveis para finalidades além das permitidas pela CCPA § 1798.121.';

  @override
  String get privacySection5Title => '5. FINALIDADES DO TRATAMENTO';

  @override
  String get privacySection5Body =>
      'Tratamos seus dados pessoais para as seguintes finalidades: (i) prestação e operação dos serviços da Plataforma (entrega de cartas, gerenciamento de cápsulas, feed social); (ii) personalização da experiência (temas, idioma, estados emocionais); (iii) envio de notificações relacionadas ao serviço (alertas de entrega de cartas, lembretes de abertura de cápsulas) via notificações push e, quando aplicável, e-mail; (iv) moderação de conteúdo para garantir um ambiente seguro e respeitoso; (v) analytics e melhoria contínua da Plataforma; (vi) prevenção a fraudes e garantia de segurança; (vii) processamento de pagamentos e gerenciamento de assinaturas (quando habilitados); (viii) cumprimento de obrigações legais e regulatórias; (ix) exercício regular de direitos em processos judiciais, administrativos ou arbitrais. Não utilizamos seus dados para publicidade de terceiros, perfilamento comportamental para segmentação de anúncios ou venda a corretores de dados.';

  @override
  String get privacySection6Title => '6. DECISÕES AUTOMATIZADAS E PERFILAMENTO';

  @override
  String get privacySection6Body =>
      'A Plataforma utiliza moderação automatizada de conteúdo alimentada por inteligência artificial (API de Moderação da OpenAI) para analisar conteúdo textual (como comentários) em busca de material potencialmente prejudicial. Este sistema pode: (a) permitir a publicação do conteúdo sem intervenção (pontuação de risco baixa); (b) apresentar um aviso gentil ao autor permitindo a publicação (pontuação de risco média); ou (c) bloquear a publicação do conteúdo (pontuação de risco alta). Quando a moderação humana está ativada, conteúdo sinalizado é encaminhado para revisão manual pela nossa equipe antes de uma decisão final. Nenhuma decisão automatizada é baseada em categorias de dados pessoais sensíveis. Nos termos do GDPR art. 22, você tem o direito de não ser submetido a decisões baseadas unicamente em tratamento automatizado que produzam efeitos jurídicos ou igualmente significativos. Você pode contestar qualquer decisão automatizada de moderação contatando privacidade@openwhen.life ou através do recurso de denúncia/feedback no app. Nos termos da LGPD art. 20, você pode solicitar a revisão de decisões automatizadas que afetem seus interesses.';

  @override
  String get privacySection7Title =>
      '7. COMPARTILHAMENTO DE DADOS E OPERADORES TERCEIROS';

  @override
  String get privacySection7Body =>
      'Não vendemos, alugamos ou comercializamos seus dados pessoais. Para fins da CCPA: não vendemos nem compartilhamos (conforme definido na CCPA § 1798.140(ad) e (ah)) informações pessoais de consumidores nos últimos 12 meses, e não temos conhecimento efetivo de venda ou compartilhamento de PI de consumidores menores de 16 anos. Os dados são compartilhados com as seguintes categorias de prestadores de serviço/operadores, cada um vinculado por acordos de processamento de dados:\n\n(a) Google LLC / Firebase: infraestrutura em nuvem (banco de dados Firestore, Cloud Storage para arquivos, Cloud Functions para lógica do servidor), serviços de autenticação, notificações push (FCM), analytics (Firebase Analytics), relatórios de falhas (Crashlytics) e atestação de dispositivo (App Check). O Google trata dados como Operador sob nossas instruções. Compromissos de privacidade do Google: https://firebase.google.com/support/privacy.\n\n(b) OpenAI, Inc.: conteúdo textual é enviado à API de Moderação da OpenAI exclusivamente para análise de segurança de conteúdo. Apenas o texto do conteúdo sendo moderado é transmitido — nenhum identificador de usuário, imagem ou dado de voz é enviado. A política de uso de dados da OpenAI para clientes da API estabelece que inputs da API não são usados para treinar modelos.\n\n(c) Twilio Inc. (SendGrid): endereços de e-mail de destinatários externos são processados para enviar e-mails de convite quando uma carta é endereçada a alguém que ainda não possui conta. Apenas o e-mail do destinatário, um nome de exibição do remetente e um título da carta são incluídos.\n\n(d) Stripe, Inc.: quando os recursos de assinatura/pagamento estão ativos, o Stripe processa dados de cartão de pagamento, identificadores de cliente e status de assinatura. Os dados do cartão são coletados diretamente pelo Stripe e nunca passam pelos nossos servidores.\n\n(e) Google Fonts: o app pode carregar fontes tipográficas dos servidores do Google, o que envolve o envio do seu endereço IP para o Google.\n\n(f) Autoridades públicas: podemos compartilhar dados com autoridades governamentais quando exigido por ordem judicial ou requisição legal fundamentada.\n\n(g) Transações corporativas: em caso de fusão, aquisição ou reestruturação, seus dados poderão ser transferidos à entidade sucessora, que ficará vinculada a esta Política.';

  @override
  String get privacySection8Title =>
      '8. TRANSFERÊNCIAS INTERNACIONAIS DE DADOS';

  @override
  String get privacySection8Body =>
      'Seus dados pessoais são armazenados em servidores operados pelo Google Cloud Platform, que podem estar localizados nos Estados Unidos ou em outros países fora do seu país de residência. Estas transferências são realizadas em conformidade com: (a) LGPD art. 33, mediante cláusulas contratuais padrão aprovadas pela Autoridade Nacional de Proteção de Dados (ANPD); (b) GDPR Capítulo V, com base em Cláusulas Contratuais Padrão (SCCs) adotadas pela Comissão Europeia (Decisão 2021/914) e, quando aplicável, medidas suplementares conforme a decisão Schrems II; (c) para operadores baseados nos EUA, compromissos contratuais que garantem proteção de dados equivalente à prevista na legislação aplicável. Para a OpenAI e o Stripe, os dados processados nos Estados Unidos estão sujeitos aos respectivos acordos de processamento de dados que incorporam SCCs.';

  @override
  String get privacySection9Title => '9. RETENÇÃO DE DADOS';

  @override
  String get privacySection9Body =>
      'Retemos seus dados pelo período mínimo necessário para as finalidades descritas nesta Política. Períodos específicos de retenção:\n\n• Dados de conta/perfil: retidos até a exclusão da conta.\n• Cartas e cápsulas: retidas até a exclusão pelo titular ou exclusão/anonimização da conta.\n• Comentários, curtidas, follows: retidos até exclusão pelo titular ou exclusão da conta.\n• Tokens de notificação push (FCM): sobrescritos a cada login; excluídos na exclusão da conta.\n• Dados de localização precisa: armazenados apenas quando opt-in; excluídos ou anonimizados na exclusão da conta.\n• Dados de cobrança (IDs Stripe): assinatura cancelada e IDs excluídos na exclusão da conta. O Stripe pode reter dados conforme sua própria política de retenção.\n• Denúncias de conteúdo: anonimizadas 90 dias após resolução.\n• Feedback do produto: anonimizado após 1 ano.\n• Logs de moderação: retidos por 2 anos (sem PII direta).\n• Dados de analytics (Firebase): retidos conforme política padrão do Firebase (14 meses para dados em nível de usuário).\n• Logs de auditoria de exclusão: retidos por 3 anos com identificadores hasheados (não reversíveis) apenas — sem PII.\n• Logs de acesso: retidos por 6 meses nos termos do art. 15 do Marco Civil da Internet.\n\nAo término destes períodos, os dados são permanentemente excluídos ou irreversivelmente anonimizados.';

  @override
  String get privacySection10Title => '10. SEUS DIREITOS';

  @override
  String get privacySection10Body =>
      'Seus direitos variam conforme sua jurisdição. Você pode exercer qualquer um dos direitos abaixo pelo app (Configurações > Dados e Privacidade), por e-mail para privacidade@openwhen.life (ou privacy@openwhen.life para inglês), ou contatando nosso DPO.\n\n— LGPD (Brasil — Art. 18): Você tem direito a: (i) confirmação da existência de tratamento; (ii) acesso aos dados; (iii) correção de dados incompletos ou inexatos; (iv) anonimização, bloqueio ou eliminação de dados desnecessários ou excessivos; (v) portabilidade a outro prestador de serviços; (vi) eliminação dos dados tratados com base no consentimento; (vii) informação sobre terceiros com quem os dados foram compartilhados; (viii) informação sobre a possibilidade de negar consentimento e suas consequências; (ix) revogação do consentimento. Prazo de resposta: 15 dias úteis. Você pode registrar reclamação junto à ANPD (Autoridade Nacional de Proteção de Dados): https://www.gov.br/anpd.\n\n— GDPR (UE/EEE — Arts. 15–22): Você tem direito a: (i) acesso (art. 15); (ii) retificação (art. 16); (iii) apagamento / direito ao esquecimento (art. 17); (iv) limitação do tratamento (art. 18); (v) portabilidade dos dados (art. 20); (vi) oposição ao tratamento baseado em interesse legítimo (art. 21); (vii) não ser submetido a decisões exclusivamente automatizadas, incluindo perfilamento (art. 22) — veja a Seção 6 acima; (viii) retirar o consentimento a qualquer momento (art. 7(3)). Prazo de resposta: 30 dias. Você pode apresentar reclamação à autoridade supervisora local.\n\n— CCPA/CPRA (Califórnia): Como consumidor da Califórnia, você tem direito a: (i) saber quais PI coletamos, usamos, divulgamos e vendemos (Direito de Saber); (ii) solicitar a exclusão de suas PI (Direito de Exclusão) — prazo de resposta: 45 dias; (iii) corrigir PI imprecisas (Direito de Correção); (iv) recusar a venda ou compartilhamento de PI — não vendemos nem compartilhamos suas PI, mas você pode enviar uma solicitação a qualquer momento; (v) limitar o uso de PI sensíveis — não utilizamos PI sensíveis além do necessário para prestar nossos serviços; (vi) não discriminação pelo exercício de seus direitos. Você pode designar um agente autorizado para enviar solicitações em seu nome. Verificamos solicitações usando o e-mail da sua conta. As categorias de PI coletadas, finalidades e divulgações a terceiros estão detalhadas nas Seções 2, 5 e 7.';

  @override
  String get privacySection11Title => '11. EXCLUSÃO DE CONTA';

  @override
  String get privacySection11Body =>
      'Você pode excluir sua conta a qualquer momento em Configurações > Dados e Privacidade > Excluir Conta. Antes da exclusão, você deverá se reautenticar por segurança. Serão oferecidos dois modos:\n\n(a) Excluir Tudo: remove permanentemente seu perfil, todas as cartas (enviadas e recebidas), cápsulas, comentários, curtidas, follows, bloqueios, denúncias, feedback, badges, notificações e todos os arquivos enviados (fotos, mensagens de voz, imagens manuscritas). Seu registro de autenticação no Firebase também é excluído.\n\n(b) Anonimizar: preserva cartas e cápsulas para seus destinatários, mas substitui seu nome por \"Usuário removido\" e remove suas informações identificáveis (ID de usuário, dados de localização, mídia pessoal). Seu perfil, conexões sociais, comentários e curtidas são excluídos.\n\nEm ambos os modos: (i) assinaturas Stripe ativas são canceladas; (ii) um log de auditoria não reversível é registrado (identificador hasheado + timestamp, sem PII) para fins de compliance; (iii) a exclusão é irreversível. Cartas bloqueadas que você já enviou podem continuar a ser entregues aos seus destinatários conforme nossos Termos de Uso — uma carta enviada é um presente confiado ao destinatário.';

  @override
  String get privacySection12Title => '12. PORTABILIDADE E EXPORTAÇÃO DE DADOS';

  @override
  String get privacySection12Body =>
      'Nos termos da LGPD art. 18 V e GDPR art. 20, você tem o direito de receber seus dados pessoais em formato estruturado, de uso comum e leitura automática. Você pode exportar seus dados em Configurações > Dados e Privacidade > Exportar Meus Dados. A exportação inclui: suas informações de perfil (JSON), todas as cartas enviadas (JSON + arquivos de mídia anexados), cápsulas criadas (JSON + fotos), seus comentários (JSON), curtidas (JSON), listas de seguidores/seguindo (JSON) e badges (JSON). A exportação é gerada como um arquivo ZIP. Você também pode solicitar uma exportação manual contatando privacidade@openwhen.life.';

  @override
  String get privacySection13Title => '13. PRIVACIDADE DE CRIANÇAS';

  @override
  String get privacySection13Body =>
      'O OpenWhen não é direcionado a crianças menores de 13 anos. Em conformidade com a COPPA (16 CFR Part 312), não coletamos intencionalmente informações pessoais de crianças menores de 13 anos. Durante o cadastro, os usuários devem confirmar que têm 13 anos ou mais. Se tomarmos conhecimento de que coletamos dados de uma criança menor de 13 anos sem consentimento parental verificável, excluiremos prontamente tais dados. Pais ou responsáveis que acreditam que seu filho forneceu dados pessoais a nós podem entrar em contato pelo e-mail privacidade@openwhen.life para solicitar a exclusão. Para usuários de 13 a 17 anos, recomendamos orientação dos pais ao usar a Plataforma.';

  @override
  String get privacySection14Title => '14. MEDIDAS DE SEGURANÇA';

  @override
  String get privacySection14Body =>
      'Implementamos medidas técnicas e organizacionais adequadas para proteger seus dados pessoais, incluindo: (a) criptografia em trânsito usando TLS 1.3 para todas as comunicações entre o app e nossos servidores; (b) criptografia em repouso para dados armazenados no Google Cloud/Firebase; (c) Firebase App Check (Play Integrity no Android, DeviceCheck no iOS) para proteger serviços de backend contra abusos; (d) controle de acesso baseado em funções limitando o acesso de colaboradores a dados pessoais; (e) Regras de Segurança do Firestore aplicando restrições de acesso a dados no nível do banco de dados; (f) monitoramento contínuo de segurança e logging. Em caso de violação de dados pessoais: nos termos do GDPR, notificaremos a autoridade supervisora competente em até 72 horas após tomar conhecimento da violação (art. 33) e os titulares afetados sem demora indevida quando a violação representar alto risco (art. 34); nos termos da LGPD, notificaremos a ANPD e os titulares afetados em prazo razoável (art. 48); nos termos da CCPA, notificaremos os consumidores californianos afetados conforme exigido pelo California Civil Code § 1798.82.';

  @override
  String get privacySection15Title => '15. TECNOLOGIAS DE RASTREAMENTO';

  @override
  String get privacySection15Body =>
      'A Plataforma não utiliza cookies tradicionais de navegador. No entanto, as seguintes tecnologias coletam dados automaticamente: (a) Firebase Analytics: coleta eventos de uso anônimos, visualizações de tela e propriedades do dispositivo usando identificadores móveis. Você pode redefinir seu identificador de publicidade nas configurações do dispositivo. O período de retenção do Firebase Analytics é de 14 meses. (b) Firebase Crashlytics: coleta relatórios de falhas incluindo estado do dispositivo, versão do app e rastreamento de pilha para nos ajudar a corrigir bugs. (c) Firebase App Check: verifica a integridade do dispositivo para proteção contra abusos automatizados. Estas tecnologias são essenciais para a operação, segurança e melhoria da Plataforma. Não utilizamos nenhuma tecnologia de rastreamento para publicidade ou rastreamento comportamental entre sites/apps. Respeitamos o sinal Global Privacy Control (GPC) como solicitação válida de opt-out nos termos da CCPA.';

  @override
  String get privacySection16Title => '16. ALTERAÇÕES NESTA POLÍTICA';

  @override
  String get privacySection16Body =>
      'Podemos atualizar esta Política periodicamente para refletir mudanças em nossas práticas, requisitos legais ou funcionalidades da Plataforma. Quando fizermos alterações materiais, iremos: (a) atualizar a \"Data de vigência\" no topo desta Política; (b) notificá-lo via notificação no app e/ou e-mail com pelo menos 15 dias de antecedência; (c) para alterações que exijam renovação de consentimento nos termos do GDPR ou da LGPD, solicitar seu consentimento expresso antes que as alterações entrem em vigor. O uso continuado da Plataforma após a data de vigência de uma atualização que não requeira consentimento constitui aceitação da Política revisada. Versões anteriores desta Política estão disponíveis mediante solicitação.';

  @override
  String get privacySection17Title => '17. FALE CONOSCO';

  @override
  String get privacySection17Body =>
      'Se você tem dúvidas sobre esta Política, deseja exercer seus direitos ou precisa reportar uma preocupação de privacidade, entre em contato:\n\n• Encarregado de Proteção de Dados (DPO): dpo@openwhen.life\n• Solicitações de privacidade (português): privacidade@openwhen.life\n• Solicitações de privacidade (inglês): privacy@openwhen.life\n• Departamento jurídico: juridico@openwhen.life\n• Suporte geral: suporte@openwhen.life\n\nBrasil — Você pode registrar reclamação junto à ANPD: https://www.gov.br/anpd\nUE/EEE — Você pode apresentar reclamação à autoridade supervisora de proteção de dados local.\nCalifórnia — Você pode contatar o Procurador-Geral da Califórnia: https://oag.ca.gov/privacy\n\nOpenWhen Tecnologia Ltda.\nÚltima atualização: 10 de abril de 2026.';

  @override
  String get letterPrivacyPublicLabel => 'Pública';

  @override
  String get letterPrivacyPublicSubtitle => 'Aparece no feed para todos';

  @override
  String get letterPrivacyPrivateLabel => 'Privada';

  @override
  String get letterPrivacyPrivateSubtitle => 'Só você pode ver';

  @override
  String get letterPrivacyActionMakePublic => 'Tornar pública';

  @override
  String get letterPrivacyActionMakePrivate => 'Tornar privada';

  @override
  String get letterDetailSentView => 'SUA CARTA ENVIADA';

  @override
  String get feedReadMore => 'Ler mais';

  @override
  String get feedReadFullLetter => 'Ler carta completa';

  @override
  String get feedCardToAnonymous => 'Para: alguém especial';

  @override
  String get vaultLetterSheetHideReceiver => 'Ocultar nome do destinatário';

  @override
  String get vaultLetterSheetShowReceiver => 'Mostrar nome do destinatário';

  @override
  String get feedRemoveFromFeed => 'Remover do feed';

  @override
  String get feedHideSenderName => 'Ocultar quem me enviou';

  @override
  String get feedShowSenderName => 'Mostrar quem me enviou';

  @override
  String get feedSenderAnonymous => 'Alguém especial';

  @override
  String get registerAcceptTermsPrefix => 'Li e aceito os ';

  @override
  String get registerAcceptTermsAnd => ' e a ';

  @override
  String get registerConfirmAge => 'Confirmo que tenho 13 anos ou mais';

  @override
  String get registerMustAcceptTerms =>
      'Você precisa aceitar os termos e confirmar sua idade para continuar';

  @override
  String get settingsDeleteChoiceTitle =>
      'O que deve acontecer com suas cartas?';

  @override
  String get settingsDeleteOptionDeleteAll => 'Apagar tudo';

  @override
  String get settingsDeleteOptionDeleteAllDesc =>
      'Todas as cartas, cápsulas e dados serão removidos permanentemente.';

  @override
  String get settingsDeleteOptionAnonymize => 'Anonimizar minhas cartas';

  @override
  String get settingsDeleteOptionAnonymizeDesc =>
      'Suas cartas permanecem para os destinatários, mas seu nome e dados são removidos.';

  @override
  String get settingsDeletePasswordLabel => 'CONFIRME SUA SENHA';

  @override
  String get settingsDeletePasswordHint => 'Digite sua senha atual';

  @override
  String get settingsDeleteIrreversibleConfirm =>
      'Entendo que esta ação é irreversível e todos os meus dados serão processados de acordo com minha escolha acima.';

  @override
  String get settingsDeleteProcessing => 'Deletando sua conta...';

  @override
  String get settingsDeleteWrongPassword => 'Senha incorreta. Tente novamente.';

  @override
  String get settingsDeleteReauthFailed =>
      'Falha na autenticação. Tente novamente.';

  @override
  String get settingsDeleteError =>
      'Falha ao deletar conta. Tente novamente mais tarde.';
}
