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

  /// Book details screen title when book is null
  ///
  /// In en, this message translates to:
  /// **'Book Details'**
  String get bookDetails;

  /// Loading state text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Error state text
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Message when book is not found
  ///
  /// In en, this message translates to:
  /// **'Book not found'**
  String get bookNotFound;

  /// Error message with details
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorMessage(String error);

  /// Author attribution text
  ///
  /// In en, this message translates to:
  /// **'by {author}'**
  String byAuthor(String author);

  /// Reading progress percentage
  ///
  /// In en, this message translates to:
  /// **'{percent}% Complete'**
  String percentComplete(String percent);

  /// Table of contents section title
  ///
  /// In en, this message translates to:
  /// **'Table of Contents'**
  String get tableOfContents;

  /// Button to generate table of contents
  ///
  /// In en, this message translates to:
  /// **'Generate TOC'**
  String get generateTOC;

  /// Message when no chapters exist
  ///
  /// In en, this message translates to:
  /// **'No chapters yet'**
  String get noChaptersYet;

  /// Instructions for generating TOC
  ///
  /// In en, this message translates to:
  /// **'Generate a Table of Contents using AI to get started'**
  String get generateTOCPrompt;

  /// Error message when chapters fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading chapters: {error}'**
  String errorLoadingChapters(String error);

  /// Dialog title for TOC generation
  ///
  /// In en, this message translates to:
  /// **'Generate Table of Contents'**
  String get generateTableOfContents;

  /// Instructions for sharing TOC prompt
  ///
  /// In en, this message translates to:
  /// **'Share this prompt with your preferred AI assistant (ChatGPT, Claude, etc.) to generate a table of contents.'**
  String get shareTOCPromptMessage;

  /// Message about pasting response
  ///
  /// In en, this message translates to:
  /// **'After getting the response, come back and paste it here.'**
  String get afterGenerationMessage;

  /// Share button text
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// Snackbar message after sharing prompt
  ///
  /// In en, this message translates to:
  /// **'Prompt shared! Paste the response when ready.'**
  String get promptSharedMessage;

  /// Snackbar message after copying prompt
  ///
  /// In en, this message translates to:
  /// **'Prompt copied to clipboard'**
  String get promptCopied;

  /// Dialog title for pasting LLM response
  ///
  /// In en, this message translates to:
  /// **'Paste LLM Response'**
  String get pasteLLMResponse;

  /// Instructions for pasting response
  ///
  /// In en, this message translates to:
  /// **'Paste the response from your AI assistant:'**
  String get pasteResponseInstructions;

  /// Hint text for paste field
  ///
  /// In en, this message translates to:
  /// **'Paste response here...\n\nSupports both JSON and plain text formats'**
  String get pasteHint;

  /// Import button text
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// Success message after importing chapters
  ///
  /// In en, this message translates to:
  /// **'Successfully imported {count} chapters!'**
  String chaptersImported(int count);

  /// Error message when importing fails
  ///
  /// In en, this message translates to:
  /// **'Error importing chapters: {error}'**
  String errorImportingChapters(String error);

  /// Title for parse error dialog
  ///
  /// In en, this message translates to:
  /// **'Parse Error'**
  String get parseError;

  /// Default parse error message
  ///
  /// In en, this message translates to:
  /// **'Could not parse the response. Please make sure the response is in the correct format.'**
  String get parseErrorMessage;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Try again button text
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// Menu option to edit book
  ///
  /// In en, this message translates to:
  /// **'Edit Book Details'**
  String get editBookDetails;

  /// Menu option to export book
  ///
  /// In en, this message translates to:
  /// **'Export Book'**
  String get exportBook;

  /// Menu option to delete book
  ///
  /// In en, this message translates to:
  /// **'Delete Book'**
  String get deleteBook;

  /// Title field label
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// Author field label
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get author;

  /// Description field label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Success message after updating book
  ///
  /// In en, this message translates to:
  /// **'Book updated successfully'**
  String get bookUpdated;

  /// Confirmation message for deleting book
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"? This action cannot be undone.'**
  String confirmDeleteBook(String title);

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Message after deleting book
  ///
  /// In en, this message translates to:
  /// **'Deleted \"{title}\"'**
  String bookDeleted(String title);

  /// Export dialog message
  ///
  /// In en, this message translates to:
  /// **'Book exported as JSON. Copy the text below:'**
  String get bookExported;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Snackbar message after copying
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// Reader screen default title
  ///
  /// In en, this message translates to:
  /// **'Reader'**
  String get reader;

  /// Bookmarks tooltip
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarks;

  /// Highlights tooltip
  ///
  /// In en, this message translates to:
  /// **'Highlights'**
  String get highlights;

  /// Notes tooltip
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// Message when chapter is not found
  ///
  /// In en, this message translates to:
  /// **'Chapter not found'**
  String get chapterNotFound;

  /// Message when chapter has no content
  ///
  /// In en, this message translates to:
  /// **'No content yet'**
  String get noContentYet;

  /// Instructions for generating content
  ///
  /// In en, this message translates to:
  /// **'Generate content for this chapter using AI'**
  String get generateContentPrompt;

  /// Button to generate chapter content
  ///
  /// In en, this message translates to:
  /// **'Generate Content'**
  String get generateContent;

  /// Previous chapter button
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Next chapter button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Font size label
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// Theme label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// Sepia theme option
  ///
  /// In en, this message translates to:
  /// **'Sepia'**
  String get sepia;

  /// Font family label
  ///
  /// In en, this message translates to:
  /// **'Font Family'**
  String get fontFamily;

  /// System font option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// Serif font option
  ///
  /// In en, this message translates to:
  /// **'Serif'**
  String get serif;

  /// Sans serif font option
  ///
  /// In en, this message translates to:
  /// **'Sans'**
  String get sans;

  /// Dialog title for content generation
  ///
  /// In en, this message translates to:
  /// **'Generate Chapter Content'**
  String get generateChapterContent;

  /// Instructions for sharing chapter prompt
  ///
  /// In en, this message translates to:
  /// **'Share this prompt with your preferred AI assistant (ChatGPT, Claude, etc.) to generate chapter content.'**
  String get shareChapterPromptMessage;

  /// Dialog title for pasting chapter content
  ///
  /// In en, this message translates to:
  /// **'Paste Chapter Content'**
  String get pasteChapterContent;

  /// Success message after importing content
  ///
  /// In en, this message translates to:
  /// **'Chapter content imported successfully!'**
  String get contentImported;

  /// Error message when importing content fails
  ///
  /// In en, this message translates to:
  /// **'Error importing content: {error}'**
  String errorImportingContent(String error);

  /// Add note dialog title and tooltip
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNote;

  /// Add bookmark tooltip
  ///
  /// In en, this message translates to:
  /// **'Add Bookmark'**
  String get addBookmark;

  /// Snackbar message after adding bookmark
  ///
  /// In en, this message translates to:
  /// **'Bookmark added'**
  String get bookmarkAdded;

  /// Error message when adding bookmark fails
  ///
  /// In en, this message translates to:
  /// **'Error adding bookmark: {error}'**
  String errorAddingBookmark(String error);

  /// Snackbar message after adding note
  ///
  /// In en, this message translates to:
  /// **'Note added'**
  String get noteAdded;

  /// Error message when adding note fails
  ///
  /// In en, this message translates to:
  /// **'Error adding note: {error}'**
  String errorAddingNote(String error);

  /// Highlight button label
  ///
  /// In en, this message translates to:
  /// **'Highlight'**
  String get highlight;

  /// Dialog title for highlighting text
  ///
  /// In en, this message translates to:
  /// **'Highlight Text'**
  String get highlightText;

  /// Label for color selection
  ///
  /// In en, this message translates to:
  /// **'Select color:'**
  String get selectColor;

  /// Snackbar message after adding highlight
  ///
  /// In en, this message translates to:
  /// **'Highlight added'**
  String get highlightAdded;

  /// Error message when adding highlight fails
  ///
  /// In en, this message translates to:
  /// **'Error adding highlight: {error}'**
  String errorAddingHighlight(String error);

  /// Success message when book title is updated from TOC response
  ///
  /// In en, this message translates to:
  /// **'Book title updated to: \"{title}\"'**
  String bookTitleUpdated(String title);

  /// Button/tooltip for TTS read aloud feature
  ///
  /// In en, this message translates to:
  /// **'Read Aloud'**
  String get readAloud;

  /// Play button for TTS
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// Pause button for TTS
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// Stop button for TTS
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// Label for speech speed control
  ///
  /// In en, this message translates to:
  /// **'Speech Speed'**
  String get speechSpeed;

  /// Label for slow speed
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get slow;

  /// Label for normal speed
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// Label for fast speed
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get fast;

  /// Title for TTS settings dialog
  ///
  /// In en, this message translates to:
  /// **'Read Aloud Settings'**
  String get ttsSettings;

  /// Error message for TTS failures
  ///
  /// In en, this message translates to:
  /// **'Text-to-speech error: {error}'**
  String ttsError(String error);

  /// Info message about background audio playback
  ///
  /// In en, this message translates to:
  /// **'Audio will continue even with screen off'**
  String get audioScreenOffInfo;

  /// Tooltip for rewind button
  ///
  /// In en, this message translates to:
  /// **'Rewind 10 seconds'**
  String get rewind;

  /// Tooltip for forward button
  ///
  /// In en, this message translates to:
  /// **'Forward 10 seconds'**
  String get forward;

  /// Button label for highlighting selected text
  ///
  /// In en, this message translates to:
  /// **'Highlight Selected Text'**
  String get highlightSelected;

  /// Title for TTS player screen
  ///
  /// In en, this message translates to:
  /// **'Text to Speech'**
  String get textToSpeech;

  /// Label for playback speed control
  ///
  /// In en, this message translates to:
  /// **'Playback Speed'**
  String get playbackSpeed;
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
