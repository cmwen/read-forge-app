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
  String get settingsTitle => 'الإعدادات';

  @override
  String get writingPreferencesSection => 'تفضيلات الكتابة';

  @override
  String get contentGenerationSection => 'توليد المحتوى';

  @override
  String get aboutSection => 'حول';

  @override
  String get writingStyleLabel => 'نمط الكتابة';

  @override
  String get writingStyleCreative => 'إبداعي - خيالي وتعبيري';

  @override
  String get writingStyleBalanced => 'متوازن - إبداع معتدل';

  @override
  String get writingStylePrecise => 'دقيق - واضح وموجز';

  @override
  String get contentLanguageLabel => 'لغة المحتوى';

  @override
  String get uiLanguageLabel => 'لغة الواجهة';

  @override
  String get uiLanguageSystemDefault => 'افتراضي النظام';

  @override
  String get toneLabel => 'النبرة';

  @override
  String get toneCasual => 'عرضي - ودود وممتع';

  @override
  String get toneNeutral => 'محايد - نبرة متوازنة';

  @override
  String get toneFormal => 'رسمي - احترافي وجاد';

  @override
  String get vocabularyLevelLabel => 'مستوى المفردات';

  @override
  String get vocabularySimple => 'بسيط - سهل الفهم';

  @override
  String get vocabularyModerate => 'معتدل - مفردات متوازنة';

  @override
  String get vocabularyAdvanced => 'متقدم - مفردات غنية';

  @override
  String get favoriteAuthorLabel => 'المؤلف المفضل';

  @override
  String get favoriteAuthorHint => 'على سبيل المثال: J.K. Rowling';

  @override
  String get favoriteAuthorDescription =>
      'أدخل اسم مؤلفك المفضل حتى تحاكي الذكاء الاصطناعي أسلوب كتابته (اختياري).';

  @override
  String get defaultChapterCountLabel => 'عدد الفصول الافتراضي';

  @override
  String chapterCountOption(int count) {
    return '$count فصول';
  }

  @override
  String get shortBook => 'كتاب قصير';

  @override
  String get standardBook => 'كتاب قياسي';

  @override
  String get longerBook => 'كتاب أطول';

  @override
  String get fullLengthNovel => 'رواية طويلة';

  @override
  String get extendedNovel => 'رواية موسعة';

  @override
  String get epicLength => 'طول ملحمي';

  @override
  String get versionLabel => 'الإصدار';

  @override
  String get licenseLabel => 'الترخيص';

  @override
  String get mitLicense => 'ترخيص MIT';

  @override
  String get clearAuthor => 'مسح';

  @override
  String get saveAuthor => 'حفظ';

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
