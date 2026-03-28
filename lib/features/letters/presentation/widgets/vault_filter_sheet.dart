import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/app_theme.dart';
import '../vault_list_filters.dart';

Future<VaultFiltersState?> showVaultFilterSheet({
  required BuildContext context,
  required int tabIndex,
  required VaultFiltersState current,
}) {
  return showModalBottomSheet<VaultFiltersState>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _VaultFilterSheet(
      tabIndex: tabIndex,
      initial: current,
    ),
  );
}

class _VaultFilterSheet extends StatefulWidget {
  const _VaultFilterSheet({
    required this.tabIndex,
    required this.initial,
  });

  final int tabIndex;
  final VaultFiltersState initial;

  @override
  State<_VaultFilterSheet> createState() => _VaultFilterSheetState();
}

class _VaultFilterSheetState extends State<_VaultFilterSheet> {
  late WaitingTabFilters _waiting;
  late OpenedTabFilters _opened;
  late SentTabFilters _sent;
  late CapsulesTabFilters _capsules;

  late final TextEditingController _waitingQueryCtrl;
  late final TextEditingController _openedQueryCtrl;
  late final TextEditingController _sentQueryCtrl;
  late final TextEditingController _capsulesQueryCtrl;

  static const _themeIds = [
    'memories',
    'goals',
    'feelings',
    'relationships',
    'growth',
  ];

  @override
  void initState() {
    super.initState();
    _waiting = widget.initial.waiting;
    _opened = widget.initial.opened;
    _sent = widget.initial.sent;
    _capsules = widget.initial.capsules;
    _waitingQueryCtrl = TextEditingController(text: _waiting.query);
    _openedQueryCtrl = TextEditingController(text: _opened.query);
    _sentQueryCtrl = TextEditingController(text: _sent.query);
    _capsulesQueryCtrl = TextEditingController(text: _capsules.query);
  }

  @override
  void dispose() {
    _waitingQueryCtrl.dispose();
    _openedQueryCtrl.dispose();
    _sentQueryCtrl.dispose();
    _capsulesQueryCtrl.dispose();
    super.dispose();
  }

  VaultFiltersState _buildResult() {
    return VaultFiltersState(
      waiting: _waiting.copyWith(query: _waitingQueryCtrl.text),
      opened: _opened.copyWith(query: _openedQueryCtrl.text),
      sent: _sent.copyWith(query: _sentQueryCtrl.text),
      capsules: _capsules.copyWith(query: _capsulesQueryCtrl.text),
    );
  }

  void _apply() => Navigator.of(context).pop(_buildResult());

  void _clearAndClose() {
    Navigator.of(context).pop(widget.initial.clearTab(widget.tabIndex));
  }

