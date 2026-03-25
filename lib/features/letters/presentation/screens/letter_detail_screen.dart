import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/owl_watermark.dart';
import 'qr_code_screen.dart';

class LetterDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docId;

  const LetterDetailScreen({super.key, required this.data, required this.docId});

  @override
  Widget build(BuildContext context) {
    final openedAt = data['openedAt'] != null
        ? (data['openedAt'] as Timestamp).toDate()
        : DateTime.now();
    final createdAt = data['createdAt'] != null
        ? (data['createdAt'] as Timestamp).toDate()
        : DateTime.now();
    final openDate = data['openDate'] != null
        ? (data['openDate'] as Timestamp).toDate()
        : DateTime.now();

    return Scaffold(
      backgroundColor: const Color(0xFF080808),
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
                      child: Text(data['title'] ?? '',
                        style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: AppColors.white, fontStyle: FontStyle.italic),
                        overflow: TextOverflow.ellipsis),
                    ),
                    // Botão QR Code
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => QrCodeScreen(
                          docId: docId,
                          title: data['title'] ?? '',
                          senderName: data['senderName'] ?? '',
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

          // Papel da carta
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                        // Barra vermelha topo
                        Container(
                          height: 5,
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                          ),
                        ),
                        // Conteúdo da carta com linhas de papel
                        Stack(
                          children: [
                            // Linhas do papel
                            CustomPaint(
                              size: Size(MediaQuery.of(context).size.width - 32, 600),
                              painter: _PaperLinesPainter(),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(48, 32, 24, 32),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('UMA CARTA DE',
                                    style: TextStyle(fontSize: 9, letterSpacing: 4, color: AppColors.accent.withOpacity(0.8))),
                                  const SizedBox(height: 8),
                                  Text(data['senderName'] ?? '',
                                    style: GoogleFonts.dmSerifDisplay(fontSize: 22, color: const Color(0xFF160D04))),
                                  const SizedBox(height: 4),
                                  Text('para ${data['receiverName'] ?? ''}',
                                    style: GoogleFonts.dmSans(fontSize: 12, fontStyle: FontStyle.italic, color: const Color(0xFF7A5C3A))),
                                  const SizedBox(height: 20),
                                  Container(width: 32, height: 1, color: AppColors.accent.withOpacity(0.4)),
                                  const SizedBox(height: 12),
                                  Text(data['title'] ?? '',
                                    style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: const Color(0xFF160D04), fontStyle: FontStyle.italic)),
                                  const SizedBox(height: 20),
                                  Text(data['message'] ?? '',
                                    style: GoogleFonts.dmSerifDisplay(fontSize: 16, fontStyle: FontStyle.italic, color: const Color(0xFF241608), height: 2.0)),
                                  const SizedBox(height: 32),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text('— ${data['senderName'] ?? ''}',
                                          style: GoogleFonts.dmSerifDisplay(fontSize: 16, fontStyle: FontStyle.italic, color: const Color(0xFF4A2E14))),
                                        const SizedBox(height: 4),
                                        Text('Escrita ${createdAt.day}/${createdAt.month}/${createdAt.year}',
                                          style: TextStyle(fontSize: 9, letterSpacing: 2, color: AppColors.accent.withOpacity(0.5))),
                                        Text('Aberta ${openedAt.day}/${openedAt.month}/${openedAt.year}',
                                          style: TextStyle(fontSize: 9, letterSpacing: 2, color: AppColors.accent.withOpacity(0.5))),
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

                  // Ações
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    child: Column(
                      children: [
                        // QR Code destaque
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(
                            builder: (_) => QrCodeScreen(
                              docId: docId,
                              title: data['title'] ?? '',
                              senderName: data['senderName'] ?? '',
                              openDate: openDate,
                            ),
                          )),
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
                                  width: 44, height: 44,
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                                  ),
                                  child: const Icon(Icons.qr_code, size: 22, color: AppColors.accent),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Gerar QR Code',
                                        style: GoogleFonts.dmSans(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
                                      Text('Coloque no presente físico 🎁',
                                        style: GoogleFonts.dmSans(fontSize: 12, color: Colors.white.withOpacity(0.4))),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.3)),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Compartilhar
                        GestureDetector(
                          onTap: () {},
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
                                  width: 44, height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                                  ),
                                  child: Icon(Icons.share_outlined, size: 22, color: Colors.white.withOpacity(0.5)),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Compartilhar carta',
                                        style: GoogleFonts.dmSans(fontSize: 14, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w500)),
                                      Text('Stories, Reels ou link direto',
                                        style: GoogleFonts.dmSans(fontSize: 12, color: Colors.white.withOpacity(0.3))),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.3)),
                              ],
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
