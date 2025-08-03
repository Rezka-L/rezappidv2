class Game {
  final String id;
  final String name;
  final String image;

  const Game({
    required this.id,
    required this.name,
    required this.image,
  });
}

// List game yang tersedia
const List<Game> games = [
  Game(
    id: 'ml',
    name: 'Mobile Legends',
    image: 'assets/images/mlbb.jpeg', // Gambar lokal
  ),
  Game(
    id: 'ff',
    name: 'Free Fire',
    image: 'assets/images/ff.png',
  ),
  Game(
    id: 'pubg',
    name: 'PUBG Mobile',
    image: 'assets/images/pubg.png',
  ),
];