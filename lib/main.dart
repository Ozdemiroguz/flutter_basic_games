import 'package:flutter/material.dart';
import 'package:flutter_basic_games/screens/home_screen.dart';
import 'package:flutter_basic_games/screens/settings_screen.dart';
import 'package:flutter_basic_games/games/tic_tac_toe_game.dart';
import 'package:flutter_basic_games/games/memory_game.dart';
import 'package:flutter_basic_games/games/snake_game.dart';
import 'package:flutter_basic_games/games/game_2048.dart';
import 'package:flutter_basic_games/utils/game_settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GameSettings().loadSettings();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final settings = GameSettings();

    return MaterialApp(
      title: 'Flutter Basic Games',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: settings.primaryColor,
          secondary: settings.secondaryColor,
        ),
        scaffoldBackgroundColor: settings.backgroundColor,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/tic_tac_toe': (context) => const TicTacToeGame(),
        '/memory_game': (context) => const MemoryGame(),
        '/snake_game': (context) => const SnakeGame(),
        '/2048_game': (context) => const Game2048(),
      },
    );
  }
}
