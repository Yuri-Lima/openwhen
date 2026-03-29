import 'dart:io';

import 'package:archive/archive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/firestore_collections.dart';
import '../../../shared/utils/music_url.dart';
import '../../../shared/utils/storage_export_url.dart';
import '../../../shared/utils/voice_url.dart';

/// Builds a multi-page PDF from opened letter documents (own letters only).
Future<Uint8List> buildLettersPdf({
  required List<DocumentSnapshot<Map<String, dynamic>>> docs,
  required String localeName,
}) async {
  if (docs.isEmpty) {
    throw ArgumentError('docs must not be empty');
  }
  final doc = pw.Document();
  final dateFmt = DateFormat.yMMMd(localeName);

  for (final snap in docs) {
    final m = snap.data();
    if (m == null) {
      throw StateError('Letter snapshot has no data');
    }
    final title = (m['title'] ?? '').toString();
    final message = (m['message'] ?? '').toString();
    final sender = (m['senderName'] ?? '').toString();
    final receiver = (m['receiverName'] ?? '').toString();
    final openedAt = m['openedAt'] as Timestamp?;
    final music = (m['musicUrl'] as String?)?.trim();
    if (music != null && music.isNotEmpty && !isValidHttpsMusicUrl(music)) {
      throw StateError('Invalid musicUrl');
    }

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (ctx) => [
          pw.Text(title, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Text('From: $sender  ·  To: $receiver', style: const pw.TextStyle(fontSize: 10)),
          if (openedAt != null)
            pw.Text('Opened: ${dateFmt.format(openedAt.toDate())}', style: const pw.TextStyle(fontSize: 10)),
          pw.Divider(),
          pw.Text(message, style: const pw.TextStyle(fontSize: 12)),
          if (music != null && music.isNotEmpty) pw.Padding(
            padding: const pw.EdgeInsets.only(top: 12),
            child: pw.Text('Music link: $music', style: const pw.TextStyle(fontSize: 9)),
          ),
        ],
      ),
    );
  }

  return doc.save();
}

Future<Uint8List?> _fetchBytesIfAllowed(String? url, bool Function(String?) allow) async {
  if (url == null || !allow(url)) return null;
  final r = await http.get(Uri.parse(url));
  if (r.statusCode != 200) return null;
  return r.bodyBytes;
}

/// ZIP: PDF + optional voice/handwritten bytes (only allowlisted Storage URLs).
Future<File> buildLettersExportZipFile({
  required List<DocumentSnapshot<Map<String, dynamic>>> docs,
  required String localeName,
}) async {
  final pdfBytes = await buildLettersPdf(docs: docs, localeName: localeName);
  final archive = Archive();
  final safeName = 'openwhen_letters_${DateTime.now().millisecondsSinceEpoch}';
  archive.addFile(ArchiveFile('$safeName.pdf', pdfBytes.length, pdfBytes));

  var idx = 0;
  for (final snap in docs) {
    final m = snap.data();
    if (m == null) continue;
    final id = _safeFileSegment(snap.id);
    final voice = m['voiceUrl'] as String?;
    final hw = m['handwrittenImageUrl'] as String?;

    final vBytes = await _fetchBytesIfAllowed(voice, isValidVoiceLetterUrl);
    if (vBytes != null) {
      archive.addFile(ArchiveFile('${id}_voice_$idx.m4a', vBytes.length, vBytes));
    }
    final hBytes = await _fetchBytesIfAllowed(hw, isValidHandwrittenExportUrl);
    if (hBytes != null) {
      archive.addFile(ArchiveFile('${id}_handwritten_$idx.jpg', hBytes.length, hBytes));
    }
    idx++;
  }

  final zipBytes = ZipEncoder().encodeBytes(archive);

  final dir = await getTemporaryDirectory();
  final f = File(p.join(dir.path, '$safeName.zip'));
  await f.writeAsBytes(zipBytes, flush: true);
  return f;
}

String _safeFileSegment(String id) {
  final b = StringBuffer();
  for (final c in id.runes) {
    final ch = String.fromCharCode(c);
    if (RegExp(r'[a-zA-Z0-9_-]').hasMatch(ch)) {
      b.write(ch);
    }
  }
  final s = b.toString();
  return s.isEmpty ? 'letter' : s.substring(0, s.length > 32 ? 32 : s.length);
}

/// Writes PDF to temp and shares (mobile/desktop); web uses share_plus fallback.
Future<void> shareExportPdf({
  required List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  required String localeName,
  required String subject,
}) async {
  final bytes = await buildLettersPdf(docs: docs, localeName: localeName);
  final dir = await getTemporaryDirectory();
  final name = 'openwhen_letters_${DateTime.now().millisecondsSinceEpoch}.pdf';
  final f = File(p.join(dir.path, name));
  await f.writeAsBytes(bytes, flush: true);
  await Share.shareXFiles([XFile(f.path)], text: subject);
}

Future<void> shareExportZip({
  required List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  required String localeName,
  required String subject,
}) async {
  final zipFile = await buildLettersExportZipFile(docs: docs, localeName: localeName);
  await Share.shareXFiles([XFile(zipFile.path)], text: subject);
  await deleteQuietly(zipFile);
}

/// Raw ZIP bytes (tests / custom flows).
Future<Uint8List> buildLettersZipBytes({
  required List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  required String localeName,
}) async {
  final f = await buildLettersExportZipFile(docs: docs, localeName: localeName);
  final bytes = await f.readAsBytes();
  await deleteQuietly(f);
  return bytes;
}

Future<void> shareZipBytes(Uint8List bytes) async {
  final dir = await getTemporaryDirectory();
  final name = 'openwhen_export_${DateTime.now().millisecondsSinceEpoch}.zip';
  final f = File(p.join(dir.path, name));
  await f.writeAsBytes(bytes, flush: true);
  await Share.shareXFiles([XFile(f.path)]);
  await deleteQuietly(f);
}

/// Deletes [file] after share; ignores errors.
Future<void> deleteQuietly(File? file) async {
  if (file == null) return;
  try {
    if (await file.exists()) await file.delete();
  } catch (_) {
    if (kDebugMode) {
      debugPrint('letter_export: temp delete failed');
    }
  }
}
