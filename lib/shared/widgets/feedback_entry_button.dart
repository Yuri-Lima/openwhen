import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/firestore_collections.dart';
import '../../l10n/app_localizations.dart';
import '../theme/open_when_palette.dart';

const int kFeedbackMaxMessageLength = 4000;

const String _kSupportEmail = 'suporte@openwhen.app';

String _feedbackPlatformLabel() {
  if (kIsWeb) return 'web';
  return switch (defaultTargetPlatform) {
    TargetPlatform.android => 'android',
    TargetPlatform.iOS => 'ios',
    TargetPlatform.macOS => 'macos',
    TargetPlatform.windows => 'windows',
    TargetPlatform.linux => 'linux',
    TargetPlatform.fuchsia => 'fuchsia',
  };
}

/// Opens the feedback bottom sheet (same as [FeedbackEntryButton]).
void showFeedbackSheet(
  BuildContext context, {
  GlobalKey<NavigatorState>? navigatorKey,
}) {
  final navContext = navigatorKey?.currentContext ?? context;
  showModalBottomSheet<void>(
    context: navContext,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const _FeedbackSheet(),
  );
}

/// Small control to collect product feedback.
///
/// Pass [navigatorKey] equal to [MaterialApp.navigatorKey] when this widget is **outside** the
/// [Navigator] subtree (e.g. [MaterialApp.builder] overlay). Omit it when built under a normal
/// route (e.g. feed header) so the sheet uses [BuildContext] that has a [Navigator] ancestor.
///
/// [forDarkHeader] uses a light icon for gradient / dark app bars (e.g. feed next to the owl).
class FeedbackEntryButton extends StatelessWidget {
  const FeedbackEntryButton({
    super.key,
    this.navigatorKey,
    this.forDarkHeader = false,
  });

  final GlobalKey<NavigatorState>? navigatorKey;
  final bool forDarkHeader;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final l10n = AppLocalizations.of(context)!;
    final iconColor = forDarkHeader
        ? Colors.white.withValues(alpha: 0.85)
        : p.inkSoft;
    final splash = forDarkHeader
        ? Colors.white.withValues(alpha: 0.12)
        : null;
    return Semantics(
      label: l10n.feedbackSemanticsLabel,
      tooltip: l10n.feedbackTooltip,
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => showFeedbackSheet(context, navigatorKey: navigatorKey),
          borderRadius: BorderRadius.circular(24),
          splashColor: splash,
          highlightColor: splash,
          child: Padding(
            padding: forDarkHeader
                ? const EdgeInsets.all(6)
                : const EdgeInsets.all(10),
            child: Icon(
              Icons.feedback_outlined,
              size: forDarkHeader ? 20 : 22,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedbackSheet extends StatefulWidget {
  const _FeedbackSheet();

  @override
  State<_FeedbackSheet> createState() => _FeedbackSheetState();
}

class _FeedbackSheetState extends State<_FeedbackSheet> {
  final TextEditingController _controller = TextEditingController();
  String _type = 'feature';
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _typeLabel(AppLocalizations l10n) {
    return switch (_type) {
      'feature' => l10n.feedbackTypeFeature,
      'recommendation' => l10n.feedbackTypeRecommendation,
      _ => l10n.feedbackTypeGeneral,
    };
  }

  Future<void> _launchMailto(String message, ScaffoldMessengerState messenger) async {
    final l10n = AppLocalizations.of(context)!;
    final subject = Uri.encodeComponent('OpenWhen feedback');
    final body = Uri.encodeComponent(
      '${l10n.feedbackEmailBodyPrefix(_typeLabel(l10n))}\n\n$message',
    );
    final uri = Uri.parse('mailto:$_kSupportEmail?subject=$subject&body=$body');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
        if (mounted) Navigator.of(context).pop();
      } else {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.feedbackCouldNotOpenEmail)),
        );
      }
    } catch (_) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.feedbackCouldNotOpenEmail)),
        );
      }
    }
  }

  Future<void> _submit() async {
    if (_submitting) return;
    final l10n = AppLocalizations.of(context)!;
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _error = l10n.feedbackEmptyError);
      return;
    }
    if (text.length > kFeedbackMaxMessageLength) {
      setState(() => _error = l10n.feedbackTooLongError);
      return;
    }
    setState(() {
      _error = null;
    });

    final messenger = ScaffoldMessenger.of(context);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      await _launchMailto(text, messenger);
      return;
    }

    setState(() => _submitting = true);
    try {
      await FirebaseFirestore.instance.collection(FirestoreCollections.feedback).add({
        'uid': user.uid,
        'type': _type,
        'message': text,
        'createdAt': FieldValue.serverTimestamp(),
        'appLocale': Localizations.localeOf(context).toLanguageTag(),
        'platform': _feedbackPlatformLabel(),
      });
      if (!mounted) return;
      Navigator.of(context).pop();
      messenger.showSnackBar(SnackBar(content: Text(l10n.feedbackSuccess)));
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.errorGeneric(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final len = _controller.text.length;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.92,
        ),
        decoration: BoxDecoration(
          color: p.bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: p.border),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: p.inkFaint,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.feedbackSheetTitle,
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 20,
                  color: p.ink,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.feedbackCategoryLabel,
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  color: p.inkSoft,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    selected: _type == 'feature',
                    label: Text(
                      l10n.feedbackTypeFeature,
                      style: GoogleFonts.dmSans(fontSize: 13),
                    ),
                    onSelected: (_) => setState(() => _type = 'feature'),
                  ),
                  ChoiceChip(
                    selected: _type == 'recommendation',
                    label: Text(
                      l10n.feedbackTypeRecommendation,
                      style: GoogleFonts.dmSans(fontSize: 13),
                    ),
                    onSelected: (_) => setState(() => _type = 'recommendation'),
                  ),
                  ChoiceChip(
                    selected: _type == 'general',
                    label: Text(
                      l10n.feedbackTypeGeneral,
                      style: GoogleFonts.dmSans(fontSize: 13),
                    ),
                    onSelected: (_) => setState(() => _type = 'general'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                maxLines: 6,
                maxLength: kFeedbackMaxMessageLength,
                onChanged: (_) => setState(() {}),
                style: GoogleFonts.dmSans(fontSize: 14, color: p.ink),
                decoration: InputDecoration(
                  hintText: l10n.feedbackMessageHint,
                  hintStyle: GoogleFonts.dmSans(fontSize: 14, color: p.inkFaint),
                  filled: true,
                  fillColor: p.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: p.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: p.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: p.accent, width: 1.5),
                  ),
                  counterText: l10n.feedbackCharCount(len, kFeedbackMaxMessageLength),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: GoogleFonts.dmSans(fontSize: 12, color: p.accent),
                ),
              ],
              if (FirebaseAuth.instance.currentUser == null) ...[
                const SizedBox(height: 12),
                Text(
                  l10n.feedbackSignedOutHint,
                  style: GoogleFonts.dmSans(fontSize: 12, color: p.inkSoft, height: 1.4),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitting
                    ? null
                    : () {
                        FocusScope.of(context).unfocus();
                        _submit();
                      },
                child: _submitting
                    ? SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: p.elevatedButtonFg,
                        ),
                      )
                    : Text(l10n.feedbackSubmit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
