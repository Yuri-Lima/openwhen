import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/billing/subscription_tier.dart';

class AppUser {
  final String uid;
  final String name;
  final String username;
  final String email;
  final String? photoUrl;
  final String? bio;
  final DateTime createdAt;
  final int lettersSentCount;
  final int lettersReceivedCount;
  final int lockedLettersCount;
  final int openedLettersCount;
  final String language;
  final String? country;

  /// Billing: `free` | `plus` | `pro` (Amanhã / Brisa / Horizonte).
  final SubscriptionTier subscriptionTier;

  /// Stripe Customer id (set by webhook); optional until first checkout.
  final String? stripeCustomerId;

  /// Active subscription id in Stripe (optional mirror).
  final String? stripeSubscriptionId;

  /// Mirror of Stripe subscription status, e.g. `active`, `past_due`, `canceled`.
  final String? subscriptionStatus;

  /// Whether the user has completed the first-action guide after registration.
  /// Defaults to `true` for existing users (no field in Firestore → skip guide).
  final bool hasCompletedFirstAction;

  /// Date of birth — required at registration for COPPA / GDPR Art. 8 compliance.
  /// Nullable for backwards compatibility with existing users.
  final DateTime? dateOfBirth;

  /// Analytics consent: 'granted' | 'denied' | null (legacy/pending).
  /// Stored in Firestore for audit trail; also cached in SharedPreferences
  /// for fast access before login.
  final String? analyticsConsent;

  /// When the user gave or changed analytics consent.
  final DateTime? analyticsConsentDate;

  /// Version of Terms of Use the user accepted (date string "YYYY-MM-DD").
  /// Null for legacy users who registered before versioning was introduced.
  final String? acceptedTermsVersion;

  /// Version of Privacy Policy the user accepted (date string "YYYY-MM-DD").
  final String? acceptedPrivacyVersion;

  /// When the user last accepted / re-accepted the legal documents.
  final DateTime? termsAcceptedAt;

  /// Account lifecycle: `active` | `pending_deletion` | `restricted`.
  /// - `pending_deletion`: user can log in but cannot send content; scheduled deletion pending.
  /// - `restricted`: GDPR Art. 18 restriction of processing — data is kept but no
  ///   processing beyond storage occurs (no sending, no moderation, no analytics).
  ///   User can lift the restriction at any time.
  final String accountStatus;

  /// When the user requested account deletion (null if not requested).
  final DateTime? deletionRequestedAt;

  /// The deletion mode chosen: `delete_all` or `anonymize` (null if not requested).
  final String? deletionMode;

  /// Scheduled date for the actual deletion (requestedAt + 15 days corridos).
  final DateTime? deletionScheduledFor;

