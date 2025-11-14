import 'package:flutter/material.dart';
import 'package:flutter_basic_games/utils/game_settings.dart';

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  List<String> board = List.filled(9, '');
  bool isXTurn = true;
  String winner = '';
  int xScore = 0;
  int oScore = 0;

  void makeMove(int index) {
    if (board[index] == '' && winner == '') {
      setState(() {
        board[index] = isXTurn ? 'X' : 'O';
        isXTurn = !isXTurn;
        winner = checkWinner();
        if (winner == 'X') {
          xScore++;
        } else if (winner == 'O') {
          oScore++;
        }
      });
    }
  }

  String checkWinner() {
    // Winning combinations
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

    // Check for draw
    if (!board.contains('')) {
      return 'Draw';
    }

    return '';
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      isXTurn = true;
      winner = '';
    });
  }

  void resetScores() {
    setState(() {
      xScore = 0;
      oScore = 0;
      resetGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = GameSettings();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: resetScores,
            tooltip: 'Reset Scores',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Score Board
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildScoreCard('X', xScore, settings.primaryColor),
                _buildScoreCard('O', oScore, settings.secondaryColor),
              ],
            ),
            const SizedBox(height: 30),

            // Current Turn or Winner
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: winner == ''
                    ? (isXTurn ? settings.primaryColor : settings.secondaryColor)
                    : Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                winner == ''
                    ? "Turn: ${isXTurn ? 'X' : 'O'}"
                    : winner == 'Draw'
                        ? 'Draw!'
                        : 'Winner: $winner',
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
            if (winner != '')
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

  Widget _buildScoreCard(String player, int score, Color color) {
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
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              score.toString(),
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
