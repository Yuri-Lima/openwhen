import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../shared/theme/app_theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'legal_screen.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/avatar_upload_helper.dart';
import '../../../../core/services/notification_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection(FirestoreCollections.users)
            .doc(_user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          final data = snapshot.data?.data() as Map<String, dynamic>?;
          final isPrivate = data?['isPrivate'] ?? false;
          final notifLike = data?['notifLike'] ?? true;
          final notifComment = data?['notifComment'] ?? true;
          final notifFollow = data?['notifFollow'] ?? true;
          final notifLetter = data?['notifLetter'] ?? true;

          return Column(
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
                        Text('Configurações',
                          style: GoogleFonts.dmSerifDisplay(fontSize: 22, color: AppColors.white, fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                ),
              ),
              // Conteúdo
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [

                    // ── Minha Conta ──
                    _buildSectionTitle('MINHA CONTA'),
                    _buildMenuCard([
                      _buildMenuItem(
                        icon: Icons.photo_camera_outlined,
                        iconColor: const Color(0xFFEC4899),
                        iconBg: const Color(0xFFFCE7F3),
                        label: 'Foto de perfil',
                        subtitle: 'Galeria ou remover',
                        onTap: () {
                          final uid = _user?.uid;
                          if (uid != null) {
                            AvatarUploadHelper.showAvatarOptions(context, uid);
                          }
                        },
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.person_outline,
                        iconColor: const Color(0xFF3B82F6),
                        iconBg: const Color(0xFFEFF6FF),
                        label: 'Editar perfil',
                        onTap: () => _showEditProfile(context, data),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.lock_outline,
                        iconColor: const Color(0xFF8B5CF6),
                        iconBg: const Color(0xFFF5F3FF),
                        label: 'Alterar senha',
                        onTap: () => _showChangePassword(context),
                      ),
                    ]),

                    // ── Privacidade ──
                    _buildSectionTitle('PRIVACIDADE E SEGURANÇA'),
                    _buildMenuCard([
                      _buildToggleItem(
                        icon: isPrivate ? Icons.lock_outline : Icons.public,
                        iconColor: isPrivate ? const Color(0xFFF59E0B) : const Color(0xFF10B981),
                        iconBg: isPrivate ? const Color(0xFFFEF3C7) : const Color(0xFFD1FAE5),
                        label: 'Conta privada',
                        subtitle: isPrivate ? 'Suas cartas não aparecem no feed' : 'Suas cartas podem aparecer no feed',
                        value: isPrivate,
                        onChanged: (v) => _updateField('isPrivate', v),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.block_outlined,
                        iconColor: const Color(0xFFEF4444),
                        iconBg: const Color(0xFFFEF2F2),
                        label: 'Usuários bloqueados',
                        onTap: () => _showBlockedUsers(context),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.mail_outline,
                        iconColor: const Color(0xFF6366F1),
                        iconBg: const Color(0xFFEEF2FF),
                        label: 'Quem pode me enviar cartas',
                        subtitle: 'Todos',
                        onTap: () {},
                        showArrow: true,
                      ),
                    ]),

                    // ── Notificações ──
                    _buildSectionTitle('NOTIFICAÇÕES'),
                    _buildMenuCard([
                      _buildMenuItem(
                        icon: Icons.notifications_active_outlined,
                        iconColor: const Color(0xFFF59E0B),
                        iconBg: const Color(0xFFFEF3C7),
                        label: 'Permissões de alerta (sistema)',
                        subtitle: 'Necessário para receber push no celular',
                        onTap: () async {
                          await NotificationService.requestPermissionAndSync();
                          if (!context.mounted) return;
                          try {
                            final s = await FirebaseMessaging.instance.getNotificationSettings();
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Status: ${s.authorizationStatus}',
                                  style: GoogleFonts.dmSans(fontSize: 13),
                                ),
                              ),
                            );
                          } catch (_) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Permissões de notificação atualizadas.',
                                    style: GoogleFonts.dmSans(fontSize: 13),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                      _buildDivider(),
                      _buildToggleItem(
                        icon: Icons.favorite_outline,
                        iconColor: const Color(0xFFE91E8C),
                        iconBg: const Color(0xFFFCE4F3),
                        label: 'Curtidas',
                        subtitle: 'Quando alguém curtir sua carta',
                        value: notifLike,
                        onChanged: (v) => _updateField('notifLike', v),
                      ),
                      _buildDivider(),
                      _buildToggleItem(
                        icon: Icons.chat_bubble_outline,
                        iconColor: const Color(0xFF3B82F6),
                        iconBg: const Color(0xFFEFF6FF),
                        label: 'Comentários',
                        subtitle: 'Quando alguém comentar sua carta',
                        value: notifComment,
                        onChanged: (v) => _updateField('notifComment', v),
                      ),
                      _buildDivider(),
                      _buildToggleItem(
                        icon: Icons.person_add_outlined,
                        iconColor: const Color(0xFF10B981),
                        iconBg: const Color(0xFFD1FAE5),
                        label: 'Novos seguidores',
                        subtitle: 'Quando alguém começar a te seguir',
                        value: notifFollow,
                        onChanged: (v) => _updateField('notifFollow', v),
                      ),
                      _buildDivider(),
                      _buildToggleItem(
                        icon: Icons.lock_open_outlined,
                        iconColor: const Color(0xFFF59E0B),
                        iconBg: const Color(0xFFFEF3C7),
                        label: 'Carta desbloqueada',
                        subtitle: 'Quando uma carta estiver pronta para abrir',
                        value: notifLetter,
                        onChanged: (v) => _updateField('notifLetter', v),
                      ),
                    ]),

                    // ── Tema ──
                    _buildSectionTitle('TEMA DO APP'),
                    _buildMenuCard([
                      _buildMenuItem(
                        icon: Icons.brightness_auto_outlined,
                        iconColor: const Color(0xFF6366F1),
                        iconBg: const Color(0xFFEEF2FF),
                        label: 'Automático',
                        subtitle: 'Segue o sistema',
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accentWarm,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('Ativo', style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.accent, fontWeight: FontWeight.w500)),
                        ),
                        onTap: () {},
                      ),
                    ]),

                    // ── Idioma ──
                    _buildSectionTitle('IDIOMA'),
                    _buildMenuCard([
                      _buildMenuItem(
                        icon: Icons.language,
                        iconColor: const Color(0xFF10B981),
                        iconBg: const Color(0xFFD1FAE5),
                        label: 'Português',
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accentWarm,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('Ativo', style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.accent, fontWeight: FontWeight.w500)),
                        ),
                        onTap: () {},
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.language,
                        iconColor: AppColors.inkFaint,
                        iconBg: AppColors.bg,
                        label: 'English',
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.bg,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text('Em breve 🌍', style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.inkFaint)),
                        ),
                        onTap: () {},
                      ),
                    ]),

                    // ── Dados ──
                    _buildSectionTitle('DADOS E PRIVACIDADE'),
                    _buildMenuCard([
                      _buildMenuItem(
                        icon: Icons.download_outlined,
                        iconColor: const Color(0xFF3B82F6),
                        iconBg: const Color(0xFFEFF6FF),
                        label: 'Exportar minhas cartas',
                        subtitle: 'PDF ou zip com todas as cartas abertas',
                        onTap: () => _showExportDialog(context),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.delete_outline,
                        iconColor: const Color(0xFFEF4444),
                        iconBg: const Color(0xFFFEF2F2),
                        label: 'Deletar conta',
                        subtitle: 'Esta ação é irreversível',
                        onTap: () => _showDeleteAccount(context),
                        labelColor: const Color(0xFFEF4444),
                      ),
                    ]),

                    // ── Legal ──
                    _buildSectionTitle('LEGAL E SUPORTE'),
                    _buildMenuCard([
                      _buildMenuItem(
                        icon: Icons.description_outlined,
                        iconColor: const Color(0xFF6B7280),
                        iconBg: AppColors.bg,
                        label: 'Termos de uso',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LegalScreen(type: LegalType.terms))),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.privacy_tip_outlined,
                        iconColor: const Color(0xFF6B7280),
                        iconBg: AppColors.bg,
                        label: 'Política de privacidade',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LegalScreen(type: LegalType.privacy))),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.help_outline,
                        iconColor: const Color(0xFF6B7280),
                        iconBg: AppColors.bg,
                        label: 'Ajuda e suporte',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LegalScreen(type: LegalType.help))),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.info_outline,
                        iconColor: const Color(0xFF6B7280),
                        iconBg: AppColors.bg,
                        label: 'Sobre o OpenWhen',
                        subtitle: 'Versão 1.0.0',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LegalScreen(type: LegalType.about))),
                      ),
                    ]),

                    const SizedBox(height: 16),

                    // Botão sair
                    GestureDetector(
                      onTap: () => ref.read(authNotifierProvider.notifier).signOut(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.logout, size: 18, color: AppColors.accent),
                            const SizedBox(width: 8),
                            Text('Sair da conta',
                              style: GoogleFonts.dmSans(fontSize: 15, color: AppColors.accent, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────

  Future<void> _updateField(String field, dynamic value) async {
    await FirebaseFirestore.instance
        .collection(FirestoreCollections.users)
        .doc(_user?.uid)
        .update({field: value});
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
      child: Text(title,
        style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.inkFaint, letterSpacing: 1.5, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() => Divider(height: 1, indent: 56, color: AppColors.border);

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    String? subtitle,
    required VoidCallback onTap,
    Widget? trailing,
    bool showArrow = false,
    Color? labelColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, size: 17, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: GoogleFonts.dmSans(fontSize: 14, color: labelColor ?? AppColors.ink)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.inkFaint)),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing,
            if (showArrow || trailing == null)
              Icon(Icons.chevron_right, size: 18, color: AppColors.inkFaint),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    String? subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 17, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.ink)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.inkFaint)),
                ],
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: AppColors.accent),
        ],
      ),
    );
  }

  // ── Dialogs ──────────────────────────────────────────────

  void _showEditProfile(BuildContext context, Map<String, dynamic>? data) {
    final nameCtrl = TextEditingController(text: data?['name'] ?? '');
    final usernameCtrl = TextEditingController(text: data?['username'] ?? '');
    final bioCtrl = TextEditingController(text: data?['bio'] ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text('Editar perfil', style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: AppColors.ink, fontStyle: FontStyle.italic)),
            const SizedBox(height: 20),
            _buildSheetField(nameCtrl, 'Nome'),
            const SizedBox(height: 12),
            _buildSheetField(usernameCtrl, '@Username'),
            const SizedBox(height: 12),
            _buildSheetField(bioCtrl, 'Bio', maxLines: 3),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _updateField('name', nameCtrl.text.trim());
                await _updateField('username', usernameCtrl.text.trim());
                await _updateField('bio', bioCtrl.text.trim());
                if (context.mounted) Navigator.pop(context);
              },
              child: Text('Salvar', style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePassword(BuildContext context) {
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text('Alterar senha', style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: AppColors.ink, fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            Text('Enviaremos um link para seu email.', style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.inkSoft)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.sendPasswordResetEmail(email: _user?.email ?? '');
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Email enviado para ${_user?.email}', style: GoogleFonts.dmSans(fontSize: 13))),
                  );
                }
              },
              child: Text('Enviar email de redefinição', style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text('Exportar cartas', style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: AppColors.ink, fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            Text('Suas cartas abertas serão exportadas em formato PDF. Isso pode levar alguns minutos.',
              style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.inkSoft, height: 1.5)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Exportação em breve! 📦', style: GoogleFonts.dmSans(fontSize: 13))),
                );
              },
              child: Text('Exportar como PDF', style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccount(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text('Deletar conta', style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: const Color(0xFFEF4444), fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            Text('Esta ação é irreversível. Todas as suas cartas, seguidores e dados serão deletados permanentemente.',
              style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.inkSoft, height: 1.5)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await FirebaseFirestore.instance.collection(FirestoreCollections.users).doc(_user?.uid).delete();
                await _user?.delete();
                if (context.mounted) ref.read(authNotifierProvider.notifier).signOut();
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
              child: Text('Confirmar exclusão', style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white)),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar', style: GoogleFonts.dmSans(fontSize: 15, color: AppColors.inkSoft)),
            ),
          ],
        ),
      ),
    );
  }

  void _showBlockedUsers(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('blocks')
            .where('blockedBy', isEqualTo: _user?.uid)
            .snapshots(),
        builder: (context, snap) {
          final docs = snap.data?.docs ?? [];
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 20),
                Text('Usuários bloqueados', style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: AppColors.ink, fontStyle: FontStyle.italic)),
                const SizedBox(height: 16),
                if (docs.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text('Nenhum usuário bloqueado.', style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.inkSoft), textAlign: TextAlign.center),
                  )
                else
                  ...docs.map((doc) {
                    final d = doc.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(d['blockedUid'] ?? '', style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.ink)),
                      trailing: TextButton(
                        onPressed: () async => await doc.reference.delete(),
                        child: Text('Desbloquear', style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.accent)),
                      ),
                    );
                  }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSheetField(TextEditingController ctrl, String label, {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        style: GoogleFonts.dmSans(color: AppColors.ink),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.dmSans(color: AppColors.inkSoft),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
