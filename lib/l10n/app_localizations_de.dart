// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'ReadForge';

  @override
  String get libraryTitle => 'ReadForge';

  @override
  String get newBook => 'Neues Buch';

  @override
  String get noBooksYet => 'Noch keine Bücher';

  @override
  String get tapToCreateFirstBook =>
      'Tippen Sie auf die + Schaltfläche, um Ihr erstes Buch zu erstellen';

  @override
  String get createNewBook => 'Neues Buch Erstellen';

  @override
  String get createBookInstructions =>
      'Füllen Sie mindestens ein Feld unten aus. Wenn Sie keinen Titel angeben, kann die KI einen für Sie basierend auf Ihrer Beschreibung oder Ihrem Zweck generieren.';

  @override
  String get bookTitleOptional => 'Buchtitel (Optional)';

  @override
  String get bookTitleHint =>
      'Geben Sie einen Titel ein oder lassen Sie es leer für KI-Generierung';

  @override
  String get descriptionOptional => 'Beschreibung (Optional)';

  @override
  String get descriptionHint => 'Beschreiben Sie, worum es in dem Buch geht';

  @override
  String get purposeOptional => 'Zweck/Lernziel (Optional)';

  @override
  String get purposeHint => 'Was möchten Sie aus diesem Buch lernen?';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get create => 'Erstellen';

  @override
  String get fillAtLeastOneField => 'Bitte füllen Sie mindestens ein Feld aus';

  @override
  String get generateTitleWithAI => 'Titel mit KI Generieren?';

  @override
  String noTitleProvidedPrompt(String contentType) {
    return 'Kein Titel angegeben. Möchten Sie die KI verwenden, um einen Titel basierend auf Ihrer $contentType zu generieren?';
  }

  @override
  String get skip => 'Überspringen';

  @override
  String get generateTitle => 'Titel Generieren';

  @override
  String get generateBookTitle => 'Buchtitel Generieren';

  @override
  String get sharePromptWithAI =>
      'Teilen Sie diese Eingabeaufforderung mit Ihrem KI-Assistenten (ChatGPT, Claude usw.), um einen Titel zu generieren.';

  @override
  String get copy => 'Kopieren';

  @override
  String get pasteTitle => 'Titel Einfügen';

  @override
  String get promptCopiedToClipboard =>
      'Eingabeaufforderung in Zwischenablage kopiert';

  @override
  String get noTitleInClipboard =>
      'Kein Titel in der Zwischenablage gefunden. Erstelle Buch mit Platzhaltertitel.';

  @override
  String bookCreatedWithTitle(String title) {
    return 'Buch mit KI-generiertem Titel erstellt: \"$title\"';
  }

  @override
  String get settings => 'Einstellungen';

  @override
  String get reading => 'Lesen';

  @override
  String get completed => 'Abgeschlossen';

  @override
  String get draft => 'Entwurf';

  @override
  String errorLoadingBooks(String error) {
    return 'Fehler beim Laden der Bücher: $error';
  }

  @override
  String get retry => 'Wiederholen';

  @override
  String get untitledBook => 'Buch Ohne Titel';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get writingPreferencesSection => 'Schreibpräferenzen';

  @override
  String get contentGenerationSection => 'Inhaltsgenerierung';

  @override
  String get aboutSection => 'Über';

  @override
  String get writingStyleLabel => 'Schreibstil';

  @override
  String get writingStyleCreative =>
      'Kreativ - Fantasievoll und ausdrucksstark';

  @override
  String get writingStyleBalanced => 'Ausgewogen - Moderate Kreativität';

  @override
  String get writingStylePrecise => 'Präzise - Klar und prägnant';

  @override
  String get contentLanguageLabel => 'Inhaltssprache';

  @override
  String get uiLanguageLabel => 'Schnittstellensprache';

  @override
  String get uiLanguageSystemDefault => 'Systemstandard';

  @override
  String get toneLabel => 'Ton';

  @override
  String get toneCasual => 'Lässig - Freundlich und entspannt';

  @override
  String get toneNeutral => 'Neutral - Ausgewogener Ton';

  @override
  String get toneFormal => 'Formal - Professionell und ernst';

  @override
  String get vocabularyLevelLabel => 'Wortschatzstufe';

  @override
  String get vocabularySimple => 'Einfach - Leicht verständlich';

  @override
  String get vocabularyModerate => 'Moderat - Ausgewogener Wortschatz';

  @override
  String get vocabularyAdvanced => 'Fortgeschritten - Reicher Wortschatz';

  @override
  String get favoriteAuthorLabel => 'Lieblingsautor';

  @override
  String get favoriteAuthorHint => 'z. B. J.K. Rowling';

  @override
  String get favoriteAuthorDescription =>
      'Geben Sie den Namen Ihres Lieblingsautors ein, damit die KI seinen Schreibstil nachahmt (optional).';

  @override
  String get defaultChapterCountLabel => 'Standardkapitelanzahl';

  @override
  String chapterCountOption(int count) {
    return '$count Kapitel';
  }

  @override
  String get shortBook => 'Kurzes Buch';

  @override
  String get standardBook => 'Standardbuch';

  @override
  String get longerBook => 'Längeres Buch';

  @override
  String get fullLengthNovel => 'Vollständiger Roman';

  @override
  String get extendedNovel => 'Erweiterter Roman';

  @override
  String get epicLength => 'Epische Länge';

  @override
  String get versionLabel => 'Version';

  @override
  String get licenseLabel => 'Lizenz';

  @override
  String get mitLicense => 'MIT-Lizenz';

  @override
  String get clearAuthor => 'Löschen';

  @override
  String get saveAuthor => 'Speichern';

  @override
  String get bookDetails => 'Book Details';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get bookNotFound => 'Book not found';

  @override
  String errorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String byAuthor(String author) {
    return 'by $author';
  }

  @override
  String percentComplete(String percent) {
    return '$percent% Complete';
  }

  @override
  String get tableOfContents => 'Table of Contents';

  @override
  String get generateTOC => 'Generate TOC';

  @override
  String get noChaptersYet => 'No chapters yet';

  @override
  String get generateTOCPrompt =>
      'Generate a Table of Contents using AI to get started';

  @override
  String errorLoadingChapters(String error) {
    return 'Error loading chapters: $error';
  }

  @override
  String get generateTableOfContents => 'Generate Table of Contents';

  @override
  String get shareTOCPromptMessage =>
      'Share this prompt with your preferred AI assistant (ChatGPT, Claude, etc.) to generate a table of contents.';

  @override
  String get afterGenerationMessage =>
      'After getting the response, come back and paste it here.';

  @override
  String get share => 'Share';

  @override
  String get promptSharedMessage =>
      'Prompt shared! Paste the response when ready.';

  @override
  String get promptCopied => 'Prompt copied to clipboard';

  @override
  String get pasteLLMResponse => 'Paste LLM Response';

  @override
  String get pasteResponseInstructions =>
      'Paste the response from your AI assistant:';

  @override
  String get pasteHint =>
      'Paste response here...\n\nSupports both JSON and plain text formats';

  @override
  String get import => 'Import';

  @override
  String chaptersImported(int count) {
    return 'Successfully imported $count chapters!';
  }

  @override
  String errorImportingChapters(String error) {
    return 'Error importing chapters: $error';
  }

  @override
  String get parseError => 'Parse Error';

  @override
  String get parseErrorMessage =>
      'Could not parse the response. Please make sure the response is in the correct format.';

  @override
  String get ok => 'OK';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get editBookDetails => 'Edit Book Details';

  @override
  String get exportBook => 'Export Book';

  @override
  String get deleteBook => 'Delete Book';

  @override
  String get title => 'Title';

  @override
  String get author => 'Author';

  @override
  String get description => 'Description';

  @override
  String get save => 'Save';

  @override
  String get bookUpdated => 'Book updated successfully';

  @override
  String confirmDeleteBook(String title) {
    return 'Are you sure you want to delete \"$title\"? This action cannot be undone.';
  }

  @override
  String get delete => 'Delete';

  @override
  String bookDeleted(String title) {
    return 'Deleted \"$title\"';
  }

  @override
  String get bookExported => 'Book exported as JSON. Copy the text below:';

  @override
  String get close => 'Close';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get reader => 'Reader';

  @override
  String get bookmarks => 'Bookmarks';

  @override
  String get highlights => 'Highlights';

  @override
  String get notes => 'Notes';

  @override
  String get chapterNotFound => 'Chapter not found';

  @override
  String get noContentYet => 'No content yet';

  @override
  String get generateContentPrompt =>
      'Generate content for this chapter using AI';

  @override
  String get generateContent => 'Generate Content';

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get fontSize => 'Font Size';

  @override
  String get theme => 'Theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get sepia => 'Sepia';

  @override
  String get fontFamily => 'Font Family';

  @override
  String get system => 'System';

  @override
  String get serif => 'Serif';

  @override
  String get sans => 'Sans';

  @override
  String get generateChapterContent => 'Generate Chapter Content';

  @override
  String get shareChapterPromptMessage =>
      'Share this prompt with your preferred AI assistant (ChatGPT, Claude, etc.) to generate chapter content.';

  @override
  String get pasteChapterContent => 'Paste Chapter Content';

  @override
  String get contentImported => 'Chapter content imported successfully!';

  @override
  String errorImportingContent(String error) {
    return 'Error importing content: $error';
  }

  @override
  String get addNote => 'Add Note';

  @override
  String get addBookmark => 'Add Bookmark';

  @override
  String get bookmarkAdded => 'Bookmark added';

  @override
  String errorAddingBookmark(String error) {
    return 'Error adding bookmark: $error';
  }

  @override
  String get noteAdded => 'Note added';

  @override
  String errorAddingNote(String error) {
    return 'Error adding note: $error';
  }

  @override
  String get highlight => 'Highlight';

  @override
  String get highlightText => 'Highlight Text';

  @override
  String get selectColor => 'Select color:';

  @override
  String get highlightAdded => 'Highlight added';

  @override
  String errorAddingHighlight(String error) {
    return 'Error adding highlight: $error';
  }

  @override
  String bookTitleUpdated(String title) {
    return 'Book title updated to: \"$title\"';
  }

  @override
  String get readAloud => 'Read Aloud';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get stop => 'Stop';

  @override
  String get speechSpeed => 'Speech Speed';

  @override
  String get slow => 'Slow';

  @override
  String get normal => 'Normal';

  @override
  String get fast => 'Fast';

  @override
  String get ttsSettings => 'Read Aloud Settings';

  @override
  String ttsError(String error) {
    return 'Text-to-speech error: $error';
  }

  @override
  String get audioScreenOffInfo => 'Audio will continue even with screen off';

  @override
  String get rewind => 'Rewind 10 seconds';

  @override
  String get forward => 'Forward 10 seconds';

  @override
  String get highlightSelected => 'Highlight Selected Text';
}
