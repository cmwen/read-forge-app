// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'ReadForge';

  @override
  String get libraryTitle => 'ReadForge';

  @override
  String get newBook => '新建图书';

  @override
  String get noBooksYet => '暂无图书';

  @override
  String get tapToCreateFirstBook => '点击 + 按钮创建您的第一本书';

  @override
  String get createNewBook => '创建新图书';

  @override
  String get createBookInstructions =>
      '至少填写一个字段。如果您不提供标题，AI 可以根据您的描述或目的为您生成一个。';

  @override
  String get bookTitleOptional => '图书标题（可选）';

  @override
  String get bookTitleHint => '输入标题或留空以使用 AI 生成';

  @override
  String get descriptionOptional => '描述（可选）';

  @override
  String get descriptionHint => '描述这本书的内容';

  @override
  String get purposeOptional => '目的/学习目标（可选）';

  @override
  String get purposeHint => '您想从这本书中学到什么？';

  @override
  String get cancel => '取消';

  @override
  String get create => '创建';

  @override
  String get fillAtLeastOneField => '请至少填写一个字段';

  @override
  String get generateTitleWithAI => '使用 AI 生成标题？';

  @override
  String noTitleProvidedPrompt(String contentType) {
    return '未提供标题。您想使用 AI 根据您的$contentType生成标题吗？';
  }

  @override
  String get skip => '跳过';

  @override
  String get generateTitle => '生成标题';

  @override
  String get generateBookTitle => '生成图书标题';

  @override
  String get sharePromptWithAI => '将此提示分享给您的 AI 助手（ChatGPT、Claude 等）以生成标题。';

  @override
  String get copy => '复制';

  @override
  String get pasteTitle => '粘贴标题';

  @override
  String get promptCopiedToClipboard => '提示已复制到剪贴板';

  @override
  String get noTitleInClipboard => '剪贴板中未找到标题。使用占位符标题创建图书。';

  @override
  String bookCreatedWithTitle(String title) {
    return '已创建带有 AI 生成标题的图书：\"$title\"';
  }

  @override
  String get settings => '设置';

  @override
  String get reading => '阅读中';

  @override
  String get completed => '已完成';

  @override
  String get draft => '草稿';

  @override
  String errorLoadingBooks(String error) {
    return '加载图书时出错：$error';
  }

  @override
  String get retry => '重试';

  @override
  String get untitledBook => '无标题图书';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => 'ReadForge';

  @override
  String get libraryTitle => 'ReadForge';

  @override
  String get newBook => '新增圖書';

  @override
  String get noBooksYet => '尚無圖書';

  @override
  String get tapToCreateFirstBook => '點擊 + 按鈕建立您的第一本書';

  @override
  String get createNewBook => '建立新圖書';

  @override
  String get createBookInstructions =>
      '至少填寫一個欄位。如果您不提供標題，AI 可以根據您的描述或目的為您生成一個。';

  @override
  String get bookTitleOptional => '圖書標題（選填）';

  @override
  String get bookTitleHint => '輸入標題或留空以使用 AI 生成';

  @override
  String get descriptionOptional => '描述（選填）';

  @override
  String get descriptionHint => '描述這本書的內容';

  @override
  String get purposeOptional => '目的/學習目標（選填）';

  @override
  String get purposeHint => '您想從這本書中學到什麼？';

  @override
  String get cancel => '取消';

  @override
  String get create => '建立';

  @override
  String get fillAtLeastOneField => '請至少填寫一個欄位';

  @override
  String get generateTitleWithAI => '使用 AI 生成標題？';

  @override
  String noTitleProvidedPrompt(String contentType) {
    return '未提供標題。您想使用 AI 根據您的$contentType生成標題嗎？';
  }

  @override
  String get skip => '跳過';

  @override
  String get generateTitle => '生成標題';

  @override
  String get generateBookTitle => '生成圖書標題';

  @override
  String get sharePromptWithAI => '將此提示分享給您的 AI 助手（ChatGPT、Claude 等）以生成標題。';

  @override
  String get copy => '複製';

  @override
  String get pasteTitle => '貼上標題';

  @override
  String get promptCopiedToClipboard => '提示已複製到剪貼簿';

  @override
  String get noTitleInClipboard => '剪貼簿中未找到標題。使用佔位符標題建立圖書。';

  @override
  String bookCreatedWithTitle(String title) {
    return '已建立帶有 AI 生成標題的圖書：\"$title\"';
  }

  @override
  String get settings => '設定';

  @override
  String get reading => '閱讀中';

  @override
  String get completed => '已完成';

  @override
  String get draft => '草稿';

  @override
  String errorLoadingBooks(String error) {
    return '載入圖書時發生錯誤：$error';
  }

  @override
  String get retry => '重試';

  @override
  String get untitledBook => '無標題圖書';
}
