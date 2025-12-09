// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'ReadForge';

  @override
  String get libraryTitle => 'ReadForge';

  @override
  String get newBook => '新しい本';

  @override
  String get noBooksYet => 'まだ本がありません';

  @override
  String get tapToCreateFirstBook => '+ ボタンをタップして最初の本を作成してください';

  @override
  String get createNewBook => '新しい本を作成';

  @override
  String get createBookInstructions =>
      '以下の少なくとも1つのフィールドを入力してください。タイトルを指定しない場合、AIが説明または目的に基づいてタイトルを生成できます。';

  @override
  String get bookTitleOptional => '本のタイトル（オプション）';

  @override
  String get bookTitleHint => 'タイトルを入力するか、AI生成のために空白のままにしてください';

  @override
  String get descriptionOptional => '説明（オプション）';

  @override
  String get descriptionHint => 'この本の内容を説明してください';

  @override
  String get purposeOptional => '目的/学習目標（オプション）';

  @override
  String get purposeHint => 'この本から何を学びたいですか？';

  @override
  String get cancel => 'キャンセル';

  @override
  String get create => '作成';

  @override
  String get fillAtLeastOneField => '少なくとも1つのフィールドを入力してください';

  @override
  String get generateTitleWithAI => 'AIでタイトルを生成しますか？';

  @override
  String noTitleProvidedPrompt(String contentType) {
    return 'タイトルが指定されていません。$contentTypeに基づいてAIでタイトルを生成しますか？';
  }

  @override
  String get skip => 'スキップ';

  @override
  String get generateTitle => 'タイトルを生成';

  @override
  String get generateBookTitle => '本のタイトルを生成';

  @override
  String get sharePromptWithAI =>
      'このプロンプトをAIアシスタント（ChatGPT、Claudeなど）と共有してタイトルを生成してください。';

  @override
  String get copy => 'コピー';

  @override
  String get pasteTitle => 'タイトルを貼り付け';

  @override
  String get promptCopiedToClipboard => 'プロンプトがクリップボードにコピーされました';

  @override
  String get noTitleInClipboard =>
      'クリップボードにタイトルが見つかりませんでした。プレースホルダータイトルで本を作成します。';

  @override
  String bookCreatedWithTitle(String title) {
    return 'AI生成タイトルで本を作成しました：\"$title\"';
  }

  @override
  String get settings => '設定';

  @override
  String get reading => '読書中';

  @override
  String get completed => '完了';

  @override
  String get draft => '下書き';

  @override
  String errorLoadingBooks(String error) {
    return '本の読み込みエラー：$error';
  }

  @override
  String get retry => '再試行';

  @override
  String get untitledBook => '無題の本';

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
