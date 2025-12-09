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
}
