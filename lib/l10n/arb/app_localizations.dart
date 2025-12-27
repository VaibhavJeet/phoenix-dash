import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Text shown in the Headline of the Game Info Page
  ///
  /// In en, this message translates to:
  /// **'Fly into Super Dash, avoid the bugs, collect points, and see how far you can go!'**
  String get gameIntroPageHeadline;

  /// Text shown in the Play button of the Game Info Page
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get gameIntroPagePlayButtonText;

  /// Text shown in the title of the auto run instruction of the Game Instructions Overlay
  ///
  /// In en, this message translates to:
  /// **'Dash Auto-runs'**
  String get gameInstructionsPageAutoRunTitle;

  /// Text shown in the description of the auto run instruction of the Game Instructions Overlay
  ///
  /// In en, this message translates to:
  /// **'Welcome to Super Dash. In this game Dash runs automatically.'**
  String get gameInstructionsPageAutoRunDescription;

  /// Text shown in the title of the tap to jump instruction of the Game Instructions Overlay
  ///
  /// In en, this message translates to:
  /// **'Tap to Jump'**
  String get gameInstructionsPageTapToJumpTitle;

  /// Text shown in the description of the tap to jump instruction of the Game Instructions Overlay
  ///
  /// In en, this message translates to:
  /// **'Tap the screen to make Dash jump.'**
  String get gameInstructionsPageTapToJumpDescription;

  /// Text shown in the description of the tap to jump instruction of the Game Instructions Overlay
  ///
  /// In en, this message translates to:
  /// **'Press spacebar to make Dash jump.'**
  String get gameInstructionsPageTapToJumpDescriptionDesktop;

  /// Text shown in the title of the collect eggs and acorns instruction of the Game Instructions Overlay
  ///
  /// In en, this message translates to:
  /// **'Collect Eggs & Acorns'**
  String get gameInstructionsPageCollectEggsAcornsTitle;

  /// Text shown in the description of the collect eggs and acorns instruction of the Game Instructions Overlay
  ///
  /// In en, this message translates to:
  /// **'Get points by collecting eggs and acorns in the stage.'**
  String get gameInstructionsPageCollectEggsAcornsDescription;

  /// Text shown in the title of the powerful wings instruction of the Game Instructions Overlay
  ///
  /// In en, this message translates to:
  /// **'Powerful Wings'**
  String get gameInstructionsPagePowerfulWingsTitle;

  /// Text shown in the description of the powerful wings instruction of the Game Instructions Overlay
  ///
  /// In en, this message translates to:
  /// **'Collect the golden feather to power up Dash with Flutter. While in midair, tap to do a double jump and see Dash fly!'**
  String get gameInstructionsPagePowerfulWingsDescription;

  /// Text shown in the title of the level gates instruction of the Game Instructions Overlay
  ///
  /// In en, this message translates to:
  /// **'Level Gates'**
  String get gameInstructionsPageLevelGatesTitle;

  /// Text shown in the description of the level gates instruction of the Game Instructions Overlay
  ///
  /// In en, this message translates to:
  /// **'Advance through gates to face tougher challenges at higher stages.'**
  String get gameInstructionsPageLevelGatesDescription;

  /// Text shown in the title of the avoid bugs instruction of the Game Instructions Overlay
  ///
  /// In en, this message translates to:
  /// **'Avoid Bugs'**
  String get gameInstructionsPageAvoidBugsTitle;

  /// Text shown in the description of the avoid bugs instruction of the Game Instructions Overlay
  ///
  /// In en, this message translates to:
  /// **'No one likes bugs! Jump to dodge them and avoid taking damage.'**
  String get gameInstructionsPageAvoidBugsDescription;

  /// Title shown in the Game Info Page for mobile devices joining from a browser
  ///
  /// In en, this message translates to:
  /// **'Mobile Apps Coming Soon'**
  String get mobileAppsComingSoon;

  /// Description shown in the Game Info Page for mobile devices joining from a browser
  ///
  /// In en, this message translates to:
  /// **'Grab the '**
  String get mobileAppsComingSoonGrabThe;

  /// Description shown in the Game Info Page for mobile devices joining from a browser
  ///
  /// In en, this message translates to:
  /// **'mobile source code '**
  String get mobileAppsComingSoonMobileSourceCode;

  /// No description provided for @mobileAppsComingSoonDescription.
  ///
  /// In en, this message translates to:
  /// **'in the repo and look for the apps available for download in stores soon! Open this link on a desktop web browser to play today.'**
  String get mobileAppsComingSoonDescription;

  /// Game name
  ///
  /// In en, this message translates to:
  /// **'Super Dash'**
  String get superDash;

  /// Text shown in the game info page
  ///
  /// In en, this message translates to:
  /// **'How it\'s made'**
  String get howItsMade;

  /// Text shown in the game info popup
  ///
  /// In en, this message translates to:
  /// **'About Super Dash'**
  String get aboutSuperDash;

  /// Text shown in the game info popup
  ///
  /// In en, this message translates to:
  /// **'Learn '**
  String get learn;

  /// Text shown in the game info popup
  ///
  /// In en, this message translates to:
  /// **'how we built Super Dash'**
  String get howWeBuiltSuperDash;

  /// Text shown in the game info popup
  ///
  /// In en, this message translates to:
  /// **' in Flutter and grab the '**
  String get inFlutterAndGrabThe;

  /// Text shown in the game info popup
  ///
  /// In en, this message translates to:
  /// **'open source code.'**
  String get openSourceCode;

  /// Text shown in the game info popup
  ///
  /// In en, this message translates to:
  /// **'Other Links'**
  String get otherLinks;

  /// Text shown in the game info popup
  ///
  /// In en, this message translates to:
  /// **'Flutter Games'**
  String get flutterGames;

  /// Text shown in the game info popup
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Text shown in the game info popup
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Text shown in the score submission page
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter;

  /// Text shown in the score submission page
  ///
  /// In en, this message translates to:
  /// **'Keep it PG, use different initials'**
  String get initialsBlacklistedMessage;

  /// Text shown in the score submission page
  ///
  /// In en, this message translates to:
  /// **'Please enter three initials'**
  String get initialsErrorMessage;

  /// Text shown in the score submission page
  ///
  /// In en, this message translates to:
  /// **'There was an error submitting your score'**
  String get scoreSubmissionErrorMessage;

  /// Text shown in the share page
  ///
  /// In en, this message translates to:
  /// **'Share your Super Dash score and challenge your friends to do more!'**
  String get shareYourScore;

  /// Text shown in the share page
  ///
  /// In en, this message translates to:
  /// **'Pts'**
  String get pts;

  /// Text shown in the share page
  ///
  /// In en, this message translates to:
  /// **'Share on:'**
  String get shareOn;

  /// Text shown in the share page
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// Text shown in the share page
  ///
  /// In en, this message translates to:
  /// **'See the ranking'**
  String get seeTheRanking;

  /// Text shown in the game over page
  ///
  /// In en, this message translates to:
  /// **'Game over!'**
  String get gameOver;

  /// Text shown in the game over page
  ///
  /// In en, this message translates to:
  /// **'Better luck next time.'**
  String get betterLuckNextTime;

  /// Text shown in the game over page
  ///
  /// In en, this message translates to:
  /// **'Total Score'**
  String get totalScore;

  /// Text shown in the game over page
  ///
  /// In en, this message translates to:
  /// **'Submit score'**
  String get submitScore;

  /// Text shown in the game over page
  ///
  /// In en, this message translates to:
  /// **'Play again'**
  String get playAgain;

  /// Text shown on the game score label
  ///
  /// In en, this message translates to:
  /// **'{points} Pts'**
  String gameScoreLabel(int points);

  /// Text shown in the leaderboard page headline
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboardPageLeaderboardHeadline;

  /// Text shown in the leaderboard page when there is an error
  ///
  /// In en, this message translates to:
  /// **'There was an error while fetching the leaderboard.'**
  String get leaderboardPageLeaderboardErrorText;

  /// Text shown in the leaderboard page when there are no entries
  ///
  /// In en, this message translates to:
  /// **'No entries'**
  String get leaderboardPageLeaderboardNoEntries;

  /// Text shown in the leaderboard page go back button
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get leaderboardPageGoBackButton;

  /// Text shown in the game page
  ///
  /// In en, this message translates to:
  /// **'Tap/press Space to start'**
  String get tapToStart;

  /// Text shown in the download mobile app page
  ///
  /// In en, this message translates to:
  /// **'Fly into Super Dash, avoid the bugs, collect points, and see how far you can go!'**
  String get downloadAppMessage;

  /// Button lable for the app download
  ///
  /// In en, this message translates to:
  /// **'Download the app'**
  String get downloadAppLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
