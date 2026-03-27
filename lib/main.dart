import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'l10n/app_localizations.dart';
import 'shared/locale/locale_provider.dart';
import 'core/constants/firestore_collections.dart';
import 'core/services/notification_service.dart';
import 'firebase_options.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/auth/presentation/screens/splash_screen.dart';
import 'features/auth/presentation/screens/onboarding_screen.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/letters/presentation/screens/write_letter_screen.dart';
import 'features/letters/presentation/screens/vault_screen.dart';
import 'features/feed/presentation/screens/feed_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/profile/presentation/screens/search_screen.dart';
import 'features/capsules/presentation/screens/create_capsule_screen.dart';
import 'shared/theme/app_theme.dart';
import 'shared/theme/theme_provider.dart';
import 'shared/widgets/feedback_entry_button.dart';

bool _onboardingShown = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await NotificationService.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> _appNavigatorKey = GlobalKey<NavigatorState>();

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
      navigatorKey: _appNavigatorKey,
      title: 'OpenWhen',
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
                  child: FeedbackEntryButton(navigatorKey: _appNavigatorKey),
                ),
              ),
          ],
        );
      },
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/write': (context) => const WriteLetterScreen(),
        '/search': (context) => const SearchScreen(),
        '/create-capsule': (context) => const CreateCapsuleScreen(),
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

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showSplash = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) return const SplashScreen();
    final authState = ref.watch(authStateProvider);
    return authState.when(
      data: (user) {
        if (user != null) return const HomeScreen();
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

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const FeedScreen(),
    const VaultScreen(),
    const ProfileScreen(),
  ];

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
                    builder: (_) => const WriteLetterScreen()),
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
                    builder: (_) => const CreateCapsuleScreen()),
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
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(FirestoreCollections.capsules)
              .where('senderUid', isEqualTo: uid)
              .where('status', isEqualTo: 'locked')
              .snapshots(),
          builder: (context, capsulesSnap) {
            final lettersCount = lettersSnap.data?.docs.length ?? 0;
            final capsulesCount = capsulesSnap.data?.docs.length ?? 0;
            final totalCount = lettersCount + capsulesCount;

            return Scaffold(
              backgroundColor: p.bg,
              body: _screens[_currentIndex],
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
                  currentIndex: _currentIndex == 0 ? 0 : _currentIndex == 1 ? 2 : 3,
                  onTap: (i) {
                    if (i == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SearchScreen()),
                      );
                      return;
                    }
                    setState(() => _currentIndex = i == 2 ? 1 : i == 3 ? 2 : i);
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
