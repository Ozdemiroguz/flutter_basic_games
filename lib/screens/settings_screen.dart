import 'package:flutter/material.dart';
import 'package:flutter_basic_games/utils/game_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GameSettings settings = GameSettings();
  String selectedColorScheme = 'Blue Ocean';
  late int snakeSpeed;
  late int memoryGridSize;
  late String difficulty;

  @override
  void initState() {
    super.initState();
    snakeSpeed = settings.snakeSpeed;
    memoryGridSize = settings.memoryGridSize;
    difficulty = settings.difficulty;

    // Find current color scheme
    GameSettings.colorSchemes.forEach((name, scheme) {
      if (scheme['primary'] == settings.primaryColor) {
        selectedColorScheme = name;
      }
    });
  }

  Future<void> saveSettings() async {
    settings.snakeSpeed = snakeSpeed;
    settings.memoryGridSize = memoryGridSize;
    settings.difficulty = difficulty;
    await settings.saveSettings();
    await settings.saveColorScheme(selectedColorScheme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Color Scheme Section
          Text(
            'Theme',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Color Scheme',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: GameSettings.colorSchemes.keys.map((schemeName) {
                      final isSelected = selectedColorScheme == schemeName;
                      final scheme = GameSettings.colorSchemes[schemeName]!;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedColorScheme = schemeName;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: scheme['primary']!.withValues(alpha: 0.2),
                            border: Border.all(
                              color: isSelected
                                  ? scheme['primary']!
                                  : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: scheme['primary'],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                schemeName,
                                style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Difficulty Section
          Text(
            'Game Settings',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Difficulty',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'Easy', label: Text('Easy')),
                      ButtonSegment(value: 'Medium', label: Text('Medium')),
                      ButtonSegment(value: 'Hard', label: Text('Hard')),
                    ],
                    selected: {difficulty},
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() {
                        difficulty = newSelection.first;
                        // Adjust speeds based on difficulty
                        switch (difficulty) {
                          case 'Easy':
                            snakeSpeed = 400;
                            break;
                          case 'Medium':
                            snakeSpeed = 300;
                            break;
                          case 'Hard':
                            snakeSpeed = 150;
                            break;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Snake Speed
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Snake Speed: ${snakeSpeed}ms',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Slider(
                    value: snakeSpeed.toDouble(),
                    min: 100,
                    max: 500,
                    divisions: 8,
                    label: '${snakeSpeed}ms',
                    onChanged: (value) {
                      setState(() {
                        snakeSpeed = value.toInt();
                      });
                    },
                  ),
                  const Text(
                    'Lower = Faster',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Memory Grid Size
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Memory Game Grid: ${memoryGridSize}x$memoryGridSize',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Slider(
                    value: memoryGridSize.toDouble(),
                    min: 2,
                    max: 6,
                    divisions: 4,
                    label: '${memoryGridSize}x$memoryGridSize',
                    onChanged: (value) {
                      setState(() {
                        memoryGridSize = value.toInt();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Save Button
          ElevatedButton(
            onPressed: () async {
              await saveSettings();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Settings saved! Restart app to see changes.'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Save Settings',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
