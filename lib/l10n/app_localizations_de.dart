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
}
