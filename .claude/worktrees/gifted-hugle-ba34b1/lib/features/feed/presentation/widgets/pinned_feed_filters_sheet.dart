import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/app_theme.dart';

/// Bottom sheet to pick 1–3 semantic mood filter ids (0–3) for the feed chip row.
class PinnedFeedFiltersSheet extends StatefulWidget {
  const PinnedFeedFiltersSheet({
    super.key,
    required this.initialPins,
    required this.onSave,
  });

  final List<int> initialPins;
  final void Function(List<int> pins) onSave;

  @override
  State<PinnedFeedFiltersSheet> createState() => _PinnedFeedFiltersSheetState();
}

class _PinnedFeedFiltersSheetState extends State<PinnedFeedFiltersSheet> {
  static const int _maxPins = 3;
  late List<int> _pins;

  @override
  void initState() {
    super.initState();
    _pins = List<int>.from(widget.initialPins);
    if (_pins.isEmpty) {
      _pins = [0];
    }
  }

  String _label(AppLocalizations l10n, int id) {
    switch (id) {
      case 0:
        return l10n.feedFilterAll;
      case 1:
        return l10n.feedFilterLove;
      case 2:
        return l10n.feedFilterFriendship;
      case 3:
        return l10n.feedFilterFamily;
      default:
        return l10n.feedFilterAll;
    }
  }

  bool _canToggle(int id) {
    if (_pins.contains(id)) return _pins.length > 1;
    return _pins.length < _maxPins;
  }

  void _toggle(int id) {
    setState(() {
      if (_pins.contains(id)) {
        if (_pins.length <= 1) return;
        _pins.remove(id);
      } else {
        if (_pins.length >= _maxPins) return;
        _pins.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: context.pal.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.feedPinFiltersSheetTitle,
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 20,
                  color: context.pal.ink,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.feedPinFiltersMaxNote,
                style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft, height: 1.4),
              ),
            ),
            const SizedBox(height: 12),
            for (var id = 0; id <= 3; id++)
              CheckboxListTile(
                value: _pins.contains(id),
                onChanged: _canToggle(id) ? (_) => _toggle(id) : null,
                title: Text(
                  _label(l10n, id),
                  style: GoogleFonts.dmSans(fontSize: 15, color: context.pal.ink),
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FilledButton(
                onPressed: () {
                  widget.onSave(List<int>.from(_pins));
                  Navigator.of(context).pop();
                },
                child: Text(l10n.feedPinFiltersSave, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
