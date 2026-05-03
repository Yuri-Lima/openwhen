import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de rascunho de carta persistido no Firestore.
///
/// Cada draft expira automaticamente 30 dias após a criação, indicado pelo
/// campo [expiresAt] (usado também pelo Firestore TTL Policy).
class LetterDraft {
  final String? id;
  final String senderUid;
  final String title;
  final String message;
  final String email;
  final String musicUrl;
  final bool isHandwritten;
  final String? handwrittenImageUrl;
  final String? voiceUrl;
  final bool isPrivate;
  final bool messageExpanded;
  final int openDateMs;
  final String? emotionKey;
  final DateTime createdAt;
  final DateTime expiresAt;

  static const int expirationDays = 30;

  const LetterDraft({
    this.id,
    required this.senderUid,
    this.title = '',
    this.message = '',
    this.email = '',
    this.musicUrl = '',
    this.isHandwritten = false,
    this.handwrittenImageUrl,
    this.voiceUrl,
    this.isPrivate = true,
    this.messageExpanded = false,
    required this.openDateMs,
    this.emotionKey,
    required this.createdAt,
    required this.expiresAt,
  });

  /// Cria um draft novo com expiração automática de 30 dias.
  factory LetterDraft.create({
    required String senderUid,
    String title = '',
    String message = '',
    String email = '',
    String musicUrl = '',
    bool isHandwritten = false,
    String? handwrittenImageUrl,
    String? voiceUrl,
    bool isPrivate = true,
    bool messageExpanded = false,
    required int openDateMs,
    String? emotionKey,
  }) {
    final now = DateTime.now();
    return LetterDraft(
      senderUid: senderUid,
      title: title,
      message: message,
      email: email,
      musicUrl: musicUrl,
      isHandwritten: isHandwritten,
      handwrittenImageUrl: handwrittenImageUrl,
      voiceUrl: voiceUrl,
      isPrivate: isPrivate,
      messageExpanded: messageExpanded,
      openDateMs: openDateMs,
      emotionKey: emotionKey,
      createdAt: now,
      expiresAt: now.add(const Duration(days: expirationDays)),
    );
  }

  /// Reconstrói a partir de um documento Firestore.
  factory LetterDraft.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return LetterDraft(
      id: doc.id,
      senderUid: d['senderUid'] as String? ?? '',
      title: d['title'] as String? ?? '',
      message: d['message'] as String? ?? '',
      email: d['email'] as String? ?? '',
      musicUrl: d['musicUrl'] as String? ?? '',
      isHandwritten: d['isHandwritten'] as bool? ?? false,
      handwrittenImageUrl: d['handwrittenImageUrl'] as String?,
      voiceUrl: d['voiceUrl'] as String?,
      isPrivate: d['isPrivate'] as bool? ?? true,
      messageExpanded: d['messageExpanded'] as bool? ?? false,
      openDateMs: d['openDateMs'] as int? ?? DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch,
      emotionKey: d['emotionKey'] as String?,
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expiresAt: (d['expiresAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Serializa para escrita no Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'senderUid': senderUid,
      'title': title,
      'message': message,
      'email': email,
      'musicUrl': musicUrl,
      'isHandwritten': isHandwritten,
      'handwrittenImageUrl': handwrittenImageUrl,
      'voiceUrl': voiceUrl,
      'isPrivate': isPrivate,
      'messageExpanded': messageExpanded,
      'openDateMs': openDateMs,
      'emotionKey': emotionKey,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
    };
  }

  /// Dias restantes antes da expiração. Retorna 0 se já expirou.
  int get daysRemaining {
    final diff = expiresAt.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }

  /// Verdadeiro se o draft já expirou.
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Verdadeiro se tem conteúdo significativo (pelo menos título ou mensagem).
  bool get hasContent =>
      title.trim().isNotEmpty ||
      message.trim().isNotEmpty ||
      handwrittenImageUrl != null ||
      voiceUrl != null;

  /// Cria uma cópia com campos atualizados (preserva createdAt e expiresAt).
  LetterDraft copyWith({
    String? id,
    String? title,
    String? message,
    String? email,
    String? musicUrl,
    bool? isHandwritten,
    String? handwrittenImageUrl,
    String? voiceUrl,
    bool? isPrivate,
    bool? messageExpanded,
    int? openDateMs,
    String? emotionKey,
  }) {
    return LetterDraft(
      id: id ?? this.id,
      senderUid: senderUid,
      title: title ?? this.title,
      message: message ?? this.message,
      email: email ?? this.email,
      musicUrl: musicUrl ?? this.musicUrl,
      isHandwritten: isHandwritten ?? this.isHandwritten,
      handwrittenImageUrl: handwrittenImageUrl ?? this.handwrittenImageUrl,
      voiceUrl: voiceUrl ?? this.voiceUrl,
      isPrivate: isPrivate ?? this.isPrivate,
      messageExpanded: messageExpanded ?? this.messageExpanded,
      openDateMs: openDateMs ?? this.openDateMs,
      emotionKey: emotionKey ?? this.emotionKey,
      createdAt: createdAt,
      expiresAt: expiresAt,
    );
  }
}
