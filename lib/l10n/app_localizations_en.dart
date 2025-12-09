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
}
