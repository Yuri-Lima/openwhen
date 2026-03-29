import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/feed_config.dart';
import '../../domain/feed_letter_filter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/app_theme.dart';

/// Explorar tab: real-time first page via [baseQuery] + optional `startAfter` pages.
class ExploreFeedPaged extends StatefulWidget {
  const ExploreFeedPaged({
    super.key,
    required this.baseQuery,
    required this.blockedSenderUids,
    required this.reportsEnabled,
    required this.buildLetterList,
    required this.buildEmpty,
    required this.buildFilterEmpty,
    required this.buildError,
  });

  final Query<Map<String, dynamic>> baseQuery;
  final Set<String> blockedSenderUids;
  final bool reportsEnabled;

  final Widget Function(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs, {
    required bool reportsEnabled,
  }) buildLetterList;

  final Widget Function() buildEmpty;
  final Widget Function() buildFilterEmpty;
  final Widget Function() buildError;

  @override
  State<ExploreFeedPaged> createState() => _ExploreFeedPagedState();
}

class _ExploreFeedPagedState extends State<ExploreFeedPaged> {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> _pagedExtra = [];
  bool _loadingMore = false;
  bool _hasMore = true;

  @override
  void didUpdateWidget(covariant ExploreFeedPaged oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.baseQuery != widget.baseQuery) {
      setState(() {
        _pagedExtra.clear();
        _hasMore = true;
      });
    }
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> _applyBlockedOnly(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    return docs.where((d) {
      return isFeedLetterVisibleForViewer(
        letterData: d.data(),
        blockedSenderUids: widget.blockedSenderUids,
      );
    }).toList();
  }

  Future<void> _loadMore(QueryDocumentSnapshot<Map<String, dynamic>> lastDoc) async {
    if (_loadingMore || !_hasMore) return;
    setState(() => _loadingMore = true);
    try {
      final snap = await widget.baseQuery.startAfterDocument(lastDoc).get();
      if (!mounted) return;
      if (snap.docs.isEmpty) {
        setState(() {
          _hasMore = false;
          _loadingMore = false;
        });
        return;
      }
      final existing = _pagedExtra.map((d) => d.id).toSet();
      for (final d in snap.docs) {
        if (!existing.contains(d.id)) {
          _pagedExtra.add(d);
          existing.add(d.id);
        }
      }
      if (snap.docs.length < FeedConfig.explorePageSize) {
        _hasMore = false;
      }
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: widget.baseQuery.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return widget.buildError();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final streamDocs = snapshot.data?.docs ?? [];
        final byId = <String, QueryDocumentSnapshot<Map<String, dynamic>>>{};
        for (final d in streamDocs) {
          byId[d.id] = d;
        }
        for (final d in _pagedExtra) {
          byId.putIfAbsent(d.id, () => d);
        }
        var merged = byId.values.toList();
        merged.sort((a, b) {
          final ta = a.data()['openedAt'] as Timestamp?;
          final tb = b.data()['openedAt'] as Timestamp?;
          if (ta != null && tb != null) {
            final c = tb.compareTo(ta);
            if (c != 0) return c;
          }
          return a.id.compareTo(b.id);
        });

        merged = _applyBlockedOnly(merged);
        if (merged.isEmpty) {
          return streamDocs.isEmpty && _pagedExtra.isEmpty
              ? widget.buildEmpty()
              : widget.buildFilterEmpty();
        }

        final lastChrono = merged.last;

        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _pagedExtra.clear();
                    _hasMore = true;
                  });
                },
                child: widget.buildLetterList(
                  merged,
                  reportsEnabled: widget.reportsEnabled,
                ),
              ),
            ),
            if (_hasMore)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _loadingMore
                    ? const SizedBox(
                        height: 36,
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      )
                    : TextButton(
                        onPressed: () => _loadMore(lastChrono),
                        child: Text(
                          l10n.feedLoadMore,
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: context.pal.accent,
                          ),
                        ),
                      ),
              ),
          ],
        );
      },
    );
  }
}
