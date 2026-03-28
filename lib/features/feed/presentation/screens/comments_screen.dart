import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/config/system_config_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/moderation/report_flow.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../../shared/utils/date_formatter.dart';

const Map<String, List<String>> _bannedWordsByLocale = {
  'pt': [
    'idiota', 'imbecil', 'burro', 'estupido', 'estúpido',
    'lixo', 'merda', 'puta', 'viado', 'fdp',
    'canalha', 'vagabundo', 'prostituta', 'desgraça',
    'maldito', 'inferno', 'otario', 'otário',
    'odeio', 'morra', 'morte',
  ],
  'en': [
    'idiot', 'moron', 'stupid', 'dumb', 'trash',
    'shit', 'fuck', 'bitch', 'asshole', 'bastard',
    'slut', 'whore', 'damn', 'crap', 'hate',
    'die', 'kill',
  ],
  'es': [
    'idiota', 'imbécil', 'estúpido', 'tonto', 'basura',
    'mierda', 'puta', 'cabrón', 'pendejo', 'maricón',
    'maldito', 'infierno', 'odio', 'muere', 'muerte',
    'desgraciado', 'prostituta',
  ],
};

bool _containsBannedWord(String text, Locale locale) {
  final textLower = text.toLowerCase();
  final lang = locale.languageCode;
  final allWords = <String>{
    ..._bannedWordsByLocale['pt'] ?? [],
    ..._bannedWordsByLocale[lang] ?? [],
  };
  for (final word in allWords) {
    if (textLower.contains(word)) return true;
  }
  return false;
}

class CommentsScreen extends ConsumerStatefulWidget {
  final String letterId;
  final String letterTitle;

  const CommentsScreen({
    super.key,
    required this.letterId,
    required this.letterTitle,
  });

  @override
  ConsumerState<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final _commentController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _sendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final l10n = AppLocalizations.of(context)!;

    // Filtro de palavras ofensivas
    if (_containsBannedWord(text, Localizations.localeOf(context))) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.commentsModerationWarning,
            style: GoogleFonts.dmSans(fontSize: 13),
          ),
          backgroundColor: context.pal.accent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser!;
      final userDoc = await FirebaseFirestore.instance
          .collection(FirestoreCollections.users)
          .doc(user.uid)
          .get();
      final userName = userDoc.data()?['name'] ?? user.email ?? '';

      await FirebaseFirestore.instance
          .collection(FirestoreCollections.comments)
          .add({
        'letterId': widget.letterId,
        'userUid': user.uid,
        'userName': userName,
        'message': text,
        'createdAt': Timestamp.now(),
      });

      await FirebaseFirestore.instance
          .collection(FirestoreCollections.letters)
          .doc(widget.letterId)
          .update({'commentCount': FieldValue.increment(1)});

      _commentController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorGeneric(e.toString()))),
        );
      }
    }

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final reportsEnabled = ref.watch(systemConfigProvider).value?.reportsEnabled ?? true;
    return Scaffold(
      backgroundColor: context.pal.bg,
      body: Column(
        children: [
          // Header escuro
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
                          border: Border.all(color: Colors.white.withOpacity(0.08)),
                        ),
                        child: Icon(Icons.arrow_back, size: 18, color: Colors.white.withOpacity(0.6)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.commentsTitle, style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: context.pal.white, fontStyle: FontStyle.italic)),
                          Text(widget.letterTitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.dmSans(fontSize: 11, color: Colors.white.withOpacity(0.3))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Lista de comentários
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(FirestoreCollections.comments)
                  .where('letterId', isEqualTo: widget.letterId)
                  .orderBy('createdAt', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('💬', style: TextStyle(fontSize: 40)),
                        const SizedBox(height: 12),
                        Text(l10n.commentsEmptyTitle, style: GoogleFonts.dmSerifDisplay(fontSize: 16, color: context.pal.ink, fontStyle: FontStyle.italic)),
                        const SizedBox(height: 8),
                        Text(l10n.commentsEmptySubtitle, style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft)),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final data = docs[i].data() as Map<String, dynamic>;
                    final createdAt = (data['createdAt'] as Timestamp).toDate();
                    final isMe = data['userUid'] == FirebaseAuth.instance.currentUser?.uid;
                    final showReport = reportsEnabled && !isMe;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isMe ? context.pal.headerGradient.first : context.pal.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isMe ? Colors.transparent : context.pal.border),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection(FirestoreCollections.users)
                                .doc(data['userUid'] as String? ?? '')
                                .snapshots(),
                            builder: (context, userSnap) {
                              final map = userSnap.data?.data() as Map<String, dynamic>?;
                              final photoUrl = map?['photoUrl'] as String?;
                              return UserAvatar(
                                photoUrl: photoUrl,
                                name: data['userName'] as String? ?? 'U',
                                size: 36,
                                backgroundColor: isMe ? context.pal.accent : context.pal.accentWarm,
                                textColor: isMe ? context.pal.white : context.pal.accent,
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      data['userName'] ?? '',
                                      style: GoogleFonts.dmSans(fontSize: 13, color: isMe ? context.pal.white : context.pal.ink, fontWeight: FontWeight.w500),
                                    ),
                                    const Spacer(),
                                    Text(
                                      formatDayMonth(createdAt, locale),
                                      style: GoogleFonts.dmSans(fontSize: 11, color: isMe ? Colors.white.withOpacity(0.3) : context.pal.inkFaint),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  data['message'] ?? '',
                                  style: GoogleFonts.dmSans(fontSize: 14, color: isMe ? Colors.white.withOpacity(0.8) : context.pal.inkSoft, height: 1.5),
                                ),
                              ],
                            ),
                          ),
                          if (showReport)
                            PopupMenuButton<String>(
                              icon: Icon(
                                Icons.more_vert,
                                size: 20,
                                color: isMe ? Colors.white38 : context.pal.inkFaint,
                              ),
                              onSelected: (value) {
                                if (value == 'report') {
                                  showReportContentSheet(
                                    context,
                                    targetType: 'comment',
                                    targetId: docs[i].id,
                                    letterId: widget.letterId,
                                  );
                                }
                              },
                              itemBuilder: (ctx) => [
                                PopupMenuItem(
                                  value: 'report',
                                  child: Text(l10n.reportMenuLabel),
                                ),
                              ],
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Campo de comentário
          Container(
            decoration: BoxDecoration(
              color: context.pal.card,
              border: Border(top: BorderSide(color: context.pal.border)),
            ),
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              12 + MediaQuery.of(context).padding.bottom,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.pal.bg,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: context.pal.border),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: TextField(
                      controller: _commentController,
                      style: GoogleFonts.dmSans(fontSize: 14, color: context.pal.ink),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: l10n.commentsInputHint,
                        hintStyle: GoogleFonts.dmSans(color: context.pal.inkFaint, fontSize: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _isLoading ? null : _sendComment,
                  child: Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: context.pal.accent,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: context.pal.accent.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: _isLoading
                        ? const Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.send_rounded, color: Colors.white, size: 18),
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
