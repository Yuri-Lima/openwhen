import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/theme/whenote_palette.dart';
import 'analytics_consent_provider.dart';
import 'consent_constants.dart';

/// A non-modal banner shown at the bottom of the screen for EU/EEA/UK users
/// who have not yet responded to the analytics consent prompt.
///
/// Usage: wrap your main content widget with [AnalyticsConsentOverlay].
/// The banner auto-dismisses after the user responds and does not block
/// interaction with the rest of the app.
class AnalyticsConsentOverlay extends ConsumerWidget {
  final Widget child;

  const AnalyticsConsentOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consent = ref.watch(analyticsConsentProvider);
    final notifier = ref.read(analyticsConsentProvider.notifier);

    return Stack(
      children: [
        child,
        if (notifier.shouldShowBanner && consent == AnalyticsConsentStatus.pending)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _AnalyticsConsentBanner(
              onAccept: () => notifier.setConsent(AnalyticsConsentStatus.granted),
              onDecline: () => notifier.setConsent(AnalyticsConsentStatus.denied),
            ),
          ),
      ],
    );
  }
}

class _AnalyticsConsentBanner extends StatefulWidget {
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _AnalyticsConsentBanner({
    required this.onAccept,
    required this.onDecline,
  });

  @override
  State<_AnalyticsConsentBanner> createState() => _AnalyticsConsentBannerState();
}

class _AnalyticsConsentBannerState extends State<_AnalyticsConsentBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Slide in after a brief delay so it doesn't appear instantly on launch.
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleAccept() {
    // Record consent immediately (before animation) to avoid losing the choice.
    widget.onAccept();
    _controller.reverse();
  }

  void _handleDecline() {
    // Record consent immediately (before animation) to avoid losing the choice.
    widget.onDecline();
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = Theme.of(context).extension<WhenotePalette>()!;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: palette.card,
            border: Border(
              top: BorderSide(color: palette.border, width: 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: palette.shadow.withValues(alpha:0.15),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(20, 16, 20, 12 + bottomPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.analyticsConsentTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.analyticsConsentBody,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.4,
                    ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _handleDecline,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: palette.inkSoft,
                        side: BorderSide(color: palette.border),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(l10n.analyticsConsentDecline),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: palette.accent,
                        foregroundColor: palette.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(l10n.analyticsConsentAccept),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
