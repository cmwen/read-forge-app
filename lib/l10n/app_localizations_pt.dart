// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'ReadForge';

  @override
  String get libraryTitle => 'ReadForge';

  @override
  String get newBook => 'Novo Livro';

  @override
  String get noBooksYet => 'Ainda não há livros';

  @override
  String get tapToCreateFirstBook =>
      'Toque no botão + para criar seu primeiro livro';

  @override
  String get createNewBook => 'Criar Novo Livro';

  @override
  String get createBookInstructions =>
      'Preencha pelo menos um campo abaixo. Se você não fornecer um título, a IA pode gerar um para você com base em sua descrição ou objetivo.';

  @override
  String get bookTitleOptional => 'Título do Livro (Opcional)';

  @override
  String get bookTitleHint =>
      'Digite um título ou deixe vazio para geração por IA';

  @override
  String get descriptionOptional => 'Descrição (Opcional)';

  @override
  String get descriptionHint => 'Descreva sobre o que é o livro';

  @override
  String get purposeOptional => 'Propósito/Objetivo de Aprendizagem (Opcional)';

  @override
  String get purposeHint => 'O que você quer aprender com este livro?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get create => 'Criar';

  @override
  String get fillAtLeastOneField => 'Por favor, preencha pelo menos um campo';

  @override
  String get generateTitleWithAI => 'Gerar Título com IA?';

  @override
  String noTitleProvidedPrompt(String contentType) {
    return 'Nenhum título foi fornecido. Gostaria de usar a IA para gerar um título com base em sua $contentType?';
  }

  @override
  String get skip => 'Pular';

  @override
  String get generateTitle => 'Gerar Título';

  @override
  String get generateBookTitle => 'Gerar Título do Livro';

  @override
  String get sharePromptWithAI =>
      'Compartilhe este prompt com seu assistente de IA (ChatGPT, Claude, etc.) para gerar um título.';

  @override
  String get copy => 'Copiar';

  @override
  String get pasteTitle => 'Colar Título';

  @override
  String get promptCopiedToClipboard =>
      'Prompt copiado para a área de transferência';

  @override
  String get noTitleInClipboard =>
      'Nenhum título encontrado na área de transferência. Criando livro com título provisório.';

  @override
  String bookCreatedWithTitle(String title) {
    return 'Livro criado com título gerado por IA: \"$title\"';
  }

  @override
  String get settings => 'Configurações';

  @override
  String get reading => 'Lendo';

  @override
  String get completed => 'Concluído';

  @override
  String get draft => 'Rascunho';

  @override
  String errorLoadingBooks(String error) {
    return 'Erro ao carregar livros: $error';
  }

  @override
  String get retry => 'Tentar Novamente';

  @override
  String get untitledBook => 'Livro Sem Título';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get writingPreferencesSection => 'Preferências de Escrita';

  @override
  String get contentGenerationSection => 'Geração de Conteúdo';

  @override
  String get aboutSection => 'Sobre';

  @override
  String get writingStyleLabel => 'Estilo de Escrita';

  @override
  String get writingStyleCreative => 'Criativo - Imaginativo e expressivo';

  @override
  String get writingStyleBalanced => 'Equilibrado - Criatividade moderada';

  @override
  String get writingStylePrecise => 'Preciso - Claro e conciso';

  @override
  String get contentLanguageLabel => 'Idioma do Conteúdo';

  @override
  String get uiLanguageLabel => 'Idioma da Interface';

  @override
  String get uiLanguageSystemDefault => 'Padrão do Sistema';

  @override
  String get toneLabel => 'Tom';

  @override
  String get toneCasual => 'Casual - Amigável e descontraído';

  @override
  String get toneNeutral => 'Neutro - Tom equilibrado';

  @override
  String get toneFormal => 'Formal - Profissional e sério';

  @override
  String get vocabularyLevelLabel => 'Nível de Vocabulário';

  @override
  String get vocabularySimple => 'Simples - Fácil de entender';

  @override
  String get vocabularyModerate => 'Moderado - Vocabulário equilibrado';

  @override
  String get vocabularyAdvanced => 'Avançado - Vocabulário rico';

  @override
  String get favoriteAuthorLabel => 'Autor Favorito';

  @override
  String get favoriteAuthorHint => 'ex., J.K. Rowling';

  @override
  String get favoriteAuthorDescription =>
      'Digite o nome do seu autor favorito para que a IA emule seu estilo de escrita (opcional).';

  @override
  String get defaultChapterCountLabel => 'Contagem de Capítulos Padrão';

  @override
  String chapterCountOption(int count) {
    return '$count capítulos';
  }

  @override
  String get shortBook => 'Livro curto';

  @override
  String get standardBook => 'Livro padrão';

  @override
  String get longerBook => 'Livro mais longo';

  @override
  String get fullLengthNovel => 'Romance completo';

  @override
  String get extendedNovel => 'Romance estendido';

  @override
  String get epicLength => 'Comprimento épico';

  @override
  String get versionLabel => 'Versão';

  @override
  String get licenseLabel => 'Licença';

  @override
  String get mitLicense => 'Licença MIT';

  @override
  String get clearAuthor => 'Limpar';

  @override
  String get saveAuthor => 'Salvar';

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
  String bookTitleUpdated(String title) {
    return 'Book title updated to: \"$title\"';
  }
}
