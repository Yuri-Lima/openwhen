import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

import '../../shared/theme/whenote_palette.dart';
import 'policy_update_provider.dart';

/// Non-blocking banner shown when a policy update is upcoming but not yet
/// effective. Dismissible — stored in widget state only (reappears on restart,
/// which is fine since the user should be reminded each session).
class PolicyUpdateBanner extends StatefulWidget {
  final PolicyUpdate policyUpdate;
  final Widget child;

  const PolicyUpdateBanner({
    super.key,
    required this.policyUpdate,
    required this.child,
  });

  @override
  State<PolicyUpdateBanner> createState() => _PolicyUpdateBannerState();
}

class _PolicyUpdateBannerState extends State<PolicyUpdateBanner>
    with SingleTickerProviderStateMixin {
  bool _dismissed = false;
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Delay appearance slightly so the main screen settles first.
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      if (mounted) setState(() => _dismissed = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (!_dismissed)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SlideTransition(
              position: _slideAnimation,
              child: _BannerContent(
                policyUpdate: widget.policyUpdate,
                onDismiss: _dismiss,
              ),
            ),
          ),
      ],
    );
  }
}

class _BannerContent extends StatelessWidget {
  final PolicyUpdate policyUpdate;
  final VoidCallback onDismiss;

  const _BannerContent({
    required this.policyUpdate,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = Theme.of(context).extension<WhenotePalette>()!;
    final effectiveDate =
        policyUpdate.effectiveDate.toIso8601String().substring(0, 10);

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
        decoration: BoxDecoration(
          color: palette.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: palette.accent.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 20,
              color: palette.accent,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.policyUpdateBannerTitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: palette.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.policyUpdateBannerBody(effectiveDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: palette.inkSoft,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: onDismiss,
                    child: Text(
                      l10n.policyUpdateBannerDismiss,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: palette.accent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onDismiss,
              child: Icon(
                Icons.close,
                size: 18,
                color: palette.inkSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
