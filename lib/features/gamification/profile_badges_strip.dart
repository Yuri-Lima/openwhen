import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/firestore_collections.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/theme/app_theme.dart';
import 'badge_id.dart';

/// Horizontal strip of earned badges (Firestore subcollection).
class ProfileBadgesStrip extends StatelessWidget {
  const ProfileBadgesStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final l10n = AppLocalizations.of(context)!;
    if (uid == null) return const SizedBox.shrink();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection(FirestoreCollections.users)
          .doc(uid)
          .collection('badgeUnlocks')
          .snapshots(),
      builder: (context, snap) {
        final docs = snap.data?.docs ?? [];
        if (docs.isEmpty) return const SizedBox.shrink();

        final ids = docs.map((d) => d.id).where(BadgeId.all.contains).toList()..sort();
        if (ids.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.profileBadgesTitle,
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  color: Colors.white.withValues(alpha: 0.35),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ids.map((id) => _BadgeChip(badgeId: id)).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.badgeId});

  final String badgeId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final label = _label(l10n);
    return Semantics(
      label: label,
      child: Tooltip(
        message: _description(l10n),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: context.pal.accent.withValues(alpha: 0.35)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_icon(), size: 14, color: context.pal.accent),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _icon() {
    switch (badgeId) {
      case BadgeId.firstLetterSent:
        return Icons.mail_outline_rounded;
      case BadgeId.firstLetterOpened:
        return Icons.mark_email_read_outlined;
      case BadgeId.firstPublic:
        return Icons.public_rounded;
      case BadgeId.lettersSentFive:
        return Icons.auto_awesome_outlined;
      case BadgeId.lettersSentTen:
        return Icons.stars_outlined;
      case BadgeId.voiceLetter:
        return Icons.mic_none_rounded;
      default:
        return Icons.emoji_events_outlined;
    }
  }

  String _label(AppLocalizations l10n) {
    switch (badgeId) {
      case BadgeId.firstLetterSent:
        return l10n.badgeFirstLetterSentTitle;
      case BadgeId.firstLetterOpened:
        return l10n.badgeFirstLetterOpenedTitle;
      case BadgeId.firstPublic:
        return l10n.badgeFirstPublicTitle;
      case BadgeId.lettersSentFive:
        return l10n.badgeLettersSentFiveTitle;
      case BadgeId.lettersSentTen:
        return l10n.badgeLettersSentTenTitle;
      case BadgeId.voiceLetter:
        return l10n.badgeVoiceLetterTitle;
      default:
        return badgeId;
    }
  }

  String _description(AppLocalizations l10n) {
    switch (badgeId) {
      case BadgeId.firstLetterSent:
        return l10n.badgeFirstLetterSentDesc;
      case BadgeId.firstLetterOpened:
        return l10n.badgeFirstLetterOpenedDesc;
      case BadgeId.firstPublic:
        return l10n.badgeFirstPublicDesc;
      case BadgeId.lettersSentFive:
        return l10n.badgeLettersSentFiveDesc;
      case BadgeId.lettersSentTen:
        return l10n.badgeLettersSentTenDesc;
      case BadgeId.voiceLetter:
        return l10n.badgeVoiceLetterDesc;
      default:
        return '';
    }
  }
}
