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
}
