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
      'Conta criada com sucesso! Faça login para continuar.';

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
  String get vaultTitle => 'Meu Cofre';

  @override
  String get vaultSubtitle => 'SUAS CARTAS E CAPSULAS';

  @override
  String get vaultTabWaiting => 'Aguardando';

  @override
  String get vaultTabOpened => 'Abertas';

  @override
  String get vaultTabSent => 'Enviadas';

  @override
  String get vaultTabCapsules => 'Capsulas';

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
  String get writeLetterPublicToggle => 'Carta pública';

  @override
  String get writeLetterPublicHint => 'Pode aparecer no feed após ser aberta';

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
  String get letterDetailShareSubtitle => 'Stories, Reels ou link direto';

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
  String get capsuleDetailShareSubtitle => 'Texto resumido da capsula';

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
  String get qrFooterBrand => 'openwhen.app';

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
  String get settingsExportButton => 'Exportar como PDF';

  @override
  String get settingsExportSnack => 'Exportação em breve! 📦';

  @override
  String get settingsDeleteTitle => 'Deletar conta';

  @override
  String get settingsDeleteBody =>
      'Esta ação é irreversível. Todas as suas cartas, seguidores e dados serão deletados permanentemente.';

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
      'Não foi possível abrir o e-mail. Contate suporte@openwhen.app.';

  @override
  String feedbackEmailBodyPrefix(String category) {
    return 'Categoria: $category';
  }

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
  String get termsSection7Title => '7. DAS DISPOSIÇÕES GERAIS';

  @override
  String get termsSection7Body =>
      'Estes Termos são regidos pelas leis da República Federativa do Brasil. Fica eleito o foro da comarca de São Paulo/SP para dirimir quaisquer controvérsias decorrentes deste instrumento, com renúncia expressa a qualquer outro foro, por mais privilegiado que seja. A nulidade de qualquer cláusula não afeta a validade das demais. Dúvidas e notificações devem ser encaminhadas para: juridico@openwhen.app. Última atualização: 22 de março de 2026.';

  @override
  String get privacyIntro =>
      'Esta Política de Privacidade (\"Política\") descreve como a OpenWhen Tecnologia Ltda. (\"Empresa\", \"nós\") coleta, trata, armazena e compartilha os dados pessoais dos usuários da Plataforma OpenWhen, em conformidade com a Lei nº 13.709/2018 (Lei Geral de Proteção de Dados — LGPD), o Regulamento Geral de Proteção de Dados da União Europeia (GDPR — Regulamento EU 2016/679), a Lei nº 12.965/2014 (Marco Civil da Internet) e demais normas aplicáveis. A Empresa atua como Controladora de Dados, nos termos do art. 5º, inciso VI, da LGPD.';

  @override
  String get privacySection1Title => '1. DOS DADOS PESSOAIS COLETADOS';

  @override
  String get privacySection1Body =>
      'A Empresa coleta as seguintes categorias de dados pessoais: (i) Dados de cadastro: nome completo, endereço de e-mail, nome de usuário e foto de perfil; (ii) Dados de uso: interações na Plataforma, cartas criadas, enviadas e recebidas, curtidas e comentários; (iii) Dados técnicos: endereço IP, identificador do dispositivo, sistema operacional e logs de acesso, nos termos do art. 15 do Marco Civil da Internet; (iv) Dados de localização: país de origem, coletado de forma não precisa e apenas para personalização do serviço. Não coletamos dados pessoais sensíveis, conforme definição do art. 5º, inciso II, da LGPD, salvo mediante consentimento expresso.';

  @override
  String get privacySection2Title => '2. DAS BASES LEGAIS PARA O TRATAMENTO';

  @override
  String get privacySection2Body =>
      'O tratamento dos dados pessoais dos usuários fundamenta-se nas seguintes hipóteses legais previstas no art. 7º da LGPD: (i) Consentimento do titular, nos termos do art. 7º, inciso I, manifestado no momento do cadastro; (ii) Execução de contrato, nos termos do art. 7º, inciso V, para prestação dos serviços contratados; (iii) Legítimo interesse da Empresa, nos termos do art. 7º, inciso IX, para melhoria da Plataforma, prevenção a fraudes e segurança do serviço; (iv) Cumprimento de obrigação legal ou regulatória, nos termos do art. 7º, inciso II.';

  @override
  String get privacySection3Title => '3. DA FINALIDADE DO TRATAMENTO';

  @override
  String get privacySection3Body =>
      'Os dados pessoais coletados são tratados para as seguintes finalidades: (i) Prestação dos serviços da Plataforma; (ii) Personalização da experiência do usuário; (iii) Envio de notificações relacionadas ao serviço; (iv) Melhoria contínua da Plataforma; (v) Prevenção a fraudes e garantia de segurança; (vi) Cumprimento de obrigações legais e regulatórias; (vii) Exercício regular de direitos em processos judiciais, administrativos ou arbitrais. Os dados não são utilizados para publicidade de terceiros.';

  @override
  String get privacySection4Title => '4. DO COMPARTILHAMENTO DE DADOS';

  @override
  String get privacySection4Body =>
      'A Empresa não vende, aluga ou cede dados pessoais a terceiros para fins comerciais. O compartilhamento de dados ocorre exclusivamente nas seguintes hipóteses: (i) Com prestadores de serviço essenciais à operação da Plataforma (Firebase/Google Cloud), na condição de Operadores de Dados, mediante contrato que garanta nível adequado de proteção; (ii) Com autoridades públicas, mediante ordem judicial ou requisição legal fundamentada; (iii) Com adquirente em caso de fusão, aquisição ou reestruturação societária, garantida a continuidade desta Política.';

  @override
  String get privacySection5Title =>
      '5. DOS DIREITOS DO TITULAR (LGPD — Art. 18)';

  @override
  String get privacySection5Body =>
      'Nos termos do art. 18 da LGPD, o usuário titular dos dados tem direito a: (i) Confirmação da existência de tratamento; (ii) Acesso aos dados; (iii) Correção de dados incompletos, inexatos ou desatualizados; (iv) Anonimização, bloqueio ou eliminação de dados desnecessários; (v) Portabilidade dos dados a outro fornecedor, mediante requisição expressa; (vi) Eliminação dos dados tratados com base no consentimento; (vii) Informação sobre compartilhamento com terceiros; (viii) Revogação do consentimento. Para exercer seus direitos, acesse Configurações > Dados e Privacidade ou contate: privacidade@openwhen.app. O prazo de resposta é de até 15 dias úteis.';

  @override
  String get privacySection6Title => '6. DA SEGURANÇA E RETENÇÃO DOS DADOS';

  @override
  String get privacySection6Body =>
      'A Empresa adota medidas técnicas e organizacionais adequadas para proteger os dados pessoais contra acesso não autorizado, destruição, perda ou alteração, incluindo: criptografia em trânsito (TLS 1.3) e em repouso, controle de acesso baseado em funções e monitoramento contínuo de segurança. Os dados são retidos pelo período necessário às finalidades do tratamento e eliminados ao término da relação contratual, salvo obrigação legal de retenção. Em caso de incidente de segurança, o titular será notificado nos termos do art. 48 da LGPD.';

  @override
  String get privacySection7Title => '7. DAS TRANSFERÊNCIAS INTERNACIONAIS';

  @override
  String get privacySection7Body =>
      'Os dados pessoais dos usuários podem ser transferidos para servidores localizados fora do Brasil (Google Cloud Platform), em conformidade com o art. 33 da LGPD, garantindo nível de proteção adequado mediante cláusulas contratuais padrão aprovadas pela Autoridade Nacional de Proteção de Dados (ANPD).';

  @override
  String get privacySection8Title =>
      '8. DO ENCARREGADO DE PROTEÇÃO DE DADOS (DPO)';

  @override
  String get privacySection8Body =>
      'Nos termos do art. 41 da LGPD, o Encarregado de Proteção de Dados (DPO) da Empresa pode ser contatado em: dpo@openwhen.app. Última atualização: 22 de março de 2026.';
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
      'Conta criada com sucesso! Faça login para continuar.';

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
  String get vaultTitle => 'Meu Cofre';

  @override
  String get vaultSubtitle => 'SUAS CARTAS E CAPSULAS';

  @override
  String get vaultTabWaiting => 'Aguardando';

  @override
  String get vaultTabOpened => 'Abertas';

  @override
  String get vaultTabSent => 'Enviadas';

  @override
  String get vaultTabCapsules => 'Capsulas';

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
  String get writeLetterPublicToggle => 'Carta pública';

  @override
  String get writeLetterPublicHint => 'Pode aparecer no feed após ser aberta';

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
  String get letterDetailShareSubtitle => 'Stories, Reels ou link direto';

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
  String get capsuleDetailShareSubtitle => 'Texto resumido da capsula';

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
  String get qrFooterBrand => 'openwhen.app';

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
  String get settingsExportButton => 'Exportar como PDF';

  @override
  String get settingsExportSnack => 'Exportação em breve! 📦';

  @override
  String get settingsDeleteTitle => 'Deletar conta';

  @override
  String get settingsDeleteBody =>
      'Esta ação é irreversível. Todas as suas cartas, seguidores e dados serão deletados permanentemente.';

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
      'Não foi possível abrir o e-mail. Contate suporte@openwhen.app.';

  @override
  String feedbackEmailBodyPrefix(String category) {
    return 'Categoria: $category';
  }

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
  String get termsSection7Title => '7. DAS DISPOSIÇÕES GERAIS';

  @override
  String get termsSection7Body =>
      'Estes Termos são regidos pelas leis da República Federativa do Brasil. Fica eleito o foro da comarca de São Paulo/SP para dirimir quaisquer controvérsias decorrentes deste instrumento, com renúncia expressa a qualquer outro foro, por mais privilegiado que seja. A nulidade de qualquer cláusula não afeta a validade das demais. Dúvidas e notificações devem ser encaminhadas para: juridico@openwhen.app. Última atualização: 22 de março de 2026.';

  @override
  String get privacyIntro =>
      'Esta Política de Privacidade (\"Política\") descreve como a OpenWhen Tecnologia Ltda. (\"Empresa\", \"nós\") coleta, trata, armazena e compartilha os dados pessoais dos usuários da Plataforma OpenWhen, em conformidade com a Lei nº 13.709/2018 (Lei Geral de Proteção de Dados — LGPD), o Regulamento Geral de Proteção de Dados da União Europeia (GDPR — Regulamento EU 2016/679), a Lei nº 12.965/2014 (Marco Civil da Internet) e demais normas aplicáveis. A Empresa atua como Controladora de Dados, nos termos do art. 5º, inciso VI, da LGPD.';

  @override
  String get privacySection1Title => '1. DOS DADOS PESSOAIS COLETADOS';

  @override
  String get privacySection1Body =>
      'A Empresa coleta as seguintes categorias de dados pessoais: (i) Dados de cadastro: nome completo, endereço de e-mail, nome de usuário e foto de perfil; (ii) Dados de uso: interações na Plataforma, cartas criadas, enviadas e recebidas, curtidas e comentários; (iii) Dados técnicos: endereço IP, identificador do dispositivo, sistema operacional e logs de acesso, nos termos do art. 15 do Marco Civil da Internet; (iv) Dados de localização: país de origem, coletado de forma não precisa e apenas para personalização do serviço. Não coletamos dados pessoais sensíveis, conforme definição do art. 5º, inciso II, da LGPD, salvo mediante consentimento expresso.';

  @override
  String get privacySection2Title => '2. DAS BASES LEGAIS PARA O TRATAMENTO';

  @override
  String get privacySection2Body =>
      'O tratamento dos dados pessoais dos usuários fundamenta-se nas seguintes hipóteses legais previstas no art. 7º da LGPD: (i) Consentimento do titular, nos termos do art. 7º, inciso I, manifestado no momento do cadastro; (ii) Execução de contrato, nos termos do art. 7º, inciso V, para prestação dos serviços contratados; (iii) Legítimo interesse da Empresa, nos termos do art. 7º, inciso IX, para melhoria da Plataforma, prevenção a fraudes e segurança do serviço; (iv) Cumprimento de obrigação legal ou regulatória, nos termos do art. 7º, inciso II.';

  @override
  String get privacySection3Title => '3. DA FINALIDADE DO TRATAMENTO';

  @override
  String get privacySection3Body =>
      'Os dados pessoais coletados são tratados para as seguintes finalidades: (i) Prestação dos serviços da Plataforma; (ii) Personalização da experiência do usuário; (iii) Envio de notificações relacionadas ao serviço; (iv) Melhoria contínua da Plataforma; (v) Prevenção a fraudes e garantia de segurança; (vi) Cumprimento de obrigações legais e regulatórias; (vii) Exercício regular de direitos em processos judiciais, administrativos ou arbitrais. Os dados não são utilizados para publicidade de terceiros.';

  @override
  String get privacySection4Title => '4. DO COMPARTILHAMENTO DE DADOS';

  @override
  String get privacySection4Body =>
      'A Empresa não vende, aluga ou cede dados pessoais a terceiros para fins comerciais. O compartilhamento de dados ocorre exclusivamente nas seguintes hipóteses: (i) Com prestadores de serviço essenciais à operação da Plataforma (Firebase/Google Cloud), na condição de Operadores de Dados, mediante contrato que garanta nível adequado de proteção; (ii) Com autoridades públicas, mediante ordem judicial ou requisição legal fundamentada; (iii) Com adquirente em caso de fusão, aquisição ou reestruturação societária, garantida a continuidade desta Política.';

  @override
  String get privacySection5Title =>
      '5. DOS DIREITOS DO TITULAR (LGPD — Art. 18)';

  @override
  String get privacySection5Body =>
      'Nos termos do art. 18 da LGPD, o usuário titular dos dados tem direito a: (i) Confirmação da existência de tratamento; (ii) Acesso aos dados; (iii) Correção de dados incompletos, inexatos ou desatualizados; (iv) Anonimização, bloqueio ou eliminação de dados desnecessários; (v) Portabilidade dos dados a outro fornecedor, mediante requisição expressa; (vi) Eliminação dos dados tratados com base no consentimento; (vii) Informação sobre compartilhamento com terceiros; (viii) Revogação do consentimento. Para exercer seus direitos, acesse Configurações > Dados e Privacidade ou contate: privacidade@openwhen.app. O prazo de resposta é de até 15 dias úteis.';

  @override
  String get privacySection6Title => '6. DA SEGURANÇA E RETENÇÃO DOS DADOS';

  @override
  String get privacySection6Body =>
      'A Empresa adota medidas técnicas e organizacionais adequadas para proteger os dados pessoais contra acesso não autorizado, destruição, perda ou alteração, incluindo: criptografia em trânsito (TLS 1.3) e em repouso, controle de acesso baseado em funções e monitoramento contínuo de segurança. Os dados são retidos pelo período necessário às finalidades do tratamento e eliminados ao término da relação contratual, salvo obrigação legal de retenção. Em caso de incidente de segurança, o titular será notificado nos termos do art. 48 da LGPD.';

  @override
  String get privacySection7Title => '7. DAS TRANSFERÊNCIAS INTERNACIONAIS';

  @override
  String get privacySection7Body =>
      'Os dados pessoais dos usuários podem ser transferidos para servidores localizados fora do Brasil (Google Cloud Platform), em conformidade com o art. 33 da LGPD, garantindo nível de proteção adequado mediante cláusulas contratuais padrão aprovadas pela Autoridade Nacional de Proteção de Dados (ANPD).';

  @override
  String get privacySection8Title =>
      '8. DO ENCARREGADO DE PROTEÇÃO DE DADOS (DPO)';

  @override
  String get privacySection8Body =>
      'Nos termos do art. 41 da LGPD, o Encarregado de Proteção de Dados (DPO) da Empresa pode ser contatado em: dpo@openwhen.app. Última atualização: 22 de março de 2026.';
}
