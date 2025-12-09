// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'ReadForge';

  @override
  String get libraryTitle => 'ReadForge';

  @override
  String get newBook => 'Nouveau Livre';

  @override
  String get noBooksYet => 'Pas encore de livres';

  @override
  String get tapToCreateFirstBook =>
      'Appuyez sur le bouton + pour créer votre premier livre';

  @override
  String get createNewBook => 'Créer un Nouveau Livre';

  @override
  String get createBookInstructions =>
      'Remplissez au moins un champ ci-dessous. Si vous ne fournissez pas de titre, l\'IA peut en générer un pour vous en fonction de votre description ou objectif.';

  @override
  String get bookTitleOptional => 'Titre du Livre (Optionnel)';

  @override
  String get bookTitleHint =>
      'Entrez un titre ou laissez vide pour la génération par IA';

  @override
  String get descriptionOptional => 'Description (Optionnel)';

  @override
  String get descriptionHint => 'Décrivez le contenu du livre';

  @override
  String get purposeOptional => 'Objectif/But d\'Apprentissage (Optionnel)';

  @override
  String get purposeHint => 'Que voulez-vous apprendre de ce livre ?';

  @override
  String get cancel => 'Annuler';

  @override
  String get create => 'Créer';

  @override
  String get fillAtLeastOneField => 'Veuillez remplir au moins un champ';

  @override
  String get generateTitleWithAI => 'Générer le Titre avec l\'IA ?';

  @override
  String noTitleProvidedPrompt(String contentType) {
    return 'Aucun titre fourni. Souhaitez-vous utiliser l\'IA pour générer un titre basé sur votre $contentType ?';
  }

  @override
  String get skip => 'Ignorer';

  @override
  String get generateTitle => 'Générer le Titre';

  @override
  String get generateBookTitle => 'Générer le Titre du Livre';

  @override
  String get sharePromptWithAI =>
      'Partagez cette invite avec votre assistant IA (ChatGPT, Claude, etc.) pour générer un titre.';

  @override
  String get copy => 'Copier';

  @override
  String get pasteTitle => 'Coller le Titre';

  @override
  String get promptCopiedToClipboard => 'Invite copiée dans le presse-papiers';

  @override
  String get noTitleInClipboard =>
      'Aucun titre trouvé dans le presse-papiers. Création du livre avec un titre provisoire.';

  @override
  String bookCreatedWithTitle(String title) {
    return 'Livre créé avec un titre généré par IA : \"$title\"';
  }

  @override
  String get settings => 'Paramètres';

  @override
  String get reading => 'En Lecture';

  @override
  String get completed => 'Terminé';

  @override
  String get draft => 'Brouillon';

  @override
  String errorLoadingBooks(String error) {
    return 'Erreur lors du chargement des livres : $error';
  }

  @override
  String get retry => 'Réessayer';

  @override
  String get untitledBook => 'Livre Sans Titre';
}
