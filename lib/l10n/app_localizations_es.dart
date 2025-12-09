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
