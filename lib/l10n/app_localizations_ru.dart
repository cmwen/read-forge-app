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
}
