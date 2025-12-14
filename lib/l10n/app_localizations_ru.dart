// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'ReadForge';

  @override
  String get libraryTitle => 'ReadForge';

  @override
  String get newBook => 'Новая Книга';

  @override
  String get noBooksYet => 'Пока нет книг';

  @override
  String get tapToCreateFirstBook =>
      'Нажмите кнопку +, чтобы создать вашу первую книгу';

  @override
  String get createNewBook => 'Создать Новую Книгу';

  @override
  String get createBookInstructions =>
      'Заполните хотя бы одно поле ниже. Если вы не укажете название, ИИ может создать его для вас на основе вашего описания или цели.';

  @override
  String get bookTitleOptional => 'Название Книги (Необязательно)';

  @override
  String get bookTitleHint =>
      'Введите название или оставьте пустым для генерации ИИ';

  @override
  String get descriptionOptional => 'Описание (Необязательно)';

  @override
  String get descriptionHint => 'Опишите, о чём книга';

  @override
  String get purposeOptional => 'Цель/Учебная Задача (Необязательно)';

  @override
  String get purposeHint => 'Что вы хотите узнать из этой книги?';

  @override
  String get cancel => 'Отмена';

  @override
  String get create => 'Создать';

  @override
  String get fillAtLeastOneField => 'Пожалуйста, заполните хотя бы одно поле';

  @override
  String get generateTitleWithAI => 'Создать Название с Помощью ИИ?';

  @override
  String noTitleProvidedPrompt(String contentType) {
    return 'Название не было указано. Хотите использовать ИИ для создания названия на основе вашего $contentType?';
  }

  @override
  String get skip => 'Пропустить';

  @override
  String get generateTitle => 'Создать Название';

  @override
  String get generateBookTitle => 'Создать Название Книги';

  @override
  String get sharePromptWithAI =>
      'Поделитесь этим запросом с вашим ИИ-помощником (ChatGPT, Claude и т.д.) для создания названия.';

  @override
  String get copy => 'Копировать';

  @override
  String get pasteTitle => 'Вставить Название';

  @override
  String get promptCopiedToClipboard => 'Запрос скопирован в буфер обмена';

  @override
  String get noTitleInClipboard =>
      'Название не найдено в буфере обмена. Создаём книгу с временным названием.';

  @override
  String bookCreatedWithTitle(String title) {
    return 'Книга создана с названием, сгенерированным ИИ: \"$title\"';
  }

  @override
  String get settings => 'Настройки';

  @override
  String get reading => 'Читаю';

  @override
  String get completed => 'Завершено';

  @override
  String get draft => 'Черновик';

  @override
  String errorLoadingBooks(String error) {
    return 'Ошибка загрузки книг: $error';
  }

  @override
  String get retry => 'Повторить';

  @override
  String get untitledBook => 'Книга Без Названия';

  @override
  String get settingsTitle => 'Параметры';

  @override
  String get writingPreferencesSection => 'Предпочтения письма';

  @override
  String get contentGenerationSection => 'Генерация контента';

  @override
  String get aboutSection => 'О программе';

  @override
  String get writingStyleLabel => 'Стиль письма';

  @override
  String get writingStyleCreative =>
      'Творческий - Воображаемый и выразительный';

  @override
  String get writingStyleBalanced => 'Сбалансированный - Умеренная творчество';

  @override
  String get writingStylePrecise => 'Точный - Четкий и лаконичный';

  @override
  String get contentLanguageLabel => 'Язык контента';

  @override
  String get uiLanguageLabel => 'Язык интерфейса';

  @override
  String get uiLanguageSystemDefault => 'По умолчанию системы';

  @override
  String get toneLabel => 'Тон';

  @override
  String get toneCasual => 'Непринужденный - Дружелюбный и расслабленный';

  @override
  String get toneNeutral => 'Нейтральный - Сбалансированный тон';

  @override
  String get toneFormal => 'Официальный - Профессиональный и серьезный';

  @override
  String get vocabularyLevelLabel => 'Уровень словарного запаса';

  @override
  String get vocabularySimple => 'Простой - Легко понять';

  @override
  String get vocabularyModerate => 'Умеренный - Сбалансированный словарь';

  @override
  String get vocabularyAdvanced => 'Продвинутый - Богатый словарь';

  @override
  String get favoriteAuthorLabel => 'Любимый автор';

  @override
  String get favoriteAuthorHint => 'напр., Дж. К. Роулинг';

  @override
  String get favoriteAuthorDescription =>
      'Введите имя вашего любимого автора, чтобы ИИ подражал их стилю письма (опционально).';

  @override
  String get defaultChapterCountLabel => 'Количество глав по умолчанию';

  @override
  String chapterCountOption(int count) {
    return '$count глав';
  }

  @override
  String get shortBook => 'Короткая книга';

  @override
  String get standardBook => 'Стандартная книга';

  @override
  String get longerBook => 'Более длинная книга';

  @override
  String get fullLengthNovel => 'Полнометражный роман';

  @override
  String get extendedNovel => 'Расширенный роман';

  @override
  String get epicLength => 'Эпическая длина';

  @override
  String get versionLabel => 'Версия';

  @override
  String get licenseLabel => 'Лицензия';

  @override
  String get mitLicense => 'Лицензия MIT';

  @override
  String get clearAuthor => 'Очистить';

  @override
  String get saveAuthor => 'Сохранить';

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
