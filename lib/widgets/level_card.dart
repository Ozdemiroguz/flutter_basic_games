import 'package:flutter/material.dart';
import 'package:flutter_basic_games/models/level_model.dart';
import 'package:flutter_basic_games/utils/game_settings.dart';

class LevelCard extends StatelessWidget {
  final GameLevel level;
  final VoidCallback? onTap;

  const LevelCard({
    super.key,
    required this.level,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final settings = GameSettings();
    final bool canPlay = level.isUnlocked;

    return Card(
      elevation: canPlay ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: canPlay ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: canPlay
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      settings.primaryColor.withOpacity(0.7),
                      settings.primaryColor,
                    ],
                  )
                : null,
            color: canPlay ? null : Colors.grey.shade300,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Level number or lock icon
                if (!canPlay)
                  const Icon(
                    Icons.lock,
                    size: 40,
                    color: Colors.grey,
                  )
                else
                  Text(
                    '${level.levelNumber}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                const SizedBox(height: 8),

                // Level title
                Text(
                  level.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: canPlay ? Colors.white : Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                // Level description
                Text(
                  level.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: canPlay ? Colors.white70 : Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                // Stars display
                if (canPlay)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Icon(
                        index < level.starsEarned
                            ? Icons.star
                            : Icons.star_border,
                        color: index < level.starsEarned
                            ? Colors.amber
                            : Colors.white54,
                        size: 20,
                      );
                    }),
                  ),

                // Best score if available
                if (canPlay && level.bestScore != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Best: ${level.bestScore}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
