import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../../shared/widgets/owl_logo.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../shared/theme/app_theme.dart';

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
      // Captura o QR Code como imagem
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
        text: '💌 Uma carta especial espera por você no OpenWhen!\n\n"${widget.title}"\n\nEscaneie o QR Code ou acesse: $_deepLink',
        subject: 'Uma carta especial espera por você 💌',
      );
    } catch (e) {
      _shareLink();
    }
    if (mounted) setState(() => _sharing = false);
  }

  Future<void> _shareLink() async {
    await Share.share(
      '💌 Uma carta especial espera por você no OpenWhen!\n\n"${widget.title}"\n\nAcesse: $_deepLink',
      subject: 'Uma carta especial espera por você 💌',
    );
    if (mounted) setState(() => _sharing = false);
  }

  Future<void> _copyLink() async {
    await Share.share(_deepLink);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Link copiado! 🔗', style: GoogleFonts.dmSans(fontSize: 13)),
          backgroundColor: AppColors.ink,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          // Header escuro
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A1714), Color(0xFF2C1810), Color(0xFF1A1714)],
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
                        Text('QR Code da carta',
                          style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: AppColors.white, fontStyle: FontStyle.italic)),
                        Text('Imprima e coloque no presente',
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
                  // Card do QR Code
                  RepaintBoundary(
                    key: _qrKey,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 32, offset: const Offset(0, 8)),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Topo
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF1A1714), Color(0xFF2C1810)],
                              ),
                              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 52, height: 52,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.accent,
                                    boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.4), blurRadius: 16)],
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFA93226)),
                                    child: Center(
                                      child: const OwlLogo(size: 44),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text('Uma carta especial espera por você',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.dmSerifDisplay(fontSize: 16, color: Colors.white, fontStyle: FontStyle.italic)),
                                const SizedBox(height: 4),
                                Text('De ${widget.senderName}  ·  Abre ${widget.openDate.day}/${widget.openDate.month}/${widget.openDate.year}',
                                  style: GoogleFonts.dmSans(fontSize: 11, color: Colors.white.withOpacity(0.4))),
                              ],
                            ),
                          ),

                          // QR Code
                          Padding(
                            padding: const EdgeInsets.all(28),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: AppColors.border, width: 1.5),
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
                                  style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: AppColors.ink, fontStyle: FontStyle.italic)),
                                const SizedBox(height: 6),
                                Text('Escaneie para acessar a carta',
                                  style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.inkFaint)),
                              ],
                            ),
                          ),

                          // Rodapé
                          Container(
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                            decoration: BoxDecoration(
                              color: AppColors.bg,
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                              border: Border(top: BorderSide(color: AppColors.border)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('💌', style: TextStyle(fontSize: 14)),
                                const SizedBox(width: 6),
                                Text('openwhen.app',
                                  style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.inkSoft, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Como usar
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.accentWarm,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.accent.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('🎁', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 10),
                            Text('Como usar no presente físico',
                              style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.ink, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildStep('1', 'Compartilhe o QR Code pelo WhatsApp ou imprima'),
                        _buildStep('2', 'Coloque dentro ou na embalagem do presente'),
                        _buildStep('3', 'A pessoa escaneia e descobre a carta'),
                        _buildStep('4', 'A carta abre automaticamente na data certa'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Link direto
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.link, size: 18, color: AppColors.inkSoft),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(_deepLink,
                            style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.inkSoft),
                            overflow: TextOverflow.ellipsis),
                        ),
                        GestureDetector(
                          onTap: _copyLink,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('Copiar', style: GoogleFonts.dmSans(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Botões de compartilhamento
                  Row(
                    children: [
                      // WhatsApp
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await Share.share(
                              '💌 Uma carta especial espera por você!\n\n"${widget.title}"\n\nAbra aqui: $_deepLink',
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
                      // Compartilhar QR
                      Expanded(
                        child: GestureDetector(
                          onTap: _sharing ? null : _shareQrCode,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _sharing
                                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                    : const Icon(Icons.share_outlined, size: 18, color: Colors.white),
                                const SizedBox(width: 8),
                                Text('Compartilhar', style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500)),
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
            decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
            child: Center(
              child: Text(number, style: GoogleFonts.dmSans(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.inkSoft, height: 1.5)),
          ),
        ],
      ),
    );
  }
}
