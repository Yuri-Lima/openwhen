import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/open_when_palette.dart';

/// Shown in [MaterialApp.builder] when the software keyboard is open; tap to
/// unfocus and collapse the keyboard app-wide.
class KeyboardDismissOverlayButton extends StatelessWidget {
  const KeyboardDismissOverlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    if (bottomInset <= 0) return const SizedBox.shrink();

    final p = context.pal;
    final l10n = AppLocalizations.of(context)!;

    final pad = MediaQuery.paddingOf(context);

    return Positioned(
      left: pad.left + 16,
      bottom: bottomInset + 8,
      child: Semantics(
        label: l10n.keyboardDismissSemanticsLabel,
        tooltip: l10n.keyboardDismissTooltip,
        button: true,
        child: Material(
          color: p.card,
          elevation: 3,
          shadowColor: p.shadow,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            borderRadius: BorderRadius.circular(24),
            splashColor: p.accentWarm,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(
                Icons.keyboard_hide_rounded,
                size: 22,
                color: p.inkSoft,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
