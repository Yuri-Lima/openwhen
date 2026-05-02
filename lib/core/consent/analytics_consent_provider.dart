import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/analytics_service.dart';
import '../utils/age_verification.dart';
import 'consent_constants.dart';

final analyticsConsentProvider =
    NotifierProvider<AnalyticsConsentNotifier, AnalyticsConsentStatus>(
  AnalyticsConsentNotifier.new,
);

class AnalyticsConsentNotifier extends Notifier<AnalyticsConsentStatus> {
  @override
  AnalyticsConsentStatus build() {
    Future.microtask(_load);
    return AnalyticsConsentStatus.pending;
  }

  /// Loads the stored consent from SharedPreferences and applies it.
  /// If no consent is stored and the user is NOT in an EU/EEA/UK jurisdiction,
  /// auto-grants consent (no banner needed).
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(kAnalyticsConsentKey);

    if (raw != null) {
      // Stored consent found — apply it.
      try {
        final stored = AnalyticsConsentStatus.values.byName(raw);
        state = stored;
        await AnalyticsService.setEnabled(stored == AnalyticsConsentStatus.granted);
      } catch (_) {
        // Corrupted value — treat as pending.
      }
      return;
    }

    // No stored consent — check jurisdiction.
    if (!isEuEeaUkJurisdiction()) {
      // Non-EU: auto-grant without showing banner.
      await setConsent(AnalyticsConsentStatus.granted);
    }
    // EU/EEA/UK with no stored consent: state remains `pending`,
    // which triggers the banner in the UI.
  }

  /// Updates the consent status everywhere:
  /// 1. In-memory state (Riverpod)
  /// 2. SharedPreferences (fast local read on next launch)
  /// 3. Firebase Analytics SDK (enable/disable collection)
  /// 4. Firestore user document (audit trail, cross-device sync)
  Future<void> setConsent(AnalyticsConsentStatus consent) async {
    state = consent;

    final now = DateTime.now();

    // 1. SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(kAnalyticsConsentKey, consent.name);
      await prefs.setString(kAnalyticsConsentDateKey, now.toIso8601String());
    } catch (_) {
      // Best-effort — don't block on storage failure.
    }

    // 2. Firebase Analytics SDK
    await AnalyticsService.setEnabled(consent == AnalyticsConsentStatus.granted);

    // 3. Firestore (best-effort, only if logged in)
    _syncToFirestore(consent, now);
  }

  /// Best-effort sync of consent choice to Firestore for audit trail.
  void _syncToFirestore(AnalyticsConsentStatus consent, DateTime date) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(
          {
            'analyticsConsent': consent.name,
            'analyticsConsentDate': Timestamp.fromDate(date),
          },
          SetOptions(merge: true),
        )
        .catchError((_) {/* best-effort, ignore failures */});
  }

  /// Whether the consent banner should be shown.
  /// True only when: status is pending AND user is in EU/EEA/UK.
  bool get shouldShowBanner =>
      state == AnalyticsConsentStatus.pending && isEuEeaUkJurisdiction();

  /// Whether the user is in a jurisdiction that requires consent UI
  /// (used to conditionally show the toggle in Settings).
  bool get isConsentRequired => isEuEeaUkJurisdiction();
}
