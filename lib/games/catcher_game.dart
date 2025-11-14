import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_basic_games/utils/game_settings.dart';
import 'package:flutter_basic_games/models/level_model.dart';

class FallingObject {
  double x;
  double y;
  final String type; // 'star', 'heart', 'coin', 'bomb'
  final IconData icon;
  final Color color;
  final int points;
  final bool isDangerous;

  FallingObject({
    required this.x,
    required this.y,
    required this.type,
    required this.icon,
    required this.color,
    required this.points,
    this.isDangerous = false,
  });
}

class CatcherGame extends StatefulWidget {
  const CatcherGame({super.key});

  @override
  State<CatcherGame> createState() => _CatcherGameState();
}

class _CatcherGameState extends State<CatcherGame> {
  GameLevel? level;
  Function(int, int, {int?})? onComplete;

  double basketX = 0.5; // Position (0.0 to 1.0)
  double basketWidth = 0.15;

  List<FallingObject> fallingObjects = [];
  Timer? gameTimer;
  Timer? spawnTimer;

  int score = 0;
  int lives = 3;
  int targetScore = 100;
  double fallSpeed = 2.0;
  double spawnRate = 1.0;
  double bombChance = 0.2;

  bool isPlaying = false;
  bool isGameOver = false;

  final List<Map<String, dynamic>> objectTypes = [
    {
      'type': 'star',
      'icon': Icons.star,
      'color': Colors.amber,
      'points': 10,
      'dangerous': false
    },
    {
      'type': 'heart',
      'icon': Icons.favorite,
      'color': Colors.red,
      'points': 15,
      'dangerous': false
    },
    {
      'type': 'coin',
      'icon': Icons.monetization_on,
      'color': Colors.orange,
      'points': 20,
      'dangerous': false
    },
    {
      'type': 'diamond',
      'icon': Icons.diamond,
      'color': Colors.cyan,
      'points': 30,
      'dangerous': false
    },
    {
      'type': 'bomb',
      'icon': Icons.warning,
      'color': Colors.black,
      'points': -20,
      'dangerous': true
    },
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      level = args['level'] as GameLevel?;
      onComplete = args['onComplete'] as Function(int, int, {int?})?;
      if (level != null) {
        targetScore = level!.config['targetScore'] ?? 100;
        fallSpeed = (level!.config['fallSpeed'] ?? 2.0).toDouble();
        spawnRate = (level!.config['spawnRate'] ?? 1.0).toDouble();
        bombChance = (level!.config['bombChance'] ?? 0.2).toDouble();
      }
    }
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    spawnTimer?.cancel();
    super.dispose();
  }

  void startGame() {
    setState(() {
      score = 0;
      lives = 3;
      fallingObjects.clear();
      isPlaying = true;
      isGameOver = false;
    });

    // Game loop
    gameTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      updateGame();
    });

    // Spawn objects
    spawnTimer = Timer.periodic(Duration(milliseconds: (1000 / spawnRate).round()), (timer) {
      spawnObject();
    });
  }

  void spawnObject() {
    if (!isPlaying || isGameOver) return;

    final random = Random();

    // Decide if it's a bomb
    bool isBomb = random.nextDouble() < bombChance;

    Map<String, dynamic> objType;
    if (isBomb) {
      objType = objectTypes.last; // bomb
    } else {
      // Random good object
      final goodObjects = objectTypes.sublist(0, objectTypes.length - 1);
      objType = goodObjects[random.nextInt(goodObjects.length)];
    }

    setState(() {
      fallingObjects.add(FallingObject(
        x: random.nextDouble() * 0.9 + 0.05, // Random X position
        y: -0.05, // Start above screen
        type: objType['type'],
        icon: objType['icon'],
        color: objType['color'],
        points: objType['points'],
        isDangerous: objType['dangerous'],
      ));
    });
  }

  void updateGame() {
    if (!isPlaying || isGameOver) return;

    setState(() {
      // Move objects down
      for (var obj in fallingObjects) {
        obj.y += 0.01 * fallSpeed;
      }

      // Check collisions and remove off-screen objects
      fallingObjects.removeWhere((obj) {
        // Check if caught by basket
        if (obj.y >= 0.85 && obj.y <= 0.95) {
          if ((obj.x - basketX).abs() < basketWidth / 2) {
            // Caught!
            if (obj.isDangerous) {
              lives--;
              if (lives <= 0) {
                gameOver();
              }
            } else {
              score += obj.points;
              if (score >= targetScore) {
                levelComplete();
              }
            }
            return true;
          }
        }

        // Remove if off screen
        if (obj.y > 1.0) {
          // Missed a good object, lose points
          if (!obj.isDangerous) {
            score = max(0, score - 5);
          }
          return true;
        }

        return false;
      });
    });
  }

  void moveBasket(double delta) {
    setState(() {
      basketX = (basketX + delta).clamp(basketWidth / 2, 1.0 - basketWidth / 2);
    });
  }

  void gameOver() {
    setState(() {
      isPlaying = false;
      isGameOver = true;
    });
    gameTimer?.cancel();
    spawnTimer?.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over!'),
        content: Text('Final Score: $score\nTarget: $targetScore'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              startGame();
            },
            child: const Text('Try Again'),
          ),
          if (level != null)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Exit'),
            ),
        ],
      ),
    );
  }

  void levelComplete() {
    gameTimer?.cancel();
    spawnTimer?.cancel();
    setState(() {
      isPlaying = false;
    });

    // Calculate stars
    int stars = 1;
    if (score >= targetScore * 1.5) {
      stars = 3;
    } else if (score >= targetScore * 1.2) {
      stars = 2;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Level Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Score: $score'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Icon(
                  index < stars ? Icons.star : Icons.star_border,
                  color: index < stars ? Colors.amber : Colors.grey,
                  size: 40,
                );
              }),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              startGame();
            },
            child: const Text('Play Again'),
          ),
          TextButton(
            onPressed: () {
              if (onComplete != null && level != null) {
                onComplete!(level!.levelNumber, stars, score: score);
              }
              Navigator.pop(context);
              Navigator.pop(context, true);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = GameSettings();
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(level != null ? 'Level ${level!.levelNumber}: ${level!.title}' : 'Sky Catcher'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Stats
          Container(
            padding: const EdgeInsets.all(16),
            color: settings.primaryColor.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('Score', '$score', Icons.star, settings.primaryColor),
                _buildStat('Target', '$targetScore', Icons.flag, settings.secondaryColor),
                _buildStat('Lives', '$lives', Icons.favorite, Colors.red),
              ],
            ),
          ),

          // Game area
          Expanded(
            child: Stack(
              children: [
                // Background
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue.shade200,
                        Colors.blue.shade50,
                      ],
                    ),
                  ),
                ),

                // Falling objects
                ...fallingObjects.map((obj) {
                  return Positioned(
                    left: obj.x * screenSize.width - 20,
                    top: obj.y * screenSize.height,
                    child: Icon(
                      obj.icon,
                      size: 40,
                      color: obj.color,
                    ),
                  );
                }),

                // Basket
                if (isPlaying)
                  Positioned(
                    left: (basketX - basketWidth / 2) * screenSize.width,
                    bottom: 40,
                    child: Container(
                      width: basketWidth * screenSize.width,
                      height: 60,
                      decoration: BoxDecoration(
                        color: settings.primaryColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: const Icon(
                        Icons.shopping_basket,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),

                // Start button overlay
                if (!isPlaying && !isGameOver)
                  Center(
                    child: ElevatedButton(
                      onPressed: startGame,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'START',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Controls
          if (isPlaying)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () => moveBasket(-0.05),
                    icon: Icon(
                      Icons.arrow_back,
                      size: 50,
                      color: settings.primaryColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () => moveBasket(0.05),
                    icon: Icon(
                      Icons.arrow_forward,
                      size: 50,
                      color: settings.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
