// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ReadForge';

  @override
  String get libraryTitle => 'ReadForge';

  @override
  String get newBook => 'New Book';

  @override
  String get noBooksYet => 'No books yet';

  @override
  String get tapToCreateFirstBook =>
      'Tap the + button to create your first book';

  @override
  String get createNewBook => 'Create New Book';

  @override
  String get createBookInstructions =>
      'Fill in at least one field below. If you don\'t provide a title, AI can generate one for you based on your description or purpose.';

  @override
  String get bookTitleOptional => 'Book Title (Optional)';

  @override
  String get bookTitleHint => 'Enter a title or leave empty for AI generation';

  @override
  String get descriptionOptional => 'Description (Optional)';

  @override
  String get descriptionHint => 'Describe what the book is about';

  @override
  String get purposeOptional => 'Purpose/Learning Goal (Optional)';

  @override
  String get purposeHint => 'What do you want to learn from this book?';

  @override
  String get cancel => 'Cancel';

  @override
  String get create => 'Create';

  @override
  String get fillAtLeastOneField => 'Please fill in at least one field';

  @override
  String get generateTitleWithAI => 'Generate Title with AI?';

  @override
  String noTitleProvidedPrompt(String contentType) {
    return 'No title was provided. Would you like to use AI to generate a title based on your $contentType?';
  }

  @override
  String get skip => 'Skip';

  @override
  String get generateTitle => 'Generate Title';

  @override
  String get generateBookTitle => 'Generate Book Title';

  @override
  String get sharePromptWithAI =>
      'Share this prompt with your AI assistant (ChatGPT, Claude, etc.) to generate a title.';

  @override
  String get copy => 'Copy';

  @override
  String get pasteTitle => 'Paste Title';

  @override
  String get promptCopiedToClipboard => 'Prompt copied to clipboard';

  @override
  String get noTitleInClipboard =>
      'No title found in clipboard. Creating book with placeholder title.';

  @override
  String bookCreatedWithTitle(String title) {
    return 'Book created with AI-generated title: \"$title\"';
  }

  @override
  String get settings => 'Settings';

  @override
  String get reading => 'Reading';

  @override
  String get completed => 'Completed';

  @override
  String get draft => 'Draft';

  @override
  String errorLoadingBooks(String error) {
    return 'Error loading books: $error';
  }

  @override
  String get retry => 'Retry';

  @override
  String get untitledBook => 'Untitled Book';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get writingPreferencesSection => 'Writing Preferences';

  @override
  String get contentGenerationSection => 'Content Generation';

  @override
  String get aboutSection => 'About';

  @override
  String get writingStyleLabel => 'Writing Style';

  @override
  String get writingStyleCreative => 'Creative - Imaginative and expressive';

  @override
  String get writingStyleBalanced => 'Balanced - Moderate creativity';

  @override
  String get writingStylePrecise => 'Precise - Clear and concise';

  @override
  String get contentLanguageLabel => 'Content Language';

  @override
  String get uiLanguageLabel => 'UI Language';

  @override
  String get uiLanguageSystemDefault => 'System Default';

  @override
  String get toneLabel => 'Tone';

  @override
  String get toneCasual => 'Casual - Friendly and relaxed';

  @override
  String get toneNeutral => 'Neutral - Balanced tone';

  @override
  String get toneFormal => 'Formal - Professional and serious';

  @override
  String get vocabularyLevelLabel => 'Vocabulary Level';

  @override
  String get vocabularySimple => 'Simple - Easy to understand';

  @override
  String get vocabularyModerate => 'Moderate - Balanced vocabulary';

  @override
  String get vocabularyAdvanced => 'Advanced - Rich vocabulary';

  @override
  String get favoriteAuthorLabel => 'Favorite Author';

  @override
  String get favoriteAuthorHint => 'e.g., J.K. Rowling';

  @override
  String get favoriteAuthorDescription =>
      'Enter the name of your favorite author for AI to emulate their writing style (optional).';

  @override
  String get defaultChapterCountLabel => 'Default Chapter Count';

  @override
  String chapterCountOption(int count) {
    return '$count chapters';
  }

  @override
  String get shortBook => 'Short book';

  @override
  String get standardBook => 'Standard book';

  @override
  String get longerBook => 'Longer book';

  @override
  String get fullLengthNovel => 'Full-length novel';

  @override
  String get extendedNovel => 'Extended novel';

  @override
  String get epicLength => 'Epic length';

  @override
  String get versionLabel => 'Version';

  @override
  String get licenseLabel => 'License';

  @override
  String get mitLicense => 'MIT License';

  @override
  String get clearAuthor => 'Clear';

  @override
  String get saveAuthor => 'Save';
}
