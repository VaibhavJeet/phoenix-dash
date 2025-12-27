import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:super_dash/app/app.dart';
import 'package:super_dash/audio/audio.dart';
import 'package:super_dash/mock_repositories.dart';
import 'package:super_dash/settings/persistence/persistence.dart';
import 'package:super_dash/settings/settings.dart';
import 'package:super_dash/share/share.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // No Firebase initialization needed!

  final settings = SettingsController(
    persistence: LocalStorageSettingsPersistence(),
  );

  final audio = AudioController()..attachSettings(settings);

  await audio.initialize();

  final share = ShareController(
    gameUrl: 'https://superdash.flutter.dev/',
  );

  // Use mock repositories instead of Firebase
  final authenticationRepository = MockAuthenticationRepository();
  final leaderboardRepository = MockLeaderboardRepository();

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  runApp(
    App(
      audioController: audio,
      settingsController: settings,
      shareController: share,
      authenticationRepository: authenticationRepository,
      leaderboardRepository: leaderboardRepository,
    ),
  );
}
