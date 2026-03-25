import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/owl_watermark.dart';
import '../../../../shared/widgets/owl_watermark.dart';
import 'letter_detail_screen.dart';
import 'letter_opening_screen.dart';
import '../../../capsules/presentation/screens/create_capsule_screen.dart';
import '../../../capsules/presentation/screens/capsule_opening_screen.dart';

class VaultScreen extends ConsumerStatefulWidget {
  const VaultScreen({super.key});

  @override
  ConsumerState<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends ConsumerState<VaultScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _countdown(DateTime openDate) {
    final now = DateTime.now();
    final diff = openDate.difference(now);
    if (diff.isNegative) return 'Pronta para abrir!';
    if (diff.inDays > 0) return 'Abre em ${diff.inDays} dias';
    if (diff.inHours > 0) return 'Abre em ${diff.inHours} horas';
    return 'Abre em ${diff.inMinutes} minutos';
  }

  double _progress(DateTime createdAt, DateTime openDate) {
    final total = openDate.difference(createdAt).inSeconds;
    final elapsed = DateTime.now().difference(createdAt).inSeconds;
    if (total <= 0) return 1.0;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1714), Color(0xFF2C1810), Color(0xFF1A1714)],
            ),
          ),
          child: SafeArea(bottom: false, child: Column(children: [
            Stack(children: [
              Positioned(top: -20, right: -20, child: Container(width: 150, height: 150, decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [AppColors.accent.withOpacity(0.1), Colors.transparent])))),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [Text('Meu Cofre', style: GoogleFonts.dmSerifDisplay(fontSize: 26, color: AppColors.white, fontStyle: FontStyle.italic)), const SizedBox(width: 6), const OwlWatermark(width: 20, height: 24)]),
                    const SizedBox(height: 4),
                    Text('SUAS CARTAS E CAPSULAS', style: GoogleFonts.dmSans(fontSize: 10, color: Colors.white.withOpacity(0.25), fontWeight: FontWeight.w300, letterSpacing: 2)),
                  ]),
                  Container(width: 36, height: 36, decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.08))), child: Icon(Icons.tune_rounded, size: 18, color: Colors.white.withOpacity(0.5))),
                ]),
              ),
            ]),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              labelColor: AppColors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.3),
              indicatorColor: AppColors.accent,
              indicatorWeight: 2,
              isScrollable: true,
              labelStyle: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w500),
              unselectedLabelStyle: GoogleFonts.dmSans(fontSize: 13),
              tabs: const [
                Tab(text: 'Aguardando'),
                Tab(text: 'Abertas'),
                Tab(text: 'Enviadas'),
                Tab(text: 'Capsulas'),
              ],
            ),
          ])),
        ),
        Expanded(child: TabBarView(controller: _tabController, children: [
          _buildLockedTab(uid),
          _buildOpenedTab(uid),
          _buildSentTab(uid),
          _buildCapsulesTab(uid),
        ])),
      ]),
    );
  }

  Widget _buildLockedTab(String uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(FirestoreCollections.letters).where('receiverUid', isEqualTo: uid).where('status', isEqualTo: 'locked').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) return _buildEmpty(emoji: '🔒', title: 'Nenhuma carta esperando', subtitle: 'Quando alguem te enviar uma carta\nela aparecera aqui');
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final data = docs[i].data() as Map<String, dynamic>;
            final openDate = (data['openDate'] as Timestamp).toDate();
            final createdAt = (data['createdAt'] as Timestamp).toDate();
            final canOpen = DateTime.now().isAfter(openDate);
            return _buildLockedCard(context: context, data: data, docId: docs[i].id, openDate: openDate, createdAt: createdAt, canOpen: canOpen);
          },
        );
      },
    );
  }

  Widget _buildOpenedTab(String uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(FirestoreCollections.letters).where('receiverUid', isEqualTo: uid).where('status', isEqualTo: 'opened').snapshots(),
      builder: (context, receivedSnap) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection(FirestoreCollections.letters).where('senderUid', isEqualTo: uid).where('status', isEqualTo: 'opened').snapshots(),
          builder: (context, sentSnap) {
            if (receivedSnap.connectionState == ConnectionState.waiting || sentSnap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            final allDocs = <String, QueryDocumentSnapshot>{};
            for (final doc in [...(receivedSnap.data?.docs ?? []), ...(sentSnap.data?.docs ?? [])]) { allDocs[doc.id] = doc; }
            final docs = allDocs.values.toList();
            if (docs.isEmpty) return _buildEmpty(emoji: '💌', title: 'Nenhuma carta aberta ainda', subtitle: 'Suas cartas abertas\naparecera aqui');
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: docs.length,
              itemBuilder: (context, i) {
                final data = docs[i].data() as Map<String, dynamic>;
                return _buildOpenedCard(context: context, data: data, docId: docs[i].id, uid: uid);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSentTab(String uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(FirestoreCollections.letters)
          .where('senderUid', isEqualTo: uid)
          .where('status', isEqualTo: 'locked')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) return _buildEmpty(emoji: '✉️', title: 'Nenhuma carta enviada', subtitle: 'As cartas que voce enviar\naparecera aqui');
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final data = docs[i].data() as Map<String, dynamic>;
            final openDate = (data['openDate'] as Timestamp).toDate();
            final createdAt = (data['createdAt'] as Timestamp).toDate();
            return _buildSentCard(context: context, data: data, docId: docs[i].id, openDate: openDate, createdAt: createdAt);
          },
        );
      },
    );
  }

  Widget _buildCapsulesTab(String uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('capsules').where('senderUid', isEqualTo: uid).orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) return _buildEmptyCapsules(context);
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final data = docs[i].data() as Map<String, dynamic>;
            return _buildCapsuleCard(context: context, data: data, docId: docs[i].id);
          },
        );
      },
    );
  }

  Widget _buildSentCard({required BuildContext context, required Map<String, dynamic> data, required String docId, required DateTime openDate, required DateTime createdAt}) {
    final status = data['status'] ?? 'locked';
    final requestStatus = data['requestStatus'] ?? 'accepted';
    final isOpened = status == 'opened';
    final isPending = requestStatus == 'pending';
    final canOpen = DateTime.now().isAfter(openDate);

    Color statusColor = AppColors.inkSoft;
    String statusLabel = 'Aguardando';
    String statusEmoji = '🔒';

    if (isPending) {
      statusColor = const Color(0xFFF59E0B);
      statusLabel = 'Pendente';
      statusEmoji = '⏳';
    } else if (isOpened) {
      statusColor = const Color(0xFF10B981);
      statusLabel = 'Aberta';
      statusEmoji = '💌';
    } else if (canOpen) {
      statusColor = AppColors.accent;
      statusLabel = 'Pronta!';
      statusEmoji = '✨';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: Text('$statusEmoji $statusLabel', style: GoogleFonts.dmSans(fontSize: 11, color: statusColor, fontWeight: FontWeight.w500)),
          ),
          const Spacer(),
          Text('Para: ${data['receiverName'] ?? ''}', style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.inkFaint)),
        ]),
        const SizedBox(height: 12),
        Text(data['title'] ?? '', style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: AppColors.ink, fontStyle: FontStyle.italic)),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: _progress(createdAt, openDate), backgroundColor: const Color(0xFFF0EBE6), valueColor: AlwaysStoppedAnimation<Color>(isOpened ? const Color(0xFF10B981) : canOpen ? AppColors.accent : AppColors.inkFaint), minHeight: 4),
        ),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            isOpened ? 'Ja foi aberta!' : _countdown(openDate),
            style: GoogleFonts.dmSans(fontSize: 12, color: isOpened ? const Color(0xFF10B981) : canOpen ? AppColors.accent : AppColors.inkSoft, fontWeight: FontWeight.w500),
          ),
          Text('${openDate.day}/${openDate.month}/${openDate.year}', style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.inkFaint)),
        ]),
        if (isPending) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              const Icon(Icons.info_outline_rounded, color: Color(0xFFF59E0B), size: 14),
              const SizedBox(width: 8),
              Expanded(child: Text('Aguardando o destinatario aceitar a carta', style: GoogleFonts.dmSans(fontSize: 11, color: const Color(0xFFF59E0B)))),
            ]),
          ),
        ],
      ]),
    );
  }

  Widget _buildCapsuleCard({required BuildContext context, required Map<String, dynamic> data, required String docId}) {
    final status = data['status'] ?? 'locked';
    final isOpen = status == 'opened';
    final theme = data['theme'] ?? 'memories';
    final title = data['title'] ?? '';
    final openDate = data['openDate'] != null ? (data['openDate'] as Timestamp).toDate() : null;
    final createdAt = data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : DateTime.now();
    final canOpen = openDate != null && DateTime.now().isAfter(openDate);
    final questions = (data['questions'] as List?)?.length ?? 0;
    final photos = (data['photos'] as List?)?.length ?? 0;

    final themeMap = {
      'memories':      ('🧠', 'Memorias',       const Color(0xFF6B6560)),
      'goals':         ('🎯', 'Metas',           const Color(0xFFC0392B)),
      'feelings':      ('💛', 'Sentimentos',     const Color(0xFFC9A84C)),
      'relationships': ('👥', 'Relacionamentos', const Color(0xFF5B8DB8)),
      'growth':        ('🌱', 'Crescimento',     const Color(0xFF4A8C6F)),
    };
    final td = themeMap[theme] ?? ('⏳', 'Capsula', const Color(0xFF6B6560));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isOpen ? AppColors.ink : AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isOpen ? Colors.transparent : AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: isOpen ? Colors.white.withOpacity(0.1) : td.$3.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
            child: Text('${td.$1} ${td.$2}', style: GoogleFonts.dmSans(fontSize: 11, color: isOpen ? Colors.white.withOpacity(0.7) : td.$3, fontWeight: FontWeight.w500)),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: canOpen ? AppColors.accentWarm : (isOpen ? Colors.white.withOpacity(0.08) : AppColors.bg), borderRadius: BorderRadius.circular(20)),
            child: Text(isOpen ? 'Aberta' : (canOpen ? 'Pronta!' : 'Selada'), style: GoogleFonts.dmSans(fontSize: 10, color: isOpen ? Colors.white.withOpacity(0.5) : (canOpen ? AppColors.accent : AppColors.inkSoft), fontWeight: FontWeight.w500)),
          ),
        ]),
        const SizedBox(height: 12),
        Text(title, style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: isOpen ? AppColors.white : AppColors.ink, fontStyle: FontStyle.italic)),
        const SizedBox(height: 6),
        Row(children: [
          if (photos > 0) ...[
            Icon(Icons.photo_outlined, size: 13, color: isOpen ? Colors.white.withOpacity(0.4) : AppColors.inkSoft),
            const SizedBox(width: 4),
            Text('$photos foto(s)', style: GoogleFonts.dmSans(fontSize: 12, color: isOpen ? Colors.white.withOpacity(0.4) : AppColors.inkSoft)),
            const SizedBox(width: 12),
          ],
          Icon(Icons.help_outline_rounded, size: 13, color: isOpen ? Colors.white.withOpacity(0.4) : AppColors.inkSoft),
          const SizedBox(width: 4),
          Text('$questions resposta(s)', style: GoogleFonts.dmSans(fontSize: 12, color: isOpen ? Colors.white.withOpacity(0.4) : AppColors.inkSoft)),
        ]),
        if (openDate != null) ...[
          const SizedBox(height: 12),
          if (!isOpen) ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: _progress(createdAt, openDate), backgroundColor: const Color(0xFFF0EBE6), valueColor: AlwaysStoppedAnimation<Color>(canOpen ? AppColors.accent : AppColors.inkFaint), minHeight: 4)),
          const SizedBox(height: 8),
          Text(isOpen ? 'Aberta em ${openDate.day}/${openDate.month}/${openDate.year}' : _countdown(openDate), style: GoogleFonts.dmSans(fontSize: 12, color: isOpen ? Colors.white.withOpacity(0.4) : (canOpen ? AppColors.accent : AppColors.inkSoft), fontWeight: FontWeight.w500)),
        ],
        if (canOpen && !isOpen) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CapsuleOpeningScreen(data: data, docId: docId))),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
              child: Text('Abrir Capsula', style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.white)),
            ),
          ),
        ],
      ]),
    );
  }

  Widget _buildLockedCard({required BuildContext context, required Map<String, dynamic> data, required String docId, required DateTime openDate, required DateTime createdAt, required bool canOpen}) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final isReceiver = data['receiverUid'] == uid;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.border), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: canOpen ? AppColors.accentWarm : AppColors.bg, borderRadius: BorderRadius.circular(20)), child: Text(canOpen ? 'Pronta!' : 'Bloqueada', style: GoogleFonts.dmSans(fontSize: 10, color: canOpen ? AppColors.accent : AppColors.inkSoft, fontWeight: FontWeight.w500))),
          const Spacer(),
          Text(isReceiver ? 'De: ${data['senderName'] ?? ''}' : 'Para: ${data['receiverName'] ?? ''}', style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.inkFaint)),
        ]),
        const SizedBox(height: 12),
        Text(data['title'] ?? '', style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: AppColors.ink, fontStyle: FontStyle.italic)),
        const SizedBox(height: 12),
        ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: _progress(createdAt, openDate), backgroundColor: const Color(0xFFF0EBE6), valueColor: AlwaysStoppedAnimation<Color>(canOpen ? AppColors.accent : AppColors.inkFaint), minHeight: 4)),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(_countdown(openDate), style: GoogleFonts.dmSans(fontSize: 12, color: canOpen ? AppColors.accent : AppColors.inkSoft, fontWeight: FontWeight.w500)),
          Text('${openDate.day}/${openDate.month}/${openDate.year}', style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.inkFaint)),
        ]),
        if (canOpen && isReceiver) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LetterOpeningScreen(data: data, docId: docId))),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 8, shadowColor: AppColors.accent.withOpacity(0.4)),
              child: Text('Abrir carta', style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.white, letterSpacing: 0.5)),
            ),
          ),
        ],
      ]),
    );
  }

  Widget _buildOpenedCard({required BuildContext context, required Map<String, dynamic> data, required String docId, required String uid}) {
    final isReceiver = data['receiverUid'] == uid;
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LetterDetailScreen(data: data, docId: docId))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: AppColors.ink.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.08))), child: Text('Carta aberta', style: GoogleFonts.dmSans(fontSize: 10, color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.w500, letterSpacing: 0.5))),
            const Spacer(),
            Text(isReceiver ? 'De: ${data['senderName'] ?? ''}' : 'Para: ${data['receiverName'] ?? ''}', style: GoogleFonts.dmSans(fontSize: 11, color: Colors.white.withOpacity(0.35))),
          ]),
          const SizedBox(height: 12),
          Text(data['title'] ?? '', style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: AppColors.white, fontStyle: FontStyle.italic)),
          const SizedBox(height: 8),
          Text(data['message'] ?? '', maxLines: 3, overflow: TextOverflow.ellipsis, style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white.withOpacity(0.5), height: 1.6)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LetterDetailScreen(data: data, docId: docId))),
              style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.white.withOpacity(0.15)), padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: Text('Ler carta completa', style: GoogleFonts.dmSans(fontSize: 14, color: Colors.white.withOpacity(0.7))),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildEmpty({required String emoji, required String title, required String subtitle}) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(emoji, style: const TextStyle(fontSize: 48)),
      const SizedBox(height: 16),
      Text(title, style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: AppColors.ink, fontStyle: FontStyle.italic)),
      const SizedBox(height: 8),
      Text(subtitle, textAlign: TextAlign.center, style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.inkSoft, height: 1.6)),
    ]));
  }

  Widget _buildEmptyCapsules(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('⏳', style: TextStyle(fontSize: 48)),
      const SizedBox(height: 16),
      Text('Nenhuma capsula ainda', style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: AppColors.ink, fontStyle: FontStyle.italic)),
      const SizedBox(height: 8),
      Text('Crie sua primeira capsula do tempo\ne guarde memorias para o futuro', textAlign: TextAlign.center, style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.inkSoft, height: 1.6)),
      const SizedBox(height: 24),
      ElevatedButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateCapsuleScreen())),
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), elevation: 0),
        child: Text('Criar Capsula', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
      ),
    ]));
  }
}
