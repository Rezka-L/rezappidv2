import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'splash_screen.dart';
import 'login_page.dart';
import 'username_page.dart';
import 'home_page.dart';

void main() {
  runApp(const RezidApp());
}

class RezidApp extends StatelessWidget {
  const RezidApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
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
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF101010),
      ),
    );
  }
}