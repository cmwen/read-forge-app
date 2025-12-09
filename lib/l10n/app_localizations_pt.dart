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
