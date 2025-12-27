# Phoenix Dash

An exciting endless runner platformer game built with Flutter and Flame game engine.

---

## Features

- Fast-paced endless runner gameplay
- Stomp enemies by jumping on them (like Mario!)
- Collect items: acorns, eggs, and golden feathers
- Power-up system with golden feather for extra protection
- Multiple level sections with increasing difficulty
- Local leaderboard support
- Cross-platform: Android, iOS, Web, Windows

---

## Requirements

- **Flutter**: 3.38.0 or higher
- **Dart SDK**: 3.10.1 or higher
- **Java**: 21 (for Android builds)
- **Android SDK**: 36 (compileSdk)
- **Gradle**: 8.11.1
- **Android Gradle Plugin**: 8.9.2
- **Kotlin**: 2.1.0

---

## Getting Started

### Installation

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Build and run the game

### Running the Game

```sh
# Development (recommended - no Firebase required)
flutter run --flavor development --target lib/main_no_firebase.dart

# Build APK
flutter build apk --release --flavor development -t lib/main_no_firebase.dart
```

### Available Flavors

- **development**: For development and testing
- **staging**: For staging environment
- **production**: For production release

---

## Game Controls

- **Tap/Click**: Jump
- **Double Tap**: Double jump (when powered up with golden feather)
- **Land on enemies**: Stomp to kill them and earn bonus points!

---

## Project Structure

```
lib/
├── app/              # App configuration and main widget
├── audio/            # Sound effects and music
├── game/             # Core game logic
│   ├── behaviors/    # Player behaviors
│   ├── components/   # Game components
│   ├── entities/     # Player, enemies, items
│   └── view/         # Game view widgets
├── game_intro/       # Intro screens and menus
├── leaderboard/      # Leaderboard functionality
├── score/            # Score tracking and game over
└── settings/         # Game settings
```

---

## Dependencies

| Package | Version | Description |
|---------|---------|-------------|
| Flutter | >=3.38.0 | UI framework |
| Flame | ^1.18.0 | Game engine |
| Flame Tiled | ^1.20.0 | Tiled map support |
| Bloc | ^8.1.4 | State management |
| Flutter Bloc | ^8.1.6 | Bloc widgets |
| Audioplayers | ^6.1.0 | Audio playback |

---

## Building for Release

### Android APK

```sh
flutter build apk --release --flavor development -t lib/main_no_firebase.dart
```

The APK will be at: `build/app/outputs/flutter-apk/app-development-release.apk`

### Android App Bundle

```sh
flutter build appbundle --release --flavor production -t lib/main_no_firebase.dart
```

---

## License

MIT License - See LICENSE file for details.

---

## Credits

Game engine powered by [Flame](https://flame-engine.org/)
