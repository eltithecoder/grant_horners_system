import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sq.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('sq'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Bible Track'**
  String get appTitle;

  /// No description provided for @todaysReadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Reading'**
  String get todaysReadingTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsIntro.
  ///
  /// In en, this message translates to:
  /// **'Use + and – to set where you are now in each list. This will be the chapter you see today.'**
  String get settingsIntro;

  /// No description provided for @readingPositionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reading positions'**
  String get readingPositionsTitle;

  /// No description provided for @readingPositionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust your place in each list.'**
  String get readingPositionsSubtitle;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the app language (for localization).'**
  String get languageSubtitle;

  /// No description provided for @languageEnglishLabel.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglishLabel;

  /// No description provided for @languageAlbanianLabel.
  ///
  /// In en, this message translates to:
  /// **'Shqip'**
  String get languageAlbanianLabel;

  /// No description provided for @bibleTranslationTitle.
  ///
  /// In en, this message translates to:
  /// **'Bible translation'**
  String get bibleTranslationTitle;

  /// No description provided for @bibleTranslationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Used for links and reading.'**
  String get bibleTranslationSubtitle;

  /// No description provided for @useBiblaTitle.
  ///
  /// In en, this message translates to:
  /// **'Use bibla.al for AL translations'**
  String get useBiblaTitle;

  /// No description provided for @useBiblaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open bibla.al when using AL/ALBB.'**
  String get useBiblaSubtitle;

  /// No description provided for @savingLabel.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get savingLabel;

  /// No description provided for @saveAndBack.
  ///
  /// In en, this message translates to:
  /// **'Save & Back'**
  String get saveAndBack;

  /// No description provided for @chapterLabel.
  ///
  /// In en, this message translates to:
  /// **'{book} {chapter}'**
  String chapterLabel(String book, int chapter);

  /// No description provided for @readingListGospels.
  ///
  /// In en, this message translates to:
  /// **'Gospels'**
  String get readingListGospels;

  /// No description provided for @readingListPentateuch.
  ///
  /// In en, this message translates to:
  /// **'Pentateuch'**
  String get readingListPentateuch;

  /// No description provided for @readingListPaulineMajor.
  ///
  /// In en, this message translates to:
  /// **'Pauline Epistles (Major)'**
  String get readingListPaulineMajor;

  /// No description provided for @readingListPaulineMinor.
  ///
  /// In en, this message translates to:
  /// **'Pauline Epistles (Minor) & General Epistles'**
  String get readingListPaulineMinor;

  /// No description provided for @readingListWisdom.
  ///
  /// In en, this message translates to:
  /// **'Wisdom Literature'**
  String get readingListWisdom;

  /// No description provided for @readingListPsalms.
  ///
  /// In en, this message translates to:
  /// **'Psalms'**
  String get readingListPsalms;

  /// No description provided for @readingListProverbs.
  ///
  /// In en, this message translates to:
  /// **'Proverbs'**
  String get readingListProverbs;

  /// No description provided for @readingListHistory.
  ///
  /// In en, this message translates to:
  /// **'History of Israel'**
  String get readingListHistory;

  /// No description provided for @readingListProphets.
  ///
  /// In en, this message translates to:
  /// **'Major & Minor Prophets'**
  String get readingListProphets;

  /// No description provided for @readingListActs.
  ///
  /// In en, this message translates to:
  /// **'Acts'**
  String get readingListActs;

  /// No description provided for @bookGenesis.
  ///
  /// In en, this message translates to:
  /// **'Genesis'**
  String get bookGenesis;

  /// No description provided for @bookExodus.
  ///
  /// In en, this message translates to:
  /// **'Exodus'**
  String get bookExodus;

  /// No description provided for @bookLeviticus.
  ///
  /// In en, this message translates to:
  /// **'Leviticus'**
  String get bookLeviticus;

  /// No description provided for @bookNumbers.
  ///
  /// In en, this message translates to:
  /// **'Numbers'**
  String get bookNumbers;

  /// No description provided for @bookDeuteronomy.
  ///
  /// In en, this message translates to:
  /// **'Deuteronomy'**
  String get bookDeuteronomy;

  /// No description provided for @bookJoshua.
  ///
  /// In en, this message translates to:
  /// **'Joshua'**
  String get bookJoshua;

  /// No description provided for @bookJudges.
  ///
  /// In en, this message translates to:
  /// **'Judges'**
  String get bookJudges;

  /// No description provided for @bookRuth.
  ///
  /// In en, this message translates to:
  /// **'Ruth'**
  String get bookRuth;

  /// No description provided for @book1Samuel.
  ///
  /// In en, this message translates to:
  /// **'1 Samuel'**
  String get book1Samuel;

  /// No description provided for @book2Samuel.
  ///
  /// In en, this message translates to:
  /// **'2 Samuel'**
  String get book2Samuel;

  /// No description provided for @book1Kings.
  ///
  /// In en, this message translates to:
  /// **'1 Kings'**
  String get book1Kings;

  /// No description provided for @book2Kings.
  ///
  /// In en, this message translates to:
  /// **'2 Kings'**
  String get book2Kings;

  /// No description provided for @book1Chronicles.
  ///
  /// In en, this message translates to:
  /// **'1 Chronicles'**
  String get book1Chronicles;

  /// No description provided for @book2Chronicles.
  ///
  /// In en, this message translates to:
  /// **'2 Chronicles'**
  String get book2Chronicles;

  /// No description provided for @bookEzra.
  ///
  /// In en, this message translates to:
  /// **'Ezra'**
  String get bookEzra;

  /// No description provided for @bookNehemiah.
  ///
  /// In en, this message translates to:
  /// **'Nehemiah'**
  String get bookNehemiah;

  /// No description provided for @bookEsther.
  ///
  /// In en, this message translates to:
  /// **'Esther'**
  String get bookEsther;

  /// No description provided for @bookJob.
  ///
  /// In en, this message translates to:
  /// **'Job'**
  String get bookJob;

  /// No description provided for @bookPsalms.
  ///
  /// In en, this message translates to:
  /// **'Psalms'**
  String get bookPsalms;

  /// No description provided for @bookProverbs.
  ///
  /// In en, this message translates to:
  /// **'Proverbs'**
  String get bookProverbs;

  /// No description provided for @bookEcclesiastes.
  ///
  /// In en, this message translates to:
  /// **'Ecclesiastes'**
  String get bookEcclesiastes;

  /// No description provided for @bookSongOfSongs.
  ///
  /// In en, this message translates to:
  /// **'Song of Songs'**
  String get bookSongOfSongs;

  /// No description provided for @bookIsaiah.
  ///
  /// In en, this message translates to:
  /// **'Isaiah'**
  String get bookIsaiah;

  /// No description provided for @bookJeremiah.
  ///
  /// In en, this message translates to:
  /// **'Jeremiah'**
  String get bookJeremiah;

  /// No description provided for @bookLamentations.
  ///
  /// In en, this message translates to:
  /// **'Lamentations'**
  String get bookLamentations;

  /// No description provided for @bookEzekiel.
  ///
  /// In en, this message translates to:
  /// **'Ezekiel'**
  String get bookEzekiel;

  /// No description provided for @bookDaniel.
  ///
  /// In en, this message translates to:
  /// **'Daniel'**
  String get bookDaniel;

  /// No description provided for @bookHosea.
  ///
  /// In en, this message translates to:
  /// **'Hosea'**
  String get bookHosea;

  /// No description provided for @bookJoel.
  ///
  /// In en, this message translates to:
  /// **'Joel'**
  String get bookJoel;

  /// No description provided for @bookAmos.
  ///
  /// In en, this message translates to:
  /// **'Amos'**
  String get bookAmos;

  /// No description provided for @bookObadiah.
  ///
  /// In en, this message translates to:
  /// **'Obadiah'**
  String get bookObadiah;

  /// No description provided for @bookJonah.
  ///
  /// In en, this message translates to:
  /// **'Jonah'**
  String get bookJonah;

  /// No description provided for @bookMicah.
  ///
  /// In en, this message translates to:
  /// **'Micah'**
  String get bookMicah;

  /// No description provided for @bookNahum.
  ///
  /// In en, this message translates to:
  /// **'Nahum'**
  String get bookNahum;

  /// No description provided for @bookHabakkuk.
  ///
  /// In en, this message translates to:
  /// **'Habakkuk'**
  String get bookHabakkuk;

  /// No description provided for @bookZephaniah.
  ///
  /// In en, this message translates to:
  /// **'Zephaniah'**
  String get bookZephaniah;

  /// No description provided for @bookHaggai.
  ///
  /// In en, this message translates to:
  /// **'Haggai'**
  String get bookHaggai;

  /// No description provided for @bookZechariah.
  ///
  /// In en, this message translates to:
  /// **'Zechariah'**
  String get bookZechariah;

  /// No description provided for @bookMalachi.
  ///
  /// In en, this message translates to:
  /// **'Malachi'**
  String get bookMalachi;

  /// No description provided for @bookMatthew.
  ///
  /// In en, this message translates to:
  /// **'Matthew'**
  String get bookMatthew;

  /// No description provided for @bookMark.
  ///
  /// In en, this message translates to:
  /// **'Mark'**
  String get bookMark;

  /// No description provided for @bookLuke.
  ///
  /// In en, this message translates to:
  /// **'Luke'**
  String get bookLuke;

  /// No description provided for @bookJohn.
  ///
  /// In en, this message translates to:
  /// **'John'**
  String get bookJohn;

  /// No description provided for @bookActs.
  ///
  /// In en, this message translates to:
  /// **'Acts'**
  String get bookActs;

  /// No description provided for @bookRomans.
  ///
  /// In en, this message translates to:
  /// **'Romans'**
  String get bookRomans;

  /// No description provided for @book1Corinthians.
  ///
  /// In en, this message translates to:
  /// **'1 Corinthians'**
  String get book1Corinthians;

  /// No description provided for @book2Corinthians.
  ///
  /// In en, this message translates to:
  /// **'2 Corinthians'**
  String get book2Corinthians;

  /// No description provided for @bookGalatians.
  ///
  /// In en, this message translates to:
  /// **'Galatians'**
  String get bookGalatians;

  /// No description provided for @bookEphesians.
  ///
  /// In en, this message translates to:
  /// **'Ephesians'**
  String get bookEphesians;

  /// No description provided for @bookPhilippians.
  ///
  /// In en, this message translates to:
  /// **'Philippians'**
  String get bookPhilippians;

  /// No description provided for @bookColossians.
  ///
  /// In en, this message translates to:
  /// **'Colossians'**
  String get bookColossians;

  /// No description provided for @book1Thessalonians.
  ///
  /// In en, this message translates to:
  /// **'1 Thessalonians'**
  String get book1Thessalonians;

  /// No description provided for @book2Thessalonians.
  ///
  /// In en, this message translates to:
  /// **'2 Thessalonians'**
  String get book2Thessalonians;

  /// No description provided for @book1Timothy.
  ///
  /// In en, this message translates to:
  /// **'1 Timothy'**
  String get book1Timothy;

  /// No description provided for @book2Timothy.
  ///
  /// In en, this message translates to:
  /// **'2 Timothy'**
  String get book2Timothy;

  /// No description provided for @bookTitus.
  ///
  /// In en, this message translates to:
  /// **'Titus'**
  String get bookTitus;

  /// No description provided for @bookPhilemon.
  ///
  /// In en, this message translates to:
  /// **'Philemon'**
  String get bookPhilemon;

  /// No description provided for @bookHebrews.
  ///
  /// In en, this message translates to:
  /// **'Hebrews'**
  String get bookHebrews;

  /// No description provided for @bookJames.
  ///
  /// In en, this message translates to:
  /// **'James'**
  String get bookJames;

  /// No description provided for @book1Peter.
  ///
  /// In en, this message translates to:
  /// **'1 Peter'**
  String get book1Peter;

  /// No description provided for @book2Peter.
  ///
  /// In en, this message translates to:
  /// **'2 Peter'**
  String get book2Peter;

  /// No description provided for @book1John.
  ///
  /// In en, this message translates to:
  /// **'1 John'**
  String get book1John;

  /// No description provided for @book2John.
  ///
  /// In en, this message translates to:
  /// **'2 John'**
  String get book2John;

  /// No description provided for @book3John.
  ///
  /// In en, this message translates to:
  /// **'3 John'**
  String get book3John;

  /// No description provided for @bookJude.
  ///
  /// In en, this message translates to:
  /// **'Jude'**
  String get bookJude;

  /// No description provided for @bookRevelation.
  ///
  /// In en, this message translates to:
  /// **'Revelation'**
  String get bookRevelation;
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
      <String>['en', 'sq'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sq':
      return AppLocalizationsSq();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
