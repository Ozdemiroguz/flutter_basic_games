class GameLevel {
  final int levelNumber;
  final String title;
  final String description;
  final String gameId;
  final Map<String, dynamic> config;
  final int requiredStarsToUnlock;

  int starsEarned;
  bool isUnlocked;
  bool isCompleted;
  int? bestScore;

  GameLevel({
    required this.levelNumber,
    required this.title,
    required this.description,
    required this.gameId,
    required this.config,
    this.requiredStarsToUnlock = 0,
    this.starsEarned = 0,
    this.isUnlocked = false,
    this.isCompleted = false,
    this.bestScore,
  });

  Map<String, dynamic> toJson() {
    return {
      'levelNumber': levelNumber,
      'title': title,
      'description': description,
      'gameId': gameId,
      'config': config,
      'requiredStarsToUnlock': requiredStarsToUnlock,
      'starsEarned': starsEarned,
      'isUnlocked': isUnlocked,
      'isCompleted': isCompleted,
      'bestScore': bestScore,
    };
  }

  factory GameLevel.fromJson(Map<String, dynamic> json) {
    return GameLevel(
      levelNumber: json['levelNumber'],
      title: json['title'],
      description: json['description'],
      gameId: json['gameId'],
      config: json['config'],
      requiredStarsToUnlock: json['requiredStarsToUnlock'] ?? 0,
      starsEarned: json['starsEarned'] ?? 0,
      isUnlocked: json['isUnlocked'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
      bestScore: json['bestScore'],
    );
  }
}
