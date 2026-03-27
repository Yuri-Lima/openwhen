import 'package:cloud_firestore/cloud_firestore.dart';

enum LetterStatus { locked, opened }

class Letter {
  final String id;
  final String senderUid;
  final String senderName;
  final String receiverUid;
  final String receiverName;
  final String title;
  final String message;
  final DateTime openDate;
  final LetterStatus status;
  final bool isPublic;
  final bool canBeShared;
  final DateTime createdAt;
  final DateTime? openedAt;
  final DateTime? publishedAt;
  final int likeCount;
  final int commentCount;

  Letter({
    required this.id,
    required this.senderUid,
    required this.senderName,
    required this.receiverUid,
    required this.receiverName,
    required this.title,
    required this.message,
    required this.openDate,
    required this.status,
    required this.isPublic,
    required this.canBeShared,
    required this.createdAt,
    this.openedAt,
    this.publishedAt,
    this.likeCount = 0,
    this.commentCount = 0,
  });

  bool get isLocked => status == LetterStatus.locked;
  bool get canOpen => DateTime.now().isAfter(openDate);

  factory Letter.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Letter(
      id: doc.id,
      senderUid: data['senderUid'] ?? '',
      senderName: data['senderName'] ?? '',
      receiverUid: data['receiverUid'] ?? '',
      receiverName: data['receiverName'] ?? '',
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      openDate: (data['openDate'] as Timestamp).toDate(),
      status: data['status'] == 'opened'
          ? LetterStatus.opened
          : LetterStatus.locked,
      isPublic: data['isPublic'] ?? false,
      canBeShared: data['canBeShared'] ?? false,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      openedAt: data['openedAt'] != null
          ? (data['openedAt'] as Timestamp).toDate()
          : null,
      publishedAt: data['publishedAt'] != null
          ? (data['publishedAt'] as Timestamp).toDate()
          : null,
      likeCount: (data['likeCount'] as num?)?.toInt() ?? 0,
      commentCount: (data['commentCount'] as num?)?.toInt() ?? 0,
    );
  }
}