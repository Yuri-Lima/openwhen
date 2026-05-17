import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/firestore_collections.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/theme/app_theme.dart';
import 'badge_id.dart';

// ──────────────────────────────────────────────────────────────────
// Color categories for each badge
// ──────────────────────────────────────────────────────────────────

class _BadgeColors {
  final Color fill;
  final Color stroke;
  final Color icon;

  const _BadgeColors({
    required this.fill,
    required this.stroke,
    required this.icon,
  });

  /// Gold – milestones (first letter, first opening)
  static const gold = _BadgeColors(
    fill: Color(0x33F59E0B),
    stroke: Color(0xAAF59E0B),
    icon: Color(0xFFF59E0B),
  );

  /// Purple – social actions (public feed)
  static const purple = _BadgeColors(
    fill: Color(0x338B5CF6),
    stroke: Color(0xAA8B5CF6),
    icon: Color(0xFF8B5CF6),
  );

  /// Green – volume badges (5, 10 letters)
  static const green = _BadgeColors(
    fill: Color(0x3310B981),
    stroke: Color(0xAA10B981),
    icon: Color(0xFF10B981),
  );

  /// Coral – special features (voice)
  static const coral = _BadgeColors(
    fill: Color(0x33E24B4A),
    stroke: Color(0xAAE24B4A),
    icon: Color(0xFFE24B4A),
  );

  /// Blue – engagement / community
  static const blue = _BadgeColors(
    fill: Color(0x333B82F6),
    stroke: Color(0xAA3B82F6),
    icon: Color(0xFF3B82F6),
  );

  /// Amber – dedication / streaks
  static const amber = _BadgeColors(
    fill: Color(0x33EF9F27),
    stroke: Color(0xAAEF9F27),
    icon: Color(0xFFEF9F27),
  );

  /// Locked – adapts to current theme brightness
  static _BadgeColors lockedFrom(WhenotePalette pal) {
    return _BadgeColors(
      fill: pal.inkFaint.withValues(alpha: 0.08),
      stroke: pal.inkFaint.withValues(alpha: 0.25),
      icon: pal.inkFaint.withValues(alpha: 0.25),
    );
  }
}

_BadgeColors _colorsForBadge(String badgeId) {
  switch (badgeId) {
    case BadgeId.firstLetterSent:
    case BadgeId.firstLetterOpened:
    case BadgeId.firstLetterReceived:
      return _BadgeColors.gold;
    case BadgeId.firstPublic:
    case BadgeId.letterLikedByTen:
      return _BadgeColors.purple;
    case BadgeId.lettersSentFive:
    case BadgeId.lettersSentTen:
      return _BadgeColors.green;
    case BadgeId.voiceLetter:
      return _BadgeColors.coral;
    case BadgeId.profileComplete:
      return _BadgeColors.blue;
    case BadgeId.threeDayStreak:
      return _BadgeColors.amber;
    default:
      return _BadgeColors.gold;
  }
}

// ──────────────────────────────────────────────────────────────────
// Main widget – shows ALL badges (unlocked + locked)
// ──────────────────────────────────────────────────────────────────

class ProfileBadgesStrip extends StatefulWidget {
  const ProfileBadgesStrip({super.key});

  @override
  State<ProfileBadgesStrip> createState() => _ProfileBadgesStripState();
}

