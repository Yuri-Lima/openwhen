import '../../../l10n/app_localizations.dart';
import '../data/auth_service.dart';

String authErrorMessage(AppLocalizations l10n, Object? error) {
  final code = error is AuthException ? error.code : AuthErrorCode.unknown;
  switch (code) {
    case AuthErrorCode.invalidCredentials:
      return l10n.authErrorInvalidCredentials;
    case AuthErrorCode.invalidEmail:
      return l10n.authErrorInvalidEmail;
    case AuthErrorCode.weakPassword:
      return l10n.authErrorWeakPassword;
    case AuthErrorCode.emailAlreadyInUse:
      return l10n.authErrorEmailAlreadyInUse;
    case AuthErrorCode.tooManyRequests:
      return l10n.authErrorTooManyRequests;
    case AuthErrorCode.networkError:
      return l10n.authErrorNetwork;
    case AuthErrorCode.userDisabled:
      return l10n.authErrorUserDisabled;
    case AuthErrorCode.unknown:
      return l10n.authErrorGeneric;
  }
}
