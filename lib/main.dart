import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

bool _onboardingShown = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await NotificationService.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenWhen',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
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
      error: (e, _) => Scaffold(body: Center(child: Text('Erro: $e'))),
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFFF7F4F0),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFC4BFB9), borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          ListTile(
            leading: Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFFF0EAE4), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.mail_outline_rounded, color: Color(0xFFC0392B))),
            title: const Text('Escrever Carta', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('Para alguem especial'),
            onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const WriteLetterScreen())); },
          ),
          ListTile(
            leading: Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFFF0EAE4), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.hourglass_empty_rounded, color: Color(0xFFC0392B))),
            title: const Text('Nova Capsula do Tempo', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('Para voce mesmo ou um grupo'),
            onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateCapsuleScreen())); },
          ),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('letters')
          .where('receiverUid', isEqualTo: uid)
          .where('status', isEqualTo: 'locked')
          .snapshots(),
      builder: (context, lettersSnap) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('capsules')
              .where('senderUid', isEqualTo: uid)
              .where('status', isEqualTo: 'locked')
              .snapshots(),
          builder: (context, capsulesSnap) {
            final lettersCount = lettersSnap.data?.docs.length ?? 0;
            final capsulesCount = capsulesSnap.data?.docs.length ?? 0;
            final totalCount = lettersCount + capsulesCount;

            return Scaffold(
              backgroundColor: AppColors.bg,
              body: _screens[_currentIndex],
              floatingActionButton: FloatingActionButton(
                onPressed: () => _showCreateOptions(context),
                child: const Icon(Icons.edit_outlined),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
              bottomNavigationBar: Container(
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: BottomNavigationBar(
                  currentIndex: _currentIndex,
                  onTap: (i) {
                    if (i == 1) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen()));
                      return;
                    }
                    setState(() => _currentIndex = i == 2 ? 1 : i == 3 ? 2 : i);
                  },
                  items: [
                    const BottomNavigationBarItem(icon: Icon(Icons.auto_awesome_outlined), activeIcon: Icon(Icons.auto_awesome), label: 'Feed'),
                    const BottomNavigationBarItem(icon: Icon(Icons.search), activeIcon: Icon(Icons.search), label: 'Buscar'),
                    BottomNavigationBarItem(
                      label: 'Cofre',
                      icon: _buildBadgeIcon(Icons.lock_outline, totalCount),
                      activeIcon: _buildBadgeIcon(Icons.lock, totalCount),
                    ),
                    const BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Perfil'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBadgeIcon(IconData icon, int count) {
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
              decoration: const BoxDecoration(
                color: Color(0xFFC0392B),
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
