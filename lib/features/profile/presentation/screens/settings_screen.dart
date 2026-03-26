import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../shared/theme/app_theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../shared/widgets/owl_watermark.dart';
import 'legal_screen.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/avatar_upload_helper.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/theme_provider.dart';
import '../../../../shared/locale/locale_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _user = FirebaseAuth.instance.currentUser;

  Widget _activePill(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: context.pal.accentWarm,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        l10n.activeLabel,
        style: GoogleFonts.dmSans(
          fontSize: 11,
          color: context.pal.accent,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeModeProvider);
    final localePref = ref.watch(localePreferenceProvider);

    return Scaffold(
      backgroundColor: context.pal.bg,
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
                            ),
                            child: Icon(Icons.arrow_back, size: 18, color: Colors.white.withOpacity(0.6)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Row(children: [Text(l10n.settingsTitle, style: GoogleFonts.dmSerifDisplay(fontSize: 22, color: context.pal.white, fontStyle: FontStyle.italic)), const SizedBox(width: 6), const OwlWatermark(width: 18, height: 22, opacity: 2.2)]),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [

                    _buildSectionTitle(l10n.settingsMyAccount),
                    _buildMenuCard([
                      _buildMenuItem(
                        icon: Icons.photo_camera_outlined,
                        iconColor: const Color(0xFFEC4899),
                        iconBg: const Color(0xFFFCE7F3),
                        label: l10n.settingsProfilePhoto,
                        subtitle: l10n.settingsProfilePhotoSubtitle,
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
                        label: l10n.settingsEditProfile,
                        onTap: () => _showEditProfile(context, data),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.lock_outline,
                        iconColor: const Color(0xFF8B5CF6),
                        iconBg: const Color(0xFFF5F3FF),
                        label: l10n.settingsChangePassword,
                        onTap: () => _showChangePassword(context),
                      ),
                    ]),

                    _buildSectionTitle(l10n.settingsPrivacySection),
                    _buildMenuCard([
                      _buildToggleItem(
                        icon: isPrivate ? Icons.lock_outline : Icons.public,
                        iconColor: isPrivate ? const Color(0xFFF59E0B) : const Color(0xFF10B981),
                        iconBg: isPrivate ? const Color(0xFFFEF3C7) : const Color(0xFFD1FAE5),
                        label: l10n.settingsPrivateAccount,
                        subtitle: isPrivate ? l10n.settingsPrivateAccountOn : l10n.settingsPrivateAccountOff,
                        value: isPrivate,
                        onChanged: (v) => _updateField('isPrivate', v),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.block_outlined,
                        iconColor: const Color(0xFFEF4444),
                        iconBg: const Color(0xFFFEF2F2),
                        label: l10n.settingsBlockedUsers,
                        onTap: () => _showBlockedUsers(context),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.mail_outline,
                        iconColor: const Color(0xFF6366F1),
                        iconBg: const Color(0xFFEEF2FF),
                        label: l10n.settingsWhoCanSend,
                        subtitle: l10n.settingsWhoCanSendValue,
                        onTap: () {},
                        showArrow: true,
                      ),
                    ]),

                    _buildSectionTitle(l10n.settingsNotificationsSection),
                    _buildMenuCard([
                      _buildMenuItem(
                        icon: Icons.notifications_active_outlined,
                        iconColor: const Color(0xFFF59E0B),
                        iconBg: const Color(0xFFFEF3C7),
                        label: l10n.settingsNotifSystemAlert,
                        subtitle: l10n.settingsNotifSystemAlertSubtitle,
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
                              final snackL10n = AppLocalizations.of(context)!;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    snackL10n.settingsNotifUpdated,
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
                        label: l10n.settingsNotifLikes,
                        subtitle: l10n.settingsNotifLikesSubtitle,
                        value: notifLike,
                        onChanged: (v) => _updateField('notifLike', v),
                      ),
                      _buildDivider(),
                      _buildToggleItem(
                        icon: Icons.chat_bubble_outline,
                        iconColor: const Color(0xFF3B82F6),
                        iconBg: const Color(0xFFEFF6FF),
                        label: l10n.settingsNotifComments,
                        subtitle: l10n.settingsNotifCommentsSubtitle,
                        value: notifComment,
                        onChanged: (v) => _updateField('notifComment', v),
                      ),
                      _buildDivider(),
                      _buildToggleItem(
                        icon: Icons.person_add_outlined,
                        iconColor: const Color(0xFF10B981),
                        iconBg: const Color(0xFFD1FAE5),
                        label: l10n.settingsNotifFollowers,
                        subtitle: l10n.settingsNotifFollowersSubtitle,
                        value: notifFollow,
                        onChanged: (v) => _updateField('notifFollow', v),
                      ),
                      _buildDivider(),
                      _buildToggleItem(
                        icon: Icons.lock_open_outlined,
                        iconColor: const Color(0xFFF59E0B),
                        iconBg: const Color(0xFFFEF3C7),
                        label: l10n.settingsNotifLetterUnlocked,
                        subtitle: l10n.settingsNotifLetterUnlockedSubtitle,
                        value: notifLetter,
                        onChanged: (v) => _updateField('notifLetter', v),
                      ),
                    ]),

                    _buildSectionTitle(l10n.themeSection),
                    _buildMenuCard([
                      _buildMenuItem(
                        icon: Icons.brightness_auto_outlined,
                        iconColor: const Color(0xFF6366F1),
                        iconBg: const Color(0xFFEEF2FF),
                        label: l10n.themeSystem,
                        subtitle: l10n.themeSystemSubtitle,
                        trailing: themeMode == AppThemeMode.system ? _activePill(l10n) : null,
                        onTap: () => ref.read(themeModeProvider.notifier).setMode(AppThemeMode.system),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.wb_sunny_outlined,
                        iconColor: const Color(0xFFF59E0B),
                        iconBg: const Color(0xFFFEF3C7),
                        label: l10n.themeClassic,
                        subtitle: l10n.themeClassicSubtitle,
                        trailing: themeMode == AppThemeMode.classic ? _activePill(l10n) : null,
                        onTap: () => ref.read(themeModeProvider.notifier).setMode(AppThemeMode.classic),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.dark_mode_outlined,
                        iconColor: const Color(0xFF64748B),
                        iconBg: const Color(0xFFE2E8F0),
                        label: l10n.themeDark,
                        subtitle: l10n.themeDarkSubtitle,
                        trailing: themeMode == AppThemeMode.dark ? _activePill(l10n) : null,
                        onTap: () => ref.read(themeModeProvider.notifier).setMode(AppThemeMode.dark),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.nights_stay_outlined,
                        iconColor: const Color(0xFF3B82F6),
                        iconBg: const Color(0xFFEFF6FF),
                        label: l10n.themeMidnight,
                        subtitle: l10n.themeMidnightSubtitle,
                        trailing: themeMode == AppThemeMode.midnight ? _activePill(l10n) : null,
                        onTap: () => ref.read(themeModeProvider.notifier).setMode(AppThemeMode.midnight),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.menu_book_outlined,
                        iconColor: const Color(0xFFB8860B),
                        iconBg: const Color(0xFFF5E6D3),
                        label: l10n.themeSepia,
                        subtitle: l10n.themeSepiaSubtitle,
                        trailing: themeMode == AppThemeMode.sepia ? _activePill(l10n) : null,
                        onTap: () => ref.read(themeModeProvider.notifier).setMode(AppThemeMode.sepia),
                      ),
                    ]),

                    _buildSectionTitle(l10n.languageSection),
                    _buildMenuCard([
                      _buildMenuItem(
                        icon: Icons.translate,
                        iconColor: const Color(0xFF6366F1),
                        iconBg: const Color(0xFFEEF2FF),
                        label: l10n.languageSystem,
                        subtitle: l10n.languageSystemSubtitle,
                        trailing: localePref == AppLocalePreference.system ? _activePill(l10n) : null,
                        onTap: () => ref.read(localePreferenceProvider.notifier).setPreference(AppLocalePreference.system),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.flag,
                        iconColor: const Color(0xFF10B981),
                        iconBg: const Color(0xFFD1FAE5),
                        label: l10n.languagePt,
                        trailing: localePref == AppLocalePreference.ptBr ? _activePill(l10n) : null,
                        onTap: () => ref.read(localePreferenceProvider.notifier).setPreference(AppLocalePreference.ptBr),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.flag_outlined,
                        iconColor: const Color(0xFF3B82F6),
                        iconBg: const Color(0xFFEFF6FF),
                        label: l10n.languageEn,
                        trailing: localePref == AppLocalePreference.en ? _activePill(l10n) : null,
                        onTap: () => ref.read(localePreferenceProvider.notifier).setPreference(AppLocalePreference.en),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.flag_outlined,
                        iconColor: const Color(0xFFF59E0B),
                        iconBg: const Color(0xFFFEF3C7),
                        label: l10n.languageEs,
                        trailing: localePref == AppLocalePreference.es ? _activePill(l10n) : null,
                        onTap: () => ref.read(localePreferenceProvider.notifier).setPreference(AppLocalePreference.es),
                      ),
                    ]),

                    _buildSectionTitle(l10n.settingsDataSection),
                    _buildMenuCard([
                      _buildMenuItem(
                        icon: Icons.download_outlined,
                        iconColor: const Color(0xFF3B82F6),
                        iconBg: const Color(0xFFEFF6FF),
                        label: l10n.settingsExportLetters,
                        subtitle: l10n.settingsExportLettersSubtitle,
                        onTap: () => _showExportDialog(context),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.delete_outline,
                        iconColor: const Color(0xFFEF4444),
                        iconBg: const Color(0xFFFEF2F2),
                        label: l10n.settingsDeleteAccount,
                        subtitle: l10n.settingsDeleteAccountSubtitle,
                        onTap: () => _showDeleteAccount(context),
                        labelColor: const Color(0xFFEF4444),
                      ),
                    ]),

                    _buildSectionTitle(l10n.settingsLegalSection),
                    _buildMenuCard([
                      _buildMenuItem(
                        icon: Icons.description_outlined,
                        iconColor: const Color(0xFF6B7280),
                        iconBg: context.pal.bg,
                        label: l10n.settingsTerms,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LegalScreen(type: LegalType.terms))),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.privacy_tip_outlined,
                        iconColor: const Color(0xFF6B7280),
                        iconBg: context.pal.bg,
                        label: l10n.settingsPrivacy,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LegalScreen(type: LegalType.privacy))),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.help_outline,
                        iconColor: const Color(0xFF6B7280),
                        iconBg: context.pal.bg,
                        label: l10n.settingsHelp,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LegalScreen(type: LegalType.help))),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.info_outline,
                        iconColor: const Color(0xFF6B7280),
                        iconBg: context.pal.bg,
                        label: l10n.settingsAbout,
                        subtitle: l10n.settingsAboutVersion,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LegalScreen(type: LegalType.about))),
                      ),
                    ]),

                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: () async {
                        await ref.read(authNotifierProvider.notifier).signOut();
                        if (context.mounted) {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: context.pal.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: context.pal.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout, size: 18, color: context.pal.accent),
                            const SizedBox(width: 8),
                            Text(l10n.settingsLogout,
                              style: GoogleFonts.dmSans(fontSize: 15, color: context.pal.accent, fontWeight: FontWeight.w500)),
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
        style: GoogleFonts.dmSans(fontSize: 10, color: context.pal.inkFaint, letterSpacing: 1.5, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: context.pal.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.pal.border),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() => Divider(height: 1, indent: 56, color: context.pal.border);

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
                  Text(label, style: GoogleFonts.dmSans(fontSize: 14, color: labelColor ?? context.pal.ink)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: GoogleFonts.dmSans(fontSize: 11, color: context.pal.inkSoft)),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing,
            if (showArrow || trailing == null)
              Icon(Icons.chevron_right, size: 18, color: context.pal.inkFaint),
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
                Text(label, style: GoogleFonts.dmSans(fontSize: 14, color: context.pal.ink)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle, style: GoogleFonts.dmSans(fontSize: 11, color: context.pal.inkSoft)),
                ],
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: context.pal.accent),
        ],
      ),
    );
  }

  void _showEditProfile(BuildContext context, Map<String, dynamic>? data) {
    final l10n = AppLocalizations.of(context)!;
    final nameCtrl = TextEditingController(text: data?['name'] ?? '');
    final usernameCtrl = TextEditingController(text: data?['username'] ?? '');
    final bioCtrl = TextEditingController(text: data?['bio'] ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.pal.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: context.pal.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text(l10n.settingsEditProfileSheetTitle, style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: context.pal.ink, fontStyle: FontStyle.italic)),
            const SizedBox(height: 20),
            _buildSheetField(nameCtrl, l10n.settingsEditProfileFieldName),
            const SizedBox(height: 12),
            _buildSheetField(usernameCtrl, l10n.settingsEditProfileFieldUsername),
            const SizedBox(height: 12),
            _buildSheetField(bioCtrl, l10n.settingsEditProfileFieldBio, maxLines: 3),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _updateField('name', nameCtrl.text.trim());
                await _updateField('username', usernameCtrl.text.trim());
                await _updateField('bio', bioCtrl.text.trim());
                if (context.mounted) Navigator.pop(context);
              },
              child: Text(l10n.actionSave, style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePassword(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.pal.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: context.pal.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text(l10n.settingsChangePasswordTitle, style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: context.pal.ink, fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            Text(l10n.settingsChangePasswordBody, style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.sendPasswordResetEmail(email: _user?.email ?? '');
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.settingsChangePasswordSent(_user?.email ?? ''), style: GoogleFonts.dmSans(fontSize: 13))),
                  );
                }
              },
              child: Text(l10n.settingsChangePasswordButton, style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: context.pal.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: context.pal.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text(l10n.settingsExportTitle, style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: context.pal.ink, fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            Text(l10n.settingsExportBody,
              style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft, height: 1.5)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.settingsExportSnack, style: GoogleFonts.dmSans(fontSize: 13))),
                );
              },
              child: Text(l10n.settingsExportButton, style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccount(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: context.pal.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: context.pal.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text(l10n.settingsDeleteTitle, style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: const Color(0xFFEF4444), fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            Text(l10n.settingsDeleteBody,
              style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft, height: 1.5)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await FirebaseFirestore.instance.collection(FirestoreCollections.users).doc(_user?.uid).delete();
                await _user?.delete();
                if (context.mounted) {
                  await ref.read(authNotifierProvider.notifier).signOut();
                  if (context.mounted) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
              child: Text(l10n.settingsDeleteConfirm, style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white)),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.actionCancel, style: GoogleFonts.dmSans(fontSize: 15, color: context.pal.inkSoft)),
            ),
          ],
        ),
      ),
    );
  }

  void _showBlockedUsers(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: context.pal.card,
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
                Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: context.pal.border, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 20),
                Text(l10n.settingsBlockedTitle, style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: context.pal.ink, fontStyle: FontStyle.italic)),
                const SizedBox(height: 16),
                if (docs.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(l10n.settingsBlockedEmpty, style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft), textAlign: TextAlign.center),
                  )
                else
                  ...docs.map((doc) {
                    final d = doc.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(d['blockedUid'] ?? '', style: GoogleFonts.dmSans(fontSize: 14, color: context.pal.ink)),
                      trailing: TextButton(
                        onPressed: () async => await doc.reference.delete(),
                        child: Text(l10n.settingsBlockedUnblock, style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.accent)),
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
        color: context.pal.bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.pal.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        style: GoogleFonts.dmSans(color: context.pal.ink),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.dmSans(color: context.pal.inkSoft),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
