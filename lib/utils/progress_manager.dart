import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_basic_games/models/game_progress.dart';
import 'package:flutter_basic_games/models/level_model.dart';

class ProgressManager {
  static final ProgressManager _instance = ProgressManager._internal();
  factory ProgressManager() => _instance;
  ProgressManager._internal();

  Map<String, GameProgress> _gameProgress = {};
  Map<String, List<GameLevel>> _gameLevels = {};
  int _totalStarsEarned = 0;

  int get totalStarsEarned => _totalStarsEarned;

  // Initialize default levels for all games
  void initializeLevels() {
    _gameLevels = {
      'tic_tac_toe': _createTicTacToeLevels(),
      'memory_game': _createMemoryGameLevels(),
      'snake_game': _createSnakeLevels(),
      '2048_game': _create2048Levels(),
    };

    _gameProgress = {
      'tic_tac_toe': GameProgress(gameId: 'tic_tac_toe', isGameUnlocked: true, highestLevelUnlocked: 1),
      'memory_game': GameProgress(gameId: 'memory_game'),
      'snake_game': GameProgress(gameId: 'snake_game'),
      '2048_game': GameProgress(gameId: '2048_game'),
    };
  }

  List<GameLevel> _createTicTacToeLevels() {
    return [
      GameLevel(
        levelNumber: 1,
        title: 'Beginner',
        description: 'Easy AI opponent',
        gameId: 'tic_tac_toe',
        config: {'difficulty': 'easy', 'aiEnabled': true},
        isUnlocked: true,
      ),
      GameLevel(
        levelNumber: 2,
        title: 'Novice',
        description: 'Easy AI, win without draw',
        gameId: 'tic_tac_toe',
        config: {'difficulty': 'easy', 'aiEnabled': true, 'noDrawAllowed': false},
      ),
      GameLevel(
        levelNumber: 3,
        title: 'Learning',
        description: 'Easy AI, perfect game',
        gameId: 'tic_tac_toe',
        config: {'difficulty': 'easy', 'aiEnabled': true},
      ),
      GameLevel(
        levelNumber: 4,
        title: 'Intermediate',
        description: 'Medium difficulty AI',
        gameId: 'tic_tac_toe',
        config: {'difficulty': 'medium', 'aiEnabled': true},
      ),
      GameLevel(
        levelNumber: 5,
        title: 'Challenger',
        description: 'Medium AI, strategic play',
        gameId: 'tic_tac_toe',
        config: {'difficulty': 'medium', 'aiEnabled': true},
      ),
      GameLevel(
        levelNumber: 6,
        title: 'Advanced',
        description: 'Tough medium AI',
        gameId: 'tic_tac_toe',
        config: {'difficulty': 'medium', 'aiEnabled': true},
      ),
      GameLevel(
        levelNumber: 7,
        title: 'Expert',
        description: 'Hard AI opponent',
        gameId: 'tic_tac_toe',
        config: {'difficulty': 'hard', 'aiEnabled': true},
      ),
      GameLevel(
        levelNumber: 8,
        title: 'Master',
        description: 'Very hard AI',
        gameId: 'tic_tac_toe',
        config: {'difficulty': 'hard', 'aiEnabled': true},
      ),
      GameLevel(
        levelNumber: 9,
        title: 'Grandmaster',
        description: 'Nearly unbeatable AI',
        gameId: 'tic_tac_toe',
        config: {'difficulty': 'hard', 'aiEnabled': true},
      ),
      GameLevel(
        levelNumber: 10,
        title: 'Legend',
        description: 'Ultimate challenge',
        gameId: 'tic_tac_toe',
        config: {'difficulty': 'hard', 'aiEnabled': true},
      ),
    ];
  }

  List<GameLevel> _createMemoryGameLevels() {
    return [
      GameLevel(levelNumber: 1, title: 'Starter', description: '2x2 grid', gameId: 'memory_game', config: {'gridSize': 2, 'targetMoves': 10}),
      GameLevel(levelNumber: 2, title: 'Easy', description: '2x2 grid, fewer moves', gameId: 'memory_game', config: {'gridSize': 2, 'targetMoves': 6}),
      GameLevel(levelNumber: 3, title: 'Growing', description: '3x3 grid', gameId: 'memory_game', config: {'gridSize': 3, 'targetMoves': 15}),
      GameLevel(levelNumber: 4, title: 'Standard', description: '4x4 grid', gameId: 'memory_game', config: {'gridSize': 4, 'targetMoves': 20}),
      GameLevel(levelNumber: 5, title: 'Focused', description: '4x4 grid, time limit', gameId: 'memory_game', config: {'gridSize': 4, 'targetMoves': 18, 'timeLimit': 120}),
      GameLevel(levelNumber: 6, title: 'Challenging', description: '4x4 grid, stricter', gameId: 'memory_game', config: {'gridSize': 4, 'targetMoves': 16}),
      GameLevel(levelNumber: 7, title: 'Large Grid', description: '5x5 grid', gameId: 'memory_game', config: {'gridSize': 5, 'targetMoves': 30}),
      GameLevel(levelNumber: 8, title: 'Memory Test', description: '5x5 grid, time limit', gameId: 'memory_game', config: {'gridSize': 5, 'targetMoves': 25, 'timeLimit': 180}),
      GameLevel(levelNumber: 9, title: 'Expert Memory', description: '6x6 grid', gameId: 'memory_game', config: {'gridSize': 6, 'targetMoves': 40}),
      GameLevel(levelNumber: 10, title: 'Master Mind', description: '6x6 grid, ultimate test', gameId: 'memory_game', config: {'gridSize': 6, 'targetMoves': 35, 'timeLimit': 240}),
    ];
  }

