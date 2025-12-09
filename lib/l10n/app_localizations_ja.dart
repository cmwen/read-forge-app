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
}
