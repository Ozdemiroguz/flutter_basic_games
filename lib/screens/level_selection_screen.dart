import 'package:flutter/material.dart';
import 'package:flutter_basic_games/models/level_model.dart';
import 'package:flutter_basic_games/models/game_model.dart';
import 'package:flutter_basic_games/utils/progress_manager.dart';
import 'package:flutter_basic_games/utils/game_settings.dart';
import 'package:flutter_basic_games/widgets/level_card.dart';

class LevelSelectionScreen extends StatefulWidget {
  final GameModel game;

  const LevelSelectionScreen({super.key, required this.game});

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  final ProgressManager _progressManager = ProgressManager();
  List<GameLevel> levels = [];

  @override
  void initState() {
    super.initState();
    _loadLevels();
  }

  void _loadLevels() {
    setState(() {
      levels = _progressManager.getLevels(widget.game.route.replaceAll('/', ''));
    });
  }

  void _onLevelComplete(int levelNumber, int stars, {int? score}) async {
    await _progressManager.completeLevel(
      widget.game.route.replaceAll('/', ''),
      levelNumber,
      stars,
      score: score,
    );
    _loadLevels();
  }

  @override
  Widget build(BuildContext context) {
    final settings = GameSettings();
    final progress = _progressManager.getGameProgress(widget.game.route.replaceAll('/', ''));

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.game.title} - Levels'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress summary
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: settings.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: settings.primaryColor, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Completed',
                  '${progress?.levelsCompleted ?? 0}/${levels.length}',
                  Icons.check_circle,
                ),
                _buildStatItem(
                  'Total Stars',
                  '${progress?.totalStars ?? 0}/${levels.length * 3}',
                  Icons.star,
                ),
              ],
            ),
          ),

          // Levels grid
          Expanded(
            child: levels.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: levels.length,
                    itemBuilder: (context, index) {
                      final level = levels[index];
                      return LevelCard(
                        level: level,
                        onTap: () async {
                          // Navigate to game with level config
                          final result = await Navigator.pushNamed(
                            context,
                            widget.game.route,
                            arguments: {
                              'level': level,
                              'onComplete': _onLevelComplete,
                            },
                          );

                          // Refresh levels after returning
                          if (result != null) {
                            _loadLevels();
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    final settings = GameSettings();
    return Column(
      children: [
        Icon(icon, color: settings.primaryColor, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: settings.primaryColor,
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
}
