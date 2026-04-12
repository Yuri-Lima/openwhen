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

  /// Account lifecycle: `active` | `pending_deletion`.
  /// When `pending_deletion`, the user can still log in but cannot send
  /// new letters/capsules. A scheduled Cloud Function will execute the
  /// actual deletion after the grace period expires.
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
      'accountStatus': accountStatus,
      if (deletionRequestedAt != null)
        'deletionRequestedAt': Timestamp.fromDate(deletionRequestedAt!),
      if (deletionMode != null) 'deletionMode': deletionMode,
      if (deletionScheduledFor != null)
        'deletionScheduledFor': Timestamp.fromDate(deletionScheduledFor!),
    };
  }
}
