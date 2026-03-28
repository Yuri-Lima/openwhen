import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/utils/date_formatter.dart';
import '../../../../shared/utils/music_url.dart';
import '../../../../shared/widgets/music_link_tile.dart';
import '../../../../shared/widgets/location_share_tile.dart';
import '../../../../shared/utils/sender_location.dart';

class CapsuleDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docId;

  const CapsuleDetailScreen({super.key, required this.data, required this.docId});

  static const _themeEmojis = {
    'memories': '🧠',
    'goals': '🎯',
    'feelings': '💛',
    'relationships': '👥',
    'growth': '🌱',
  };

  static const _themeColors = {
    'memories': Color(0xFF6B6560),
    'goals': Color(0xFFC0392B),
    'feelings': Color(0xFFC9A84C),
    'relationships': Color(0xFF5B8DB8),
    'growth': Color(0xFF4A8C6F),
  };

  static String _themeLabel(AppLocalizations l10n, String id) {
    switch (id) {
      case 'memories':      return l10n.capsuleThemeMemories;
      case 'goals':         return l10n.capsuleThemeGoals;
      case 'feelings':      return l10n.capsuleThemeFeelings;
      case 'relationships': return l10n.capsuleThemeRelationships;
      case 'growth':        return l10n.capsuleThemeGrowth;
      default:              return l10n.capsuleThemeDefault;
    }
  }

  List<Map<String, String>> _qaPairs() {
    final raw = data['questions'];
    if (raw is! List) return [];
    final out = <Map<String, String>>[];
    for (final item in raw) {
      if (item is Map) {
        out.add({
          'question': item['question']?.toString() ?? '',
          'answer': item['answer']?.toString() ?? '',
        });
      }
    }
    return out;
  }

  Future<void> _deleteCapsule(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.capsuleDetailDeleteConfirm),
        content: Text(l10n.capsuleDetailDeleteBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.actionCancel)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.actionDelete, style: TextStyle(color: context.pal.accent)),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    await FirebaseFirestore.instance.collection(FirestoreCollections.capsules).doc(docId).delete();
    if (context.mounted) Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final themeId = data['theme'] as String? ?? 'memories';
    final emoji = _themeEmojis[themeId] ?? '⏳';
    final themeLabel = _themeLabel(l10n, themeId);
    final themeColor = _themeColors[themeId] ?? const Color(0xFF6B6560);
    final title = data['title'] as String? ?? '';
    final openedAt = data['openedAt'] != null ? (data['openedAt'] as Timestamp).toDate() : DateTime.now();
    final createdAt = data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : DateTime.now();
    final isPublic = data['isPublic'] == true;
    final qa = _qaPairs();
    final photos = (data['photos'] as List?)?.whereType<String>().toList() ?? [];
    final musicUrl = data['musicUrl'] as String?;
    final showMusicLink = isValidHttpsMusicUrl(musicUrl);
    final senderLoc = parseSenderLocationData(data['senderLocation']);

    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: context.pal.headerGradient,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.arrow_back, size: 18, color: Colors.white.withOpacity(0.6)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.dmSerifDisplay(
                              fontSize: 18,
                              color: context.pal.white,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '$emoji $themeLabel',
                                style: GoogleFonts.dmSans(fontSize: 11, color: Colors.white.withOpacity(0.45)),
                              ),
                              if (isPublic) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: context.pal.accent.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    l10n.capsuleDetailOnFeed,
                                    style: GoogleFonts.dmSans(fontSize: 10, color: context.pal.accent),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2E8D5),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 24, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: themeColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.capsuleDetailYourCapsule,
                          style: TextStyle(
                            fontSize: 9,
                            letterSpacing: 3,
                            color: themeColor.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          title,
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: 20,
                            color: const Color(0xFF160D04),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.capsuleDetailDates(formatShortDate(createdAt, locale), formatShortDate(openedAt, locale)),
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            color: const Color(0xFF7A5C3A),
                          ),
                        ),
                        const SizedBox(height: 20),
                        for (final pair in qa) ...[
                          Text(
                            pair['question'] ?? '',
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: const Color(0xFF6B6560),
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            pair['answer'] ?? '',
                            style: GoogleFonts.dmSerifDisplay(
                              fontSize: 15,
                              color: const Color(0xFF241608),
                              fontStyle: FontStyle.italic,
                              height: 1.65,
                            ),
                          ),
                          const SizedBox(height: 18),
                        ],
                      ],
                    ),
                  ),
                  if (photos.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: photos.length,
                        itemBuilder: (context, i) => GestureDetector(
                          onTap: () => _showPhotoFullscreen(context, photos, i),
                          child: Container(
                            width: 180,
                            margin: EdgeInsets.only(right: i < photos.length - 1 ? 12 : 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: NetworkImage(photos[i]),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (showMusicLink) ...[
                    const SizedBox(height: 16),
                    MusicLinkTileDark(url: musicUrl!.trim()),
                  ],
                  if (senderLoc != null) ...[
                    const SizedBox(height: 16),
                    LocationShareTileDark(lat: senderLoc.lat, lng: senderLoc.lng),
                  ],
                  const SizedBox(height: 20),
                  _actionTile(
                    icon: Icons.share_outlined,
                    title: l10n.actionShare,
                    subtitle: l10n.capsuleDetailShareSubtitle,
                    onTap: () {
                      final buffer = StringBuffer('$title\n\n');
                      for (final p in qa) {
                        buffer.writeln('${p['question']}\n${p['answer']}\n');
                      }
                      Share.share(buffer.toString(), subject: title);
                    },
                  ),
                  const SizedBox(height: 10),
                  _actionTile(
                    icon: Icons.delete_outline,
                    title: l10n.capsuleDetailDeleteTitle,
                    subtitle: l10n.capsuleDetailDeleteSubtitle,
                    destructive: true,
                    onTap: () => _deleteCapsule(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPhotoFullscreen(BuildContext context, List<String> photos, int initialIndex) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => _PhotoGalleryDialog(photos: photos, initialIndex: initialIndex),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool destructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1714),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: destructive ? Colors.red.withOpacity(0.12) : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: destructive ? Colors.red.withOpacity(0.35) : Colors.white.withOpacity(0.1),
                ),
              ),
              child: Icon(icon, size: 22, color: destructive ? Colors.red.shade300 : Colors.white.withOpacity(0.6)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: destructive ? Colors.red.shade200 : Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.dmSans(fontSize: 12, color: Colors.white.withOpacity(0.35)),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.25)),
          ],
        ),
      ),
    );
  }
}

class _PhotoGalleryDialog extends StatefulWidget {
  final List<String> photos;
  final int initialIndex;
  const _PhotoGalleryDialog({required this.photos, required this.initialIndex});

  @override
  State<_PhotoGalleryDialog> createState() => _PhotoGalleryDialogState();
}

class _PhotoGalleryDialogState extends State<_PhotoGalleryDialog> {
  late final PageController _pageCtrl;
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _pageCtrl = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageCtrl,
              itemCount: widget.photos.length,
              onPageChanged: (i) => setState(() => _current = i),
              itemBuilder: (_, i) => Center(
                child: InteractiveViewer(
                  child: Image.network(widget.photos[i], fit: BoxFit.contain),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                  child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                ),
              ),
            ),
            if (widget.photos.length > 1)
              Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 16,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.photos.length, (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == _current ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: i == _current ? Colors.white : Colors.white38,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  )),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
