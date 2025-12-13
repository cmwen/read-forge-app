// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'ReadForge';

  @override
  String get libraryTitle => 'ReadForge';

  @override
  String get newBook => '새 책';

  @override
  String get noBooksYet => '아직 책이 없습니다';

  @override
  String get tapToCreateFirstBook => '+ 버튼을 눌러 첫 번째 책을 만드세요';

  @override
  String get createNewBook => '새 책 만들기';

  @override
  String get createBookInstructions =>
      '아래 항목 중 하나 이상을 입력하세요. 제목을 입력하지 않으면 AI가 설명이나 목적을 기반으로 제목을 생성할 수 있습니다.';

  @override
  String get bookTitleOptional => '책 제목 (선택사항)';

  @override
  String get bookTitleHint => '제목을 입력하거나 AI 생성을 위해 비워두세요';

  @override
  String get descriptionOptional => '설명 (선택사항)';

  @override
  String get descriptionHint => '책의 내용을 설명하세요';

  @override
  String get purposeOptional => '목적/학습 목표 (선택사항)';

  @override
  String get purposeHint => '이 책에서 무엇을 배우고 싶으신가요?';

  @override
  String get cancel => '취소';

  @override
  String get create => '만들기';

  @override
  String get fillAtLeastOneField => '하나 이상의 항목을 입력해 주세요';

  @override
  String get generateTitleWithAI => 'AI로 제목을 생성하시겠습니까?';

  @override
  String noTitleProvidedPrompt(String contentType) {
    return '제목이 제공되지 않았습니다. $contentType을(를) 기반으로 AI로 제목을 생성하시겠습니까?';
  }

  @override
  String get skip => '건너뛰기';

  @override
  String get generateTitle => '제목 생성';

  @override
  String get generateBookTitle => '책 제목 생성';

  @override
  String get sharePromptWithAI =>
      '이 프롬프트를 AI 어시스턴트(ChatGPT, Claude 등)와 공유하여 제목을 생성하세요.';

  @override
  String get copy => '복사';

  @override
  String get pasteTitle => '제목 붙여넣기';

  @override
  String get promptCopiedToClipboard => '프롬프트가 클립보드에 복사되었습니다';

  @override
  String get noTitleInClipboard => '클립보드에 제목이 없습니다. 임시 제목으로 책을 만듭니다.';

  @override
  String bookCreatedWithTitle(String title) {
    return 'AI 생성 제목으로 책을 만들었습니다: \"$title\"';
  }

  @override
  String get settings => '설정';

  @override
  String get reading => '읽는 중';

  @override
  String get completed => '완료';

  @override
  String get draft => '초안';

  @override
  String errorLoadingBooks(String error) {
    return '책을 불러오는 중 오류 발생: $error';
  }

  @override
  String get retry => '다시 시도';

  @override
  String get untitledBook => '제목 없는 책';

  @override
  String get settingsTitle => '설정';

  @override
  String get writingPreferencesSection => '글쓰기 선호도';

  @override
  String get contentGenerationSection => '콘텐츠 생성';

  @override
  String get aboutSection => '정보';

  @override
  String get writingStyleLabel => '글쓰기 스타일';

  @override
  String get writingStyleCreative => '창의적 - 상상력 있고 표현력 있는';

  @override
  String get writingStyleBalanced => '균형 - 중간 정도의 창의성';

  @override
  String get writingStylePrecise => '정확 - 명확하고 간결';

  @override
  String get contentLanguageLabel => '콘텐츠 언어';

  @override
  String get uiLanguageLabel => 'UI 언어';

  @override
  String get uiLanguageSystemDefault => '시스템 기본값';

  @override
  String get toneLabel => '톤';

  @override
  String get toneCasual => '캐주얼 - 친근하고 편한';

  @override
  String get toneNeutral => '중립 - 균형 잡힌 톤';

  @override
  String get toneFormal => '공식 - 전문적이고 진지';

  @override
  String get vocabularyLevelLabel => '어휘 수준';

  @override
  String get vocabularySimple => '간단 - 이해하기 쉬운';

  @override
  String get vocabularyModerate => '중간 - 균형 잡힌 어휘';

  @override
  String get vocabularyAdvanced => '고급 - 풍부한 어휘';

  @override
  String get favoriteAuthorLabel => '선호하는 작가';

  @override
  String get favoriteAuthorHint => '예: J.K. 롤링';

  @override
  String get favoriteAuthorDescription =>
      'AI가 자신의 글쓰기 스타일을 모방하도록 선호하는 작가의 이름을 입력하세요 (선택 사항).';

  @override
  String get defaultChapterCountLabel => '기본 장 수';

  @override
  String chapterCountOption(int count) {
    return '$count장';
  }

  @override
  String get shortBook => '짧은 책';

  @override
  String get standardBook => '표준 책';

  @override
  String get longerBook => '더 긴 책';

  @override
  String get fullLengthNovel => '완전한 장편 소설';

  @override
  String get extendedNovel => '확장 장편 소설';

  @override
  String get epicLength => '서사시적 길이';

  @override
  String get versionLabel => '버전';

  @override
  String get licenseLabel => '라이선스';

  @override
  String get mitLicense => 'MIT 라이선스';

  @override
  String get clearAuthor => '지우기';

  @override
  String get saveAuthor => '저장';

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
}