class _ProfileBadgesStripState extends State<ProfileBadgesStrip>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  late final AnimationController _animCtrl = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  late final Animation<double> _expandAnim = CurvedAnimation(
    parent: _animCtrl,
    curve: Curves.easeInOut,
  );

  late final Animation<double> _rotateAnim = Tween<double>(
    begin: 0,
    end: 0.5, // 180°
  ).animate(_expandAnim);

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _animCtrl.forward();
    } else {
      _animCtrl.reverse();
    }
  }

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
        final unlockedIds = docs
            .map((d) => d.id)
            .where(BadgeId.all.contains)
            .toSet();

        // Build a map of badgeId -> unlockedAt timestamp
        final unlockDates = <String, DateTime?>{};
        for (final doc in docs) {
          final ts = doc.data()['unlockedAt'] as Timestamp?;
          unlockDates[doc.id] = ts?.toDate();
        }

        final pal = context.pal;
        final unlockedCount = unlockedIds.length;
        final totalCount = BadgeId.all.length;

        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Collapsible header ──
              GestureDetector(
                onTap: _toggle,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    Text(
                      l10n.profileBadgesTitle,
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        color: pal.inkFaint,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Unlocked count pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: pal.inkFaint.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$unlockedCount/$totalCount',
                        style: GoogleFonts.dmSans(
                          fontSize: 9,
                          color: pal.inkSoft,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    RotationTransition(
                      turns: _rotateAnim,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: pal.inkFaint,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Animated badge grid ──
              SizeTransition(
                sizeFactor: _expandAnim,
                axisAlignment: -1.0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: BadgeId.all.map((id) {
                      final unlocked = unlockedIds.contains(id);
                      return _BadgeShield(
                        badgeId: id,
                        unlocked: unlocked,
                        unlockedAt: unlockDates[id],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ──────────────────────────────────────────────────────────────────
// Individual shield badge
// ──────────────────────────────────────────────────────────────────

class _BadgeShield extends StatelessWidget {
  const _BadgeShield({
    required this.badgeId,
    required this.unlocked,
    this.unlockedAt,
  });

  final String badgeId;
  final bool unlocked;
  final DateTime? unlockedAt;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pal = context.pal;
    final colors =
        unlocked ? _colorsForBadge(badgeId) : _BadgeColors.lockedFrom(pal);
    final label = unlocked ? _label(l10n) : '???';

    return GestureDetector(
      onTap: () => _showBadgeDetails(context),
      child: Semantics(
        label: unlocked ? _label(l10n) : l10n.profileBadgesTitle,
        child: SizedBox(
          width: 48,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Shield
              SizedBox(
                width: 44,
                height: 52,
                child: CustomPaint(
                  painter: _ShieldPainter(
                    fillColor: colors.fill,
                    strokeColor: colors.stroke,
                    isLocked: !unlocked,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Icon(
                        _icon(),
                        size: 20,
                        color: colors.icon,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              // Label
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.dmSans(
                  fontSize: 9,
                  color: unlocked
                      ? pal.inkSoft.withValues(alpha: 0.7)
                      : pal.inkFaint.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBadgeDetails(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pal = context.pal;
    final colors =
        unlocked ? _colorsForBadge(badgeId) : _BadgeColors.lockedFrom(pal);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          decoration: BoxDecoration(
            color: pal.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: unlocked
                  ? colors.stroke.withValues(alpha: 0.4)
                  : pal.border,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Large shield
              SizedBox(
                width: 64,
                height: 76,
                child: CustomPaint(
                  painter: _ShieldPainter(
                    fillColor: colors.fill,
                    strokeColor: colors.stroke,
                    isLocked: !unlocked,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Icon(
                        _icon(),
                        size: 28,
                        color: colors.icon,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Title
              Text(
                unlocked ? _label(l10n) : '???',
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 18,
                  color: unlocked ? pal.ink : pal.inkFaint,
                ),
              ),
              const SizedBox(height: 8),
              // Description
              Text(
                unlocked
                    ? _description(l10n)
                    : _hint(l10n),
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: pal.inkSoft,
                  height: 1.5,
                ),
              ),
              // Unlock date
              if (unlocked && unlockedAt != null) ...[
                const SizedBox(height: 12),
                Text(
                  DateFormat.yMMMd(
                    Localizations.localeOf(context).toString(),
                  ).format(unlockedAt!),
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: colors.icon.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              const SizedBox(height: 8),
            ],
          ),
        );
      },
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
      case BadgeId.firstLetterReceived:
        return Icons.markunread_mailbox_outlined;
      case BadgeId.profileComplete:
        return Icons.person_outline_rounded;
      case BadgeId.threeDayStreak:
        return Icons.local_fire_department_outlined;
      case BadgeId.letterLikedByTen:
        return Icons.favorite_border_rounded;
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
      case BadgeId.firstLetterReceived:
        return l10n.badgeFirstLetterReceivedTitle;
      case BadgeId.profileComplete:
        return l10n.badgeProfileCompleteTitle;
      case BadgeId.threeDayStreak:
        return l10n.badgeThreeDayStreakTitle;
      case BadgeId.letterLikedByTen:
        return l10n.badgeLetterLikedByTenTitle;
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
      case BadgeId.firstLetterReceived:
        return l10n.badgeFirstLetterReceivedDesc;
      case BadgeId.profileComplete:
        return l10n.badgeProfileCompleteDesc;
      case BadgeId.threeDayStreak:
        return l10n.badgeThreeDayStreakDesc;
      case BadgeId.letterLikedByTen:
        return l10n.badgeLetterLikedByTenDesc;
      default:
        return '';
    }
  }

  String _hint(AppLocalizations l10n) {
    switch (badgeId) {
      case BadgeId.firstLetterSent:
        return l10n.badgeHintFirstLetterSent;
      case BadgeId.firstLetterOpened:
        return l10n.badgeHintFirstLetterOpened;
      case BadgeId.firstPublic:
        return l10n.badgeHintFirstPublic;
      case BadgeId.lettersSentFive:
        return l10n.badgeHintLettersSentFive;
      case BadgeId.lettersSentTen:
        return l10n.badgeHintLettersSentTen;
      case BadgeId.voiceLetter:
        return l10n.badgeHintVoiceLetter;
      case BadgeId.firstLetterReceived:
        return l10n.badgeHintFirstLetterReceived;
      case BadgeId.profileComplete:
        return l10n.badgeHintProfileComplete;
      case BadgeId.threeDayStreak:
        return l10n.badgeHintThreeDayStreak;
      case BadgeId.letterLikedByTen:
        return l10n.badgeHintLetterLikedByTen;
      default:
        return '';
    }
  }
}

// ──────────────────────────────────────────────────────────────────
// CustomPainter – draws the shield / crest shape
// ──────────────────────────────────────────────────────────────────

class _ShieldPainter extends CustomPainter {
  final Color fillColor;
  final Color strokeColor;
  final bool isLocked;

  _ShieldPainter({
    required this.fillColor,
    required this.strokeColor,
    required this.isLocked,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Shield path: wide at top, pointed at bottom
    final path = Path()
      ..moveTo(w * 0.5, h * 0.04) // top center
      ..cubicTo(
        w * 0.25, h * 0.04, // control 1
        w * 0.02, h * 0.06, // control 2
        w * 0.02, h * 0.22, // left shoulder
      )
      ..lineTo(w * 0.02, h * 0.52)
      ..cubicTo(
        w * 0.02, h * 0.72,
        w * 0.25, h * 0.88,
        w * 0.5, h * 0.98, // bottom point
      )
      ..cubicTo(
        w * 0.75, h * 0.88,
        w * 0.98, h * 0.72,
        w * 0.98, h * 0.52,
      )
      ..lineTo(w * 0.98, h * 0.22)
      ..cubicTo(
        w * 0.98, h * 0.06,
        w * 0.75, h * 0.04,
        w * 0.5, h * 0.04,
      )
      ..close();

    // Fill
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // Stroke
    final strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    if (isLocked) {
      // Dashed stroke for locked
      final metric = path.computeMetrics().first;
      final totalLength = metric.length;
      const dashLen = 4.0;
      const gapLen = 3.0;
      double distance = 0;
      while (distance < totalLength) {
        final end = math.min(distance + dashLen, totalLength);
        final extractedPath = metric.extractPath(distance, end);
        canvas.drawPath(extractedPath, strokePaint);
        distance = end + gapLen;
      }
    } else {
      canvas.drawPath(path, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ShieldPainter old) =>
      old.fillColor != fillColor ||
      old.strokeColor != strokeColor ||
      old.isLocked != isLocked;
}
