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

  @override
  String get textToSpeech => 'Text to Speech';

  @override
  String get playbackSpeed => 'Playback Speed';
}
