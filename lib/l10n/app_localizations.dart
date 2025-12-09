import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

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
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh'),
    Locale('zh', 'TW'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'ReadForge'**
  String get appTitle;

  /// Title shown in the library screen
  ///
  /// In en, this message translates to:
  /// **'ReadForge'**
  String get libraryTitle;

  /// Button to create a new book
  ///
  /// In en, this message translates to:
  /// **'New Book'**
  String get newBook;

  /// Message when library is empty
  ///
  /// In en, this message translates to:
  /// **'No books yet'**
  String get noBooksYet;

  /// Instructions for creating first book
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to create your first book'**
  String get tapToCreateFirstBook;

  /// Dialog title for creating a new book
  ///
  /// In en, this message translates to:
  /// **'Create New Book'**
  String get createNewBook;

  /// Instructions in the create book dialog
  ///
  /// In en, this message translates to:
  /// **'Fill in at least one field below. If you don\'t provide a title, AI can generate one for you based on your description or purpose.'**
  String get createBookInstructions;

  /// Label for book title field
  ///
  /// In en, this message translates to:
  /// **'Book Title (Optional)'**
  String get bookTitleOptional;

  /// Hint text for book title field
  ///
  /// In en, this message translates to:
  /// **'Enter a title or leave empty for AI generation'**
  String get bookTitleHint;

  /// Label for description field
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get descriptionOptional;

  /// Hint text for description field
  ///
  /// In en, this message translates to:
  /// **'Describe what the book is about'**
  String get descriptionHint;

  /// Label for purpose field
  ///
  /// In en, this message translates to:
  /// **'Purpose/Learning Goal (Optional)'**
  String get purposeOptional;

  /// Hint text for purpose field
  ///
  /// In en, this message translates to:
  /// **'What do you want to learn from this book?'**
  String get purposeHint;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Create button text
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// Error message when no fields are filled
  ///
  /// In en, this message translates to:
  /// **'Please fill in at least one field'**
  String get fillAtLeastOneField;

  /// Dialog title for AI title generation
  ///
  /// In en, this message translates to:
  /// **'Generate Title with AI?'**
  String get generateTitleWithAI;

  /// Prompt asking user if they want AI title generation
  ///
  /// In en, this message translates to:
  /// **'No title was provided. Would you like to use AI to generate a title based on your {contentType}?'**
  String noTitleProvidedPrompt(String contentType);

  /// Skip button text
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Button to generate title with AI
  ///
  /// In en, this message translates to:
  /// **'Generate Title'**
  String get generateTitle;

  /// Dialog title for generating book title
  ///
  /// In en, this message translates to:
  /// **'Generate Book Title'**
  String get generateBookTitle;

  /// Instructions for using AI to generate title
  ///
  /// In en, this message translates to:
  /// **'Share this prompt with your AI assistant (ChatGPT, Claude, etc.) to generate a title.'**
  String get sharePromptWithAI;

  /// Copy button text
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// Button to paste generated title
  ///
  /// In en, this message translates to:
  /// **'Paste Title'**
  String get pasteTitle;

  /// Snackbar message when prompt is copied
  ///
  /// In en, this message translates to:
  /// **'Prompt copied to clipboard'**
  String get promptCopiedToClipboard;

  /// Message when clipboard is empty
  ///
  /// In en, this message translates to:
  /// **'No title found in clipboard. Creating book with placeholder title.'**
  String get noTitleInClipboard;

  /// Success message with generated title
  ///
  /// In en, this message translates to:
  /// **'Book created with AI-generated title: \"{title}\"'**
  String bookCreatedWithTitle(String title);

  /// Settings button text
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Status: Reading
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get reading;

  /// Status: Completed
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// Status: Draft
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get draft;

  /// Error message when books fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading books: {error}'**
  String errorLoadingBooks(String error);

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Placeholder title for books without a title
  ///
  /// In en, this message translates to:
  /// **'Untitled Book'**
  String get untitledBook;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Section header for writing preferences
  ///
  /// In en, this message translates to:
  /// **'Writing Preferences'**
  String get writingPreferencesSection;

  /// Section header for content generation settings
  ///
  /// In en, this message translates to:
  /// **'Content Generation'**
  String get contentGenerationSection;

  /// Section header for about information
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// Label for writing style setting
  ///
  /// In en, this message translates to:
  /// **'Writing Style'**
  String get writingStyleLabel;

  /// Writing style option: creative
  ///
  /// In en, this message translates to:
  /// **'Creative - Imaginative and expressive'**
  String get writingStyleCreative;

  /// Writing style option: balanced
  ///
  /// In en, this message translates to:
  /// **'Balanced - Moderate creativity'**
  String get writingStyleBalanced;

  /// Writing style option: precise
  ///
  /// In en, this message translates to:
  /// **'Precise - Clear and concise'**
  String get writingStylePrecise;

  /// Label for content language setting (for AI generation)
  ///
  /// In en, this message translates to:
  /// **'Content Language'**
  String get contentLanguageLabel;

  /// Label for UI language setting
  ///
  /// In en, this message translates to:
  /// **'UI Language'**
  String get uiLanguageLabel;

  /// Option for system default UI language
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get uiLanguageSystemDefault;

  /// Label for tone setting
  ///
  /// In en, this message translates to:
  /// **'Tone'**
  String get toneLabel;

  /// Tone option: casual
  ///
  /// In en, this message translates to:
  /// **'Casual - Friendly and relaxed'**
  String get toneCasual;

  /// Tone option: neutral
  ///
  /// In en, this message translates to:
  /// **'Neutral - Balanced tone'**
  String get toneNeutral;

  /// Tone option: formal
  ///
  /// In en, this message translates to:
  /// **'Formal - Professional and serious'**
  String get toneFormal;

  /// Label for vocabulary level setting
  ///
  /// In en, this message translates to:
  /// **'Vocabulary Level'**
  String get vocabularyLevelLabel;

  /// Vocabulary level option: simple
  ///
  /// In en, this message translates to:
  /// **'Simple - Easy to understand'**
  String get vocabularySimple;

  /// Vocabulary level option: moderate
  ///
  /// In en, this message translates to:
  /// **'Moderate - Balanced vocabulary'**
  String get vocabularyModerate;

  /// Vocabulary level option: advanced
  ///
  /// In en, this message translates to:
  /// **'Advanced - Rich vocabulary'**
  String get vocabularyAdvanced;

  /// Label for favorite author setting
  ///
  /// In en, this message translates to:
  /// **'Favorite Author'**
  String get favoriteAuthorLabel;

  /// Hint text for favorite author input
  ///
  /// In en, this message translates to:
  /// **'e.g., J.K. Rowling'**
  String get favoriteAuthorHint;

  /// Description text for favorite author setting
  ///
  /// In en, this message translates to:
  /// **'Enter the name of your favorite author for AI to emulate their writing style (optional).'**
  String get favoriteAuthorDescription;

  /// Label for default chapter count setting
  ///
  /// In en, this message translates to:
  /// **'Default Chapter Count'**
  String get defaultChapterCountLabel;

  /// Chapter count option format
  ///
  /// In en, this message translates to:
  /// **'{count} chapters'**
  String chapterCountOption(int count);

  /// Chapter count label: 5 chapters
  ///
  /// In en, this message translates to:
  /// **'Short book'**
  String get shortBook;

  /// Chapter count label: 10 chapters
  ///
  /// In en, this message translates to:
  /// **'Standard book'**
  String get standardBook;

  /// Chapter count label: 15 chapters
  ///
  /// In en, this message translates to:
  /// **'Longer book'**
  String get longerBook;

  /// Chapter count label: 20 chapters
  ///
  /// In en, this message translates to:
  /// **'Full-length novel'**
  String get fullLengthNovel;

  /// Chapter count label: 25 chapters
  ///
  /// In en, this message translates to:
  /// **'Extended novel'**
  String get extendedNovel;

  /// Chapter count label: 30 chapters
  ///
  /// In en, this message translates to:
  /// **'Epic length'**
  String get epicLength;

  /// Label for version information
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get versionLabel;

  /// Label for license information
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get licenseLabel;

  /// License type
  ///
  /// In en, this message translates to:
  /// **'MIT License'**
  String get mitLicense;

  /// Button to clear favorite author
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearAuthor;

  /// Button to save favorite author
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveAuthor;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'ja',
    'ko',
    'pt',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
