import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_basic_games/utils/game_settings.dart';
import 'package:flutter_basic_games/models/level_model.dart';

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  List<String> board = List.filled(9, '');
  bool isXTurn = true;
  String winner = '';
  GameLevel? level;
  Function(int, int, {int?})? onComplete;

  bool aiEnabled = false;
  String aiDifficulty = 'easy';
  int wins = 0;
  int draws = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      level = args['level'] as GameLevel?;
      onComplete = args['onComplete'] as Function(int, int, {int?})?;
      if (level != null) {
        aiEnabled = level!.config['aiEnabled'] ?? false;
        aiDifficulty = level!.config['difficulty'] ?? 'easy';
      }
    }
    resetGame();
  }

  void makeMove(int index) {
    if (board[index] == '' && winner == '' && isXTurn) {
      setState(() {
        board[index] = 'X';
        isXTurn = false;
        winner = checkWinner();

        if (winner != '' || !board.contains('')) {
          handleGameEnd();
        } else if (aiEnabled && !isXTurn) {
          // AI move after a short delay
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted && !isXTurn && winner == '') {
              makeAIMove();
            }
          });
        }
      });
    }
  }

  void makeAIMove() {
    int? move;

    switch (aiDifficulty) {
      case 'easy':
        move = getEasyAIMove();
        break;
      case 'medium':
        move = getMediumAIMove();
        break;
      case 'hard':
        move = getHardAIMove();
        break;
    }

    if (move != null && board[move] == '') {
      setState(() {
        board[move!] = 'O';
        isXTurn = true;
        winner = checkWinner();
        if (winner != '' || !board.contains('')) {
          handleGameEnd();
        }
      });
    }
  }

  int? getEasyAIMove() {
    // 30% chance of making a smart move, 70% random
    if (Random().nextInt(100) < 30) {
      return getMediumAIMove();
    }
    final emptySpots = <int>[];
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') emptySpots.add(i);
    }
    return emptySpots.isEmpty ? null : emptySpots[Random().nextInt(emptySpots.length)];
  }

  int? getMediumAIMove() {
    // Try to win
    int? winMove = findWinningMove('O');
    if (winMove != null) return winMove;

    // Block player from winning
    int? blockMove = findWinningMove('X');
    if (blockMove != null) return blockMove;

    // Take center if available
    if (board[4] == '') return 4;

    // Take a corner
    List<int> corners = [0, 2, 6, 8];
    corners.shuffle();
    for (int corner in corners) {
      if (board[corner] == '') return corner;
    }

    // Take any available spot
    return getEasyAIMove();
  }

  int? getHardAIMove() {
    // Use minimax algorithm for hard difficulty
    int bestScore = -1000;
    int? bestMove;

    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        board[i] = 'O';
        int score = minimax(board, 0, false);
        board[i] = '';

        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
      }
    }

    return bestMove;
  }

  int minimax(List<String> board, int depth, bool isMaximizing) {
    String result = checkWinner();

    if (result == 'O') return 10 - depth;
    if (result == 'X') return depth - 10;
    if (!board.contains('')) return 0;

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == '') {
          board[i] = 'O';
          int score = minimax(board, depth + 1, false);
          board[i] = '';
          bestScore = max(bestScore, score);
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == '') {
          board[i] = 'X';
          int score = minimax(board, depth + 1, true);
          board[i] = '';
          bestScore = min(bestScore, score);
        }
      }
      return bestScore;
    }
  }

  int? findWinningMove(String player) {
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        board[i] = player;
        if (checkWinner() == player) {
          board[i] = '';
          return i;
        }
        board[i] = '';
      }
    }
    return null;
  }

  String checkWinner() {
    const List<List<int>> winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6], // Diagonals
    ];

    for (var pattern in winPatterns) {
      if (board[pattern[0]] != '' &&
          board[pattern[0]] == board[pattern[1]] &&
          board[pattern[1]] == board[pattern[2]]) {
        return board[pattern[0]];
      }
    }

    if (!board.contains('')) {
      return 'Draw';
    }

    return '';
  }

  void handleGameEnd() {
    if (winner == 'X') {
      wins++;
      if (level != null) {
        showLevelCompleteDialog();
      }
    } else if (winner == 'Draw') {
      draws++;
    }
  }

  void showLevelCompleteDialog() {
    // Calculate stars based on performance
    int stars = 1;
    if (wins >= 1 && draws == 0) stars = 2;
    if (wins >= 1 && draws == 0 && aiDifficulty == 'hard') stars = 3;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Level Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Congratulations!'),
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
              setState(() {
                resetGame();
                wins = 0;
                draws = 0;
              });
            },
            child: const Text('Play Again'),
          ),
          TextButton(
            onPressed: () {
              if (onComplete != null && level != null) {
                onComplete!(level!.levelNumber, stars);
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

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      isXTurn = true;
      winner = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = GameSettings();

    return Scaffold(
      appBar: AppBar(
        title: Text(level != null ? 'Level ${level!.levelNumber}: ${level!.title}' : 'Tic Tac Toe'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: resetGame,
            tooltip: 'Reset Game',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Level info
            if (level != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: settings.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  level!.description,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 20),

            // Score Board
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildScoreCard('X (You)', wins.toString(), settings.primaryColor),
                _buildScoreCard('Draws', draws.toString(), Colors.grey),
              ],
            ),

            const SizedBox(height: 30),

            // Current Turn or Winner
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: winner == ''
                    ? (isXTurn ? settings.primaryColor : settings.secondaryColor)
                    : winner == 'Draw'
                        ? Colors.orange
                        : winner == 'X'
                            ? Colors.green
                            : Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                winner == ''
                    ? "Turn: ${isXTurn ? 'X (You)' : 'O (AI)'}"
                    : winner == 'Draw'
                        ? 'Draw!'
                        : winner == 'X'
                            ? 'You Win!'
                            : 'AI Wins!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Game Board
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => makeMove(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: settings.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: settings.primaryColor,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            board[index],
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: board[index] == 'X'
                                  ? settings.primaryColor
                                  : settings.secondaryColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            // New Game Button
            if (winner != '' && level == null)
              ElevatedButton(
                onPressed: resetGame,
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
        ),
      ),
    );
  }

  Widget _buildScoreCard(String player, String score, Color color) {
    return Card(
      elevation: 4,
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.1),
        ),
        child: Column(
          children: [
            Text(
              player,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              score,
              style: TextStyle(
                fontSize: 28,
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
