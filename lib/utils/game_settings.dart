import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameSettings {
  static final GameSettings _instance = GameSettings._internal();
  factory GameSettings() => _instance;
  GameSettings._internal();

  // Theme colors
  Color primaryColor = Colors.blue;
  Color secondaryColor = Colors.orange;
  Color backgroundColor = Colors.white;

  // Difficulty settings
  int snakeSpeed = 300; // milliseconds
  int memoryGridSize = 4; // 4x4 grid
  String difficulty = 'Medium'; // Easy, Medium, Hard

  // Available color schemes
  static const Map<String, Map<String, Color>> colorSchemes = {
    'Blue Ocean': {
      'primary': Colors.blue,
      'secondary': Colors.orange,
      'background': Colors.white,
    },
    'Forest': {
      'primary': Colors.green,
      'secondary': Colors.brown,
      'background': Color(0xFFF5F5DC),
    },
    'Sunset': {
      'primary': Colors.deepOrange,
      'secondary': Colors.purple,
      'background': Color(0xFFFFF8DC),
    },
    'Dark Mode': {
      'primary': Colors.indigo,
      'secondary': Colors.amber,
      'background': Color(0xFF1E1E1E),
    },
  };

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final scheme = prefs.getString('colorScheme') ?? 'Blue Ocean';
    setColorScheme(scheme);
    snakeSpeed = prefs.getInt('snakeSpeed') ?? 300;
    memoryGridSize = prefs.getInt('memoryGridSize') ?? 4;
    difficulty = prefs.getString('difficulty') ?? 'Medium';
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('snakeSpeed', snakeSpeed);
    await prefs.setInt('memoryGridSize', memoryGridSize);
    await prefs.setString('difficulty', difficulty);
  }

  void setColorScheme(String schemeName) {
    final scheme = colorSchemes[schemeName] ?? colorSchemes['Blue Ocean']!;
    primaryColor = scheme['primary']!;
    secondaryColor = scheme['secondary']!;
    backgroundColor = scheme['background']!;
  }

  Future<void> saveColorScheme(String schemeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('colorScheme', schemeName);
    setColorScheme(schemeName);
  }
}
