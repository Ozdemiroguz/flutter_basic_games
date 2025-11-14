import 'package:flutter/material.dart';
import 'package:flutter_basic_games/models/game_model.dart';
import 'package:flutter_basic_games/widgets/game_card.dart';
import 'package:flutter_basic_games/utils/game_settings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                // ignore: use_build_context_synchronously
                Navigator.pushReplacementNamed(context, '/');
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
            Text(
              'Choose a Game',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: settings.primaryColor,
                  ),
            ),
            const SizedBox(height: 20),
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
                  return GameCard(game: games[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
