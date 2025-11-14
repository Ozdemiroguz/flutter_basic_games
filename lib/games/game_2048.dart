import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_basic_games/utils/game_settings.dart';

class Game2048 extends StatefulWidget {
  const Game2048({super.key});

  @override
  State<Game2048> createState() => _Game2048State();
}

class _Game2048State extends State<Game2048> {
  static const int gridSize = 4;
  List<List<int>> grid = [];
  int score = 0;
  int bestScore = 0;
  bool isGameOver = false;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    grid = List.generate(gridSize, (_) => List.filled(gridSize, 0));
    score = 0;
    isGameOver = false;
    addRandomTile();
    addRandomTile();
    setState(() {});
  }

  void addRandomTile() {
    final emptyCells = <Point<int>>[];
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (grid[i][j] == 0) {
          emptyCells.add(Point(i, j));
        }
      }
    }

    if (emptyCells.isNotEmpty) {
      final randomCell = emptyCells[Random().nextInt(emptyCells.length)];
      grid[randomCell.x][randomCell.y] = Random().nextInt(10) == 0 ? 4 : 2;
    }
  }

  bool move(Direction direction) {
    List<List<int>> oldGrid = grid.map((row) => List<int>.from(row)).toList();
    bool moved = false;

    switch (direction) {
      case Direction.left:
        moved = moveLeft();
        break;
      case Direction.right:
        moved = moveRight();
        break;
      case Direction.up:
        moved = moveUp();
        break;
      case Direction.down:
        moved = moveDown();
        break;
    }

    if (moved) {
      addRandomTile();
      if (score > bestScore) {
        bestScore = score;
      }
      checkGameOver();
    }

    return moved;
  }

  bool moveLeft() {
    bool moved = false;
    for (int i = 0; i < gridSize; i++) {
      List<int> row = grid[i].where((cell) => cell != 0).toList();
      for (int j = 0; j < row.length - 1; j++) {
        if (row[j] == row[j + 1]) {
          row[j] *= 2;
          score += row[j];
          row.removeAt(j + 1);
          row.add(0);
        }
      }
      while (row.length < gridSize) {
        row.add(0);
      }
      if (grid[i].toString() != row.toString()) {
        moved = true;
      }
      grid[i] = row;
    }
    return moved;
  }

  bool moveRight() {
    bool moved = false;
    for (int i = 0; i < gridSize; i++) {
      List<int> row = grid[i].where((cell) => cell != 0).toList();
      for (int j = row.length - 1; j > 0; j--) {
        if (row[j] == row[j - 1]) {
          row[j] *= 2;
          score += row[j];
          row.removeAt(j - 1);
          row.insert(0, 0);
          j--;
        }
      }
      while (row.length < gridSize) {
        row.insert(0, 0);
      }
      if (grid[i].toString() != row.toString()) {
        moved = true;
      }
      grid[i] = row;
    }
    return moved;
  }

  bool moveUp() {
    bool moved = false;
    for (int j = 0; j < gridSize; j++) {
      List<int> column = [];
      for (int i = 0; i < gridSize; i++) {
        if (grid[i][j] != 0) {
          column.add(grid[i][j]);
        }
      }
      for (int i = 0; i < column.length - 1; i++) {
        if (column[i] == column[i + 1]) {
          column[i] *= 2;
          score += column[i];
          column.removeAt(i + 1);
          column.add(0);
        }
      }
      while (column.length < gridSize) {
        column.add(0);
      }

      for (int i = 0; i < gridSize; i++) {
        if (grid[i][j] != column[i]) {
          moved = true;
        }
        grid[i][j] = column[i];
      }
    }
    return moved;
  }

  bool moveDown() {
    bool moved = false;
    for (int j = 0; j < gridSize; j++) {
      List<int> column = [];
      for (int i = 0; i < gridSize; i++) {
        if (grid[i][j] != 0) {
          column.add(grid[i][j]);
        }
      }
      for (int i = column.length - 1; i > 0; i--) {
        if (column[i] == column[i - 1]) {
          column[i] *= 2;
          score += column[i];
          column.removeAt(i - 1);
          column.insert(0, 0);
          i--;
        }
      }
      while (column.length < gridSize) {
        column.insert(0, 0);
      }

      for (int i = 0; i < gridSize; i++) {
        if (grid[i][j] != column[i]) {
          moved = true;
        }
        grid[i][j] = column[i];
      }
    }
    return moved;
  }

  void checkGameOver() {
    // Check if any cell is empty
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (grid[i][j] == 0) {
          return;
        }
      }
    }

    // Check if any adjacent cells can merge
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize - 1; j++) {
        if (grid[i][j] == grid[i][j + 1]) {
          return;
        }
      }
    }

    for (int j = 0; j < gridSize; j++) {
      for (int i = 0; i < gridSize - 1; i++) {
        if (grid[i][j] == grid[i + 1][j]) {
          return;
        }
      }
    }

    setState(() {
      isGameOver = true;
    });
  }

  Color getTileColor(int value) {
    final settings = GameSettings();
    switch (value) {
      case 2:
        return const Color(0xFFEEE4DA);
      case 4:
        return const Color(0xFFEDE0C8);
      case 8:
        return const Color(0xFFF2B179);
      case 16:
        return const Color(0xFFF59563);
      case 32:
        return const Color(0xFFF67C5F);
      case 64:
        return const Color(0xFFF65E3B);
      case 128:
        return const Color(0xFFEDCF72);
      case 256:
        return const Color(0xFFEDCC61);
      case 512:
        return const Color(0xFFEDC850);
      case 1024:
        return const Color(0xFFEDC53F);
      case 2048:
        return const Color(0xFFEDC22E);
      default:
        return value > 2048
            ? settings.primaryColor
            : const Color(0xFFCDC1B4);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = GameSettings();

    return Scaffold(
      appBar: AppBar(
        title: const Text('2048'),
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
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            setState(() => move(Direction.right));
          } else if (details.primaryVelocity! < 0) {
            setState(() => move(Direction.left));
          }
        },
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            setState(() => move(Direction.down));
          } else if (details.primaryVelocity! < 0) {
            setState(() => move(Direction.up));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Score Display
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildScoreCard('Score', score.toString(), settings.primaryColor),
                  _buildScoreCard(
                    'Best',
                    bestScore.toString(),
                    settings.secondaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Instructions
              const Text(
                'Swipe to move tiles',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Game Grid
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFBBADA0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridSize,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: gridSize * gridSize,
                    itemBuilder: (context, index) {
                      final i = index ~/ gridSize;
                      final j = index % gridSize;
                      final value = grid[i][j];

                      return Container(
                        decoration: BoxDecoration(
                          color: getTileColor(value),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: value != 0
                              ? Text(
                                  value.toString(),
                                  style: TextStyle(
                                    fontSize: value < 100
                                        ? 32
                                        : value < 1000
                                            ? 28
                                            : 24,
                                    fontWeight: FontWeight.bold,
                                    color: value <= 4
                                        ? const Color(0xFF776E65)
                                        : Colors.white,
                                  ),
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),

              if (isGameOver) ...[
                const SizedBox(height: 20),
                const Text(
                  'Game Over!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      initializeGame();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'New Game',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard(String label, String value, Color color) {
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

enum Direction { up, down, left, right }
