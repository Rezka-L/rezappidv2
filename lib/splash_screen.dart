import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoCtrl;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;

  late AnimationController _bgCtrl;
  late Animation<Color?> _bgColor1;
  late Animation<Color?> _bgColor2;

  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Background gradient animasi controller
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _bgColor1 = ColorTween(
      begin: const Color(0xFF0D0D0D),
      end: Colors.blueAccent.shade700,
    ).animate(CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut));

    _bgColor2 = ColorTween(
      begin: const Color(0xFF1F1F1F),
      end: Colors.blue.shade900,
    ).animate(CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut));

    // Logo animasi controller
    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _logoScale = Tween<double>(begin: 0.7, end: 1.1).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOutBack),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.easeIn),
    );

    _logoCtrl.forward();

    // Setelah splash 4 detik lanjut ke login
    _timer = Timer(const Duration(seconds: 5), () {
      context.go('/login');
    });
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _bgCtrl.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bgCtrl,
      builder: (context, child) {
        return Scaffold(
          body: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_bgColor1.value ?? Colors.black, _bgColor2.value ?? Colors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FadeTransition(
                      opacity: _logoOpacity,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: const Text(
                          'Rezid',
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 5,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 15,
                                color: Colors.blueAccent,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const LoadingDotsModern(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class LoadingDotsModern extends StatefulWidget {
  const LoadingDotsModern({super.key});

  @override
  State<LoadingDotsModern> createState() => _LoadingDotsModernState();
}

class _LoadingDotsModernState extends State<LoadingDotsModern> with SingleTickerProviderStateMixin {
  late AnimationController _dotsCtrl;
  late Animation<int> _dotCount;

  @override
  void initState() {
    super.initState();
    _dotsCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _dotCount = StepTween(begin: 0, end: 3).animate(_dotsCtrl);
    _dotsCtrl.repeat();
  }

  @override
  void dispose() {
    _dotsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _dotCount,
      builder: (context, child) {
        String dots = '.' * _dotCount.value;
        return Text(
          'Loading$dots',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            foreground: Paint()
              ..shader = const LinearGradient(
             colors: [Color.fromARGB(255, 50, 52, 56), Color.fromARGB(255, 50, 52, 53)],
              ).createShader(const Rect.fromLTWH(0, 0, 80, 20)),
          ),
        );
      },
    );
  }
}