  AppUser({
    required this.uid,
    required this.name,
    required this.username,
    required this.email,
    this.photoUrl,
    this.bio,
    required this.createdAt,
    this.lettersSentCount = 0,
    this.lettersReceivedCount = 0,
    this.lockedLettersCount = 0,
    this.openedLettersCount = 0,
    this.language = 'pt-BR',
    this.country,
    this.subscriptionTier = SubscriptionTier.free,
    this.stripeCustomerId,
    this.stripeSubscriptionId,
    this.subscriptionStatus,
    this.dateOfBirth,
    this.hasCompletedFirstAction = true,
    this.analyticsConsent,
    this.analyticsConsentDate,
    this.acceptedTermsVersion,
    this.acceptedPrivacyVersion,
    this.termsAcceptedAt,
    this.accountStatus = 'active',
    this.deletionRequestedAt,
    this.deletionMode,
    this.deletionScheduledFor,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      name: data['name'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'],
      bio: data['bio'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lettersSentCount: data['lettersSentCount'] ?? 0,
      lettersReceivedCount: data['lettersReceivedCount'] ?? 0,
      lockedLettersCount: data['lockedLettersCount'] ?? 0,
      openedLettersCount: data['openedLettersCount'] ?? 0,
      language: data['language'] ?? 'pt-BR',
      country: data['country'],
      subscriptionTier: subscriptionTierFromId(data['subscriptionTier'] as String?),
      stripeCustomerId: data['stripeCustomerId'] as String?,
      stripeSubscriptionId: data['stripeSubscriptionId'] as String?,
      subscriptionStatus: data['subscriptionStatus'] as String?,
      dateOfBirth: data['dateOfBirth'] != null
          ? (data['dateOfBirth'] as Timestamp).toDate()
          : null,
      hasCompletedFirstAction: data['hasCompletedFirstAction'] as bool? ?? true,
      analyticsConsent: data['analyticsConsent'] as String?,
      analyticsConsentDate: data['analyticsConsentDate'] != null
          ? (data['analyticsConsentDate'] as Timestamp).toDate()
          : null,
      acceptedTermsVersion: data['acceptedTermsVersion'] as String?,
      acceptedPrivacyVersion: data['acceptedPrivacyVersion'] as String?,
      termsAcceptedAt: data['termsAcceptedAt'] != null
          ? (data['termsAcceptedAt'] as Timestamp).toDate()
          : null,
      accountStatus: data['accountStatus'] as String? ?? 'active',
      deletionRequestedAt: data['deletionRequestedAt'] != null
          ? (data['deletionRequestedAt'] as Timestamp).toDate()
          : null,
      deletionMode: data['deletionMode'] as String?,
      deletionScheduledFor: data['deletionScheduledFor'] != null
          ? (data['deletionScheduledFor'] as Timestamp).toDate()
          : null,
    );
  }

  /// Whether this account is pending deletion (grace period active).
  bool get isPendingDeletion => accountStatus == 'pending_deletion';

  /// Whether processing is restricted (GDPR Art. 18).
  bool get isRestricted => accountStatus == 'restricted';

  /// Whether the user can perform write actions (send letters, capsules, etc.).
  /// Blocked when account is pending deletion.
  bool get canSendContent => accountStatus == 'active';

  /// Days remaining until the scheduled deletion executes.
  /// Returns 0 if not pending or if the date has passed.
  int get deletionDaysRemaining {
    if (deletionScheduledFor == null) return 0;
    final diff = deletionScheduledFor!.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'email': email,
      'photoUrl': photoUrl,
      'bio': bio,
      'createdAt': Timestamp.fromDate(createdAt),
      'lettersSentCount': lettersSentCount,
      'lettersReceivedCount': lettersReceivedCount,
      'lockedLettersCount': lockedLettersCount,
      'openedLettersCount': openedLettersCount,
      'language': language,
      'country': country,
      'subscriptionTier': subscriptionTierId(subscriptionTier),
      if (stripeCustomerId != null) 'stripeCustomerId': stripeCustomerId,
      if (stripeSubscriptionId != null) 'stripeSubscriptionId': stripeSubscriptionId,
      if (subscriptionStatus != null) 'subscriptionStatus': subscriptionStatus,
      if (dateOfBirth != null)
        'dateOfBirth': Timestamp.fromDate(dateOfBirth!),
      'hasCompletedFirstAction': hasCompletedFirstAction,
      if (analyticsConsent != null) 'analyticsConsent': analyticsConsent,
      if (analyticsConsentDate != null)
        'analyticsConsentDate': Timestamp.fromDate(analyticsConsentDate!),
      if (acceptedTermsVersion != null)
        'acceptedTermsVersion': acceptedTermsVersion,
      if (acceptedPrivacyVersion != null)
        'acceptedPrivacyVersion': acceptedPrivacyVersion,
      if (termsAcceptedAt != null)
        'termsAcceptedAt': Timestamp.fromDate(termsAcceptedAt!),
      'accountStatus': accountStatus,
      if (deletionRequestedAt != null)
        'deletionRequestedAt': Timestamp.fromDate(deletionRequestedAt!),
      if (deletionMode != null) 'deletionMode': deletionMode,
      if (deletionScheduledFor != null)
        'deletionScheduledFor': Timestamp.fromDate(deletionScheduledFor!),
    };
  }
}
