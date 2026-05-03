import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/firestore_collections.dart';
import 'policy_constants.dart';

/// State of the user's policy consent relative to the latest required version.
enum PolicyConsentState {
  /// No active policy update or user has already accepted.
  upToDate,

  /// A policy update exists but the effective date is in the future.
  /// Show an informational (non-blocking) banner.
  upcomingChange,

  /// The effective date has passed and the user hasn't accepted the new version.
  /// Show a blocking re-consent screen.
  requiresReConsent,
}

/// Represents an active policy update from `systemConfig/policyUpdate`.
class PolicyUpdate {
  final String termsVersion;
  final String privacyVersion;
  final DateTime effectiveDate;
  final DateTime? notifiedAt;
  final String summaryEn;
  final String summaryPt;
  final String summaryPtBR;
  final String summaryEs;
  final String changesUrl;
  final bool active;

  const PolicyUpdate({
    required this.termsVersion,
    required this.privacyVersion,
    required this.effectiveDate,
    this.notifiedAt,
    this.summaryEn = '',
    this.summaryPt = '',
    this.summaryPtBR = '',
    this.summaryEs = '',
    this.changesUrl = '',
    this.active = false,
  });

  factory PolicyUpdate.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    if (!snapshot.exists || snapshot.data() == null) {
      return PolicyUpdate(
        termsVersion: '',
        privacyVersion: '',
        effectiveDate: _epoch,
        active: false,
      );
    }
    final m = snapshot.data()!;
    return PolicyUpdate(
      termsVersion: m['termsVersion'] as String? ?? '',
      privacyVersion: m['privacyVersion'] as String? ?? '',
      effectiveDate: m['effectiveDate'] != null
          ? (m['effectiveDate'] as Timestamp).toDate()
          : _epoch,
      notifiedAt: m['notifiedAt'] != null
          ? (m['notifiedAt'] as Timestamp).toDate()
          : null,
      summaryEn: m['summaryEn'] as String? ?? '',
      summaryPt: m['summaryPt'] as String? ?? '',
      summaryPtBR: m['summaryPtBR'] as String? ?? '',
      summaryEs: m['summaryEs'] as String? ?? '',
      changesUrl: m['changesUrl'] as String? ?? '',
      active: m['active'] as bool? ?? false,
    );
  }

  /// Returns the summary in the user's language.
  String summaryForLang(String lang) {
    final l = lang.length >= 2 ? lang.substring(0, 2) : 'en';
    if (l == 'pt') return summaryPtBR.isNotEmpty ? summaryPtBR : summaryPt;
    if (l == 'es') return summaryEs.isNotEmpty ? summaryEs : summaryEn;
    return summaryEn;
  }

  static final DateTime _epoch = DateTime(1970);
}

/// Streams the active policy update document from Firestore.
final policyUpdateProvider = StreamProvider<PolicyUpdate>((ref) {
  return FirebaseFirestore.instance
      .collection(FirestoreCollections.systemConfig)
      .doc(FirestoreCollections.systemConfigPolicyUpdateDocId)
      .snapshots()
      .map(PolicyUpdate.fromSnapshot);
});

/// Determines whether the user needs to re-consent to updated policies.
///
/// [userAcceptedTermsVersion] and [userAcceptedPrivacyVersion] come from
/// the user's Firestore document. `null` means legacy user who accepted
/// the initial version ([kInitialPolicyVersion]).
PolicyConsentState checkPolicyConsent({
  required PolicyUpdate policyUpdate,
  required String? userAcceptedTermsVersion,
  required String? userAcceptedPrivacyVersion,
}) {
  if (!policyUpdate.active || policyUpdate.termsVersion.isEmpty) {
    return PolicyConsentState.upToDate;
  }

  final acceptedTerms = userAcceptedTermsVersion ?? kInitialPolicyVersion;
  final acceptedPrivacy = userAcceptedPrivacyVersion ?? kInitialPolicyVersion;

  final termsOutdated =
      acceptedTerms.compareTo(policyUpdate.termsVersion) < 0;
  final privacyOutdated =
      acceptedPrivacy.compareTo(policyUpdate.privacyVersion) < 0;

  if (!termsOutdated && !privacyOutdated) {
    return PolicyConsentState.upToDate;
  }

  final now = DateTime.now();
  if (policyUpdate.effectiveDate.isAfter(now)) {
    return PolicyConsentState.upcomingChange;
  }

  return PolicyConsentState.requiresReConsent;
}
