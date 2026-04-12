import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
    Locale('pt', 'BR'),
  ];

  /// No description provided for @appName.
  ///
  /// In pt_BR, this message translates to:
  /// **'OpenWhen'**
  String get appName;

  /// No description provided for @splashTagline.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cartas para o futuro'**
  String get splashTagline;

  /// No description provided for @errorGeneric.
  ///
  /// In pt_BR, this message translates to:
  /// **'Erro: {error}'**
  String errorGeneric(String error);

  /// No description provided for @snackFillAllFields.
  ///
  /// In pt_BR, this message translates to:
  /// **'Preencha todos os campos!'**
  String get snackFillAllFields;

  /// No description provided for @actionSave.
  ///
  /// In pt_BR, this message translates to:
  /// **'Salvar'**
  String get actionSave;

  /// No description provided for @actionCancel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cancelar'**
  String get actionCancel;

  /// No description provided for @actionDelete.
  ///
  /// In pt_BR, this message translates to:
  /// **'Excluir'**
  String get actionDelete;

  /// No description provided for @actionContinue.
  ///
  /// In pt_BR, this message translates to:
  /// **'Continuar'**
  String get actionContinue;

  /// No description provided for @actionShare.
  ///
  /// In pt_BR, this message translates to:
  /// **'Compartilhar'**
  String get actionShare;

  /// No description provided for @actionCopy.
  ///
  /// In pt_BR, this message translates to:
  /// **'Copiar'**
  String get actionCopy;

  /// No description provided for @actionOk.
  ///
  /// In pt_BR, this message translates to:
  /// **'OK'**
  String get actionOk;

  /// No description provided for @locationAskShareTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Compartilhar sua localização?'**
  String get locationAskShareTitle;

  /// No description provided for @locationAskShareBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'O destinatário pode ver onde você estava ao enviar e copiar um link do Maps. Você também pode exigir abertura apenas num raio de 10 metros deste ponto.'**
  String get locationAskShareBody;

  /// No description provided for @locationAskShareAllow.
  ///
  /// In pt_BR, this message translates to:
  /// **'Compartilhar localização'**
  String get locationAskShareAllow;

  /// No description provided for @locationAskShareDeny.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não compartilhar'**
  String get locationAskShareDeny;

  /// No description provided for @locationAskRestrictTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Exigir estar no local para abrir?'**
  String get locationAskRestrictTitle;

  /// No description provided for @locationAskRestrictBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'O destinatário só poderá abrir isto num raio de 10 metros do ponto que você compartilhou.'**
  String get locationAskRestrictBody;

  /// No description provided for @locationAskRestrictYes.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sim, em 10 m'**
  String get locationAskRestrictYes;

  /// No description provided for @locationAskRestrictNo.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não'**
  String get locationAskRestrictNo;

  /// No description provided for @locationCaptureFailed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível obter a localização. Enviando sem ela.'**
  String get locationCaptureFailed;

  /// No description provided for @locationShareTileTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Local do remetente'**
  String get locationShareTileTitle;

  /// No description provided for @locationShareTileSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Toque para copiar o link do Google Maps'**
  String get locationShareTileSubtitle;

  /// No description provided for @locationCopiedSnack.
  ///
  /// In pt_BR, this message translates to:
  /// **'Copiado para a área de transferência'**
  String get locationCopiedSnack;

  /// No description provided for @locationProximityTooFarTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Longe demais'**
  String get locationProximityTooFarTitle;

  /// No description provided for @locationProximityTooFarBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Só é possível abrir isto num raio de 10 metros do local compartilhado. Aproxime-se e tente de novo.'**
  String get locationProximityTooFarBody;

  /// No description provided for @locationProximityNeedLocationTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Localização necessária'**
  String get locationProximityNeedLocationTitle;

  /// No description provided for @locationProximityNeedLocationBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ative os serviços de localização e permita que o OpenWhen acesse sua localização para abrir isto.'**
  String get locationProximityNeedLocationBody;

  /// No description provided for @navFeed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Feed'**
  String get navFeed;

  /// No description provided for @navSearch.
  ///
  /// In pt_BR, this message translates to:
  /// **'Buscar'**
  String get navSearch;

  /// No description provided for @navVault.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cofre'**
  String get navVault;

  /// No description provided for @navProfile.
  ///
  /// In pt_BR, this message translates to:
  /// **'Perfil'**
  String get navProfile;

  /// No description provided for @homeWriteLetter.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escrever Carta'**
  String get homeWriteLetter;

  /// No description provided for @homeWriteLetterSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Para alguem especial'**
  String get homeWriteLetterSubtitle;

  /// No description provided for @homeNewCapsule.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nova Capsula do Tempo'**
  String get homeNewCapsule;

  /// No description provided for @homeNewCapsuleSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Para voce mesmo ou um grupo'**
  String get homeNewCapsuleSubtitle;

  /// No description provided for @onboardingTag1.
  ///
  /// In pt_BR, this message translates to:
  /// **'CARTAS PARA O FUTURO'**
  String get onboardingTag1;

  /// No description provided for @onboardingTitle1.
  ///
  /// In pt_BR, this message translates to:
  /// **'Palavras que chegam\nna hora certa'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escreva uma carta hoje. Escolha quando ela será aberta. Deixe o tempo fazer sua magia.'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingTag2.
  ///
  /// In pt_BR, this message translates to:
  /// **'SEU COFRE DIGITAL'**
  String get onboardingTag2;

  /// No description provided for @onboardingTitle2.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bloqueada até o\nmomento perfeito'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In pt_BR, this message translates to:
  /// **'A carta fica guardada com segurança até a data que você escolher — pode ser amanhã, ou daqui a 10 anos.'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingTag3.
  ///
  /// In pt_BR, this message translates to:
  /// **'COMPARTILHE AMOR'**
  String get onboardingTag3;

  /// No description provided for @onboardingTitle3.
  ///
  /// In pt_BR, this message translates to:
  /// **'Inspire outras pessoas\ncom sua história'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cartas abertas podem ir para o feed público. Espalhe amor, amizade e emoção para o mundo.'**
  String get onboardingSubtitle3;

  /// No description provided for @onboardingCreateFirst.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criar minha primeira carta'**
  String get onboardingCreateFirst;

  /// No description provided for @onboardingAlreadyHaveAccount.
  ///
  /// In pt_BR, this message translates to:
  /// **'Já tenho uma conta'**
  String get onboardingAlreadyHaveAccount;

  /// No description provided for @loginHeroLetters.
  ///
  /// In pt_BR, this message translates to:
  /// **'CARTAS PARA O FUTURO'**
  String get loginHeroLetters;

  /// No description provided for @loginHeroCreateAccount.
  ///
  /// In pt_BR, this message translates to:
  /// **'CRIE SUA CONTA GRÁTIS'**
  String get loginHeroCreateAccount;

  /// No description provided for @loginTabSignIn.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entrar'**
  String get loginTabSignIn;

  /// No description provided for @loginTabCreateAccount.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criar conta'**
  String get loginTabCreateAccount;

  /// No description provided for @hintEmail.
  ///
  /// In pt_BR, this message translates to:
  /// **'seu@email.com'**
  String get hintEmail;

  /// No description provided for @labelEmail.
  ///
  /// In pt_BR, this message translates to:
  /// **'E-mail'**
  String get labelEmail;

  /// No description provided for @hintPassword.
  ///
  /// In pt_BR, this message translates to:
  /// **'sua senha'**
  String get hintPassword;

  /// No description provided for @labelPassword.
  ///
  /// In pt_BR, this message translates to:
  /// **'Senha'**
  String get labelPassword;

  /// No description provided for @loginForgotPassword.
  ///
  /// In pt_BR, this message translates to:
  /// **'Esqueceu a senha?'**
  String get loginForgotPassword;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Recuperar senha'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Insira o e-mail associado à sua conta e enviaremos um link para redefinir sua senha.'**
  String get forgotPasswordBody;

  /// No description provided for @forgotPasswordHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'seu e-mail'**
  String get forgotPasswordHint;

  /// No description provided for @forgotPasswordButton.
  ///
  /// In pt_BR, this message translates to:
  /// **'Enviar link de recuperação'**
  String get forgotPasswordButton;

  /// No description provided for @forgotPasswordSent.
  ///
  /// In pt_BR, this message translates to:
  /// **'Link de recuperação enviado para {email}'**
  String forgotPasswordSent(String email);

  /// No description provided for @forgotPasswordErrorNoUser.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhuma conta encontrada com este e-mail.'**
  String get forgotPasswordErrorNoUser;

  /// No description provided for @forgotPasswordErrorInvalidEmail.
  ///
  /// In pt_BR, this message translates to:
  /// **'Por favor, insira um e-mail válido.'**
  String get forgotPasswordErrorInvalidEmail;

  /// No description provided for @forgotPasswordErrorGeneric.
  ///
  /// In pt_BR, this message translates to:
  /// **'Algo deu errado. Tente novamente.'**
  String get forgotPasswordErrorGeneric;

  /// No description provided for @loginButtonSignIn.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entrar'**
  String get loginButtonSignIn;

  /// No description provided for @loginRegisterBlurb.
  ///
  /// In pt_BR, this message translates to:
  /// **'Crie sua conta em um único passo: nome, e-mail e senha na próxima tela.'**
  String get loginRegisterBlurb;

  /// No description provided for @loginBullet1.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cartas para abrir no futuro'**
  String get loginBullet1;

  /// No description provided for @loginBullet2.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cofre seguro e feed opcional'**
  String get loginBullet2;

  /// No description provided for @loginBullet3.
  ///
  /// In pt_BR, this message translates to:
  /// **'Grátis para começar'**
  String get loginBullet3;

  /// No description provided for @loginCreateAccount.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criar minha conta'**
  String get loginCreateAccount;

  /// No description provided for @loginAlreadyHaveAccount.
  ///
  /// In pt_BR, this message translates to:
  /// **'Já tenho conta — entrar'**
  String get loginAlreadyHaveAccount;

  /// No description provided for @loginOrContinueWith.
  ///
  /// In pt_BR, this message translates to:
  /// **'ou continue com'**
  String get loginOrContinueWith;

  /// No description provided for @loginLegalFooter.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ao entrar você aceita os Termos de Uso e a Política de Privacidade.'**
  String get loginLegalFooter;

  /// No description provided for @registerSuccess.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conta criada! Verifique seu email e faça login para continuar.'**
  String get registerSuccess;

  /// No description provided for @hintName.
  ///
  /// In pt_BR, this message translates to:
  /// **'seu nome'**
  String get hintName;

  /// No description provided for @labelName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nome'**
  String get labelName;

  /// No description provided for @hintCreatePassword.
  ///
  /// In pt_BR, this message translates to:
  /// **'crie uma senha'**
  String get hintCreatePassword;

  /// No description provided for @registerCreateAccount.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criar minha conta'**
  String get registerCreateAccount;

  /// No description provided for @registerAlreadyHaveAccount.
  ///
  /// In pt_BR, this message translates to:
  /// **'Já tenho uma conta'**
  String get registerAlreadyHaveAccount;

  /// No description provided for @registerLegalFooter.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ao criar sua conta você aceita os Termos de Uso e a Política de Privacidade.'**
  String get registerLegalFooter;

  /// No description provided for @feedPublicHeader.
  ///
  /// In pt_BR, this message translates to:
  /// **'FEED PÚBLICO'**
  String get feedPublicHeader;

  /// No description provided for @feedFilterAll.
  ///
  /// In pt_BR, this message translates to:
  /// **'Para todos'**
  String get feedFilterAll;

  /// No description provided for @feedFilterLove.
  ///
  /// In pt_BR, this message translates to:
  /// **'Amor'**
  String get feedFilterLove;

  /// No description provided for @feedFilterFriendship.
  ///
  /// In pt_BR, this message translates to:
  /// **'Amizade'**
  String get feedFilterFriendship;

  /// No description provided for @feedFilterFamily.
  ///
  /// In pt_BR, this message translates to:
  /// **'Família'**
  String get feedFilterFamily;

  /// No description provided for @feedLayerExplore.
  ///
  /// In pt_BR, this message translates to:
  /// **'Explorar'**
  String get feedLayerExplore;

  /// No description provided for @feedLayerHighlights.
  ///
  /// In pt_BR, this message translates to:
  /// **'Destaques'**
  String get feedLayerHighlights;

  /// No description provided for @feedLayerFollowing.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seguindo'**
  String get feedLayerFollowing;

  /// No description provided for @feedFiltersButton.
  ///
  /// In pt_BR, this message translates to:
  /// **'Feed'**
  String get feedFiltersButton;

  /// No description provided for @feedFiltersSheetTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escolher feed'**
  String get feedFiltersSheetTitle;

  /// No description provided for @feedFiltersButtonSemantic.
  ///
  /// In pt_BR, this message translates to:
  /// **'Abrir filtros do tipo de feed'**
  String get feedFiltersButtonSemantic;

  /// No description provided for @feedCustomizePinnedFilters.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fixar filtros rápidos…'**
  String get feedCustomizePinnedFilters;

  /// No description provided for @feedCustomizePinnedFiltersHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escolha até 3 chips de humor na barra'**
  String get feedCustomizePinnedFiltersHint;

  /// No description provided for @feedPinFiltersSheetTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fixar filtros rápidos'**
  String get feedPinFiltersSheetTitle;

  /// No description provided for @feedPinFiltersMaxNote.
  ///
  /// In pt_BR, this message translates to:
  /// **'Até 3 filtros. A ordem segue a sua seleção.'**
  String get feedPinFiltersMaxNote;

  /// No description provided for @feedPinFiltersSave.
  ///
  /// In pt_BR, this message translates to:
  /// **'Guardar'**
  String get feedPinFiltersSave;

  /// No description provided for @feedFollowingEmptyTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhuma carta de quem você segue'**
  String get feedFollowingEmptyTitle;

  /// No description provided for @feedFollowingEmptySubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Siga perfis para ver as cartas públicas deles aqui.'**
  String get feedFollowingEmptySubtitle;

  /// No description provided for @feedFollowingSignedOutTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entre para ver este feed'**
  String get feedFollowingSignedOutTitle;

  /// No description provided for @feedFollowingSignedOutSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'A aba Seguindo mostra cartas públicas de quem você segue.'**
  String get feedFollowingSignedOutSubtitle;

  /// No description provided for @feedLoadError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível carregar o feed. Tente novamente.'**
  String get feedLoadError;

  /// No description provided for @feedLoadMore.
  ///
  /// In pt_BR, this message translates to:
  /// **'Carregar mais'**
  String get feedLoadMore;

  /// No description provided for @feedEmptyTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhuma carta pública ainda'**
  String get feedEmptyTitle;

  /// No description provided for @feedEmptySubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seja o primeiro a compartilhar\numa carta com o mundo'**
  String get feedEmptySubtitle;

  /// No description provided for @feedFilterEmptyTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhuma carta neste filtro'**
  String get feedFilterEmptyTitle;

  /// No description provided for @feedFilterEmptySubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tente outro filtro ou volte para \"Para todos\"'**
  String get feedFilterEmptySubtitle;

  /// No description provided for @feedCardTo.
  ///
  /// In pt_BR, this message translates to:
  /// **'Para: {name}'**
  String feedCardTo(String name);

  /// No description provided for @feedCardFeatured.
  ///
  /// In pt_BR, this message translates to:
  /// **'✦ Destaque'**
  String get feedCardFeatured;

  /// No description provided for @feedOpenedOnDate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aberta em {date}'**
  String feedOpenedOnDate(String date);

  /// No description provided for @feedViewAllComments.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ver todos os {count} comentários'**
  String feedViewAllComments(int count);

  /// No description provided for @commentsTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comentários'**
  String get commentsTitle;

  /// No description provided for @commentsEmptyTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum comentário ainda'**
  String get commentsEmptyTitle;

  /// No description provided for @commentsEmptySubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seja o primeiro a comentar'**
  String get commentsEmptySubtitle;

  /// No description provided for @commentsInputHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escreva com amor... 💌'**
  String get commentsInputHint;

  /// No description provided for @commentsModerationWarning.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sua mensagem contém palavras inadequadas. O OpenWhen é um espaço de amor e respeito. 💌'**
  String get commentsModerationWarning;

  /// No description provided for @commentsModerationAiBlocked.
  ///
  /// In pt_BR, this message translates to:
  /// **'Este comentário não passou na moderação automática. Reformule com respeito.'**
  String get commentsModerationAiBlocked;

  /// No description provided for @commentsModerationUnavailable.
  ///
  /// In pt_BR, this message translates to:
  /// **'A moderação automática não está disponível no momento. Tente de novo em instantes.'**
  String get commentsModerationUnavailable;

  /// No description provided for @vaultTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Meu Cofre'**
  String get vaultTitle;

  /// No description provided for @vaultSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'SUAS CARTAS E CAPSULAS'**
  String get vaultSubtitle;

  /// No description provided for @vaultTabReceived.
  ///
  /// In pt_BR, this message translates to:
  /// **'Recebidas'**
  String get vaultTabReceived;

  /// No description provided for @vaultTabSent.
  ///
  /// In pt_BR, this message translates to:
  /// **'Enviadas'**
  String get vaultTabSent;

  /// No description provided for @vaultTabCapsules.
  ///
  /// In pt_BR, this message translates to:
  /// **'Capsulas'**
  String get vaultTabCapsules;

  /// No description provided for @vaultEmptyReceivedTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhuma carta recebida ainda'**
  String get vaultEmptyReceivedTitle;

  /// No description provided for @vaultEmptyReceivedSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quando alguem te enviar uma carta\nela aparecera aqui'**
  String get vaultEmptyReceivedSubtitle;

  /// No description provided for @vaultEmptyReceivedCta.
  ///
  /// In pt_BR, this message translates to:
  /// **'Compartilhe seu perfil para as pessoas poderem te enviar cartas.'**
  String get vaultEmptyReceivedCta;

  /// No description provided for @vaultEmptyReceivedCtaButton.
  ///
  /// In pt_BR, this message translates to:
  /// **'Abrir perfil'**
  String get vaultEmptyReceivedCtaButton;

  /// No description provided for @vaultLetterChipPrivate.
  ///
  /// In pt_BR, this message translates to:
  /// **'🔒 Privada · Tornar pública'**
  String get vaultLetterChipPrivate;

  /// No description provided for @vaultLetterChipPublic.
  ///
  /// In pt_BR, this message translates to:
  /// **'🌍 Pública · Tornar privada'**
  String get vaultLetterChipPublic;

  /// No description provided for @vaultLetterSheetMakePublic.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tornar pública'**
  String get vaultLetterSheetMakePublic;

  /// No description provided for @vaultLetterSheetMakePrivate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tornar privada'**
  String get vaultLetterSheetMakePrivate;

  /// No description provided for @vaultLetterSheetDelete.
  ///
  /// In pt_BR, this message translates to:
  /// **'Remover do cofre'**
  String get vaultLetterSheetDelete;

  /// No description provided for @vaultLetterSheetFavoriteSoon.
  ///
  /// In pt_BR, this message translates to:
  /// **'Favoritar (em breve)'**
  String get vaultLetterSheetFavoriteSoon;

  /// No description provided for @vaultLetterDeleteTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Remover carta?'**
  String get vaultLetterDeleteTitle;

  /// No description provided for @vaultLetterDeleteMessage.
  ///
  /// In pt_BR, this message translates to:
  /// **'A carta sai do seu cofre e do feed público, se estiver compartilhada.'**
  String get vaultLetterDeleteMessage;

  /// No description provided for @vaultMenuHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dica: toque em ⋯ no card para mudar privacidade ou excluir.'**
  String get vaultMenuHint;

  /// No description provided for @vaultMenuHintGotIt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entendi'**
  String get vaultMenuHintGotIt;

  /// No description provided for @vaultCountdownReady.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pronta para abrir!'**
  String get vaultCountdownReady;

  /// No description provided for @vaultCountdownDays.
  ///
  /// In pt_BR, this message translates to:
  /// **'Abre em {count} dias'**
  String vaultCountdownDays(int count);

  /// No description provided for @vaultCountdownHours.
  ///
  /// In pt_BR, this message translates to:
  /// **'Abre em {count} horas'**
  String vaultCountdownHours(int count);

  /// No description provided for @vaultCountdownMinutes.
  ///
  /// In pt_BR, this message translates to:
  /// **'Abre em {count} minutos'**
  String vaultCountdownMinutes(int count);

  /// No description provided for @vaultEmptyWaitingTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhuma carta esperando'**
  String get vaultEmptyWaitingTitle;

  /// No description provided for @vaultEmptyWaitingSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quando alguem te enviar uma carta\nela aparecera aqui'**
  String get vaultEmptyWaitingSubtitle;

  /// No description provided for @vaultEmptyOpenedTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhuma carta aberta ainda'**
  String get vaultEmptyOpenedTitle;

  /// No description provided for @vaultEmptyOpenedSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Suas cartas abertas\naparecera aqui'**
  String get vaultEmptyOpenedSubtitle;

  /// No description provided for @vaultEmptySentTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhuma carta enviada'**
  String get vaultEmptySentTitle;

  /// No description provided for @vaultEmptySentSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'As cartas que voce enviar\naparecera aqui'**
  String get vaultEmptySentSubtitle;

  /// No description provided for @vaultStatusWaiting.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aguardando'**
  String get vaultStatusWaiting;

  /// No description provided for @vaultStatusPending.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pendente'**
  String get vaultStatusPending;

  /// No description provided for @vaultStatusOpened.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aberta'**
  String get vaultStatusOpened;

  /// No description provided for @vaultStatusReady.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pronta!'**
  String get vaultStatusReady;

  /// No description provided for @vaultStatusLocked.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bloqueada'**
  String get vaultStatusLocked;

  /// No description provided for @vaultTo.
  ///
  /// In pt_BR, this message translates to:
  /// **'Para: {name}'**
  String vaultTo(String name);

  /// No description provided for @vaultFrom.
  ///
  /// In pt_BR, this message translates to:
  /// **'De: {name}'**
  String vaultFrom(String name);

  /// No description provided for @vaultAlreadyOpened.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ja foi aberta!'**
  String get vaultAlreadyOpened;

  /// No description provided for @vaultPendingRecipient.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aguardando o destinatario aceitar a carta'**
  String get vaultPendingRecipient;

  /// No description provided for @vaultOpenLetter.
  ///
  /// In pt_BR, this message translates to:
  /// **'Abrir carta'**
  String get vaultOpenLetter;

  /// No description provided for @vaultLetterOpened.
  ///
  /// In pt_BR, this message translates to:
  /// **'Carta aberta'**
  String get vaultLetterOpened;

  /// No description provided for @vaultReadFullLetter.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ler carta completa'**
  String get vaultReadFullLetter;

  /// No description provided for @vaultOpenCapsule.
  ///
  /// In pt_BR, this message translates to:
  /// **'Abrir Capsula'**
  String get vaultOpenCapsule;

  /// No description provided for @vaultViewFullCapsule.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ver capsula completa'**
  String get vaultViewFullCapsule;

  /// No description provided for @vaultEmptyCapsulesTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhuma capsula ainda'**
  String get vaultEmptyCapsulesTitle;

  /// No description provided for @vaultEmptyCapsulesSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Crie sua primeira capsula do tempo\ne guarde memorias para o futuro'**
  String get vaultEmptyCapsulesSubtitle;

  /// No description provided for @vaultCreateCapsule.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criar Capsula'**
  String get vaultCreateCapsule;

  /// No description provided for @vaultPhotoCount.
  ///
  /// In pt_BR, this message translates to:
  /// **'{count} foto(s)'**
  String vaultPhotoCount(int count);

  /// No description provided for @vaultAnswerCount.
  ///
  /// In pt_BR, this message translates to:
  /// **'{count} resposta(s)'**
  String vaultAnswerCount(int count);

  /// No description provided for @vaultCapsuleOpenedOn.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aberta em {date}'**
  String vaultCapsuleOpenedOn(String date);

  /// No description provided for @vaultCapsuleSealed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Selada'**
  String get vaultCapsuleSealed;

  /// No description provided for @capsulePhotoAdd.
  ///
  /// In pt_BR, this message translates to:
  /// **'Adicionar foto'**
  String get capsulePhotoAdd;

  /// No description provided for @capsulePhotoHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Toque para adicionar uma foto a sua capsula'**
  String get capsulePhotoHint;

  /// No description provided for @capsulePhotoWebDisabled.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fotos disponiveis apenas no app mobile'**
  String get capsulePhotoWebDisabled;

  /// No description provided for @capsulePhotoRemove.
  ///
  /// In pt_BR, this message translates to:
  /// **'Remover foto'**
  String get capsulePhotoRemove;

  /// No description provided for @capsulePhotoErrorUpload.
  ///
  /// In pt_BR, this message translates to:
  /// **'Erro ao enviar foto. Tente novamente.'**
  String get capsulePhotoErrorUpload;

  /// No description provided for @capsulePhotoMax.
  ///
  /// In pt_BR, this message translates to:
  /// **'Maximo de {count} fotos atingido'**
  String capsulePhotoMax(int count);

  /// No description provided for @vaultFilterTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Filtrar e ordenar'**
  String get vaultFilterTitle;

  /// No description provided for @vaultFilterSearchHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Buscar por título ou nome...'**
  String get vaultFilterSearchHint;

  /// No description provided for @vaultFilterSortLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ordenar por'**
  String get vaultFilterSortLabel;

  /// No description provided for @vaultFilterApply.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aplicar'**
  String get vaultFilterApply;

  /// No description provided for @vaultFilterClear.
  ///
  /// In pt_BR, this message translates to:
  /// **'Limpar filtros'**
  String get vaultFilterClear;

  /// No description provided for @vaultFilterOpenDateFrom.
  ///
  /// In pt_BR, this message translates to:
  /// **'Abre a partir de'**
  String get vaultFilterOpenDateFrom;

  /// No description provided for @vaultFilterOpenDateTo.
  ///
  /// In pt_BR, this message translates to:
  /// **'Abre até'**
  String get vaultFilterOpenDateTo;

  /// No description provided for @vaultFilterClearDate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Limpar data'**
  String get vaultFilterClearDate;

  /// No description provided for @vaultFilterPendingOnly.
  ///
  /// In pt_BR, this message translates to:
  /// **'Somente pendentes de aceite'**
  String get vaultFilterPendingOnly;

  /// No description provided for @vaultFilterThemesLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Temas'**
  String get vaultFilterThemesLabel;

  /// No description provided for @vaultFilterDirectionAll.
  ///
  /// In pt_BR, this message translates to:
  /// **'Todas'**
  String get vaultFilterDirectionAll;

  /// No description provided for @vaultFilterDirectionReceived.
  ///
  /// In pt_BR, this message translates to:
  /// **'Recebidas'**
  String get vaultFilterDirectionReceived;

  /// No description provided for @vaultFilterDirectionSent.
  ///
  /// In pt_BR, this message translates to:
  /// **'Enviadas'**
  String get vaultFilterDirectionSent;

  /// No description provided for @vaultFilterEmptyTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum item com este filtro'**
  String get vaultFilterEmptyTitle;

  /// No description provided for @vaultFilterEmptySubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ajuste a busca ou limpe os filtros para ver tudo de novo'**
  String get vaultFilterEmptySubtitle;

  /// No description provided for @vaultFilterActiveBadge.
  ///
  /// In pt_BR, this message translates to:
  /// **'Filtrado'**
  String get vaultFilterActiveBadge;

  /// No description provided for @vaultSortWaitingOpenDateAsc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Data de abertura (mais próxima)'**
  String get vaultSortWaitingOpenDateAsc;

  /// No description provided for @vaultSortWaitingOpenDateDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Data de abertura (mais distante)'**
  String get vaultSortWaitingOpenDateDesc;

  /// No description provided for @vaultSortWaitingCreatedDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criação (mais recente)'**
  String get vaultSortWaitingCreatedDesc;

  /// No description provided for @vaultSortWaitingCreatedAsc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criação (mais antiga)'**
  String get vaultSortWaitingCreatedAsc;

  /// No description provided for @vaultSortWaitingTitleAsc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Título (A–Z)'**
  String get vaultSortWaitingTitleAsc;

  /// No description provided for @vaultSortOpenedOpenedAtDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aberta em (mais recente)'**
  String get vaultSortOpenedOpenedAtDesc;

  /// No description provided for @vaultSortOpenedOpenedAtAsc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aberta em (mais antiga)'**
  String get vaultSortOpenedOpenedAtAsc;

  /// No description provided for @vaultSortOpenedOpenDateDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Data planejada (mais distante)'**
  String get vaultSortOpenedOpenDateDesc;

  /// No description provided for @vaultSortOpenedOpenDateAsc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Data planejada (mais próxima)'**
  String get vaultSortOpenedOpenDateAsc;

  /// No description provided for @vaultSortOpenedTitleAsc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Título (A–Z)'**
  String get vaultSortOpenedTitleAsc;

  /// No description provided for @vaultSortSentOpenDateAsc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Data de abertura (mais próxima)'**
  String get vaultSortSentOpenDateAsc;

  /// No description provided for @vaultSortSentOpenDateDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Data de abertura (mais distante)'**
  String get vaultSortSentOpenDateDesc;

  /// No description provided for @vaultSortSentCreatedDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criação (mais recente)'**
  String get vaultSortSentCreatedDesc;

  /// No description provided for @vaultSortSentCreatedAsc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criação (mais antiga)'**
  String get vaultSortSentCreatedAsc;

  /// No description provided for @vaultSortSentTitleAsc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Título (A–Z)'**
  String get vaultSortSentTitleAsc;

  /// No description provided for @vaultSortCapsulesOpenDateAsc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Data de abertura (mais próxima)'**
  String get vaultSortCapsulesOpenDateAsc;

  /// No description provided for @vaultSortCapsulesOpenDateDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Data de abertura (mais distante)'**
  String get vaultSortCapsulesOpenDateDesc;

  /// No description provided for @vaultSortCapsulesCreatedDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criação (mais recente)'**
  String get vaultSortCapsulesCreatedDesc;

  /// No description provided for @vaultSortCapsulesCreatedAsc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criação (mais antiga)'**
  String get vaultSortCapsulesCreatedAsc;

  /// No description provided for @vaultSortCapsulesTitleAsc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Título (A–Z)'**
  String get vaultSortCapsulesTitleAsc;

  /// No description provided for @capsuleThemeMemories.
  ///
  /// In pt_BR, this message translates to:
  /// **'Memorias'**
  String get capsuleThemeMemories;

  /// No description provided for @capsuleThemeGoals.
  ///
  /// In pt_BR, this message translates to:
  /// **'Metas'**
  String get capsuleThemeGoals;

  /// No description provided for @capsuleThemeFeelings.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentimentos'**
  String get capsuleThemeFeelings;

  /// No description provided for @capsuleThemeRelationships.
  ///
  /// In pt_BR, this message translates to:
  /// **'Relacionamentos'**
  String get capsuleThemeRelationships;

  /// No description provided for @capsuleThemeGrowth.
  ///
  /// In pt_BR, this message translates to:
  /// **'Crescimento'**
  String get capsuleThemeGrowth;

  /// No description provided for @capsuleThemeDefault.
  ///
  /// In pt_BR, this message translates to:
  /// **'Capsula'**
  String get capsuleThemeDefault;

  /// No description provided for @writeLetterTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escrever carta'**
  String get writeLetterTitle;

  /// No description provided for @writeLetterFeeling.
  ///
  /// In pt_BR, this message translates to:
  /// **'COMO VOCÊ ESTÁ SE SENTINDO?'**
  String get writeLetterFeeling;

  /// No description provided for @writeLetterEmotionLove.
  ///
  /// In pt_BR, this message translates to:
  /// **'Amor'**
  String get writeLetterEmotionLove;

  /// No description provided for @writeLetterEmotionAchievement.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conquista'**
  String get writeLetterEmotionAchievement;

  /// No description provided for @writeLetterEmotionAdvice.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conselho'**
  String get writeLetterEmotionAdvice;

  /// No description provided for @writeLetterEmotionNostalgia.
  ///
  /// In pt_BR, this message translates to:
  /// **'Saudade'**
  String get writeLetterEmotionNostalgia;

  /// No description provided for @writeLetterEmotionFarewell.
  ///
  /// In pt_BR, this message translates to:
  /// **'Despedida'**
  String get writeLetterEmotionFarewell;

  /// No description provided for @writeLetterFieldTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Título'**
  String get writeLetterFieldTitle;

  /// No description provided for @writeLetterFieldTitleHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ex: Abra quando sentir saudade'**
  String get writeLetterFieldTitleHint;

  /// No description provided for @writeLetterTypeSection.
  ///
  /// In pt_BR, this message translates to:
  /// **'TIPO DE CARTA'**
  String get writeLetterTypeSection;

  /// No description provided for @writeLetterTypeTyped.
  ///
  /// In pt_BR, this message translates to:
  /// **'Digitada'**
  String get writeLetterTypeTyped;

  /// No description provided for @writeLetterTypeHandwritten.
  ///
  /// In pt_BR, this message translates to:
  /// **'Manuscrita'**
  String get writeLetterTypeHandwritten;

  /// No description provided for @writeLetterFieldMessage.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sua mensagem'**
  String get writeLetterFieldMessage;

  /// No description provided for @writeLetterPhotoTap.
  ///
  /// In pt_BR, this message translates to:
  /// **'Toque para adicionar a foto da carta'**
  String get writeLetterPhotoTap;

  /// No description provided for @writeLetterPhotoHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tire uma foto da sua carta escrita à mão'**
  String get writeLetterPhotoHint;

  /// No description provided for @writeLetterRecipientSection.
  ///
  /// In pt_BR, this message translates to:
  /// **'PARA QUEM?'**
  String get writeLetterRecipientSection;

  /// No description provided for @writeLetterSearchHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Buscar por @usuario ou nome...'**
  String get writeLetterSearchHint;

  /// No description provided for @writeLetterOrSendExternal.
  ///
  /// In pt_BR, this message translates to:
  /// **'ou envie para quem não tem conta'**
  String get writeLetterOrSendExternal;

  /// No description provided for @writeLetterEmailHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'email@exemplo.com'**
  String get writeLetterEmailHint;

  /// No description provided for @writeLetterReceiverLink.
  ///
  /// In pt_BR, this message translates to:
  /// **'Receberá um link para criar conta'**
  String get writeLetterReceiverLink;

  /// No description provided for @writeLetterOpenDateLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Data de abertura'**
  String get writeLetterOpenDateLabel;

  /// No description provided for @writeLetterPrivacyNote.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cartas enviadas são privadas. Só quem recebe pode escolher publicar no feed depois de abrir.'**
  String get writeLetterPrivacyNote;

  /// No description provided for @writeLetterSend.
  ///
  /// In pt_BR, this message translates to:
  /// **'Enviar carta 💌'**
  String get writeLetterSend;

  /// No description provided for @writeLetterSnackTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Preencha o título!'**
  String get writeLetterSnackTitle;

  /// No description provided for @writeLetterSnackMessage.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escreva sua mensagem!'**
  String get writeLetterSnackMessage;

  /// No description provided for @writeLetterSnackPhoto.
  ///
  /// In pt_BR, this message translates to:
  /// **'Adicione a foto da carta!'**
  String get writeLetterSnackPhoto;

  /// No description provided for @writeLetterSnackRecipient.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escolha o destinatário!'**
  String get writeLetterSnackRecipient;

  /// No description provided for @writeLetterSnackEmotion.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escolha o estado emocional!'**
  String get writeLetterSnackEmotion;

  /// No description provided for @writeLetterSnackSentFriend.
  ///
  /// In pt_BR, this message translates to:
  /// **'Carta enviada! 💌'**
  String get writeLetterSnackSentFriend;

  /// No description provided for @writeLetterSnackSentPending.
  ///
  /// In pt_BR, this message translates to:
  /// **'Carta enviada! Aguardando aprovação. 💌'**
  String get writeLetterSnackSentPending;

  /// No description provided for @writeLetterSnackSentExternal.
  ///
  /// In pt_BR, this message translates to:
  /// **'Carta criada! Compartilhe o link com o destinatário. 💌'**
  String get writeLetterSnackSentExternal;

  /// No description provided for @writeLetterSnackEmailInvalid.
  ///
  /// In pt_BR, this message translates to:
  /// **'Insira um email válido (ex: nome@exemplo.com)'**
  String get writeLetterSnackEmailInvalid;

  /// No description provided for @writeLetterSnackStorageError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ative o Firebase Storage para usar esta função'**
  String get writeLetterSnackStorageError;

  /// No description provided for @writeLetterMusicUrlLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Link da música (opcional)'**
  String get writeLetterMusicUrlLabel;

  /// No description provided for @writeLetterMusicUrlHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'https://open.spotify.com/...'**
  String get writeLetterMusicUrlHint;

  /// No description provided for @writeLetterSnackMusicUrlInvalid.
  ///
  /// In pt_BR, this message translates to:
  /// **'Use um link https:// válido para a música.'**
  String get writeLetterSnackMusicUrlInvalid;

  /// No description provided for @writeLetterMessageTapToExpand.
  ///
  /// In pt_BR, this message translates to:
  /// **'Toque para escrever sua mensagem'**
  String get writeLetterMessageTapToExpand;

  /// No description provided for @writeLetterVoiceSection.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mensagem de voz (opcional)'**
  String get writeLetterVoiceSection;

  /// No description provided for @writeLetterVoiceRecord.
  ///
  /// In pt_BR, this message translates to:
  /// **'Gravar'**
  String get writeLetterVoiceRecord;

  /// No description provided for @writeLetterVoiceStop.
  ///
  /// In pt_BR, this message translates to:
  /// **'Parar'**
  String get writeLetterVoiceStop;

  /// No description provided for @writeLetterVoiceDiscard.
  ///
  /// In pt_BR, this message translates to:
  /// **'Descartar áudio'**
  String get writeLetterVoiceDiscard;

  /// No description provided for @writeLetterVoicePreview.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ouvir prévia'**
  String get writeLetterVoicePreview;

  /// No description provided for @writeLetterVoiceMaxDuration.
  ///
  /// In pt_BR, this message translates to:
  /// **'O limite é 1 minuto.'**
  String get writeLetterVoiceMaxDuration;

  /// No description provided for @writeLetterVoicePermissionDenied.
  ///
  /// In pt_BR, this message translates to:
  /// **'Permissão do microfone necessária para gravar.'**
  String get writeLetterVoicePermissionDenied;

  /// No description provided for @writeLetterVoiceOpenSettings.
  ///
  /// In pt_BR, this message translates to:
  /// **'Abrir configurações'**
  String get writeLetterVoiceOpenSettings;

  /// No description provided for @writeLetterVoiceWillSend.
  ///
  /// In pt_BR, this message translates to:
  /// **'Será enviada com a carta'**
  String get writeLetterVoiceWillSend;

  /// No description provided for @writeLetterVoiceUploadError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível enviar o áudio. Tente de novo.'**
  String get writeLetterVoiceUploadError;

  /// No description provided for @writeLetterSendErrorEmailLookup.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível verificar o email do destinatário. Verifique sua conexão e tente novamente.'**
  String get writeLetterSendErrorEmailLookup;

  /// No description provided for @writeLetterSendErrorLoadProfile.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível carregar o seu perfil. Tente novamente.'**
  String get writeLetterSendErrorLoadProfile;

  /// No description provided for @writeLetterSendErrorFriendshipCheck.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível verificar amizade. Tente novamente.'**
  String get writeLetterSendErrorFriendshipCheck;

  /// No description provided for @writeLetterSendErrorSave.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível salvar a carta. Tente novamente.'**
  String get writeLetterSendErrorSave;

  /// No description provided for @writeLetterSendErrorUnexpected.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ocorreu um erro ao enviar. Tente novamente.'**
  String get writeLetterSendErrorUnexpected;

  /// No description provided for @voiceLetterTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mensagem de voz'**
  String get voiceLetterTitle;

  /// No description provided for @voiceLetterSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Gravada pelo remetente'**
  String get voiceLetterSubtitle;

  /// No description provided for @voiceLetterPlay.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ouvir'**
  String get voiceLetterPlay;

  /// No description provided for @voiceLetterPause.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pausar'**
  String get voiceLetterPause;

  /// No description provided for @voiceLetterPlayError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível reproduzir o áudio.'**
  String get voiceLetterPlayError;

  /// No description provided for @musicLinkTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ouvir música'**
  String get musicLinkTitle;

  /// No description provided for @musicLinkSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Abre no app ou no navegador'**
  String get musicLinkSubtitle;

  /// No description provided for @musicLinkOpenError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível abrir este link.'**
  String get musicLinkOpenError;

  /// No description provided for @letterDetailHeaderFrom.
  ///
  /// In pt_BR, this message translates to:
  /// **'UMA CARTA DE'**
  String get letterDetailHeaderFrom;

  /// No description provided for @letterDetailTo.
  ///
  /// In pt_BR, this message translates to:
  /// **'para {name}'**
  String letterDetailTo(String name);

  /// No description provided for @letterDetailWrittenOn.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escrita {date}'**
  String letterDetailWrittenOn(String date);

  /// No description provided for @letterDetailOpenedOn.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aberta {date}'**
  String letterDetailOpenedOn(String date);

  /// No description provided for @letterDetailQrTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Gerar QR Code'**
  String get letterDetailQrTitle;

  /// No description provided for @letterDetailQrSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Coloque no presente físico 🎁'**
  String get letterDetailQrSubtitle;

  /// No description provided for @letterDetailShareTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Compartilhar carta'**
  String get letterDetailShareTitle;

  /// No description provided for @letterDetailShareSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Instagram Stories ou folha de partilha'**
  String get letterDetailShareSubtitle;

  /// No description provided for @storyShareFallbackSnack.
  ///
  /// In pt_BR, this message translates to:
  /// **'Folha de partilha aberta — escolha o Instagram ou outra app.'**
  String get storyShareFallbackSnack;

  /// No description provided for @storyShareSheetTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Compartilhar cápsula'**
  String get storyShareSheetTitle;

  /// No description provided for @storyShareInstagramOption.
  ///
  /// In pt_BR, this message translates to:
  /// **'Instagram Stories'**
  String get storyShareInstagramOption;

  /// No description provided for @storyShareTextOption.
  ///
  /// In pt_BR, this message translates to:
  /// **'Texto (perguntas e respostas)'**
  String get storyShareTextOption;

  /// No description provided for @letterOpeningEmotionLove.
  ///
  /// In pt_BR, this message translates to:
  /// **'Uma carta de amor espera por você 💕'**
  String get letterOpeningEmotionLove;

  /// No description provided for @letterOpeningEmotionAchievement.
  ///
  /// In pt_BR, this message translates to:
  /// **'Uma conquista foi guardada para você 🏆'**
  String get letterOpeningEmotionAchievement;

  /// No description provided for @letterOpeningEmotionAdvice.
  ///
  /// In pt_BR, this message translates to:
  /// **'Um conselho especial espera por você 🌿'**
  String get letterOpeningEmotionAdvice;

  /// No description provided for @letterOpeningEmotionNostalgia.
  ///
  /// In pt_BR, this message translates to:
  /// **'Memórias guardadas para você 🍂'**
  String get letterOpeningEmotionNostalgia;

  /// No description provided for @letterOpeningEmotionFarewell.
  ///
  /// In pt_BR, this message translates to:
  /// **'Palavras de despedida esperaram por você 🦋'**
  String get letterOpeningEmotionFarewell;

  /// No description provided for @letterOpeningWrittenOpenedToday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escrita {date}  ·  Aberta hoje'**
  String letterOpeningWrittenOpenedToday(String date);

  /// No description provided for @letterOpeningPublishFeed.
  ///
  /// In pt_BR, this message translates to:
  /// **'✦  Publicar no feed'**
  String get letterOpeningPublishFeed;

  /// No description provided for @letterOpeningKeepPrivate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Guardar só para mim'**
  String get letterOpeningKeepPrivate;

  /// No description provided for @letterOpeningTapToOpen.
  ///
  /// In pt_BR, this message translates to:
  /// **'TOQUE PARA ABRIR'**
  String get letterOpeningTapToOpen;

  /// No description provided for @requestsTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pedidos de carta'**
  String get requestsTitle;

  /// No description provided for @requestsSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'De pessoas que você não segue'**
  String get requestsSubtitle;

  /// No description provided for @requestsEmptyTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum pedido pendente'**
  String get requestsEmptyTitle;

  /// No description provided for @requestsEmptySubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quando alguém que você não segue\nte enviar uma carta, aparecerá aqui.'**
  String get requestsEmptySubtitle;

  /// No description provided for @requestsSheetTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que deseja fazer?'**
  String get requestsSheetTitle;

  /// No description provided for @requestsSheetLetterFrom.
  ///
  /// In pt_BR, this message translates to:
  /// **'Carta de {name}'**
  String requestsSheetLetterFrom(String name);

  /// No description provided for @requestsAccept.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aceitar carta'**
  String get requestsAccept;

  /// No description provided for @requestsDecline.
  ///
  /// In pt_BR, this message translates to:
  /// **'Recusar carta'**
  String get requestsDecline;

  /// No description provided for @requestsBlockUser.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bloquear {name}'**
  String requestsBlockUser(String name);

  /// No description provided for @requestsSnackAccepted.
  ///
  /// In pt_BR, this message translates to:
  /// **'Carta aceita! Ela aparecerá no seu cofre. 💌'**
  String get requestsSnackAccepted;

  /// No description provided for @requestsSnackDeclined.
  ///
  /// In pt_BR, this message translates to:
  /// **'Carta recusada.'**
  String get requestsSnackDeclined;

  /// No description provided for @requestsSnackBlocked.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usuário bloqueado.'**
  String get requestsSnackBlocked;

  /// No description provided for @requestsSenderNotFollowing.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pessoa que você não segue'**
  String get requestsSenderNotFollowing;

  /// No description provided for @requestsBadgePending.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pendente'**
  String get requestsBadgePending;

  /// No description provided for @requestsRevealHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aceite para revelar a mensagem'**
  String get requestsRevealHint;

  /// No description provided for @requestsOpensOn.
  ///
  /// In pt_BR, this message translates to:
  /// **'Abre em {date}'**
  String requestsOpensOn(String date);

  /// No description provided for @requestsViewOptions.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ver opções'**
  String get requestsViewOptions;

  /// No description provided for @qrScreenTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'QR Code da carta'**
  String get qrScreenTitle;

  /// No description provided for @qrScreenSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Imprima e coloque no presente'**
  String get qrScreenSubtitle;

  /// No description provided for @qrCardHeadline.
  ///
  /// In pt_BR, this message translates to:
  /// **'Uma carta especial espera por você'**
  String get qrCardHeadline;

  /// No description provided for @qrCardMeta.
  ///
  /// In pt_BR, this message translates to:
  /// **'De {sender}  ·  Abre {date}'**
  String qrCardMeta(String sender, String date);

  /// No description provided for @qrScanHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escaneie para acessar a carta'**
  String get qrScanHint;

  /// No description provided for @qrHowToTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como usar no presente físico'**
  String get qrHowToTitle;

  /// No description provided for @qrStep1.
  ///
  /// In pt_BR, this message translates to:
  /// **'Compartilhe o QR Code pelo WhatsApp ou imprima'**
  String get qrStep1;

  /// No description provided for @qrStep2.
  ///
  /// In pt_BR, this message translates to:
  /// **'Coloque dentro ou na embalagem do presente'**
  String get qrStep2;

  /// No description provided for @qrStep3.
  ///
  /// In pt_BR, this message translates to:
  /// **'A pessoa escaneia e descobre a carta'**
  String get qrStep3;

  /// No description provided for @qrStep4.
  ///
  /// In pt_BR, this message translates to:
  /// **'A carta abre automaticamente na data certa'**
  String get qrStep4;

  /// No description provided for @qrLinkCopied.
  ///
  /// In pt_BR, this message translates to:
  /// **'Link copiado! 🔗'**
  String get qrLinkCopied;

  /// No description provided for @qrShareText.
  ///
  /// In pt_BR, this message translates to:
  /// **'💌 Uma carta especial espera por você no OpenWhen!\n\n\"{title}\"\n\nEscaneie o QR Code ou acesse: {link}'**
  String qrShareText(String title, String link);

  /// No description provided for @qrShareSubject.
  ///
  /// In pt_BR, this message translates to:
  /// **'Uma carta especial espera por você 💌'**
  String get qrShareSubject;

  /// No description provided for @qrShareLinkOnly.
  ///
  /// In pt_BR, this message translates to:
  /// **'💌 Uma carta especial espera por você no OpenWhen!\n\n\"{title}\"\n\nAcesse: {link}'**
  String qrShareLinkOnly(String title, String link);

  /// No description provided for @qrShareWhatsApp.
  ///
  /// In pt_BR, this message translates to:
  /// **'💌 Uma carta especial espera por você!\n\n\"{title}\"\n\nAbra aqui: {link}'**
  String qrShareWhatsApp(String title, String link);

  /// No description provided for @createCapsuleTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nova Cápsula do Tempo'**
  String get createCapsuleTitle;

  /// No description provided for @createCapsuleStepProgress.
  ///
  /// In pt_BR, this message translates to:
  /// **'Passo {current} de 3 — {stepName}'**
  String createCapsuleStepProgress(int current, String stepName);

  /// No description provided for @createCapsuleStepTheme.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tema'**
  String get createCapsuleStepTheme;

  /// No description provided for @createCapsuleStepMessage.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mensagem'**
  String get createCapsuleStepMessage;

  /// No description provided for @createCapsuleStepWhen.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quando abrir'**
  String get createCapsuleStepWhen;

  /// No description provided for @createCapsuleSeal.
  ///
  /// In pt_BR, this message translates to:
  /// **'Selar Cápsula 🦉'**
  String get createCapsuleSeal;

  /// No description provided for @createCapsuleThemeQuestion.
  ///
  /// In pt_BR, this message translates to:
  /// **'Qual é a essência\ndessa cápsula?'**
  String get createCapsuleThemeQuestion;

  /// No description provided for @createCapsuleThemeHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escolha um tema para sua cápsula.'**
  String get createCapsuleThemeHint;

  /// No description provided for @createCapsuleAudienceTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Esta cápsula é para quem?'**
  String get createCapsuleAudienceTitle;

  /// No description provided for @createCapsuleAudiencePersonal.
  ///
  /// In pt_BR, this message translates to:
  /// **'Só para mim'**
  String get createCapsuleAudiencePersonal;

  /// No description provided for @createCapsuleAudienceCollective.
  ///
  /// In pt_BR, this message translates to:
  /// **'Coletiva'**
  String get createCapsuleAudienceCollective;

  /// No description provided for @createCapsuleCollectiveHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Convide quem vai abrir esta cápsula consigo na mesma data. Só você escreve o conteúdo.'**
  String get createCapsuleCollectiveHint;

  /// No description provided for @createCapsuleInviteSearchHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Busque por nome ou @usuário'**
  String get createCapsuleInviteSearchHint;

  /// No description provided for @createCapsuleCollectiveNeedInvite.
  ///
  /// In pt_BR, this message translates to:
  /// **'Adicione pelo menos uma pessoa para uma cápsula coletiva.'**
  String get createCapsuleCollectiveNeedInvite;

  /// No description provided for @createCapsuleMaxParticipants.
  ///
  /// In pt_BR, this message translates to:
  /// **'Uma cápsula pode ter no máximo {max} pessoas (incluindo você).'**
  String createCapsuleMaxParticipants(int max);

  /// No description provided for @vaultCapsuleCollectiveBadge.
  ///
  /// In pt_BR, this message translates to:
  /// **'Coletiva'**
  String get vaultCapsuleCollectiveBadge;

  /// No description provided for @capsuleDetailParticipantsHeading.
  ///
  /// In pt_BR, this message translates to:
  /// **'Junto com'**
  String get capsuleDetailParticipantsHeading;

  /// No description provided for @createCapsuleThemeMemoriesLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Memórias'**
  String get createCapsuleThemeMemoriesLabel;

  /// No description provided for @createCapsuleThemeMemoriesSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Guarde o que não quer esquecer'**
  String get createCapsuleThemeMemoriesSubtitle;

  /// No description provided for @createCapsuleThemeGoalsLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Metas'**
  String get createCapsuleThemeGoalsLabel;

  /// No description provided for @createCapsuleThemeGoalsSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Uma promessa para o futuro'**
  String get createCapsuleThemeGoalsSubtitle;

  /// No description provided for @createCapsuleThemeFeelingsLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sentimentos'**
  String get createCapsuleThemeFeelingsLabel;

  /// No description provided for @createCapsuleThemeFeelingsSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que está dentro de você agora'**
  String get createCapsuleThemeFeelingsSubtitle;

  /// No description provided for @createCapsuleThemeRelationshipsLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Relacionamentos'**
  String get createCapsuleThemeRelationshipsLabel;

  /// No description provided for @createCapsuleThemeRelationshipsSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'As pessoas que importam'**
  String get createCapsuleThemeRelationshipsSubtitle;

  /// No description provided for @createCapsuleThemeGrowthLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Crescimento'**
  String get createCapsuleThemeGrowthLabel;

  /// No description provided for @createCapsuleThemeGrowthSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quem você está se tornando'**
  String get createCapsuleThemeGrowthSubtitle;

  /// No description provided for @createCapsuleWriteHeading.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escreva para o\nseu eu do futuro'**
  String get createCapsuleWriteHeading;

  /// No description provided for @createCapsuleWriteHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escreva livremente. Sem regras. Só você e o futuro.'**
  String get createCapsuleWriteHint;

  /// No description provided for @createCapsuleFieldTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Título'**
  String get createCapsuleFieldTitle;

  /// No description provided for @createCapsuleFieldTitleHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ex: Para o meu eu de daqui a 1 ano...'**
  String get createCapsuleFieldTitleHint;

  /// No description provided for @createCapsuleMusicUrlLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Link da música (opcional)'**
  String get createCapsuleMusicUrlLabel;

  /// No description provided for @createCapsuleMusicUrlHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'https://music.youtube.com/...'**
  String get createCapsuleMusicUrlHint;

  /// No description provided for @createCapsuleFieldMessageHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Querido eu do futuro...\n\nEscreva o que está sentindo, o que sonha, o que quer lembrar...'**
  String get createCapsuleFieldMessageHint;

  /// No description provided for @createCapsuleCharCount.
  ///
  /// In pt_BR, this message translates to:
  /// **'{count} caracteres'**
  String createCapsuleCharCount(int count);

  /// No description provided for @createCapsuleCharMin.
  ///
  /// In pt_BR, this message translates to:
  /// **' (mínimo 10)'**
  String get createCapsuleCharMin;

  /// No description provided for @createCapsuleWhenHeading.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quando você\npoderá abrir?'**
  String get createCapsuleWhenHeading;

  /// No description provided for @createCapsuleWhenHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escolha uma data ou evento especial.'**
  String get createCapsuleWhenHint;

  /// No description provided for @createCapsuleTypeDate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Data'**
  String get createCapsuleTypeDate;

  /// No description provided for @createCapsuleTypeEvent.
  ///
  /// In pt_BR, this message translates to:
  /// **'Evento'**
  String get createCapsuleTypeEvent;

  /// No description provided for @createCapsuleTypeBoth.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ambos'**
  String get createCapsuleTypeBoth;

  /// No description provided for @createCapsulePickDate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escolher data'**
  String get createCapsulePickDate;

  /// No description provided for @createCapsuleCustomEventHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ou descreva o evento...'**
  String get createCapsuleCustomEventHint;

  /// No description provided for @createCapsulePublishToggle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Publicar no feed ao abrir'**
  String get createCapsulePublishToggle;

  /// No description provided for @createCapsulePublishHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Você decide depois de rever tudo'**
  String get createCapsulePublishHint;

  /// No description provided for @createCapsuleSuccessTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cápsula selada!'**
  String get createCapsuleSuccessTitle;

  /// No description provided for @createCapsuleSuccessBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Suas palavras estão guardadas.\nSó você poderá abrir na hora certa.'**
  String get createCapsuleSuccessBody;

  /// No description provided for @createCapsuleSuccessViewVault.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ver meu Cofre'**
  String get createCapsuleSuccessViewVault;

  /// No description provided for @createCapsulePresetBirthday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Meu aniversário'**
  String get createCapsulePresetBirthday;

  /// No description provided for @createCapsulePresetAnniversary.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nosso aniversário'**
  String get createCapsulePresetAnniversary;

  /// No description provided for @createCapsulePresetGraduation.
  ///
  /// In pt_BR, this message translates to:
  /// **'Minha formatura'**
  String get createCapsulePresetGraduation;

  /// No description provided for @createCapsulePresetBaby.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nascimento do bebê'**
  String get createCapsulePresetBaby;

  /// No description provided for @createCapsulePresetMoving.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nossa mudança'**
  String get createCapsulePresetMoving;

  /// No description provided for @createCapsulePresetTrip.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fim da viagem'**
  String get createCapsulePresetTrip;

  /// No description provided for @createCapsulePresetCareer.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nova fase profissional'**
  String get createCapsulePresetCareer;

  /// No description provided for @createCapsulePresetChristmas.
  ///
  /// In pt_BR, this message translates to:
  /// **'Natal'**
  String get createCapsulePresetChristmas;

  /// No description provided for @createCapsulePresetNewYear.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ano Novo'**
  String get createCapsulePresetNewYear;

  /// No description provided for @capsuleDetailYourCapsule.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sua capsula'**
  String get capsuleDetailYourCapsule;

  /// No description provided for @capsuleDetailDates.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criada em {createdDate}  ·  Aberta em {openedDate}'**
  String capsuleDetailDates(String createdDate, String openedDate);

  /// No description provided for @capsuleDetailOnFeed.
  ///
  /// In pt_BR, this message translates to:
  /// **'No feed'**
  String get capsuleDetailOnFeed;

  /// No description provided for @capsuleDetailShareSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Instagram Stories ou folha de partilha'**
  String get capsuleDetailShareSubtitle;

  /// No description provided for @capsuleDetailDeleteTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Excluir capsula'**
  String get capsuleDetailDeleteTitle;

  /// No description provided for @capsuleDetailDeleteSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Remove do cofre permanentemente'**
  String get capsuleDetailDeleteSubtitle;

  /// No description provided for @capsuleDetailDeleteConfirm.
  ///
  /// In pt_BR, this message translates to:
  /// **'Excluir capsula?'**
  String get capsuleDetailDeleteConfirm;

  /// No description provided for @capsuleDetailDeleteBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Esta acao nao pode ser desfeita.'**
  String get capsuleDetailDeleteBody;

  /// No description provided for @capsuleOpeningHeader.
  ///
  /// In pt_BR, this message translates to:
  /// **'CAPSULA DO TEMPO'**
  String get capsuleOpeningHeader;

  /// No description provided for @capsuleOpeningThemeMemories.
  ///
  /// In pt_BR, this message translates to:
  /// **'Memorias guardadas para o futuro'**
  String get capsuleOpeningThemeMemories;

  /// No description provided for @capsuleOpeningThemeGoals.
  ///
  /// In pt_BR, this message translates to:
  /// **'Suas metas esperam por voce'**
  String get capsuleOpeningThemeGoals;

  /// No description provided for @capsuleOpeningThemeFeelings.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que voce sentiu, guardado aqui'**
  String get capsuleOpeningThemeFeelings;

  /// No description provided for @capsuleOpeningThemeRelationships.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conexoes que importam'**
  String get capsuleOpeningThemeRelationships;

  /// No description provided for @capsuleOpeningThemeGrowth.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quem voce esta se tornando'**
  String get capsuleOpeningThemeGrowth;

  /// No description provided for @capsuleOpeningPublishFeed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Publicar no feed'**
  String get capsuleOpeningPublishFeed;

  /// No description provided for @capsuleOpeningKeepPrivate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Guardar so para mim'**
  String get capsuleOpeningKeepPrivate;

  /// No description provided for @capsuleOpeningTapToOpen.
  ///
  /// In pt_BR, this message translates to:
  /// **'TOQUE PARA ABRIR'**
  String get capsuleOpeningTapToOpen;

  /// No description provided for @profileTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Perfil'**
  String get profileTitle;

  /// No description provided for @profilePrivate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Privada'**
  String get profilePrivate;

  /// No description provided for @profilePublic.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pública'**
  String get profilePublic;

  /// No description provided for @profileDefaultName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usuário'**
  String get profileDefaultName;

  /// No description provided for @profileStatFollowers.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seguidores'**
  String get profileStatFollowers;

  /// No description provided for @profileStatFollowing.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seguindo'**
  String get profileStatFollowing;

  /// No description provided for @profileStatSent.
  ///
  /// In pt_BR, this message translates to:
  /// **'Enviadas'**
  String get profileStatSent;

  /// No description provided for @profileStatOpened.
  ///
  /// In pt_BR, this message translates to:
  /// **'Abertas'**
  String get profileStatOpened;

  /// No description provided for @profileBadgesTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'CONQUISTAS'**
  String get profileBadgesTitle;

  /// No description provided for @badgeFirstLetterSentTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Primeira carta'**
  String get badgeFirstLetterSentTitle;

  /// No description provided for @badgeFirstLetterSentDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Você enviou sua primeira carta.'**
  String get badgeFirstLetterSentDesc;

  /// No description provided for @badgeFirstLetterOpenedTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Primeira abertura'**
  String get badgeFirstLetterOpenedTitle;

  /// No description provided for @badgeFirstLetterOpenedDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Você abriu sua primeira carta.'**
  String get badgeFirstLetterOpenedDesc;

  /// No description provided for @badgeFirstPublicTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Primeira no feed'**
  String get badgeFirstPublicTitle;

  /// No description provided for @badgeFirstPublicDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Você compartilhou uma carta no feed público.'**
  String get badgeFirstPublicDesc;

  /// No description provided for @badgeLettersSentFiveTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'5 cartas'**
  String get badgeLettersSentFiveTitle;

  /// No description provided for @badgeLettersSentFiveDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Você enviou 5 cartas.'**
  String get badgeLettersSentFiveDesc;

  /// No description provided for @badgeLettersSentTenTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'10 cartas'**
  String get badgeLettersSentTenTitle;

  /// No description provided for @badgeLettersSentTenDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Você enviou 10 cartas.'**
  String get badgeLettersSentTenDesc;

  /// No description provided for @badgeVoiceLetterTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Voz'**
  String get badgeVoiceLetterTitle;

  /// No description provided for @badgeVoiceLetterDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Você enviou uma carta com áudio.'**
  String get badgeVoiceLetterDesc;

  /// No description provided for @profileStatLetters.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cartas'**
  String get profileStatLetters;

  /// No description provided for @profileEmptyTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhuma carta publicada'**
  String get profileEmptyTitle;

  /// No description provided for @profileEmptySubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Suas cartas abertas e publicas\naparecera aqui'**
  String get profileEmptySubtitle;

  /// No description provided for @editProfileTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Editar perfil'**
  String get editProfileTitle;

  /// No description provided for @editProfileSectionName.
  ///
  /// In pt_BR, this message translates to:
  /// **'NOME'**
  String get editProfileSectionName;

  /// No description provided for @editProfileSectionUsername.
  ///
  /// In pt_BR, this message translates to:
  /// **'USERNAME'**
  String get editProfileSectionUsername;

  /// No description provided for @editProfileSectionBio.
  ///
  /// In pt_BR, this message translates to:
  /// **'BIO'**
  String get editProfileSectionBio;

  /// No description provided for @editProfileHintName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seu nome completo'**
  String get editProfileHintName;

  /// No description provided for @editProfileHintUsername.
  ///
  /// In pt_BR, this message translates to:
  /// **'seu_username'**
  String get editProfileHintUsername;

  /// No description provided for @editProfileHintBio.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conte um pouco sobre voce...'**
  String get editProfileHintBio;

  /// No description provided for @editProfileUsernameRules.
  ///
  /// In pt_BR, this message translates to:
  /// **'Apenas letras, numeros e _'**
  String get editProfileUsernameRules;

  /// No description provided for @editProfileSaveChanges.
  ///
  /// In pt_BR, this message translates to:
  /// **'Salvar alteracoes'**
  String get editProfileSaveChanges;

  /// No description provided for @editProfileErrorNameEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nome nao pode ser vazio'**
  String get editProfileErrorNameEmpty;

  /// No description provided for @editProfileErrorUsernameEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Username nao pode ser vazio'**
  String get editProfileErrorUsernameEmpty;

  /// No description provided for @editProfileErrorUsernameShort.
  ///
  /// In pt_BR, this message translates to:
  /// **'Username deve ter pelo menos 3 caracteres'**
  String get editProfileErrorUsernameShort;

  /// No description provided for @editProfileErrorUsernameTaken.
  ///
  /// In pt_BR, this message translates to:
  /// **'Este username ja esta em uso'**
  String get editProfileErrorUsernameTaken;

  /// No description provided for @editProfileSaved.
  ///
  /// In pt_BR, this message translates to:
  /// **'Perfil atualizado!'**
  String get editProfileSaved;

  /// No description provided for @userProfileFollowing.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seguindo'**
  String get userProfileFollowing;

  /// No description provided for @userProfileFollow.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seguir'**
  String get userProfileFollow;

  /// No description provided for @userProfileActionSendLetter.
  ///
  /// In pt_BR, this message translates to:
  /// **'Carta'**
  String get userProfileActionSendLetter;

  /// No description provided for @userProfileEmptyLetters.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhuma carta pública ainda'**
  String get userProfileEmptyLetters;

  /// No description provided for @searchTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Buscar pessoas'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Buscar por nome ou @username...'**
  String get searchHint;

  /// No description provided for @searchEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum resultado'**
  String get searchEmpty;

  /// No description provided for @searchMinCharsHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Digite pelo menos 2 caracteres para buscar'**
  String get searchMinCharsHint;

  /// No description provided for @settingsTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Configurações'**
  String get settingsTitle;

  /// No description provided for @themeSection.
  ///
  /// In pt_BR, this message translates to:
  /// **'TEMA DO APP'**
  String get themeSection;

  /// No description provided for @themeSystem.
  ///
  /// In pt_BR, this message translates to:
  /// **'Automático (sistema)'**
  String get themeSystem;

  /// No description provided for @themeSystemSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Claro ou escuro conforme o aparelho'**
  String get themeSystemSubtitle;

  /// No description provided for @themeClassic.
  ///
  /// In pt_BR, this message translates to:
  /// **'Clássico'**
  String get themeClassic;

  /// No description provided for @themeClassicSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fundo claro e destaque vermelho'**
  String get themeClassicSubtitle;

  /// No description provided for @themeDark.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escuro'**
  String get themeDark;

  /// No description provided for @themeDarkSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Interface escura confortável'**
  String get themeDarkSubtitle;

  /// No description provided for @themeMidnight.
  ///
  /// In pt_BR, this message translates to:
  /// **'Midnight'**
  String get themeMidnight;

  /// No description provided for @themeMidnightSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Azul profundo'**
  String get themeMidnightSubtitle;

  /// No description provided for @themeSepia.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sépia'**
  String get themeSepia;

  /// No description provided for @themeSepiaSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tons quentes no papel'**
  String get themeSepiaSubtitle;

  /// No description provided for @languageSection.
  ///
  /// In pt_BR, this message translates to:
  /// **'IDIOMA'**
  String get languageSection;

  /// No description provided for @languageSystem.
  ///
  /// In pt_BR, this message translates to:
  /// **'Automático (sistema)'**
  String get languageSystem;

  /// No description provided for @languageSystemSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usa o idioma do aparelho (pt, en ou es)'**
  String get languageSystemSubtitle;

  /// No description provided for @languagePt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Português (Brasil)'**
  String get languagePt;

  /// No description provided for @languageEn.
  ///
  /// In pt_BR, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @languageEs.
  ///
  /// In pt_BR, this message translates to:
  /// **'Español'**
  String get languageEs;

  /// No description provided for @activeLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ativo'**
  String get activeLabel;

  /// No description provided for @settingsMyAccount.
  ///
  /// In pt_BR, this message translates to:
  /// **'MINHA CONTA'**
  String get settingsMyAccount;

  /// No description provided for @settingsProfilePhoto.
  ///
  /// In pt_BR, this message translates to:
  /// **'Foto de perfil'**
  String get settingsProfilePhoto;

  /// No description provided for @settingsProfilePhotoSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Galeria ou remover'**
  String get settingsProfilePhotoSubtitle;

  /// No description provided for @avatarChooseFromGallery.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escolher da galeria'**
  String get avatarChooseFromGallery;

  /// No description provided for @avatarRemovePhoto.
  ///
  /// In pt_BR, this message translates to:
  /// **'Remover foto'**
  String get avatarRemovePhoto;

  /// No description provided for @avatarPhotoRemovedSnack.
  ///
  /// In pt_BR, this message translates to:
  /// **'Foto removida'**
  String get avatarPhotoRemovedSnack;

  /// No description provided for @avatarPhotoUpdatedSnack.
  ///
  /// In pt_BR, this message translates to:
  /// **'Foto de perfil atualizada'**
  String get avatarPhotoUpdatedSnack;

  /// No description provided for @avatarUploadError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível enviar a foto: {error}'**
  String avatarUploadError(String error);

  /// No description provided for @settingsNotifPermissionStatus.
  ///
  /// In pt_BR, this message translates to:
  /// **'Status: {status}'**
  String settingsNotifPermissionStatus(String status);

  /// No description provided for @qrFooterBrand.
  ///
  /// In pt_BR, this message translates to:
  /// **'openwhen.live'**
  String get qrFooterBrand;

  /// No description provided for @qrShareWhatsAppLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'WhatsApp'**
  String get qrShareWhatsAppLabel;

  /// No description provided for @settingsEditProfile.
  ///
  /// In pt_BR, this message translates to:
  /// **'Editar perfil'**
  String get settingsEditProfile;

  /// No description provided for @settingsChangePassword.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alterar senha'**
  String get settingsChangePassword;

  /// No description provided for @settingsPrivacySection.
  ///
  /// In pt_BR, this message translates to:
  /// **'PRIVACIDADE E SEGURANÇA'**
  String get settingsPrivacySection;

  /// No description provided for @settingsPrivateAccount.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conta privada'**
  String get settingsPrivateAccount;

  /// No description provided for @settingsPrivateAccountOn.
  ///
  /// In pt_BR, this message translates to:
  /// **'Suas cartas não aparecem no feed'**
  String get settingsPrivateAccountOn;

  /// No description provided for @settingsPrivateAccountOff.
  ///
  /// In pt_BR, this message translates to:
  /// **'Suas cartas podem aparecer no feed'**
  String get settingsPrivateAccountOff;

  /// No description provided for @settingsBlockedUsers.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usuários bloqueados'**
  String get settingsBlockedUsers;

  /// No description provided for @settingsWhoCanSend.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quem pode me enviar cartas'**
  String get settingsWhoCanSend;

  /// No description provided for @settingsWhoCanSendValue.
  ///
  /// In pt_BR, this message translates to:
  /// **'Todos'**
  String get settingsWhoCanSendValue;

  /// No description provided for @settingsNotificationsSection.
  ///
  /// In pt_BR, this message translates to:
  /// **'NOTIFICAÇÕES'**
  String get settingsNotificationsSection;

  /// No description provided for @settingsNotifSystemAlert.
  ///
  /// In pt_BR, this message translates to:
  /// **'Permissões de alerta (sistema)'**
  String get settingsNotifSystemAlert;

  /// No description provided for @settingsNotifSystemAlertSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Necessário para receber push no celular'**
  String get settingsNotifSystemAlertSubtitle;

  /// No description provided for @settingsNotifUpdated.
  ///
  /// In pt_BR, this message translates to:
  /// **'Permissões de notificação atualizadas.'**
  String get settingsNotifUpdated;

  /// No description provided for @settingsNotifLikes.
  ///
  /// In pt_BR, this message translates to:
  /// **'Curtidas'**
  String get settingsNotifLikes;

  /// No description provided for @settingsNotifLikesSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quando alguém curtir sua carta'**
  String get settingsNotifLikesSubtitle;

  /// No description provided for @settingsNotifComments.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comentários'**
  String get settingsNotifComments;

  /// No description provided for @settingsNotifCommentsSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quando alguém comentar sua carta'**
  String get settingsNotifCommentsSubtitle;

  /// No description provided for @settingsNotifFollowers.
  ///
  /// In pt_BR, this message translates to:
  /// **'Novos seguidores'**
  String get settingsNotifFollowers;

  /// No description provided for @settingsNotifFollowersSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quando alguém começar a te seguir'**
  String get settingsNotifFollowersSubtitle;

  /// No description provided for @settingsNotifLetterUnlocked.
  ///
  /// In pt_BR, this message translates to:
  /// **'Carta desbloqueada'**
  String get settingsNotifLetterUnlocked;

  /// No description provided for @settingsNotifLetterUnlockedSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quando uma carta estiver pronta para abrir'**
  String get settingsNotifLetterUnlockedSubtitle;

  /// No description provided for @settingsDataSection.
  ///
  /// In pt_BR, this message translates to:
  /// **'DADOS E PRIVACIDADE'**
  String get settingsDataSection;

  /// No description provided for @settingsExportLetters.
  ///
  /// In pt_BR, this message translates to:
  /// **'Exportar minhas cartas'**
  String get settingsExportLetters;

  /// No description provided for @settingsExportLettersSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'PDF ou zip com todas as cartas abertas'**
  String get settingsExportLettersSubtitle;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In pt_BR, this message translates to:
  /// **'Deletar conta'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsDeleteAccountSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Esta ação é irreversível'**
  String get settingsDeleteAccountSubtitle;

  /// No description provided for @settingsLegalSection.
  ///
  /// In pt_BR, this message translates to:
  /// **'LEGAL E SUPORTE'**
  String get settingsLegalSection;

  /// No description provided for @settingsTerms.
  ///
  /// In pt_BR, this message translates to:
  /// **'Termos de uso'**
  String get settingsTerms;

  /// No description provided for @settingsPrivacy.
  ///
  /// In pt_BR, this message translates to:
  /// **'Política de privacidade'**
  String get settingsPrivacy;

  /// No description provided for @settingsHelp.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ajuda e suporte'**
  String get settingsHelp;

  /// No description provided for @settingsAbout.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sobre o OpenWhen'**
  String get settingsAbout;

  /// No description provided for @settingsAboutVersion.
  ///
  /// In pt_BR, this message translates to:
  /// **'Versão 1.0.0'**
  String get settingsAboutVersion;

  /// No description provided for @settingsLogout.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sair da conta'**
  String get settingsLogout;

  /// No description provided for @settingsLogoutTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sair da conta'**
  String get settingsLogoutTitle;

  /// No description provided for @settingsLogoutConfirmMessage.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tem certeza que deseja sair?'**
  String get settingsLogoutConfirmMessage;

  /// No description provided for @settingsLogoutConfirmButton.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sair'**
  String get settingsLogoutConfirmButton;

  /// No description provided for @settingsEditProfileSheetTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Editar perfil'**
  String get settingsEditProfileSheetTitle;

  /// No description provided for @settingsEditProfileFieldName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nome'**
  String get settingsEditProfileFieldName;

  /// No description provided for @settingsEditProfileFieldUsername.
  ///
  /// In pt_BR, this message translates to:
  /// **'@Username'**
  String get settingsEditProfileFieldUsername;

  /// No description provided for @settingsEditProfileFieldBio.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bio'**
  String get settingsEditProfileFieldBio;

  /// No description provided for @settingsChangePasswordTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alterar senha'**
  String get settingsChangePasswordTitle;

  /// No description provided for @settingsChangePasswordBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Enviaremos um link para seu email.'**
  String get settingsChangePasswordBody;

  /// No description provided for @settingsChangePasswordButton.
  ///
  /// In pt_BR, this message translates to:
  /// **'Enviar email de redefinição'**
  String get settingsChangePasswordButton;

  /// No description provided for @settingsChangePasswordSent.
  ///
  /// In pt_BR, this message translates to:
  /// **'Email enviado para {email}'**
  String settingsChangePasswordSent(String email);

  /// No description provided for @settingsExportTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Exportar cartas'**
  String get settingsExportTitle;

  /// No description provided for @settingsExportBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Suas cartas abertas serão exportadas em formato PDF. Isso pode levar alguns minutos.'**
  String get settingsExportBody;

  /// No description provided for @settingsExportButton.
  ///
  /// In pt_BR, this message translates to:
  /// **'Exportar como ZIP'**
  String get settingsExportButton;

  /// No description provided for @settingsExportZipSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Um PDF por carta, mais áudio e imagem manuscrita quando houver.'**
  String get settingsExportZipSubtitle;

  /// No description provided for @settingsExportSuccess.
  ///
  /// In pt_BR, this message translates to:
  /// **'{count} cartas exportadas.'**
  String settingsExportSuccess(int count);

  /// No description provided for @settingsExportSnack.
  ///
  /// In pt_BR, this message translates to:
  /// **'Preparando exportação…'**
  String get settingsExportSnack;

  /// No description provided for @letterDetailExportPdfTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Exportar PDF'**
  String get letterDetailExportPdfTitle;

  /// No description provided for @letterDetailExportPdfSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Baixe uma cópia portátil desta carta'**
  String get letterDetailExportPdfSubtitle;

  /// No description provided for @settingsDeleteTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Deletar conta'**
  String get settingsDeleteTitle;

  /// No description provided for @settingsDeleteBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Esta ação é irreversível. Todas as suas cartas, seguidores e dados serão deletados permanentemente.'**
  String get settingsDeleteBody;

  /// No description provided for @settingsDeletePendingLettersWarning.
  ///
  /// In pt_BR, this message translates to:
  /// **'Importante: Você pode ter cartas bloqueadas aguardando entrega a destinatários ou cartas aguardando para serem recebidas. Se escolher \"Excluir Tudo\", cartas pendentes que você enviou não serão entregues e cartas que você ainda não abriu serão perdidas. Se escolher \"Anonimizar\", suas cartas enviadas continuarão sendo entregues, mas seu nome será substituído por \"Usuário removido\".'**
  String get settingsDeletePendingLettersWarning;

  /// No description provided for @settingsDeleteConfirm.
  ///
  /// In pt_BR, this message translates to:
  /// **'Confirmar exclusão'**
  String get settingsDeleteConfirm;

  /// No description provided for @settingsBlockedTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usuários bloqueados'**
  String get settingsBlockedTitle;

  /// No description provided for @settingsBlockedEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum usuário bloqueado.'**
  String get settingsBlockedEmpty;

  /// No description provided for @settingsBlockedUnblock.
  ///
  /// In pt_BR, this message translates to:
  /// **'Desbloquear'**
  String get settingsBlockedUnblock;

  /// No description provided for @legalTitleTerms.
  ///
  /// In pt_BR, this message translates to:
  /// **'Termos de Uso'**
  String get legalTitleTerms;

  /// No description provided for @legalTitlePrivacy.
  ///
  /// In pt_BR, this message translates to:
  /// **'Política de Privacidade'**
  String get legalTitlePrivacy;

  /// No description provided for @legalTitleAbout.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sobre o OpenWhen'**
  String get legalTitleAbout;

  /// No description provided for @legalTitleHelp.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ajuda e Suporte'**
  String get legalTitleHelp;

  /// No description provided for @legalLastUpdate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Última atualização: {date}'**
  String legalLastUpdate(String date);

  /// No description provided for @aboutTagline.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escreva hoje. Sinta amanhã.'**
  String get aboutTagline;

  /// No description provided for @aboutVersion.
  ///
  /// In pt_BR, this message translates to:
  /// **'Versão 1.0.0 — Build 2026.03.22'**
  String get aboutVersion;

  /// No description provided for @aboutWhatIsTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que é o OpenWhen'**
  String get aboutWhatIsTitle;

  /// No description provided for @aboutWhatIsBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'O OpenWhen é uma plataforma digital de comunicação temporal e rede social emocional. Permite criar cartas digitais com data futura de abertura, combinando o valor sentimental de uma carta física com a viralidade de uma rede social moderna.'**
  String get aboutWhatIsBody;

  /// No description provided for @aboutSecurityTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Segurança e Privacidade'**
  String get aboutSecurityTitle;

  /// No description provided for @aboutSecurityBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Desenvolvido em conformidade com a LGPD (Lei nº 13.709/2018) e o Marco Civil da Internet (Lei nº 12.965/2014). Seus dados são protegidos com criptografia de ponta e armazenados na infraestrutura Google Cloud Platform.'**
  String get aboutSecurityBody;

  /// No description provided for @aboutComplianceTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conformidade Legal'**
  String get aboutComplianceTitle;

  /// No description provided for @aboutComplianceBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'O OpenWhen opera em total conformidade com a legislação brasileira vigente, incluindo LGPD, Marco Civil da Internet, Código de Defesa do Consumidor (Lei nº 8.078/1990) e demais normas aplicáveis ao setor de tecnologia.'**
  String get aboutComplianceBody;

  /// No description provided for @aboutCompanyTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Empresa'**
  String get aboutCompanyTitle;

  /// No description provided for @aboutCompanyBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'OpenWhen Tecnologia Ltda. — Empresa brasileira, com sede no Brasil. Foro de eleição: comarca de São Paulo/SP.'**
  String get aboutCompanyBody;

  /// No description provided for @aboutContacts.
  ///
  /// In pt_BR, this message translates to:
  /// **'Contatos'**
  String get aboutContacts;

  /// No description provided for @aboutContactSupport.
  ///
  /// In pt_BR, this message translates to:
  /// **'Suporte geral'**
  String get aboutContactSupport;

  /// No description provided for @aboutContactPrivacy.
  ///
  /// In pt_BR, this message translates to:
  /// **'Privacidade e LGPD'**
  String get aboutContactPrivacy;

  /// No description provided for @aboutContactLegal.
  ///
  /// In pt_BR, this message translates to:
  /// **'Jurídico'**
  String get aboutContactLegal;

  /// No description provided for @aboutContactDpo.
  ///
  /// In pt_BR, this message translates to:
  /// **'DPO'**
  String get aboutContactDpo;

  /// No description provided for @aboutCopyright.
  ///
  /// In pt_BR, this message translates to:
  /// **'© 2026 OpenWhen Tecnologia Ltda. Todos os direitos reservados.'**
  String get aboutCopyright;

  /// No description provided for @helpCenter.
  ///
  /// In pt_BR, this message translates to:
  /// **'Central de Ajuda'**
  String get helpCenter;

  /// No description provided for @helpCenterSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Encontre respostas para as dúvidas mais frequentes.'**
  String get helpCenterSubtitle;

  /// No description provided for @helpFaqSection.
  ///
  /// In pt_BR, this message translates to:
  /// **'PERGUNTAS FREQUENTES'**
  String get helpFaqSection;

  /// No description provided for @helpFaq1Q.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como enviar uma carta?'**
  String get helpFaq1Q;

  /// No description provided for @helpFaq1A.
  ///
  /// In pt_BR, this message translates to:
  /// **'Toque no botão ✏️ na tela principal. Preencha o título, selecione o estado emocional, escreva sua mensagem, informe o e-mail do destinatário e defina a data de abertura. A carta ficará bloqueada até a data escolhida.'**
  String get helpFaq1A;

  /// No description provided for @helpFaq2Q.
  ///
  /// In pt_BR, this message translates to:
  /// **'O destinatário precisa ter conta no OpenWhen?'**
  String get helpFaq2Q;

  /// No description provided for @helpFaq2A.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sim. Atualmente o destinatário precisa ter uma conta cadastrada no OpenWhen para receber cartas. O envio para e-mails externos estará disponível em breve.'**
  String get helpFaq2A;

  /// No description provided for @helpFaq3Q.
  ///
  /// In pt_BR, this message translates to:
  /// **'Posso editar uma carta após o envio?'**
  String get helpFaq3Q;

  /// No description provided for @helpFaq3A.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não. As cartas ficam seladas imediatamente após o envio para preservar a autenticidade e integridade da mensagem, em analogia às cartas físicas. Esta é uma decisão de produto intencional.'**
  String get helpFaq3A;

  /// No description provided for @helpFaq4Q.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como funciona o Feed Público?'**
  String get helpFaq4Q;

  /// No description provided for @helpFaq4A.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ao abrir uma carta, você pode optar por publicá-la no Feed Público. Essa autorização é individual por carta. Cartas privadas jamais são exibidas publicamente sem sua autorização expressa.'**
  String get helpFaq4A;

  /// No description provided for @helpFaq5Q.
  ///
  /// In pt_BR, this message translates to:
  /// **'Recebi uma carta de um desconhecido. O que fazer?'**
  String get helpFaq5Q;

  /// No description provided for @helpFaq5A.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cartas de pessoas que você não segue ficam em \"Pedidos de Carta\" no Cofre. Você pode aceitar, recusar ou bloquear o remetente sem que ele saiba da sua decisão.'**
  String get helpFaq5A;

  /// No description provided for @helpFaq6Q.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como exportar minhas cartas?'**
  String get helpFaq6Q;

  /// No description provided for @helpFaq6A.
  ///
  /// In pt_BR, this message translates to:
  /// **'Acesse Configurações > Dados e Privacidade > Exportar minhas cartas. Você receberá um arquivo com todas as suas cartas abertas, conforme direito de portabilidade garantido pelo art. 18, inciso V, da LGPD.'**
  String get helpFaq6A;

  /// No description provided for @helpFaq7Q.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como deletar minha conta?'**
  String get helpFaq7Q;

  /// No description provided for @helpFaq7A.
  ///
  /// In pt_BR, this message translates to:
  /// **'Acesse Configurações > Dados e Privacidade > Deletar conta. A exclusão é irreversível e todos os seus dados serão permanentemente removidos em até 30 dias, conforme art. 18, inciso VI, da LGPD.'**
  String get helpFaq7A;

  /// No description provided for @helpFaq8Q.
  ///
  /// In pt_BR, this message translates to:
  /// **'Encontrei um conteúdo ofensivo. Como denunciar?'**
  String get helpFaq8Q;

  /// No description provided for @helpFaq8A.
  ///
  /// In pt_BR, this message translates to:
  /// **'Toque nos três pontos ao lado de qualquer carta ou comentário e selecione \"Denunciar\". Nossa equipe analisará o conteúdo em até 24 horas. Denúncias graves são tratadas com prioridade.'**
  String get helpFaq8A;

  /// No description provided for @reportMenuLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Denunciar'**
  String get reportMenuLabel;

  /// No description provided for @reportSheetTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Denunciar conteúdo'**
  String get reportSheetTitle;

  /// No description provided for @reportSheetSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Diga o que está errado. Detalhes opcionais ajudam nossa equipe a analisar mais rápido.'**
  String get reportSheetSubtitle;

  /// No description provided for @reportReasonSpam.
  ///
  /// In pt_BR, this message translates to:
  /// **'Spam ou enganoso'**
  String get reportReasonSpam;

  /// No description provided for @reportReasonHarassment.
  ///
  /// In pt_BR, this message translates to:
  /// **'Assédio ou bullying'**
  String get reportReasonHarassment;

  /// No description provided for @reportReasonHate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Discurso de ódio'**
  String get reportReasonHate;

  /// No description provided for @reportReasonIllegal.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conteúdo ilegal'**
  String get reportReasonIllegal;

  /// No description provided for @reportReasonOther.
  ///
  /// In pt_BR, this message translates to:
  /// **'Outro'**
  String get reportReasonOther;

  /// No description provided for @reportDetailLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Detalhes adicionais (opcional)'**
  String get reportDetailLabel;

  /// No description provided for @reportDetailHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Contexto que ajuda a moderação…'**
  String get reportDetailHint;

  /// No description provided for @reportSubmit.
  ///
  /// In pt_BR, this message translates to:
  /// **'Enviar denúncia'**
  String get reportSubmit;

  /// No description provided for @reportSuccess.
  ///
  /// In pt_BR, this message translates to:
  /// **'Obrigado — recebemos sua denúncia.'**
  String get reportSuccess;

  /// No description provided for @adminModerationTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Moderação'**
  String get adminModerationTitle;

  /// No description provided for @adminModerationReportsTab.
  ///
  /// In pt_BR, this message translates to:
  /// **'Denúncias'**
  String get adminModerationReportsTab;

  /// No description provided for @adminModerationFeedbackTab.
  ///
  /// In pt_BR, this message translates to:
  /// **'Feedback'**
  String get adminModerationFeedbackTab;

  /// No description provided for @adminModerationIncidentsTab.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alertas IA'**
  String get adminModerationIncidentsTab;

  /// No description provided for @adminModerationAiBannerTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Moderação por IA (servidor)'**
  String get adminModerationAiBannerTitle;

  /// No description provided for @adminModerationProviderOpenai.
  ///
  /// In pt_BR, this message translates to:
  /// **'OpenAI Moderation API'**
  String get adminModerationProviderOpenai;

  /// No description provided for @adminModerationCredentialsOk.
  ///
  /// In pt_BR, this message translates to:
  /// **'Credenciais configuradas'**
  String get adminModerationCredentialsOk;

  /// No description provided for @adminModerationCredentialsMissing.
  ///
  /// In pt_BR, this message translates to:
  /// **'Credenciais em falta (env das Functions)'**
  String get adminModerationCredentialsMissing;

  /// No description provided for @adminModerationEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nada pendente.'**
  String get adminModerationEmpty;

  /// No description provided for @adminModerationResolve.
  ///
  /// In pt_BR, this message translates to:
  /// **'Arquivar'**
  String get adminModerationResolve;

  /// No description provided for @adminModerationConfirm.
  ///
  /// In pt_BR, this message translates to:
  /// **'Marcar como analisado'**
  String get adminModerationConfirm;

  /// No description provided for @adminModerationLoadError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível carregar a fila de moderação.'**
  String get adminModerationLoadError;

  /// No description provided for @adminEntrySettings.
  ///
  /// In pt_BR, this message translates to:
  /// **'Moderação (admin)'**
  String get adminEntrySettings;

  /// No description provided for @adminModerationReviewsTab.
  ///
  /// In pt_BR, this message translates to:
  /// **'Revisão humana'**
  String get adminModerationReviewsTab;

  /// No description provided for @moderationNotificationsSection.
  ///
  /// In pt_BR, this message translates to:
  /// **'Moderação'**
  String get moderationNotificationsSection;

  /// No description provided for @moderationNotificationsEntry.
  ///
  /// In pt_BR, this message translates to:
  /// **'Notificações'**
  String get moderationNotificationsEntry;

  /// No description provided for @moderationNotificationsTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Notificações'**
  String get moderationNotificationsTitle;

  /// No description provided for @moderationNotificationsEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhuma notificação.'**
  String get moderationNotificationsEmpty;

  /// No description provided for @commentsModerationPendingReview.
  ///
  /// In pt_BR, this message translates to:
  /// **'O comentário foi enviado para revisão. Será notificado quando for aprovado ou rejeitado.'**
  String get commentsModerationPendingReview;

  /// No description provided for @commentsModerationQueueFailed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível enviar para revisão. Tente novamente.'**
  String get commentsModerationQueueFailed;

  /// No description provided for @adminModerationApprove.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aprovar e publicar'**
  String get adminModerationApprove;

  /// No description provided for @adminModerationReject.
  ///
  /// In pt_BR, this message translates to:
  /// **'Rejeitar'**
  String get adminModerationReject;

  /// No description provided for @adminModerationFeedbackLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mensagem ao utilizador (obrigatório ao rejeitar)'**
  String get adminModerationFeedbackLabel;

  /// No description provided for @adminModerationFeedbackHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Explique o que deve mudar…'**
  String get adminModerationFeedbackHint;

  /// No description provided for @adminModerationReviewsLoadError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível carregar a fila de revisão.'**
  String get adminModerationReviewsLoadError;

  /// No description provided for @helpNotFoundTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não encontrou o que procurava?'**
  String get helpNotFoundTitle;

  /// No description provided for @helpNotFoundBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nossa equipe está disponível para ajudar:'**
  String get helpNotFoundBody;

  /// No description provided for @helpResponseTime.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tempo de resposta'**
  String get helpResponseTime;

  /// No description provided for @helpResponseTimeValue.
  ///
  /// In pt_BR, this message translates to:
  /// **'até 2 dias úteis'**
  String get helpResponseTimeValue;

  /// No description provided for @feedbackTooltip.
  ///
  /// In pt_BR, this message translates to:
  /// **'Enviar feedback'**
  String get feedbackTooltip;

  /// No description provided for @feedbackSemanticsLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Enviar feedback ou pedido de recurso'**
  String get feedbackSemanticsLabel;

  /// No description provided for @feedbackSheetTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Feedback'**
  String get feedbackSheetTitle;

  /// No description provided for @feedbackCategoryLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Categoria'**
  String get feedbackCategoryLabel;

  /// No description provided for @feedbackTypeFeature.
  ///
  /// In pt_BR, this message translates to:
  /// **'Recurso'**
  String get feedbackTypeFeature;

  /// No description provided for @feedbackTypeRecommendation.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ideia'**
  String get feedbackTypeRecommendation;

  /// No description provided for @feedbackTypeGeneral.
  ///
  /// In pt_BR, this message translates to:
  /// **'Geral'**
  String get feedbackTypeGeneral;

  /// No description provided for @feedbackMessageHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que você gostaria de compartilhar?'**
  String get feedbackMessageHint;

  /// No description provided for @feedbackCharCount.
  ///
  /// In pt_BR, this message translates to:
  /// **'{current} / {max}'**
  String feedbackCharCount(int current, int max);

  /// No description provided for @feedbackSubmit.
  ///
  /// In pt_BR, this message translates to:
  /// **'Enviar'**
  String get feedbackSubmit;

  /// No description provided for @feedbackEmptyError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Digite uma mensagem.'**
  String get feedbackEmptyError;

  /// No description provided for @feedbackTooLongError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mensagem muito longa.'**
  String get feedbackTooLongError;

  /// No description provided for @feedbackSuccess.
  ///
  /// In pt_BR, this message translates to:
  /// **'Obrigado — recebemos seu feedback.'**
  String get feedbackSuccess;

  /// No description provided for @feedbackSignedOutHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Você não está conectado. Vamos abrir o app de e-mail para você enviar para a nossa equipe.'**
  String get feedbackSignedOutHint;

  /// No description provided for @feedbackCouldNotOpenEmail.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível abrir o e-mail. Contate suporte@openwhen.live.'**
  String get feedbackCouldNotOpenEmail;

  /// No description provided for @feedbackEmailBodyPrefix.
  ///
  /// In pt_BR, this message translates to:
  /// **'Categoria: {category}'**
  String feedbackEmailBodyPrefix(String category);

  /// No description provided for @keyboardDismissTooltip.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ocultar teclado'**
  String get keyboardDismissTooltip;

  /// No description provided for @keyboardDismissSemanticsLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fechar teclado'**
  String get keyboardDismissSemanticsLabel;

  /// No description provided for @subscriptionSectionTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Plano e assinatura'**
  String get subscriptionSectionTitle;

  /// No description provided for @subscriptionScreenTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Planos'**
  String get subscriptionScreenTitle;

  /// No description provided for @subscriptionPlanAmanhaName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Amanhã'**
  String get subscriptionPlanAmanhaName;

  /// No description provided for @subscriptionPlanBrisaName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Brisa'**
  String get subscriptionPlanBrisaName;

  /// No description provided for @subscriptionPlanHorizonteName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Horizonte'**
  String get subscriptionPlanHorizonteName;

  /// No description provided for @subscriptionPlanAmanhaPitch.
  ///
  /// In pt_BR, this message translates to:
  /// **'O essencial para escrever hoje e sentir no tempo certo.'**
  String get subscriptionPlanAmanhaPitch;

  /// No description provided for @subscriptionPlanBrisaPitch.
  ///
  /// In pt_BR, this message translates to:
  /// **'Partilha e expressão: mais profundidade no cofre e nas redes.'**
  String get subscriptionPlanBrisaPitch;

  /// No description provided for @subscriptionPlanHorizontePitch.
  ///
  /// In pt_BR, this message translates to:
  /// **'Arquivo, família e inteligência com transparência.'**
  String get subscriptionPlanHorizontePitch;

  /// No description provided for @subscriptionCurrentPlanLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seu plano atual'**
  String get subscriptionCurrentPlanLabel;

  /// No description provided for @subscriptionSubscribeBrisa.
  ///
  /// In pt_BR, this message translates to:
  /// **'Assinar Brisa'**
  String get subscriptionSubscribeBrisa;

  /// No description provided for @subscriptionSubscribeHorizonte.
  ///
  /// In pt_BR, this message translates to:
  /// **'Assinar Horizonte'**
  String get subscriptionSubscribeHorizonte;

  /// No description provided for @subscriptionManageBilling.
  ///
  /// In pt_BR, this message translates to:
  /// **'Gerenciar assinatura e pagamento'**
  String get subscriptionManageBilling;

  /// No description provided for @subscriptionCheckoutError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível abrir o pagamento. Tente novamente.'**
  String get subscriptionCheckoutError;

  /// No description provided for @subscriptionPortalError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível abrir o portal de cobrança.'**
  String get subscriptionPortalError;

  /// No description provided for @subscriptionUpgradeDialogTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Plano necessário'**
  String get subscriptionUpgradeDialogTitle;

  /// No description provided for @subscriptionUpgradeDialogBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Esta função exige o plano {planName} ou superior.'**
  String subscriptionUpgradeDialogBody(String planName);

  /// No description provided for @subscriptionUpgradeDialogViewPlans.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ver planos'**
  String get subscriptionUpgradeDialogViewPlans;

  /// No description provided for @subscriptionBillingDisabledBanner.
  ///
  /// In pt_BR, this message translates to:
  /// **'O checkout de assinatura ainda não está ativado. Você pode continuar usando o app no plano Amanhã. Ative o billing no projeto quando o Stripe estiver pronto.'**
  String get subscriptionBillingDisabledBanner;

  /// No description provided for @subscriptionBillingDisabledSnack.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pagamentos ainda não estão ativos. Use BILLING_ENABLED=true quando o Stripe estiver configurado.'**
  String get subscriptionBillingDisabledSnack;

  /// No description provided for @termsIntro.
  ///
  /// In pt_BR, this message translates to:
  /// **'Estes Termos de Uso (\"Termos\") regulam o acesso e a utilização do aplicativo OpenWhen (\"Plataforma\"), desenvolvido e operado pela OpenWhen Tecnologia Ltda. (\"Empresa\"), inscrita no CNPJ sob o nº [XX.XXX.XXX/0001-XX], com sede no Brasil. A utilização da Plataforma implica a aceitação integral e irrestrita destes Termos, nos termos do art. 8º da Lei nº 12.965/2014 (Marco Civil da Internet) e da Lei nº 13.709/2018 (Lei Geral de Proteção de Dados — LGPD).'**
  String get termsIntro;

  /// No description provided for @termsSection1Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'1. DO OBJETO E NATUREZA DO SERVIÇO'**
  String get termsSection1Title;

  /// No description provided for @termsSection1Body.
  ///
  /// In pt_BR, this message translates to:
  /// **'O OpenWhen é uma plataforma digital de comunicação temporal que permite aos usuários criar, enviar, receber e armazenar mensagens eletrônicas (\"Cartas\") programadas para abertura em data futura determinada pelo remetente. O serviço possui natureza de intermediação digital de comunicação privada e, quando autorizado pelo usuário, de publicação em ambiente de rede social (\"Feed Público\"). A Empresa atua como provedora de aplicação, nos termos do art. 5º, inciso VII, do Marco Civil da Internet.'**
  String get termsSection1Body;

  /// No description provided for @termsSection2Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'2. DOS REQUISITOS PARA UTILIZAÇÃO'**
  String get termsSection2Title;

  /// No description provided for @termsSection2Body.
  ///
  /// In pt_BR, this message translates to:
  /// **'Para utilizar a Plataforma, o usuário deverá: (i) ter capacidade civil plena, nos termos do art. 3º do Código Civil Brasileiro (Lei nº 10.406/2002), ou ser assistido por responsável legal quando menor de 16 anos; (ii) fornecer dados verídicos no cadastro, sob pena de cancelamento imediato da conta, nos termos do art. 7º, inciso VI, do Marco Civil da Internet; (iii) manter a confidencialidade de suas credenciais de acesso, sendo responsável por todas as atividades realizadas em sua conta.'**
  String get termsSection2Body;

  /// No description provided for @termsSection3Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'3. DAS OBRIGAÇÕES E RESPONSABILIDADES DO USUÁRIO'**
  String get termsSection3Title;

  /// No description provided for @termsSection3Body.
  ///
  /// In pt_BR, this message translates to:
  /// **'O usuário se compromete a utilizar a Plataforma em conformidade com a legislação vigente, especialmente: (i) a Lei nº 12.965/2014 (Marco Civil da Internet); (ii) a Lei nº 13.709/2018 (LGPD); (iii) o Código Penal Brasileiro no que tange a crimes contra a honra (arts. 138 a 140); (iv) a Lei nº 7.716/1989 (Lei de Crimes de Preconceito); e (v) o Estatuto da Criança e do Adolescente (ECA — Lei nº 8.069/1990). É expressamente vedado ao usuário publicar conteúdo que: (a) seja difamatório, calunioso ou injurioso; (b) incite violência, ódio ou discriminação de qualquer natureza; (c) viole direitos de propriedade intelectual de terceiros; (d) constitua assédio, cyberbullying ou perseguição; (e) envolva pornografia infantil ou conteúdo sexual envolvendo menores de idade.'**
  String get termsSection3Body;

  /// No description provided for @termsSection4Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'4. DA RESPONSABILIDADE CIVIL DA EMPRESA'**
  String get termsSection4Title;

  /// No description provided for @termsSection4Body.
  ///
  /// In pt_BR, this message translates to:
  /// **'A Empresa, na qualidade de provedora de aplicação, não se responsabiliza pelo conteúdo gerado pelos usuários (\"UGC — User Generated Content\"), nos termos do art. 19 do Marco Civil da Internet. A responsabilidade civil da Empresa somente será configurada mediante descumprimento de ordem judicial específica determinando a remoção de conteúdo. A Empresa adota mecanismos de moderação e denúncia, sem que isso implique assunção de responsabilidade editorial sobre o conteúdo dos usuários.'**
  String get termsSection4Body;

  /// No description provided for @termsSection5Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'5. DA PROPRIEDADE INTELECTUAL'**
  String get termsSection5Title;

  /// No description provided for @termsSection5Body.
  ///
  /// In pt_BR, this message translates to:
  /// **'O usuário é e permanece titular dos direitos autorais sobre o conteúdo que cria na Plataforma, nos termos da Lei nº 9.610/1998 (Lei de Direitos Autorais). Ao publicar conteúdo no Feed Público, o usuário concede à Empresa licença não exclusiva, irrevogável, gratuita e mundial para reproduzir, distribuir e exibir tal conteúdo exclusivamente no âmbito da Plataforma, podendo revogar tal licença mediante a exclusão do conteúdo ou encerramento da conta. A marca, logotipo, design e código-fonte do OpenWhen são de titularidade exclusiva da Empresa e protegidos pela Lei nº 9.279/1996 (Lei da Propriedade Industrial).'**
  String get termsSection5Body;

  /// No description provided for @termsSection6Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'6. DA VIGÊNCIA E RESCISÃO'**
  String get termsSection6Title;

  /// No description provided for @termsSection6Body.
  ///
  /// In pt_BR, this message translates to:
  /// **'O presente contrato vigorará por prazo indeterminado a partir do cadastro do usuário. O usuário poderá rescindir o contrato a qualquer momento mediante exclusão de sua conta nas configurações da Plataforma, nos termos do art. 7º, inciso IX, do Marco Civil da Internet. A Empresa reserva-se o direito de suspender ou encerrar contas que violem estes Termos, sem prejuízo das demais medidas legais cabíveis.'**
  String get termsSection6Body;

  /// No description provided for @termsSection7Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'7. DA DESCONTINUAÇÃO DO SERVIÇO E GARANTIA DE ENTREGA DAS CARTAS'**
  String get termsSection7Title;

  /// No description provided for @termsSection7Body.
  ///
  /// In pt_BR, this message translates to:
  /// **'O OpenWhen empreende todos os esforços para garantir a entrega de todas as cartas e cápsulas nas datas escolhidas pelo remetente. Em caso de descontinuação planejada dos serviços, a Empresa se compromete a: (i) notificar todos os usuários cadastrados por e-mail e notificação no app com no mínimo 90 (noventa) dias de antecedência do encerramento definitivo; (ii) durante o período de aviso, disponibilizar a exportação de todos os dados do usuário (cartas, cápsulas, perfil, mídia) pelo app ou por e-mail; (iii) entregar todas as cartas bloqueadas cuja data de abertura caia dentro do período de aviso; (iv) após o período de 90 dias, excluir permanente e irreversivelmente todos os dados dos usuários dos seus servidores. A Empresa poderá estabelecer um Fundo de Continuidade — uma reserva financeira suficiente para manter a infraestrutura essencial (Firebase, armazenamento, funções de entrega) por pelo menos 2 (dois) anos mesmo que o app deixe de gerar receita. Quando estabelecido, a existência e o status deste fundo serão documentados nestes Termos. Este compromisso constitui uma garantia de produto, não uma obrigação legal, e poderá ser ajustado conforme a capacidade financeira da Empresa evolua.'**
  String get termsSection7Body;

  /// No description provided for @termsSection8Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'8. DAS DISPOSIÇÕES GERAIS'**
  String get termsSection8Title;

  /// No description provided for @termsSection8Body.
  ///
  /// In pt_BR, this message translates to:
  /// **'Estes Termos são regidos pelas leis da República Federativa do Brasil. Fica eleito o foro da comarca de São Paulo/SP para dirimir quaisquer controvérsias decorrentes deste instrumento, com renúncia expressa a qualquer outro foro, por mais privilegiado que seja. A nulidade de qualquer cláusula não afeta a validade das demais. Dúvidas e notificações devem ser encaminhadas para: juridico@openwhen.live. Última atualização: 10 de abril de 2026.'**
  String get termsSection8Body;

  /// No description provided for @privacyIntro.
  ///
  /// In pt_BR, this message translates to:
  /// **'Esta Política de Privacidade (\"Política\") descreve como a OpenWhen Tecnologia Ltda. (\"Empresa\", \"nós\", \"nos\", \"nosso\") coleta, trata, armazena e compartilha os dados pessoais dos usuários da plataforma e do aplicativo móvel OpenWhen (\"Plataforma\"). Esta Política tem alcance global e está em conformidade com: (a) a Lei Geral de Proteção de Dados — LGPD (Lei nº 13.709/2018); (b) o Regulamento Geral de Proteção de Dados da União Europeia — GDPR (Regulamento EU 2016/679); (c) a Lei de Privacidade do Consumidor da Califórnia e a Lei de Direitos de Privacidade da Califórnia — CCPA/CPRA (California Civil Code §§ 1798.100–1798.199.100); (d) o Marco Civil da Internet (Lei nº 12.965/2014); e (e) a Lei de Proteção da Privacidade Online das Crianças dos EUA — COPPA (16 CFR Part 312). A Empresa atua como Controladora de Dados (LGPD art. 5º VI / GDPR art. 4(7)) e como \"Business\" nos termos da CCPA. Data de vigência: 10 de abril de 2026.'**
  String get privacyIntro;

  /// No description provided for @privacySection1Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'1. DEFINIÇÕES'**
  String get privacySection1Title;

  /// No description provided for @privacySection1Body.
  ///
  /// In pt_BR, this message translates to:
  /// **'Para os fins desta Política: \"Dados Pessoais\" significa qualquer informação relacionada a pessoa natural identificada ou identificável (LGPD art. 5º I / GDPR art. 4(1)); \"Informação Pessoal\" (PI) tem o significado definido na CCPA § 1798.140(v); \"Tratamento\" significa qualquer operação realizada com dados pessoais (LGPD art. 5º X / GDPR art. 4(2)); \"Titular dos Dados\" ou \"Consumidor\" significa qualquer pessoa natural cujos dados pessoais são tratados; \"Controlador\" significa a entidade que determina as finalidades e os meios do tratamento; \"Operador\" ou \"Processador\" significa a entidade que trata dados em nome do Controlador; \"Dados Pessoais Sensíveis\" significa dados relativos à origem racial ou étnica, convicção religiosa, opinião política, saúde, vida sexual ou dados biométricos/genéticos (LGPD art. 5º II / GDPR art. 9).'**
  String get privacySection1Body;

  /// No description provided for @privacySection2Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'2. DADOS QUE COLETAMOS'**
  String get privacySection2Title;

  /// No description provided for @privacySection2Body.
  ///
  /// In pt_BR, this message translates to:
  /// **'Coletamos as seguintes categorias de dados pessoais:\n\n(a) Dados de Cadastro: nome completo, nome de exibição, endereço de e-mail, nome de usuário, foto de perfil (opcional) e texto biográfico (opcional).\n\n(b) Conteúdo Gerado pelo Usuário: cartas (texto, título, estado emocional), imagens de cartas manuscritas (capturadas pela câmera), mensagens de voz (até 1 minuto, capturadas pelo microfone), cápsulas do tempo (texto, tema, fotos), comentários em cartas públicas e links opcionais de música.\n\n(c) Dados de Localização Precisa (opt-in): quando você opta por anexar uma localização a uma carta ou cápsula, coletamos suas coordenadas GPS precisas (latitude e longitude) e o momento da captura. Você também pode ativar um requisito de proximidade (aproximadamente 10 metros) para o destinatário abrir a carta. A coleta de localização é sempre opcional e solicitada por carta ou cápsula — nunca coletamos localização em segundo plano.\n\n(d) Dados Técnicos e de Dispositivo: endereço IP, identificador do dispositivo, sistema operacional, versão do app, token de notificação push (Firebase Cloud Messaging), plataforma do dispositivo (Android/iOS/web), idioma preferido e logs de acesso nos termos do art. 15 do Marco Civil da Internet.\n\n(e) Dados de Analytics: eventos de uso (cartas criadas, abertas, compartilhadas; cápsulas criadas, abertas; visualizações do feed; curtidas, comentários, follows; visualizações de perfil; alterações de tema e idioma), visualizações de tela e relatórios de falhas/erros, coletados via Firebase Analytics e Firebase Crashlytics.\n\n(f) Dados Sociais: relações de seguidores/seguindo, bloqueios entre usuários, curtidas em cartas públicas e comentários.\n\n(g) Dados de Cobrança: quando os recursos de assinatura estão habilitados, armazenamos seu identificador de cliente Stripe, identificador de assinatura, nível de assinatura (free/plus/pro) e status da assinatura. Dados de cartão de pagamento são processados e armazenados exclusivamente pelo Stripe e nunca passam pelos nossos servidores.\n\n(h) Dados de Moderação: denúncias de conteúdo enviadas por usuários (motivo, detalhe, conteúdo alvo), resultados de análise de moderação por IA (categorias sinalizadas e pontuações), registros de revisão humana de moderação e logs de incidentes de moderação.\n\n(i) Dados de Comunicação: mensagens de feedback do produto (incluindo metadados de plataforma e idioma do app) e solicitações de suporte.\n\n(j) Dados de Gamificação: registros de desbloqueio de badges e histórico de notificações no app.\n\nPara fins da CCPA, as categorias de PI coletadas nos últimos 12 meses incluem: identificadores (nome, e-mail, nome de usuário, ID do dispositivo); atividade de rede de internet/eletrônica (eventos de uso, logs de acesso); dados de geolocalização (GPS preciso quando opt-in); informações de áudio/visuais (mensagens de voz, fotos); e informações profissionais ou pessoais inferidas do conteúdo que você cria.'**
  String get privacySection2Body;

  /// No description provided for @privacySection3Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'3. COMO COLETAMOS DADOS'**
  String get privacySection3Title;

  /// No description provided for @privacySection3Body.
  ///
  /// In pt_BR, this message translates to:
  /// **'(a) Diretamente de você: quando você cria uma conta, escreve cartas ou cápsulas, envia fotos ou mensagens de voz, concede permissão de localização, envia feedback, publica comentários ou interage com outros usuários.\n\n(b) Automaticamente: dados técnicos e de dispositivo, eventos de analytics, relatórios de falhas e tokens de notificação push são coletados automaticamente quando você usa a Plataforma, por meio dos SDKs do Firebase integrados ao app.\n\n(c) De terceiros: atualizações de status de pagamento do Stripe (via webhooks) quando os recursos de assinatura estão ativos; atestação de dispositivo do Firebase App Check (Play Integrity no Android, DeviceCheck no iOS) para proteção contra abusos.'**
  String get privacySection3Body;

  /// No description provided for @privacySection4Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'4. BASES LEGAIS PARA O TRATAMENTO'**
  String get privacySection4Title;

  /// No description provided for @privacySection4Body.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nos termos da LGPD (art. 7º) e do GDPR (art. 6), tratamos seus dados com base em:\n\n(a) Consentimento (LGPD art. 7º I / GDPR art. 6(1)(a)): manifestado no cadastro quando você aceita esta Política; para recursos opcionais como dados de localização e mensagens de voz, o consentimento é obtido no momento do uso.\n\n(b) Execução de Contrato (LGPD art. 7º V / GDPR art. 6(1)(b)): tratamento necessário para a prestação dos serviços da Plataforma — entrega de cartas, gerenciamento de cápsulas, recursos sociais e manutenção da sua conta.\n\n(c) Legítimo Interesse (LGPD art. 7º IX / GDPR art. 6(1)(f)): melhoria da Plataforma, prevenção a fraudes, moderação de conteúdo, segurança do serviço e analytics. Realizamos teste de proporcionalidade para garantir que nossos interesses não se sobreponham aos seus direitos fundamentais.\n\n(d) Obrigação Legal (LGPD art. 7º II / GDPR art. 6(1)(c)): retenção de logs de acesso por 6 meses (Marco Civil da Internet art. 15), cumprimento de ordens judiciais e requisitos regulatórios.\n\nNos termos da CCPA, a coleta e uso de PI está detalhada nas Seções 2, 6 e 8 desta Política. Não utilizamos nem divulgamos informações pessoais sensíveis para finalidades além das permitidas pela CCPA § 1798.121.'**
  String get privacySection4Body;

  /// No description provided for @privacySection5Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'5. FINALIDADES DO TRATAMENTO'**
  String get privacySection5Title;

  /// No description provided for @privacySection5Body.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tratamos seus dados pessoais para as seguintes finalidades: (i) prestação e operação dos serviços da Plataforma (entrega de cartas, gerenciamento de cápsulas, feed social); (ii) personalização da experiência (temas, idioma, estados emocionais); (iii) envio de notificações relacionadas ao serviço (alertas de entrega de cartas, lembretes de abertura de cápsulas) via notificações push e, quando aplicável, e-mail; (iv) moderação de conteúdo para garantir um ambiente seguro e respeitoso; (v) analytics e melhoria contínua da Plataforma; (vi) prevenção a fraudes e garantia de segurança; (vii) processamento de pagamentos e gerenciamento de assinaturas (quando habilitados); (viii) cumprimento de obrigações legais e regulatórias; (ix) exercício regular de direitos em processos judiciais, administrativos ou arbitrais. Não utilizamos seus dados para publicidade de terceiros, perfilamento comportamental para segmentação de anúncios ou venda a corretores de dados.'**
  String get privacySection5Body;

  /// No description provided for @privacySection6Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'6. DECISÕES AUTOMATIZADAS E PERFILAMENTO'**
  String get privacySection6Title;

  /// No description provided for @privacySection6Body.
  ///
  /// In pt_BR, this message translates to:
  /// **'A Plataforma utiliza moderação automatizada de conteúdo alimentada por inteligência artificial (API de Moderação da OpenAI) para analisar conteúdo textual (como comentários) em busca de material potencialmente prejudicial. Este sistema pode: (a) permitir a publicação do conteúdo sem intervenção (pontuação de risco baixa); (b) apresentar um aviso gentil ao autor permitindo a publicação (pontuação de risco média); ou (c) bloquear a publicação do conteúdo (pontuação de risco alta). Quando a moderação humana está ativada, conteúdo sinalizado é encaminhado para revisão manual pela nossa equipe antes de uma decisão final. Nenhuma decisão automatizada é baseada em categorias de dados pessoais sensíveis. Nos termos do GDPR art. 22, você tem o direito de não ser submetido a decisões baseadas unicamente em tratamento automatizado que produzam efeitos jurídicos ou igualmente significativos. Você pode contestar qualquer decisão automatizada de moderação contatando privacidade@openwhen.live ou através do recurso de denúncia/feedback no app. Nos termos da LGPD art. 20, você pode solicitar a revisão de decisões automatizadas que afetem seus interesses.'**
  String get privacySection6Body;

  /// No description provided for @privacySection7Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'7. COMPARTILHAMENTO DE DADOS E OPERADORES TERCEIROS'**
  String get privacySection7Title;

  /// No description provided for @privacySection7Body.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não vendemos, alugamos ou comercializamos seus dados pessoais. Para fins da CCPA: não vendemos nem compartilhamos (conforme definido na CCPA § 1798.140(ad) e (ah)) informações pessoais de consumidores nos últimos 12 meses, e não temos conhecimento efetivo de venda ou compartilhamento de PI de consumidores menores de 16 anos. Os dados são compartilhados com as seguintes categorias de prestadores de serviço/operadores, cada um vinculado por acordos de processamento de dados:\n\n(a) Google LLC / Firebase: infraestrutura em nuvem (banco de dados Firestore, Cloud Storage para arquivos, Cloud Functions para lógica do servidor), serviços de autenticação, notificações push (FCM), analytics (Firebase Analytics), relatórios de falhas (Crashlytics) e atestação de dispositivo (App Check). O Google trata dados como Operador sob nossas instruções. Compromissos de privacidade do Google: https://firebase.google.com/support/privacy.\n\n(b) OpenAI, Inc.: conteúdo textual é enviado à API de Moderação da OpenAI exclusivamente para análise de segurança de conteúdo. Apenas o texto do conteúdo sendo moderado é transmitido — nenhum identificador de usuário, imagem ou dado de voz é enviado. A política de uso de dados da OpenAI para clientes da API estabelece que inputs da API não são usados para treinar modelos.\n\n(c) Twilio Inc. (SendGrid): endereços de e-mail de destinatários externos são processados para enviar e-mails de convite quando uma carta é endereçada a alguém que ainda não possui conta. Apenas o e-mail do destinatário, um nome de exibição do remetente e um título da carta são incluídos.\n\n(d) Stripe, Inc.: quando os recursos de assinatura/pagamento estão ativos, o Stripe processa dados de cartão de pagamento, identificadores de cliente e status de assinatura. Os dados do cartão são coletados diretamente pelo Stripe e nunca passam pelos nossos servidores.\n\n(e) Google Fonts: o app pode carregar fontes tipográficas dos servidores do Google, o que envolve o envio do seu endereço IP para o Google.\n\n(f) Autoridades públicas: podemos compartilhar dados com autoridades governamentais quando exigido por ordem judicial ou requisição legal fundamentada.\n\n(g) Transações corporativas: em caso de fusão, aquisição ou reestruturação, seus dados poderão ser transferidos à entidade sucessora, que ficará vinculada a esta Política.'**
  String get privacySection7Body;

  /// No description provided for @privacySection8Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'8. TRANSFERÊNCIAS INTERNACIONAIS DE DADOS'**
  String get privacySection8Title;

  /// No description provided for @privacySection8Body.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seus dados pessoais são armazenados em servidores operados pelo Google Cloud Platform, que podem estar localizados nos Estados Unidos ou em outros países fora do seu país de residência. Estas transferências são realizadas em conformidade com: (a) LGPD art. 33, mediante cláusulas contratuais padrão aprovadas pela Autoridade Nacional de Proteção de Dados (ANPD); (b) GDPR Capítulo V, com base em Cláusulas Contratuais Padrão (SCCs) adotadas pela Comissão Europeia (Decisão 2021/914) e, quando aplicável, medidas suplementares conforme a decisão Schrems II; (c) para operadores baseados nos EUA, compromissos contratuais que garantem proteção de dados equivalente à prevista na legislação aplicável. Para a OpenAI e o Stripe, os dados processados nos Estados Unidos estão sujeitos aos respectivos acordos de processamento de dados que incorporam SCCs.'**
  String get privacySection8Body;

  /// No description provided for @privacySection9Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'9. RETENÇÃO DE DADOS'**
  String get privacySection9Title;

  /// No description provided for @privacySection9Body.
  ///
  /// In pt_BR, this message translates to:
  /// **'Retemos seus dados pelo período mínimo necessário para as finalidades descritas nesta Política. Períodos específicos de retenção:\n\n• Dados de conta/perfil: retidos até a exclusão da conta.\n• Cartas e cápsulas: retidas até a exclusão pelo titular ou exclusão/anonimização da conta.\n• Comentários, curtidas, follows: retidos até exclusão pelo titular ou exclusão da conta.\n• Tokens de notificação push (FCM): sobrescritos a cada login; excluídos na exclusão da conta.\n• Dados de localização precisa: armazenados apenas quando opt-in; excluídos ou anonimizados na exclusão da conta.\n• Dados de cobrança (IDs Stripe): assinatura cancelada e IDs excluídos na exclusão da conta. O Stripe pode reter dados conforme sua própria política de retenção.\n• Denúncias de conteúdo: anonimizadas 90 dias após resolução.\n• Feedback do produto: anonimizado após 1 ano.\n• Logs de moderação: retidos por 2 anos (sem PII direta).\n• Dados de analytics (Firebase): retidos conforme política padrão do Firebase (14 meses para dados em nível de usuário).\n• Logs de auditoria de exclusão: retidos por 3 anos com identificadores hasheados (não reversíveis) apenas — sem PII.\n• Logs de acesso: retidos por 6 meses nos termos do art. 15 do Marco Civil da Internet.\n\nAo término destes períodos, os dados são permanentemente excluídos ou irreversivelmente anonimizados.'**
  String get privacySection9Body;

  /// No description provided for @privacySection10Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'10. SEUS DIREITOS'**
  String get privacySection10Title;

  /// No description provided for @privacySection10Body.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seus direitos variam conforme sua jurisdição. Você pode exercer qualquer um dos direitos abaixo pelo app (Configurações > Dados e Privacidade), por e-mail para privacidade@openwhen.live (ou privacy@openwhen.live para inglês), ou contatando nosso DPO.\n\n— LGPD (Brasil — Art. 18): Você tem direito a: (i) confirmação da existência de tratamento; (ii) acesso aos dados; (iii) correção de dados incompletos ou inexatos; (iv) anonimização, bloqueio ou eliminação de dados desnecessários ou excessivos; (v) portabilidade a outro prestador de serviços; (vi) eliminação dos dados tratados com base no consentimento; (vii) informação sobre terceiros com quem os dados foram compartilhados; (viii) informação sobre a possibilidade de negar consentimento e suas consequências; (ix) revogação do consentimento. Prazo de resposta: 15 dias úteis. Você pode registrar reclamação junto à ANPD (Autoridade Nacional de Proteção de Dados): https://www.gov.br/anpd.\n\n— GDPR (UE/EEE — Arts. 15–22): Você tem direito a: (i) acesso (art. 15); (ii) retificação (art. 16); (iii) apagamento / direito ao esquecimento (art. 17); (iv) limitação do tratamento (art. 18); (v) portabilidade dos dados (art. 20); (vi) oposição ao tratamento baseado em interesse legítimo (art. 21); (vii) não ser submetido a decisões exclusivamente automatizadas, incluindo perfilamento (art. 22) — veja a Seção 6 acima; (viii) retirar o consentimento a qualquer momento (art. 7(3)). Prazo de resposta: 30 dias. Você pode apresentar reclamação à autoridade supervisora local.\n\n— CCPA/CPRA (Califórnia): Como consumidor da Califórnia, você tem direito a: (i) saber quais PI coletamos, usamos, divulgamos e vendemos (Direito de Saber); (ii) solicitar a exclusão de suas PI (Direito de Exclusão) — prazo de resposta: 45 dias; (iii) corrigir PI imprecisas (Direito de Correção); (iv) recusar a venda ou compartilhamento de PI — não vendemos nem compartilhamos suas PI, mas você pode enviar uma solicitação a qualquer momento; (v) limitar o uso de PI sensíveis — não utilizamos PI sensíveis além do necessário para prestar nossos serviços; (vi) não discriminação pelo exercício de seus direitos. Você pode designar um agente autorizado para enviar solicitações em seu nome. Verificamos solicitações usando o e-mail da sua conta. As categorias de PI coletadas, finalidades e divulgações a terceiros estão detalhadas nas Seções 2, 5 e 7.'**
  String get privacySection10Body;

  /// No description provided for @privacySection11Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'11. EXCLUSÃO DE CONTA'**
  String get privacySection11Title;

  /// No description provided for @privacySection11Body.
  ///
  /// In pt_BR, this message translates to:
  /// **'Você pode excluir sua conta a qualquer momento em Configurações > Dados e Privacidade > Excluir Conta. Antes da exclusão, você deverá se reautenticar por segurança. Serão oferecidos dois modos:\n\n(a) Excluir Tudo: remove permanentemente seu perfil, todas as cartas (enviadas e recebidas), cápsulas, comentários, curtidas, follows, bloqueios, denúncias, feedback, badges, notificações e todos os arquivos enviados (fotos, mensagens de voz, imagens manuscritas). Seu registro de autenticação no Firebase também é excluído.\n\n(b) Anonimizar: preserva cartas e cápsulas para seus destinatários, mas substitui seu nome por \"Usuário removido\" e remove suas informações identificáveis (ID de usuário, dados de localização, mídia pessoal). Seu perfil, conexões sociais, comentários e curtidas são excluídos.\n\nEm ambos os modos: (i) assinaturas Stripe ativas são canceladas; (ii) um log de auditoria não reversível é registrado (identificador hasheado + timestamp, sem PII) para fins de compliance; (iii) a exclusão é irreversível. Cartas bloqueadas que você já enviou podem continuar a ser entregues aos seus destinatários conforme nossos Termos de Uso — uma carta enviada é um presente confiado ao destinatário.'**
  String get privacySection11Body;

  /// No description provided for @privacySection12Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'12. PORTABILIDADE E EXPORTAÇÃO DE DADOS'**
  String get privacySection12Title;

  /// No description provided for @privacySection12Body.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nos termos da LGPD art. 18 V e GDPR art. 20, você tem o direito de receber seus dados pessoais em formato estruturado, de uso comum e leitura automática. Você pode exportar seus dados em Configurações > Dados e Privacidade > Exportar Meus Dados. A exportação inclui: suas informações de perfil (JSON), todas as cartas enviadas (JSON + arquivos de mídia anexados), cápsulas criadas (JSON + fotos), seus comentários (JSON), curtidas (JSON), listas de seguidores/seguindo (JSON) e badges (JSON). A exportação é gerada como um arquivo ZIP. Você também pode solicitar uma exportação manual contatando privacidade@openwhen.live.'**
  String get privacySection12Body;

  /// No description provided for @privacySection13Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'13. PRIVACIDADE DE CRIANÇAS'**
  String get privacySection13Title;

  /// No description provided for @privacySection13Body.
  ///
  /// In pt_BR, this message translates to:
  /// **'O OpenWhen não é direcionado a crianças menores de 13 anos. Em conformidade com a COPPA (16 CFR Part 312), não coletamos intencionalmente informações pessoais de crianças menores de 13 anos. Durante o cadastro, os usuários devem confirmar que têm 13 anos ou mais. Se tomarmos conhecimento de que coletamos dados de uma criança menor de 13 anos sem consentimento parental verificável, excluiremos prontamente tais dados. Pais ou responsáveis que acreditam que seu filho forneceu dados pessoais a nós podem entrar em contato pelo e-mail privacidade@openwhen.live para solicitar a exclusão. Para usuários de 13 a 17 anos, recomendamos orientação dos pais ao usar a Plataforma.'**
  String get privacySection13Body;

  /// No description provided for @privacySection14Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'14. MEDIDAS DE SEGURANÇA'**
  String get privacySection14Title;

  /// No description provided for @privacySection14Body.
  ///
  /// In pt_BR, this message translates to:
  /// **'Implementamos medidas técnicas e organizacionais adequadas para proteger seus dados pessoais, incluindo: (a) criptografia em trânsito usando TLS 1.3 para todas as comunicações entre o app e nossos servidores; (b) criptografia em repouso para dados armazenados no Google Cloud/Firebase; (c) Firebase App Check (Play Integrity no Android, DeviceCheck no iOS) para proteger serviços de backend contra abusos; (d) controle de acesso baseado em funções limitando o acesso de colaboradores a dados pessoais; (e) Regras de Segurança do Firestore aplicando restrições de acesso a dados no nível do banco de dados; (f) monitoramento contínuo de segurança e logging. Em caso de violação de dados pessoais: nos termos do GDPR, notificaremos a autoridade supervisora competente em até 72 horas após tomar conhecimento da violação (art. 33) e os titulares afetados sem demora indevida quando a violação representar alto risco (art. 34); nos termos da LGPD, notificaremos a ANPD e os titulares afetados em prazo razoável (art. 48); nos termos da CCPA, notificaremos os consumidores californianos afetados conforme exigido pelo California Civil Code § 1798.82.'**
  String get privacySection14Body;

  /// No description provided for @privacySection15Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'15. TECNOLOGIAS DE RASTREAMENTO'**
  String get privacySection15Title;

  /// No description provided for @privacySection15Body.
  ///
  /// In pt_BR, this message translates to:
  /// **'A Plataforma não utiliza cookies tradicionais de navegador. No entanto, as seguintes tecnologias coletam dados automaticamente: (a) Firebase Analytics: coleta eventos de uso anônimos, visualizações de tela e propriedades do dispositivo usando identificadores móveis. Você pode redefinir seu identificador de publicidade nas configurações do dispositivo. O período de retenção do Firebase Analytics é de 14 meses. (b) Firebase Crashlytics: coleta relatórios de falhas incluindo estado do dispositivo, versão do app e rastreamento de pilha para nos ajudar a corrigir bugs. (c) Firebase App Check: verifica a integridade do dispositivo para proteção contra abusos automatizados. Estas tecnologias são essenciais para a operação, segurança e melhoria da Plataforma. Não utilizamos nenhuma tecnologia de rastreamento para publicidade ou rastreamento comportamental entre sites/apps. Respeitamos o sinal Global Privacy Control (GPC) como solicitação válida de opt-out nos termos da CCPA.'**
  String get privacySection15Body;

  /// No description provided for @privacySection16Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'16. ALTERAÇÕES NESTA POLÍTICA'**
  String get privacySection16Title;

  /// No description provided for @privacySection16Body.
  ///
  /// In pt_BR, this message translates to:
  /// **'Podemos atualizar esta Política periodicamente para refletir mudanças em nossas práticas, requisitos legais ou funcionalidades da Plataforma. Quando fizermos alterações materiais, iremos: (a) atualizar a \"Data de vigência\" no topo desta Política; (b) notificá-lo via notificação no app e/ou e-mail com pelo menos 15 dias de antecedência; (c) para alterações que exijam renovação de consentimento nos termos do GDPR ou da LGPD, solicitar seu consentimento expresso antes que as alterações entrem em vigor. O uso continuado da Plataforma após a data de vigência de uma atualização que não requeira consentimento constitui aceitação da Política revisada. Versões anteriores desta Política estão disponíveis mediante solicitação.'**
  String get privacySection16Body;

  /// No description provided for @privacySection17Title.
  ///
  /// In pt_BR, this message translates to:
  /// **'17. FALE CONOSCO'**
  String get privacySection17Title;

  /// No description provided for @privacySection17Body.
  ///
  /// In pt_BR, this message translates to:
  /// **'Se você tem dúvidas sobre esta Política, deseja exercer seus direitos ou precisa reportar uma preocupação de privacidade, entre em contato:\n\n• Encarregado de Proteção de Dados (DPO): dpo@openwhen.live\n• Solicitações de privacidade (português): privacidade@openwhen.live\n• Solicitações de privacidade (inglês): privacy@openwhen.live\n• Departamento jurídico: juridico@openwhen.live\n• Suporte geral: suporte@openwhen.live\n\nBrasil — Você pode registrar reclamação junto à ANPD: https://www.gov.br/anpd\nUE/EEE — Você pode apresentar reclamação à autoridade supervisora de proteção de dados local.\nCalifórnia — Você pode contatar o Procurador-Geral da Califórnia: https://oag.ca.gov/privacy\n\nOpenWhen Tecnologia Ltda.\nÚltima atualização: 10 de abril de 2026.'**
  String get privacySection17Body;

  /// No description provided for @letterPrivacyPublicLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pública'**
  String get letterPrivacyPublicLabel;

  /// No description provided for @letterPrivacyPublicSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aparece no feed para todos'**
  String get letterPrivacyPublicSubtitle;

  /// No description provided for @letterPrivacyPrivateLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Privada'**
  String get letterPrivacyPrivateLabel;

  /// No description provided for @letterPrivacyPrivateSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Só você pode ver'**
  String get letterPrivacyPrivateSubtitle;

  /// No description provided for @letterPrivacyActionMakePublic.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tornar pública'**
  String get letterPrivacyActionMakePublic;

  /// No description provided for @letterPrivacyActionMakePrivate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tornar privada'**
  String get letterPrivacyActionMakePrivate;

  /// No description provided for @letterDetailSentView.
  ///
  /// In pt_BR, this message translates to:
  /// **'SUA CARTA ENVIADA'**
  String get letterDetailSentView;

  /// No description provided for @feedReadMore.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ler mais'**
  String get feedReadMore;

  /// No description provided for @feedReadFullLetter.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ler carta completa'**
  String get feedReadFullLetter;

  /// No description provided for @feedCardToAnonymous.
  ///
  /// In pt_BR, this message translates to:
  /// **'Para: alguém especial'**
  String get feedCardToAnonymous;

  /// No description provided for @vaultLetterSheetHideReceiver.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ocultar nome do destinatário'**
  String get vaultLetterSheetHideReceiver;

  /// No description provided for @vaultLetterSheetShowReceiver.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mostrar nome do destinatário'**
  String get vaultLetterSheetShowReceiver;

  /// No description provided for @feedRemoveFromFeed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Remover do feed'**
  String get feedRemoveFromFeed;

  /// No description provided for @feedHideSenderName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ocultar quem me enviou'**
  String get feedHideSenderName;

  /// No description provided for @feedShowSenderName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mostrar quem me enviou'**
  String get feedShowSenderName;

  /// No description provided for @feedSenderAnonymous.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alguém especial'**
  String get feedSenderAnonymous;

  /// No description provided for @registerAcceptTermsPrefix.
  ///
  /// In pt_BR, this message translates to:
  /// **'Li e aceito os '**
  String get registerAcceptTermsPrefix;

  /// No description provided for @registerAcceptTermsAnd.
  ///
  /// In pt_BR, this message translates to:
  /// **' e a '**
  String get registerAcceptTermsAnd;

  /// No description provided for @registerConfirmAge.
  ///
  /// In pt_BR, this message translates to:
  /// **'Confirmo que tenho 13 anos ou mais'**
  String get registerConfirmAge;

  /// No description provided for @registerMustAcceptTerms.
  ///
  /// In pt_BR, this message translates to:
  /// **'Você precisa aceitar os termos e confirmar sua idade para continuar'**
  String get registerMustAcceptTerms;

  /// No description provided for @registerSectionUsername.
  ///
  /// In pt_BR, this message translates to:
  /// **'USERNAME'**
  String get registerSectionUsername;

  /// No description provided for @registerHintUsername.
  ///
  /// In pt_BR, this message translates to:
  /// **'seu_username'**
  String get registerHintUsername;

  /// No description provided for @registerUsernameSuggestions.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sugestoes:'**
  String get registerUsernameSuggestions;

  /// No description provided for @registerUsernameAvailable.
  ///
  /// In pt_BR, this message translates to:
  /// **'Disponivel'**
  String get registerUsernameAvailable;

  /// No description provided for @registerUsernameChecking.
  ///
  /// In pt_BR, this message translates to:
  /// **'Verificando...'**
  String get registerUsernameChecking;

  /// No description provided for @registerUsernameRules.
  ///
  /// In pt_BR, this message translates to:
  /// **'Letras, numeros, . e _ apenas'**
  String get registerUsernameRules;

  /// No description provided for @registerErrorUsernameEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escolha um username'**
  String get registerErrorUsernameEmpty;

  /// No description provided for @registerErrorUsernameShort.
  ///
  /// In pt_BR, this message translates to:
  /// **'Username deve ter pelo menos 3 caracteres'**
  String get registerErrorUsernameShort;

  /// No description provided for @registerErrorUsernameLong.
  ///
  /// In pt_BR, this message translates to:
  /// **'Username deve ter no maximo 20 caracteres'**
  String get registerErrorUsernameLong;

  /// No description provided for @registerErrorUsernameInvalid.
  ///
  /// In pt_BR, this message translates to:
  /// **'Apenas letras, numeros, . e _ (sem iniciar/terminar com . ou _)'**
  String get registerErrorUsernameInvalid;

  /// No description provided for @registerErrorUsernameTaken.
  ///
  /// In pt_BR, this message translates to:
  /// **'Este username ja esta em uso'**
  String get registerErrorUsernameTaken;

  /// No description provided for @settingsDeleteChoiceTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que deve acontecer com suas cartas?'**
  String get settingsDeleteChoiceTitle;

  /// No description provided for @settingsDeleteOptionDeleteAll.
  ///
  /// In pt_BR, this message translates to:
  /// **'Apagar tudo'**
  String get settingsDeleteOptionDeleteAll;

  /// No description provided for @settingsDeleteOptionDeleteAllDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Todas as cartas, cápsulas e dados serão removidos permanentemente.'**
  String get settingsDeleteOptionDeleteAllDesc;

  /// No description provided for @settingsDeleteOptionAnonymize.
  ///
  /// In pt_BR, this message translates to:
  /// **'Anonimizar minhas cartas'**
  String get settingsDeleteOptionAnonymize;

  /// No description provided for @settingsDeleteOptionAnonymizeDesc.
  ///
  /// In pt_BR, this message translates to:
  /// **'Suas cartas permanecem para os destinatários, mas seu nome e dados são removidos.'**
  String get settingsDeleteOptionAnonymizeDesc;

  /// No description provided for @settingsDeletePasswordLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'CONFIRME SUA SENHA'**
  String get settingsDeletePasswordLabel;

  /// No description provided for @settingsDeletePasswordHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Digite sua senha atual'**
  String get settingsDeletePasswordHint;

  /// No description provided for @settingsDeleteIrreversibleConfirm.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entendo que esta ação é irreversível e todos os meus dados serão processados de acordo com minha escolha acima.'**
  String get settingsDeleteIrreversibleConfirm;

  /// No description provided for @settingsDeleteProcessing.
  ///
  /// In pt_BR, this message translates to:
  /// **'Deletando sua conta...'**
  String get settingsDeleteProcessing;

  /// No description provided for @settingsDeleteWrongPassword.
  ///
  /// In pt_BR, this message translates to:
  /// **'Senha incorreta. Tente novamente.'**
  String get settingsDeleteWrongPassword;

  /// No description provided for @settingsDeleteReauthFailed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Falha na autenticação. Tente novamente.'**
  String get settingsDeleteReauthFailed;

  /// No description provided for @settingsDeleteError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Falha ao deletar conta. Tente novamente mais tarde.'**
  String get settingsDeleteError;

  /// No description provided for @settingsDeletePendingBanner.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sua conta será excluída em {days} dia(s). Você pode cancelar a exclusão a qualquer momento.'**
  String settingsDeletePendingBanner(int days);

  /// No description provided for @settingsDeleteCancelButton.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cancelar exclusão'**
  String get settingsDeleteCancelButton;

  /// No description provided for @settingsDeleteCancelled.
  ///
  /// In pt_BR, this message translates to:
  /// **'Exclusão de conta cancelada. Sua conta está ativa novamente.'**
  String get settingsDeleteCancelled;

  /// No description provided for @settingsDeleteScheduled.
  ///
  /// In pt_BR, this message translates to:
  /// **'Exclusão agendada para {day}/{month}/{year}. Seus dados foram enviados por email.'**
  String settingsDeleteScheduled(int day, int month, int year);

  /// No description provided for @privacyCenterTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Central de Privacidade'**
  String get privacyCenterTitle;

  /// No description provided for @privacyCenterSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ver todos os seus dados armazenados'**
  String get privacyCenterSubtitle;

  /// No description provided for @privacyCenterIntro.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aqui você pode ver todos os dados que o OpenWhen armazena sobre você. Isso inclui seu perfil, cartas, cápsulas, interações sociais e mais. Conforme LGPD Art. 18 e GDPR Art. 15.'**
  String get privacyCenterIntro;

  /// No description provided for @privacyCenterProfile.
  ///
  /// In pt_BR, this message translates to:
  /// **'Perfil'**
  String get privacyCenterProfile;

  /// No description provided for @privacyCenterFieldName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nome'**
  String get privacyCenterFieldName;

  /// No description provided for @privacyCenterFieldUsername.
  ///
  /// In pt_BR, this message translates to:
  /// **'Username'**
  String get privacyCenterFieldUsername;

  /// No description provided for @privacyCenterFieldEmail.
  ///
  /// In pt_BR, this message translates to:
  /// **'Email'**
  String get privacyCenterFieldEmail;

  /// No description provided for @privacyCenterFieldBio.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bio'**
  String get privacyCenterFieldBio;

  /// No description provided for @privacyCenterFieldCountry.
  ///
  /// In pt_BR, this message translates to:
  /// **'País'**
  String get privacyCenterFieldCountry;

  /// No description provided for @privacyCenterFieldLanguage.
  ///
  /// In pt_BR, this message translates to:
  /// **'Idioma'**
  String get privacyCenterFieldLanguage;

  /// No description provided for @privacyCenterFieldCreatedAt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criado em'**
  String get privacyCenterFieldCreatedAt;

  /// No description provided for @privacyCenterFieldPhoto.
  ///
  /// In pt_BR, this message translates to:
  /// **'Foto'**
  String get privacyCenterFieldPhoto;

  /// No description provided for @privacyCenterYes.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sim'**
  String get privacyCenterYes;

  /// No description provided for @privacyCenterNo.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não'**
  String get privacyCenterNo;

  /// No description provided for @privacyCenterLetters.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cartas'**
  String get privacyCenterLetters;

  /// No description provided for @privacyCenterLettersSent.
  ///
  /// In pt_BR, this message translates to:
  /// **'Enviadas'**
  String get privacyCenterLettersSent;

  /// No description provided for @privacyCenterLettersReceived.
  ///
  /// In pt_BR, this message translates to:
  /// **'Recebidas'**
  String get privacyCenterLettersReceived;

  /// No description provided for @privacyCenterLettersLocked.
  ///
  /// In pt_BR, this message translates to:
  /// **'Trancadas'**
  String get privacyCenterLettersLocked;

  /// No description provided for @privacyCenterLettersWithLocation.
  ///
  /// In pt_BR, this message translates to:
  /// **'Com localização'**
  String get privacyCenterLettersWithLocation;

  /// No description provided for @privacyCenterCapsules.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cápsulas'**
  String get privacyCenterCapsules;

  /// No description provided for @privacyCenterCapsulesTotal.
  ///
  /// In pt_BR, this message translates to:
  /// **'Total'**
  String get privacyCenterCapsulesTotal;

  /// No description provided for @privacyCenterSocial.
  ///
  /// In pt_BR, this message translates to:
  /// **'Social'**
  String get privacyCenterSocial;

  /// No description provided for @privacyCenterFollowers.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seguidores'**
  String get privacyCenterFollowers;

  /// No description provided for @privacyCenterFollowing.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seguindo'**
  String get privacyCenterFollowing;

  /// No description provided for @privacyCenterBlocks.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bloqueios'**
  String get privacyCenterBlocks;

  /// No description provided for @privacyCenterEngagement.
  ///
  /// In pt_BR, this message translates to:
  /// **'Engajamento'**
  String get privacyCenterEngagement;

  /// No description provided for @privacyCenterComments.
  ///
  /// In pt_BR, this message translates to:
  /// **'Comentários'**
  String get privacyCenterComments;

  /// No description provided for @privacyCenterLikes.
  ///
  /// In pt_BR, this message translates to:
  /// **'Curtidas'**
  String get privacyCenterLikes;

  /// No description provided for @privacyCenterBadges.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conquistas'**
  String get privacyCenterBadges;

  /// No description provided for @privacyCenterBadgesUnlocked.
  ///
  /// In pt_BR, this message translates to:
  /// **'Desbloqueadas'**
  String get privacyCenterBadgesUnlocked;

  /// No description provided for @privacyCenterBilling.
  ///
  /// In pt_BR, this message translates to:
  /// **'Assinatura'**
  String get privacyCenterBilling;

  /// No description provided for @privacyCenterSubscriptionTier.
  ///
  /// In pt_BR, this message translates to:
  /// **'Plano'**
  String get privacyCenterSubscriptionTier;

  /// No description provided for @privacyCenterSubscriptionStatus.
  ///
  /// In pt_BR, this message translates to:
  /// **'Status'**
  String get privacyCenterSubscriptionStatus;

  /// No description provided for @privacyCenterLocation.
  ///
  /// In pt_BR, this message translates to:
  /// **'Localização'**
  String get privacyCenterLocation;

  /// No description provided for @privacyCenterLocationExplainer.
  ///
  /// In pt_BR, this message translates to:
  /// **'O OpenWhen salva sua localização apenas quando você opta por incluí-la numa carta. A localização é opcional e controlada por carta.'**
  String get privacyCenterLocationExplainer;

  /// No description provided for @emailVerificationTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Verifique seu email'**
  String get emailVerificationTitle;

  /// No description provided for @emailVerificationSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Enviamos um link de verificação para {email}. Confirme para desbloquear o envio de cartas, cápsulas e comentários.'**
  String emailVerificationSubtitle(String email);

  /// No description provided for @emailVerificationResend.
  ///
  /// In pt_BR, this message translates to:
  /// **'Reenviar email'**
  String get emailVerificationResend;

  /// No description provided for @emailVerificationResendCooldown.
  ///
  /// In pt_BR, this message translates to:
  /// **'Reenviar em {seconds}s'**
  String emailVerificationResendCooldown(String seconds);

  /// No description provided for @emailVerificationAlreadyDone.
  ///
  /// In pt_BR, this message translates to:
  /// **'Já verifiquei'**
  String get emailVerificationAlreadyDone;

  /// No description provided for @emailVerificationNotYet.
  ///
  /// In pt_BR, this message translates to:
  /// **'Email ainda não verificado. Verifique sua caixa de entrada e pasta de spam.'**
  String get emailVerificationNotYet;

  /// No description provided for @emailVerificationLater.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mais tarde'**
  String get emailVerificationLater;

  /// No description provided for @registerSuccessVerify.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conta criada! Verifique seu email para confirmar.'**
  String get registerSuccessVerify;

  /// No description provided for @notificationEmailBounceTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Email não entregue'**
  String get notificationEmailBounceTitle;

  /// No description provided for @notificationEmailBounceBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'O email para {email} não pôde ser entregue. Verifique o endereço e tente novamente.'**
  String notificationEmailBounceBody(String email);

  /// No description provided for @notificationEmailSendFailedTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Email não enviado'**
  String get notificationEmailSendFailedTitle;

  /// No description provided for @notificationEmailSendFailedBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'O email para {email} não pôde ser enviado. Tente novamente mais tarde.'**
  String notificationEmailSendFailedBody(String email);

  /// No description provided for @resendEmail.
  ///
  /// In pt_BR, this message translates to:
  /// **'Reenviar'**
  String get resendEmail;

  /// No description provided for @resendEmailDialogTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Reenviar email de convite'**
  String get resendEmailDialogTitle;

  /// No description provided for @resendEmailDialogBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'O email para {email} falhou. Você pode editar o endereço e reenviar.'**
  String resendEmailDialogBody(String email);

  /// No description provided for @resendEmailSuccess.
  ///
  /// In pt_BR, this message translates to:
  /// **'Email reenviado com sucesso!'**
  String get resendEmailSuccess;

  /// No description provided for @resendEmailCooldown.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aguarde alguns minutos antes de reenviar.'**
  String get resendEmailCooldown;

  /// No description provided for @resendEmailGenericError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível reenviar o email. Tente novamente mais tarde.'**
  String get resendEmailGenericError;

  /// No description provided for @letterModerationWarning.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sua carta tem um tom que pode machucar. Quer revisar antes de selar?'**
  String get letterModerationWarning;

  /// No description provided for @letterModerationBlocked.
  ///
  /// In pt_BR, this message translates to:
  /// **'Esta carta não pode ser enviada. O OpenWhen existe para conectar pessoas com amor, superação e conexão genuína.'**
  String get letterModerationBlocked;

  /// No description provided for @letterModerationUnavailable.
  ///
  /// In pt_BR, this message translates to:
  /// **'A verificação de conteúdo está temporariamente indisponível. Tente novamente em alguns instantes.'**
  String get letterModerationUnavailable;

  /// No description provided for @letterModerationReviewBtn.
  ///
  /// In pt_BR, this message translates to:
  /// **'Revisar carta'**
  String get letterModerationReviewBtn;

  /// No description provided for @letterModerationSendAnywayBtn.
  ///
  /// In pt_BR, this message translates to:
  /// **'Enviar assim mesmo'**
  String get letterModerationSendAnywayBtn;

  /// No description provided for @letterModerationStepLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Verificando conteúdo…'**
  String get letterModerationStepLabel;

  /// No description provided for @capsuleModerationWarning.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sua cápsula tem um tom que pode machucar. Quer revisar antes de selar?'**
  String get capsuleModerationWarning;

  /// No description provided for @capsuleModerationBlocked.
  ///
  /// In pt_BR, this message translates to:
  /// **'Esta cápsula não pode ser criada. O OpenWhen existe para conectar pessoas com amor, superação e conexão genuína.'**
  String get capsuleModerationBlocked;

  /// No description provided for @capsuleModerationUnavailable.
  ///
  /// In pt_BR, this message translates to:
  /// **'A verificação de conteúdo está temporariamente indisponível. Tente novamente em alguns instantes.'**
  String get capsuleModerationUnavailable;

  /// No description provided for @capsuleModerationReviewBtn.
  ///
  /// In pt_BR, this message translates to:
  /// **'Revisar cápsula'**
  String get capsuleModerationReviewBtn;

  /// No description provided for @capsuleModerationSendAnywayBtn.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criar assim mesmo'**
  String get capsuleModerationSendAnywayBtn;

  /// No description provided for @mediaModerationImageRemovedTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Imagem removida'**
  String get mediaModerationImageRemovedTitle;

  /// No description provided for @mediaModerationImageRemovedBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Uma imagem que você enviou foi removida por não atender às diretrizes do OpenWhen.'**
  String get mediaModerationImageRemovedBody;

  /// No description provided for @mediaModerationAudioRemovedTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Áudio removido'**
  String get mediaModerationAudioRemovedTitle;

  /// No description provided for @mediaModerationAudioRemovedBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Um áudio que você enviou foi removido por não atender às diretrizes do OpenWhen.'**
  String get mediaModerationAudioRemovedBody;

  /// No description provided for @mediaModerationImageUnavailable.
  ///
  /// In pt_BR, this message translates to:
  /// **'Imagem indisponível'**
  String get mediaModerationImageUnavailable;

  /// No description provided for @mediaModerationAudioUnavailable.
  ///
  /// In pt_BR, this message translates to:
  /// **'Áudio indisponível'**
  String get mediaModerationAudioUnavailable;

  /// No description provided for @followersTabFollowers.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seguidores'**
  String get followersTabFollowers;

  /// No description provided for @followersTabFollowing.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seguindo'**
  String get followersTabFollowing;

  /// No description provided for @followersEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum seguidor ainda'**
  String get followersEmpty;

  /// No description provided for @followingEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não segue ninguém ainda'**
  String get followingEmpty;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
