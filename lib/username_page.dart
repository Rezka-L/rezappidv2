import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UsernamePage extends StatefulWidget {
  const UsernamePage({super.key});

  @override
  State<UsernamePage> createState() => _UsernamePageState();
}

class _UsernamePageState extends State<UsernamePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  String? _errorText;
  bool _isButtonEnabled = false;

  late AnimationController _animationController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _usernameController.addListener(() {
      setState(() {
        _isButtonEnabled = _usernameController.text.trim().isNotEmpty;
        _errorText = null;
      });
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.4, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _submit() {
    final username = _usernameController.text.trim();
    if (username.isEmpty) {
      setState(() => _errorText = 'Masukkan username dulu ya');
    } else if (username.length < 3) {
      setState(() => _errorText = 'Minimal 3 karakter');
    } else if (username.contains(' ')) {
      setState(() => _errorText = 'Tidak boleh ada spasi');
    } else {
      context.go('/home', extra: username);
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF0F0F0F);
    const accentColor = Colors.blueAccent;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // â¨ Animated glowing effect
          Positioned(
            top: -100,
            left: -100,
            child: AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) => Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.blueAccent.withOpacity(_glowAnimation.value * 0.3),
                      Colors.transparent,
                    ],
                    radius: 0.8,
                  ),
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'logo',
                      child: Icon(
                        Icons.videogame_asset_rounded,
                        size: 70,
                        color: Colors.blueAccent.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Hello there!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Enter your username to start',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 36),

                    // TextField
                    TextField(
                      controller: _usernameController,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: const TextStyle(color: Colors.grey),
                        errorText: _errorText,
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      onSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: 40),

                    // Continue button
                    AnimatedOpacity(
                      opacity: _isButtonEnabled ? 1 : 0.4,
                      duration: const Duration(milliseconds: 300),
                      child: Hero(
                        tag: 'continue',
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isButtonEnabled ? _submit : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 6,
                            ),
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
    }