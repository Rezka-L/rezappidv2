import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rezappid/models/game.dart'; // sesuaikan path kamu

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _sliderTimer;
  int _currentGradientIndex = 0;

  final List<List<Color>> gradients = [
    [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
    [Color(0xFF1e3c72), Color(0xFF2a5298)],
    [Color(0xFF232526), Color(0xFF414345)],
    [Color(0xFF0f0c29), Color(0xFF302b63), Color(0xFF24243e)],
  ];

  final List<String> sliderTexts = [
    'Promo diamond ML murah!',
    'Top up FF bonus cashback!',
    'Diskon PUBG hari ini aja!',
    'Voucher game terlengkap!',
  ];

  @override
  void initState() {
    super.initState();
    _startSliderTimer();
  }

  void _startSliderTimer() {
    _sliderTimer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % sliderTexts.length;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
      setState(() {
        _currentGradientIndex = (_currentGradientIndex + 1) % gradients.length;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _sliderTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedContainer(
        duration: Duration(seconds: 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradients[_currentGradientIndex],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Text(
                'Hi, ${widget.username} ð',
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 48,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: sliderTexts.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Text(
                        sliderTexts[index],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: games.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    final game = games[index];
                    return GestureDetector(
                      onTap: () {
                        context.push('/topup', extra: game);
                      },
                      child: Hero(
                        tag: game.name,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              game.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}