import 'package:cloud_firestore/cloud_firestore.dart';

import 'letter_export_service.dart' deferred as export_impl;

/// Carrega o chunk com `pdf` / `archive` / ZIP apenas quando o utilizador exporta.
Future<void> shareLetterPdfDeferred({
  required String docId,
  required String localeName,
  required String subject,
}) async {
  await export_impl.loadLibrary();
  return export_impl.shareLetterPdf(
    docId: docId,
    localeName: localeName,
    subject: subject,
  );
}

/// Carrega o chunk de exportação ZIP/PDF apenas quando o utilizador exporta em massa.
Future<void> shareExportZipDeferred({
  required List<DocumentSnapshot<Map<String, dynamic>>> docs,
  required String localeName,
  required String subject,
}) async {
  await export_impl.loadLibrary();
  return export_impl.shareExportZip(
    docs: docs,
    localeName: localeName,
    subject: subject,
  );
}