  List<GameLevel> _createSnakeLevels() {
    return [
      GameLevel(levelNumber: 1, title: 'First Steps', description: 'Slow snake, low target', gameId: 'snake_game', config: {'speed': 400, 'targetScore': 50, 'obstacles': []}),
      GameLevel(levelNumber: 2, title: 'Getting Faster', description: 'Medium speed', gameId: 'snake_game', config: {'speed': 350, 'targetScore': 100, 'obstacles': []}),
      GameLevel(levelNumber: 3, title: 'Speed Up', description: 'Faster movement', gameId: 'snake_game', config: {'speed': 300, 'targetScore': 150, 'obstacles': []}),
      GameLevel(levelNumber: 4, title: 'Obstacle Course', description: 'With obstacles', gameId: 'snake_game', config: {'speed': 300, 'targetScore': 150, 'obstacles': [[5,5], [5,6], [15,15]]}),
      GameLevel(levelNumber: 5, title: 'Quick Reflexes', description: 'Fast snake', gameId: 'snake_game', config: {'speed': 250, 'targetScore': 200, 'obstacles': [[10,10]]}),
      GameLevel(levelNumber: 6, title: 'Maze Runner', description: 'More obstacles', gameId: 'snake_game', config: {'speed': 250, 'targetScore': 200, 'obstacles': [[5,5], [5,6], [5,7], [15,15], [15,14]]}),
      GameLevel(levelNumber: 7, title: 'Speed Demon', description: 'Very fast', gameId: 'snake_game', config: {'speed': 200, 'targetScore': 250, 'obstacles': [[8,8], [8,9]]}),
      GameLevel(levelNumber: 8, title: 'Complex Maze', description: 'Many obstacles', gameId: 'snake_game', config: {'speed': 200, 'targetScore': 250, 'obstacles': [[5,5], [5,6], [5,7], [15,15], [15,14], [10,10], [10,11]]}),
      GameLevel(levelNumber: 9, title: 'Lightning Fast', description: 'Extreme speed', gameId: 'snake_game', config: {'speed': 150, 'targetScore': 300, 'obstacles': [[7,7], [7,8], [13,13]]}),
      GameLevel(levelNumber: 10, title: 'Master Snake', description: 'Ultimate challenge', gameId: 'snake_game', config: {'speed': 150, 'targetScore': 400, 'obstacles': [[5,5], [5,6], [5,7], [15,15], [15,14], [15,13], [10,10], [10,11], [10,12]]}),
    ];
  }

  List<GameLevel> _create2048Levels() {
    return [
      GameLevel(levelNumber: 1, title: 'Tutorial', description: 'Reach 128', gameId: '2048_game', config: {'targetScore': 128, 'moveLimit': null}),
      GameLevel(levelNumber: 2, title: 'Getting Started', description: 'Reach 256', gameId: '2048_game', config: {'targetScore': 256, 'moveLimit': null}),
      GameLevel(levelNumber: 3, title: 'Progressing', description: 'Reach 512', gameId: '2048_game', config: {'targetScore': 512, 'moveLimit': null}),
      GameLevel(levelNumber: 4, title: 'Skilled', description: 'Reach 512 in 100 moves', gameId: '2048_game', config: {'targetScore': 512, 'moveLimit': 100}),
      GameLevel(levelNumber: 5, title: 'Advanced', description: 'Reach 1024', gameId: '2048_game', config: {'targetScore': 1024, 'moveLimit': null}),
      GameLevel(levelNumber: 6, title: 'Efficient', description: 'Reach 1024 in 150 moves', gameId: '2048_game', config: {'targetScore': 1024, 'moveLimit': 150}),
      GameLevel(levelNumber: 7, title: 'Expert Level', description: 'Reach 2048', gameId: '2048_game', config: {'targetScore': 2048, 'moveLimit': null}),
      GameLevel(levelNumber: 8, title: 'Time Challenge', description: 'Reach 2048 in 200 moves', gameId: '2048_game', config: {'targetScore': 2048, 'moveLimit': 200}),
      GameLevel(levelNumber: 9, title: 'Master', description: 'Reach 4096', gameId: '2048_game', config: {'targetScore': 4096, 'moveLimit': null}),
      GameLevel(levelNumber: 10, title: 'Legend', description: 'Reach 4096 efficiently', gameId: '2048_game', config: {'targetScore': 4096, 'moveLimit': 300}),
    ];
  }

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    // Load game progress
    for (String gameId in _gameProgress.keys) {
      final progressJson = prefs.getString('progress_$gameId');
      if (progressJson != null) {
        _gameProgress[gameId] = GameProgress.fromJson(jsonDecode(progressJson));
      }
    }

