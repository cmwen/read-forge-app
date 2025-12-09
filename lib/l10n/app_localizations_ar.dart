// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'ReadForge';

  @override
  String get libraryTitle => 'ReadForge';

  @override
  String get newBook => 'كتاب جديد';

  @override
  String get noBooksYet => 'لا توجد كتب بعد';

  @override
  String get tapToCreateFirstBook => 'اضغط على زر + لإنشاء كتابك الأول';

  @override
  String get createNewBook => 'إنشاء كتاب جديد';

  @override
  String get createBookInstructions =>
      'املأ حقلاً واحداً على الأقل أدناه. إذا لم تقدم عنواناً، يمكن للذكاء الاصطناعي إنشاء واحد لك بناءً على وصفك أو هدفك.';

  @override
  String get bookTitleOptional => 'عنوان الكتاب (اختياري)';

  @override
  String get bookTitleHint =>
      'أدخل عنواناً أو اتركه فارغاً للتوليد بالذكاء الاصطناعي';

  @override
  String get descriptionOptional => 'الوصف (اختياري)';

  @override
  String get descriptionHint => 'صف محتوى الكتاب';

  @override
  String get purposeOptional => 'الغرض/الهدف التعليمي (اختياري)';

  @override
  String get purposeHint => 'ماذا تريد أن تتعلم من هذا الكتاب؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get create => 'إنشاء';

  @override
  String get fillAtLeastOneField => 'يرجى ملء حقل واحد على الأقل';

  @override
  String get generateTitleWithAI => 'إنشاء عنوان بالذكاء الاصطناعي؟';

  @override
  String noTitleProvidedPrompt(String contentType) {
    return 'لم يتم تقديم عنوان. هل تريد استخدام الذكاء الاصطناعي لإنشاء عنوان بناءً على $contentType الخاص بك؟';
  }

  @override
  String get skip => 'تخطي';

  @override
  String get generateTitle => 'إنشاء عنوان';

  @override
  String get generateBookTitle => 'إنشاء عنوان الكتاب';

  @override
  String get sharePromptWithAI =>
      'شارك هذا الموجه مع مساعد الذكاء الاصطناعي الخاص بك (ChatGPT أو Claude أو غيرها) لإنشاء عنوان.';

  @override
  String get copy => 'نسخ';

  @override
  String get pasteTitle => 'لصق العنوان';

  @override
  String get promptCopiedToClipboard => 'تم نسخ الموجه إلى الحافظة';

  @override
  String get noTitleInClipboard =>
      'لم يتم العثور على عنوان في الحافظة. إنشاء كتاب بعنوان مؤقت.';

  @override
  String bookCreatedWithTitle(String title) {
    return 'تم إنشاء كتاب بعنوان من الذكاء الاصطناعي: \"$title\"';
  }

  @override
  String get settings => 'الإعدادات';

  @override
  String get reading => 'جارٍ القراءة';

  @override
  String get completed => 'مكتمل';

  @override
  String get draft => 'مسودة';

  @override
  String errorLoadingBooks(String error) {
    return 'خطأ في تحميل الكتب: $error';
  }

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get untitledBook => 'كتاب بدون عنوان';

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
