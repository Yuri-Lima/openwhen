import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/letter_repository_actions.dart';
import '../../../../shared/utils/date_formatter.dart';
import '../../../../shared/utils/music_url.dart';
import '../../../../shared/utils/voice_url.dart';
import '../../../../shared/widgets/music_link_tile.dart';
import '../../../../shared/widgets/voice_letter_tile.dart';
import '../../../../shared/widgets/location_share_tile.dart';
import '../../../../shared/utils/sender_location.dart';
import '../../../../shared/social/instagram_stories_share_service.dart';
import '../../../../shared/social/story_share_content.dart';
import 'qr_code_screen.dart';

class LetterDetailScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final String docId;

  const LetterDetailScreen({super.key, required this.data, required this.docId});

  @override
  State<LetterDetailScreen> createState() => _LetterDetailScreenState();
}

class _LetterDetailScreenState extends State<LetterDetailScreen> {
  late bool _isPublic;
  bool _isUpdating = false;
  bool _sharingStory = false;

  String get _currentUid => FirebaseAuth.instance.currentUser?.uid ?? '';

  bool get _isReceiver => widget.data['receiverUid'] == _currentUid;
  bool get _isSender   => widget.data['senderUid'] == _currentUid;
  bool get _isOpened   => (widget.data['status'] ?? 'locked') == 'opened';

  @override
  void initState() {
    super.initState();
    _isPublic = widget.data['isPublic'] ?? false;
  }

