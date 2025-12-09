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
  String get settingsTitle => '設定';

  @override
  String get writingPreferencesSection => '執筆の好み';

  @override
  String get contentGenerationSection => 'コンテンツ生成';

  @override
  String get aboutSection => 'について';

  @override
  String get writingStyleLabel => '執筆スタイル';

  @override
  String get writingStyleCreative => '創造的 - 想像力豊かで表現力豊か';

  @override
  String get writingStyleBalanced => 'バランス - 中程度の創造性';

  @override
  String get writingStylePrecise => '正確 - 明確で簡潔';

  @override
  String get contentLanguageLabel => 'コンテンツ言語';

  @override
  String get uiLanguageLabel => 'UI言語';

  @override
  String get uiLanguageSystemDefault => 'システムデフォルト';

  @override
  String get toneLabel => 'トーン';

  @override
  String get toneCasual => 'カジュアル - フレンドリーでリラックス';

  @override
  String get toneNeutral => 'ニュートラル - バランスの取れたトーン';

  @override
  String get toneFormal => 'フォーマル - プロフェッショナルで真摯';

  @override
  String get vocabularyLevelLabel => '語彙レベル';

  @override
  String get vocabularySimple => 'シンプル - 理解しやすい';

  @override
  String get vocabularyModerate => '中程度 - バランスの取れた語彙';

  @override
  String get vocabularyAdvanced => '上級 - 豊かな語彙';

  @override
  String get favoriteAuthorLabel => '好きな著者';

  @override
  String get favoriteAuthorHint => '例：J.K. ローリング';

  @override
  String get favoriteAuthorDescription =>
      '好きな著者の名前を入力すると、AIがその執筆スタイルを模倣します（オプション）。';

  @override
  String get defaultChapterCountLabel => 'デフォルト章数';

  @override
  String chapterCountOption(int count) {
    return '$count章';
  }

  @override
  String get shortBook => '短編';

  @override
  String get standardBook => '標準的な本';

  @override
  String get longerBook => 'より長い本';

  @override
  String get fullLengthNovel => 'フル長編小説';

  @override
  String get extendedNovel => '拡張長編小説';

  @override
  String get epicLength => '叙事詩の長さ';

  @override
  String get versionLabel => 'バージョン';

  @override
  String get licenseLabel => 'ライセンス';

  @override
  String get mitLicense => 'MITライセンス';

  @override
  String get clearAuthor => 'クリア';

  @override
  String get saveAuthor => '保存';
}
