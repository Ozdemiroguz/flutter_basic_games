# Flutter Basic Games

A mobile application featuring multiple customizable simple games with progressive level systems, built with Flutter.

## Features

### Games

1. **Tic Tac Toe**
   - Classic X and O game
   - Multiple difficulty levels with AI opponents
   - Progressive challenge system
   - Unlock levels by winning previous ones

2. **Memory Game**
   - Card matching puzzle game
   - Progressive difficulty (grid size increases with levels)
   - Time-based challenges in advanced levels
   - Star rating system based on moves

3. **Snake**
   - Classic snake game
   - Level-based challenges with increasing speed
   - Obstacle courses in higher levels
   - Score targets to unlock next levels

4. **Sky Catcher**
   - Catch falling objects in your basket
   - Avoid dangerous bombs
   - Progressive speed and difficulty
   - Multiple object types with different point values

5. **2048**
   - Number merging puzzle game
   - Level-based score goals
   - Limited moves in challenge levels
   - Progressive difficulty

### Level System

- **Progressive Unlocking**: Complete levels to unlock new challenges
- **Game Unlocking**: Complete enough levels to unlock new games
  - Tic Tac Toe: Available from start
  - Memory Game: Unlock after completing 3 Tic Tac Toe levels
  - Snake: Unlock after completing 5 total levels
  - Sky Catcher: Unlock after completing 7 total levels
  - 2048: Unlock after completing 10 total levels
- **Star Rating**: Earn 1-3 stars based on performance
- **Level Selection**: Choose from unlocked levels
- **Progress Tracking**: Your progress is saved automatically

### Customization Options

- **Theme Colors**: 4 different color schemes
  - Blue Ocean
  - Forest
  - Sunset
  - Dark Mode

- **Game Settings**: Adjustable difficulty and preferences
- **Progress Reset**: Option to reset all progress

## Project Structure

```
lib/
├── main.dart                     # Main entry point
├── screens/
│   ├── home_screen.dart          # Main menu
│   ├── settings_screen.dart      # Settings
│   └── level_selection_screen.dart # Level selection
├── games/
│   ├── tic_tac_toe_game.dart     # Tic Tac Toe game
│   ├── memory_game.dart          # Memory game
│   ├── snake_game.dart           # Snake game
│   └── game_2048.dart            # 2048 game
├── models/
│   ├── game_model.dart           # Game data model
│   ├── level_model.dart          # Level data model
│   └── game_progress.dart        # Progress tracking
├── widgets/
│   ├── game_card.dart            # Game card widget
│   └── level_card.dart           # Level card widget
└── utils/
    ├── game_settings.dart        # Game settings manager
    └── progress_manager.dart     # Progress manager
```

## Installation

### Requirements

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android SDK / Xcode (depending on platform)

### Steps

1. Clone the repository:
```bash
git clone https://github.com/Ozdemiroguz/flutter_basic_games.git
cd flutter_basic_games
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run
```

## Usage

### Main Menu
- When you open the app, you'll see the main menu with all games
- Locked games are shown with a lock icon
- Complete levels in unlocked games to unlock new games
- Tap on an unlocked game to see its levels

### Level Selection
- Each game has multiple levels with increasing difficulty
- Levels are unlocked progressively by completing previous ones
- Each level shows your best performance (stars earned)
- Tap on an unlocked level to start playing

### Settings
- Tap the settings icon in the top right corner
- Customize color theme and game preferences
- Reset all progress if you want to start over
- Tap "Save Settings" to save your changes

### Games

**Tic Tac Toe:**
- Level 1-3: Play against easy AI
- Level 4-6: Medium difficulty AI
- Level 7-10: Hard AI that's challenging to beat
- Earn 3 stars for perfect wins (no draws)

**Memory Game:**
- Level 1-3: 2x2 and 3x3 grids
- Level 4-6: 4x4 grids
- Level 7-10: 5x5 and 6x6 grids
- Stars based on number of moves

**Snake:**
- Level 1-3: Slow speed, simple maze
- Level 4-6: Medium speed with obstacles
- Level 7-10: Fast speed, complex mazes
- Reach target score to complete level

**Sky Catcher:**
- Level 1-3: Slow falling, few bombs
- Level 4-6: Faster speed, more objects
- Level 7-10: Extreme speed, danger zone
- Catch good objects, avoid bombs
- Stars based on score achievement

**2048:**
- Level 1-3: Reach 512
- Level 4-6: Reach 1024
- Level 7-10: Reach 2048 and beyond
- Stars based on score and efficiency

## Contributing

1. Fork this repository
2. Create a feature branch (`git checkout -b feature/NewFeature`)
3. Commit your changes (`git commit -m 'Add new feature'`)
4. Push to the branch (`git push origin feature/NewFeature`)
5. Create a Pull Request

## License

This project is open source and free to use.

## Contact

For questions or suggestions, please open an issue.

## Screenshots

(Screenshots will be added after the app is running)

## Technical Details

- **State Management**: StatefulWidget with Provider pattern
- **Storage**: SharedPreferences for settings and progress
- **UI Framework**: Material Design 3
- **Minimum SDK**: Flutter 3.0.0
- **Features**:
  - Progressive level system
  - Star rating system
  - Unlockable content
  - Persistent progress tracking

## Future Enhancements

- [ ] More games
- [ ] Sound effects and music
- [ ] Online multiplayer
- [ ] Leaderboards
- [ ] Achievement system
- [ ] Daily challenges
- [ ] Hints and power-ups
