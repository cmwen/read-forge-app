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
}
