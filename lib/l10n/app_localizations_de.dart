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
