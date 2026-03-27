import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../../shared/widgets/owl_logo.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/utils/date_formatter.dart';

class QrCodeScreen extends StatefulWidget {
  final String docId;
  final String title;
  final String senderName;
  final DateTime openDate;

  const QrCodeScreen({
    super.key,
    required this.docId,
    required this.title,
    required this.senderName,
    required this.openDate,
  });

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  final GlobalKey _qrKey = GlobalKey();
  bool _sharing = false;

  String get _deepLink => 'https://openwhen.app/letter/${widget.docId}';

  Future<void> _shareQrCode() async {
    setState(() => _sharing = true);
    try {
      final l10n = AppLocalizations.of(context)!;
      final boundary = _qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        _shareLink();
        return;
      }
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        _shareLink();
        return;
      }
      final bytes = byteData.buffer.asUint8List();
      final xFile = XFile.fromData(bytes, mimeType: 'image/png', name: 'openwhen_qrcode.png');
      await Share.shareXFiles(
        [xFile],
        text: l10n.qrShareText(widget.title, _deepLink),
        subject: l10n.qrShareSubject,
      );
    } catch (e) {
      _shareLink();
    }
    if (mounted) setState(() => _sharing = false);
  }

  Future<void> _shareLink() async {
    final l10n = AppLocalizations.of(context)!;
    await Share.share(
      l10n.qrShareLinkOnly(widget.title, _deepLink),
      subject: l10n.qrShareSubject,
    );
    if (mounted) setState(() => _sharing = false);
  }

  Future<void> _copyLink() async {
    final l10n = AppLocalizations.of(context)!;
    await Share.share(_deepLink);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.qrLinkCopied, style: GoogleFonts.dmSans(fontSize: 13)),
          backgroundColor: context.pal.ink,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    return Scaffold(
      backgroundColor: context.pal.bg,
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
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.qrScreenTitle,
                          style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: context.pal.white, fontStyle: FontStyle.italic)),
                        Text(l10n.qrScreenSubtitle,
                          style: GoogleFonts.dmSans(fontSize: 11, color: Colors.white.withOpacity(0.3))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  RepaintBoundary(
                    key: _qrKey,
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.pal.card,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 32, offset: const Offset(0, 8)),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  context.pal.headerGradient[0],
                                  context.pal.headerGradient[1],
                                ],
                              ),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: context.pal.accent.withOpacity(0.45),
                                        blurRadius: 18,
                                      ),
                                    ],
                                  ),
                                  child: const OwlLogo(
                                    size: 52,
                                    mode: OwlLogoMode.sealOnly,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(l10n.qrCardHeadline,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.dmSerifDisplay(fontSize: 16, color: Colors.white, fontStyle: FontStyle.italic)),
                                const SizedBox(height: 4),
                                Text(l10n.qrCardMeta(widget.senderName, formatShortDate(widget.openDate, locale)),
                                  style: GoogleFonts.dmSans(fontSize: 11, color: Colors.white.withOpacity(0.4))),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(28),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: context.pal.border, width: 1.5),
                                  ),
                                  child: QrImageView(
                                    data: _deepLink,
                                    version: QrVersions.auto,
                                    size: 200,
                                    backgroundColor: Colors.white,
                                    eyeStyle: const QrEyeStyle(
                                      eyeShape: QrEyeShape.square,
                                      color: Color(0xFF1A1714),
                                    ),
                                    dataModuleStyle: const QrDataModuleStyle(
                                      dataModuleShape: QrDataModuleShape.square,
                                      color: Color(0xFF1A1714),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(widget.title,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: context.pal.ink, fontStyle: FontStyle.italic)),
                                const SizedBox(height: 6),
                                Text(l10n.qrScanHint,
                                  style: GoogleFonts.dmSans(fontSize: 12, color: context.pal.inkFaint)),
                              ],
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                            decoration: BoxDecoration(
                              color: context.pal.bg,
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                              border: Border(top: BorderSide(color: context.pal.border)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('💌', style: TextStyle(fontSize: 14)),
                                const SizedBox(width: 6),
                                Text('openwhen.app',
                                  style: GoogleFonts.dmSans(fontSize: 12, color: context.pal.inkSoft, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: context.pal.accentWarm,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: context.pal.accent.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('🎁', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 10),
                            Text(l10n.qrHowToTitle,
                              style: GoogleFonts.dmSans(fontSize: 14, color: context.pal.ink, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildStep('1', l10n.qrStep1),
                        _buildStep('2', l10n.qrStep2),
                        _buildStep('3', l10n.qrStep3),
                        _buildStep('4', l10n.qrStep4),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.pal.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: context.pal.border),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.link, size: 18, color: context.pal.inkSoft),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(_deepLink,
                            style: GoogleFonts.dmSans(fontSize: 12, color: context.pal.inkSoft),
                            overflow: TextOverflow.ellipsis),
                        ),
                        GestureDetector(
                          onTap: _copyLink,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: context.pal.accent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(l10n.actionCopy, style: GoogleFonts.dmSans(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await Share.share(
                              l10n.qrShareWhatsApp(widget.title, _deepLink),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF25D366),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [BoxShadow(color: const Color(0xFF25D366).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.chat, size: 18, color: Colors.white),
                                const SizedBox(width: 8),
                                Text('WhatsApp', style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: _sharing ? null : _shareQrCode,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: context.pal.accent,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [BoxShadow(color: context.pal.accent.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _sharing
                                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                    : const Icon(Icons.share_outlined, size: 18, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(l10n.actionShare, style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20, height: 20,
            decoration: BoxDecoration(color: context.pal.accent, shape: BoxShape.circle),
            child: Center(
              child: Text(number, style: GoogleFonts.dmSans(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft, height: 1.5)),
          ),
        ],
      ),
    );
  }
}
