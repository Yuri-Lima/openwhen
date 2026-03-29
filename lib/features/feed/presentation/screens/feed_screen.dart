import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/config/system_config_provider.dart';
import '../../../../shared/moderation/report_flow.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../../shared/widgets/owl_watermark.dart';
import '../../../../shared/widgets/owl_feedback_affordance.dart';
import '../../../../shared/utils/date_formatter.dart';
import 'comments_screen.dart';
import '../../../profile/presentation/screens/user_profile_screen.dart';
import '../../../letters/presentation/screens/letter_detail_screen.dart';
import '../../../letters/data/letter_repository_actions.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  int _selectedFilter = 0;

  static const Map<int, List<String>> _filterEmotions = {
    1: ['love'],
    2: ['advice', 'achievement'],
    3: ['nostalgia', 'farewell'],
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final reportsEnabled = ref.watch(systemConfigProvider).value?.reportsEnabled ?? true;
    final filters = [l10n.feedFilterAll, l10n.feedFilterLove, l10n.feedFilterFriendship, l10n.feedFilterFamily];
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'OpenWhen',
                                  style: GoogleFonts.dmSerifDisplay(
                                    fontSize: 26,
                                    color: context.pal.white,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const OwlFeedbackAffordance(
                                  forDarkHeader: true,
                                  child: OwlWatermark(width: 20, height: 24, opacity: 2.2),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(l10n.feedPublicHeader, style: GoogleFonts.dmSans(fontSize: 10, color: Colors.white.withOpacity(0.25), fontWeight: FontWeight.w300, letterSpacing: 2)),
                          ],
                        ),
                        Row(
                          children: [
                            
                            _iconBtn(Icons.search),
                            const SizedBox(width: 8),
                            _iconBtn(Icons.notifications_outlined),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Filtros
                  SizedBox(
                    height: 44,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      itemCount: filters.length,
                      itemBuilder: (_, i) => GestureDetector(
                        onTap: () => setState(() => _selectedFilter = i),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: _selectedFilter == i ? context.pal.accent : Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _selectedFilter == i ? context.pal.accent : Colors.white.withOpacity(0.08)),
                          ),
                          child: Text(filters[i], style: GoogleFonts.dmSans(fontSize: 12,
                            color: _selectedFilter == i ? context.pal.white : Colors.white.withOpacity(0.4),
                            fontWeight: _selectedFilter == i ? FontWeight.w500 : FontWeight.w400)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Feed
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(FirestoreCollections.letters)
                  .where('isPublic', isEqualTo: true)
                  .where('status', isEqualTo: 'opened')
                  .orderBy('openedAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final allDocs = snapshot.data?.docs ?? [];
                if (allDocs.isEmpty) return _buildEmpty();

                final allowedKeys = _filterEmotions[_selectedFilter];
                final docs = allowedKeys == null
                    ? allDocs
                    : allDocs.where((d) {
                        final emotion = (d.data() as Map<String, dynamic>)['emotionalState'] as String?;
                        return emotion != null && allowedKeys.contains(emotion);
                      }).toList();

                if (docs.isEmpty) return _buildFilterEmpty();

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 100),
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    final data = docs[i].data() as Map<String, dynamic>;
                    return _FeedCard(
                      data: data,
                      docId: docs[i].id,
                      isFeatured: i == 0,
                      reportsEnabled: reportsEnabled,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon) => Container(
    width: 36, height: 36,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.08),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white.withOpacity(0.08)),
    ),
    child: Icon(icon, size: 18, color: Colors.white.withOpacity(0.5)),
  );

  Widget _buildEmpty() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('✨', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(l10n.feedEmptyTitle,
            style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: context.pal.ink, fontStyle: FontStyle.italic)),
          const SizedBox(height: 8),
          Text(l10n.feedEmptySubtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft, height: 1.6)),
        ],
      ),
    );
  }

  Widget _buildFilterEmpty() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔍', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 14),
          Text(l10n.feedFilterEmptyTitle,
            style: GoogleFonts.dmSerifDisplay(fontSize: 17, color: context.pal.ink, fontStyle: FontStyle.italic)),
          const SizedBox(height: 6),
          Text(l10n.feedFilterEmptySubtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft, height: 1.5)),
        ],
      ),
    );
  }
}

