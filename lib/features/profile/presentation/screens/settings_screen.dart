import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../shared/theme/app_theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../shared/widgets/owl_watermark.dart';
import '../../../../shared/widgets/owl_feedback_affordance.dart';
import 'legal_screen.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/avatar_upload_helper.dart';
import '../../../../core/export/complete_export_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/theme_provider.dart';
import '../../../../shared/locale/locale_provider.dart';
import '../../../../core/billing/subscription_tier.dart';
import '../../../../core/billing/subscription_tier_provider.dart';
import '../../../../core/billing/tier_guard.dart';
import '../../../../core/admin/admin_claims.dart';
import '../../../admin/presentation/admin_moderation_screen.dart';
import 'moderation_notifications_screen.dart';
import 'subscription_plans_screen.dart';
import '../../../../core/services/account_deletion_service.dart';
import '../../../../core/services/deletion_request_service.dart';
import '../../../../core/services/privacy_log_service.dart';
import '../../../../core/utils/firebase_locale_helper.dart';
import '../widgets/pending_deletion_banner.dart';
import 'privacy_center_screen.dart';
import '../../../../core/consent/analytics_consent_provider.dart';
import '../../../../core/consent/consent_constants.dart';
import '../../../../core/services/processing_restriction_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _user = FirebaseAuth.instance.currentUser;
  bool? _isAdmin;

  @override
  void initState() {
    super.initState();
    _refreshAdminClaim();
  }

  Future<void> _refreshAdminClaim() async {
    final v = await currentUserHasAdminClaim();
    if (mounted) setState(() => _isAdmin = v);
  }

  Future<void> _resetFirstActionGuide(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final l10n = AppLocalizations.of(context)!;
    await FirebaseFirestore.instance
        .collection(FirestoreCollections.users)
        .doc(uid)
        .update({'hasCompletedFirstAction': false});
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.adminResetFirstActionDone)),
      );
    }
  }

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
          final subTier = ref.watch(subscriptionTierProvider).asData?.value ?? SubscriptionTier.free;
          final isPrivate = data?['isPrivate'] ?? false;
          final notifLike = data?['notifLike'] ?? true;
          final notifComment = data?['notifComment'] ?? true;
          final notifFollow = data?['notifFollow'] ?? true;
          final notifLetter = data?['notifLetter'] ?? true;
          final accountStatus = data?['accountStatus'] as String? ?? 'active';
          final isPendingDeletion = accountStatus == 'pending_deletion';
          final isRestricted = accountStatus == 'restricted';
          final deletionScheduledFor = data?['deletionScheduledFor'] as Timestamp?;
          final deletionDaysRemaining = deletionScheduledFor != null
              ? deletionScheduledFor.toDate().difference(DateTime.now()).inDays.clamp(0, 999)
              : 0;

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
                              color: Colors.white.withValues(alpha:0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.arrow_back, size: 18, color: Colors.white.withValues(alpha:0.6)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Row(children: [
                          Text(l10n.settingsTitle, style: GoogleFonts.dmSerifDisplay(fontSize: 22, color: context.pal.white, fontStyle: FontStyle.italic)),
                          const SizedBox(width: 6),
                          const OwlFeedbackAffordance(
                            forDarkHeader: true,
                            child: OwlWatermark(width: 18, height: 22, opacity: 2.2),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [

                    // ── Pending Deletion Banner ──
                    if (isPendingDeletion)
                      PendingDeletionBanner(
                        daysRemaining: deletionDaysRemaining,
                        messageBuilder: (days) => l10n.settingsDeletePendingBanner(days),
                        cancelLabel: l10n.settingsDeleteCancelButton,
                        onCancel: () => _cancelDeletion(context),
                      ),

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

                    _buildSectionTitle(l10n.subscriptionSectionTitle),
                    _buildMenuCard([
                      _buildMenuItem(
                        icon: Icons.workspace_premium_outlined,
                        iconColor: const Color(0xFFD97706),
                        iconBg: const Color(0xFFFEF3C7),
                        label: l10n.subscriptionScreenTitle,
                        subtitle: '${l10n.subscriptionCurrentPlanLabel}: ${tierDisplayName(subTier, l10n)}',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const SubscriptionPlansScreen(),
                          ),
                        ),
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
                    Material(
                      color: context.pal.card,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: context.pal.border),
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            leading: Container(
                              width: 32, height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.notifications_active_outlined, size: 17, color: Color(0xFFF59E0B)),
                            ),
                            title: Text(l10n.settingsNotifSystemAlert, style: GoogleFonts.dmSans(fontSize: 14, color: context.pal.ink)),
                            subtitle: Text(l10n.settingsNotifSystemAlertSubtitle, style: GoogleFonts.dmSans(fontSize: 11, color: context.pal.inkSoft)),
                            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            childrenPadding: const EdgeInsets.only(bottom: 8),
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: TextButton.icon(
                                    onPressed: () async {
                                      await NotificationService.requestPermissionAndSync();
                                      if (!context.mounted) return;
                                      try {
                                        final s = await FirebaseMessaging.instance.getNotificationSettings();
                                        if (!context.mounted) return;
                                        final permL10n = AppLocalizations.of(context)!;
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              permL10n.settingsNotifPermissionStatus(s.authorizationStatus.toString()),
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
                                    icon: Icon(Icons.phonelink_ring_outlined, size: 16, color: context.pal.accent),
                                    label: Text(l10n.settingsNotifSystemAlertSubtitle, style: GoogleFonts.dmSans(fontSize: 12, color: context.pal.accent)),
                                  ),
                                ),
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
                            ],
                          ),
                        ),
                      ),
                    ),

                    _buildSectionTitle(l10n.themeSection),
                    Material(
                      color: context.pal.card,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: context.pal.border),
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            leading: Container(
                              width: 32, height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF2FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.palette_outlined, size: 17, color: Color(0xFF6366F1)),
                            ),
                            title: Text(l10n.themeSection, style: GoogleFonts.dmSans(fontSize: 14, color: context.pal.ink)),
                            subtitle: Text(
                              themeMode == AppThemeMode.system ? l10n.themeSystem
                                : themeMode == AppThemeMode.classic ? l10n.themeClassic
                                : themeMode == AppThemeMode.dark ? l10n.themeDark
                                : themeMode == AppThemeMode.midnight ? l10n.themeMidnight
                                : l10n.themeSepia,
                              style: GoogleFonts.dmSans(fontSize: 11, color: context.pal.inkSoft),
                            ),
                            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            childrenPadding: const EdgeInsets.only(bottom: 8),
                            children: [
                              _buildDivider(),
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
                            ],
                          ),
                        ),
                      ),
                    ),

                    _buildSectionTitle(l10n.languageSection),
                    Material(
                      color: context.pal.card,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: context.pal.border),
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            leading: Container(
                              width: 32, height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF2FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.translate, size: 17, color: Color(0xFF6366F1)),
                            ),
                            title: Text(l10n.languageSection, style: GoogleFonts.dmSans(fontSize: 14, color: context.pal.ink)),
                            subtitle: Text(
                              localePref == AppLocalePreference.system ? l10n.languageSystem
                                : localePref == AppLocalePreference.ptBr ? l10n.languagePt
                                : localePref == AppLocalePreference.en ? l10n.languageEn
                                : l10n.languageEs,
                              style: GoogleFonts.dmSans(fontSize: 11, color: context.pal.inkSoft),
                            ),
                            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            childrenPadding: const EdgeInsets.only(bottom: 8),
                            children: [
                              _buildDivider(),
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
                            ],
                          ),
                        ),
                      ),
                    ),

                    _buildSectionTitle(l10n.settingsDataSection),
                    _buildMenuCard([
                      _buildMenuItem(
                        icon: Icons.download_outlined,
                        iconColor: const Color(0xFF3B82F6),
                        iconBg: const Color(0xFFEFF6FF),
                        label: l10n.settingsExportData,
                        subtitle: l10n.settingsExportDataSubtitle,
                        onTap: () => _showExportDialog(context),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.shield_outlined,
                        iconColor: const Color(0xFF10B981),
                        iconBg: const Color(0xFFECFDF5),
                        label: l10n.privacyCenterTitle,
                        subtitle: l10n.privacyCenterSubtitle,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PrivacyCenterScreen(),
                          ),
                        ),
                      ),
                      if (ref.read(analyticsConsentProvider.notifier).isConsentRequired) ...[
                        _buildDivider(),
                        _buildAnalyticsToggle(context, ref, l10n),
                      ],
                      _buildDivider(),
                      _buildMenuItem(
                        icon: isRestricted ? Icons.lock_open_outlined : Icons.lock_outlined,
                        iconColor: isRestricted ? const Color(0xFFEF9F27) : const Color(0xFF6B7280),
                        iconBg: isRestricted ? const Color(0xFFFAEEDA) : context.pal.bg,
                        label: isRestricted
                            ? l10n.settingsLiftRestriction
                            : l10n.settingsRestrictProcessing,
                        subtitle: isRestricted
                            ? l10n.settingsLiftRestrictionSubtitle
                            : l10n.settingsRestrictProcessingSubtitle,
                        onTap: () => _showRestrictionDialog(context, isRestricted),
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

                    _buildSectionTitle(l10n.moderationNotificationsSection),
                    _buildMenuCard([
                      _buildMenuItem(
                        icon: Icons.mark_chat_unread_outlined,
                        iconColor: const Color(0xFF8B5CF6),
                        iconBg: const Color(0xFFF3E8FF),
                        label: l10n.moderationNotificationsEntry,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ModerationNotificationsScreen()),
                        ),
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

                    if (_isAdmin == true) ...[
                      _buildSectionTitle('Admin'),
                      Material(
                        color: context.pal.card,
                        borderRadius: BorderRadius.circular(16),
                        child: Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            leading: Container(
                              width: 32, height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF2FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.admin_panel_settings_outlined, size: 17, color: Color(0xFF6366F1)),
                            ),
                            title: Text('Admin', style: GoogleFonts.dmSans(fontSize: 14, color: context.pal.ink)),
                            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            childrenPadding: const EdgeInsets.only(bottom: 8),
                            children: [
                              _buildDivider(),
                              _buildMenuItem(
                                icon: Icons.shield_outlined,
                                iconColor: const Color(0xFF6366F1),
                                iconBg: const Color(0xFFEEF2FF),
                                label: l10n.adminEntrySettings,
                                onTap: () async {
                                  await Navigator.push<void>(
                                    context,
                                    MaterialPageRoute(builder: (_) => const AdminModerationScreen()),
                                  );
                                  await _refreshAdminClaim();
                                },
                              ),
                              _buildDivider(),
                              _buildMenuItem(
                                icon: Icons.restart_alt_rounded,
                                iconColor: const Color(0xFFF59E0B),
                                iconBg: const Color(0xFFFEF3C7),
                                label: l10n.adminResetFirstAction,
                                subtitle: l10n.adminResetFirstActionSubtitle,
                                onTap: () => _resetFirstActionGuide(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),

                    Material(
                      color: context.pal.card,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        onTap: () => _signOutAndNavigate(context),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
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

  Future<void> _signOutAndNavigate(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.pal.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.settingsLogoutTitle,
          style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: context.pal.ink, fontStyle: FontStyle.italic),
        ),
        content: Text(
          l10n.settingsLogoutConfirmMessage,
          style: GoogleFonts.dmSans(fontSize: 14, color: context.pal.inkSoft),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.actionCancel, style: GoogleFonts.dmSans(color: context.pal.inkSoft)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.settingsLogoutConfirmButton, style: GoogleFonts.dmSans(color: context.pal.accent, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await ref.read(authNotifierProvider.notifier).signOut();
    if (!context.mounted) return;
    await _handleSignOutResult(context);
  }

  Future<void> _handleSignOutResult(BuildContext context) async {
    if (!context.mounted) return;
    final authAsync = ref.read(authNotifierProvider);
    if (authAsync.hasError) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.errorGeneric(authAsync.error.toString()),
            style: GoogleFonts.dmSans(fontSize: 13),
          ),
        ),
      );
      return;
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
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

  Widget _buildAnalyticsToggle(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final consentStatus = ref.watch(analyticsConsentProvider);
    final isEnabled = consentStatus == AnalyticsConsentStatus.granted;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.analytics_outlined, size: 20, color: const Color(0xFF3B82F6)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settingsAnalyticsToggle,
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: context.pal.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.settingsAnalyticsDescription,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: context.pal.inkSoft,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: isEnabled,
            activeColor: context.pal.accent,
            onChanged: (value) {
              ref.read(analyticsConsentProvider.notifier).setConsent(
                    value ? AnalyticsConsentStatus.granted : AnalyticsConsentStatus.denied,
                  );
            },
          ),
        ],
      ),
    );
  }

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
      builder: (sheetCtx) {
        final bottomInset = MediaQuery.viewInsetsOf(sheetCtx).bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(sheetCtx).height * 0.85),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
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
          ),
        );
      },
    );
  }

  void _showChangePassword(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.pal.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetCtx) {
        final bottomInset = MediaQuery.viewInsetsOf(sheetCtx).bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(sheetCtx).height * 0.85),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
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
                      await applyFirebaseLocale();
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
          ),
        );
      },
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
            const SizedBox(height: 6),
            Text(l10n.settingsExportZipSubtitle,
              style: GoogleFonts.dmSans(fontSize: 12, color: context.pal.inkFaint, height: 1.45)),
            const SizedBox(height: 20),
            _CompleteExportButton(user: _user),
          ],
        ),
      ),
    );
  }

  void _showRestrictionDialog(BuildContext context, bool isCurrentlyRestricted) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          isCurrentlyRestricted
              ? l10n.settingsLiftRestriction
              : l10n.settingsRestrictProcessing,
        ),
        content: Text(
          isCurrentlyRestricted
              ? l10n.settingsLiftRestrictionConfirm
              : l10n.settingsRestrictProcessingConfirm,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.settingsDeleteCancelButton),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                if (isCurrentlyRestricted) {
                  await ProcessingRestrictionService.liftRestriction();
                } else {
                  await ProcessingRestrictionService.restrictProcessing();
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isCurrentlyRestricted
                            ? l10n.settingsLiftRestrictionSuccess
                            : l10n.settingsRestrictProcessingSuccess,
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: Text(
              isCurrentlyRestricted
                  ? l10n.settingsLiftRestriction
                  : l10n.settingsRestrictProcessing,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccount(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: context.pal.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _DeleteAccountSheet(
        l10n: l10n,
        authProvider: AccountDeletionService.currentAuthProvider(),
        onConfirm: (DeletionMode mode) async {
          Navigator.pop(context);
          await _executeAccountDeletion(context, mode);
        },
      ),
    );
  }

  Future<void> _executeAccountDeletion(
    BuildContext context,
    DeletionMode mode,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    // Show loading overlay
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: context.pal.card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: context.pal.accent),
                const SizedBox(height: 16),
                Text(l10n.settingsDeleteProcessing,
                    style: GoogleFonts.dmSans(fontSize: 14, color: context.pal.ink)),
              ],
            ),
          ),
        ),
      ),
    );

    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final provider = AccountDeletionService.currentAuthProvider();
    final modeStr = mode == DeletionMode.deleteAll ? 'delete_all' : 'anonymize';

    try {
      // Request soft deletion (export + 15-day grace period)
      // Re-auth was already done in the bottom sheet before calling onConfirm.
      final scheduledFor = await AccountDeletionService.requestSoftDeletion(mode);

      // Audit log (best-effort)
      PrivacyLogService.logDeletionRequest(
        uid: uid,
        mode: modeStr,
        authProvider: provider.name,
        success: true,
      );

      // Sign out locally
      if (!context.mounted) return;
      Navigator.pop(context); // dismiss loading

      // Show confirmation with scheduled date
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.settingsDeleteScheduled(scheduledFor.day, scheduledFor.month, scheduledFor.year)),
            duration: const Duration(seconds: 5),
          ),
        );
      }

      await ref.read(authNotifierProvider.notifier).signOut();
      if (context.mounted) {
        await _handleSignOutResult(context);
      }
    } catch (e, st) {
      debugPrint('Account deletion request failed: $e\n$st');
      PrivacyLogService.logDeletionRequest(
        uid: uid,
        mode: modeStr,
        authProvider: provider.name,
        success: false,
      );
      if (!context.mounted) return;
      Navigator.pop(context); // dismiss loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsDeleteError)),
      );
    }
  }

  Future<void> _cancelDeletion(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    try {
      await DeletionRequestService.cancelDeletion();
      PrivacyLogService.logDeletionCancellation(uid: uid, success: true);
      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(l10n.settingsDeleteCancelled,
                style: GoogleFonts.dmSans(fontSize: 13)),
          ),
        );
      }
    } catch (e) {
      debugPrint('Cancel deletion failed: $e');
      PrivacyLogService.logDeletionCancellation(uid: uid, success: false);
      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(l10n.errorGeneric(e.toString()),
                style: GoogleFonts.dmSans(fontSize: 13)),
          ),
        );
      }
    }
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

