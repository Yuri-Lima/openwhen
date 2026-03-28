import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/admin/admin_functions_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/theme/app_theme.dart';

/// Minimal moderation queue (reports + feedback) for users with `admin` claim.
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
  bool _loadingReports = true;
  bool _loadingFeedback = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadReports();
    _loadFeedback();
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
          labelColor: context.pal.white,
          unselectedLabelColor: Colors.white54,
          indicatorColor: context.pal.accent,
          tabs: [
            Tab(text: l10n.adminModerationReportsTab),
            Tab(text: l10n.adminModerationFeedbackTab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReportsTab(),
          _buildFeedbackTab(),
        ],
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
                    Text(
                      r['detail'] as String,
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
                  Text(
                    '${r['message'] ?? ''}',
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
}
