import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'splash_screen.dart';
import 'login_page.dart';
import 'username_page.dart';
import 'home_page.dart';
import 'topup_page.dart';
import 'models/game.dart'; // import class Game dan const games
import 'firebase_options.dart'; // jangan lupa generate via flutterfire configure

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const RezidApp());
}

class RezidApp extends StatefulWidget {
  const RezidApp({super.key});

  @override
  State<RezidApp> createState() => _RezidAppState();
}

class _RezidAppState extends State<RezidApp> {
  DateTime? _lastBackPressed;
  late final GoRouter router;

  final List<Game> gameList = games;

  @override
  void initState() {
    super.initState();

    router = GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/username',
          builder: (context, state) => const UsernamePage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) {
            final username = state.extra as String?;
            return HomePage(username: username ?? 'Guest');
          },
        ),
        GoRoute(
          path: '/topup/:gameId',
          builder: (context, state) {
            final gameId = state.pathParameters['gameId'];
            Game? selectedGame;
            try {
              selectedGame = gameList.firstWhere((g) => g.id == gameId);
            } catch (e) {
              selectedGame = null;
            }
            if (selectedGame == null) {
              return const Scaffold(
                body: Center(child: Text('Game tidak ditemukan')),
              );
            }
            return TopUpPage(game: selectedGame);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF101010),
      ),
      builder: (context, child) {
        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, resultSetter) async {
            final currentLocation =
                router.routerDelegate.currentConfiguration.uri.toString();
            if (currentLocation != '/home') {
              router.go('/home');
              if (resultSetter != null) {
                (resultSetter as void Function(bool))(false);
              }
              return;
            }

            if (_lastBackPressed == null ||
                DateTime.now().difference(_lastBackPressed!) >
                    const Duration(seconds: 2)) {
              _lastBackPressed = DateTime.now();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tekan sekali lagi untuk keluar aplikasi'),
                ),
              );
              if (resultSetter != null) {
                (resultSetter as void Function(bool))(false);
              }
              return;
            }

            if (resultSetter != null) {
              (resultSetter as void Function(bool))(true);
            }
          },
          child: child!,
        );
      },
    );
  }

  Future<void> _onWillPop() async {
    final router = GoRouter.of(context);
    if (router.routerDelegate.currentConfiguration.uri.toString() != '/home') {
      router.go('/home');
      return;
    }

    if (_lastBackPressed == null ||
        DateTime.now().difference(_lastBackPressed!) >
            const Duration(seconds: 2)) {
      _lastBackPressed = DateTime.now();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tekan sekali lagi untuk keluar aplikasi')),
      );
      return;
    }
  }
}