// ---------------------------------------------------------------------------
// Delete Account Bottom Sheet — re-auth + deletion mode choice
// ---------------------------------------------------------------------------
class _DeleteAccountSheet extends StatefulWidget {
  const _DeleteAccountSheet({
    required this.l10n,
    required this.onConfirm,
    required this.authProvider,
  });

  final AppLocalizations l10n;
  final AuthProvider authProvider;
  final Future<void> Function(DeletionMode mode) onConfirm;

  @override
  State<_DeleteAccountSheet> createState() => _DeleteAccountSheetState();
}

class _DeleteAccountSheetState extends State<_DeleteAccountSheet> {
  final _passwordCtrl = TextEditingController();
  DeletionMode _mode = DeletionMode.deleteAll;
  bool _confirmed = false;
  bool _showPassword = false;
  bool _reauthenticated = false;
  bool _reauthenticating = false;
  String? _reauthError;

  bool get _isPasswordProvider =>
      widget.authProvider == AuthProvider.password;

  @override
  void dispose() {
    _passwordCtrl.dispose();
    super.dispose();
  }

  bool get _canProceed {
    if (!_confirmed) return false;
    if (_isPasswordProvider) return _passwordCtrl.text.isNotEmpty;
    return _reauthenticated;
  }

  Future<void> _handleSocialReauth() async {
    setState(() {
      _reauthenticating = true;
      _reauthError = null;
    });

    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final providerName = widget.authProvider.name;
    final error = await AccountDeletionService.reauthenticate();

    if (!mounted) return;
    if (error == null) {
      PrivacyLogService.logReauthentication(
        uid: uid, provider: providerName, success: true,
      );
      setState(() {
        _reauthenticated = true;
        _reauthenticating = false;
      });
    } else if (error == 'cancelled') {
      setState(() => _reauthenticating = false);
    } else {
      PrivacyLogService.logReauthentication(
        uid: uid, provider: providerName, success: false,
      );
      setState(() {
        _reauthenticating = false;
        _reauthError = error;
      });
    }
  }

