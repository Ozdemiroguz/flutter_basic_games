class GameProgress {
  final String gameId;
  int totalStars;
  int levelsCompleted;
  int highestLevelUnlocked;
  bool isGameUnlocked;

  GameProgress({
    required this.gameId,
    this.totalStars = 0,
    this.levelsCompleted = 0,
    this.highestLevelUnlocked = 1,
    this.isGameUnlocked = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'totalStars': totalStars,
      'levelsCompleted': levelsCompleted,
      'highestLevelUnlocked': highestLevelUnlocked,
      'isGameUnlocked': isGameUnlocked,
    };
  }

  factory GameProgress.fromJson(Map<String, dynamic> json) {
    return GameProgress(
      gameId: json['gameId'],
      totalStars: json['totalStars'] ?? 0,
      levelsCompleted: json['levelsCompleted'] ?? 0,
      highestLevelUnlocked: json['highestLevelUnlocked'] ?? 1,
      isGameUnlocked: json['isGameUnlocked'] ?? false,
    );
  }
}
