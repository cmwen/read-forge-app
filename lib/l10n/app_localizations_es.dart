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
}