    // Load level progress
    for (String gameId in _gameLevels.keys) {
      final levelsJson = prefs.getString('levels_$gameId');
      if (levelsJson != null) {
        final levelsList = jsonDecode(levelsJson) as List;
        _gameLevels[gameId] = levelsList.map((l) => GameLevel.fromJson(l)).toList();
      }
    }

    // Calculate total stars
    _calculateTotalStars();

    // Update game unlocks based on total stars
    _updateGameUnlocks();
  }

  Future<void> saveProgress() async {
    final prefs = await SharedPreferences.getInstance();

    // Save game progress
    for (String gameId in _gameProgress.keys) {
      await prefs.setString('progress_$gameId', jsonEncode(_gameProgress[gameId]!.toJson()));
    }

    // Save level progress
    for (String gameId in _gameLevels.keys) {
      final levelsJson = _gameLevels[gameId]!.map((l) => l.toJson()).toList();
      await prefs.setString('levels_$gameId', jsonEncode(levelsJson));
    }
  }

  void _calculateTotalStars() {
    _totalStarsEarned = 0;
    for (var levels in _gameLevels.values) {
      for (var level in levels) {
        _totalStarsEarned += level.starsEarned;
      }
    }
  }

  void _updateGameUnlocks() {
    // Tic Tac Toe is always unlocked
    _gameProgress['tic_tac_toe']!.isGameUnlocked = true;

    // Memory Game: Unlock after 3 Tic Tac Toe levels completed
    int ticTacToeCompleted = _gameProgress['tic_tac_toe']!.levelsCompleted;
    _gameProgress['memory_game']!.isGameUnlocked = ticTacToeCompleted >= 3;

    // Snake: Unlock after 5 total levels completed
    int totalCompleted = _gameProgress.values.fold(0, (sum, progress) => sum + progress.levelsCompleted);
    _gameProgress['snake_game']!.isGameUnlocked = totalCompleted >= 5;

    // 2048: Unlock after 10 total levels completed
    _gameProgress['2048_game']!.isGameUnlocked = totalCompleted >= 10;
  }

  Future<void> completeLevel(String gameId, int levelNumber, int stars, {int? score}) async {
    if (!_gameLevels.containsKey(gameId)) return;

    final levels = _gameLevels[gameId]!;
    final levelIndex = levels.indexWhere((l) => l.levelNumber == levelNumber);

    if (levelIndex == -1) return;

    final level = levels[levelIndex];
    final oldStars = level.starsEarned;

    // Update level
    level.isCompleted = true;
    level.starsEarned = stars > level.starsEarned ? stars : level.starsEarned;
    if (score != null && (level.bestScore == null || score > level.bestScore!)) {
      level.bestScore = score;
    }

    // Unlock next level
    if (levelIndex + 1 < levels.length) {
      levels[levelIndex + 1].isUnlocked = true;
    }

    // Update game progress
    final progress = _gameProgress[gameId]!;
    if (!progress.levelsCompleted.toString().contains(levelNumber.toString())) {
      progress.levelsCompleted++;
    }
    progress.totalStars += (stars - oldStars);
    if (levelNumber > progress.highestLevelUnlocked) {
      progress.highestLevelUnlocked = levelNumber + 1;
    }

    _calculateTotalStars();
    _updateGameUnlocks();
    await saveProgress();
  }

  List<GameLevel> getLevels(String gameId) {
    return _gameLevels[gameId] ?? [];
  }

  GameProgress? getGameProgress(String gameId) {
    return _gameProgress[gameId];
  }

  bool isGameUnlocked(String gameId) {
    return _gameProgress[gameId]?.isGameUnlocked ?? false;
  }

  Future<void> resetAllProgress() async {
    initializeLevels();
    await saveProgress();
  }

  int getTotalCompletedLevels() {
    return _gameProgress.values.fold(0, (sum, progress) => sum + progress.levelsCompleted);
  }
}
