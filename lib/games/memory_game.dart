import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_basic_games/utils/game_settings.dart';

class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  late int gridSize;
  late List<int> cardValues;
  late List<bool> cardFlipped;
  late List<bool> cardMatched;

  int? firstCardIndex;
  int? secondCardIndex;
  int moves = 0;
  int matches = 0;
  bool canFlip = true;

  final List<IconData> icons = [
    Icons.star,
    Icons.favorite,
    Icons.flight,
    Icons.music_note,
    Icons.pets,
    Icons.sports_soccer,
    Icons.cake,
    Icons.beach_access,
    Icons.directions_car,
    Icons.home,
    Icons.restaurant,
    Icons.school,
    Icons.shopping_cart,
    Icons.local_hospital,
    Icons.local_cafe,
    Icons.wb_sunny,
    Icons.cloud,
    Icons.ac_unit,
  ];

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    gridSize = GameSettings().memoryGridSize;
    final totalCards = gridSize * gridSize;
    final pairCount = totalCards ~/ 2;

    // Create pairs
    cardValues = [];
    for (int i = 0; i < pairCount; i++) {
      cardValues.add(i);
      cardValues.add(i);
    }
    cardValues.shuffle();

    cardFlipped = List.filled(totalCards, false);
    cardMatched = List.filled(totalCards, false);
    moves = 0;
    matches = 0;
    firstCardIndex = null;
    secondCardIndex = null;
    canFlip = true;
  }

  void flipCard(int index) {
    if (!canFlip ||
        cardFlipped[index] ||
        cardMatched[index] ||
        index == firstCardIndex) {
      return;
    }

    setState(() {
      cardFlipped[index] = true;

      if (firstCardIndex == null) {
        firstCardIndex = index;
      } else {
        secondCardIndex = index;
        canFlip = false;
        moves++;
        checkMatch();
      }
    });
  }

  void checkMatch() {
    if (firstCardIndex == null || secondCardIndex == null) return;

    if (cardValues[firstCardIndex!] == cardValues[secondCardIndex!]) {
      // Match found
      setState(() {
        cardMatched[firstCardIndex!] = true;
        cardMatched[secondCardIndex!] = true;
        matches++;
        firstCardIndex = null;
        secondCardIndex = null;
        canFlip = true;
      });

      // Check if game won
      if (matches == cardValues.length ~/ 2) {
        Future.delayed(const Duration(milliseconds: 500), () {
          showWinDialog();
        });
      }
    } else {
      // No match
      Timer(const Duration(milliseconds: 1000), () {
        setState(() {
          cardFlipped[firstCardIndex!] = false;
          cardFlipped[secondCardIndex!] = false;
          firstCardIndex = null;
          secondCardIndex = null;
          canFlip = true;
        });
      });
    }
  }

  void showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Congratulations!'),
        content: Text('You won in $moves moves!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                initializeGame();
              });
            },
            child: const Text('Play Again'),
          ),
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

  @override
  Widget build(BuildContext context) {
    final settings = GameSettings();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Game'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                initializeGame();
              });
            },
            tooltip: 'New Game',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard('Moves', moves.toString(), settings.primaryColor),
                _buildStatCard(
                  'Matches',
                  '$matches/${cardValues.length ~/ 2}',
                  settings.secondaryColor,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Game Grid
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridSize,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: cardValues.length,
                    itemBuilder: (context, index) {
                      final isFlipped = cardFlipped[index] || cardMatched[index];

                      return GestureDetector(
                        onTap: () => flipCard(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: cardMatched[index]
                                ? Colors.green.withOpacity(0.3)
                                : isFlipped
                                    ? settings.primaryColor
                                    : settings.secondaryColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: isFlipped
                                ? Icon(
                                    icons[cardValues[index] % icons.length],
                                    size: 40,
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.help_outline,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.1),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
