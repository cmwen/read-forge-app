// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'ReadForge';

  @override
  String get libraryTitle => 'ReadForge';

  @override
  String get newBook => 'Nouveau Livre';

  @override
  String get noBooksYet => 'Pas encore de livres';

  @override
  String get tapToCreateFirstBook =>
      'Appuyez sur le bouton + pour créer votre premier livre';

  @override
  String get createNewBook => 'Créer un Nouveau Livre';

  @override
  String get createBookInstructions =>
      'Remplissez au moins un champ ci-dessous. Si vous ne fournissez pas de titre, l\'IA peut en générer un pour vous en fonction de votre description ou objectif.';

  @override
  String get bookTitleOptional => 'Titre du Livre (Optionnel)';

  @override
  String get bookTitleHint =>
      'Entrez un titre ou laissez vide pour la génération par IA';

  @override
  String get descriptionOptional => 'Description (Optionnel)';

  @override
  String get descriptionHint => 'Décrivez le contenu du livre';

  @override
  String get purposeOptional => 'Objectif/But d\'Apprentissage (Optionnel)';

  @override
  String get purposeHint => 'Que voulez-vous apprendre de ce livre ?';

  @override
  String get cancel => 'Annuler';

  @override
  String get create => 'Créer';

  @override
  String get fillAtLeastOneField => 'Veuillez remplir au moins un champ';

  @override
  String get generateTitleWithAI => 'Générer le Titre avec l\'IA ?';

  @override
  String noTitleProvidedPrompt(String contentType) {
    return 'Aucun titre fourni. Souhaitez-vous utiliser l\'IA pour générer un titre basé sur votre $contentType ?';
  }

  @override
  String get skip => 'Ignorer';

  @override
  String get generateTitle => 'Générer le Titre';

  @override
  String get generateBookTitle => 'Générer le Titre du Livre';

  @override
  String get sharePromptWithAI =>
      'Partagez cette invite avec votre assistant IA (ChatGPT, Claude, etc.) pour générer un titre.';

  @override
  String get copy => 'Copier';

  @override
  String get pasteTitle => 'Coller le Titre';

  @override
  String get promptCopiedToClipboard => 'Invite copiée dans le presse-papiers';

  @override
  String get noTitleInClipboard =>
      'Aucun titre trouvé dans le presse-papiers. Création du livre avec un titre provisoire.';

  @override
  String bookCreatedWithTitle(String title) {
    return 'Livre créé avec un titre généré par IA : \"$title\"';
  }

  @override
  String get settings => 'Paramètres';

  @override
  String get reading => 'En Lecture';

  @override
  String get completed => 'Terminé';

  @override
  String get draft => 'Brouillon';

  @override
  String errorLoadingBooks(String error) {
    return 'Erreur lors du chargement des livres : $error';
  }

  @override
  String get retry => 'Réessayer';

  @override
  String get untitledBook => 'Livre Sans Titre';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get writingPreferencesSection => 'Préférences d\'Écriture';

  @override
  String get contentGenerationSection => 'Génération de Contenu';

  @override
  String get aboutSection => 'À propos';

  @override
  String get writingStyleLabel => 'Style d\'Écriture';

  @override
  String get writingStyleCreative => 'Créatif - Imaginatif et expressif';

  @override
  String get writingStyleBalanced => 'Équilibré - Créativité modérée';

  @override
  String get writingStylePrecise => 'Précis - Clair et concis';

  @override
  String get contentLanguageLabel => 'Langue du Contenu';

  @override
  String get uiLanguageLabel => 'Langue de l\'Interface';

  @override
  String get uiLanguageSystemDefault => 'Par Défaut du Système';

  @override
  String get toneLabel => 'Ton';

  @override
  String get toneCasual => 'Décontracté - Amical et relaxé';

  @override
  String get toneNeutral => 'Neutre - Ton équilibré';

  @override
  String get toneFormal => 'Formel - Professionnel et sérieux';

  @override
  String get vocabularyLevelLabel => 'Niveau de Vocabulaire';

  @override
  String get vocabularySimple => 'Simple - Facile à comprendre';

  @override
  String get vocabularyModerate => 'Modéré - Vocabulaire équilibré';

  @override
  String get vocabularyAdvanced => 'Avancé - Vocabulaire riche';

  @override
  String get favoriteAuthorLabel => 'Auteur Préféré';

  @override
  String get favoriteAuthorHint => 'ex., J.K. Rowling';

  @override
  String get favoriteAuthorDescription =>
      'Entrez le nom de votre auteur préféré pour que l\'IA émule son style d\'écriture (facultatif).';

  @override
  String get defaultChapterCountLabel => 'Nombre Predéfini de Chapitres';

  @override
  String chapterCountOption(int count) {
    return '$count chapitres';
  }

  @override
  String get shortBook => 'Livre court';

  @override
  String get standardBook => 'Livre standard';

  @override
  String get longerBook => 'Livre plus long';

  @override
  String get fullLengthNovel => 'Roman complet';

  @override
  String get extendedNovel => 'Roman étendu';

  @override
  String get epicLength => 'Longueur épique';

  @override
  String get versionLabel => 'Version';

  @override
  String get licenseLabel => 'Licence';

  @override
  String get mitLicense => 'Licence MIT';

  @override
  String get clearAuthor => 'Effacer';

  @override
  String get saveAuthor => 'Enregistrer';

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
  String get playing => 'Playing';

  @override
  String get paused => 'Paused';

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

  @override
  String get textToSpeech => 'Text to Speech';

  @override
  String get playbackSpeed => 'Playback Speed';
}
