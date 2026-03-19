import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../shared/theme/app_theme.dart';
import 'comments_screen.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['Para todos', 'Amor', 'Amizade', 'Família'];

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
              child: Stack(
                children: [
                  Positioned(
                    top: -20, right: -20,
                    child: Container(
                      width: 150, height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [AppColors.accent.withOpacity(0.1), Colors.transparent]),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('OpenWhen', style: GoogleFonts.dmSerifDisplay(fontSize: 26, color: AppColors.white, fontStyle: FontStyle.italic)),
                                const SizedBox(height: 4),
                                Text('FEED PÚBLICO', style: GoogleFonts.dmSans(fontSize: 10, color: Colors.white.withOpacity(0.25), fontWeight: FontWeight.w300, letterSpacing: 2)),
                              ],
                            ),
                            Row(
                              children: [
                                _buildIconBtn(Icons.search),
                                const SizedBox(width: 8),
                                _buildIconBtn(Icons.notifications_outlined),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 44,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          itemCount: _filters.length,
                          itemBuilder: (context, i) => GestureDetector(
                            onTap: () => setState(() => _selectedFilter = i),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                color: _selectedFilter == i ? AppColors.accent : Colors.white.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: _selectedFilter == i ? AppColors.accent : Colors.white.withOpacity(0.08)),
                              ),
                              child: Text(
                                _filters[i],
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  color: _selectedFilter == i ? AppColors.white : Colors.white.withOpacity(0.4),
                                  fontWeight: _selectedFilter == i ? FontWeight.w500 : FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) return _buildEmpty();
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final data = docs[i].data() as Map<String, dynamic>;
                    return i == 0
                        ? _buildFeaturedCard(data: data, docId: docs[i].id)
                        : _buildNormalCard(data: data, docId: docs[i].id);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconBtn(IconData icon) {
    return Container(
      width: 36, height: 36,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Icon(icon, size: 18, color: Colors.white.withOpacity(0.5)),
    );
  }

  Widget _buildFeaturedCard({required Map<String, dynamic> data, required String docId}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.ink.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                ),
                child: Text('✦ Em destaque', style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.accent, fontWeight: FontWeight.w500)),
              ),
              const Spacer(),
              Text(data['senderName'] ?? '', style: GoogleFonts.dmSans(fontSize: 11, color: Colors.white.withOpacity(0.35))),
            ],
          ),
          const SizedBox(height: 14),
          Text(data['title'] ?? '', style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: AppColors.white, fontStyle: FontStyle.italic)),
          const SizedBox(height: 8),
          Text(data['message'] ?? '', maxLines: 3, overflow: TextOverflow.ellipsis,
            style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white.withOpacity(0.5), height: 1.6)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildLikeButton(docId: docId, likeCount: data['likeCount'] ?? 0),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => CommentsScreen(letterId: docId, letterTitle: data['title'] ?? ''),
                )),
                child: Row(
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 16, color: Colors.white.withOpacity(0.4)),
                    const SizedBox(width: 4),
                    Text('${data['commentCount'] ?? 0}', style: GoogleFonts.dmSans(fontSize: 12, color: Colors.white.withOpacity(0.4))),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNormalCard({required Map<String, dynamic> data, required String docId}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: AppColors.accentWarm, borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Text(
                    (data['senderName'] as String? ?? 'U').substring(0, 1).toUpperCase(),
                    style: GoogleFonts.dmSerifDisplay(fontSize: 16, color: AppColors.accent, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['senderName'] ?? '', style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.ink, fontWeight: FontWeight.w500)),
                  Text('Para: ${data['receiverName'] ?? ''}', style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.inkFaint)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(data['title'] ?? '', style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: AppColors.ink, fontStyle: FontStyle.italic)),
          const SizedBox(height: 8),
          Text(data['message'] ?? '', maxLines: 3, overflow: TextOverflow.ellipsis,
            style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.inkSoft, height: 1.6)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildLikeButton(docId: docId, likeCount: data['likeCount'] ?? 0, isDark: false),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => CommentsScreen(letterId: docId, letterTitle: data['title'] ?? ''),
                )),
                child: Row(
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 16, color: AppColors.inkFaint),
                    const SizedBox(width: 4),
                    Text('${data['commentCount'] ?? 0}', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.inkFaint)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLikeButton({required String docId, required int likeCount, bool isDark = true}) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(FirestoreCollections.likes)
          .where('letterId', isEqualTo: docId)
          .where('userUid', isEqualTo: uid)
          .snapshots(),
      builder: (context, snapshot) {
        final liked = (snapshot.data?.docs ?? []).isNotEmpty;
        return GestureDetector(
          onTap: () async {
            if (liked) {
              await FirebaseFirestore.instance.collection(FirestoreCollections.likes).doc(snapshot.data!.docs.first.id).delete();
              await FirebaseFirestore.instance.collection(FirestoreCollections.letters).doc(docId).update({'likeCount': FieldValue.increment(-1)});
            } else {
              await FirebaseFirestore.instance.collection(FirestoreCollections.likes).add({'letterId': docId, 'userUid': uid, 'createdAt': Timestamp.now()});
              await FirebaseFirestore.instance.collection(FirestoreCollections.letters).doc(docId).update({'likeCount': FieldValue.increment(1)});
            }
          },
          child: Row(
            children: [
              Icon(liked ? Icons.favorite : Icons.favorite_border, size: 16,
                color: liked ? AppColors.accent : isDark ? Colors.white.withOpacity(0.4) : AppColors.inkFaint),
              const SizedBox(width: 4),
              Text('$likeCount', style: GoogleFonts.dmSans(fontSize: 12, color: isDark ? Colors.white.withOpacity(0.4) : AppColors.inkFaint)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('✨', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text('Nenhuma carta pública ainda', style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: AppColors.ink, fontStyle: FontStyle.italic)),
          const SizedBox(height: 8),
          Text('Seja o primeiro a compartilhar\numa carta com o mundo', textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.inkSoft, height: 1.6)),
        ],
      ),
    );
  }
}
