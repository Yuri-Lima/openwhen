import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/constants/firestore_collections.dart';
import '../../l10n/app_localizations.dart';
import '../theme/open_when_palette.dart';

/// Reasons must match [firestore.rules] for `reports`.
enum ReportReason {
  spam,
  harassment,
  hate,
  illegal,
  other,
}

String reportReasonId(ReportReason r) {
  switch (r) {
    case ReportReason.spam:
      return 'spam';
    case ReportReason.harassment:
      return 'harassment';
    case ReportReason.hate:
      return 'hate';
    case ReportReason.illegal:
      return 'illegal';
    case ReportReason.other:
      return 'other';
  }
}

String reportReasonLabel(AppLocalizations l10n, ReportReason r) {
  switch (r) {
    case ReportReason.spam:
      return l10n.reportReasonSpam;
    case ReportReason.harassment:
      return l10n.reportReasonHarassment;
    case ReportReason.hate:
      return l10n.reportReasonHate;
    case ReportReason.illegal:
      return l10n.reportReasonIllegal;
    case ReportReason.other:
      return l10n.reportReasonOther;
  }
}

/// Submits a report document matching server rules. [targetId] is the letter id
/// or the comment document id; [letterId] is always the parent letter id.
Future<void> submitReport({
  required String targetType,
  required String targetId,
  required String letterId,
  required ReportReason reason,
  String detail = '',
}) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) throw StateError('Not signed in');

  final trimmed = detail.trim();
  final safeDetail = trimmed.length > 2000 ? trimmed.substring(0, 2000) : trimmed;

  await FirebaseFirestore.instance.collection(FirestoreCollections.reports).add({
    'reporterUid': uid,
    'targetType': targetType,
    'targetId': targetId,
    'letterId': letterId,
    'reason': reportReasonId(reason),
    'detail': safeDetail,
    'status': 'pending',
    'createdAt': FieldValue.serverTimestamp(),
  });
}

/// Sheet content: owns [TextEditingController] so it is disposed only after the
/// modal route removes this subtree (avoids use-after-dispose during dismiss animation).
class _ReportContentSheetBody extends StatefulWidget {
  const _ReportContentSheetBody({
    required this.targetType,
    required this.targetId,
    required this.letterId,
    required this.l10n,
  });

  final String targetType;
  final String targetId;
  final String letterId;
  final AppLocalizations l10n;

  @override
  State<_ReportContentSheetBody> createState() => _ReportContentSheetBodyState();
}

class _ReportContentSheetBodyState extends State<_ReportContentSheetBody> {
  ReportReason _reason = ReportReason.other;
  late final TextEditingController _detailCtrl;

  @override
  void initState() {
    super.initState();
    _detailCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _detailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: BoxDecoration(
          color: context.pal.bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.pal.border),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.pal.inkFaint,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.reportSheetTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: context.pal.ink,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.reportSheetSubtitle,
                style: TextStyle(fontSize: 13, color: context.pal.inkSoft, height: 1.4),
              ),
              const SizedBox(height: 16),
              ...ReportReason.values.map((r) {
                return RadioListTile<ReportReason>(
                  value: r,
                  groupValue: _reason,
                  onChanged: (v) {
                    if (v != null) setState(() => _reason = v);
                  },
                  title: Text(
                    reportReasonLabel(l10n, r),
                    style: TextStyle(fontSize: 14, color: context.pal.ink),
                  ),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                );
              }),
              const SizedBox(height: 8),
              TextField(
                controller: _detailCtrl,
                maxLines: 3,
                maxLength: 2000,
                decoration: InputDecoration(
                  labelText: l10n.reportDetailLabel,
                  hintText: l10n.reportDetailHint,
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () async {
                  try {
                    await submitReport(
                      targetType: widget.targetType,
                      targetId: widget.targetId,
                      letterId: widget.letterId,
                      reason: _reason,
                      detail: _detailCtrl.text,
                    );
                    if (context.mounted) Navigator.pop(context, true);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.errorGeneric(e.toString()))),
                      );
                    }
                  }
                },
                child: Text(l10n.reportSubmit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet: choose reason, optional detail, submit.
Future<void> showReportContentSheet(
  BuildContext context, {
  required String targetType,
  required String targetId,
  required String letterId,
}) async {
  final l10n = AppLocalizations.of(context)!;

  final submitted = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return _ReportContentSheetBody(
        targetType: targetType,
        targetId: targetId,
        letterId: letterId,
        l10n: l10n,
      );
    },
  );

  if (submitted == true && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.reportSuccess)),
    );
  }
}
