import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/app_theme.dart';

/// In-app inbox for moderation outcomes (Firestore `users/{uid}/notifications`).
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
            itemBuilder: (context, i) {
              final doc = docs[i];
              final d = doc.data();
              final read = d['read'] == true;
              final title = d['title'] as String? ?? '';
              final body = d['body'] as String? ?? '';
              return Card(
                color: context.pal.card,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    title,
                    style: TextStyle(
                      fontWeight: read ? FontWeight.w500 : FontWeight.w700,
                      color: context.pal.ink,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      body,
                      style: TextStyle(fontSize: 14, color: context.pal.inkSoft),
                    ),
                  ),
                  trailing: read
                      ? null
                      : IconButton(
                          tooltip: MaterialLocalizations.of(context).okButtonLabel,
                          icon: const Icon(Icons.done),
                          onPressed: () => doc.reference.update({'read': true}),
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
