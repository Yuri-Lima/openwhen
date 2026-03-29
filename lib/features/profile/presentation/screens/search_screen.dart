import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../../shared/widgets/owl_watermark.dart';
import '../../../../shared/widgets/owl_feedback_affordance.dart';
import '../../../../l10n/app_localizations.dart';
import 'user_profile_screen.dart';

/// User search loads all profiles once; each list row still attaches a live
/// `follows` listener (Seguir/Seguindo). At scale, replace with batched reads
/// (e.g. `whereIn` chunks of 10) or a Cloud Function–aggregated follow graph.

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
  /// Throttle pull-to-refresh to avoid repeated full-collection reads (Firestore cost).
  DateTime? _lastUsersRefresh;

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
        if (currentUid == null) {
          _allUsers = [];
          _filtered = [];
        } else {
          _allUsers = snap.docs.where((d) => d.id != currentUid).toList();
          _filtered = _allUsers;
        }
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
        final selfUid = FirebaseAuth.instance.currentUser?.uid;
        _filtered = _allUsers.where((doc) {
          if (selfUid != null && doc.id == selfUid) return false;
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
    final l10n = AppLocalizations.of(context)!;
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
                        Row(children: [
                          Text(l10n.searchTitle, style: GoogleFonts.dmSerifDisplay(fontSize: 22, color: context.pal.white, fontStyle: FontStyle.italic)),
                          const SizedBox(width: 6),
                          const OwlFeedbackAffordance(
                            forDarkHeader: true,
                            child: OwlWatermark(width: 18, height: 22, opacity: 2.2),
                          ),
                        ]),
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
                              style: GoogleFonts.dmSans(color: context.pal.white, fontSize: 15),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: l10n.searchHint,
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
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () async {
                      final now = DateTime.now();
                      if (_lastUsersRefresh != null &&
                          now.difference(_lastUsersRefresh!) <
                              const Duration(seconds: 3)) {
                        await Future<void>.delayed(Duration.zero);
                        return;
                      }
                      _lastUsersRefresh = now;
                      setState(() => _loading = true);
                      await _loadUsers();
                    },
                    child: _filtered.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.35,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('😕', style: TextStyle(fontSize: 40)),
                                      const SizedBox(height: 12),
                                      Text(l10n.searchEmpty,
                                        style: GoogleFonts.dmSerifDisplay(fontSize: 16, color: context.pal.ink, fontStyle: FontStyle.italic)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: _filtered.length,
                            itemBuilder: (_, i) => _buildUserTile(_filtered[i]),
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTile(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final l10n = AppLocalizations.of(context)!;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('follows')
          .where('followerUid', isEqualTo: currentUid)
          .where('followingUid', isEqualTo: doc.id)
          .snapshots(),
      builder: (_, followSnap) {
        final isFollowing = (followSnap.data?.docs ?? []).isNotEmpty;
        final isSelf = currentUid != null && doc.id == currentUid;

        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => UserProfileScreen(userId: doc.id, userName: data['name'] ?? ''),
          )),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: context.pal.card,
              border: Border(bottom: BorderSide(color: context.pal.border)),
            ),
            child: Row(
              children: [
                UserAvatar(
                  photoUrl: data['photoUrl'] as String?,
                  name: data['name'] as String? ?? 'U',
                  size: 48,
                  backgroundColor: context.pal.accentWarm,
                  textColor: context.pal.accent,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['name'] ?? '',
                        style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500, color: context.pal.ink)),
                      Text('@${data['username'] ?? ''}',
                        style: GoogleFonts.dmSans(fontSize: 12, color: context.pal.inkFaint)),
                    ],
                  ),
                ),
                if (!isSelf)
                  GestureDetector(
                    onTap: () async {
                      if (currentUid == null) return;
                      if (isFollowing) {
                        final docs = followSnap.data?.docs ?? [];
                        if (docs.isEmpty) return;
                        await FirebaseFirestore.instance.collection('follows').doc(docs.first.id).delete();
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
                        color: isFollowing ? Colors.transparent : context.pal.accent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isFollowing ? context.pal.inkFaint : context.pal.accent),
                      ),
                      child: Text(
                        isFollowing ? l10n.userProfileFollowing : l10n.userProfileFollow,
                        style: GoogleFonts.dmSans(
                          fontSize: 13, fontWeight: FontWeight.w500,
                          color: isFollowing ? context.pal.inkSoft : context.pal.white,
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
