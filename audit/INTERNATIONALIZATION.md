# Internationalization (i18n) Guide

ReadForge supports multiple languages to make the app accessible to users worldwide.

## Supported Languages

- 🇬🇧 **English** (en) - Default
- 🇪🇸 **Spanish** (es)
- 🇨🇳 **Chinese Simplified** (zh)
- 🇹🇼 **Chinese Traditional** (zh_TW) - Taiwan
- 🇫🇷 **French** (fr)
- 🇩🇪 **German** (de)
- 🇵🇹 **Portuguese** (pt)
- 🇯🇵 **Japanese** (ja)
- 🇰🇷 **Korean** (ko)
- 🇸🇦 **Arabic** (ar)
- 🇮🇳 **Hindi** (hi)
- 🇷🇺 **Russian** (ru)

## How Language Selection Works

ReadForge automatically uses your device's system language. If your device is set to one of the supported languages, the app will display in that language. Otherwise, it defaults to English.

### Changing the App Language

To change the language in ReadForge:
1. Go to your device's **Settings**
2. Navigate to **Language & Region** (or **Language & Input** on Android)
3. Select your preferred language
4. Restart the ReadForge app

The app will automatically detect and use your new language preference.

## Features with i18n Support

All user-facing text in the app is translated, including:

- ✅ Navigation labels and buttons
- ✅ Book creation dialog
- ✅ Status messages and labels
- ✅ Error messages
- ✅ Settings screens
- ✅ Book statuses (Draft, Reading, Completed)
- ✅ AI prompt generation dialogs

## For Developers: Adding New Languages

If you want to contribute translations for a new language:

### 1. Create a New ARB File

Create a new file in `lib/l10n/` named `app_[locale].arb` (e.g., `app_fr.arb` for French):

```json
{
  "@@locale": "fr",
  "appTitle": "ReadForge",
  "libraryTitle": "ReadForge",
  "newBook": "Nouveau Livre",
  ...
}
```

### 2. Copy Translations from English Template

Use `lib/l10n/app_en.arb` as a template. Copy all keys and translate the values:

```json
{
  "@@locale": "fr",
  "createNewBook": "Créer un Nouveau Livre",
  "bookTitleOptional": "Titre du Livre (Optionnel)",
  ...
}
```

### 3. Add the Locale to main.dart

Update the `supportedLocales` list in `lib/main.dart`:

```dart
supportedLocales: const [
  Locale('en'), // English
  Locale('es'), // Spanish
  Locale('zh'), // Chinese
  Locale('fr'), // French  <- Add new locale
],
```

### 4. Generate Localization Files

Run the following command to generate the Dart localization files:

```bash
flutter gen-l10n
```

Or simply run:

```bash
flutter pub get
```

The localization files will be automatically generated in `lib/l10n/`.

### 5. Test Your Translation

1. Change your device language to the new language
2. Run the app: `flutter run`
3. Verify all strings are properly translated

## Translation Guidelines

When translating:

1. **Keep Placeholders**: Maintain placeholders like `{title}`, `{error}`, `{contentType}` exactly as they are
2. **Match Tone**: Try to match the friendly, informal tone of the English version
3. **Technical Terms**: Keep technical terms like "AI", "ChatGPT", "Claude" as-is
4. **Context Matters**: Consider the context where each string appears (button, dialog, message, etc.)
5. **Test Thoroughly**: Always test your translations in the app to ensure they fit properly in the UI

## File Structure

```
lib/l10n/
├── app_en.arb              # English (source)
├── app_es.arb              # Spanish
├── app_zh.arb              # Chinese
├── app_localizations.dart  # Generated - do not edit
├── app_localizations_en.dart  # Generated - do not edit
├── app_localizations_es.dart  # Generated - do not edit
└── app_localizations_zh.dart  # Generated - do not edit
```

## Common Issues

### Translation Not Appearing

1. Make sure you ran `flutter pub get` after creating/modifying ARB files
2. Check that your ARB file is properly formatted JSON
3. Verify the locale code matches in both the filename and `@@locale` field
4. Restart the app after changing device language

### Missing Placeholder Error

If you get an error about missing placeholders:
- Check that all placeholders from the English template are present in your translation
- Placeholders must use the exact same names: `{title}`, `{error}`, etc.

### Build Errors After Adding Translations

1. Run `flutter clean`
2. Run `flutter pub get`
3. Try rebuilding the app

## AI Prompts and Internationalization

**Important**: The AI prompts themselves (for generating book content) are currently only generated in English, regardless of the app's display language. This is intentional as most AI models work best with English prompts.

However, you can:
- Set your preferred **output language** in Settings → Language
- The AI will generate content in your specified language
- The app UI will still respect your device's language setting

## Contributing Translations

We welcome contributions for new languages! Please:

1. Fork the repository
2. Create a new branch: `git checkout -b add-french-translation`
3. Add your ARB file with complete translations
4. Test thoroughly
5. Submit a pull request

Make sure to:
- Translate all strings (check against `app_en.arb`)
- Test the app with your new language
- Include screenshots in your PR

## Questions?

If you have questions about internationalization:
- Open an issue on GitHub
- Check existing translations for examples
- Refer to Flutter's [internationalization documentation](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
