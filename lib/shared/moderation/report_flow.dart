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

/// Bottom sheet: choose reason, optional detail, submit.
Future<void> showReportContentSheet(
  BuildContext context, {
  required String targetType,
  required String targetId,
  required String letterId,
}) async {
  final l10n = AppLocalizations.of(context)!;
  ReportReason reason = ReportReason.other;
  final detailCtrl = TextEditingController();

  final submitted = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setModal) {
          final bottom = MediaQuery.of(ctx).viewInsets.bottom;
          return Padding(
            padding: EdgeInsets.only(bottom: bottom),
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              decoration: BoxDecoration(
                color: ctx.pal.bg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: ctx.pal.border),
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
                          color: ctx.pal.inkFaint,
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
                        color: ctx.pal.ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.reportSheetSubtitle,
                      style: TextStyle(fontSize: 13, color: ctx.pal.inkSoft, height: 1.4),
                    ),
                    const SizedBox(height: 16),
                    ...ReportReason.values.map((r) {
                      return RadioListTile<ReportReason>(
                        value: r,
                        groupValue: reason,
                        onChanged: (v) {
                          if (v != null) setModal(() => reason = v);
                        },
                        title: Text(
                          reportReasonLabel(l10n, r),
                          style: TextStyle(fontSize: 14, color: ctx.pal.ink),
                        ),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      );
                    }),
                    const SizedBox(height: 8),
                    TextField(
                      controller: detailCtrl,
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
                            targetType: targetType,
                            targetId: targetId,
                            letterId: letterId,
                            reason: reason,
                            detail: detailCtrl.text,
                          );
                          if (ctx.mounted) Navigator.pop(ctx, true);
                        } catch (e) {
                          if (ctx.mounted) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
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
        },
      );
    },
  );

  detailCtrl.dispose();
  if (submitted == true && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.reportSuccess)),
    );
  }
}
