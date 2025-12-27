// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get gameIntroPageHeadline =>
      'Fly into Super Dash, avoid the bugs, collect points, and see how far you can go!';

  @override
  String get gameIntroPagePlayButtonText => 'Play';

  @override
  String get gameInstructionsPageAutoRunTitle => 'Dash Auto-runs';

  @override
  String get gameInstructionsPageAutoRunDescription =>
      'Welcome to Super Dash. In this game Dash runs automatically.';

  @override
  String get gameInstructionsPageTapToJumpTitle => 'Tap to Jump';

  @override
  String get gameInstructionsPageTapToJumpDescription =>
      'Tap the screen to make Dash jump.';

  @override
  String get gameInstructionsPageTapToJumpDescriptionDesktop =>
      'Press spacebar to make Dash jump.';

  @override
  String get gameInstructionsPageCollectEggsAcornsTitle =>
      'Collect Eggs & Acorns';

  @override
  String get gameInstructionsPageCollectEggsAcornsDescription =>
      'Get points by collecting eggs and acorns in the stage.';

  @override
  String get gameInstructionsPagePowerfulWingsTitle => 'Powerful Wings';

  @override
  String get gameInstructionsPagePowerfulWingsDescription =>
      'Collect the golden feather to power up Dash with Flutter. While in midair, tap to do a double jump and see Dash fly!';

  @override
  String get gameInstructionsPageLevelGatesTitle => 'Level Gates';

  @override
  String get gameInstructionsPageLevelGatesDescription =>
      'Advance through gates to face tougher challenges at higher stages.';

  @override
  String get gameInstructionsPageAvoidBugsTitle => 'Avoid Bugs';

  @override
  String get gameInstructionsPageAvoidBugsDescription =>
      'No one likes bugs! Jump to dodge them and avoid taking damage.';

  @override
  String get mobileAppsComingSoon => 'Mobile Apps Coming Soon';

  @override
  String get mobileAppsComingSoonGrabThe => 'Grab the ';

  @override
  String get mobileAppsComingSoonMobileSourceCode => 'mobile source code ';

  @override
  String get mobileAppsComingSoonDescription =>
      'in the repo and look for the apps available for download in stores soon! Open this link on a desktop web browser to play today.';

  @override
  String get superDash => 'Super Dash';

  @override
  String get howItsMade => 'How it\'s made';

  @override
  String get aboutSuperDash => 'About Super Dash';

  @override
  String get learn => 'Learn ';

  @override
  String get howWeBuiltSuperDash => 'how we built Super Dash';

  @override
  String get inFlutterAndGrabThe => ' in Flutter and grab the ';

  @override
  String get openSourceCode => 'open source code.';

  @override
  String get otherLinks => 'Other Links';

  @override
  String get flutterGames => 'Flutter Games';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get enter => 'Enter';

  @override
  String get initialsBlacklistedMessage => 'Keep it PG, use different initials';

  @override
  String get initialsErrorMessage => 'Please enter three initials';

  @override
  String get scoreSubmissionErrorMessage =>
      'There was an error submitting your score';

  @override
  String get shareYourScore =>
      'Share your Super Dash score and challenge your friends to do more!';

  @override
  String get pts => 'Pts';

  @override
  String get shareOn => 'Share on:';

  @override
  String get share => 'Share';

  @override
  String get seeTheRanking => 'See the ranking';

  @override
  String get gameOver => 'Game over!';

  @override
  String get betterLuckNextTime => 'Better luck next time.';

  @override
  String get totalScore => 'Total Score';

  @override
  String get submitScore => 'Submit score';

  @override
  String get playAgain => 'Play again';

  @override
  String gameScoreLabel(int points) {
    return '$points Pts';
  }

  @override
  String get leaderboardPageLeaderboardHeadline => 'Leaderboard';

  @override
  String get leaderboardPageLeaderboardErrorText =>
      'There was an error while fetching the leaderboard.';

  @override
  String get leaderboardPageLeaderboardNoEntries => 'No entries';

  @override
  String get leaderboardPageGoBackButton => 'Go back';

  @override
  String get tapToStart => 'Tap/press Space to start';

  @override
  String get downloadAppMessage =>
      'Fly into Super Dash, avoid the bugs, collect points, and see how far you can go!';

  @override
  String get downloadAppLabel => 'Download the app';
}
