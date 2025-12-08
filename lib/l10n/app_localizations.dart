import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
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
    Locale('en'),
    Locale('es'),
    Locale('zh'),
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
      <String>['en', 'es', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
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
