import 'package:flutter/material.dart';
import 'package:flutter_basic_games/models/game_model.dart';
import 'package:flutter_basic_games/widgets/game_card.dart';
import 'package:flutter_basic_games/utils/game_settings.dart';
import 'package:flutter_basic_games/utils/progress_manager.dart';
import 'package:flutter_basic_games/screens/level_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProgressManager _progressManager = ProgressManager();

  @override
  void initState() {
    super.initState();
    _initializeProgress();
  }

  Future<void> _initializeProgress() async {
    _progressManager.initializeLevels();
    await _progressManager.loadProgress();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final settings = GameSettings();

    final List<GameModel> games = [
      GameModel(
        title: 'Tic Tac Toe',
        description: 'Classic X and O game',
        icon: Icons.grid_on,
        color: settings.primaryColor,
        route: '/tic_tac_toe',
      ),
      GameModel(
        title: 'Memory Game',
        description: 'Match the cards',
        icon: Icons.psychology,
        color: Colors.purple,
        route: '/memory_game',
      ),
      GameModel(
        title: 'Snake',
        description: 'Eat and grow',
        icon: Icons.gamepad,
        color: Colors.green,
        route: '/snake_game',
      ),
      GameModel(
        title: '2048',
        description: 'Merge numbers',
        icon: Icons.apps,
        color: Colors.orange,
        route: '/2048_game',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Basic Games'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.pushNamed(context, '/settings');
              // Rebuild after settings change
              if (context.mounted) {
                setState(() {});
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: settings.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: settings.primaryColor, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildProgressItem(
                    'Total Stars',
                    '${_progressManager.totalStarsEarned}',
                    Icons.star,
                    settings.primaryColor,
                  ),
                  _buildProgressItem(
                    'Levels Done',
                    '${_progressManager.getTotalCompletedLevels()}',
                    Icons.check_circle,
                    settings.secondaryColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Choose a Game',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: settings.primaryColor,
                  ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: games.length,
                itemBuilder: (context, index) {
                  final game = games[index];
                  final gameId = game.route.replaceAll('/', '');
                  final isUnlocked = _progressManager.isGameUnlocked(gameId);
                  final progress = _progressManager.getGameProgress(gameId);

                  return GameCard(
                    game: game,
                    isLocked: !isUnlocked,
                    progress: progress,
                    onTap: isUnlocked
                        ? () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LevelSelectionScreen(game: game),
                              ),
                            );
                            setState(() {}); // Refresh on return
                          }
                        : () {
                            _showUnlockInfo(context, gameId);
                          },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  void _showUnlockInfo(BuildContext context, String gameId) {
    String message = '';
    switch (gameId) {
      case 'memory_game':
        message = 'Complete 3 Tic Tac Toe levels to unlock Memory Game!';
        break;
      case 'snake_game':
        message = 'Complete 5 total levels to unlock Snake!';
        break;
      case '2048_game':
        message = 'Complete 10 total levels to unlock 2048!';
        break;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.lock, color: Colors.orange),
            SizedBox(width: 8),
            Text('Locked'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