  Future<void> _handleConfirm() async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (_isPasswordProvider) {
      // Re-auth with password first
      final error = await AccountDeletionService.reauthenticateWithPassword(
        _passwordCtrl.text,
      );
      if (!mounted) return;
      if (error != null) {
        PrivacyLogService.logReauthentication(
          uid: uid, provider: 'password', success: false,
        );
        final l10n = widget.l10n;
        final msg = error == 'wrong-password' || error == 'invalid-credential'
            ? l10n.settingsDeleteWrongPassword
            : l10n.settingsDeleteReauthFailed;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
        return;
      }
      PrivacyLogService.logReauthentication(
        uid: uid, provider: 'password', success: true,
      );
    }
    // Social re-auth was already done via _handleSocialReauth
    await widget.onConfirm(_mode);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24, 20, 24,
        MediaQuery.of(context).viewInsets.bottom + 40,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: context.pal.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              l10n.settingsDeleteTitle,
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 20,
                color: const Color(0xFFEF4444),
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 12),

            // Explanation
            Text(
              l10n.settingsDeleteBody,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: context.pal.inkSoft,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),

            // Pending letters warning
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFDBA74)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      size: 20, color: Color(0xFFF59E0B)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.settingsDeletePendingLettersWarning,
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: const Color(0xFF92400E),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Deletion mode choice
            Text(
              l10n.settingsDeleteChoiceTitle,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: context.pal.ink,
              ),
            ),
            const SizedBox(height: 8),

            // Option A: Delete all
            _buildModeOption(
              value: DeletionMode.deleteAll,
              title: l10n.settingsDeleteOptionDeleteAll,
              subtitle: l10n.settingsDeleteOptionDeleteAllDesc,
            ),
            const SizedBox(height: 8),

            // Option B: Anonymize
            _buildModeOption(
              value: DeletionMode.anonymize,
              title: l10n.settingsDeleteOptionAnonymize,
              subtitle: l10n.settingsDeleteOptionAnonymizeDesc,
            ),
            const SizedBox(height: 20),

            // Re-authentication section
            if (_isPasswordProvider) ...[
              // Password field for email/password users
              Text(
                l10n.settingsDeletePasswordLabel,
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  color: context.pal.inkFaint,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: context.pal.bg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: context.pal.border, width: 1.5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                child: Row(
                  children: [
                    Icon(Icons.lock_outline, size: 18,
                        color: context.pal.inkFaint.withValues(alpha:0.6)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _passwordCtrl,
                        obscureText: !_showPassword,
                        onChanged: (_) => setState(() {}),
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          color: context.pal.ink,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: l10n.settingsDeletePasswordHint,
                          hintStyle: GoogleFonts.dmSans(color: context.pal.inkFaint),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _showPassword = !_showPassword),
                      child: Icon(
                        _showPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 18,
                        color: context.pal.inkFaint.withValues(alpha:0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Social re-auth button for Google/Apple users
              Text(
                l10n.settingsDeleteReauthLabel,
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  color: context.pal.inkFaint,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 6),
              if (_reauthenticated)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha:0.3),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha:0.4)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, size: 18, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 10),
                      Text(
                        l10n.settingsDeleteReauthSuccess,
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                )
              else
                OutlinedButton.icon(
                  onPressed: _reauthenticating ? null : _handleSocialReauth,
                  icon: _reauthenticating
                      ? SizedBox(
                          width: 16, height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: context.pal.inkSoft,
                          ),
                        )
                      : Icon(
                          widget.authProvider == AuthProvider.apple
                              ? Icons.apple
                              : Icons.g_mobiledata,
                          size: 20,
                        ),
                  label: Text(
                    widget.authProvider == AuthProvider.apple
                        ? l10n.settingsDeleteReauthApple
                        : l10n.settingsDeleteReauthGoogle,
                    style: GoogleFonts.dmSans(fontSize: 14),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    side: BorderSide(color: context.pal.border, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              if (_reauthError != null) ...[
                const SizedBox(height: 6),
                Text(
                  l10n.settingsDeleteReauthFailed,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: const Color(0xFFEF4444),
                  ),
                ),
              ],
            ],
            const SizedBox(height: 16),

            // Confirmation checkbox
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _confirmed,
                    onChanged: (v) => setState(() => _confirmed = v ?? false),
                    activeColor: const Color(0xFFEF4444),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _confirmed = !_confirmed),
                    child: Text(
                      l10n.settingsDeleteIrreversibleConfirm,
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: context.pal.inkSoft,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Confirm button
            ElevatedButton(
              onPressed: _canProceed ? _handleConfirm : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                disabledBackgroundColor:
                    const Color(0xFFEF4444).withValues(alpha:0.3),
              ),
              child: Text(
                l10n.settingsDeleteConfirm,
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Cancel button
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                l10n.actionCancel,
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  color: context.pal.inkSoft,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeOption({
    required DeletionMode value,
    required String title,
    required String subtitle,
  }) {
    final selected = _mode == value;
    return GestureDetector(
      onTap: () => setState(() => _mode = value),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFEF4444).withValues(alpha:0.08)
              : context.pal.bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? const Color(0xFFEF4444).withValues(alpha:0.4)
                : context.pal.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<DeletionMode>(
              value: value,
              groupValue: _mode,
              onChanged: (v) => setState(() => _mode = v!),
              activeColor: const Color(0xFFEF4444),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: context.pal.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      color: context.pal.inkSoft,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Complete Export Button — handles progress feedback within the bottom sheet
// ---------------------------------------------------------------------------
class _CompleteExportButton extends StatefulWidget {
  const _CompleteExportButton({required this.user});
  final User? user;

  @override
  State<_CompleteExportButton> createState() => _CompleteExportButtonState();
}

class _CompleteExportButtonState extends State<_CompleteExportButton> {
  bool _exporting = false;
  String _stage = '';
  double _progress = 0;

  static const _stageLabels = {
    'profile': 'Profile',
    'letters': 'Letters',
    'media': 'Media',
    'capsules': 'Capsules',
    'comments': 'Comments',
    'likes': 'Likes',
    'follows': 'Follows',
    'badges': 'Badges',
    'zip': 'ZIP',
    'done': '',
  };

  Future<void> _runExport() async {
    final uid = widget.user?.uid;
    if (uid == null) return;
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);

    setState(() => _exporting = true);

    try {
      final (:zipFile, :result) = await buildCompleteExportZip(
        firestore: FirebaseFirestore.instance,
        uid: uid,
        onProgress: (stage, progress) {
          if (mounted) setState(() { _stage = stage; _progress = progress; });
        },
      );

      PrivacyLogService.logCompleteExport(
        uid: uid,
        metadata: result.toMetadata(),
        success: true,
      );

      nav.pop();
      await shareCompleteExportZip(zipFile);

      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              l10n.settingsExportCompleteSuccess(result.totalItems, result.mediaFilesCount),
              style: GoogleFonts.dmSans(fontSize: 13),
            ),
          ),
        );
      }
    } catch (e) {
      PrivacyLogService.logCompleteExport(uid: uid, metadata: {}, success: false);
      nav.pop();
      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              l10n.errorGeneric(e.toString()),
              style: GoogleFonts.dmSans(fontSize: 13),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_exporting) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: _progress, minHeight: 4, borderRadius: BorderRadius.circular(2)),
          const SizedBox(height: 10),
          Text(
            '${l10n.settingsExportSnack} ${_stageLabels[_stage] ?? _stage}',
            style: GoogleFonts.dmSans(fontSize: 12, color: context.pal.inkSoft),
          ),
        ],
      );
    }

    return ElevatedButton(
      onPressed: _runExport,
      child: Text(l10n.settingsExportButton, style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500)),
    );
  }
}
