import 'package:cloud_firestore/cloud_firestore.dart';

enum LetterStatus { locked, opened }

enum InviteEmailStatus {
  sent,
  delivered,
  bounced,
  dropped,
  deferred,
  sendFailed;

  static InviteEmailStatus? fromString(String? value) {
    if (value == null) return null;
    if (value == 'send_failed') return sendFailed;
    return InviteEmailStatus.values.where((e) => e.name == value).firstOrNull;
  }
}

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
  /// Optional https URL (Spotify, YouTube Music, etc.) — opened externally.
  final String? musicUrl;
  /// Optional Firebase Storage URL for a short voice recording.
  final String? voiceUrl;
  /// Optional point shared at send time (`lat`, `lng`, `capturedAt`).
  final Map<String, dynamic>? senderLocation;
  /// When true, receiver must be within 10 m of [senderLocation] to open.
  final bool openRequiresProximity;
  /// Email delivery status for external recipients (null for in-app recipients).
  final InviteEmailStatus? inviteEmailStatus;
  final DateTime? inviteEmailStatusUpdatedAt;
  /// Email address of external recipient (null for in-app recipients).
  final String? receiverEmail;

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
    this.musicUrl,
    this.voiceUrl,
    this.senderLocation,
    this.openRequiresProximity = false,
    this.inviteEmailStatus,
    this.inviteEmailStatusUpdatedAt,
    this.receiverEmail,
  });

  bool get isLocked => status == LetterStatus.locked;
  bool get canOpen => DateTime.now().isAfter(openDate);

  bool get hasEmailDeliveryFailure =>
      inviteEmailStatus == InviteEmailStatus.bounced ||
      inviteEmailStatus == InviteEmailStatus.dropped ||
      inviteEmailStatus == InviteEmailStatus.sendFailed;

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
      musicUrl: data['musicUrl'] as String?,
      voiceUrl: data['voiceUrl'] as String?,
      senderLocation: data['senderLocation'] is Map
          ? Map<String, dynamic>.from(data['senderLocation'] as Map)
          : null,
      openRequiresProximity: data['openRequiresProximity'] == true,
      inviteEmailStatus:
          InviteEmailStatus.fromString(data['inviteEmailStatus'] as String?),
      inviteEmailStatusUpdatedAt: data['inviteEmailStatusUpdatedAt'] != null
          ? (data['inviteEmailStatusUpdatedAt'] as Timestamp).toDate()
          : null,
      receiverEmail: data['receiverEmail'] as String?,
    );
  }
}
