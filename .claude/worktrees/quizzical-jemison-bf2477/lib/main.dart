import 'dart:io' show Platform;
import 'dart:ui' show PlatformDispatcher;

import 'package:audio_session/audio_session.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode, kIsWeb, kReleaseMode;
import 'package:flutter/services.dart' show MissingPluginException;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'l10n/app_localizations.dart';
import 'shared/locale/locale_provider.dart';
import 'core/constants/firestore_collections.dart';
import 'core/services/notification_service.dart';
import 'core/services/analytics_service.dart';
import 'firebase_options.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/auth/presentation/screens/splash_screen.dart';
import 'features/auth/presentation/screens/onboarding_screen.dart';
import 'features/auth/presentation/screens/first_action_guide_screen.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/letters/presentation/screens/vault_screen.dart';
import 'features/feed/presentation/screens/feed_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/capsules/data/capsule_vault_streams.dart';
import 'core/linking/deep_link_bootstrap.dart';
import 'core/linking/deep_link_coordinator.dart';
import 'core/navigation/app_navigator_key.dart';
import 'core/navigation/deferred_screens.dart';
import 'shared/theme/app_theme.dart';
import 'shared/theme/theme_provider.dart';
import 'shared/widgets/feedback_entry_button.dart';
import 'shared/widgets/keyboard_dismiss_overlay_button.dart';
import 'core/navigation/home_tab_provider.dart';

bool _onboardingShown = false;
bool _firstActionGuideDone = false;

/// Best-effort: improves playback on iOS/Android; not available on web and may
/// throw [MissingPluginException] after hot restart until a full rebuild.
Future<void> _configureAudioSession() async {
  if (kIsWeb) return;
  try {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
  } on MissingPluginException catch (e) {
    debugPrint('AudioSession skipped (no platform implementation): $e');
  } catch (e, st) {
    debugPrint('AudioSession.configure failed: $e\n$st');
  }
}

