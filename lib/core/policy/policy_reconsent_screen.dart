import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

import '../../features/profile/presentation/screens/legal_screen.dart' show LegalScreen, LegalType;
import '../../shared/theme/whenote_palette.dart';
import '../constants/firestore_collections.dart';
import 'policy_constants.dart';
import 'policy_update_provider.dart';

/// Full-screen blocking dialog shown when the user must accept updated policies.
///
/// Cannot be dismissed via back button or swipe. The user must either accept
/// the new terms or log out.
class PolicyReConsentScreen extends StatefulWidget {
  final PolicyUpdate policyUpdate;
  final VoidCallback onAccepted;

  const PolicyReConsentScreen({
    super.key,
    required this.policyUpdate,
    required this.onAccepted,
  });

  @override
  State<PolicyReConsentScreen> createState() => _PolicyReConsentScreenState();
}

class _PolicyReConsentScreenState extends State<PolicyReConsentScreen> {
  bool _accepted = false;
  bool _saving = false;
  late final TapGestureRecognizer _viewFullTapRecognizer;

  @override
  void initState() {
    super.initState();
    _viewFullTapRecognizer = TapGestureRecognizer();
  }

  @override
  void dispose() {
    _viewFullTapRecognizer.dispose();
    super.dispose();
  }

  Future<void> _acceptAndContinue() async {
    if (_saving) return;
    setState(() => _saving = true);

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      await FirebaseFirestore.instance
          .collection(FirestoreCollections.users)
          .doc(uid)
          .update({
        'acceptedTermsVersion': widget.policyUpdate.termsVersion,
        'acceptedPrivacyVersion': widget.policyUpdate.privacyVersion,
        'termsAcceptedAt': Timestamp.now(),
      });

      widget.onAccepted();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      setState(() => _saving = false);
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = Theme.of(context).extension<WhenotePalette>()!;
    final lang = Localizations.localeOf(context).languageCode;
    final summary = widget.policyUpdate.summaryForLang(lang);
    final effectiveDate =
        widget.policyUpdate.effectiveDate.toIso8601String().substring(0, 10);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: palette.bg,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),

                // Icon
                Icon(
                  Icons.policy_outlined,
                  size: 48,
                  color: palette.accent,
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  l10n.policyReconsentTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Subtitle
                Text(
                  l10n.policyReconsentBody,
                  style: TextStyle(
                    fontSize: 14,
                    color: palette.inkSoft,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Effective date
                Text(
                  l10n.policyReconsentEffectiveDate(effectiveDate),
                  style: TextStyle(
                    fontSize: 13,
                    color: palette.inkSoft,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Summary card
                if (summary.isNotEmpty) ...[
                  Text(
                    l10n.policyReconsentSummaryLabel,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: palette.ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: palette.card,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      summary,
                      style: TextStyle(
                        fontSize: 13,
                        color: palette.inkSoft,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                // Link to full document
                _buildViewFullLink(l10n, palette),

                const Spacer(),

                // Checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _accepted,
                        onChanged: (v) => setState(() => _accepted = v ?? false),
                        activeColor: palette.accent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _accepted = !_accepted),
                        child: Text(
                          l10n.policyReconsentCheckbox,
                          style: TextStyle(
                            fontSize: 13,
                            color: palette.ink,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Accept button
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _accepted && !_saving ? _acceptAndContinue : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: palette.accent,
                      foregroundColor: palette.bg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _saving
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: palette.bg,
                            ),
                          )
                        : Text(l10n.policyReconsentAccept),
                  ),
                ),
                const SizedBox(height: 12),

                // Logout button
                TextButton(
                  onPressed: _saving ? null : _logout,
                  child: Text(
                    l10n.policyReconsentLogout,
                    style: TextStyle(color: palette.inkSoft),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildViewFullLink(AppLocalizations l10n, WhenotePalette palette) {
    final url = widget.policyUpdate.changesUrl.isNotEmpty
        ? widget.policyUpdate.changesUrl
        : 'https://whenote.app/privacy.html';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: l10n.policyReconsentViewFull,
          style: TextStyle(
            fontSize: 13,
            color: palette.accent,
            decoration: TextDecoration.underline,
          ),
          recognizer: _viewFullTapRecognizer
            ..onTap = () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LegalScreen(type: LegalType.privacy)),
              );
            },
        ),
      ),
    );
  }
}