  Future<void> _pickOpenDate({required bool isFrom}) async {
    final now = DateTime.now();
    final initial = isFrom
        ? (_waiting.openDateFrom ?? now)
        : (_waiting.openDateTo ?? now);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      setState(() {
        if (isFrom) {
          _waiting = _waiting.copyWith(openDateFrom: picked);
        } else {
          _waiting = _waiting.copyWith(openDateTo: picked);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final p = context.pal;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.88,
        ),
        decoration: BoxDecoration(
          color: p.bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: p.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 8, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.vaultFilterTitle,
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 20,
                        color: p.ink,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close_rounded, color: p.inkSoft),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: _buildTabBody(l10n, p),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clearAndClose,
                      child: Text(l10n.vaultFilterClear),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _apply,
                      child: Text(l10n.vaultFilterApply),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBody(AppLocalizations l10n, OpenWhenPalette p) {
    switch (widget.tabIndex) {
      case 0:
        return _waitingBody(l10n, p);
      case 1:
        return _openedBody(l10n, p);
      case 2:
        return _sentBody(l10n, p);
      case 3:
        return _capsulesBody(l10n, p);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _waitingBody(AppLocalizations l10n, OpenWhenPalette p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _waitingQueryCtrl,
          onChanged: (v) => _waiting = _waiting.copyWith(query: v),
          decoration: InputDecoration(
            hintText: l10n.vaultFilterSearchHint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            isDense: true,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.vaultFilterSortLabel,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: p.inkSoft,
          ),
        ),
        const SizedBox(height: 8),
        _sortDropdown<VaultWaitingSort>(
          value: _waiting.sort,
          items: VaultWaitingSort.values,
          labelFor: (s) => _waitingSortLabel(l10n, s),
          onChanged: (s) {
            if (s != null) setState(() => _waiting = _waiting.copyWith(sort: s));
          },
        ),
        const SizedBox(height: 16),
        Text(
          l10n.vaultFilterOpenDateFrom,
          style: GoogleFonts.dmSans(fontSize: 12, color: p.inkSoft),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _pickOpenDate(isFrom: true),
                child: Text(
                  _waiting.openDateFrom != null
                      ? _formatDate(_waiting.openDateFrom!)
                      : '—',
                  style: GoogleFonts.dmSans(fontSize: 13),
                ),
              ),
            ),
            if (_waiting.openDateFrom != null) ...[
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => setState(
                  () => _waiting = _waiting.copyWith(clearOpenDateFrom: true),
                ),
                icon: Icon(Icons.clear_rounded, color: p.inkSoft, size: 20),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        Text(
          l10n.vaultFilterOpenDateTo,
          style: GoogleFonts.dmSans(fontSize: 12, color: p.inkSoft),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _pickOpenDate(isFrom: false),
                child: Text(
                  _waiting.openDateTo != null
                      ? _formatDate(_waiting.openDateTo!)
                      : '—',
                  style: GoogleFonts.dmSans(fontSize: 13),
                ),
              ),
            ),
            if (_waiting.openDateTo != null) ...[
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => setState(
                  () => _waiting = _waiting.copyWith(clearOpenDateTo: true),
                ),
                icon: Icon(Icons.clear_rounded, color: p.inkSoft, size: 20),
              ),
            ],
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Widget _openedBody(AppLocalizations l10n, OpenWhenPalette p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _openedQueryCtrl,
          onChanged: (v) => _opened = _opened.copyWith(query: v),
          decoration: InputDecoration(
            hintText: l10n.vaultFilterSearchHint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            isDense: true,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.vaultFilterSortLabel,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: p.inkSoft,
          ),
        ),
        const SizedBox(height: 8),
        _sortDropdown<VaultOpenedSort>(
          value: _opened.sort,
          items: VaultOpenedSort.values,
          labelFor: (s) => _openedSortLabel(l10n, s),
          onChanged: (s) {
            if (s != null) setState(() => _opened = _opened.copyWith(sort: s));
          },
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilterChip(
              label: Text(l10n.vaultFilterDirectionAll),
              selected: _opened.direction == VaultOpenedDirection.all,
              onSelected: (_) => setState(
                () => _opened = _opened.copyWith(
                  direction: VaultOpenedDirection.all,
                ),
              ),
            ),
            FilterChip(
              label: Text(l10n.vaultFilterDirectionReceived),
              selected: _opened.direction == VaultOpenedDirection.received,
              onSelected: (_) => setState(
                () => _opened = _opened.copyWith(
                  direction: VaultOpenedDirection.received,
                ),
              ),
            ),
            FilterChip(
              label: Text(l10n.vaultFilterDirectionSent),
              selected: _opened.direction == VaultOpenedDirection.sent,
              onSelected: (_) => setState(
                () => _opened = _opened.copyWith(
                  direction: VaultOpenedDirection.sent,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _sentBody(AppLocalizations l10n, OpenWhenPalette p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _sentQueryCtrl,
          onChanged: (v) => _sent = _sent.copyWith(query: v),
          decoration: InputDecoration(
            hintText: l10n.vaultFilterSearchHint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            isDense: true,
          ),
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            l10n.vaultFilterPendingOnly,
            style: GoogleFonts.dmSans(fontSize: 14, color: p.ink),
          ),
          value: _sent.pendingOnly,
          onChanged: (v) => setState(() => _sent = _sent.copyWith(pendingOnly: v)),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.vaultFilterSortLabel,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: p.inkSoft,
          ),
        ),
        const SizedBox(height: 8),
        _sortDropdown<VaultSentSort>(
          value: _sent.sort,
          items: VaultSentSort.values,
          labelFor: (s) => _sentSortLabel(l10n, s),
          onChanged: (s) {
            if (s != null) setState(() => _sent = _sent.copyWith(sort: s));
          },
        ),
      ],
    );
  }

  String _themeLabel(AppLocalizations l10n, String id) {
    switch (id) {
      case 'memories':
        return l10n.capsuleThemeMemories;
      case 'goals':
        return l10n.capsuleThemeGoals;
      case 'feelings':
        return l10n.capsuleThemeFeelings;
      case 'relationships':
        return l10n.capsuleThemeRelationships;
      case 'growth':
        return l10n.capsuleThemeGrowth;
      default:
        return l10n.capsuleThemeDefault;
    }
  }

  Widget _capsulesBody(AppLocalizations l10n, OpenWhenPalette p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _capsulesQueryCtrl,
          onChanged: (v) => _capsules = _capsules.copyWith(query: v),
          decoration: InputDecoration(
            hintText: l10n.vaultFilterSearchHint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            isDense: true,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.vaultFilterSortLabel,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: p.inkSoft,
          ),
        ),
        const SizedBox(height: 8),
        _sortDropdown<VaultCapsulesSort>(
          value: _capsules.sort,
          items: VaultCapsulesSort.values,
          labelFor: (s) => _capsulesSortLabel(l10n, s),
          onChanged: (s) {
            if (s != null) {
              setState(() => _capsules = _capsules.copyWith(sort: s));
            }
          },
        ),
        const SizedBox(height: 16),
        Text(
          l10n.vaultFilterThemesLabel,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: p.inkSoft,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _themeIds.map((id) {
            final selected = _capsules.themes.contains(id);
            return FilterChip(
              label: Text(_themeLabel(l10n, id)),
              selected: selected,
              onSelected: (sel) {
                setState(() {
                  final next = Set<String>.from(_capsules.themes);
                  if (sel) {
                    next.add(id);
                  } else {
                    next.remove(id);
                  }
                  _capsules = _capsules.copyWith(themes: next);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _sortDropdown<T>({
    required T value,
    required List<T> items,
    required String Function(T) labelFor,
    required ValueChanged<T?> onChanged,
  }) {
    final p = context.pal;
    return InputDecorator(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          isDense: true,
          dropdownColor: p.card,
          style: GoogleFonts.dmSans(fontSize: 14, color: p.ink),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(labelFor(e), overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

String _waitingSortLabel(AppLocalizations l10n, VaultWaitingSort s) {
  switch (s) {
    case VaultWaitingSort.openDateAsc:
      return l10n.vaultSortWaitingOpenDateAsc;
    case VaultWaitingSort.openDateDesc:
      return l10n.vaultSortWaitingOpenDateDesc;
    case VaultWaitingSort.createdAtDesc:
      return l10n.vaultSortWaitingCreatedDesc;
    case VaultWaitingSort.createdAtAsc:
      return l10n.vaultSortWaitingCreatedAsc;
    case VaultWaitingSort.titleAsc:
      return l10n.vaultSortWaitingTitleAsc;
  }
}

String _openedSortLabel(AppLocalizations l10n, VaultOpenedSort s) {
  switch (s) {
    case VaultOpenedSort.openedAtDesc:
      return l10n.vaultSortOpenedOpenedAtDesc;
    case VaultOpenedSort.openedAtAsc:
      return l10n.vaultSortOpenedOpenedAtAsc;
    case VaultOpenedSort.openDateDesc:
      return l10n.vaultSortOpenedOpenDateDesc;
    case VaultOpenedSort.openDateAsc:
      return l10n.vaultSortOpenedOpenDateAsc;
    case VaultOpenedSort.titleAsc:
      return l10n.vaultSortOpenedTitleAsc;
  }
}

String _sentSortLabel(AppLocalizations l10n, VaultSentSort s) {
  switch (s) {
    case VaultSentSort.openDateAsc:
      return l10n.vaultSortSentOpenDateAsc;
    case VaultSentSort.openDateDesc:
      return l10n.vaultSortSentOpenDateDesc;
    case VaultSentSort.createdAtDesc:
      return l10n.vaultSortSentCreatedDesc;
    case VaultSentSort.createdAtAsc:
      return l10n.vaultSortSentCreatedAsc;
    case VaultSentSort.titleAsc:
      return l10n.vaultSortSentTitleAsc;
  }
}

String _capsulesSortLabel(AppLocalizations l10n, VaultCapsulesSort s) {
  switch (s) {
    case VaultCapsulesSort.openDateAsc:
      return l10n.vaultSortCapsulesOpenDateAsc;
    case VaultCapsulesSort.openDateDesc:
      return l10n.vaultSortCapsulesOpenDateDesc;
    case VaultCapsulesSort.createdAtDesc:
      return l10n.vaultSortCapsulesCreatedDesc;
    case VaultCapsulesSort.createdAtAsc:
      return l10n.vaultSortCapsulesCreatedAsc;
    case VaultCapsulesSort.titleAsc:
      return l10n.vaultSortCapsulesTitleAsc;
  }
}