  Future<void> _shareToInstagramStory(BuildContext triggerContext) async {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final deepLink = 'https://openwhen.app/letter/${widget.docId}';

    if (kIsWeb) {
      await Share.share(
        l10n.qrShareLinkOnly(widget.data['title'] ?? '', deepLink),
        subject: l10n.qrShareSubject,
      );
      return;
    }

    final openDate = widget.data['openDate'] != null
        ? (widget.data['openDate'] as Timestamp).toDate()
        : DateTime.now();
    final openedAt = widget.data['openedAt'] != null
        ? (widget.data['openedAt'] as Timestamp).toDate()
        : DateTime.now();

    final dateSubtitle = _isOpened
        ? l10n.letterDetailOpenedOn(formatShortDate(openedAt, locale))
        : l10n.requestsOpensOn(formatShortDate(openDate, locale));

    final content = StoryShareContent.letter(
      docId: widget.docId,
      title: widget.data['title'] ?? '',
      dateSubtitle: dateSubtitle,
    );

    final box = triggerContext.findRenderObject() as RenderBox?;
    final origin = box != null ? box.localToGlobal(Offset.zero) & box.size : null;

    setState(() => _sharingStory = true);
    try {
      final outcome = await InstagramStoriesShareService.share(
        context: context,
        content: content,
        shareText: l10n.qrShareText(widget.data['title'] ?? '', deepLink),
        shareSubject: l10n.qrShareSubject,
        sharePositionOrigin: origin,
      );
      if (!mounted) return;
      if (outcome == StoriesShareOutcome.fallback) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.storyShareFallbackSnack, style: GoogleFonts.dmSans(fontSize: 13)),
            backgroundColor: context.pal.ink,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _sharingStory = false);
    }
  }

  Future<void> _toggleVisibility() async {
    if (_isUpdating) return;
    setState(() => _isUpdating = true);
    try {
      final newValue = !_isPublic;
      await setLetterPublic(docId: widget.docId, isPublic: newValue);
      if (mounted) setState(() => _isPublic = newValue);
    } catch (_) {
      // silently ignore — UI stays on previous state
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final openedAt = widget.data['openedAt'] != null
        ? (widget.data['openedAt'] as Timestamp).toDate()
        : DateTime.now();
    final createdAt = widget.data['createdAt'] != null
        ? (widget.data['createdAt'] as Timestamp).toDate()
        : DateTime.now();
    final openDate = widget.data['openDate'] != null
        ? (widget.data['openDate'] as Timestamp).toDate()
        : DateTime.now();
    final musicUrl = widget.data['musicUrl'] as String?;
    final showMusicLink = isValidHttpsMusicUrl(musicUrl);
    final voiceUrl = widget.data['voiceUrl'] as String?;
    final showVoice = isValidVoiceLetterUrl(voiceUrl);
    final senderLoc = parseSenderLocationData(widget.data['senderLocation']);

    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────────
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
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.arrow_back, size: 18, color: Colors.white.withOpacity(0.6)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_isSender && !_isReceiver) ...[
                            Text(
                              l10n.letterDetailSentView,
                              style: GoogleFonts.dmSans(
                                fontSize: 9,
                                letterSpacing: 3,
                                color: Colors.white.withOpacity(0.35),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(height: 2),
                          ],
                          Text(
                            widget.data['title'] ?? '',
                            style: GoogleFonts.dmSerifDisplay(
                              fontSize: 18,
                              color: context.pal.white,
                              fontStyle: FontStyle.italic,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // QR só aparece para o receptor
                    if (_isReceiver || (!_isReceiver && !_isSender))
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (_) => QrCodeScreen(
                            docId: widget.docId,
                            title: widget.data['title'] ?? '',
                            senderName: widget.data['senderName'] ?? '',
                            openDate: openDate,
                          ),
                        )),
                        child: Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.qr_code, size: 18, color: Colors.white.withOpacity(0.6)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // ── Conteúdo ────────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Papel da carta
                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2E8D5),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 32, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 5,
                          decoration: BoxDecoration(
                            color: context.pal.accent,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                          ),
                        ),
                        Stack(
                          children: [
                            CustomPaint(
                              size: Size(MediaQuery.of(context).size.width - 32, 600),
                              painter: _PaperLinesPainter(),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(48, 32, 24, 32),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.letterDetailHeaderFrom,
                                    style: TextStyle(fontSize: 9, letterSpacing: 4, color: context.pal.accent.withOpacity(0.8))),
                                  const SizedBox(height: 8),
                                  Text(widget.data['senderName'] ?? '',
                                    style: GoogleFonts.dmSerifDisplay(fontSize: 22, color: const Color(0xFF160D04))),
                                  const SizedBox(height: 4),
                                  Text(l10n.letterDetailTo(widget.data['receiverName'] ?? ''),
                                    style: GoogleFonts.dmSans(fontSize: 12, fontStyle: FontStyle.italic, color: const Color(0xFF7A5C3A))),
                                  const SizedBox(height: 20),
                                  Container(width: 32, height: 1, color: context.pal.accent.withOpacity(0.4)),
                                  const SizedBox(height: 12),
                                  Text(widget.data['title'] ?? '',
                                    style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: const Color(0xFF160D04), fontStyle: FontStyle.italic)),
                                  const SizedBox(height: 20),
                                  Text(widget.data['message'] ?? '',
                                    style: GoogleFonts.dmSerifDisplay(fontSize: 16, fontStyle: FontStyle.italic, color: const Color(0xFF241608), height: 2.0)),
                                  const SizedBox(height: 32),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text('— ${widget.data['senderName'] ?? ''}',
                                          style: GoogleFonts.dmSerifDisplay(fontSize: 16, fontStyle: FontStyle.italic, color: const Color(0xFF4A2E14))),
                                        const SizedBox(height: 4),
                                        Text(l10n.letterDetailWrittenOn(formatShortDate(createdAt, locale)),
                                          style: TextStyle(fontSize: 9, letterSpacing: 2, color: context.pal.accent.withOpacity(0.5))),
                                        if (_isOpened)
                                          Text(l10n.letterDetailOpenedOn(formatShortDate(openedAt, locale)),
                                            style: TextStyle(fontSize: 9, letterSpacing: 2, color: context.pal.accent.withOpacity(0.5))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ── Tiles de ação ────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    child: Column(
                      children: [
                        if (showMusicLink) ...[
                          MusicLinkTileDark(url: musicUrl!.trim()),
                          const SizedBox(height: 12),
                        ],
                        if (showVoice) ...[
                          VoiceLetterTileDark(url: voiceUrl!.trim()),
                          const SizedBox(height: 12),
                        ],
                        if (senderLoc != null) ...[
                          LocationShareTileDark(lat: senderLoc.lat, lng: senderLoc.lng),
                          const SizedBox(height: 12),
                        ],

                        // ── Toggle de visibilidade (só receptor, carta aberta) ──
                        if (_isReceiver && _isOpened) ...[
                          _buildVisibilityTile(l10n),
                          const SizedBox(height: 12),
                        ],

                        // ── QR Code (só receptor) ──────────────────────────────
                        if (_isReceiver || (!_isReceiver && !_isSender)) ...[
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(
                              builder: (_) => QrCodeScreen(
                                docId: widget.docId,
                                title: widget.data['title'] ?? '',
                                senderName: widget.data['senderName'] ?? '',
                                openDate: openDate,
                              ),
                            )),
                            child: _buildTile(
                              icon: Icons.qr_code,
                              iconColor: context.pal.accent,
                              iconBg: context.pal.accent.withOpacity(0.15),
                              iconBorder: context.pal.accent.withOpacity(0.3),
                              title: l10n.letterDetailQrTitle,
                              subtitle: l10n.letterDetailQrSubtitle,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],

                        // ── Compartilhar ───────────────────────────────────────
                        Builder(
                          builder: (ctx) => GestureDetector(
                            onTap: _sharingStory ? null : () => _shareToInstagramStory(ctx),
                            child: _buildTile(
                              icon: Icons.share_outlined,
                              iconColor: context.pal.accent,
                              iconBg: context.pal.accent.withOpacity(0.15),
                              iconBorder: context.pal.accent.withOpacity(0.3),
                              title: l10n.letterDetailShareTitle,
                              subtitle: l10n.letterDetailShareSubtitle,
                              trailing: _sharingStory
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisibilityTile(AppLocalizations l10n) {
    final isPublic = _isPublic;
    final icon = isPublic ? Icons.public_rounded : Icons.lock_outline_rounded;
    final iconColor = isPublic ? const Color(0xFF10B981) : Colors.white.withOpacity(0.5);
    final iconBg = isPublic ? const Color(0xFF10B981).withOpacity(0.15) : Colors.white.withOpacity(0.05);
    final iconBorder = isPublic ? const Color(0xFF10B981).withOpacity(0.3) : Colors.white.withOpacity(0.1);
    final title = isPublic ? l10n.letterPrivacyPublicLabel : l10n.letterPrivacyPrivateLabel;
    final subtitle = isPublic ? l10n.letterPrivacyPublicSubtitle : l10n.letterPrivacyPrivateSubtitle;

    return GestureDetector(
      onTap: _isUpdating ? null : _toggleVisibility,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1714),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPublic
                ? const Color(0xFF10B981).withOpacity(0.3)
                : Colors.white.withOpacity(0.08),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: iconBorder),
              ),
              child: _isUpdating
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: CircularProgressIndicator(strokeWidth: 2, color: iconColor),
                    )
                  : Icon(icon, size: 22, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: isPublic ? const Color(0xFF10B981) : Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    )),
                  Text(subtitle,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.35),
                    )),
                ],
              ),
            ),
            // Chip de status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isPublic
                    ? const Color(0xFF10B981).withOpacity(0.12)
                    : Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isPublic ? l10n.letterPrivacyActionMakePrivate : l10n.letterPrivacyActionMakePublic,
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  color: isPublic
                      ? const Color(0xFF10B981)
                      : Colors.white.withOpacity(0.4),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required Color iconBorder,
    required String title,
    required String subtitle,
    bool muted = false,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1714),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: iconBorder),
            ),
            child: Icon(icon, size: 22, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: muted ? Colors.white.withOpacity(0.8) : Colors.white,
                    fontWeight: FontWeight.w500,
                  )),
                Text(subtitle,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: Colors.white.withOpacity(muted ? 0.3 : 0.4),
                  )),
              ],
            ),
          ),
          trailing ?? Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.3)),
        ],
      ),
    );
  }
}

class _PaperLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.04)..strokeWidth = 1;
    for (double y = 28; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    canvas.drawLine(const Offset(36, 0), Offset(36, size.height),
      Paint()..color = const Color(0xFFC0392B).withOpacity(0.12)..strokeWidth = 1);
  }
  @override
  bool shouldRepaint(_) => false;
}
