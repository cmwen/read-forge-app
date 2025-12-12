// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'ReadForge';

  @override
  String get libraryTitle => 'ReadForge';

  @override
  String get newBook => 'Nuevo Libro';

  @override
  String get noBooksYet => 'Aún no hay libros';

  @override
  String get tapToCreateFirstBook =>
      'Toca el botón + para crear tu primer libro';

  @override
  String get createNewBook => 'Crear Nuevo Libro';

  @override
  String get createBookInstructions =>
      'Completa al menos un campo a continuación. Si no proporcionas un título, la IA puede generar uno basado en tu descripción o propósito.';

  @override
  String get bookTitleOptional => 'Título del Libro (Opcional)';

  @override
  String get bookTitleHint =>
      'Ingresa un título o déjalo vacío para generación por IA';

  @override
  String get descriptionOptional => 'Descripción (Opcional)';

  @override
  String get descriptionHint => 'Describe de qué trata el libro';

  @override
  String get purposeOptional => 'Propósito/Objetivo de Aprendizaje (Opcional)';

  @override
  String get purposeHint => '¿Qué quieres aprender de este libro?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get create => 'Crear';

  @override
  String get fillAtLeastOneField => 'Por favor completa al menos un campo';

  @override
  String get generateTitleWithAI => '¿Generar Título con IA?';

  @override
  String noTitleProvidedPrompt(String contentType) {
    return 'No se proporcionó un título. ¿Te gustaría usar IA para generar un título basado en tu $contentType?';
  }

  @override
  String get skip => 'Omitir';

  @override
  String get generateTitle => 'Generar Título';

  @override
  String get generateBookTitle => 'Generar Título del Libro';

  @override
  String get sharePromptWithAI =>
      'Comparte esta indicación con tu asistente de IA (ChatGPT, Claude, etc.) para generar un título.';

  @override
  String get copy => 'Copiar';

  @override
  String get pasteTitle => 'Pegar Título';

  @override
  String get promptCopiedToClipboard => 'Indicación copiada al portapapeles';

  @override
  String get noTitleInClipboard =>
      'No se encontró título en el portapapeles. Creando libro con título provisional.';

  @override
  String bookCreatedWithTitle(String title) {
    return 'Libro creado con título generado por IA: \"$title\"';
  }

  @override
  String get settings => 'Configuración';

  @override
  String get reading => 'Leyendo';

  @override
  String get completed => 'Completado';

  @override
  String get draft => 'Borrador';

  @override
  String errorLoadingBooks(String error) {
    return 'Error al cargar libros: $error';
  }

  @override
  String get retry => 'Reintentar';

  @override
  String get untitledBook => 'Libro Sin Título';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get writingPreferencesSection => 'Preferencias de Escritura';

  @override
  String get contentGenerationSection => 'Generación de Contenido';

  @override
  String get aboutSection => 'Acerca de';

  @override
  String get writingStyleLabel => 'Estilo de Escritura';

  @override
  String get writingStyleCreative => 'Creativo - Imaginativo y expresivo';

  @override
  String get writingStyleBalanced => 'Equilibrado - Creatividad moderada';

  @override
  String get writingStylePrecise => 'Preciso - Claro y conciso';

  @override
  String get contentLanguageLabel => 'Idioma del Contenido';

  @override
  String get uiLanguageLabel => 'Idioma de la Interfaz';

  @override
  String get uiLanguageSystemDefault => 'Sistema Predeterminado';

  @override
  String get toneLabel => 'Tono';

  @override
  String get toneCasual => 'Casual - Amigable y relajado';

  @override
  String get toneNeutral => 'Neutral - Tono equilibrado';

  @override
  String get toneFormal => 'Formal - Profesional y serio';

  @override
  String get vocabularyLevelLabel => 'Nivel de Vocabulario';

  @override
  String get vocabularySimple => 'Simple - Fácil de entender';

  @override
  String get vocabularyModerate => 'Moderado - Vocabulario equilibrado';

  @override
  String get vocabularyAdvanced => 'Avanzado - Vocabulario rico';

  @override
  String get favoriteAuthorLabel => 'Autor Favorito';

  @override
  String get favoriteAuthorHint => 'p. ej., J.K. Rowling';

  @override
  String get favoriteAuthorDescription =>
      'Ingrese el nombre de su autor favorito para que la IA emule su estilo de escritura (opcional).';

  @override
  String get defaultChapterCountLabel => 'Número Predeterminado de Capítulos';

  @override
  String chapterCountOption(int count) {
    return '$count capítulos';
  }

  @override
  String get shortBook => 'Libro corto';

  @override
  String get standardBook => 'Libro estándar';

  @override
  String get longerBook => 'Libro más largo';

  @override
  String get fullLengthNovel => 'Novela de larga duración';

  @override
  String get extendedNovel => 'Novela extendida';

  @override
  String get epicLength => 'Longitud épica';

  @override
  String get versionLabel => 'Versión';

  @override
  String get licenseLabel => 'Licencia';

  @override
  String get mitLicense => 'Licencia MIT';

  @override
  String get clearAuthor => 'Limpiar';

  @override
  String get saveAuthor => 'Guardar';

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
}
