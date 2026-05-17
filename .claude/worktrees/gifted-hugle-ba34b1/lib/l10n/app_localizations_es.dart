// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Whenote';

  @override
  String get splashTagline => 'Cartas para el futuro';

  @override
  String errorGeneric(String error) {
    return 'Error: $error';
  }

  @override
  String get snackFillAllFields => '¡Completa todos los campos!';

  @override
  String get authErrorInvalidCredentials => 'Correo o contraseña incorrectos.';

  @override
  String get authErrorInvalidEmail => 'Correo electrónico inválido.';

  @override
  String get authErrorWeakPassword =>
      'La contraseña debe tener al menos 6 caracteres.';

  @override
  String get authErrorEmailAlreadyInUse => 'Este correo ya está en uso.';

  @override
  String get authErrorTooManyRequests =>
      'Demasiados intentos. Espera unos minutos o restablece tu contraseña.';

  @override
  String get authErrorNetwork =>
      'Sin conexión. Comprueba tu internet e intenta de nuevo.';

  @override
  String get authErrorUserDisabled => 'Esta cuenta ha sido deshabilitada.';

  @override
  String get authErrorGeneric =>
      'No se pudo iniciar sesión. Inténtalo de nuevo.';

  @override
  String get loginForgotPasswordInline => 'Olvidé mi contraseña';

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
      'Activa los servicios de ubicación y permite que Whenote acceda a tu ubicación para abrir esto.';

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
  String get firstActionTitle => '¿Qué te gustaría\nhacer primero?';

  @override
  String get firstActionSubtitle =>
      'Elige una opción para empezar — siempre puedes hacer la otra después.';

  @override
  String get firstActionLetterTitle => 'Enviar una carta';

  @override
  String get firstActionLetterSubtitle => 'Para alguien especial';

  @override
  String get firstActionCapsuleTitle => 'Crear una cápsula del tiempo';

  @override
  String get firstActionCapsuleSubtitle => 'Para tu yo del futuro';

  @override
  String get firstActionSkip => 'Explorar primero';

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
  String get forgotPasswordTitle => 'Recuperar contraseña';

  @override
  String get forgotPasswordBody =>
      'Ingresa el correo electrónico asociado a tu cuenta y te enviaremos un enlace para restablecer tu contraseña.';

  @override
  String get forgotPasswordHint => 'tu correo electrónico';

  @override
  String get forgotPasswordButton => 'Enviar enlace de recuperación';

  @override
  String forgotPasswordSent(String email) {
    return 'Enlace de recuperación enviado a $email';
  }

  @override
  String get forgotPasswordErrorNoUser =>
      'No se encontró una cuenta con este correo.';

  @override
  String get forgotPasswordErrorInvalidEmail =>
      'Por favor, ingresa un correo electrónico válido.';

  @override
  String get forgotPasswordErrorGeneric =>
      'Algo salió mal. Inténtalo de nuevo.';

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
      '¡Cuenta creada! Revisa tu correo y luego inicia sesión para continuar.';

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
  String get feedLayerExplore => 'Explorar';

  @override
  String get feedLayerHighlights => 'Destacados';

  @override
  String get feedLayerFollowing => 'Siguiendo';

  @override
  String get feedFiltersButton => 'Feed';

  @override
  String get feedFiltersSheetTitle => 'Elegir feed';

  @override
  String get feedFiltersButtonSemantic => 'Abrir filtros del tipo de feed';

  @override
  String get feedCustomizePinnedFilters => 'Fijar filtros rápidos…';

  @override
  String get feedCustomizePinnedFiltersHint =>
      'Elige hasta 3 chips de humor en la barra';

  @override
  String get feedPinFiltersSheetTitle => 'Fijar filtros rápidos';

  @override
  String get feedPinFiltersMaxNote =>
      'Hasta 3 filtros. El orden sigue tu selección.';

  @override
  String get feedPinFiltersSave => 'Guardar';

  @override
  String get feedFollowingEmptyTitle => 'No hay cartas de quien sigues';

  @override
  String get feedFollowingEmptySubtitle =>
      'Sigue perfiles para ver sus cartas públicas aquí.';

  @override
  String get feedFollowingSignedOutTitle => 'Inicia sesión para ver este feed';

  @override
  String get feedFollowingSignedOutSubtitle =>
      'La pestaña Siguiendo muestra cartas públicas de quien sigues.';

  @override
  String get feedLoadError => 'No se pudo cargar el feed. Intenta de nuevo.';

  @override
  String get feedLoadMore => 'Cargar más';

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
      'Tu mensaje contiene palabras inadecuadas. Whenote es un espacio de amor y respeto. 💌';

  @override
  String get commentsModerationAiBlocked =>
      'Este comentario no pasó la moderación automática. Reformula con respeto.';

  @override
  String get commentsModerationUnavailable =>
      'La moderación automática no está disponible ahora. Inténtalo de nuevo en unos instantes.';

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
  String get vaultEmptyReceivedCta =>
      'Comparte tu perfil para que puedan enviarte cartas.';

  @override
  String get vaultEmptyReceivedCtaButton => 'Abrir perfil';

  @override
  String get vaultLetterChipPrivate => '🔒 Privada · Hacer pública';

  @override
  String get vaultLetterChipPublic => '🌍 Pública · Hacer privada';

  @override
  String get vaultLetterSheetMakePublic => 'Hacer pública';

  @override
  String get vaultLetterSheetMakePrivate => 'Hacer privada';

  @override
  String get vaultLetterSheetDelete => 'Quitar de la caja';

  @override
  String get vaultLetterSheetFavoriteSoon => 'Favorito (pronto)';

  @override
  String get vaultLetterDeleteTitle => '¿Quitar carta?';

  @override
  String get vaultLetterDeleteMessage =>
      'Se elimina de tu caja y del feed público si estaba compartida.';

  @override
  String get vaultMenuHint =>
      'Consejo: toca ⋯ en una tarjeta para privacidad o eliminar.';

  @override
  String get vaultMenuHintGotIt => 'Entendido';

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
  String get writeLetterPrivacyNote =>
      'Las cartas enviadas son privadas. Solo quien recibe puede elegir compartir en el feed público al abrirla.';

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
  String get writeLetterGenerateLink => 'Generar enlace compartible';

  @override
  String get writeLetterShareViaLinkLabel => 'Compartir por enlace';

  @override
  String get writeLetterShareViaLinkHint =>
      'Se generará un enlace después de sellar';

  @override
  String get writeLetterShareLinkTitle => '¡Tu enlace está listo!';

  @override
  String get writeLetterShareLinkHint =>
      'Comparte este enlace con el destinatario por WhatsApp, SMS o cualquier canal.';

  @override
  String get writeLetterShareLinkCopy => 'Copiar';

  @override
  String get writeLetterShareLinkShare => 'Compartir';

  @override
  String get writeLetterShareLinkCopied => '¡Enlace copiado!';

  @override
  String get writeLetterShareLinkSubject =>
      'Alguien te envió una carta en Whenote';

  @override
  String get shareLinkPending =>
      'Enlace compartido — esperando que alguien reclame esta carta';

  @override
  String get shareLinkClaimed =>
      '¡Carta reclamada! El destinatario ha recibido tu carta';

  @override
  String get shareLinkRevoked => 'El enlace de compartir fue revocado';

  @override
  String get writeLetterPrivateTitle => 'Carta privada';

  @override
  String get writeLetterPrivateHint =>
      'Solo tú y el destinatario tendrán acceso';

  @override
  String get writeLetterPublicTitle => 'Permitir publicación en el feed';

  @override
  String get writeLetterPublicHint =>
      'El destinatario podrá compartir en el feed después de abrir';

  @override
  String get writeLetterSnackEmailInvalid =>
      'Ingresa un email válido (ej: nombre@ejemplo.com)';

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
  String get writeLetterSendErrorEmailLookup =>
      'No se pudo verificar el email del destinatario. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get writeLetterSendErrorLoadProfile =>
      'No se pudo cargar tu perfil. Inténtalo de nuevo.';

  @override
  String get writeLetterSendErrorFriendshipCheck =>
      'No se pudo verificar la amistad. Inténtalo de nuevo.';

  @override
  String get writeLetterSendErrorSave =>
      'No se pudo guardar la carta. Inténtalo de nuevo.';

  @override
  String get writeLetterSendErrorUnexpected =>
      'Ocurrió un error al enviar. Inténtalo de nuevo.';

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
  String get letterDetailShareSubtitle =>
      'Instagram Stories o hoja de compartir';

  @override
  String get storyShareFallbackSnack =>
      'Se abrió la hoja de compartir — elige Instagram u otra app.';

  @override
  String get storyShareSheetTitle => 'Compartir cápsula';

  @override
  String get storyShareInstagramOption => 'Instagram Stories';

  @override
  String get storyShareTextOption => 'Texto (preguntas y respuestas)';

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
  String get letterEmotionalPrimerTitle => 'Esta carta puede ser emotiva.';

  @override
  String get letterEmotionalPrimerBody => 'Ábrela cuando te sientas listo.';

  @override
  String get letterEmotionalPrimerOpenNow => 'Abrir ahora';

  @override
  String get letterEmotionalPrimerViewLater => 'Ver después';

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
    return '💌 ¡Una carta especial te espera en Whenote!\n\n\"$title\"\n\nEscanea el código QR o accede a: $link';
  }

  @override
  String get qrShareSubject => 'Una carta especial te espera 💌';

  @override
  String qrShareLinkOnly(String title, String link) {
    return '💌 ¡Una carta especial te espera en Whenote!\n\n\"$title\"\n\nAccede a: $link';
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
  String get createCapsuleAudienceTitle => '¿Para quién es esta cápsula?';

  @override
  String get createCapsuleAudiencePersonal => 'Solo para mí';

  @override
  String get createCapsuleAudienceCollective => 'Colectiva';

  @override
  String get createCapsuleCollectiveHint =>
      'Invita a quien abrirá esta cápsula contigo el mismo día. Solo tú escribes el contenido.';

  @override
  String get createCapsuleInviteSearchHint => 'Busca por nombre o @usuario';

  @override
  String get createCapsuleCollectiveNeedInvite =>
      'Añade al menos una persona para una cápsula colectiva.';

  @override
  String createCapsuleMaxParticipants(int max) {
    return 'Una cápsula puede incluir como máximo $max personas (incluido tú).';
  }

  @override
  String get vaultCapsuleCollectiveBadge => 'Colectiva';

  @override
  String get capsuleDetailParticipantsHeading => 'Junto a';

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
  String get capsuleDetailShareSubtitle =>
      'Instagram Stories o hoja de compartir';

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
  String get profileBadgesTitle => 'LOGROS';

  @override
  String get badgeFirstLetterSentTitle => 'Primera carta';

  @override
  String get badgeFirstLetterSentDesc => 'Enviaste tu primera carta.';

  @override
  String get badgeFirstLetterOpenedTitle => 'Primera apertura';

  @override
  String get badgeFirstLetterOpenedDesc => 'Abriste tu primera carta.';

  @override
  String get badgeFirstPublicTitle => 'Primera en el feed';

  @override
  String get badgeFirstPublicDesc =>
      'Compartiste una carta en el feed público.';

  @override
  String get badgeLettersSentFiveTitle => '5 cartas';

  @override
  String get badgeLettersSentFiveDesc => 'Enviaste 5 cartas.';

  @override
  String get badgeLettersSentTenTitle => '10 cartas';

  @override
  String get badgeLettersSentTenDesc => 'Enviaste 10 cartas.';

  @override
  String get badgeVoiceLetterTitle => 'Voz';

  @override
  String get badgeVoiceLetterDesc => 'Enviaste una carta con audio.';

  @override
  String get badgeHintFirstLetterSent =>
      'Envía tu primera carta para desbloquear.';

  @override
  String get badgeHintFirstLetterOpened =>
      'Abre tu primera carta para desbloquear.';

  @override
  String get badgeHintFirstPublic => 'Comparte una carta en el feed público.';

  @override
  String get badgeHintLettersSentFive => 'Envía 5 cartas para desbloquear.';

  @override
  String get badgeHintLettersSentTen => 'Envía 10 cartas para desbloquear.';

  @override
  String get badgeHintVoiceLetter =>
      'Envía una carta con audio para desbloquear.';

  @override
  String get badgeFirstLetterReceivedTitle => 'Carta recibida';

  @override
  String get badgeFirstLetterReceivedDesc => 'Recibiste tu primera carta.';

  @override
  String get badgeHintFirstLetterReceived =>
      'Recibe tu primera carta para desbloquear.';

  @override
  String get badgeProfileCompleteTitle => 'Perfil completo';

  @override
  String get badgeProfileCompleteDesc => 'Completaste tu perfil.';

  @override
  String get badgeHintProfileComplete =>
      'Completa nombre, username, bio y avatar.';

  @override
  String get badgeThreeDayStreakTitle => '3 días seguidos';

  @override
  String get badgeThreeDayStreakDesc =>
      'Usaste la app por 3 días consecutivos.';

  @override
  String get badgeHintThreeDayStreak => 'Usa la app por 3 días seguidos.';

  @override
  String get badgeLetterLikedByTenTitle => '10 likes';

  @override
  String get badgeLetterLikedByTenDesc => 'Una carta tuya recibió 10 likes.';

  @override
  String get badgeHintLetterLikedByTen => 'Recibe 10 likes en una carta.';

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
  String get userProfileActionSendLetter => 'Carta';

  @override
  String get userProfileEmptyLetters => 'Aún no hay cartas públicas';

  @override
  String get profileTabOpened => 'Abiertas';

  @override
  String get profileTabSealed => 'Selladas';

  @override
  String get profileSealedLabel => 'Sellada';

  @override
  String get profileSealedStill => 'Esta carta aún está sellada ⏳';

  @override
  String get profileSealedReady => '¡Esta carta está lista para abrirse! ✨';

  @override
  String get profileSealedAvailable => '¡Disponible para abrir!';

  @override
  String get profileSealedEmptyTitle => 'Sin cartas selladas';

  @override
  String get profileSealedEmptySubtitle =>
      'Las cartas selladas recibidas\naparecerán aquí';

  @override
  String get userProfileSealedEmptyTitle => 'Aún no hay cartas selladas';

  @override
  String get searchTitle => 'Buscar personas';

  @override
  String get searchHint => 'Buscar por nombre o @username...';

  @override
  String get searchEmpty => 'Sin resultados';

  @override
  String get searchMinCharsHint => 'Escribe al menos 2 caracteres para buscar';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get themeSection => 'Tema de la app';

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
  String get languageSection => 'Idioma';

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
  String get qrFooterBrand => 'whenote.app';

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
  String get settingsWhoCanSendEveryone => 'Todos';

  @override
  String get settingsWhoCanSendEveryoneSubtitle =>
      'Cualquier usuario puede enviarte cartas';

  @override
  String get settingsWhoCanSendFollowers => 'Personas que sigo';

  @override
  String get settingsWhoCanSendFollowersSubtitle =>
      'Solo personas que sigues de vuelta pueden enviar';

  @override
  String get settingsWhoCanSendNobody => 'Nadie';

  @override
  String get settingsWhoCanSendNobodySubtitle => 'Nadie puede enviarte cartas';

  @override
  String get profileBlockUser => 'Bloquear usuario';

  @override
  String get profileBlockConfirm =>
      '¿Estás seguro de que quieres bloquear a este usuario? No podrá enviarte cartas ni interactuar con tu contenido.';

  @override
  String get profileBlockSuccess => 'Usuario bloqueado';

  @override
  String get profileUnblockUser => 'Desbloquear usuario';

  @override
  String get profileUnblockSuccess => 'Usuario desbloqueado';

  @override
  String get profileReportUser => 'Reportar usuario';

  @override
  String get letterSendBlockedError =>
      'Este usuario no está recibiendo cartas en este momento';

  @override
  String get letterSendFollowersOnlyError =>
      'Este usuario solo acepta cartas de sus conexiones';

  @override
  String get settingsNotificationsSection => 'Notificaciones';

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
  String get settingsExportData => 'Exportar mis datos';

  @override
  String get settingsExportDataSubtitle =>
      'Descarga todos tus datos en un archivo ZIP';

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
  String get settingsAbout => 'Acerca de Whenote';

  @override
  String get settingsAboutVersion => 'Versión 1.0.0';

  @override
  String get settingsLogout => 'Cerrar sesión';

  @override
  String get settingsLogoutTitle => 'Cerrar sesión';

  @override
  String get settingsLogoutConfirmMessage =>
      '¿Estás seguro de que quieres cerrar sesión?';

  @override
  String get settingsLogoutConfirmButton => 'Cerrar sesión';

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
  String get settingsExportTitle => 'Exportar tus datos';

  @override
  String get settingsExportBody =>
      'Todos tus datos — perfil, cartas, cápsulas, comentarios, me gusta, seguidores e insignias — se exportarán en un archivo ZIP con archivos JSON y archivos multimedia adjuntos.';

  @override
  String get settingsExportButton => 'Exportar como ZIP';

  @override
  String get settingsExportZipSubtitle =>
      'Formato legible por máquina (JSON) para portabilidad de datos. Esto puede tardar unos minutos.';

  @override
  String settingsExportSuccess(int count) {
    return '$count cartas exportadas.';
  }

  @override
  String settingsExportCompleteSuccess(int items, int media) {
    return '$items elementos y $media archivos multimedia exportados.';
  }

  @override
  String get settingsExportSnack => 'Preparando exportación…';

  @override
  String get letterDetailExportPdfTitle => 'Exportar PDF';

  @override
  String get letterDetailExportPdfSubtitle =>
      'Descarga una copia portable de esta carta';

  @override
  String get settingsDeleteTitle => 'Eliminar cuenta';

  @override
  String get settingsDeleteBody =>
      'Esta acción es irreversible. Todas tus cartas, seguidores y datos se eliminarán permanentemente.';

  @override
  String get settingsDeletePendingLettersWarning =>
      'Importante: Es posible que tengas cartas bloqueadas esperando ser entregadas a destinatarios o cartas esperando ser recibidas. Si eliges \"Eliminar Todo\", las cartas pendientes que enviaste no se entregarán y las cartas que aún no abriste se perderán. Si eliges \"Anonimizar\", tus cartas enviadas continuarán siendo entregadas, pero tu nombre será reemplazado por \"Usuario eliminado\".';

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
  String get legalTitleAbout => 'Acerca de Whenote';

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
  String get aboutWhatIsTitle => 'Qué es Whenote';

  @override
  String get aboutWhatIsBody =>
      'Whenote es una plataforma digital de comunicación temporal y red social emocional. Permite crear cartas digitales con fecha futura de apertura, combinando el valor sentimental de una carta física con la viralidad de una red social moderna.';

  @override
  String get aboutSecurityTitle => 'Seguridad y Privacidad';

  @override
  String get aboutSecurityBody =>
      'Desarrollado en conformidad con la LGPD (Ley nº 13.709/2018) y el Marco Civil de Internet (Ley nº 12.965/2014). Tus datos se transmiten a través de una conexión segura (TLS) y se almacenan en la infraestructura de Google Cloud Platform, que utiliza cifrado en reposo.';

  @override
  String get aboutComplianceTitle => 'Cumplimiento Legal';

  @override
  String get aboutComplianceBody =>
      'Whenote opera en total cumplimiento con la legislación brasileña vigente, incluyendo LGPD, Marco Civil de Internet, Código de Defensa del Consumidor (Ley nº 8.078/1990) y demás normas aplicables al sector de tecnología.';

  @override
  String get aboutCompanyTitle => 'Empresa';

  @override
  String get aboutCompanyBody =>
      'Desarrollado y operado por Yuri Matos de Lima (Oviedo, España) y Diego Ricardo Martins Rocha (Miami, FL, EE.UU.). Fuero de elección: Miami-Dade County, FL, EE.UU.';

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
  String get aboutCopyright => '© 2026 Whenote. Todos los derechos reservados.';

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
  String get helpFaq2Q => '¿El destinatario necesita tener cuenta en Whenote?';

  @override
  String get helpFaq2A =>
      'Sí. Actualmente el destinatario necesita tener una cuenta registrada en Whenote para recibir cartas. El envío a correos externos estará disponible próximamente.';

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
  String get adminModerationIncidentsTab => 'Alertas IA';

  @override
  String get adminModerationAiBannerTitle => 'Moderación por IA (servidor)';

  @override
  String get adminModerationProviderOpenai => 'OpenAI Moderation API';

  @override
  String get adminModerationCredentialsOk => 'Credenciales configuradas';

  @override
  String get adminModerationCredentialsMissing =>
      'Credenciales faltantes (env de Functions)';

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
  String get adminResetFirstAction => 'Resetear guía de primera acción';

  @override
  String get adminResetFirstActionSubtitle =>
      'Muestra la guía de nuevo en el próximo inicio';

  @override
  String get adminResetFirstActionDone =>
      'Guía de primera acción reseteada. Reinicia la app para verla.';

  @override
  String get adminModerationReviewsTab => 'Revisión humana';

  @override
  String get moderationNotificationsSection => 'Moderación';

  @override
  String get moderationNotificationsEntry => 'Notificaciones';

  @override
  String get moderationNotificationsTitle => 'Notificaciones';

  @override
  String get moderationNotificationsEmpty => 'Sin notificaciones.';

  @override
  String notifFollowTitle(String name) {
    return '$name empezó a seguirte';
  }

  @override
  String get notifFollowBody => 'Tienes una nueva conexión en Whenote.';

  @override
  String notifLikeTitle(String name) {
    return 'A $name le gustó tu carta';
  }

  @override
  String get notifLikeBody =>
      'Abre la app para ver quién conecta con tus palabras.';

  @override
  String notifCommentTitle(String name) {
    return '$name comentó en tu carta';
  }

  @override
  String get notifCommentBody => 'Mira lo que escribieron.';

  @override
  String get commentsModerationPendingReview =>
      'Tu comentario se envió a revisión. Te avisaremos cuando sea aprobado o rechazado.';

  @override
  String get commentsModerationQueueFailed =>
      'No se pudo enviar a revisión. Inténtalo de nuevo.';

  @override
  String get adminModerationApprove => 'Aprobar y publicar';

  @override
  String get adminModerationReject => 'Rechazar';

  @override
  String get adminModerationFeedbackLabel =>
      'Mensaje al usuario (obligatorio al rechazar)';

  @override
  String get adminModerationFeedbackHint => 'Explica qué debe cambiar…';

  @override
  String get adminModerationReviewsLoadError =>
      'No se pudo cargar la cola de revisión.';

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
      'No se pudo abrir el correo. Contacta suporte@whenote.app.';

  @override
  String feedbackEmailBodyPrefix(String category) {
    return 'Categoría: $category';
  }

  @override
  String get keyboardDismissTooltip => 'Ocultar teclado';

  @override
  String get keyboardDismissSemanticsLabel => 'Cerrar teclado';

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
      'Estos Términos de Uso (\"Términos\") regulan el acceso y la utilización de la aplicación Whenote (\"Plataforma\"), desarrollada y operada por Yuri Matos de Lima (NIE: Z2387345L, Oviedo, España) y Diego Ricardo Martins Rocha (Miami, FL, EE.UU.), personas físicas (\"Operadores\"). La utilización de la Plataforma implica la aceptación integral e irrestricta de estos Términos, en conformidad con la legislación aplicable, incluyendo el Reglamento General de Protección de Datos — RGPD (UE), la Lei Geral de Proteção de Dados — LGPD (Brasil) y el California Consumer Privacy Act — CCPA (EE.UU.).';

  @override
  String get termsSection1Title => '1. DEL OBJETO Y NATURALEZA DEL SERVICIO';

  @override
  String get termsSection1Body =>
      'Whenote es una plataforma digital de comunicación temporal que permite a los usuarios crear, enviar, recibir y almacenar mensajes electrónicos (\"Cartas\") programados para apertura en fecha futura determinada por el remitente. El servicio tiene naturaleza de intermediación digital de comunicación privada y, cuando sea autorizado por el usuario, de publicación en entorno de red social (\"Feed Público\"). La Empresa actúa como proveedora de aplicación, en los términos del art. 5º, inciso VII, del Marco Civil de Internet.';

  @override
  String get termsSection2Title => '2. DE LOS REQUISITOS PARA LA UTILIZACIÓN';

  @override
  String get termsSection2Body =>
      'Para utilizar la Plataforma, el usuario deberá: (i) tener al menos 13 años de edad (o la edad mínima exigida por la legislación aplicable en el país de residencia del usuario — por ejemplo, 16 años en determinados Estados miembros de la UE en virtud del art. 8 del GDPR); los usuarios por debajo de la edad mínima aplicable solo podrán usar la Plataforma con consentimiento parental o de un tutor legal verificable; (ii) proporcionar datos verídicos en el registro, bajo pena de cancelación inmediata de la cuenta; (iii) mantener la confidencialidad de sus credenciales de acceso, siendo responsable de todas las actividades realizadas en su cuenta. Durante el registro, el usuario deberá proporcionar su fecha de nacimiento y confirmar que cumple con el requisito de edad mínima.';

  @override
  String get termsSection3Title =>
      '3. DE LAS OBLIGACIONES Y RESPONSABILIDADES DEL USUARIO';

  @override
  String get termsSection3Body =>
      'El usuario se compromete a utilizar la Plataforma en conformidad con todas las leyes aplicables en su jurisdicción, incluyendo, pero no limitándose a: (i) en Brasil — Ley nº 12.965/2014 (Marco Civil de Internet), Ley nº 13.709/2018 (LGPD), el Código Penal Brasileño en lo que respecta a delitos contra el honor (arts. 138 a 140), Ley nº 7.716/1989 (Ley de Delitos de Prejuicio) y el Estatuto del Niño y del Adolescente (ECA — Ley nº 8.069/1990); (ii) en la Unión Europea — el Reglamento General de Protección de Datos (GDPR), el Reglamento de Servicios Digitales (Reglamento UE 2022/2065) y las leyes nacionales aplicables de cada Estado miembro; (iii) en Estados Unidos — leyes federales incluyendo el Communications Decency Act (47 U.S.C. § 230), el Children\'s Online Privacy Protection Act (COPPA) y leyes estatales aplicables incluyendo el California Consumer Privacy Act (CCPA/CPRA); (iv) en cualquier otra jurisdicción — todas las leyes locales aplicables que rigen la conducta en línea, protección de datos, propiedad intelectual y moderación de contenido. Queda expresamente prohibido al usuario publicar contenido que: (a) sea difamatorio, calumnioso o injurioso; (b) incite a la violencia, el odio o la discriminación de cualquier tipo; (c) viole derechos de propiedad intelectual de terceros; (d) constituya acoso, ciberacoso o persecución; (e) involucre material de abuso sexual infantil (CSAM) o contenido sexual que involucre a menores de edad; (f) viole cualquier ley o reglamento aplicable en la jurisdicción del usuario.';

  @override
  String get termsSection4Title =>
      '4. DE LA RESPONSABILIDAD CIVIL DE LA EMPRESA';

  @override
  String get termsSection4Body =>
      'La Empresa, en calidad de proveedora de aplicación, no se responsabiliza por el contenido generado por los usuarios (\"UGC — User Generated Content\"), en los términos del art. 19 del Marco Civil de Internet (Brasil) y en consonancia con la Sección 230 del Communications Decency Act (EE.UU.) y el Reglamento de Servicios Digitales (UE). La responsabilidad civil de la Empresa solo se configurará mediante incumplimiento de orden judicial específica que determine la remoción de contenido o, en la UE, al tener conocimiento efectivo de contenido ilegal y no actuar con celeridad. La Empresa adopta mecanismos de moderación y denuncia, sin que ello implique asunción de responsabilidad editorial sobre el contenido de los usuarios.\n\nLA PLATAFORMA SE PROPORCIONA \"TAL CUAL\" Y \"SEGÚN DISPONIBILIDAD\", SIN GARANTÍAS DE NINGÚN TIPO, EXPRESAS O IMPLÍCITAS, INCLUYENDO, PERO NO LIMITÁNDOSE A, GARANTÍAS IMPLÍCITAS DE COMERCIABILIDAD, ADECUACIÓN PARA UN PROPÓSITO PARTICULAR Y NO INFRACCIÓN. EN LA MÁXIMA MEDIDA PERMITIDA POR LA LEGISLACIÓN APLICABLE, LOS OPERADORES NO SERÁN RESPONSABLES DE DAÑOS INDIRECTOS, INCIDENTALES, ESPECIALES, CONSECUENTES O PUNITIVOS, NI DE CUALQUIER PÉRDIDA DE BENEFICIOS, DATOS O CLIENTELA, DERIVADOS DE O RELACIONADOS CON EL USO DE LA PLATAFORMA. LA RESPONSABILIDAD TOTAL AGREGADA DE LOS OPERADORES NO EXCEDERÁ EL MONTO PAGADO A LOS OPERADORES EN LOS 12 MESES ANTERIORES A LA RECLAMACIÓN, O USD 100, LO QUE SEA MAYOR. NADA EN ESTOS TÉRMINOS EXCLUYE O LIMITA LA RESPONSABILIDAD POR MUERTE O LESIÓN PERSONAL CAUSADA POR NEGLIGENCIA, FRAUDE O CUALQUIER OTRA RESPONSABILIDAD QUE NO PUEDA SER EXCLUIDA O LIMITADA SEGÚN LA LEGISLACIÓN APLICABLE.';

  @override
  String get termsSection5Title => '5. DE LA PROPIEDAD INTELECTUAL';

  @override
  String get termsSection5Body =>
      'El usuario es y permanece titular de los derechos de autor sobre el contenido que crea en la Plataforma, de conformidad con la legislación de derechos de autor aplicable (incluyendo la Ley nº 9.610/1998 en Brasil, el Convenio de Berna y el U.S. Copyright Act). Al publicar contenido en el Feed Público, el usuario concede a la Empresa una licencia no exclusiva, gratuita y mundial para reproducir, distribuir y exhibir dicho contenido exclusivamente en el ámbito de la Plataforma. Esta licencia es revocable en cualquier momento mediante la eliminación del contenido o el cierre de la cuenta; tras la revocación, la Empresa cesará de exhibir el contenido dentro de un plazo razonable. La marca, logotipo, diseño y código fuente de Whenote son de titularidad exclusiva de los Operadores y están protegidos por las leyes de propiedad intelectual aplicables.';

  @override
  String get termsSection6Title => '6. DE LA VIGENCIA Y RESCISIÓN';

  @override
  String get termsSection6Body =>
      'El presente contrato tendrá vigencia por plazo indeterminado a partir del registro del usuario. El usuario podrá rescindir el contrato en cualquier momento mediante la eliminación de su cuenta en la configuración de la Plataforma, en los términos del art. 7º, inciso IX, del Marco Civil de Internet. La Empresa se reserva el derecho de suspender o cancelar cuentas que violen estos Términos, sin perjuicio de las demás medidas legales correspondientes.';

  @override
  String get termsSection7Title =>
      '7. DE LA DISCONTINUACIÓN DEL SERVICIO Y GARANTÍA DE ENTREGA DE CARTAS';

  @override
  String get termsSection7Body =>
      'Whenote realiza todos los esfuerzos para garantizar la entrega de todas las cartas y cápsulas en las fechas elegidas por el remitente. En caso de discontinuación planificada de los servicios, la Empresa se compromete a: (i) notificar a todos los usuarios registrados por correo electrónico y notificación en la app con al menos 90 (noventa) días de antelación al cierre definitivo; (ii) durante el período de aviso, hacer disponible la exportación de todos los datos del usuario (cartas, cápsulas, perfil, medios) a través de la app o por correo electrónico; (iii) entregar todas las cartas bloqueadas cuya fecha de apertura caiga dentro del período de aviso; (iv) después del período de 90 días, eliminar permanente e irreversiblemente todos los datos de los usuarios de sus servidores. La Empresa podrá establecer un Fondo de Continuidad — una reserva financiera suficiente para mantener la infraestructura esencial (Firebase, almacenamiento, funciones de entrega) por al menos 2 (dos) años incluso si la app deja de generar ingresos. Cuando se establezca, la existencia y el estado de este fondo serán documentados en estos Términos. Este compromiso constituye una garantía de producto, no una obligación legal, y podrá ajustarse según evolucione la capacidad financiera de la Empresa.';

  @override
  String get termsSection8Title => '8. RESOLUCIÓN DE DISPUTAS';

  @override
  String get termsSection8Body =>
      'Para usuarios residentes en Estados Unidos: cualquier disputa derivada de estos Términos será resuelta mediante arbitraje vinculante administrado por la American Arbitration Association (AAA) bajo sus Reglas de Arbitraje de Consumo, conducido en inglés, en Miami-Dade County, FL, EE.UU. Usted y los Operadores acuerdan renunciar a cualquier derecho de participar en una acción colectiva, arbitraje colectivo o procedimiento representativo. Puede excluirse de esta cláusula de arbitraje enviando una notificación escrita a juridico@whenote.app dentro de los 30 días siguientes al primer uso de la Plataforma. Las reclamaciones de medidas cautelares y las disputas que califiquen para tribunales de reclamos menores están exentas de arbitraje. Para usuarios residentes en la Unión Europea o el Espacio Económico Europeo: cualquier disputa será sometida a los tribunales competentes del país de residencia habitual del usuario, de conformidad con el Reglamento (UE) nº 1215/2012 (Bruselas I bis). Nada en estos Términos limita sus derechos bajo las leyes obligatorias de protección al consumidor de su Estado miembro. Para usuarios residentes en Brasil: cualquier disputa será sometida a los tribunales competentes del domicilio del usuario, de conformidad con el artículo 101, inciso I, del Código de Defensa del Consumidor (Ley nº 8.078/1990). Para usuarios residentes en cualquier otra jurisdicción: las disputas serán sometidas a los tribunales de la residencia habitual del usuario, salvo que la ley local permita la elección de un fuero alternativo, en cuyo caso se aplicarán los tribunales de Miami-Dade County, FL, EE.UU.';

  @override
  String get termsSection9Title => '9. DISPOSICIONES GENERALES';

  @override
  String get termsSection9Body =>
      'Estos Términos se rigen por las leyes del Estado de Florida, Estados Unidos, sin consideración de los principios de conflicto de leyes. Sin embargo, esta elección de ley no priva a los consumidores de la Unión Europea, Brasil, el Reino Unido u otra jurisdicción de la protección otorgada por las disposiciones obligatorias de sus leyes locales de protección al consumidor, las cuales se aplicarán en la medida en que otorguen mayor protección. La nulidad de cualquier cláusula no afecta la validez de las demás. Las dudas y notificaciones deben dirigirse a: juridico@whenote.app. Última actualización: 2 de mayo de 2026.';

  @override
  String get privacyIntro =>
      'Esta Política de Privacidad (\"Política\") describe cómo Yuri Matos de Lima y Diego Ricardo Martins Rocha (\"Operadores\", \"nosotros\", \"nos\", \"nuestro\") recopilan, tratan, almacenan y comparten los datos personales de los usuarios de la plataforma y aplicación móvil Whenote (\"Plataforma\"). Esta Política tiene alcance global y cumple con: (a) la Ley General de Protección de Datos de Brasil — LGPD (Ley nº 13.709/2018); (b) el Reglamento General de Protección de Datos de la Unión Europea — GDPR (Reglamento UE 2016/679); (c) el Reglamento General de Protección de Datos del Reino Unido — UK GDPR, conforme retenido por la European Union (Withdrawal) Act 2018, y la UK Data Protection Act 2018; (d) la Ley de Privacidad del Consumidor de California y la Ley de Derechos de Privacidad de California — CCPA/CPRA (California Civil Code §§ 1798.100–1798.199.100); (e) el Marco Civil de Internet de Brasil (Ley nº 12.965/2014); y (f) la Ley de Protección de la Privacidad Infantil en Línea de EE.UU. — COPPA (16 CFR Part 312). Los Operadores actúan como Responsable del Tratamiento (LGPD art. 5º VI / GDPR art. 4(7) / UK GDPR art. 4(7)) y como \"Business\" según la CCPA. Fecha de vigencia: 2 de mayo de 2026.';

  @override
  String get privacySection1Title => '1. DEFINICIONES';

  @override
  String get privacySection1Body =>
      'A los efectos de esta Política: \"Datos Personales\" significa cualquier información relacionada con una persona física identificada o identificable (LGPD art. 5º I / GDPR art. 4(1)); \"Información Personal\" (PI) tiene el significado definido en la CCPA § 1798.140(v); \"Tratamiento\" significa cualquier operación realizada con datos personales (LGPD art. 5º X / GDPR art. 4(2)); \"Titular de los Datos\" o \"Consumidor\" significa cualquier persona física cuyos datos personales son tratados; \"Responsable\" significa la entidad que determina los fines y medios del tratamiento; \"Encargado\" u \"Operador\" significa la entidad que trata datos en nombre del Responsable; \"Datos Personales Sensibles\" significa datos relativos al origen racial o étnico, convicciones religiosas, opiniones políticas, salud, vida sexual o datos biométricos/genéticos (LGPD art. 5º II / GDPR art. 9).';

  @override
  String get privacySection2Title => '2. DATOS QUE RECOPILAMOS';

  @override
  String get privacySection2Body =>
      'Recopilamos las siguientes categorías de datos personales:\n\n(a) Datos de Registro: nombre completo, nombre para mostrar, dirección de correo electrónico, nombre de usuario, foto de perfil (opcional) y texto biográfico (opcional).\n\n(b) Contenido Generado por el Usuario: cartas (texto, título, estado emocional), imágenes de cartas manuscritas (capturadas con la cámara), mensajes de voz (hasta 1 minuto, capturados con el micrófono), cápsulas del tiempo (texto, tema, fotos), comentarios en cartas públicas y enlaces opcionales de música.\n\n(c) Datos de Ubicación Precisa (opt-in): cuando eliges adjuntar una ubicación a una carta o cápsula, recopilamos tus coordenadas GPS precisas (latitud y longitud) y la marca de tiempo de la captura. También puedes activar un requisito de proximidad (aproximadamente 10 metros) para que el destinatario abra la carta. La recopilación de ubicación siempre es opcional y se solicita por carta o cápsula — nunca recopilamos ubicación en segundo plano. Se ha realizado una Evaluación de Impacto en la Protección de Datos (EIPD) conforme al artículo 35 del GDPR para el tratamiento de datos de ubicación precisa, disponible previa solicitud a nuestro DPO.\n\n(d) Datos Técnicos y del Dispositivo: dirección IP, identificador del dispositivo, sistema operativo, versión de la app, token de notificación push (Firebase Cloud Messaging), plataforma del dispositivo (Android/iOS/web), idioma preferido y registros de acceso según el art. 15 del Marco Civil de Internet.\n\n(e) Datos de Analytics: eventos de uso (cartas creadas, abiertas, compartidas; cápsulas creadas, abiertas; vistas del feed; me gusta, comentarios, follows; vistas de perfil; cambios de tema e idioma), vistas de pantalla e informes de errores/fallos, recopilados mediante Firebase Analytics y Firebase Crashlytics.\n\n(f) Datos Sociales: relaciones de seguidores/seguidos, bloqueos entre usuarios, me gusta en cartas públicas y comentarios.\n\n(g) Datos de Facturación: cuando las funciones de suscripción están habilitadas, almacenamos tu identificador de cliente Stripe, identificador de suscripción, nivel de suscripción (free/plus/pro) y estado de la suscripción. Los datos de tarjeta de pago son procesados y almacenados exclusivamente por Stripe y nunca pasan por nuestros servidores.\n\n(h) Datos de Moderación: denuncias de contenido enviadas por usuarios (motivo, detalle, contenido objetivo), resultados de análisis de moderación por IA (categorías señaladas y puntuaciones), registros de revisión humana de moderación y registros de incidentes de moderación.\n\n(i) Datos de Comunicación: mensajes de retroalimentación del producto (incluyendo metadatos de plataforma e idioma de la app) y solicitudes de soporte.\n\n(j) Datos de Gamificación: registros de desbloqueo de insignias e historial de notificaciones en la app.\n\nPara los fines de la CCPA, las categorías de PI recopiladas en los últimos 12 meses incluyen: identificadores (nombre, correo electrónico, nombre de usuario, ID del dispositivo); actividad de red de internet/electrónica (eventos de uso, registros de acceso); datos de geolocalización (GPS preciso cuando hay opt-in); información de audio/visual (mensajes de voz, fotos); e información profesional o personal inferida del contenido que creas.';

  @override
  String get privacySection3Title => '3. CÓMO RECOPILAMOS DATOS';

  @override
  String get privacySection3Body =>
      '(a) Directamente de ti: cuando creas una cuenta, escribes cartas o cápsulas, subes fotos o mensajes de voz, concedes permiso de ubicación, envías retroalimentación, publicas comentarios o interactúas con otros usuarios.\n\n(b) Automáticamente: datos técnicos y del dispositivo, eventos de analytics, informes de fallos y tokens de notificación push se recopilan automáticamente cuando usas la Plataforma, mediante los SDKs de Firebase integrados en la app.\n\n(c) De terceros: actualizaciones de estado de pago de Stripe (vía webhooks) cuando las funciones de suscripción están activas; atestación del dispositivo de Firebase App Check (Play Integrity en Android, DeviceCheck en iOS) para protección contra abusos.';

  @override
  String get privacySection4Title => '4. BASES LEGALES PARA EL TRATAMIENTO';

  @override
  String get privacySection4Body =>
      'Según la LGPD (art. 7º) y el GDPR (art. 6), tratamos tus datos con base en:\n\n(a) Consentimiento (LGPD art. 7º I / GDPR art. 6(1)(a)): manifestado en el registro cuando aceptas esta Política; para funciones opcionales como datos de ubicación y mensajes de voz, el consentimiento se obtiene en el momento del uso.\n\n(b) Ejecución de Contrato (LGPD art. 7º V / GDPR art. 6(1)(b)): tratamiento necesario para la prestación de los servicios de la Plataforma — entrega de cartas, gestión de cápsulas, funciones sociales y mantenimiento de tu cuenta.\n\n(c) Interés Legítimo (LGPD art. 7º IX / GDPR art. 6(1)(f)): mejora de la Plataforma, prevención de fraudes, moderación de contenido, seguridad del servicio y analytics. Realizamos una prueba de proporcionalidad para garantizar que nuestros intereses no prevalezcan sobre tus derechos fundamentales.\n\n(d) Obligación Legal (LGPD art. 7º II / GDPR art. 6(1)(c)): retención de registros de acceso por 6 meses (Marco Civil de Internet art. 15), cumplimiento de órdenes judiciales y requisitos regulatorios.\n\nSegún la CCPA, la recopilación y uso de PI se detalla en las Secciones 2, 6 y 8 de esta Política. No utilizamos ni divulgamos información personal sensible para fines más allá de los permitidos por la CCPA § 1798.121.';

  @override
  String get privacySection5Title => '5. FINALIDADES DEL TRATAMIENTO';

  @override
  String get privacySection5Body =>
      'Tratamos tus datos personales para las siguientes finalidades: (i) prestación y operación de los servicios de la Plataforma (entrega de cartas, gestión de cápsulas, feed social); (ii) personalización de la experiencia (temas, idioma, estados emocionales); (iii) envío de notificaciones relacionadas con el servicio (alertas de entrega de cartas, recordatorios de apertura de cápsulas) mediante notificaciones push y, cuando corresponda, correo electrónico; (iv) moderación de contenido para garantizar un entorno seguro y respetuoso; (v) analytics y mejora continua de la Plataforma; (vi) prevención de fraudes y garantía de seguridad; (vii) procesamiento de pagos y gestión de suscripciones (cuando están habilitadas); (viii) cumplimiento de obligaciones legales y regulatorias; (ix) ejercicio regular de derechos en procesos judiciales, administrativos o arbitrales. No utilizamos tus datos para publicidad de terceros, perfilado comportamental para segmentación de anuncios ni venta a intermediarios de datos.';

  @override
  String get privacySection6Title => '6. DECISIONES AUTOMATIZADAS Y PERFILADO';

  @override
  String get privacySection6Body =>
      'La Plataforma utiliza moderación automatizada de contenido impulsada por inteligencia artificial (API de Moderación de OpenAI) para analizar contenido textual (como comentarios) en busca de material potencialmente dañino. Este sistema puede: (a) permitir la publicación del contenido sin intervención (puntuación de riesgo baja); (b) presentar una advertencia amable al autor permitiendo la publicación (puntuación de riesgo media); o (c) bloquear la publicación del contenido (puntuación de riesgo alta). Cuando la moderación humana está activada, el contenido señalado se encola para revisión manual por nuestro equipo antes de una decisión final. Ninguna decisión automatizada se basa en categorías de datos personales sensibles. Según el GDPR art. 22, tienes derecho a no ser objeto de decisiones basadas únicamente en el tratamiento automatizado que produzcan efectos jurídicos o igualmente significativos. Puedes impugnar cualquier decisión automatizada de moderación contactando a privacidade@whenote.app o a través de la función de denuncia/retroalimentación en la app. Según la LGPD art. 20, puedes solicitar la revisión de decisiones automatizadas que afecten tus intereses.';

  @override
  String get privacySection7Title =>
      '7. INTERCAMBIO DE DATOS Y ENCARGADOS TERCEROS';

  @override
  String get privacySection7Body =>
      'No vendemos, alquilamos ni comercializamos tus datos personales. Para los fines de la CCPA: no hemos vendido ni compartido (según la definición de la CCPA § 1798.140(ad) y (ah)) información personal de consumidores en los últimos 12 meses, y no tenemos conocimiento efectivo de la venta o intercambio de PI de consumidores menores de 16 años. Los datos se comparten con las siguientes categorías de prestadores de servicios/encargados, cada uno vinculado por acuerdos de tratamiento de datos (DPAs) conforme al artículo 28 del GDPR y al artículo 39 de la LGPD. Copias de estos DPAs están disponibles previa solicitud contactando a dpo@whenote.app:\n\n(a) Google LLC / Firebase / Google Workspace: infraestructura en la nube (base de datos Firestore, Cloud Storage para archivos, Cloud Functions para lógica del servidor), servicios de autenticación, correos transaccionales (verificación de email, restablecimiento de contraseña) vía Google Workspace SMTP Relay, notificaciones push (FCM), analytics (Firebase Analytics), informes de fallos (Crashlytics) y atestación del dispositivo (App Check). Google trata datos como Encargado bajo nuestras instrucciones. Compromisos de privacidad de Google: https://firebase.google.com/support/privacy.\n\n(b) OpenAI, Inc.: el contenido textual se envía a la API de Moderación de OpenAI exclusivamente para análisis de seguridad de contenido. Solo se transmite el texto del contenido moderado — no se envían identificadores de usuario, imágenes ni datos de voz. La política de uso de datos de OpenAI para clientes de API establece que las entradas de API no se utilizan para entrenar modelos.\n\n(c) Twilio Inc. (SendGrid): las direcciones de correo electrónico de destinatarios externos se procesan para enviar correos de invitación cuando una carta se dirige a alguien que aún no tiene cuenta. Solo se incluyen el correo del destinatario, un nombre para mostrar del remitente y un título de la carta.\n\n(d) Stripe, Inc.: cuando las funciones de suscripción/pago están activas, Stripe procesa datos de tarjeta de pago, identificadores de cliente y estado de suscripción. Los datos de tarjeta son recopilados directamente por Stripe y nunca pasan por nuestros servidores.\n\n(e) Google Fonts: la app puede cargar tipografías de los servidores de Google, lo que implica el envío de tu dirección IP a Google.\n\n(f) Autoridades públicas: podemos compartir datos con autoridades gubernamentales cuando sea requerido por orden judicial o solicitud legal fundamentada.\n\n(g) Transacciones corporativas: en caso de fusión, adquisición o reestructuración, tus datos podrán ser transferidos a la entidad sucesora, que quedará vinculada a esta Política.';

  @override
  String get privacySection8Title =>
      '8. TRANSFERENCIAS INTERNACIONALES DE DATOS';

  @override
  String get privacySection8Body =>
      'Tus datos personales se almacenan en servidores operados por Google Cloud Platform, que pueden estar ubicados en Estados Unidos u otros países fuera de tu país de residencia. Estas transferencias se realizan en conformidad con: (a) LGPD art. 33, mediante cláusulas contractuales estándar aprobadas por la Autoridad Nacional de Protección de Datos (ANPD); (b) GDPR Capítulo V, basándose en Cláusulas Contractuales Estándar (SCCs) adoptadas por la Comisión Europea (Decisión 2021/914) y, cuando corresponda, medidas suplementarias según la sentencia Schrems II; (c) para encargados con sede en EE.UU., compromisos contractuales que garantizan una protección de datos equivalente a la prevista en la legislación aplicable. Para OpenAI y Stripe, los datos procesados en Estados Unidos están sujetos a sus respectivos acuerdos de procesamiento de datos que incorporan SCCs.';

  @override
  String get privacySection9Title => '9. RETENCIÓN DE DATOS';

  @override
  String get privacySection9Body =>
      'Retenemos tus datos durante el período mínimo necesario para las finalidades descritas en esta Política. Períodos específicos de retención:\n\n• Datos de cuenta/perfil: retenidos hasta la eliminación de la cuenta.\n• Cartas y cápsulas: retenidas hasta la eliminación por el titular o eliminación/anonimización de la cuenta.\n• Comentarios, me gusta, follows: retenidos hasta la eliminación por el titular o eliminación de la cuenta.\n• Tokens de notificación push (FCM): sobrescritos en cada inicio de sesión; eliminados al eliminar la cuenta.\n• Datos de ubicación precisa: almacenados solo cuando hay opt-in; eliminados o anonimizados al eliminar la cuenta.\n• Datos de facturación (IDs Stripe): suscripción cancelada e IDs eliminados al eliminar la cuenta. Stripe puede retener datos según su propia política de retención.\n• Denuncias de contenido: anonimizadas 90 días después de la resolución.\n• Retroalimentación del producto: anonimizada después de 1 año.\n• Registros de moderación: retenidos por 2 años (sin PII directa).\n• Datos de analytics (Firebase): retenidos según la política predeterminada de Firebase (14 meses para datos a nivel de usuario).\n• Registros de auditoría de eliminación: retenidos por 3 años con identificadores hasheados (no reversibles) únicamente — sin PII.\n• Registros de acceso: retenidos por 6 meses según el art. 15 del Marco Civil de Internet.\n\nAl vencimiento de estos períodos, los datos se eliminan permanentemente o se anonimizan de forma irreversible.';

  @override
  String get privacySection10Title => '10. TUS DERECHOS';

  @override
  String get privacySection10Body =>
      'Tus derechos varían según tu jurisdicción. Puedes ejercer cualquiera de los derechos a continuación a través de la app (Configuración > Datos y Privacidad), por correo electrónico a privacidade@whenote.app (o privacy@whenote.app en inglés), o contactando a nuestro DPO.\n\n— LGPD (Brasil — Art. 18): Tienes derecho a: (i) confirmación de la existencia del tratamiento; (ii) acceso a los datos; (iii) corrección de datos incompletos o inexactos; (iv) anonimización, bloqueo o eliminación de datos innecesarios o excesivos; (v) portabilidad a otro prestador de servicios; (vi) eliminación de los datos tratados con base en el consentimiento; (vii) información sobre terceros con quienes se compartieron los datos; (viii) información sobre la posibilidad de negar el consentimiento y sus consecuencias; (ix) revocación del consentimiento. Plazo de respuesta: 15 días hábiles. Puedes presentar una reclamación ante la ANPD (Autoridad Nacional de Protección de Datos): https://www.gov.br/anpd.\n\n— GDPR (UE/EEE — Arts. 15–22): Tienes derecho a: (i) acceso (art. 15); (ii) rectificación (art. 16); (iii) supresión / derecho al olvido (art. 17); (iv) limitación del tratamiento (art. 18); (v) portabilidad de los datos (art. 20); (vi) oposición al tratamiento basado en interés legítimo (art. 21); (vii) no ser objeto de decisiones exclusivamente automatizadas, incluido el perfilado (art. 22) — ver Sección 6 anterior; (viii) retirar el consentimiento en cualquier momento (art. 7(3)). Plazo de respuesta: 30 días. Puedes presentar una reclamación ante la autoridad de control local.\n\n— CCPA/CPRA (California): Como consumidor de California, tienes derecho a: (i) saber qué PI recopilamos, usamos, divulgamos y vendemos (Derecho a Saber); (ii) solicitar la eliminación de tu PI (Derecho de Eliminación) — plazo de respuesta: 45 días; (iii) corregir PI inexacta (Derecho de Corrección); (iv) rechazar la venta o intercambio de PI — no vendemos ni compartimos tu PI, pero puedes enviar una solicitud en cualquier momento; (v) limitar el uso de PI sensible — no utilizamos PI sensible más allá de lo necesario para prestar nuestros servicios; (vi) no discriminación por ejercer tus derechos. Puedes designar un agente autorizado para enviar solicitudes en tu nombre. Verificamos las solicitudes usando el correo electrónico de tu cuenta. Las categorías de PI recopiladas, finalidades y divulgaciones a terceros se detallan en las Secciones 2, 5 y 7.';

  @override
  String get privacySection11Title => '11. ELIMINACIÓN DE CUENTA';

  @override
  String get privacySection11Body =>
      'Puedes eliminar tu cuenta en cualquier momento en Configuración > Datos y Privacidad > Eliminar Cuenta. Antes de la eliminación, deberás reautenticarte por seguridad. Se te ofrecerán dos modos:\n\n(a) Eliminar Todo: elimina permanentemente tu perfil, todas las cartas (enviadas y recibidas), cápsulas, comentarios, me gusta, follows, bloqueos, denuncias, retroalimentación, insignias, notificaciones y todos los archivos subidos (fotos, mensajes de voz, imágenes manuscritas). Tu registro de autenticación en Firebase también se elimina.\n\n(b) Anonimizar: preserva cartas y cápsulas para sus destinatarios, pero reemplaza tu nombre por \"Usuario eliminado\" y elimina tu información identificable (ID de usuario, datos de ubicación, medios personales). Tu perfil, conexiones sociales, comentarios y me gusta se eliminan.\n\nEn ambos modos: (i) las suscripciones Stripe activas se cancelan; (ii) se registra un registro de auditoría no reversible (identificador hasheado + marca de tiempo, sin PII) para fines de cumplimiento; (iii) tras la confirmación, tu cuenta entra en un período de gracia de 15 días durante el cual puedes cancelar la solicitud de eliminación en Configuración; expirado este período, la eliminación se ejecuta de forma permanente e irreversible. Las cartas bloqueadas que ya enviaste pueden continuar siendo entregadas a sus destinatarios según nuestros Términos de Uso — una carta enviada es un regalo confiado al destinatario.';

  @override
  String get privacySection12Title => '12. PORTABILIDAD Y EXPORTACIÓN DE DATOS';

  @override
  String get privacySection12Body =>
      'Según la LGPD art. 18 V y el GDPR art. 20, tienes derecho a recibir tus datos personales en un formato estructurado, de uso común y lectura automática. Puedes exportar tus datos en Configuración > Datos y Privacidad > Exportar Mis Datos. La exportación incluye: tu información de perfil (JSON), todas las cartas enviadas (JSON + archivos de medios adjuntos), cápsulas creadas (JSON + fotos), tus comentarios (JSON), me gusta (JSON), listas de seguidores/seguidos (JSON) e insignias (JSON). La exportación se genera como un archivo ZIP. También puedes solicitar una exportación manual contactando a privacidade@whenote.app.';

  @override
  String get privacySection13Title => '13. PRIVACIDAD INFANTIL';

  @override
  String get privacySection13Body =>
      'Whenote no está dirigido a niños menores de 13 años. En cumplimiento de la COPPA (16 CFR Part 312), no recopilamos intencionalmente información personal de niños menores de 13 años. En la Unión Europea y el Reino Unido, la edad mínima para el consentimiento al tratamiento de datos es de 16 años (o la edad inferior establecida por cada Estado miembro conforme al artículo 8 del GDPR, pero nunca inferior a 13). Durante el registro, los usuarios deben proporcionar su fecha de nacimiento y confirmar que cumplen con el requisito de edad mínima aplicable en su jurisdicción. Si tomamos conocimiento de que hemos recopilado datos de un niño por debajo de la edad mínima aplicable sin consentimiento parental verificable, eliminaremos dichos datos y la cuenta asociada de inmediato. Los padres o tutores que crean que su hijo ha proporcionado datos personales pueden contactarnos en privacidade@whenote.app para solicitar la eliminación. Para usuarios de 13 a 17 años, recomendamos la orientación de los padres al usar la Plataforma. Nos comprometemos a cumplir con los estándares en evolución de verificación de edad, incluyendo el UK Age Appropriate Design Code (AADC) y marcos similares.';

  @override
  String get privacySection14Title => '14. MEDIDAS DE SEGURIDAD';

  @override
  String get privacySection14Body =>
      'Implementamos medidas técnicas y organizativas adecuadas para proteger tus datos personales, incluyendo: (a) cifrado en tránsito usando TLS 1.3 para todas las comunicaciones entre la app y nuestros servidores; (b) cifrado en reposo para datos almacenados en Google Cloud/Firebase; (c) Firebase App Check (Play Integrity en Android, DeviceCheck en iOS) para proteger los servicios de backend contra abusos; (d) control de acceso basado en roles que limita el acceso de empleados a datos personales; (e) Reglas de Seguridad de Firestore que aplican restricciones de acceso a datos a nivel de base de datos; (f) monitoreo continuo de seguridad y registro. En caso de violación de datos personales: según el GDPR, notificaremos a la autoridad de control competente dentro de las 72 horas siguientes al conocimiento de la violación (art. 33) y a los titulares afectados sin demora indebida cuando la violación represente un alto riesgo (art. 34); según la LGPD, notificaremos a la ANPD y a los titulares afectados en un plazo razonable (art. 48); según la CCPA, notificaremos a los consumidores de California afectados según lo requerido por el California Civil Code § 1798.82.';

  @override
  String get privacySection15Title => '15. TECNOLOGÍAS DE SEGUIMIENTO';

  @override
  String get privacySection15Body =>
      'La Plataforma no utiliza cookies tradicionales de navegador. Sin embargo, las siguientes tecnologías recopilan datos automáticamente: (a) Firebase Analytics: recopila eventos de uso, vistas de pantalla y propiedades del dispositivo usando identificadores móviles. En la Unión Europea y el Reino Unido, los identificadores de dispositivos móviles pueden considerarse equivalentes a cookies conforme a la Directiva ePrivacy (2002/58/CE) y las UK Privacy and Electronic Communications Regulations (PECR). Cuando sea requerido, obtenemos tu consentimiento antes de activar la recopilación de analytics. Puedes restablecer tu identificador de publicidad en la configuración del dispositivo o desactivar los analytics en la configuración de la app. El período de retención de Firebase Analytics es de 14 meses. (b) Firebase Crashlytics: recopila informes de fallos incluyendo estado del dispositivo, versión de la app y trazas de pila para ayudarnos a corregir errores. Crashlytics se clasifica como una tecnología estrictamente necesaria para la estabilidad y seguridad de la Plataforma. (c) Firebase App Check: verifica la integridad del dispositivo para protección contra abusos automatizados. Estas tecnologías son esenciales para la operación, seguridad y mejora de la Plataforma. No utilizamos ninguna tecnología de seguimiento para publicidad o seguimiento comportamental entre sitios/apps.';

  @override
  String get privacySection16Title => '16. CAMBIOS EN ESTA POLÍTICA';

  @override
  String get privacySection16Body =>
      'Podemos actualizar esta Política periódicamente para reflejar cambios en nuestras prácticas, requisitos legales o funcionalidades de la Plataforma. Cuando realicemos cambios materiales: (a) actualizaremos la \"Fecha de vigencia\" al inicio de esta Política; (b) te notificaremos mediante notificación en la app y/o correo electrónico con al menos 15 días de anticipación; (c) para cambios que requieran renovación de consentimiento según el GDPR o la LGPD, solicitaremos tu consentimiento expreso antes de que los cambios entren en vigor. El uso continuado de la Plataforma después de la fecha de vigencia de una actualización que no requiera consentimiento constituye aceptación de la Política revisada. Las versiones anteriores de esta Política están disponibles bajo solicitud.';

  @override
  String get privacySection17Title => '17. CONTÁCTANOS';

  @override
  String get privacySection17Body =>
      'Si tienes preguntas sobre esta Política, deseas ejercer tus derechos o necesitas reportar una preocupación de privacidad, contáctanos:\n\n• Encargado de Protección de Datos (DPO): dpo@whenote.app\n• Solicitudes de privacidad (portugués): privacidade@whenote.app\n• Solicitudes de privacidad (inglés): privacy@whenote.app\n• Departamento legal: juridico@whenote.app\n• Soporte general: suporte@whenote.app\n\nRepresentante en la UE/EEE (Artículo 27 del GDPR): Yuri Matos de Lima, Oviedo, España — eu-representative@whenote.app. Este representante está designado para ser contactado por las autoridades de control y los titulares de datos en la UE/EEE en todos los asuntos relacionados con el tratamiento de datos personales.\n\nBrasil — Puedes presentar una reclamación ante la ANPD: https://www.gov.br/anpd\nUE/EEE — Puedes presentar una reclamación ante la autoridad de control de protección de datos local.\nReino Unido — Puedes presentar una reclamación ante la Information Commissioner\'s Office (ICO): https://ico.org.uk/make-a-complaint\nCalifornia — Puedes contactar al Fiscal General de California: https://oag.ca.gov/privacy\n\nYuri Matos de Lima & Diego Ricardo Martins Rocha\nÚltima actualización: 2 de mayo de 2026.';

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

  @override
  String get feedReadMore => 'Leer más';

  @override
  String get feedReadFullLetter => 'Leer carta completa';

  @override
  String get feedOpenLetter => 'Abrir carta';

  @override
  String get feedCloseLetter => 'Cerrar';

  @override
  String get feedCardToAnonymous => 'Para: alguien especial';

  @override
  String get vaultLetterSheetHideReceiver => 'Ocultar nombre del destinatario';

  @override
  String get vaultLetterSheetShowReceiver => 'Mostrar nombre del destinatario';

  @override
  String get feedRemoveFromFeed => 'Quitar del feed';

  @override
  String get feedHideSenderName => 'Ocultar quien me lo envió';

  @override
  String get feedShowSenderName => 'Mostrar quien me lo envió';

  @override
  String get feedSenderAnonymous => 'Alguien especial';

  @override
  String get registerAcceptTermsPrefix => 'He leído y acepto los ';

  @override
  String get registerAcceptTermsAnd => ' y la ';

  @override
  String get registerMustAcceptTerms =>
      'Debes aceptar los términos y confirmar tu edad para continuar';

  @override
  String get socialSignInAgeGateTitle => 'Antes de continuar';

  @override
  String get socialSignInAgeGateBody =>
      'Para crear tu cuenta, confirma lo siguiente:';

  @override
  String get socialSignInContinue => 'Continuar';

  @override
  String get registerDateOfBirthLabel => 'FECHA DE NACIMIENTO';

  @override
  String get registerDateOfBirthHint => 'Selecciona tu fecha de nacimiento';

  @override
  String registerAgeUnder(int minAge) {
    return 'Debes tener al menos $minAge años para usar esta aplicación.';
  }

  @override
  String get registerSectionUsername => 'USERNAME';

  @override
  String get registerHintUsername => 'tu_username';

  @override
  String get registerUsernameSuggestions => 'Sugerencias:';

  @override
  String get registerUsernameAvailable => 'Disponible';

  @override
  String get registerUsernameChecking => 'Verificando...';

  @override
  String get registerUsernameRules => 'Solo letras, números, . y _';

  @override
  String get registerErrorUsernameEmpty => 'Elige un username';

  @override
  String get registerErrorUsernameShort =>
      'El username debe tener al menos 3 caracteres';

  @override
  String get registerErrorUsernameLong =>
      'El username debe tener máximo 20 caracteres';

  @override
  String get registerErrorUsernameInvalid =>
      'Solo letras, números, . y _ (no puede empezar/terminar con . o _)';

  @override
  String get registerErrorUsernameTaken => 'Este username ya está en uso';

  @override
  String get settingsDeleteChoiceTitle => '¿Qué debe pasar con tus cartas?';

  @override
  String get settingsDeleteOptionDeleteAll => 'Eliminar todo';

  @override
  String get settingsDeleteOptionDeleteAllDesc =>
      'Todas las cartas, cápsulas y datos serán eliminados permanentemente.';

  @override
  String get settingsDeleteOptionAnonymize => 'Anonimizar mis cartas';

  @override
  String get settingsDeleteOptionAnonymizeDesc =>
      'Tus cartas permanecen para los destinatarios, pero tu nombre e información son eliminados.';

  @override
  String get settingsDeletePasswordLabel => 'CONFIRMA TU CONTRASEÑA';

  @override
  String get settingsDeletePasswordHint => 'Ingresa tu contraseña actual';

  @override
  String get settingsDeleteReauthLabel => 'VERIFICA TU IDENTIDAD';

  @override
  String get settingsDeleteReauthApple => 'Verificar con Apple';

  @override
  String get settingsDeleteReauthGoogle => 'Verificar con Google';

  @override
  String get settingsDeleteReauthSuccess => 'Identidad verificada';

  @override
  String get settingsDeleteIrreversibleConfirm =>
      'Entiendo que esta acción es irreversible y todos mis datos serán procesados según mi elección anterior.';

  @override
  String get settingsDeleteProcessing => 'Eliminando tu cuenta...';

  @override
  String get settingsDeleteWrongPassword =>
      'Contraseña incorrecta. Inténtalo de nuevo.';

  @override
  String get settingsDeleteReauthFailed =>
      'Error de autenticación. Inténtalo de nuevo.';

  @override
  String get settingsDeleteError =>
      'Error al eliminar la cuenta. Inténtalo más tarde.';

  @override
  String settingsDeletePendingBanner(int days) {
    return 'Tu cuenta será eliminada en $days día(s). Puedes cancelar la eliminación en cualquier momento.';
  }

  @override
  String get settingsDeleteCancelButton => 'Cancelar eliminación';

  @override
  String get settingsRestrictProcessing => 'Restringir procesamiento';

  @override
  String get settingsRestrictProcessingSubtitle =>
      'Mantener datos pero detener todo el procesamiento (RGPD Art. 18)';

  @override
  String get settingsRestrictProcessingConfirm =>
      'Sus datos se mantendrán pero ya no serán procesados. No podrá enviar cartas, cápsulas ni interactuar con contenido hasta que levante la restricción. Puede levantarla en cualquier momento.';

  @override
  String get settingsRestrictProcessingSuccess =>
      'Procesamiento restringido. Sus datos están almacenados pero no se procesan.';

  @override
  String get settingsLiftRestriction => 'Levantar restricción';

  @override
  String get settingsLiftRestrictionSubtitle =>
      'Reanudar el procesamiento normal de sus datos';

  @override
  String get settingsLiftRestrictionConfirm =>
      'Esto reanudará el procesamiento normal de sus datos. Podrá volver a enviar cartas, cápsulas e interactuar con contenido.';

  @override
  String get settingsLiftRestrictionSuccess =>
      'Restricción levantada. Su cuenta está totalmente activa nuevamente.';

  @override
  String get settingsDeleteCancelled =>
      'Eliminación de cuenta cancelada. Tu cuenta está activa de nuevo.';

  @override
  String settingsDeleteScheduled(int day, int month, int year) {
    return 'Eliminación programada para $day/$month/$year. Tus datos han sido enviados por email.';
  }

  @override
  String get privacyCenterTitle => 'Centro de Privacidad';

  @override
  String get privacyCenterSubtitle => 'Ver todos tus datos almacenados';

  @override
  String get privacyCenterIntro =>
      'Aquí puedes ver todos los datos que Whenote almacena sobre ti. Esto incluye tu perfil, cartas, cápsulas, interacciones sociales y más. De acuerdo con GDPR Art. 15 y LGPD Art. 18.';

  @override
  String get privacyCenterProfile => 'Perfil';

  @override
  String get privacyCenterFieldName => 'Nombre';

  @override
  String get privacyCenterFieldUsername => 'Username';

  @override
  String get privacyCenterFieldEmail => 'Email';

  @override
  String get privacyCenterFieldBio => 'Bio';

  @override
  String get privacyCenterFieldCountry => 'País';

  @override
  String get privacyCenterFieldLanguage => 'Idioma';

  @override
  String get privacyCenterFieldCreatedAt => 'Creado en';

  @override
  String get privacyCenterFieldPhoto => 'Foto';

  @override
  String get privacyCenterYes => 'Sí';

  @override
  String get privacyCenterNo => 'No';

  @override
  String get privacyCenterLetters => 'Cartas';

  @override
  String get privacyCenterLettersSent => 'Enviadas';

  @override
  String get privacyCenterLettersReceived => 'Recibidas';

  @override
  String get privacyCenterLettersLocked => 'Bloqueadas';

  @override
  String get privacyCenterLettersWithLocation => 'Con ubicación';

  @override
  String get privacyCenterCapsules => 'Cápsulas';

  @override
  String get privacyCenterCapsulesTotal => 'Total';

  @override
  String get privacyCenterSocial => 'Social';

  @override
  String get privacyCenterFollowers => 'Seguidores';

  @override
  String get privacyCenterFollowing => 'Siguiendo';

  @override
  String get privacyCenterBlocks => 'Bloqueos';

  @override
  String get privacyCenterEngagement => 'Interacciones';

  @override
  String get privacyCenterComments => 'Comentarios';

  @override
  String get privacyCenterLikes => 'Me gusta';

  @override
  String get privacyCenterBadges => 'Logros';

  @override
  String get privacyCenterBadgesUnlocked => 'Desbloqueados';

  @override
  String get privacyCenterBilling => 'Suscripción';

  @override
  String get privacyCenterSubscriptionTier => 'Plan';

  @override
  String get privacyCenterSubscriptionStatus => 'Estado';

  @override
  String get privacyCenterLocation => 'Ubicación';

  @override
  String get privacyCenterLocationExplainer =>
      'Whenote solo guarda tu ubicación cuando eliges incluirla en una carta. La ubicación es opcional y se controla por carta.';

  @override
  String get emailVerificationTitle => 'Verifica tu email';

  @override
  String emailVerificationSubtitle(String email) {
    return 'Enviamos un enlace de verificación a $email. Confírmalo para desbloquear el envío de cartas, cápsulas y comentarios.';
  }

  @override
  String get emailVerificationResend => 'Reenviar email';

  @override
  String emailVerificationResendCooldown(String seconds) {
    return 'Reenviar en ${seconds}s';
  }

  @override
  String get emailVerificationAlreadyDone => 'Ya verifiqué';

  @override
  String get emailVerificationNotYet =>
      'Email aún no verificado. Revisa tu bandeja de entrada y carpeta de spam.';

  @override
  String get emailVerificationLater => 'Más tarde';

  @override
  String get registerSuccessVerify =>
      '¡Cuenta creada! Revisa tu email para verificar.';

  @override
  String get notificationEmailBounceTitle => 'Email no entregado';

  @override
  String notificationEmailBounceBody(String email) {
    return 'El email a $email no pudo ser entregado. Verifica la dirección e inténtalo de nuevo.';
  }

  @override
  String get notificationEmailSendFailedTitle => 'Email no enviado';

  @override
  String notificationEmailSendFailedBody(String email) {
    return 'El email a $email no pudo ser enviado. Inténtalo más tarde.';
  }

  @override
  String get resendEmail => 'Reenviar';

  @override
  String get resendEmailDialogTitle => 'Reenviar email de invitación';

  @override
  String resendEmailDialogBody(String email) {
    return 'El email a $email falló. Puedes editar la dirección y reenviar.';
  }

  @override
  String get resendEmailSuccess => '¡Email reenviado con éxito!';

  @override
  String get resendEmailCooldown => 'Espera unos minutos antes de reenviar.';

  @override
  String get resendEmailGenericError =>
      'No se pudo reenviar el email. Inténtalo más tarde.';

  @override
  String get letterModerationWarning =>
      'Tu carta tiene un tono que podría herir. ¿Quieres revisarla antes de sellarla?';

  @override
  String get letterModerationBlocked =>
      'Esta carta no puede ser enviada. Whenote existe para conectar personas con amor, superación y conexión genuina.';

  @override
  String get letterModerationUnavailable =>
      'La verificación de contenido no está disponible temporalmente. Inténtalo de nuevo en unos instantes.';

  @override
  String get letterModerationReviewBtn => 'Revisar carta';

  @override
  String get letterModerationSendAnywayBtn => 'Enviar de todos modos';

  @override
  String get letterModerationStepLabel => 'Verificando contenido…';

  @override
  String get capsuleModerationWarning =>
      'Tu cápsula tiene un tono que podría herir. ¿Quieres revisarla antes de sellarla?';

  @override
  String get capsuleModerationBlocked =>
      'Esta cápsula no puede ser creada. Whenote existe para conectar personas con amor, superación y conexión genuina.';

  @override
  String get capsuleModerationUnavailable =>
      'La verificación de contenido no está disponible temporalmente. Inténtalo de nuevo en unos instantes.';

  @override
  String get capsuleModerationReviewBtn => 'Revisar cápsula';

  @override
  String get capsuleModerationSendAnywayBtn => 'Crear de todos modos';

  @override
  String get mediaModerationImageRemovedTitle => 'Imagen eliminada';

  @override
  String get mediaModerationImageRemovedBody =>
      'Una imagen que subiste fue eliminada por no cumplir con las directrices de Whenote.';

  @override
  String get mediaModerationAudioRemovedTitle => 'Audio eliminado';

  @override
  String get mediaModerationAudioRemovedBody =>
      'Un audio que subiste fue eliminado por no cumplir con las directrices de Whenote.';

  @override
  String get mediaModerationImageUnavailable => 'Imagen no disponible';

  @override
  String get mediaModerationAudioUnavailable => 'Audio no disponible';

  @override
  String get followersTabFollowers => 'Seguidores';

  @override
  String get followersTabFollowing => 'Siguiendo';

  @override
  String get followersEmpty => 'Aún no hay seguidores';

  @override
  String get followingEmpty => 'Aún no sigue a nadie';

  @override
  String get analyticsConsentTitle => 'Ayúdanos a mejorar';

  @override
  String get analyticsConsentBody =>
      'Usamos datos de uso anónimos para entender cómo se usa la app. No se recopilan datos personales. Puedes cambiar esto en cualquier momento en Ajustes.';

  @override
  String get analyticsConsentAccept => 'Aceptar';

  @override
  String get analyticsConsentDecline => 'No, gracias';

  @override
  String get settingsAnalyticsToggle => 'Datos de uso';

  @override
  String get settingsAnalyticsDescription =>
      'Permitir datos de uso anónimos para ayudar a mejorar la app';

  @override
  String get policyUpdateBannerTitle => 'Actualización de políticas';

  @override
  String policyUpdateBannerBody(String date) {
    return 'Nuestros Términos de Uso y Política de Privacidad se actualizarán el $date. Toca para saber más.';
  }

  @override
  String get policyUpdateBannerDismiss => 'Entendido';

  @override
  String get policyReconsentTitle => 'Hemos actualizado nuestras políticas';

  @override
  String get policyReconsentBody =>
      'Hemos realizado cambios en nuestros Términos de Uso y/o Política de Privacidad. Por favor, revisa y acepta para continuar usando Whenote.';

  @override
  String get policyReconsentSummaryLabel => 'Resumen de los cambios:';

  @override
  String get policyReconsentViewFull => 'Ver documentos completos';

  @override
  String get policyReconsentCheckbox =>
      'He leído y acepto los Términos de Uso y la Política de Privacidad actualizados';

  @override
  String get policyReconsentAccept => 'Aceptar y continuar';

  @override
  String get policyReconsentLogout => 'Cerrar sesión';

  @override
  String policyReconsentEffectiveDate(String date) {
    return 'Efectivo desde $date';
  }

  @override
  String get draftsTitle => 'Borradores';

  @override
  String get draftsEmpty =>
      'Sin borradores.\nGuarda una carta como borrador para continuarla después.';

  @override
  String get draftsUntitled => 'Sin título';

  @override
  String get draftsNoContent => 'Sin contenido';

  @override
  String get draftsDeleteTitle => '¿Eliminar borrador?';

  @override
  String get draftsDeleteMessage =>
      'Este borrador se eliminará permanentemente.';

  @override
  String draftsExpiresIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Expira en $days días',
      one: 'Expira en 1 día',
      zero: 'Expira hoy',
    );
    return '$_temp0';
  }

  @override
  String get homeDrafts => 'Borradores';

  @override
  String get homeDraftsSubtitle => 'Continúa una carta que empezaste';

  @override
  String get draftSaveDialogTitle => '¿Guardar borrador?';

  @override
  String get draftSaveDialogMessage =>
      'Tienes cambios sin guardar. ¿Deseas guardar esta carta como borrador?';

  @override
  String get draftSaveDialogSave => 'Guardar borrador';

  @override
  String get draftSaveDialogDiscard => 'Descartar';

  @override
  String get draftSaveDialogCancel => 'Cancelar';

  @override
  String get draftSavedSnackbar => 'Borrador guardado';

  @override
  String get draftSaveErrorSnackbar => 'No se pudo guardar el borrador';
}
