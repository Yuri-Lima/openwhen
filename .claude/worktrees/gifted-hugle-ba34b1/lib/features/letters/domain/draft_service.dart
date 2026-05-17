import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/firestore_collections.dart';
import 'draft_model.dart';

/// Serviço centralizado para gerenciar rascunhos de cartas no Firestore.
///
/// Responsabilidades:
/// - CRUD de drafts na coleção `drafts`
/// - Limpeza de drafts expirados (client-side fallback para TTL Policy)
/// - Migração one-time do SharedPreferences legado para Firestore
/// - Controle de limite de drafts por utilizador
class DraftService {
  static const int maxDraftsPerUser = 10;
  static const String _legacyPrefsKey = 'write_letter_draft_v1';
  static const String _migrationDoneKey = 'draft_migration_done_v1';

  final FirebaseFirestore _firestore;

  DraftService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirestoreCollections.drafts);

  // ---------------------------------------------------------------------------
  // CRUD
  // ---------------------------------------------------------------------------

  /// Salva (cria ou atualiza) um draft. Retorna o ID do documento.
  Future<String> saveDraft(LetterDraft draft) async {
    final data = draft.toFirestore();

    if (draft.id != null) {
      // Update existente — não altera createdAt/expiresAt
      final updateData = Map<String, dynamic>.from(data);
      updateData.remove('createdAt');
      updateData.remove('expiresAt');
      await _collection.doc(draft.id).update(updateData);
      return draft.id!;
    } else {
      // Novo draft
      final docRef = await _collection.add(data);
      // Incrementa counter no user doc
      await _incrementDraftCount(draft.senderUid, 1);
      return docRef.id;
    }
  }

  /// Carrega um draft específico por ID.
  Future<LetterDraft?> getDraft(String draftId) async {
    final doc = await _collection.doc(draftId).get();
    if (!doc.exists || doc.data() == null) return null;
    final draft = LetterDraft.fromFirestore(doc);
    if (draft.isExpired) {
      // Limpa draft expirado ao aceder
      await deleteDraft(draftId, draft.senderUid);
      return null;
    }
    return draft;
  }

  /// Lista todos os drafts do utilizador, ordenados por expiração crescente.
  Future<List<LetterDraft>> listDrafts(String uid) async {
    final snap = await _collection
        .where('senderUid', isEqualTo: uid)
        .orderBy('expiresAt', descending: false)
        .get();

    final drafts = <LetterDraft>[];
    for (final doc in snap.docs) {
      final draft = LetterDraft.fromFirestore(doc);
      if (draft.isExpired) {
        // Limpa expirados silenciosamente
        unawaited(_deleteDraftDoc(doc.id, uid));
      } else {
        drafts.add(draft);
      }
    }
    return drafts;
  }

  /// Stream reativo de drafts do utilizador.
  Stream<List<LetterDraft>> watchDrafts(String uid) {
    return _collection
        .where('senderUid', isEqualTo: uid)
        .orderBy('expiresAt', descending: false)
        .snapshots()
        .map((snap) {
      final drafts = <LetterDraft>[];
      for (final doc in snap.docs) {
        final draft = LetterDraft.fromFirestore(doc);
        if (!draft.isExpired) {
          drafts.add(draft);
        }
      }
      return drafts;
    });
  }

  /// Conta quantos drafts o utilizador tem (para enforçar limite).
  Future<int> countDrafts(String uid) async {
    final snap = await _collection
        .where('senderUid', isEqualTo: uid)
        .count()
        .get();
    return snap.count ?? 0;
  }

  /// Verifica se o utilizador pode criar mais drafts.
  Future<bool> canCreateDraft(String uid) async {
    final count = await countDrafts(uid);
    return count < maxDraftsPerUser;
  }

  /// Deleta um draft e decrementa o counter.
  Future<void> deleteDraft(String draftId, String senderUid) async {
    await _deleteDraftDoc(draftId, senderUid);
  }

  Future<void> _deleteDraftDoc(String draftId, String senderUid) async {
    try {
      await _collection.doc(draftId).delete();
      await _incrementDraftCount(senderUid, -1);
    } catch (e) {
      if (kDebugMode) debugPrint('[DraftService] delete error: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Limpeza de expirados (fallback client-side para TTL Policy)
  // ---------------------------------------------------------------------------

  /// Remove todos os drafts expirados do utilizador. Chamar no app start.
  Future<void> deleteExpiredDrafts(String uid) async {
    try {
      final snap = await _collection
          .where('senderUid', isEqualTo: uid)
          .where('expiresAt', isLessThan: Timestamp.now())
          .get();

      if (snap.docs.isEmpty) return;

      final batch = _firestore.batch();
      for (final doc in snap.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      // Corrige counter
      await _incrementDraftCount(uid, -snap.docs.length);
    } catch (e) {
      if (kDebugMode) debugPrint('[DraftService] cleanup error: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Migração SharedPreferences → Firestore (one-time)
  // ---------------------------------------------------------------------------

  /// Migra o draft legado do SharedPreferences para Firestore.
  /// Só executa uma vez (marcada por flag local).
  Future<void> migrateFromSharedPreferences(String uid) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Verifica se já migrou
      if (prefs.getBool(_migrationDoneKey) == true) return;

      final raw = prefs.getString(_legacyPrefsKey);
      if (raw != null && raw.isNotEmpty) {
        final data = jsonDecode(raw) as Map<String, dynamic>?;
        if (data != null) {
          final title = data['title'] as String? ?? '';
          final message = data['message'] as String? ?? '';

          // Só migra se tiver conteúdo real
          if (title.trim().isNotEmpty || message.trim().isNotEmpty) {
            final draft = LetterDraft.create(
              senderUid: uid,
              title: title,
              message: message,
              email: data['email'] as String? ?? '',
              musicUrl: data['musicUrl'] as String? ?? '',
              isHandwritten: data['isHandwritten'] as bool? ?? false,
              isPrivate: data['isPrivate'] as bool? ?? true,
              messageExpanded: data['messageExpanded'] as bool? ?? false,
              openDateMs: data['openDateMs'] as int? ??
                  DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch,
              emotionKey: data['emotion'] as String?,
            );
            await saveDraft(draft);
          }

          // Limpa SharedPreferences legado
          await prefs.remove(_legacyPrefsKey);
        }
      }

      // Marca migração como concluída
      await prefs.setBool(_migrationDoneKey, true);
    } catch (e) {
      if (kDebugMode) debugPrint('[DraftService] migration error: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Counter auxiliar no user doc (soft-limit)
  // ---------------------------------------------------------------------------

  Future<void> _incrementDraftCount(String uid, int delta) async {
    try {
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(uid)
          .update({'draftCount': FieldValue.increment(delta)});
    } catch (e) {
      // Se o campo não existir, cria
      if (delta > 0) {
        try {
          await _firestore
              .collection(FirestoreCollections.users)
              .doc(uid)
              .set({'draftCount': delta}, SetOptions(merge: true));
        } catch (_) {}
      }
    }
  }
}
