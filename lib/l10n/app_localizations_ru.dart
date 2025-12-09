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
