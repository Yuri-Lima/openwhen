import 'package:cloud_firestore/cloud_firestore.dart';

/// Sort public letter docs by engagement (likes), then recency.
int compareLettersByHighlights(
  QueryDocumentSnapshot<Map<String, dynamic>> a,
  QueryDocumentSnapshot<Map<String, dynamic>> b,
) {
  final la = (a.data()['likeCount'] as num?)?.toInt() ?? 0;
  final lb = (b.data()['likeCount'] as num?)?.toInt() ?? 0;
  if (la != lb) return lb.compareTo(la);
  final ta = a.data()['openedAt'] as Timestamp?;
  final tb = b.data()['openedAt'] as Timestamp?;
  if (ta != null && tb != null) {
    final c = tb.compareTo(ta);
    if (c != 0) return c;
  }
  return a.id.compareTo(b.id);
}

/// Chronological: newest opened first.
int compareLettersByOpenedAtDesc(
  QueryDocumentSnapshot<Map<String, dynamic>> a,
  QueryDocumentSnapshot<Map<String, dynamic>> b,
) {
  final ta = a.data()['openedAt'] as Timestamp?;
  final tb = b.data()['openedAt'] as Timestamp?;
  if (ta != null && tb != null) {
    final c = tb.compareTo(ta);
    if (c != 0) return c;
  }
  return a.id.compareTo(b.id);
}
