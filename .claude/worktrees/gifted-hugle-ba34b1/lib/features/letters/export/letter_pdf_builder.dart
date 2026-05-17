import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'export_url_allowlist.dart';

Future<Uint8List> buildLetterPdfBytes({
  required Map<String, dynamic> data,
  required String docId,
  required String localeName,
}) async {
  final title = (data['title'] as String?) ?? '';
  final message = (data['message'] as String?) ?? '';
  final sender = (data['senderName'] as String?) ?? '';
  final receiver = (data['receiverName'] as String?) ?? '';
  final openedAt = data['openedAt'] != null
      ? (data['openedAt'] as Timestamp).toDate()
      : null;
  final createdAt = data['createdAt'] != null
      ? (data['createdAt'] as Timestamp).toDate()
      : null;
  final musicUrl = (data['musicUrl'] as String?)?.trim();
  final isHandwritten = data['isHandwritten'] == true;
  final handwrittenUrl = data['handwrittenImageUrl'] as String?;

  final dateFmt = DateFormat.yMMMd(localeName);

  pw.Widget? imageWidget;
  if (isHandwritten &&
      handwrittenUrl != null &&
      isAllowedLetterAssetDownloadUrl(handwrittenUrl)) {
    final bytes = await _fetchAllowedBytes(handwrittenUrl);
    if (bytes != null && bytes.isNotEmpty) {
      imageWidget = pw.Image(pw.MemoryImage(bytes), fit: pw.BoxFit.contain);
    }
  }

  final doc = pw.Document();
  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        pw.Text(
          title,
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.Text('From: $sender  ·  To: $receiver', style: const pw.TextStyle(fontSize: 10)),
        if (createdAt != null)
          pw.Text('Created: ${dateFmt.format(createdAt)}', style: const pw.TextStyle(fontSize: 9)),
        if (openedAt != null)
          pw.Text('Opened: ${dateFmt.format(openedAt)}', style: const pw.TextStyle(fontSize: 9)),
        pw.Divider(),
        if (imageWidget != null) ...[
          imageWidget,
          pw.SizedBox(height: 16),
        ],
        if (!isHandwritten || message.isNotEmpty)
          pw.Text(message, style: const pw.TextStyle(fontSize: 12)),
        if (musicUrl != null && musicUrl.isNotEmpty) ...[
          pw.SizedBox(height: 16),
          pw.Text('Music link: $musicUrl', style: const pw.TextStyle(fontSize: 9)),
        ],
        pw.SizedBox(height: 24),
        pw.Text('Letter id: $docId', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
      ],
    ),
  );
  return doc.save();
}

Future<Uint8List?> _fetchAllowedBytes(String url) async {
  if (!isAllowedLetterAssetDownloadUrl(url)) return null;
  final r = await http.get(Uri.parse(url));
  if (r.statusCode != 200) return null;
  return r.bodyBytes;
}
