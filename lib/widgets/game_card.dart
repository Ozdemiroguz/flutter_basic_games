import 'package:flutter/material.dart';
import 'package:flutter_basic_games/models/game_model.dart';
import 'package:flutter_basic_games/models/game_progress.dart';

class GameCard extends StatelessWidget {
  final GameModel game;
  final bool isLocked;
  final GameProgress? progress;
  final VoidCallback? onTap;

  const GameCard({
    super.key,
    required this.game,
    this.isLocked = false,
    this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isLocked ? 2 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: isLocked
                ? null
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      game.color.withValues(alpha: 0.7),
                      game.color,
                    ],
                  ),
            color: isLocked ? Colors.grey.shade300 : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Lock icon or game icon
                if (isLocked)
                  const Icon(
                    Icons.lock,
                    size: 60,
                    color: Colors.grey,
                  )
                else
                  Icon(
                    game.icon,
                    size: 60,
                    color: Colors.white,
                  ),

                const SizedBox(height: 16),

                // Game title
                Text(
                  game.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isLocked ? Colors.grey.shade600 : Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Description or lock message
                Text(
                  isLocked ? 'Locked' : game.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isLocked ? Colors.grey.shade500 : Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Progress info if unlocked
                if (!isLocked && progress != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${progress!.totalStars}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.check_circle, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${progress!.levelsCompleted}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
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
