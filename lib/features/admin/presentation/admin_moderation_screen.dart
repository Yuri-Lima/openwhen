import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/admin/admin_functions_service.dart';
import '../../../core/admin/admin_moderation_info.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/theme/app_theme.dart';

/// Moderation queue (reports, feedback, human review, AI ops incidents) for users with `admin` claim.
class AdminModerationScreen extends ConsumerStatefulWidget {
  const AdminModerationScreen({super.key});

  @override
  ConsumerState<AdminModerationScreen> createState() => _AdminModerationScreenState();
}

class _AdminModerationScreenState extends ConsumerState<AdminModerationScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _admin = AdminFunctionsService();

  List<Map<String, dynamic>> _reports = [];
  List<Map<String, dynamic>> _feedback = [];
  List<Map<String, dynamic>> _reviews = [];
  List<Map<String, dynamic>> _incidents = [];
  bool _loadingReports = true;
  bool _loadingFeedback = true;
  bool _loadingReviews = true;
  bool _loadingIncidents = true;
  bool _loadingModerationInfo = true;
  AdminModerationInfo? _moderationInfo;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Do not call setState from async loaders synchronously during initState — their first
    // lines run before initState returns and will crash / assert. Defer after frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadModerationInfo();
      _loadReports();
      _loadFeedback();
      _loadReviews();
      _loadIncidents();
    });
  }

  Future<void> _loadModerationInfo() async {
    setState(() => _loadingModerationInfo = true);
    try {
      final info = await _admin.getModerationInfo();
      if (mounted) setState(() => _moderationInfo = info);
    } catch (_) {
      if (mounted) setState(() => _moderationInfo = null);
    }
    if (mounted) setState(() => _loadingModerationInfo = false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadReports() async {
    setState(() {
      _loadingReports = true;
      _error = null;
    });
    try {
      final list = await _admin.listPendingReports();
      if (mounted) setState(() => _reports = list);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _reports = [];
        });
      }
    }
    if (mounted) setState(() => _loadingReports = false);
  }

  Future<void> _loadFeedback() async {
    setState(() => _loadingFeedback = true);
    try {
      final list = await _admin.listRecentFeedback();
      if (mounted) setState(() => _feedback = list);
    } catch (e) {
      if (mounted) setState(() => _feedback = []);
    }
    if (mounted) setState(() => _loadingFeedback = false);
  }

  Future<void> _loadReviews() async {
    setState(() => _loadingReviews = true);
    try {
      final (list, _) = await _admin.listPendingModerationReviews();
      if (mounted) setState(() => _reviews = list);
    } catch (e) {
      if (mounted) setState(() => _reviews = []);
    }
    if (mounted) setState(() => _loadingReviews = false);
  }

  Future<void> _loadIncidents() async {
    setState(() => _loadingIncidents = true);
    try {
      final list = await _admin.listModerationIncidents();
      if (mounted) setState(() => _incidents = list);
    } catch (e) {
      if (mounted) setState(() => _incidents = []);
    }
    if (mounted) setState(() => _loadingIncidents = false);
  }

  String _ts(Map<String, dynamic> m) {
    final c = m['createdAt'];
    if (c is Timestamp) {
      return c.toDate().toIso8601String();
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.pal.bg,
      appBar: AppBar(
        backgroundColor: context.pal.headerGradient.first,
        foregroundColor: context.pal.white,
        title: Text(
          l10n.adminModerationTitle,
          style: GoogleFonts.dmSerifDisplay(fontSize: 20, fontStyle: FontStyle.italic),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          labelColor: context.pal.white,
          unselectedLabelColor: Colors.white54,
          indicatorColor: context.pal.accent,
          labelStyle: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w500),
          tabs: [
            Tab(text: l10n.adminModerationReportsTab),
            Tab(text: l10n.adminModerationFeedbackTab),
            Tab(text: l10n.adminModerationReviewsTab),
            Tab(text: l10n.adminModerationIncidentsTab),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_loadingModerationInfo)
            const LinearProgressIndicator(minHeight: 2)
          else if (_moderationInfo != null)
            _buildModerationProviderBanner(context, l10n, _moderationInfo!),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildReportsTab(),
                _buildFeedbackTab(),
                _buildReviewsTab(),
                _buildIncidentsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModerationProviderBanner(
    BuildContext context,
    AppLocalizations l10n,
    AdminModerationInfo info,
  ) {
    final providerLabel = info.providerId == 'openai'
        ? l10n.adminModerationProviderOpenai
        : info.providerId;
    final credOk = info.credentialsConfigured;
    return Material(
      color: context.pal.card,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.adminModerationAiBannerTitle,
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: context.pal.inkSoft,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              providerLabel,
              style: GoogleFonts.dmSans(fontSize: 15, color: context.pal.ink),
            ),
            const SizedBox(height: 4),
            Text(
              credOk ? l10n.adminModerationCredentialsOk : l10n.adminModerationCredentialsMissing,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: credOk ? context.pal.inkSoft : context.pal.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsTab() {
    final l10n = AppLocalizations.of(context)!;
    if (_loadingReports) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.adminModerationLoadError,
            textAlign: TextAlign.center,
            style: TextStyle(color: context.pal.inkSoft),
          ),
        ),
      );
    }
    if (_reports.isEmpty) {
      return Center(child: Text(l10n.adminModerationEmpty, style: TextStyle(color: context.pal.inkSoft)));
    }
    return RefreshIndicator(
      onRefresh: _loadReports,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _reports.length,
        itemBuilder: (context, i) {
          final r = _reports[i];
          final id = r['id'] as String? ?? '';
          return Card(
            color: context.pal.card,
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${r['targetType']} · ${r['reason']}',
                    style: TextStyle(fontWeight: FontWeight.w600, color: context.pal.ink),
                  ),
                  const SizedBox(height: 4),
                  Text('letterId: ${r['letterId']}', style: TextStyle(fontSize: 12, color: context.pal.inkSoft)),
                  Text('targetId: ${r['targetId']}', style: TextStyle(fontSize: 12, color: context.pal.inkSoft)),
                  Text(_ts(r), style: TextStyle(fontSize: 11, color: context.pal.inkFaint)),
                  if ((r['detail'] as String?)?.isNotEmpty == true) ...[
                    const SizedBox(height: 8),
                    _BidirectionalScrollText(
                      text: r['detail'] as String,
                      style: TextStyle(fontSize: 13, color: context.pal.inkSoft),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () async {
                          await _admin.resolveReport(reportId: id, resolution: 'dismissed');
                          await _loadReports();
                        },
                        child: Text(l10n.adminModerationResolve),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () async {
                          await _admin.resolveReport(reportId: id, resolution: 'resolved');
                          await _loadReports();
                        },
                        child: Text(l10n.adminModerationConfirm),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeedbackTab() {
    final l10n = AppLocalizations.of(context)!;
    if (_loadingFeedback) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_feedback.isEmpty) {
      return Center(child: Text(l10n.adminModerationEmpty, style: TextStyle(color: context.pal.inkSoft)));
    }
    return RefreshIndicator(
      onRefresh: _loadFeedback,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _feedback.length,
        itemBuilder: (context, i) {
          final r = _feedback[i];
          return Card(
            color: context.pal.card,
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${r['type'] ?? ''}',
                    style: TextStyle(fontWeight: FontWeight.w600, color: context.pal.ink),
                  ),
                  const SizedBox(height: 4),
                  Text(_ts(r), style: TextStyle(fontSize: 11, color: context.pal.inkFaint)),
                  const SizedBox(height: 8),
                  _BidirectionalScrollText(
                    text: '${r['message'] ?? ''}',
                    style: TextStyle(fontSize: 14, color: context.pal.inkSoft),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _approveReview(String id) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await _admin.resolveModerationReview(reviewId: id, decision: 'approved');
      if (mounted) await _loadReviews();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.adminModerationReviewsLoadError)),
        );
      }
    }
  }

  Future<void> _rejectReviewDialog(String id) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.adminModerationReject),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.adminModerationFeedbackLabel,
            hintText: l10n.adminModerationFeedbackHint,
          ),
          maxLines: 4,
          maxLength: 4000,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel)),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isEmpty) return;
              Navigator.pop(ctx, true);
            },
            child: Text(l10n.adminModerationReject),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final feedback = controller.text.trim();
    if (feedback.isEmpty) return;
    try {
      await _admin.resolveModerationReview(
        reviewId: id,
        decision: 'rejected',
        userFeedback: feedback,
      );
      if (mounted) await _loadReviews();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.adminModerationReviewsLoadError)),
        );
      }
    }
  }

  Widget _buildReviewsTab() {
    final l10n = AppLocalizations.of(context)!;
    if (_loadingReviews) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_reviews.isEmpty) {
      return Center(child: Text(l10n.adminModerationEmpty, style: TextStyle(color: context.pal.inkSoft)));
    }
    return RefreshIndicator(
      onRefresh: _loadReviews,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _reviews.length,
        itemBuilder: (context, i) {
          final r = _reviews[i];
          final id = r['id'] as String? ?? '';
          final text = '${r['text'] ?? ''}';
          return Card(
            color: context.pal.card,
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${r['authorDisplayName'] ?? ''} · letter ${r['letterId'] ?? ''}',
                    style: TextStyle(fontWeight: FontWeight.w600, color: context.pal.ink),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'flagged: ${r['flagged']} · review $id',
                    style: TextStyle(fontSize: 11, color: context.pal.inkFaint),
                  ),
                  const SizedBox(height: 8),
                  _BidirectionalScrollText(
                    text: text,
                    style: TextStyle(fontSize: 14, color: context.pal.inkSoft),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      FilledButton(
                        onPressed: id.isEmpty ? null : () => _approveReview(id),
                        child: Text(l10n.adminModerationApprove),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: id.isEmpty ? null : () => _rejectReviewDialog(id),
                        child: Text(l10n.adminModerationReject),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIncidentsTab() {
    final l10n = AppLocalizations.of(context)!;
    if (_loadingIncidents) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_incidents.isEmpty) {
      return Center(child: Text(l10n.adminModerationEmpty, style: TextStyle(color: context.pal.inkSoft)));
    }
    return RefreshIndicator(
      onRefresh: _loadIncidents,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _incidents.length,
        itemBuilder: (context, i) {
          final r = _incidents[i];
          final count = r['count'];
          return Card(
            color: context.pal.card,
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${r['kind'] ?? ''} · ${r['severity'] ?? ''}',
                    style: TextStyle(fontWeight: FontWeight.w600, color: context.pal.ink),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${r['providerId'] ?? ''}',
                    style: TextStyle(fontSize: 12, color: context.pal.inkSoft),
                  ),
                  if (count != null)
                    Text('count: $count', style: TextStyle(fontSize: 12, color: context.pal.inkSoft)),
                  Text(_tsIncident(r), style: TextStyle(fontSize: 11, color: context.pal.inkFaint)),
                  const SizedBox(height: 8),
                  _BidirectionalScrollText(
                    text: '${r['message'] ?? ''}',
                    style: TextStyle(fontSize: 14, color: context.pal.inkSoft),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _tsIncident(Map<String, dynamic> r) {
    final last = r['lastOccurredAt'];
    if (last is Timestamp) {
      return last.toDate().toIso8601String();
    }
    if (last is Map && last['_seconds'] != null) {
      final s = last['_seconds'] as num;
      return DateTime.fromMillisecondsSinceEpoch((s * 1000).toInt()).toIso8601String();
    }
    if (last is String) return last;
    return _ts(r);
  }
}

/// Wraps at list width; horizontal pan when a line is wider (e.g. long URLs). [ListView] supplies vertical scroll.
class _BidirectionalScrollText extends StatelessWidget {
  const _BidirectionalScrollText({
    required this.text,
    required this.style,
  });

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        if (!w.isFinite || w <= 0) {
          return SelectionArea(child: Text(text, style: style));
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: w),
            child: SelectionArea(
              child: Text(
                text,
                style: style,
                softWrap: true,
              ),
            ),
          ),
        );
      },
    );
  }
}
