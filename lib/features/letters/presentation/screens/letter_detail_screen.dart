import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../shared/theme/app_theme.dart';

class LetterDetailScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final String docId;

  const LetterDetailScreen({
    super.key,
    required this.data,
    required this.docId,
  });

  @override
  State<LetterDetailScreen> createState() => _LetterDetailScreenState();
}

class _LetterDetailScreenState extends State<LetterDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final openedAt = data['openedAt'] != null
        ? (data['openedAt'] as Timestamp).toDate()
        : DateTime.now();

    return Scaffold(
      backgroundColor: AppColors.ink,
      body: Stack(
        children: [
          // Brilho radial vermelho
          Center(
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withOpacity(0.08),
                    AppColors.accent.withOpacity(0.02),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Conteúdo
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
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
                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            size: 18,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.06)),
                        ),
                        child: Text(
                          '💌 Carta aberta',
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Carta
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeIn,
                    child: SlideTransition(
                      position: _slideUp,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // De / Para
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'DE',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 10,
                                        color: Colors.white.withOpacity(0.25),
                                        letterSpacing: 2,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      data['senderName'] ?? '',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 13,
                                        color: Colors.white.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 32),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'PARA',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 10,
                                        color: Colors.white.withOpacity(0.25),
                                        letterSpacing: 2,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      data['receiverName'] ?? '',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 13,
                                        color: Colors.white.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'ABERTA EM',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 10,
                                        color: Colors.white.withOpacity(0.25),
                                        letterSpacing: 2,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${openedAt.day}/${openedAt.month}/${openedAt.year}',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 13,
                                        color: Colors.white.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            // Linha separadora
                            Container(
                              height: 1,
                              color: Colors.white.withOpacity(0.06),
                            ),
                            const SizedBox(height: 32),
                            // Título
                            Text(
                              data['title'] ?? '',
                              style: GoogleFonts.dmSerifDisplay(
                                fontSize: 28,
                                color: AppColors.white,
                                fontStyle: FontStyle.italic,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Mensagem
                            Text(
                              data['message'] ?? '',
                              style: GoogleFonts.dmSerifDisplay(
                                fontSize: 17,
                                color: Colors.white.withOpacity(0.75),
                                fontStyle: FontStyle.italic,
                                height: 1.9,
                              ),
                            ),
                            const SizedBox(height: 48),
                            // Linha separadora
                            Container(
                              height: 1,
                              color: Colors.white.withOpacity(0.06),
                            ),
                            const SizedBox(height: 24),
                            // Assinatura
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Com carinho,',
                                      style: GoogleFonts.dmSerifDisplay(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(0.3),
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      data['senderName'] ?? '',
                                      style: GoogleFonts.dmSerifDisplay(
                                        fontSize: 18,
                                        color: Colors.white.withOpacity(0.6),
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            // Botão publicar no feed
                            if (data['canBeShared'] == true &&
                                data['isPublic'] == false)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('letters')
                                        .doc(widget.docId)
                                        .update({
                                      'isPublic': true,
                                      'publishedAt': Timestamp.now(),
                                    });
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Carta publicada no feed! ✨'),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.accent,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 8,
                                    shadowColor:
                                        AppColors.accent.withOpacity(0.4),
                                  ),
                                  child: Text(
                                    '✦  Publicar no feed',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
