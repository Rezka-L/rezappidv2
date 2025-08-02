import 'dart:async'; import 'package:flutter/material.dart'; import 'package:go_router/go_router.dart'; // Tambahkan jika belum

class HomePage extends StatefulWidget { final String username; const HomePage({super.key, required this.username});

@override State<HomePage> createState() => _HomePageState(); }

class _HomePageState extends State<HomePage> { final PageController _pageController = PageController(); int _currentPage = 0;

static List<List<Color>> gradients = [ const [Color(0xFF1E1B18), Color(0xFF4E2600)], const [Color(0xFF2B1E0F), Color(0xFFFF7E45)], const [Color(0xFF3A2319), Color(0xFFDB3C0D)], const [Color(0xFF271E18), Color(0xFF9E3100)], ];

int _currentGradientIndex = 0;

final List<String> slideImages = [ 'assets/images/mlbb.jpeg', 'assets/images/ff.png', 'assets/images/pubg.png', ];

final List<Map<String, dynamic>> menuItems = [ { "title": "Mobile Legends", "icon": Icons.gamepad, "color": Colors.orangeAccent, "id": "mlbb" }, { "title": "Free Fire", "icon": Icons.whatshot, "color": Colors.redAccent, "id": "ff" }, { "title": "PUBG Mobile", "icon": Icons.sports_esports, "color": Colors.deepOrangeAccent, "id": "pubg" }, { "title": "Genshin Impact", "icon": Icons.bolt, "color": Colors.orange, "id": "genshin" }, { "title": "Call of Duty", "icon": Icons.shield, "color": Colors.deepOrange, "id": "cod" }, { "title": "Valorant", "icon": Icons.flash_on, "color": Colors.red, "id": "valorant" }, ];

late Timer _backgroundTimer; late Timer _slideTimer;

@override void initState() { super.initState();

_backgroundTimer = Timer.periodic(const Duration(seconds: 7), (timer) {
  setState(() {
    _currentGradientIndex = (_currentGradientIndex + 1) % gradients.length;
  });
});

_slideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
  if (_pageController.hasClients) {
    int nextPage = (_currentPage + 1) % slideImages.length;
    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }
});

}

@override void dispose() { _backgroundTimer.cancel(); _slideTimer.cancel(); _pageController.dispose(); super.dispose(); }

void _onPageChanged(int index) { setState(() { _currentPage = index; }); }

Widget buildSlideIndicators() { return Row( mainAxisAlignment: MainAxisAlignment.center, children: List.generate(slideImages.length, (index) { return AnimatedContainer( duration: const Duration(milliseconds: 300), margin: const EdgeInsets.symmetric(horizontal: 4), width: _currentPage == index ? 14 : 8, height: 8, decoration: BoxDecoration( color: _currentPage == index ? Colors.orangeAccent : Colors.grey, borderRadius: BorderRadius.circular(4), ), ); }), ); }

@override Widget build(BuildContext context) { return Scaffold( body: AnimatedContainer( duration: const Duration(seconds: 7), decoration: BoxDecoration( gradient: LinearGradient( colors: gradients[_currentGradientIndex], begin: Alignment.topLeft, end: Alignment.bottomRight, ), ), child: SafeArea( child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [ Padding( padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), child: Text( 'Welcome, ${widget.username} ð', style: const TextStyle( fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white, shadows: [ Shadow( blurRadius: 6, color: Colors.black54, offset: Offset(2, 2), ) ], ), ), ), SizedBox( height: 200, child: PageView.builder( controller: _pageController, itemCount: slideImages.length, onPageChanged: _onPageChanged, itemBuilder: (context, index) { return Padding( padding: const EdgeInsets.symmetric(horizontal: 16), child: ClipRRect( borderRadius: BorderRadius.circular(20), child: Image.asset( slideImages[index], fit: BoxFit.cover, ), ), ); }, ), ), const SizedBox(height: 12), buildSlideIndicators(), const SizedBox(height: 24), Expanded( child: Padding( padding: const EdgeInsets.symmetric(horizontal: 16), child: GridView.builder( itemCount: menuItems.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 3, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.85, ), itemBuilder: (context, index) { final item = menuItems[index]; return GestureDetector( onTap: () { context.push('/topup/${item["id"]}'); }, child: Container( decoration: BoxDecoration( color: item["color"].withOpacity(0.85), borderRadius: BorderRadius.circular(20), boxShadow: const [ BoxShadow( color: Colors.black45, blurRadius: 8, offset: Offset(0, 4), ) ], ), child: Column( mainAxisAlignment: MainAxisAlignment.center, children: [ Icon( item["icon"], size: 48, color: Colors.white, ), const SizedBox(height: 12), Text( item["title"], textAlign: TextAlign.center, style: const TextStyle( fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, shadows: [ Shadow( blurRadius: 4, color: Colors.black54, offset: Offset(1, 1), ) ], ), ), ], ), ), ); }, ), ), ), const SizedBox(height: 20), ], ), ), ), ); } }