Future<void> _activateAppCheckIfNeeded() async {
  if (kIsWeb) return;
  // Skip App Check on iOS: Firebase iOS SDK 12.9.0 has a Swift Concurrency
  // deadlock bug (firebase-ios-sdk#15974) that can hang the entire app at
  // startup when DeviceCheck/AppAttest tokens are fetched asynchronously.
  // Re-enable once FlutterFire ships Firebase iOS SDK >= 12.12.0.
  if (!kIsWeb && Platform.isIOS) {
    debugPrint('[AppCheck] Skipped on iOS (SDK deadlock workaround)');
    return;
  }
  try {
    await FirebaseAppCheck.instance.activate(
      androidProvider:
          kReleaseMode ? AndroidProvider.playIntegrity : AndroidProvider.debug,
      appleProvider:
          kReleaseMode ? AppleProvider.deviceCheck : AppleProvider.debug,
    );
  } catch (e, st) {
    debugPrint('Firebase App Check activate failed (non-fatal): $e\n$st');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAudioSession();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // --- Crashlytics: capture all Flutter & Dart errors ---
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await _activateAppCheckIfNeeded();

  try {
    await initDeepLinks();
  } catch (e, st) {
    debugPrint('[DeepLink] init failed (non-fatal): $e\n$st');
    FirebaseCrashlytics.instance.recordError(e, st);
  }

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // FCM + listeners nativos no iOS: inicializar após o primeiro frame evita
  // EXC_BAD_ACCESS / corrida entre JIT (debug em device) e o bridge nativo.
  runApp(
    ProviderScope(
      child: _PostFrameNotificationInit(child: const MyApp()),
    ),
  );
}

/// Agenda [NotificationService.init] após o primeiro frame (ver doc em [main]).
class _PostFrameNotificationInit extends StatefulWidget {
  const _PostFrameNotificationInit({required this.child});

  final Widget child;

  @override
  State<_PostFrameNotificationInit> createState() =>
      _PostFrameNotificationInitState();
}

class _PostFrameNotificationInitState extends State<_PostFrameNotificationInit> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      try {
        await NotificationService.init();
      } catch (e, st) {
        debugPrint('[Notifications] init failed (non-fatal): $e\n$st');
        FirebaseCrashlytics.instance.recordError(e, st);
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(themeModeProvider);
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final palette = resolvePalette(mode, brightness);
    final localePref = ref.watch(localePreferenceProvider);
    final platformLocale =
        WidgetsBinding.instance.platformDispatcher.locale;
    final appLocale = resolveAppLocale(localePref, platformLocale);

    // Logged-in users get feedback next to each owl; global FAB only when signed out.
    final hideGlobalFeedbackFab = ref.watch(authStateProvider).maybeWhen(
      data: (user) => user != null,
      orElse: () => false,
    );

    return MaterialApp(
      navigatorObservers: [AnalyticsService.observer],
      navigatorKey: rootNavigatorKey,
      title: 'Whenote',
      debugShowCheckedModeBanner: false,
      locale: appLocale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.themeFromPalette(palette),
      builder: (context, child) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            child ?? const SizedBox.shrink(),
            if (!hideGlobalFeedbackFab)
              Positioned(
                top: 0,
                right: 0,
                child: SafeArea(
                  minimum: const EdgeInsets.only(top: 8, right: 8),
                  child: FeedbackEntryButton(navigatorKey: rootNavigatorKey),
                ),
              ),
            const KeyboardDismissOverlayButton(),
          ],
        );
      },
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/write': (context) => const DeferredWriteLetterPage(),
        '/search': (context) => const DeferredSearchPage(),
        '/create-capsule': (context) => const DeferredCreateCapsulePage(),
      },
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});

  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  bool _showSplash = true;
  bool _authTimedOut = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showSplash = false);
    });
    // Safety net: if auth stream never emits (native SDK deadlock on iOS),
    // force past the splash after 8 seconds so the user isn't stuck forever.
    Future.delayed(const Duration(seconds: 8), () {
      if (!mounted) return;
      final isStillLoading = ref.read(authStateProvider).isLoading;
      if (isStillLoading) {
        debugPrint('[AuthWrapper] Auth stream timed out — forcing login screen');
        setState(() => _authTimedOut = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) return const SplashScreen();

    // If auth stream deadlocked (iOS SDK bug), show login instead of infinite splash.
    if (_authTimedOut) {
      if (!_onboardingShown) {
        return OnboardingScreen(onFinish: () {
          _onboardingShown = true;
          if (mounted) setState(() {});
        });
      }
      return const LoginScreen();
    }

    final authState = ref.watch(authStateProvider);
    return authState.when(
      data: (user) {
        if (user != null) {
          // Already completed the first-action guide this session → skip check.
          if (_firstActionGuideDone) return const HomeScreen();

          // Check Firestore flag once; defaults to true for existing users.
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection(FirestoreCollections.users)
                .doc(user.uid)
                .snapshots(),
            builder: (context, snap) {
              if (!snap.hasData) return const SplashScreen();
              final data = snap.data?.data() as Map<String, dynamic>?;
              final completed = data?['hasCompletedFirstAction'] as bool? ?? true;
              if (completed) {
                // Cache so we don't re-check every rebuild.
                _firstActionGuideDone = true;
                return const HomeScreen();
              }
              return FirstActionGuideScreen(
                onComplete: () {
                  _firstActionGuideDone = true;
                  if (mounted) setState(() {});
                },
              );
            },
          );
        }
        if (!_onboardingShown) {
          return OnboardingScreen(onFinish: () {
            _onboardingShown = true;
            if (mounted) setState(() {});
          });
        }
        return const LoginScreen();
      },
      loading: () => const SplashScreen(),
      error: (e, _) {
        final l10n = AppLocalizations.of(context)!;
        return Scaffold(body: Center(child: Text(l10n.errorGeneric(e.toString()))));
      },
    );
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  final List<Widget> _screens = [
    const FeedScreen(),
    const VaultScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      try {
        await DeepLinkCoordinator.handlePendingAfterSignIn(context);
      } catch (e, st) {
        debugPrint('DeepLinkCoordinator error (non-fatal): $e\n$st');
      }
      // NOTE: billing migration (migrateUserBillingDefaults) must NOT run at
      // startup — the HTTPSCallable crashes the native iOS SDK even through
      // CallableQueue. Runs lazily in SubscriptionPlansScreen instead.
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshEmailVerifiedStatus();
    }
  }

  Future<void> _refreshEmailVerifiedStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.emailVerified) return;
    try {
      await user.reload();
    } catch (_) {}
    ref.invalidate(authStateProvider);
  }

  void _showCreateOptions(BuildContext context) {
    final p = context.pal;
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: p.bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: p.inkFaint,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: p.accentWarm,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.mail_outline_rounded, color: p.accent),
            ),
            title: Text(l10n.homeWriteLetter,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(l10n.homeWriteLetterSubtitle),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.push(
                ctx,
                MaterialPageRoute(
                    builder: (_) => const DeferredWriteLetterPage()),
              );
            },
          ),
          ListTile(
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: p.accentWarm,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.hourglass_empty_rounded, color: p.accent),
            ),
            title: Text(l10n.homeNewCapsule,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(l10n.homeNewCapsuleSubtitle),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.push(
                ctx,
                MaterialPageRoute(
                    builder: (_) => const DeferredCreateCapsulePage()),
              );
            },
          ),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final p = context.pal;
    final l10n = AppLocalizations.of(context)!;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(FirestoreCollections.letters)
          .where('receiverUid', isEqualTo: uid)
          .where('status', isEqualTo: 'locked')
          .snapshots(),
      builder: (context, lettersSnap) {
        if (lettersSnap.hasError) {
          debugPrint('Letters stream error: ${lettersSnap.error}');
        }
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: lockedCapsulesSenderStream(uid),
          builder: (context, capSenderSnap) {
            if (capSenderSnap.hasError) {
              debugPrint('Capsules sender stream error: ${capSenderSnap.error}');
            }
            return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: lockedCapsulesCollectiveParticipantStream(uid),
              builder: (context, capParticipantSnap) {
                if (capParticipantSnap.hasError) {
                  debugPrint('Capsules collective stream error: ${capParticipantSnap.error}');
                }
                final lettersCount = lettersSnap.data?.docs.length ?? 0;
                final mergedCaps = mergeLockedCapsuleVaultDocs(
                  capSenderSnap.data,
                  capParticipantSnap.data,
                );
                final capsulesCount = mergedCaps.length;
                final totalCount = lettersCount + capsulesCount;
                final tabIndex = ref.watch(homeTabIndexProvider);

                return Scaffold(
              backgroundColor: p.bg,
              body: _screens[tabIndex],
              floatingActionButton: FloatingActionButton(
                onPressed: () => _showCreateOptions(context),
                child: const Icon(Icons.edit_outlined),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: p.border)),
                ),
                child: BottomNavigationBar(
                  currentIndex: tabIndex == 0 ? 0 : tabIndex == 1 ? 2 : 3,
                  onTap: (i) {
                    if (i == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DeferredSearchPage()),
                      );
                      return;
                    }
                    ref.read(homeTabIndexProvider.notifier).setTab(
                          i == 2 ? 1 : i == 3 ? 2 : 0,
                        );
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.auto_awesome_outlined),
                      activeIcon: const Icon(Icons.auto_awesome),
                      label: l10n.navFeed,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.search),
                      activeIcon: const Icon(Icons.search),
                      label: l10n.navSearch,
                    ),
                    BottomNavigationBarItem(
                      label: l10n.navVault,
                      icon: _buildBadgeIcon(context, Icons.lock_outline, totalCount),
                      activeIcon:
                          _buildBadgeIcon(context, Icons.lock, totalCount),
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.person_outline),
                      activeIcon: const Icon(Icons.person),
                      label: l10n.navProfile,
                    ),
                  ],
                ),
              ),
            );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildBadgeIcon(BuildContext context, IconData icon, int count) {
    final accent = context.pal.accent;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        if (count > 0)
          Positioned(
            top: -4,
            right: -8,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: accent,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
