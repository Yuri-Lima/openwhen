import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../shared/theme/app_theme.dart';

class QrCodeScreen extends StatelessWidget {
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

  String get _deepLink => 'https://openwhen.app/letter/$docId';

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                  // Card do QR Code — estilo cartão de presente
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 32, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Topo do cartão — fundo escuro com OW
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
                              // Lacre OW
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
                                    child: Text('OW', style: GoogleFonts.dmSerifDisplay(fontSize: 16, color: Colors.white, fontStyle: FontStyle.italic)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text('Uma carta especial espera por você',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.dmSerifDisplay(fontSize: 16, color: Colors.white, fontStyle: FontStyle.italic)),
                              const SizedBox(height: 4),
                              Text('De $senderName  ·  Abre ${openDate.day}/${openDate.month}/${openDate.year}',
                                style: GoogleFonts.dmSans(fontSize: 11, color: Colors.white.withOpacity(0.4))),
                            ],
                          ),
                        ),

                        // QR Code
                        Padding(
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            children: [
                              // Frame do QR
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
                              Text(title,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: AppColors.ink, fontStyle: FontStyle.italic)),
                              const SizedBox(height: 6),
                              Text('Escaneie para acessar a carta',
                                style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.inkFaint)),
                            ],
                          ),
                        ),

                        // Rodapé do cartão
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
                        _buildStep('1', 'Imprima este QR Code ou salve na galeria'),
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
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Link copiado! 🔗', style: GoogleFonts.dmSans(fontSize: 13)),
                                backgroundColor: AppColors.ink,
                              ),
                            );
                          },
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

                  // Botões de ação
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Salvando na galeria... 📸', style: GoogleFonts.dmSans(fontSize: 13)),
                                backgroundColor: AppColors.ink,
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.download_outlined, size: 18, color: AppColors.inkSoft),
                                const SizedBox(width: 8),
                                Text('Salvar', style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.ink)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Compartilhando... 🚀', style: GoogleFonts.dmSans(fontSize: 13)),
                                backgroundColor: AppColors.ink,
                              ),
                            );
                          },
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
                                const Icon(Icons.share_outlined, size: 18, color: Colors.white),
                                const SizedBox(width: 8),
                                Text('Compartilhar', style: GoogleFonts.dmSans(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
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
