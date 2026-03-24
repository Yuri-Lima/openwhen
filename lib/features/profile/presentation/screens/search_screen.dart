import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/user_avatar.dart';
import 'user_profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchCtrl = TextEditingController();
  List<DocumentSnapshot> _allUsers = [];
  List<DocumentSnapshot> _filtered = [];
  bool _loading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final snap = await FirebaseFirestore.instance
        .collection(FirestoreCollections.users)
        .get();

    if (mounted) {
      setState(() {
        _allUsers = snap.docs.where((d) => d.id != currentUid).toList();
        _filtered = _allUsers;
        _loading = false;
      });
    }
  }

  void _search(String query) {
    setState(() {
      _query = query;
      if (query.trim().isEmpty) {
        _filtered = _allUsers;
      } else {
        final q = query.toLowerCase();
        _filtered = _allUsers.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final name = (data['name'] ?? '').toLowerCase();
          final username = (data['username'] ?? '').toLowerCase();
          return name.contains(q) || username.contains(q);
        }).toList();
      }
    });
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
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
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
                        Text('Buscar pessoas',
                          style: GoogleFonts.dmSerifDisplay(fontSize: 22, color: AppColors.white, fontStyle: FontStyle.italic)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.search, size: 18, color: Colors.white.withOpacity(0.4)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchCtrl,
                              autofocus: true,
                              style: GoogleFonts.dmSans(color: AppColors.white, fontSize: 15),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Buscar por nome ou @username...',
                                hintStyle: GoogleFonts.dmSans(color: Colors.white.withOpacity(0.3), fontSize: 15),
                                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onChanged: _search,
                            ),
                          ),
                          if (_query.isNotEmpty)
                            GestureDetector(
                              onTap: () { _searchCtrl.clear(); _search(''); },
                              child: Icon(Icons.close, size: 18, color: Colors.white.withOpacity(0.4)),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Resultados
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('😕', style: TextStyle(fontSize: 40)),
                            const SizedBox(height: 12),
                            Text('Nenhum resultado',
                              style: GoogleFonts.dmSerifDisplay(fontSize: 16, color: AppColors.ink, fontStyle: FontStyle.italic)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filtered.length,
                        itemBuilder: (_, i) => _buildUserTile(_filtered[i]),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTile(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('follows')
          .where('followerUid', isEqualTo: currentUid)
          .where('followingUid', isEqualTo: doc.id)
          .snapshots(),
      builder: (_, followSnap) {
        final isFollowing = (followSnap.data?.docs ?? []).isNotEmpty;

        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => UserProfileScreen(userId: doc.id, userName: data['name'] ?? ''),
          )),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                UserAvatar(
                  photoUrl: data['photoUrl'] as String?,
                  name: data['name'] as String? ?? 'U',
                  size: 48,
                  backgroundColor: AppColors.accentWarm,
                  textColor: AppColors.accent,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['name'] ?? '',
                        style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.ink)),
                      Text('@${data['username'] ?? ''}',
                        style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.inkFaint)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (isFollowing) {
                      await FirebaseFirestore.instance.collection('follows').doc(followSnap.data!.docs.first.id).delete();
                    } else {
                      await FirebaseFirestore.instance.collection('follows').add({
                        'followerUid': currentUid,
                        'followingUid': doc.id,
                        'createdAt': Timestamp.now(),
                      });
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: isFollowing ? Colors.transparent : AppColors.accent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isFollowing ? AppColors.inkFaint : AppColors.accent),
                    ),
                    child: Text(
                      isFollowing ? 'Seguindo' : 'Seguir',
                      style: GoogleFonts.dmSans(
                        fontSize: 13, fontWeight: FontWeight.w500,
                        color: isFollowing ? AppColors.inkSoft : AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
