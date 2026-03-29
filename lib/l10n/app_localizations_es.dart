// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'OpenWhen';

  @override
  String get splashTagline => 'Cartas para el futuro';

  @override
  String errorGeneric(String error) {
    return 'Error: $error';
  }

  @override
  String get snackFillAllFields => '¡Completa todos los campos!';

  @override
  String get actionSave => 'Guardar';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get actionContinue => 'Continuar';

  @override
  String get actionShare => 'Compartir';

  @override
  String get actionCopy => 'Copiar';

  @override
  String get actionOk => 'OK';

  @override
  String get locationAskShareTitle => '¿Compartir tu ubicación?';

  @override
  String get locationAskShareBody =>
      'El destinatario puede ver dónde estabas al enviar y copiar un enlace de Maps. También puedes exigir abrir solo en un radio de 10 metros de este punto.';

  @override
  String get locationAskShareAllow => 'Compartir ubicación';

  @override
  String get locationAskShareDeny => 'No compartir';

  @override
  String get locationAskRestrictTitle =>
      '¿Exigir estar en el lugar para abrir?';

  @override
  String get locationAskRestrictBody =>
      'El destinatario solo podrá abrir esto en un radio de 10 metros del punto que compartiste.';

  @override
  String get locationAskRestrictYes => 'Sí, 10 m';

  @override
  String get locationAskRestrictNo => 'No';

  @override
  String get locationCaptureFailed =>
      'No se pudo obtener la ubicación. Se envía sin ella.';

  @override
  String get locationShareTileTitle => 'Ubicación del remitente';

  @override
  String get locationShareTileSubtitle =>
      'Toca para copiar el enlace de Google Maps';

  @override
  String get locationCopiedSnack => 'Copiado al portapapeles';

  @override
  String get locationProximityTooFarTitle => 'Demasiado lejos';

  @override
  String get locationProximityTooFarBody =>
      'Solo se puede abrir en un radio de 10 metros de la ubicación compartida. Acércate e inténtalo de nuevo.';

  @override
  String get locationProximityNeedLocationTitle => 'Ubicación necesaria';

  @override
  String get locationProximityNeedLocationBody =>
      'Activa los servicios de ubicación y permite que OpenWhen acceda a tu ubicación para abrir esto.';

  @override
  String get navFeed => 'Feed';

  @override
  String get navSearch => 'Buscar';

  @override
  String get navVault => 'Cofre';

  @override
  String get navProfile => 'Perfil';

  @override
  String get homeWriteLetter => 'Escribir Carta';

  @override
  String get homeWriteLetterSubtitle => 'Para alguien especial';

  @override
  String get homeNewCapsule => 'Nueva Cápsula del Tiempo';

  @override
  String get homeNewCapsuleSubtitle => 'Para ti mismo o un grupo';

  @override
  String get onboardingTag1 => 'CARTAS PARA EL FUTURO';

  @override
  String get onboardingTitle1 => 'Palabras que llegan\nen el momento justo';

  @override
  String get onboardingSubtitle1 =>
      'Escribe una carta hoy. Elige cuándo se abrirá. Deja que el tiempo haga su magia.';

  @override
  String get onboardingTag2 => 'TU COFRE DIGITAL';

  @override
  String get onboardingTitle2 => 'Bloqueada hasta el\nmomento perfecto';

  @override
  String get onboardingSubtitle2 =>
      'La carta queda guardada con seguridad hasta la fecha que elijas — puede ser mañana, o dentro de 10 años.';

  @override
  String get onboardingTag3 => 'COMPARTE AMOR';

  @override
  String get onboardingTitle3 => 'Inspira a otras personas\ncon tu historia';

  @override
  String get onboardingSubtitle3 =>
      'Las cartas abiertas pueden ir al feed público. Esparce amor, amistad y emoción por el mundo.';

  @override
  String get onboardingCreateFirst => 'Crear mi primera carta';

  @override
  String get onboardingAlreadyHaveAccount => 'Ya tengo una cuenta';

  @override
  String get loginHeroLetters => 'CARTAS PARA EL FUTURO';

  @override
  String get loginHeroCreateAccount => 'CREA TU CUENTA GRATIS';

  @override
  String get loginTabSignIn => 'Iniciar sesión';

  @override
  String get loginTabCreateAccount => 'Crear cuenta';

  @override
  String get hintEmail => 'tu@email.com';

  @override
  String get labelEmail => 'Correo electrónico';

  @override
  String get hintPassword => 'tu contraseña';

  @override
  String get labelPassword => 'Contraseña';

  @override
  String get loginForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get loginButtonSignIn => 'Iniciar sesión';

  @override
  String get loginRegisterBlurb =>
      'Crea tu cuenta en un solo paso: nombre, correo y contraseña en la siguiente pantalla.';

  @override
  String get loginBullet1 => 'Cartas para abrir en el futuro';

  @override
  String get loginBullet2 => 'Cofre seguro y feed opcional';

  @override
  String get loginBullet3 => 'Gratis para empezar';

  @override
  String get loginCreateAccount => 'Crear mi cuenta';

  @override
  String get loginAlreadyHaveAccount => 'Ya tengo cuenta — iniciar sesión';

  @override
  String get loginOrContinueWith => 'o continúa con';

  @override
  String get loginLegalFooter =>
      'Al iniciar sesión aceptas los Términos de Uso y la Política de Privacidad.';

  @override
  String get registerSuccess =>
      '¡Cuenta creada con éxito! Inicia sesión para continuar.';

  @override
  String get hintName => 'tu nombre';

  @override
  String get labelName => 'Nombre';

  @override
  String get hintCreatePassword => 'crea una contraseña';

  @override
  String get registerCreateAccount => 'Crear mi cuenta';

  @override
  String get registerAlreadyHaveAccount => 'Ya tengo una cuenta';

  @override
  String get registerLegalFooter =>
      'Al crear tu cuenta aceptas los Términos de Uso y la Política de Privacidad.';

  @override
  String get feedPublicHeader => 'FEED PÚBLICO';

  @override
  String get feedFilterAll => 'Para todos';

  @override
  String get feedFilterLove => 'Amor';

  @override
  String get feedFilterFriendship => 'Amistad';

  @override
  String get feedFilterFamily => 'Familia';

  @override
  String get feedEmptyTitle => 'Aún no hay cartas públicas';

  @override
  String get feedEmptySubtitle =>
      'Sé el primero en compartir\nuna carta con el mundo';

  @override
  String get feedFilterEmptyTitle => 'No hay cartas en este filtro';

  @override
  String get feedFilterEmptySubtitle =>
      'Prueba otro filtro o vuelve a \"Para todos\"';

  @override
  String feedCardTo(String name) {
    return 'Para: $name';
  }

  @override
  String get feedCardFeatured => '✦ Destacada';

  @override
  String feedOpenedOnDate(String date) {
    return 'Abierta el $date';
  }

  @override
  String feedViewAllComments(int count) {
    return 'Ver los $count comentarios';
  }

  @override
  String get commentsTitle => 'Comentarios';

  @override
  String get commentsEmptyTitle => 'Aún no hay comentarios';

  @override
  String get commentsEmptySubtitle => 'Sé el primero en comentar';

  @override
  String get commentsInputHint => 'Escribe con amor... 💌';

  @override
  String get commentsModerationWarning =>
      'Tu mensaje contiene palabras inadecuadas. OpenWhen es un espacio de amor y respeto. 💌';

  @override
  String get vaultTitle => 'Mi Cofre';

  @override
  String get vaultSubtitle => 'TUS CARTAS Y CÁPSULAS';

  @override
  String get vaultTabReceived => 'Recibidas';

  @override
  String get vaultTabSent => 'Enviadas';

  @override
  String get vaultTabCapsules => 'Cápsulas';

  @override
  String get vaultEmptyReceivedTitle => 'Aún no hay cartas recibidas';

  @override
  String get vaultEmptyReceivedSubtitle =>
      'Cuando alguien te envíe una carta\naparecerá aquí';

  @override
  String get vaultCountdownReady => '¡Lista para abrir!';

  @override
  String vaultCountdownDays(int count) {
    return 'Se abre en $count días';
  }

  @override
  String vaultCountdownHours(int count) {
    return 'Se abre en $count horas';
  }

  @override
  String vaultCountdownMinutes(int count) {
    return 'Se abre en $count minutos';
  }

  @override
  String get vaultEmptyWaitingTitle => 'Ninguna carta en espera';

  @override
  String get vaultEmptyWaitingSubtitle =>
      'Cuando alguien te envíe una carta\naparecerá aquí';

  @override
  String get vaultEmptyOpenedTitle => 'Aún no hay cartas abiertas';

  @override
  String get vaultEmptyOpenedSubtitle => 'Tus cartas abiertas\naparecerán aquí';

  @override
  String get vaultEmptySentTitle => 'Ninguna carta enviada';

  @override
  String get vaultEmptySentSubtitle => 'Las cartas que envíes\naparecerán aquí';

  @override
  String get vaultStatusWaiting => 'En espera';

  @override
  String get vaultStatusPending => 'Pendiente';

  @override
  String get vaultStatusOpened => 'Abierta';

  @override
  String get vaultStatusReady => '¡Lista!';

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
  String get vaultAlreadyOpened => '¡Ya fue abierta!';

  @override
  String get vaultPendingRecipient =>
      'Esperando que el destinatario acepte la carta';

  @override
  String get vaultOpenLetter => 'Abrir carta';

  @override
  String get vaultLetterOpened => 'Carta abierta';

  @override
  String get vaultReadFullLetter => 'Leer carta completa';

  @override
  String get vaultOpenCapsule => 'Abrir Cápsula';

  @override
  String get vaultViewFullCapsule => 'Ver cápsula completa';

  @override
  String get vaultEmptyCapsulesTitle => 'Aún no hay cápsulas';

  @override
  String get vaultEmptyCapsulesSubtitle =>
      'Crea tu primera cápsula del tiempo\ny guarda recuerdos para el futuro';

  @override
  String get vaultCreateCapsule => 'Crear Cápsula';

  @override
  String vaultPhotoCount(int count) {
    return '$count foto(s)';
  }

  @override
  String vaultAnswerCount(int count) {
    return '$count respuesta(s)';
  }

  @override
  String vaultCapsuleOpenedOn(String date) {
    return 'Abierta el $date';
  }

  @override
  String get vaultCapsuleSealed => 'Sellada';

  @override
  String get capsulePhotoAdd => 'Agregar foto';

  @override
  String get capsulePhotoHint => 'Toca para agregar una foto a tu cápsula';

  @override
  String get capsulePhotoWebDisabled =>
      'Las fotos solo están disponibles en la app móvil';

  @override
  String get capsulePhotoRemove => 'Eliminar foto';

  @override
  String get capsulePhotoErrorUpload =>
      'Error al subir la foto. Inténtalo de nuevo.';

  @override
  String capsulePhotoMax(int count) {
    return 'Máximo de $count fotos alcanzado';
  }

  @override
  String get vaultFilterTitle => 'Filtrar y ordenar';

  @override
  String get vaultFilterSearchHint => 'Buscar por título o nombre...';

  @override
  String get vaultFilterSortLabel => 'Ordenar por';

  @override
  String get vaultFilterApply => 'Aplicar';

  @override
  String get vaultFilterClear => 'Borrar filtros';

  @override
  String get vaultFilterOpenDateFrom => 'Abre desde';

  @override
  String get vaultFilterOpenDateTo => 'Abre hasta';

  @override
  String get vaultFilterClearDate => 'Quitar fecha';

  @override
  String get vaultFilterPendingOnly => 'Solo pendientes de aceptación';

  @override
  String get vaultFilterThemesLabel => 'Temas';

  @override
  String get vaultFilterDirectionAll => 'Todas';

  @override
  String get vaultFilterDirectionReceived => 'Recibidas';

  @override
  String get vaultFilterDirectionSent => 'Enviadas';

  @override
  String get vaultFilterEmptyTitle => 'Nada coincide con este filtro';

  @override
  String get vaultFilterEmptySubtitle =>
      'Ajusta la búsqueda o borra los filtros para verlo todo';

  @override
  String get vaultFilterActiveBadge => 'Filtrado';

  @override
  String get vaultSortWaitingOpenDateAsc => 'Fecha de apertura (más próxima)';

  @override
  String get vaultSortWaitingOpenDateDesc => 'Fecha de apertura (más lejana)';

  @override
  String get vaultSortWaitingCreatedDesc => 'Creación (más reciente)';

  @override
  String get vaultSortWaitingCreatedAsc => 'Creación (más antigua)';

  @override
  String get vaultSortWaitingTitleAsc => 'Título (A–Z)';

  @override
  String get vaultSortOpenedOpenedAtDesc => 'Abierta (más reciente)';

  @override
  String get vaultSortOpenedOpenedAtAsc => 'Abierta (más antigua)';

  @override
  String get vaultSortOpenedOpenDateDesc => 'Fecha prevista (más lejana)';

  @override
  String get vaultSortOpenedOpenDateAsc => 'Fecha prevista (más próxima)';

  @override
  String get vaultSortOpenedTitleAsc => 'Título (A–Z)';

  @override
  String get vaultSortSentOpenDateAsc => 'Fecha de apertura (más próxima)';

  @override
  String get vaultSortSentOpenDateDesc => 'Fecha de apertura (más lejana)';

  @override
  String get vaultSortSentCreatedDesc => 'Creación (más reciente)';

  @override
  String get vaultSortSentCreatedAsc => 'Creación (más antigua)';

  @override
  String get vaultSortSentTitleAsc => 'Título (A–Z)';

  @override
  String get vaultSortCapsulesOpenDateAsc => 'Fecha de apertura (más próxima)';

  @override
  String get vaultSortCapsulesOpenDateDesc => 'Fecha de apertura (más lejana)';

  @override
  String get vaultSortCapsulesCreatedDesc => 'Creación (más reciente)';

  @override
  String get vaultSortCapsulesCreatedAsc => 'Creación (más antigua)';

  @override
  String get vaultSortCapsulesTitleAsc => 'Título (A–Z)';

  @override
  String get capsuleThemeMemories => 'Recuerdos';

  @override
  String get capsuleThemeGoals => 'Metas';

  @override
  String get capsuleThemeFeelings => 'Sentimientos';

  @override
  String get capsuleThemeRelationships => 'Relaciones';

  @override
  String get capsuleThemeGrowth => 'Crecimiento';

  @override
  String get capsuleThemeDefault => 'Cápsula';

  @override
  String get writeLetterTitle => 'Escribir carta';

  @override
  String get writeLetterFeeling => '¿CÓMO TE SIENTES?';

  @override
  String get writeLetterEmotionLove => 'Amor';

  @override
  String get writeLetterEmotionAchievement => 'Logro';

  @override
  String get writeLetterEmotionAdvice => 'Consejo';

  @override
  String get writeLetterEmotionNostalgia => 'Nostalgia';

  @override
  String get writeLetterEmotionFarewell => 'Despedida';

  @override
  String get writeLetterFieldTitle => 'Título';

  @override
  String get writeLetterFieldTitleHint => 'Ej: Abre cuando sientas nostalgia';

  @override
  String get writeLetterTypeSection => 'TIPO DE CARTA';

  @override
  String get writeLetterTypeTyped => 'Escrita a máquina';

  @override
  String get writeLetterTypeHandwritten => 'Manuscrita';

  @override
  String get writeLetterFieldMessage => 'Tu mensaje';

  @override
  String get writeLetterPhotoTap => 'Toca para agregar la foto de la carta';

  @override
  String get writeLetterPhotoHint => 'Toma una foto de tu carta escrita a mano';

  @override
  String get writeLetterRecipientSection => '¿PARA QUIÉN?';

  @override
  String get writeLetterSearchHint => 'Buscar por @usuario o nombre...';

  @override
  String get writeLetterOrSendExternal => 'o envía a alguien sin cuenta';

  @override
  String get writeLetterEmailHint => 'email@ejemplo.com';

  @override
  String get writeLetterReceiverLink => 'Recibirá un enlace para crear cuenta';

  @override
  String get writeLetterOpenDateLabel => 'Fecha de apertura';

  @override
  String get writeLetterPublicToggle => 'Carta pública';

  @override
  String get writeLetterPublicHint =>
      'Puede aparecer en el feed después de ser abierta';

  @override
  String get writeLetterSend => 'Enviar carta 💌';

  @override
  String get writeLetterSnackTitle => '¡Completa el título!';

  @override
  String get writeLetterSnackMessage => '¡Escribe tu mensaje!';

  @override
  String get writeLetterSnackPhoto => '¡Agrega la foto de la carta!';

  @override
  String get writeLetterSnackRecipient => '¡Elige el destinatario!';

  @override
  String get writeLetterSnackEmotion => '¡Elige el estado emocional!';

  @override
  String get writeLetterSnackSentFriend => '¡Carta enviada! 💌';

  @override
  String get writeLetterSnackSentPending =>
      '¡Carta enviada! Esperando aprobación. 💌';

  @override
  String get writeLetterSnackSentExternal =>
      '¡Carta creada! Comparte el enlace con el destinatario. 💌';

  @override
  String get writeLetterSnackEmailInvalid => '¡Ingresa un correo válido!';

  @override
  String get writeLetterSnackStorageError =>
      'Activa Firebase Storage para usar esta función';

  @override
  String get writeLetterMusicUrlLabel => 'Enlace de la canción (opcional)';

  @override
  String get writeLetterMusicUrlHint => 'https://open.spotify.com/...';

  @override
  String get writeLetterSnackMusicUrlInvalid =>
      'Usa un enlace https:// válido para la canción.';

  @override
  String get writeLetterMessageTapToExpand => 'Toca para escribir tu mensaje';

  @override
  String get writeLetterVoiceSection => 'Mensaje de voz (opcional)';

  @override
  String get writeLetterVoiceRecord => 'Grabar';

  @override
  String get writeLetterVoiceStop => 'Detener';

  @override
  String get writeLetterVoiceDiscard => 'Descartar audio';

  @override
  String get writeLetterVoicePreview => 'Vista previa';

  @override
  String get writeLetterVoiceMaxDuration => 'El límite es 1 minuto.';

  @override
  String get writeLetterVoicePermissionDenied =>
      'Se necesita permiso del micrófono para grabar.';

  @override
  String get writeLetterVoiceOpenSettings => 'Abrir ajustes';

  @override
  String get writeLetterVoiceWillSend => 'Se enviará con la carta';

  @override
  String get writeLetterVoiceUploadError =>
      'No se pudo subir el audio. Inténtalo de nuevo.';

  @override
  String get voiceLetterTitle => 'Mensaje de voz';

  @override
  String get voiceLetterSubtitle => 'Grabado por el remitente';

  @override
  String get voiceLetterPlay => 'Escuchar';

  @override
  String get voiceLetterPause => 'Pausar';

  @override
  String get voiceLetterPlayError => 'No se pudo reproducir el audio.';

  @override
  String get musicLinkTitle => 'Escuchar música';

  @override
  String get musicLinkSubtitle => 'Se abre en la app o el navegador';

  @override
  String get musicLinkOpenError => 'No se pudo abrir este enlace.';

  @override
  String get letterDetailHeaderFrom => 'UNA CARTA DE';

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
    return 'Abierta $date';
  }

  @override
  String get letterDetailQrTitle => 'Generar código QR';

  @override
  String get letterDetailQrSubtitle => 'Colócalo en el regalo físico 🎁';

  @override
  String get letterDetailShareTitle => 'Compartir carta';

  @override
  String get letterDetailShareSubtitle => 'Stories, Reels o enlace directo';

  @override
  String get letterOpeningEmotionLove => 'Una carta de amor te espera 💕';

  @override
  String get letterOpeningEmotionAchievement =>
      'Un logro fue guardado para ti 🏆';

  @override
  String get letterOpeningEmotionAdvice => 'Un consejo especial te espera 🌿';

  @override
  String get letterOpeningEmotionNostalgia => 'Recuerdos guardados para ti 🍂';

  @override
  String get letterOpeningEmotionFarewell =>
      'Palabras de despedida te esperaron 🦋';

  @override
  String letterOpeningWrittenOpenedToday(String date) {
    return 'Escrita $date  ·  Abierta hoy';
  }

  @override
  String get letterOpeningPublishFeed => '✦  Publicar en el feed';

  @override
  String get letterOpeningKeepPrivate => 'Guardar solo para mí';

  @override
  String get letterOpeningTapToOpen => 'TOCA PARA ABRIR';

  @override
  String get requestsTitle => 'Solicitudes de carta';

  @override
  String get requestsSubtitle => 'De personas que no sigues';

  @override
  String get requestsEmptyTitle => 'No hay solicitudes pendientes';

  @override
  String get requestsEmptySubtitle =>
      'Cuando alguien que no sigues\nte envíe una carta, aparecerá aquí.';

  @override
  String get requestsSheetTitle => '¿Qué deseas hacer?';

  @override
  String requestsSheetLetterFrom(String name) {
    return 'Carta de $name';
  }

  @override
  String get requestsAccept => 'Aceptar carta';

  @override
  String get requestsDecline => 'Rechazar carta';

  @override
  String requestsBlockUser(String name) {
    return 'Bloquear a $name';
  }

  @override
  String get requestsSnackAccepted =>
      '¡Carta aceptada! Aparecerá en tu cofre. 💌';

  @override
  String get requestsSnackDeclined => 'Carta rechazada.';

  @override
  String get requestsSnackBlocked => 'Usuario bloqueado.';

  @override
  String get requestsSenderNotFollowing => 'Persona que no sigues';

  @override
  String get requestsBadgePending => 'Pendiente';

  @override
  String get requestsRevealHint => 'Acepta para revelar el mensaje';

  @override
  String requestsOpensOn(String date) {
    return 'Se abre el $date';
  }

  @override
  String get requestsViewOptions => 'Ver opciones';

  @override
  String get qrScreenTitle => 'Código QR de la carta';

  @override
  String get qrScreenSubtitle => 'Imprímelo y colócalo en el regalo';

  @override
  String get qrCardHeadline => 'Una carta especial te espera';

  @override
  String qrCardMeta(String sender, String date) {
    return 'De $sender  ·  Se abre el $date';
  }

  @override
  String get qrScanHint => 'Escanea para acceder a la carta';

  @override
  String get qrHowToTitle => 'Cómo usarlo en el regalo físico';

  @override
  String get qrStep1 => 'Comparte el código QR por WhatsApp o imprímelo';

  @override
  String get qrStep2 => 'Colócalo dentro o en el empaque del regalo';

  @override
  String get qrStep3 => 'La persona lo escanea y descubre la carta';

  @override
  String get qrStep4 => 'La carta se abre automáticamente en la fecha indicada';

  @override
  String get qrLinkCopied => '¡Enlace copiado! 🔗';

  @override
  String qrShareText(String title, String link) {
    return '💌 ¡Una carta especial te espera en OpenWhen!\n\n\"$title\"\n\nEscanea el código QR o accede a: $link';
  }

  @override
  String get qrShareSubject => 'Una carta especial te espera 💌';

  @override
  String qrShareLinkOnly(String title, String link) {
    return '💌 ¡Una carta especial te espera en OpenWhen!\n\n\"$title\"\n\nAccede a: $link';
  }

  @override
  String qrShareWhatsApp(String title, String link) {
    return '💌 ¡Una carta especial te espera!\n\n\"$title\"\n\nÁbrela aquí: $link';
  }

  @override
  String get createCapsuleTitle => 'Nueva Cápsula del Tiempo';

  @override
  String createCapsuleStepProgress(int current, String stepName) {
    return 'Paso $current de 3 — $stepName';
  }

  @override
  String get createCapsuleStepTheme => 'Tema';

  @override
  String get createCapsuleStepMessage => 'Mensaje';

  @override
  String get createCapsuleStepWhen => 'Cuándo abrir';

  @override
  String get createCapsuleSeal => 'Sellar Cápsula 🦉';

  @override
  String get createCapsuleThemeQuestion =>
      '¿Cuál es la esencia\nde esta cápsula?';

  @override
  String get createCapsuleThemeHint => 'Elige un tema para tu cápsula.';

  @override
  String get createCapsuleThemeMemoriesLabel => 'Recuerdos';

  @override
  String get createCapsuleThemeMemoriesSubtitle =>
      'Guarda lo que no quieres olvidar';

  @override
  String get createCapsuleThemeGoalsLabel => 'Metas';

  @override
  String get createCapsuleThemeGoalsSubtitle => 'Una promesa para el futuro';

  @override
  String get createCapsuleThemeFeelingsLabel => 'Sentimientos';

  @override
  String get createCapsuleThemeFeelingsSubtitle =>
      'Lo que hay dentro de ti ahora';

  @override
  String get createCapsuleThemeRelationshipsLabel => 'Relaciones';

  @override
  String get createCapsuleThemeRelationshipsSubtitle =>
      'Las personas que importan';

  @override
  String get createCapsuleThemeGrowthLabel => 'Crecimiento';

  @override
  String get createCapsuleThemeGrowthSubtitle =>
      'En quién te estás convirtiendo';

  @override
  String get createCapsuleWriteHeading => 'Escríbele a tu\nyo del futuro';

  @override
  String get createCapsuleWriteHint =>
      'Escribe libremente. Sin reglas. Solo tú y el futuro.';

  @override
  String get createCapsuleFieldTitle => 'Título';

  @override
  String get createCapsuleFieldTitleHint =>
      'Ej: Para mi yo de dentro de 1 año...';

  @override
  String get createCapsuleMusicUrlLabel => 'Enlace de la canción (opcional)';

  @override
  String get createCapsuleMusicUrlHint => 'https://music.youtube.com/...';

  @override
  String get createCapsuleFieldMessageHint =>
      'Querido yo del futuro...\n\nEscribe lo que sientes, lo que sueñas, lo que quieres recordar...';

  @override
  String createCapsuleCharCount(int count) {
    return '$count caracteres';
  }

  @override
  String get createCapsuleCharMin => ' (mínimo 10)';

  @override
  String get createCapsuleWhenHeading => '¿Cuándo podrás\nabrirla?';

  @override
  String get createCapsuleWhenHint => 'Elige una fecha o un evento especial.';

  @override
  String get createCapsuleTypeDate => 'Fecha';

  @override
  String get createCapsuleTypeEvent => 'Evento';

  @override
  String get createCapsuleTypeBoth => 'Ambos';

  @override
  String get createCapsulePickDate => 'Elegir fecha';

  @override
  String get createCapsuleCustomEventHint => 'O describe el evento...';

  @override
  String get createCapsulePublishToggle => 'Publicar en el feed al abrir';

  @override
  String get createCapsulePublishHint => 'Tú decides después de revisar todo';

  @override
  String get createCapsuleSuccessTitle => '¡Cápsula sellada!';

  @override
  String get createCapsuleSuccessBody =>
      'Tus palabras están guardadas.\nSolo tú podrás abrirla en el momento indicado.';

  @override
  String get createCapsuleSuccessViewVault => 'Ver mi Cofre';

  @override
  String get createCapsulePresetBirthday => 'Mi cumpleaños';

  @override
  String get createCapsulePresetAnniversary => 'Nuestro aniversario';

  @override
  String get createCapsulePresetGraduation => 'Mi graduación';

  @override
  String get createCapsulePresetBaby => 'Nacimiento del bebé';

  @override
  String get createCapsulePresetMoving => 'Nuestra mudanza';

  @override
  String get createCapsulePresetTrip => 'Fin del viaje';

  @override
  String get createCapsulePresetCareer => 'Nueva etapa profesional';

  @override
  String get createCapsulePresetChristmas => 'Navidad';

  @override
  String get createCapsulePresetNewYear => 'Año Nuevo';

  @override
  String get capsuleDetailYourCapsule => 'Tu cápsula';

  @override
  String capsuleDetailDates(String createdDate, String openedDate) {
    return 'Creada el $createdDate  ·  Abierta el $openedDate';
  }

  @override
  String get capsuleDetailOnFeed => 'En el feed';

  @override
  String get capsuleDetailShareSubtitle => 'Texto resumido de la cápsula';

  @override
  String get capsuleDetailDeleteTitle => 'Eliminar cápsula';

  @override
  String get capsuleDetailDeleteSubtitle =>
      'Se elimina del cofre permanentemente';

  @override
  String get capsuleDetailDeleteConfirm => '¿Eliminar cápsula?';

  @override
  String get capsuleDetailDeleteBody => 'Esta acción no se puede deshacer.';

  @override
  String get capsuleOpeningHeader => 'CÁPSULA DEL TIEMPO';

  @override
  String get capsuleOpeningThemeMemories =>
      'Recuerdos guardados para el futuro';

  @override
  String get capsuleOpeningThemeGoals => 'Tus metas te esperan';

  @override
  String get capsuleOpeningThemeFeelings => 'Lo que sentiste, guardado aquí';

  @override
  String get capsuleOpeningThemeRelationships => 'Conexiones que importan';

  @override
  String get capsuleOpeningThemeGrowth => 'En quién te estás convirtiendo';

  @override
  String get capsuleOpeningPublishFeed => 'Publicar en el feed';

  @override
  String get capsuleOpeningKeepPrivate => 'Guardar solo para mí';

  @override
  String get capsuleOpeningTapToOpen => 'TOCA PARA ABRIR';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profilePrivate => 'Privada';

  @override
  String get profilePublic => 'Pública';

  @override
  String get profileDefaultName => 'Usuario';

  @override
  String get profileStatFollowers => 'Seguidores';

  @override
  String get profileStatFollowing => 'Siguiendo';

  @override
  String get profileStatSent => 'Enviadas';

  @override
  String get profileStatOpened => 'Abiertas';

  @override
  String get profileStatLetters => 'Cartas';

  @override
  String get profileEmptyTitle => 'Ninguna carta publicada';

  @override
  String get profileEmptySubtitle =>
      'Tus cartas abiertas y públicas\naparecerán aquí';

  @override
  String get editProfileTitle => 'Editar perfil';

  @override
  String get editProfileSectionName => 'NOMBRE';

  @override
  String get editProfileSectionUsername => 'USERNAME';

  @override
  String get editProfileSectionBio => 'BIO';

  @override
  String get editProfileHintName => 'Tu nombre completo';

  @override
  String get editProfileHintUsername => 'tu_username';

  @override
  String get editProfileHintBio => 'Cuéntanos un poco sobre ti...';

  @override
  String get editProfileUsernameRules => 'Solo letras, números y _';

  @override
  String get editProfileSaveChanges => 'Guardar cambios';

  @override
  String get editProfileErrorNameEmpty => 'El nombre no puede estar vacío';

  @override
  String get editProfileErrorUsernameEmpty =>
      'El username no puede estar vacío';

  @override
  String get editProfileErrorUsernameShort =>
      'El username debe tener al menos 3 caracteres';

  @override
  String get editProfileErrorUsernameTaken => 'Este username ya está en uso';

  @override
  String get editProfileSaved => '¡Perfil actualizado!';

  @override
  String get userProfileFollowing => 'Siguiendo';

  @override
  String get userProfileFollow => 'Seguir';

  @override
  String get userProfileEmptyLetters => 'Aún no hay cartas públicas';

  @override
  String get searchTitle => 'Buscar personas';

  @override
  String get searchHint => 'Buscar por nombre o @username...';

  @override
  String get searchEmpty => 'Sin resultados';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get themeSection => 'TEMA DE LA APP';

  @override
  String get themeSystem => 'Automático (sistema)';

  @override
  String get themeSystemSubtitle => 'Claro u oscuro según el dispositivo';

  @override
  String get themeClassic => 'Clásico';

  @override
  String get themeClassicSubtitle => 'Fondo claro y acento rojo';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeDarkSubtitle => 'Interfaz oscura cómoda';

  @override
  String get themeMidnight => 'Midnight';

  @override
  String get themeMidnightSubtitle => 'Azul profundo';

  @override
  String get themeSepia => 'Sepia';

  @override
  String get themeSepiaSubtitle => 'Tonos cálidos de papel';

  @override
  String get languageSection => 'IDIOMA';

  @override
  String get languageSystem => 'Automático (sistema)';

  @override
  String get languageSystemSubtitle =>
      'Usa el idioma del dispositivo (pt, en o es)';

  @override
  String get languagePt => 'Portugués (Brasil)';

  @override
  String get languageEn => 'English';

  @override
  String get languageEs => 'Español';

  @override
  String get activeLabel => 'Activo';

  @override
  String get settingsMyAccount => 'MI CUENTA';

  @override
  String get settingsProfilePhoto => 'Foto de perfil';

  @override
  String get settingsProfilePhotoSubtitle => 'Galería o eliminar';

  @override
  String get avatarChooseFromGallery => 'Elegir de la galería';

  @override
  String get avatarRemovePhoto => 'Eliminar foto';

  @override
  String get avatarPhotoRemovedSnack => 'Foto eliminada';

  @override
  String get avatarPhotoUpdatedSnack => 'Foto de perfil actualizada';

  @override
  String avatarUploadError(String error) {
    return 'No se pudo subir la foto: $error';
  }

  @override
  String settingsNotifPermissionStatus(String status) {
    return 'Estado: $status';
  }

  @override
  String get qrFooterBrand => 'openwhen.app';

  @override
  String get qrShareWhatsAppLabel => 'WhatsApp';

  @override
  String get settingsEditProfile => 'Editar perfil';

  @override
  String get settingsChangePassword => 'Cambiar contraseña';

  @override
  String get settingsPrivacySection => 'PRIVACIDAD Y SEGURIDAD';

  @override
  String get settingsPrivateAccount => 'Cuenta privada';

  @override
  String get settingsPrivateAccountOn => 'Tus cartas no aparecen en el feed';

  @override
  String get settingsPrivateAccountOff =>
      'Tus cartas pueden aparecer en el feed';

  @override
  String get settingsBlockedUsers => 'Usuarios bloqueados';

  @override
  String get settingsWhoCanSend => 'Quién puede enviarme cartas';

  @override
  String get settingsWhoCanSendValue => 'Todos';

  @override
  String get settingsNotificationsSection => 'NOTIFICACIONES';

  @override
  String get settingsNotifSystemAlert => 'Permisos de alerta (sistema)';

  @override
  String get settingsNotifSystemAlertSubtitle =>
      'Necesario para recibir push en el celular';

  @override
  String get settingsNotifUpdated => 'Permisos de notificación actualizados.';

  @override
  String get settingsNotifLikes => 'Me gusta';

  @override
  String get settingsNotifLikesSubtitle =>
      'Cuando alguien le dé me gusta a tu carta';

  @override
  String get settingsNotifComments => 'Comentarios';

  @override
  String get settingsNotifCommentsSubtitle => 'Cuando alguien comente tu carta';

  @override
  String get settingsNotifFollowers => 'Nuevos seguidores';

  @override
  String get settingsNotifFollowersSubtitle =>
      'Cuando alguien empiece a seguirte';

  @override
  String get settingsNotifLetterUnlocked => 'Carta desbloqueada';

  @override
  String get settingsNotifLetterUnlockedSubtitle =>
      'Cuando una carta esté lista para abrir';

  @override
  String get settingsDataSection => 'DATOS Y PRIVACIDAD';

  @override
  String get settingsExportLetters => 'Exportar mis cartas';

  @override
  String get settingsExportLettersSubtitle =>
      'PDF o zip con todas las cartas abiertas';

  @override
  String get settingsDeleteAccount => 'Eliminar cuenta';

  @override
  String get settingsDeleteAccountSubtitle => 'Esta acción es irreversible';

  @override
  String get settingsLegalSection => 'LEGAL Y SOPORTE';

  @override
  String get settingsTerms => 'Términos de uso';

  @override
  String get settingsPrivacy => 'Política de privacidad';

  @override
  String get settingsHelp => 'Ayuda y soporte';

  @override
  String get settingsAbout => 'Acerca de OpenWhen';

  @override
  String get settingsAboutVersion => 'Versión 1.0.0';

  @override
  String get settingsLogout => 'Cerrar sesión';

  @override
  String get settingsEditProfileSheetTitle => 'Editar perfil';

  @override
  String get settingsEditProfileFieldName => 'Nombre';

  @override
  String get settingsEditProfileFieldUsername => '@Username';

  @override
  String get settingsEditProfileFieldBio => 'Bio';

  @override
  String get settingsChangePasswordTitle => 'Cambiar contraseña';

  @override
  String get settingsChangePasswordBody =>
      'Te enviaremos un enlace a tu correo.';

  @override
  String get settingsChangePasswordButton =>
      'Enviar correo de restablecimiento';

  @override
  String settingsChangePasswordSent(String email) {
    return 'Correo enviado a $email';
  }

  @override
  String get settingsExportTitle => 'Exportar cartas';

  @override
  String get settingsExportBody =>
      'Tus cartas abiertas se exportarán en formato PDF. Esto puede tardar unos minutos.';

  @override
  String get settingsExportButton => 'Exportar como PDF';

  @override
  String get settingsExportSnack => '¡Exportación en camino! 📦';

  @override
  String get settingsDeleteTitle => 'Eliminar cuenta';

  @override
  String get settingsDeleteBody =>
      'Esta acción es irreversible. Todas tus cartas, seguidores y datos se eliminarán permanentemente.';

  @override
  String get settingsDeleteConfirm => 'Confirmar eliminación';

  @override
  String get settingsBlockedTitle => 'Usuarios bloqueados';

  @override
  String get settingsBlockedEmpty => 'Ningún usuario bloqueado.';

  @override
  String get settingsBlockedUnblock => 'Desbloquear';

  @override
  String get legalTitleTerms => 'Términos de Uso';

  @override
  String get legalTitlePrivacy => 'Política de Privacidad';

  @override
  String get legalTitleAbout => 'Acerca de OpenWhen';

  @override
  String get legalTitleHelp => 'Ayuda y Soporte';

  @override
  String legalLastUpdate(String date) {
    return 'Última actualización: $date';
  }

  @override
  String get aboutTagline => 'Escribe hoy. Siente mañana.';

  @override
  String get aboutVersion => 'Versión 1.0.0 — Build 2026.03.22';

  @override
  String get aboutWhatIsTitle => 'Qué es OpenWhen';

  @override
  String get aboutWhatIsBody =>
      'OpenWhen es una plataforma digital de comunicación temporal y red social emocional. Permite crear cartas digitales con fecha futura de apertura, combinando el valor sentimental de una carta física con la viralidad de una red social moderna.';

  @override
  String get aboutSecurityTitle => 'Seguridad y Privacidad';

  @override
  String get aboutSecurityBody =>
      'Desarrollado en conformidad con la LGPD (Ley nº 13.709/2018) y el Marco Civil de Internet (Ley nº 12.965/2014). Tus datos están protegidos con cifrado de extremo a extremo y almacenados en la infraestructura de Google Cloud Platform.';

  @override
  String get aboutComplianceTitle => 'Cumplimiento Legal';

  @override
  String get aboutComplianceBody =>
      'OpenWhen opera en total cumplimiento con la legislación brasileña vigente, incluyendo LGPD, Marco Civil de Internet, Código de Defensa del Consumidor (Ley nº 8.078/1990) y demás normas aplicables al sector de tecnología.';

  @override
  String get aboutCompanyTitle => 'Empresa';

  @override
  String get aboutCompanyBody =>
      'OpenWhen Tecnologia Ltda. — Empresa brasileña, con sede en Brasil. Fuero de elección: jurisdicción de São Paulo/SP.';

  @override
  String get aboutContacts => 'Contactos';

  @override
  String get aboutContactSupport => 'Soporte general';

  @override
  String get aboutContactPrivacy => 'Privacidad y LGPD';

  @override
  String get aboutContactLegal => 'Jurídico';

  @override
  String get aboutContactDpo => 'DPO';

  @override
  String get aboutCopyright =>
      '© 2026 OpenWhen Tecnologia Ltda. Todos los derechos reservados.';

  @override
  String get helpCenter => 'Centro de Ayuda';

  @override
  String get helpCenterSubtitle =>
      'Encuentra respuestas a las preguntas más frecuentes.';

  @override
  String get helpFaqSection => 'PREGUNTAS FRECUENTES';

  @override
  String get helpFaq1Q => '¿Cómo enviar una carta?';

  @override
  String get helpFaq1A =>
      'Toca el botón ✏️ en la pantalla principal. Completa el título, selecciona el estado emocional, escribe tu mensaje, ingresa el correo del destinatario y define la fecha de apertura. La carta quedará bloqueada hasta la fecha elegida.';

  @override
  String get helpFaq2Q => '¿El destinatario necesita tener cuenta en OpenWhen?';

  @override
  String get helpFaq2A =>
      'Sí. Actualmente el destinatario necesita tener una cuenta registrada en OpenWhen para recibir cartas. El envío a correos externos estará disponible próximamente.';

  @override
  String get helpFaq3Q => '¿Puedo editar una carta después de enviarla?';

  @override
  String get helpFaq3A =>
      'No. Las cartas quedan selladas inmediatamente después del envío para preservar la autenticidad e integridad del mensaje, de manera análoga a las cartas físicas. Esta es una decisión de producto intencional.';

  @override
  String get helpFaq4Q => '¿Cómo funciona el Feed Público?';

  @override
  String get helpFaq4A =>
      'Al abrir una carta, puedes optar por publicarla en el Feed Público. Esta autorización es individual por carta. Las cartas privadas jamás se muestran públicamente sin tu autorización expresa.';

  @override
  String get helpFaq5Q => 'Recibí una carta de un desconocido. ¿Qué hago?';

  @override
  String get helpFaq5A =>
      'Las cartas de personas que no sigues aparecen en \"Solicitudes de Carta\" en el Cofre. Puedes aceptar, rechazar o bloquear al remitente sin que este conozca tu decisión.';

  @override
  String get helpFaq6Q => '¿Cómo exportar mis cartas?';

  @override
  String get helpFaq6A =>
      'Ve a Configuración > Datos y Privacidad > Exportar mis cartas. Recibirás un archivo con todas tus cartas abiertas, conforme al derecho de portabilidad garantizado por el art. 18, inciso V, de la LGPD.';

  @override
  String get helpFaq7Q => '¿Cómo eliminar mi cuenta?';

  @override
  String get helpFaq7A =>
      'Ve a Configuración > Datos y Privacidad > Eliminar cuenta. La eliminación es irreversible y todos tus datos serán eliminados permanentemente en un plazo de 30 días, conforme al art. 18, inciso VI, de la LGPD.';

  @override
  String get helpFaq8Q => 'Encontré un contenido ofensivo. ¿Cómo lo denuncio?';

  @override
  String get helpFaq8A =>
      'Toca los tres puntos junto a cualquier carta o comentario y selecciona \"Denunciar\". Nuestro equipo analizará el contenido en un plazo de 24 horas. Las denuncias graves se tratan con prioridad.';

  @override
  String get reportMenuLabel => 'Denunciar';

  @override
  String get reportSheetTitle => 'Denunciar contenido';

  @override
  String get reportSheetSubtitle =>
      'Indica qué falla. Los detalles opcionales ayudan a revisar más rápido.';

  @override
  String get reportReasonSpam => 'Spam o engañoso';

  @override
  String get reportReasonHarassment => 'Acoso o intimidación';

  @override
  String get reportReasonHate => 'Discurso de odio';

  @override
  String get reportReasonIllegal => 'Contenido ilegal';

  @override
  String get reportReasonOther => 'Otro';

  @override
  String get reportDetailLabel => 'Detalles adicionales (opcional)';

  @override
  String get reportDetailHint => 'Contexto que ayuda a la moderación…';

  @override
  String get reportSubmit => 'Enviar denuncia';

  @override
  String get reportSuccess => 'Gracias — recibimos tu denuncia.';

  @override
  String get adminModerationTitle => 'Moderación';

  @override
  String get adminModerationReportsTab => 'Denuncias';

  @override
  String get adminModerationFeedbackTab => 'Comentarios';

  @override
  String get adminModerationEmpty => 'Nada pendiente.';

  @override
  String get adminModerationResolve => 'Descartar';

  @override
  String get adminModerationConfirm => 'Marcar como revisado';

  @override
  String get adminModerationLoadError =>
      'No se pudo cargar la cola de moderación.';

  @override
  String get adminEntrySettings => 'Moderación (admin)';

  @override
  String get helpNotFoundTitle => '¿No encontraste lo que buscabas?';

  @override
  String get helpNotFoundBody =>
      'Nuestro equipo está disponible para ayudarte:';

  @override
  String get helpResponseTime => 'Tiempo de respuesta';

  @override
  String get helpResponseTimeValue => 'hasta 2 días hábiles';

  @override
  String get feedbackTooltip => 'Enviar comentarios';

  @override
  String get feedbackSemanticsLabel =>
      'Enviar comentarios o solicitud de función';

  @override
  String get feedbackSheetTitle => 'Comentarios';

  @override
  String get feedbackCategoryLabel => 'Categoría';

  @override
  String get feedbackTypeFeature => 'Función';

  @override
  String get feedbackTypeRecommendation => 'Idea';

  @override
  String get feedbackTypeGeneral => 'General';

  @override
  String get feedbackMessageHint => '¿Qué te gustaría compartir?';

  @override
  String feedbackCharCount(int current, int max) {
    return '$current / $max';
  }

  @override
  String get feedbackSubmit => 'Enviar';

  @override
  String get feedbackEmptyError => 'Escribe un mensaje.';

  @override
  String get feedbackTooLongError => 'El mensaje es demasiado largo.';

  @override
  String get feedbackSuccess => 'Gracias — recibimos tus comentarios.';

  @override
  String get feedbackSignedOutHint =>
      'No has iniciado sesión. Abriremos tu correo para que envíes esto a nuestro equipo.';

  @override
  String get feedbackCouldNotOpenEmail =>
      'No se pudo abrir el correo. Contacta suporte@openwhen.app.';

  @override
  String feedbackEmailBodyPrefix(String category) {
    return 'Categoría: $category';
  }

  @override
  String get subscriptionSectionTitle => 'Plan y suscripción';

  @override
  String get subscriptionScreenTitle => 'Planes';

  @override
  String get subscriptionPlanAmanhaName => 'Amanhã';

  @override
  String get subscriptionPlanBrisaName => 'Brisa';

  @override
  String get subscriptionPlanHorizonteName => 'Horizonte';

  @override
  String get subscriptionPlanAmanhaPitch =>
      'Lo esencial para escribir hoy y sentirlo en el momento adecuado.';

  @override
  String get subscriptionPlanBrisaPitch =>
      'Comparte y expresa más: cofre y redes con más profundidad.';

  @override
  String get subscriptionPlanHorizontePitch =>
      'Archivo, familia e inteligencia con transparencia.';

  @override
  String get subscriptionCurrentPlanLabel => 'Tu plan actual';

  @override
  String get subscriptionSubscribeBrisa => 'Suscribirse a Brisa';

  @override
  String get subscriptionSubscribeHorizonte => 'Suscribirse a Horizonte';

  @override
  String get subscriptionManageBilling => 'Gestionar suscripción y pago';

  @override
  String get subscriptionCheckoutError =>
      'No se pudo abrir el pago. Inténtalo de nuevo.';

  @override
  String get subscriptionPortalError =>
      'No se pudo abrir el portal de facturación.';

  @override
  String get subscriptionUpgradeDialogTitle => 'Plan necesario';

  @override
  String subscriptionUpgradeDialogBody(String planName) {
    return 'Esta función requiere el plan $planName o superior.';
  }

  @override
  String get subscriptionUpgradeDialogViewPlans => 'Ver planes';

  @override
  String get subscriptionBillingDisabledBanner =>
      'El pago de suscripción aún no está activado. Puedes seguir usando la app en el plano Amanhã. Activa el billing cuando Stripe esté listo.';

  @override
  String get subscriptionBillingDisabledSnack =>
      'Los pagos aún no están activos. Usa BILLING_ENABLED=true cuando Stripe esté configurado.';

  @override
  String get termsIntro =>
      'Estos Términos de Uso (\"Términos\") regulan el acceso y la utilización de la aplicación OpenWhen (\"Plataforma\"), desarrollada y operada por OpenWhen Tecnologia Ltda. (\"Empresa\"), inscrita en el CNPJ bajo el nº [XX.XXX.XXX/0001-XX], con sede en Brasil. La utilización de la Plataforma implica la aceptación integral e irrestricta de estos Términos, en los términos del art. 8º de la Ley nº 12.965/2014 (Marco Civil de Internet) y la Ley nº 13.709/2018 (Ley General de Protección de Datos — LGPD).';

  @override
  String get termsSection1Title => '1. DEL OBJETO Y NATURALEZA DEL SERVICIO';

  @override
  String get termsSection1Body =>
      'OpenWhen es una plataforma digital de comunicación temporal que permite a los usuarios crear, enviar, recibir y almacenar mensajes electrónicos (\"Cartas\") programados para apertura en fecha futura determinada por el remitente. El servicio tiene naturaleza de intermediación digital de comunicación privada y, cuando sea autorizado por el usuario, de publicación en entorno de red social (\"Feed Público\"). La Empresa actúa como proveedora de aplicación, en los términos del art. 5º, inciso VII, del Marco Civil de Internet.';

  @override
  String get termsSection2Title => '2. DE LOS REQUISITOS PARA LA UTILIZACIÓN';

  @override
  String get termsSection2Body =>
      'Para utilizar la Plataforma, el usuario deberá: (i) tener capacidad civil plena, en los términos del art. 3º del Código Civil Brasileño (Ley nº 10.406/2002), o ser asistido por un responsable legal cuando sea menor de 16 años; (ii) proporcionar datos verídicos en el registro, bajo pena de cancelación inmediata de la cuenta, en los términos del art. 7º, inciso VI, del Marco Civil de Internet; (iii) mantener la confidencialidad de sus credenciales de acceso, siendo responsable de todas las actividades realizadas en su cuenta.';

  @override
  String get termsSection3Title =>
      '3. DE LAS OBLIGACIONES Y RESPONSABILIDADES DEL USUARIO';

  @override
  String get termsSection3Body =>
      'El usuario se compromete a utilizar la Plataforma en conformidad con la legislación vigente, especialmente: (i) la Ley nº 12.965/2014 (Marco Civil de Internet); (ii) la Ley nº 13.709/2018 (LGPD); (iii) el Código Penal Brasileño en lo que respecta a delitos contra el honor (arts. 138 a 140); (iv) la Ley nº 7.716/1989 (Ley de Delitos de Prejuicio); y (v) el Estatuto del Niño y del Adolescente (ECA — Ley nº 8.069/1990). Queda expresamente prohibido al usuario publicar contenido que: (a) sea difamatorio, calumnioso o injurioso; (b) incite a la violencia, el odio o la discriminación de cualquier tipo; (c) viole derechos de propiedad intelectual de terceros; (d) constituya acoso, ciberacoso o persecución; (e) involucre pornografía infantil o contenido sexual que involucre a menores de edad.';

  @override
  String get termsSection4Title =>
      '4. DE LA RESPONSABILIDAD CIVIL DE LA EMPRESA';

  @override
  String get termsSection4Body =>
      'La Empresa, en calidad de proveedora de aplicación, no se responsabiliza por el contenido generado por los usuarios (\"UGC — User Generated Content\"), en los términos del art. 19 del Marco Civil de Internet. La responsabilidad civil de la Empresa solo se configurará mediante incumplimiento de orden judicial específica que determine la remoción de contenido. La Empresa adopta mecanismos de moderación y denuncia, sin que ello implique asunción de responsabilidad editorial sobre el contenido de los usuarios.';

  @override
  String get termsSection5Title => '5. DE LA PROPIEDAD INTELECTUAL';

  @override
  String get termsSection5Body =>
      'El usuario es y permanece titular de los derechos de autor sobre el contenido que crea en la Plataforma, en los términos de la Ley nº 9.610/1998 (Ley de Derechos de Autor). Al publicar contenido en el Feed Público, el usuario concede a la Empresa una licencia no exclusiva, irrevocable, gratuita y mundial para reproducir, distribuir y exhibir dicho contenido exclusivamente en el ámbito de la Plataforma, pudiendo revocar dicha licencia mediante la eliminación del contenido o el cierre de la cuenta. La marca, logotipo, diseño y código fuente de OpenWhen son de titularidad exclusiva de la Empresa y están protegidos por la Ley nº 9.279/1996 (Ley de Propiedad Industrial).';

  @override
  String get termsSection6Title => '6. DE LA VIGENCIA Y RESCISIÓN';

  @override
  String get termsSection6Body =>
      'El presente contrato tendrá vigencia por plazo indeterminado a partir del registro del usuario. El usuario podrá rescindir el contrato en cualquier momento mediante la eliminación de su cuenta en la configuración de la Plataforma, en los términos del art. 7º, inciso IX, del Marco Civil de Internet. La Empresa se reserva el derecho de suspender o cancelar cuentas que violen estos Términos, sin perjuicio de las demás medidas legales correspondientes.';

  @override
  String get termsSection7Title => '7. DE LAS DISPOSICIONES GENERALES';

  @override
  String get termsSection7Body =>
      'Estos Términos se rigen por las leyes de la República Federativa del Brasil. Se elige el fuero de la jurisdicción de São Paulo/SP para dirimir cualquier controversia derivada de este instrumento, con renuncia expresa a cualquier otro fuero, por más privilegiado que sea. La nulidad de cualquier cláusula no afecta la validez de las demás. Las dudas y notificaciones deben dirigirse a: juridico@openwhen.app. Última actualización: 22 de marzo de 2026.';

  @override
  String get privacyIntro =>
      'Esta Política de Privacidad (\"Política\") describe cómo OpenWhen Tecnologia Ltda. (\"Empresa\", \"nosotros\") recopila, trata, almacena y comparte los datos personales de los usuarios de la Plataforma OpenWhen, en conformidad con la Ley nº 13.709/2018 (Ley General de Protección de Datos — LGPD), el Reglamento General de Protección de Datos de la Unión Europea (GDPR — Reglamento UE 2016/679), la Ley nº 12.965/2014 (Marco Civil de Internet) y demás normas aplicables. La Empresa actúa como Controladora de Datos, en los términos del art. 5º, inciso VI, de la LGPD.';

  @override
  String get privacySection1Title => '1. DE LOS DATOS PERSONALES RECOPILADOS';

  @override
  String get privacySection1Body =>
      'La Empresa recopila las siguientes categorías de datos personales: (i) Datos de registro: nombre completo, dirección de correo electrónico, nombre de usuario y foto de perfil; (ii) Datos de uso: interacciones en la Plataforma, cartas creadas, enviadas y recibidas, me gusta y comentarios; (iii) Datos técnicos: dirección IP, identificador del dispositivo, sistema operativo y registros de acceso, en los términos del art. 15 del Marco Civil de Internet; (iv) Datos de ubicación: país de origen, recopilado de forma no precisa y solo para personalización del servicio. No recopilamos datos personales sensibles, según la definición del art. 5º, inciso II, de la LGPD, salvo mediante consentimiento expreso.';

  @override
  String get privacySection2Title =>
      '2. DE LAS BASES LEGALES PARA EL TRATAMIENTO';

  @override
  String get privacySection2Body =>
      'El tratamiento de los datos personales de los usuarios se fundamenta en las siguientes hipótesis legales previstas en el art. 7º de la LGPD: (i) Consentimiento del titular, en los términos del art. 7º, inciso I, manifestado en el momento del registro; (ii) Ejecución de contrato, en los términos del art. 7º, inciso V, para la prestación de los servicios contratados; (iii) Interés legítimo de la Empresa, en los términos del art. 7º, inciso IX, para la mejora de la Plataforma, prevención de fraudes y seguridad del servicio; (iv) Cumplimiento de obligación legal o regulatoria, en los términos del art. 7º, inciso II.';

  @override
  String get privacySection3Title => '3. DE LA FINALIDAD DEL TRATAMIENTO';

  @override
  String get privacySection3Body =>
      'Los datos personales recopilados se tratan para las siguientes finalidades: (i) Prestación de los servicios de la Plataforma; (ii) Personalización de la experiencia del usuario; (iii) Envío de notificaciones relacionadas con el servicio; (iv) Mejora continua de la Plataforma; (v) Prevención de fraudes y garantía de seguridad; (vi) Cumplimiento de obligaciones legales y regulatorias; (vii) Ejercicio regular de derechos en procesos judiciales, administrativos o arbitrales. Los datos no se utilizan para publicidad de terceros.';

  @override
  String get privacySection4Title => '4. DEL INTERCAMBIO DE DATOS';

  @override
  String get privacySection4Body =>
      'La Empresa no vende, alquila ni cede datos personales a terceros con fines comerciales. El intercambio de datos ocurre exclusivamente en las siguientes hipótesis: (i) Con prestadores de servicios esenciales para la operación de la Plataforma (Firebase/Google Cloud), en condición de Operadores de Datos, mediante contrato que garantice un nivel adecuado de protección; (ii) Con autoridades públicas, mediante orden judicial o solicitud legal fundamentada; (iii) Con adquirente en caso de fusión, adquisición o reestructuración societaria, garantizando la continuidad de esta Política.';

  @override
  String get privacySection5Title =>
      '5. DE LOS DERECHOS DEL TITULAR (LGPD — Art. 18)';

  @override
  String get privacySection5Body =>
      'En los términos del art. 18 de la LGPD, el usuario titular de los datos tiene derecho a: (i) Confirmación de la existencia de tratamiento; (ii) Acceso a los datos; (iii) Corrección de datos incompletos, inexactos o desactualizados; (iv) Anonimización, bloqueo o eliminación de datos innecesarios; (v) Portabilidad de los datos a otro proveedor, mediante solicitud expresa; (vi) Eliminación de los datos tratados con base en el consentimiento; (vii) Información sobre intercambio con terceros; (viii) Revocación del consentimiento. Para ejercer sus derechos, acceda a Configuración > Datos y Privacidad o contacte a: privacidade@openwhen.app. El plazo de respuesta es de hasta 15 días hábiles.';

  @override
  String get privacySection6Title =>
      '6. DE LA SEGURIDAD Y RETENCIÓN DE LOS DATOS';

  @override
  String get privacySection6Body =>
      'La Empresa adopta medidas técnicas y organizativas adecuadas para proteger los datos personales contra acceso no autorizado, destrucción, pérdida o alteración, incluyendo: cifrado en tránsito (TLS 1.3) y en reposo, control de acceso basado en roles y monitoreo continuo de seguridad. Los datos se retienen durante el período necesario para las finalidades del tratamiento y se eliminan al término de la relación contractual, salvo obligación legal de retención. En caso de incidente de seguridad, el titular será notificado en los términos del art. 48 de la LGPD.';

  @override
  String get privacySection7Title => '7. DE LAS TRANSFERENCIAS INTERNACIONALES';

  @override
  String get privacySection7Body =>
      'Los datos personales de los usuarios pueden ser transferidos a servidores ubicados fuera de Brasil (Google Cloud Platform), en conformidad con el art. 33 de la LGPD, garantizando un nivel de protección adecuado mediante cláusulas contractuales estándar aprobadas por la Autoridad Nacional de Protección de Datos (ANPD).';

  @override
  String get privacySection8Title =>
      '8. DEL ENCARGADO DE PROTECCIÓN DE DATOS (DPO)';

  @override
  String get privacySection8Body =>
      'En los términos del art. 41 de la LGPD, el Encargado de Protección de Datos (DPO) de la Empresa puede ser contactado en: dpo@openwhen.app. Última actualización: 22 de marzo de 2026.';

  @override
  String get letterPrivacyPublicLabel => 'Pública';

  @override
  String get letterPrivacyPublicSubtitle => 'Aparece en el feed para todos';

  @override
  String get letterPrivacyPrivateLabel => 'Privada';

  @override
  String get letterPrivacyPrivateSubtitle => 'Solo tú puedes verla';

  @override
  String get letterPrivacyActionMakePublic => 'Hacer pública';

  @override
  String get letterPrivacyActionMakePrivate => 'Hacer privada';

  @override
  String get letterDetailSentView => 'TU CARTA ENVIADA';
}
