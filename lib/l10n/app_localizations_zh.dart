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

  @override
  String get settingsTitle => '设置';

  @override
  String get writingPreferencesSection => '写作偏好';

  @override
  String get contentGenerationSection => '内容生成';

  @override
  String get aboutSection => '关于';

  @override
  String get writingStyleLabel => '写作风格';

  @override
  String get writingStyleCreative => '创意 - 富有想象力和表现力';

  @override
  String get writingStyleBalanced => '平衡 - 中等创意';

  @override
  String get writingStylePrecise => '精确 - 清晰简洁';

  @override
  String get contentLanguageLabel => '内容语言';

  @override
  String get uiLanguageLabel => '界面语言';

  @override
  String get uiLanguageSystemDefault => '系统默认';

  @override
  String get toneLabel => '语气';

  @override
  String get toneCasual => '休闲 - 友好轻松';

  @override
  String get toneNeutral => '中立 - 平衡语气';

  @override
  String get toneFormal => '正式 - 专业严肃';

  @override
  String get vocabularyLevelLabel => '词汇级别';

  @override
  String get vocabularySimple => '简单 - 易于理解';

  @override
  String get vocabularyModerate => '中等 - 平衡词汇';

  @override
  String get vocabularyAdvanced => '高级 - 丰富词汇';

  @override
  String get favoriteAuthorLabel => '喜爱的作者';

  @override
  String get favoriteAuthorHint => '例如：J.K. 罗琳';

  @override
  String get favoriteAuthorDescription => '输入您喜爱的作者名称，AI 将模仿他们的写作风格（可选）。';

  @override
  String get defaultChapterCountLabel => '默认章节数';

  @override
  String chapterCountOption(int count) {
    return '$count 个章节';
  }

  @override
  String get shortBook => '短书';

  @override
  String get standardBook => '标准书籍';

  @override
  String get longerBook => '较长书籍';

  @override
  String get fullLengthNovel => '完整长篇小说';

  @override
  String get extendedNovel => '拓展长篇小说';

  @override
  String get epicLength => '史诗级长度';

  @override
  String get versionLabel => '版本';

  @override
  String get licenseLabel => '许可证';

  @override
  String get mitLicense => 'MIT 许可证';

  @override
  String get clearAuthor => '清除';

  @override
  String get saveAuthor => '保存';
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

  @override
  String get settingsTitle => '設定';

  @override
  String get writingPreferencesSection => '寫作偏好';

  @override
  String get contentGenerationSection => '內容生成';

  @override
  String get aboutSection => '關於';

  @override
  String get writingStyleLabel => '寫作風格';

  @override
  String get writingStyleCreative => '創意 - 富有想像力和表現力';

  @override
  String get writingStyleBalanced => '平衡 - 中等創意';

  @override
  String get writingStylePrecise => '精確 - 清晰簡潔';

  @override
  String get contentLanguageLabel => '內容語言';

  @override
  String get uiLanguageLabel => '介面語言';

  @override
  String get uiLanguageSystemDefault => '系統預設';

  @override
  String get toneLabel => '語氣';

  @override
  String get toneCasual => '休閒 - 友善輕鬆';

  @override
  String get toneNeutral => '中立 - 平衡語氣';

  @override
  String get toneFormal => '正式 - 專業嚴肅';

  @override
  String get vocabularyLevelLabel => '詞彙級別';

  @override
  String get vocabularySimple => '簡單 - 易於理解';

  @override
  String get vocabularyModerate => '中等 - 平衡詞彙';

  @override
  String get vocabularyAdvanced => '高級 - 豐富詞彙';

  @override
  String get favoriteAuthorLabel => '喜愛的作者';

  @override
  String get favoriteAuthorHint => '例如：J.K. 羅琳';

  @override
  String get favoriteAuthorDescription => '輸入您喜愛的作者名稱，AI 將模仿他們的寫作風格（可選）。';

  @override
  String get defaultChapterCountLabel => '預設章節數';

  @override
  String chapterCountOption(int count) {
    return '$count 個章節';
  }

  @override
  String get shortBook => '短書';

  @override
  String get standardBook => '標準書籍';

  @override
  String get longerBook => '較長書籍';

  @override
  String get fullLengthNovel => '完整長篇小說';

  @override
  String get extendedNovel => '拓展長篇小說';

  @override
  String get epicLength => '史詩級長度';

  @override
  String get versionLabel => '版本';

  @override
  String get licenseLabel => '授權條款';

  @override
  String get mitLicense => 'MIT 授權條款';

  @override
  String get clearAuthor => '清除';

  @override
  String get saveAuthor => '保存';
}