// ── Card individual do feed ──────────────────────────────────
class _FeedCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final String docId;
  final bool isFeatured;
  final bool reportsEnabled;

  const _FeedCard({
    required this.data,
    required this.docId,
    required this.isFeatured,
    required this.reportsEnabled,
  });

  @override
  State<_FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<_FeedCard> with SingleTickerProviderStateMixin {
  bool _showAllComments = false;
  final Set<String> _expandedCommentPreviewIds = <String>{};
  bool _expanded = false;
  late AnimationController _heartCtrl;
  late Animation<double> _heartScale;

  Color _bg(BuildContext ctx) => widget.isFeatured ? ctx.pal.headerGradient.first : ctx.pal.card;
  Color _text(BuildContext ctx) => widget.isFeatured ? Colors.white : ctx.pal.ink;
  Color _textSoft(BuildContext ctx) => widget.isFeatured ? Colors.white.withOpacity(0.6) : ctx.pal.inkSoft;
  Color _textFaint(BuildContext ctx) => widget.isFeatured ? Colors.white.withOpacity(0.4) : ctx.pal.inkFaint;
  Color _textMuted(BuildContext ctx) => widget.isFeatured ? Colors.white.withOpacity(0.25) : ctx.pal.inkFaint;
  Color _iconFaint(BuildContext ctx) => widget.isFeatured ? Colors.white.withOpacity(0.5) : ctx.pal.inkFaint;

  @override
  void initState() {
    super.initState();
    _heartCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _heartScale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _heartCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _heartCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final data = widget.data;
    final openedAt = data['openedAt'] != null ? (data['openedAt'] as Timestamp).toDate() : DateTime.now();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: _bg(context),
        border: Border(
          bottom: BorderSide(color: context.pal.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header do card — autor
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              children: [
                // ── Identificação do remetente ─────────────────────────────
                Builder(builder: (context) {
                  final hideSender = (data['hideSenderName'] ?? false) == true;
                  final senderUid  = data['senderUid'] as String? ?? '';
                  final senderName = data['senderName'] as String? ?? 'U';

                  Widget avatarSection;
                  if (hideSender) {
                    // Remetente ocultado: avatar genérico, sem link para perfil
                    avatarSection = Row(
                      children: [
                        Container(
                          decoration: widget.isFeatured
                              ? BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: context.pal.accent.withOpacity(0.4)),
                                )
                              : null,
                          child: ClipOval(
                            child: UserAvatar(
                              photoUrl: null,
                              name: '?',
                              size: 38,
                              backgroundColor: widget.isFeatured
                                  ? context.pal.accent.withOpacity(0.35)
                                  : context.pal.accentWarm,
                              textColor: widget.isFeatured ? Colors.white : context.pal.accent,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.feedSenderAnonymous,
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                color: _text(context),
                              )),
                            Text(l10n.feedCardTo(data['receiverName'] as String? ?? ''),
                              style: GoogleFonts.dmSans(fontSize: 11, color: _textFaint(context))),
                          ],
                        ),
                      ],
                    );
                  } else {
                    // Remetente visível: avatar real + link para perfil
                    avatarSection = GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => UserProfileScreen(userId: senderUid, userName: senderName),
                      )),
                      child: Row(
                        children: [
                          StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection(FirestoreCollections.users)
                                .doc(senderUid)
                                .snapshots(),
                            builder: (context, userSnap) {
                              final map = userSnap.data?.data() as Map<String, dynamic>?;
                              final photoUrl = map?['photoUrl'] as String?;
                              return Container(
                                decoration: widget.isFeatured
                                    ? BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: context.pal.accent.withOpacity(0.4)),
                                      )
                                    : null,
                                child: ClipOval(
                                  child: UserAvatar(
                                    photoUrl: photoUrl,
                                    name: senderName,
                                    size: 38,
                                    backgroundColor: widget.isFeatured
                                        ? context.pal.accent.withOpacity(0.35)
                                        : context.pal.accentWarm,
                                    textColor: widget.isFeatured ? Colors.white : context.pal.accent,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(senderName,
                                style: GoogleFonts.dmSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: _text(context),
                                )),
                              Text(l10n.feedCardTo(data['receiverName'] as String? ?? ''),
                                style: GoogleFonts.dmSans(fontSize: 11, color: _textFaint(context))),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return avatarSection;
                }),

                const Spacer(),

                // ── Menu ··· — visível apenas para o destinatário ──────────
                Builder(builder: (context) {
                  // isReceiver: o usuário logado é quem recebeu (e publicou) a carta
                  final isReceiver = uid != null &&
                      (data['receiverUid'] as String? ?? '') == uid;
                  // isStranger: nem remetente nem destinatário
                  final isSender   = uid != null && (data['senderUid'] as String? ?? '') == uid;
                  final isStranger = uid != null && !isReceiver && !isSender;

                  final isPublic    = data['isPublic'] == true;
                  final hideSender  = (data['hideSenderName'] ?? false) == true;

                  if (isReceiver) {
                    return PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, size: 20, color: _textFaint(context)),
                      tooltip: '',
                      onSelected: (value) async {
                        switch (value) {
                          case 'toggle_public':
                            await setLetterPublic(
                              docId: widget.docId,
                              isPublic: !isPublic,
                            );
                            break;
                          case 'toggle_sender':
                            await setLetterHideSenderName(
                              docId: widget.docId,
                              hide: !hideSender,
                            );
                            break;
                          case 'remove_feed':
                            await setLetterPublic(
                              docId: widget.docId,
                              isPublic: false,
                            );
                            break;
                        }
                      },
                      itemBuilder: (ctx) => [
                        // 1. Tornar privada / pública
                        PopupMenuItem<String>(
                          value: 'toggle_public',
                          child: Row(children: [
                            Icon(
                              isPublic
                                  ? Icons.lock_outline_rounded
                                  : Icons.public_rounded,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text(isPublic
                                ? l10n.vaultLetterSheetMakePrivate
                                : l10n.vaultLetterSheetMakePublic),
                          ]),
                        ),
                        // 2. Ocultar / mostrar nome do remetente (só quando pública)
                        if (isPublic)
                          PopupMenuItem<String>(
                            value: 'toggle_sender',
                            child: Row(children: [
                              Icon(
                                hideSender
                                    ? Icons.person_rounded
                                    : Icons.person_off_rounded,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Text(hideSender
                                  ? l10n.feedShowSenderName
                                  : l10n.feedHideSenderName),
                            ]),
                          ),
                        // 3. Remover do feed (divisor visual)
                        const PopupMenuDivider(),
                        PopupMenuItem<String>(
                          value: 'remove_feed',
                          child: Row(children: [
                            Icon(
                              Icons.remove_circle_outline_rounded,
                              size: 18,
                              color: Colors.red.shade700,
                            ),
                            const SizedBox(width: 10),
                            Text(l10n.feedRemoveFromFeed,
                              style: TextStyle(color: Colors.red.shade700)),
                          ]),
                        ),
                      ],
                    );
                  }

                  if (isStranger && widget.reportsEnabled) {
                    return PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, size: 20, color: _textFaint(context)),
                      tooltip: '',
                      onSelected: (value) {
                        if (value == 'report') {
                          showReportContentSheet(
                            context,
                            targetType: 'letter',
                            targetId: widget.docId,
                            letterId: widget.docId,
                          );
                        }
                      },
                      itemBuilder: (ctx) => [
                        PopupMenuItem<String>(
                          value: 'report',
                          child: Text(l10n.reportMenuLabel),
                        ),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                }),

                if (widget.isFeatured) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.pal.accent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: context.pal.accent.withOpacity(0.3)),
                    ),
                    child: Text(l10n.feedCardFeatured,
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        color: context.pal.accent,
                        fontWeight: FontWeight.w500,
                      )),
                  ),
                ],
              ],
            ),
          ),

          // Conteúdo da carta
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['title'] ?? '',
                  style: GoogleFonts.dmSerifDisplay(fontSize: 18,
                    color: _text(context),
                    fontStyle: FontStyle.italic, height: 1.3)),
                const SizedBox(height: 8),
                Text(data['message'] ?? '',
                  maxLines: _expanded ? null : 4,
                  overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
                  style: GoogleFonts.dmSans(fontSize: 14,
                    color: _textSoft(context),
                    height: 1.6)),
                const SizedBox(height: 6),
                // Botões: "Ler mais" ou "Ler carta completa"
                if (!_expanded)
                  GestureDetector(
                    onTap: () => setState(() => _expanded = true),
                    child: Text(l10n.feedReadMore,
                      style: GoogleFonts.dmSans(fontSize: 13,
                        color: _textFaint(context),
                        fontWeight: FontWeight.w500)),
                  )
                else ...[
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder: (_) => LetterDetailScreen(
                        data: data,
                        docId: widget.docId,
                      ),
                    )),
                    child: Text(l10n.feedReadFullLetter,
                      style: GoogleFonts.dmSans(fontSize: 13,
                        color: context.pal.accent,
                        fontWeight: FontWeight.w500)),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  l10n.feedOpenedOnDate(formatShortDate(openedAt, locale)),
                  style: GoogleFonts.dmSans(fontSize: 10,
                    color: _textMuted(context),
                    letterSpacing: 1),
                ),
              ],
            ),
          ),

          // Ações — like e comentário
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Row(
              children: [
                // Like
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(FirestoreCollections.likes)
                      .where('letterId', isEqualTo: widget.docId)
                      .where('userUid', isEqualTo: uid)
                      .snapshots(),
                  builder: (_, likeSnap) {
                    final liked = (likeSnap.data?.docs ?? []).isNotEmpty;
                    return GestureDetector(
                      onTap: () async {
                        _heartCtrl.forward(from: 0);
                        if (liked) {
                          await FirebaseFirestore.instance.collection(FirestoreCollections.likes).doc(likeSnap.data!.docs.first.id).delete();
                          await FirebaseFirestore.instance.collection(FirestoreCollections.letters).doc(widget.docId).update({'likeCount': FieldValue.increment(-1)});
                        } else {
                          await FirebaseFirestore.instance.collection(FirestoreCollections.likes).add({'letterId': widget.docId, 'userUid': uid, 'createdAt': Timestamp.now()});
                          await FirebaseFirestore.instance.collection(FirestoreCollections.letters).doc(widget.docId).update({'likeCount': FieldValue.increment(1)});
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            AnimatedBuilder(
                              animation: _heartScale,
                              builder: (_, __) => Transform.scale(
                                scale: _heartScale.value,
                                child: Icon(
                                  liked ? Icons.favorite : Icons.favorite_border,
                                  size: 22,
                                  color: liked ? context.pal.accent : _iconFaint(context),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text('${widget.data['likeCount'] ?? 0}',
                              style: GoogleFonts.dmSans(fontSize: 13,
                                color: _iconFaint(context))),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                // Comentário
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => CommentsScreen(letterId: widget.docId, letterTitle: widget.data['title'] ?? ''),
                  )),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 22,
                          color: _iconFaint(context)),
                        const SizedBox(width: 4),
                        Text('${widget.data['commentCount'] ?? 0}',
                          style: GoogleFonts.dmSans(fontSize: 13,
                            color: _iconFaint(context))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Preview de comentários
          if ((widget.data['commentCount'] ?? 0) > 0)
            _buildCommentsPreview(uid),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildCommentsPreview(String? uid) {
    final l10n = AppLocalizations.of(context)!;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(FirestoreCollections.comments)
          .where('letterId', isEqualTo: widget.docId)
          .orderBy('createdAt', descending: false)
          .limit(_showAllComments ? 20 : 2)
          .snapshots(),
      builder: (_, snap) {
        final docs = snap.data?.docs ?? [];
        if (docs.isEmpty) return const SizedBox();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(height: 1, color: widget.isFeatured ? Colors.white.withOpacity(0.08) : context.pal.border),
            ...docs.map((doc) {
              final c = doc.data() as Map<String, dynamic>;
              final message = c['message'] as String? ?? '';
              final commentExpanded = _expandedCommentPreviewIds.contains(doc.id);
              final showReadMore = !commentExpanded &&
                  (message.length > 120 || message.split('\n').length >= 4);
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${c['userName'] ?? ''}  ',
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: widget.isFeatured ? Colors.white.withOpacity(0.8) : context.pal.ink,
                            ),
                          ),
                          TextSpan(
                            text: message,
                            style: GoogleFonts.dmSans(fontSize: 13, color: _textSoft(context)),
                          ),
                        ],
                      ),
                      maxLines: commentExpanded ? null : 4,
                      overflow: commentExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    ),
                    if (showReadMore)
                      GestureDetector(
                        onTap: () => setState(() => _expandedCommentPreviewIds.add(doc.id)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            l10n.feedReadMore,
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              color: _textFaint(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
            if (!_showAllComments && (widget.data['commentCount'] ?? 0) > 2)
              GestureDetector(
                onTap: () => setState(() => _showAllComments = true),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                  child: Text(l10n.feedViewAllComments(widget.data['commentCount'] as int? ?? 0),
                    style: GoogleFonts.dmSans(fontSize: 12,
                      color: _textMuted(context))),
                ),
              ),
          ],
        );
      },
    );
  }
}
