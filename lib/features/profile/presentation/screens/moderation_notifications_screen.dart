import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../letters/presentation/screens/letter_detail_screen.dart';
import 'user_profile_screen.dart';

/// In-app inbox for moderation outcomes AND engagement notifications
/// (likes, comments, follows). Reads from `users/{uid}/notifications`.
class ModerationNotificationsScreen extends StatelessWidget {
  const ModerationNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return Scaffold(
        backgroundColor: context.pal.bg,
        appBar: AppBar(
          backgroundColor: context.pal.headerGradient.first,
          foregroundColor: context.pal.white,
          title: Text(
            l10n.moderationNotificationsTitle,
            style: GoogleFonts.dmSerifDisplay(fontSize: 20, fontStyle: FontStyle.italic),
          ),
        ),
        body: const Center(child: SizedBox.shrink()),
      );
    }

    return Scaffold(
      backgroundColor: context.pal.bg,
      appBar: AppBar(
        backgroundColor: context.pal.headerGradient.first,
        foregroundColor: context.pal.white,
        title: Text(
          l10n.moderationNotificationsTitle,
          style: GoogleFonts.dmSerifDisplay(fontSize: 20, fontStyle: FontStyle.italic),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection(FirestoreCollections.users)
            .doc(uid)
            .collection(FirestoreCollections.userNotifications)
            .orderBy('createdAt', descending: true)
            .limit(50)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  '${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.pal.inkSoft),
                ),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return Center(
              child: Text(
                l10n.moderationNotificationsEmpty,
                style: TextStyle(color: context.pal.inkSoft),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, i) => _NotificationTile(doc: docs[i]),
          );
        },
      ),
    );
  }
}

// ─── Individual notification tile ───────────────────────────────────

class _NotificationTile extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;

  const _NotificationTile({required this.doc});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final d = doc.data();
    final read = d['read'] == true;
    final type = d['type'] as String? ?? '';
    final kind = d['kind'] as String? ?? '';
    final actorName = d['actorName'] as String? ?? '';

    // For engagement notifications, use device-locale strings instead of
    // the server-stored copy (which may have been written in a different language).
    String title;
    String body;
    if (type == 'engagement' && actorName.isNotEmpty) {
      switch (kind) {
        case 'follow':
          title = l10n.notifFollowTitle(actorName);
          body = l10n.notifFollowBody;
          break;
        case 'like':
          title = l10n.notifLikeTitle(actorName);
          body = l10n.notifLikeBody;
          break;
        case 'comment':
          title = l10n.notifCommentTitle(actorName);
          body = l10n.notifCommentBody;
          break;
        default:
          title = d['title'] as String? ?? '';
          body = d['body'] as String? ?? '';
      }
    } else {
      title = d['title'] as String? ?? '';
      body = d['body'] as String? ?? '';
    }

    return Card(
      color: read ? context.pal.card : context.pal.card.withAlpha(240),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _leadingIcon(type, kind),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: read ? FontWeight.w500 : FontWeight.w700,
            color: _titleColor(context, type),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            body,
            style: TextStyle(fontSize: 14, color: context.pal.inkSoft),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: read
            ? null
            : IconButton(
                tooltip: MaterialLocalizations.of(context).okButtonLabel,
                icon: const Icon(Icons.done),
                onPressed: () => doc.reference.update({'read': true}),
              ),
        onTap: () => _onTap(context, d),
      ),
    );
  }

  // ── Icon per notification type ──────────────────────────────────

  Widget? _leadingIcon(String type, String kind) {
    if (type == 'email_bounce') {
      return const Icon(Icons.email_outlined, color: Colors.red);
    }
    if (type == 'engagement') {
      switch (kind) {
        case 'like':
          return const Icon(Icons.favorite, color: Colors.pinkAccent);
        case 'comment':
          return const Icon(Icons.chat_bubble, color: Colors.blueAccent);
        case 'follow':
          return const Icon(Icons.person_add, color: Colors.teal);
      }
    }
    if (type == 'moderation_review') {
      return const Icon(Icons.shield_outlined, color: Colors.orange);
    }
    return null;
  }

  Color _titleColor(BuildContext context, String type) {
    if (type == 'email_bounce') return Colors.red;
    return context.pal.ink;
  }

  // ── Tap navigation (deep linking) ─────────────────────────────

  void _onTap(BuildContext context, Map<String, dynamic> d) {
    // Mark as read
    if (d['read'] != true) {
      doc.reference.update({'read': true});
    }

    final type = d['type'] as String? ?? '';
    final kind = d['kind'] as String? ?? '';

    if (type == 'engagement') {
      switch (kind) {
        case 'like':
        case 'comment':
          _navigateToLetter(context, d);
          break;
        case 'follow':
          _navigateToProfile(context, d);
          break;
      }
    }
  }

  void _navigateToLetter(BuildContext context, Map<String, dynamic> d) {
    final letterId = d['letterId'] as String?;
    if (letterId == null || letterId.isEmpty) return;

    // Fetch the letter and navigate
    FirebaseFirestore.instance
        .collection(FirestoreCollections.letters)
        .doc(letterId)
        .get()
        .then((snap) {
      if (!snap.exists || !context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => LetterDetailScreen(
            data: snap.data()!,
            docId: snap.id,
          ),
        ),
      );
    });
  }

  void _navigateToProfile(BuildContext context, Map<String, dynamic> d) {
    final actorUid = d['actorUid'] as String?;
    final actorName = d['actorName'] as String? ?? '';
    if (actorUid == null || actorUid.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserProfileScreen(
          userId: actorUid,
          userName: actorName,
        ),
      ),
    );
  }
}
