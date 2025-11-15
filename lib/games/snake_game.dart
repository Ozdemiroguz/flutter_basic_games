import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_basic_games/utils/game_settings.dart';

enum Direction { up, down, left, right }

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  static const int gridSize = 20;
  List<Point<int>> snake = [const Point(10, 10)];
  Point<int> food = const Point(15, 15);
  Direction direction = Direction.right;
  Direction nextDirection = Direction.right;
  Timer? gameTimer;
  int score = 0;
  int highScore = 0;
  bool isPlaying = false;
  bool isGameOver = false;

  @override
  void initState() {
    super.initState();
    generateFood();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  void startGame() {
    setState(() {
      snake = [const Point(10, 10)];
      direction = Direction.right;
      nextDirection = Direction.right;
      score = 0;
      isPlaying = true;
      isGameOver = false;
      generateFood();
    });

    gameTimer?.cancel();
    final speed = GameSettings().snakeSpeed;
    gameTimer = Timer.periodic(Duration(milliseconds: speed), (timer) {
      updateGame();
    });
  }

  void generateFood() {
    final random = Random();
    Point<int> newFood;
    do {
      newFood = Point(
        random.nextInt(gridSize),
        random.nextInt(gridSize),
      );
    } while (snake.contains(newFood));

    food = newFood;
  }

  void updateGame() {
    if (!isPlaying || isGameOver) return;

    direction = nextDirection;

    final head = snake.first;
    Point<int> newHead;

    switch (direction) {
      case Direction.up:
        newHead = Point(head.x, head.y - 1);
        break;
      case Direction.down:
        newHead = Point(head.x, head.y + 1);
        break;
      case Direction.left:
        newHead = Point(head.x - 1, head.y);
        break;
      case Direction.right:
        newHead = Point(head.x + 1, head.y);
        break;
    }

    // Check collision with walls
    if (newHead.x < 0 ||
        newHead.x >= gridSize ||
        newHead.y < 0 ||
        newHead.y >= gridSize) {
      gameOver();
      return;
    }

    // Check collision with self
    if (snake.contains(newHead)) {
      gameOver();
      return;
    }

    setState(() {
      snake.insert(0, newHead);

      // Check if food eaten
      if (newHead == food) {
        score += 10;
        if (score > highScore) {
          highScore = score;
        }
        generateFood();
      } else {
        snake.removeLast();
      }
    });
  }

  void gameOver() {
    setState(() {
      isPlaying = false;
      isGameOver = true;
    });
    gameTimer?.cancel();
  }

  void changeDirection(Direction newDirection) {
    // Prevent reversing
    if (direction == Direction.up && newDirection == Direction.down) return;
    if (direction == Direction.down && newDirection == Direction.up) return;
    if (direction == Direction.left && newDirection == Direction.right) return;
    if (direction == Direction.right && newDirection == Direction.left) return;

    nextDirection = newDirection;
  }

  @override
  Widget build(BuildContext context) {
    final settings = GameSettings();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake Game'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Score Display
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildScoreCard('Score', score.toString(), settings.primaryColor),
                _buildScoreCard(
                  'High Score',
                  highScore.toString(),
                  settings.secondaryColor,
                ),
              ],
            ),
          ),

          // Game Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: settings.primaryColor, width: 3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridSize,
                    ),
                    itemCount: gridSize * gridSize,
                    itemBuilder: (context, index) {
                      final x = index % gridSize;
                      final y = index ~/ gridSize;
                      final point = Point(x, y);

                      final isSnakeHead = snake.isNotEmpty && snake.first == point;
                      final isSnakeBody = snake.contains(point) && !isSnakeHead;
                      final isFood = food == point;

                      Color? cellColor;
                      Widget? cellChild;

                      if (isSnakeHead) {
                        cellColor = settings.primaryColor;
                        cellChild = const Icon(
                          Icons.circle,
                          size: 12,
                          color: Colors.white,
                        );
                      } else if (isSnakeBody) {
                        cellColor = settings.primaryColor.withValues(alpha: 0.7);
                      } else if (isFood) {
                        cellColor = settings.secondaryColor;
                        cellChild = const Icon(
                          Icons.apple,
                          size: 12,
                          color: Colors.white,
                        );
                      }

                      return Container(
                        margin: const EdgeInsets.all(0.5),
                        decoration: BoxDecoration(
                          color: cellColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: cellChild,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // Controls
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (!isPlaying)
                  ElevatedButton(
                    onPressed: startGame,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isGameOver ? 'Play Again' : 'Start Game',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                if (isPlaying) ...[
                  // Up button
                  IconButton(
                    icon: Icon(
                      Icons.arrow_drop_up,
                      size: 60,
                      color: settings.primaryColor,
                    ),
                    onPressed: () => changeDirection(Direction.up),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Left button
                      IconButton(
                        icon: Icon(
                          Icons.arrow_left,
                          size: 60,
                          color: settings.primaryColor,
                        ),
                        onPressed: () => changeDirection(Direction.left),
                      ),
                      const SizedBox(width: 60),
                      // Right button
                      IconButton(
                        icon: Icon(
                          Icons.arrow_right,
                          size: 60,
                          color: settings.primaryColor,
                        ),
                        onPressed: () => changeDirection(Direction.right),
                      ),
                    ],
                  ),
                  // Down button
                  IconButton(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      size: 60,
                      color: settings.primaryColor,
                    ),
                    onPressed: () => changeDirection(Direction.down),
                  ),
                ],
              ],
            ),
          ),
        ],
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
          color: color.withValues(alpha: 0.1),
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
