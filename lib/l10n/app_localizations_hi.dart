// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'ReadForge';

  @override
  String get libraryTitle => 'ReadForge';

  @override
  String get newBook => 'नई पुस्तक';

  @override
  String get noBooksYet => 'अभी तक कोई पुस्तक नहीं';

  @override
  String get tapToCreateFirstBook =>
      'अपनी पहली पुस्तक बनाने के लिए + बटन पर टैप करें';

  @override
  String get createNewBook => 'नई पुस्तक बनाएं';

  @override
  String get createBookInstructions =>
      'नीचे कम से कम एक फ़ील्ड भरें। यदि आप शीर्षक नहीं देते हैं, तो AI आपके विवरण या उद्देश्य के आधार पर एक शीर्षक बना सकता है।';

  @override
  String get bookTitleOptional => 'पुस्तक का शीर्षक (वैकल्पिक)';

  @override
  String get bookTitleHint =>
      'एक शीर्षक दर्ज करें या AI द्वारा बनाने के लिए खाली छोड़ दें';

  @override
  String get descriptionOptional => 'विवरण (वैकल्पिक)';

  @override
  String get descriptionHint => 'पुस्तक के बारे में बताएं';

  @override
  String get purposeOptional => 'उद्देश्य/सीखने का लक्ष्य (वैकल्पिक)';

  @override
  String get purposeHint => 'आप इस पुस्तक से क्या सीखना चाहते हैं?';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get create => 'बनाएं';

  @override
  String get fillAtLeastOneField => 'कृपया कम से कम एक फ़ील्ड भरें';

  @override
  String get generateTitleWithAI => 'AI से शीर्षक बनाएं?';

  @override
  String noTitleProvidedPrompt(String contentType) {
    return 'कोई शीर्षक नहीं दिया गया। क्या आप अपने $contentType के आधार पर शीर्षक बनाने के लिए AI का उपयोग करना चाहते हैं?';
  }

  @override
  String get skip => 'छोड़ें';

  @override
  String get generateTitle => 'शीर्षक बनाएं';

  @override
  String get generateBookTitle => 'पुस्तक का शीर्षक बनाएं';

  @override
  String get sharePromptWithAI =>
      'शीर्षक बनाने के लिए इस प्रॉम्प्ट को अपने AI सहायक (ChatGPT, Claude, आदि) के साथ साझा करें।';

  @override
  String get copy => 'कॉपी करें';

  @override
  String get pasteTitle => 'शीर्षक पेस्ट करें';

  @override
  String get promptCopiedToClipboard => 'प्रॉम्प्ट क्लिपबोर्ड पर कॉपी किया गया';

  @override
  String get noTitleInClipboard =>
      'क्लिपबोर्ड में कोई शीर्षक नहीं मिला। प्लेसहोल्डर शीर्षक के साथ पुस्तक बना रहे हैं।';

  @override
  String bookCreatedWithTitle(String title) {
    return 'AI-जनित शीर्षक के साथ पुस्तक बनाई गई: \"$title\"';
  }

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get reading => 'पढ़ रहे हैं';

  @override
  String get completed => 'पूर्ण';

  @override
  String get draft => 'ड्राफ़्ट';

  @override
  String errorLoadingBooks(String error) {
    return 'पुस्तकें लोड करने में त्रुटि: $error';
  }

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get untitledBook => 'शीर्षक रहित पुस्तक';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get writingPreferencesSection => 'लेखन प्राथमिकताएं';

  @override
  String get contentGenerationSection => 'सामग्री निर्माण';

  @override
  String get aboutSection => 'बारे में';

  @override
  String get writingStyleLabel => 'लेखन शैली';

  @override
  String get writingStyleCreative => 'रचनात्मक - कल्पनाशील और अभिव्यक्तिपूर्ण';

  @override
  String get writingStyleBalanced => 'संतुलित - मध्यम रचनात्मकता';

  @override
  String get writingStylePrecise => 'सटीक - स्पष्ट और संक्षिप्त';

  @override
  String get contentLanguageLabel => 'सामग्री भाषा';

  @override
  String get uiLanguageLabel => 'यूआई भाषा';

  @override
  String get uiLanguageSystemDefault => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get toneLabel => 'स्वर';

  @override
  String get toneCasual => 'आकस्मिक - मैत्रीपूर्ण और आरामदायक';

  @override
  String get toneNeutral => 'तटस्थ - संतुलित स्वर';

  @override
  String get toneFormal => 'औपचारिक - व्यावसायिक और गंभीर';

  @override
  String get vocabularyLevelLabel => 'शब्दावली स्तर';

  @override
  String get vocabularySimple => 'सरल - समझने में आसान';

  @override
  String get vocabularyModerate => 'मध्यम - संतुलित शब्दावली';

  @override
  String get vocabularyAdvanced => 'उन्नत - समृद्ध शब्दावली';

  @override
  String get favoriteAuthorLabel => 'पसंदीदा लेखक';

  @override
  String get favoriteAuthorHint => 'उदा.: जे.के. राउलिंग';

  @override
  String get favoriteAuthorDescription =>
      'अपने पसंदीदा लेखक का नाम दर्ज करें ताकि कृत्रिम बुद्धिमत्ता उनकी लेखन शैली की नकल कर सके (वैकल्पिक)।';

  @override
  String get defaultChapterCountLabel => 'डिफ़ॉल्ट अध्याय संख्या';

  @override
  String chapterCountOption(int count) {
    return '$count अध्याय';
  }

  @override
  String get shortBook => 'छोटी किताब';

  @override
  String get standardBook => 'मानक किताब';

  @override
  String get longerBook => 'लंबी किताब';

  @override
  String get fullLengthNovel => 'पूर्ण लंबाई उपन्यास';

  @override
  String get extendedNovel => 'विस्तारित उपन्यास';

  @override
  String get epicLength => 'महाकाव्य लंबाई';

  @override
  String get versionLabel => 'संस्करण';

  @override
  String get licenseLabel => 'लाइसेंस';

  @override
  String get mitLicense => 'MIT लाइसेंस';

  @override
  String get clearAuthor => 'साफ करें';

  @override
  String get saveAuthor => 'सहेजें';
}
