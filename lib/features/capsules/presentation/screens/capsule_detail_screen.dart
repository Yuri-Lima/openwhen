import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../shared/theme/app_theme.dart';

class CapsuleDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docId;

  const CapsuleDetailScreen({super.key, required this.data, required this.docId});

  static Map<String, (String, String, Color)> get themeLabels => {
        'memories': ('🧠', 'Memorias', const Color(0xFF6B6560)),
        'goals': ('🎯', 'Metas', const Color(0xFFC0392B)),
        'feelings': ('💛', 'Sentimentos', const Color(0xFFC9A84C)),
        'relationships': ('👥', 'Relacionamentos', const Color(0xFF5B8DB8)),
        'growth': ('🌱', 'Crescimento', const Color(0xFF4A8C6F)),
      };

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
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir capsula?'),
        content: const Text('Esta acao nao pode ser desfeita.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Excluir', style: TextStyle(color: AppColors.accent)),
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
    final themeId = data['theme'] as String? ?? 'memories';
    final td = themeLabels[themeId] ?? ('⏳', 'Capsula', const Color(0xFF6B6560));
    final title = data['title'] as String? ?? '';
    final openedAt = data['openedAt'] != null ? (data['openedAt'] as Timestamp).toDate() : DateTime.now();
    final createdAt = data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : DateTime.now();
    final isPublic = data['isPublic'] == true;
    final qa = _qaPairs();

    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: Column(
        children: [
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
                              color: AppColors.white,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '${td.$1} ${td.$2}',
                                style: GoogleFonts.dmSans(fontSize: 11, color: Colors.white.withOpacity(0.45)),
                              ),
                              if (isPublic) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'No feed',
                                    style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.accent),
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
                            color: td.$3,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Sua capsula',
                          style: TextStyle(
                            fontSize: 9,
                            letterSpacing: 3,
                            color: td.$3.withOpacity(0.9),
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
                          'Criada em ${createdAt.day}/${createdAt.month}/${createdAt.year}  ·  Aberta em ${openedAt.day}/${openedAt.month}/${openedAt.year}',
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
                  const SizedBox(height: 20),
                  _actionTile(
                    icon: Icons.share_outlined,
                    title: 'Compartilhar',
                    subtitle: 'Texto resumido da capsula',
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
                    title: 'Excluir capsula',
                    subtitle: 'Remove do cofre permanentemente',
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
