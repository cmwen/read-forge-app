import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_forge/features/settings/presentation/app_settings_provider.dart';
import 'package:read_forge/features/settings/domain/app_settings.dart';
import 'package:read_forge/l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Settings screen for app-wide preferences
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          // Writing Preferences Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n.writingPreferencesSection,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.style),
            title: Text(l10n.writingStyleLabel),
            subtitle: Text(
              _getWritingStyleLabel(context, settings.writingStyle),
            ),
            onTap: () =>
                _showWritingStylePicker(context, notifier, settings, l10n),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.contentLanguageLabel),
            subtitle: Text(settings.language),
            onTap: () =>
                _showContentLanguagePicker(context, notifier, settings, l10n),
          ),
          ListTile(
            leading: const Icon(Icons.mood),
            title: Text(l10n.toneLabel),
            subtitle: Text(_getToneLabel(context, settings.tone)),
            onTap: () => _showTonePicker(context, notifier, settings, l10n),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: Text(l10n.vocabularyLevelLabel),
            subtitle: Text(
              _getVocabularyLabel(context, settings.vocabularyLevel),
            ),
            onTap: () =>
                _showVocabularyPicker(context, notifier, settings, l10n),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(l10n.favoriteAuthorLabel),
            subtitle: Text(settings.favoriteAuthor ?? l10n.favoriteAuthorHint),
            onTap: () => _showAuthorDialog(context, notifier, settings, l10n),
          ),

          const Divider(),

          // App Preferences Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'App Preferences',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.public),
            title: Text(l10n.uiLanguageLabel),
            subtitle: Text(
              _getUILanguageLabel(context, settings.uiLanguageCode),
            ),
            onTap: () =>
                _showUILanguagePicker(context, notifier, settings, l10n),
          ),

          const Divider(),

          // Content Generation Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n.contentGenerationSection,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.format_list_numbered),
            title: Text(l10n.defaultChapterCountLabel),
            subtitle: Text(l10n.chapterCountOption(settings.suggestedChapters)),
            onTap: () =>
                _showChapterCountPicker(context, notifier, settings, l10n),
          ),

          const Divider(),

          // About Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n.aboutSection,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final version = snapshot.data?.version ?? '0.1.0';
              final buildNumber = snapshot.data?.buildNumber ?? '1';
              return ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(l10n.versionLabel),
                subtitle: Text('$version+$buildNumber'),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: Text(l10n.licenseLabel),
            subtitle: Text(l10n.mitLicense),
          ),
        ],
      ),
    );
  }

  String _getWritingStyleLabel(BuildContext context, String style) {
    final l10n = AppLocalizations.of(context)!;
    switch (style) {
      case 'creative':
        return l10n.writingStyleCreative;
      case 'precise':
        return l10n.writingStylePrecise;
      case 'balanced':
      default:
        return l10n.writingStyleBalanced;
    }
  }

  String _getUILanguageLabel(BuildContext context, String code) {
    final l10n = AppLocalizations.of(context)!;
    if (code == 'system') {
      return l10n.uiLanguageSystemDefault;
    }

    final languageNames = {
      'en': 'English',
      'es': 'Español',
      'zh': '中文 (简体)',
      'zh_TW': '繁體中文',
      'fr': 'Français',
      'de': 'Deutsch',
      'pt': 'Português',
      'ja': '日本語',
      'ko': '한국어',
      'ar': 'العربية',
      'hi': 'हिन्दी',
      'ru': 'Русский',
    };
    return languageNames[code] ?? code;
  }

  String _getToneLabel(BuildContext context, String tone) {
    final l10n = AppLocalizations.of(context)!;
    switch (tone) {
      case 'casual':
        return l10n.toneCasual;
      case 'formal':
        return l10n.toneFormal;
      case 'neutral':
      default:
        return l10n.toneNeutral;
    }
  }

  String _getVocabularyLabel(BuildContext context, String level) {
    final l10n = AppLocalizations.of(context)!;
    switch (level) {
      case 'simple':
        return l10n.vocabularySimple;
      case 'advanced':
        return l10n.vocabularyAdvanced;
      case 'moderate':
      default:
        return l10n.vocabularyModerate;
    }
  }

  void _showWritingStylePicker(
    BuildContext context,
    AppSettingsNotifier notifier,
    AppSettings settings,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.writingStyleLabel),
        children: [
          _buildOptionTile(
            context,
            l10n.writingStyleCreative.split(' - ')[0],
            l10n.writingStyleCreative.split(' - ')[1],
            'creative',
            settings.writingStyle,
            (value) {
              notifier.setWritingStyle(value);
              Navigator.pop(context);
            },
          ),
          _buildOptionTile(
            context,
            l10n.writingStyleBalanced.split(' - ')[0],
            l10n.writingStyleBalanced.split(' - ')[1],
            'balanced',
            settings.writingStyle,
            (value) {
              notifier.setWritingStyle(value);
              Navigator.pop(context);
            },
          ),
          _buildOptionTile(
            context,
            l10n.writingStylePrecise.split(' - ')[0],
            l10n.writingStylePrecise.split(' - ')[1],
            'precise',
            settings.writingStyle,
            (value) {
              notifier.setWritingStyle(value);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showContentLanguagePicker(
    BuildContext context,
    AppSettingsNotifier notifier,
    AppSettings settings,
    AppLocalizations l10n,
  ) {
    final languages = [
      'English',
      'Spanish',
      'French',
      'German',
      'Italian',
      'Portuguese',
      'Chinese',
      'Japanese',
      'Korean',
    ];

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.contentLanguageLabel),
        children: languages
            .map(
              (language) => _buildOptionTile(
                context,
                language,
                null,
                language,
                settings.language,
                (value) {
                  notifier.setLanguage(value);
                  Navigator.pop(context);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  void _showUILanguagePicker(
    BuildContext context,
    AppSettingsNotifier notifier,
    AppSettings settings,
    AppLocalizations l10n,
  ) {
    final languageOptions = [
      (code: 'system', label: l10n.uiLanguageSystemDefault),
      (code: 'en', label: 'English'),
      (code: 'es', label: 'Español'),
      (code: 'zh', label: '中文 (简体)'),
      (code: 'zh_TW', label: '繁體中文'),
      (code: 'fr', label: 'Français'),
      (code: 'de', label: 'Deutsch'),
      (code: 'pt', label: 'Português'),
      (code: 'ja', label: '日本語'),
      (code: 'ko', label: '한국어'),
      (code: 'ar', label: 'العربية'),
      (code: 'hi', label: 'हिन्दी'),
      (code: 'ru', label: 'Русский'),
    ];

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.uiLanguageLabel),
        children: languageOptions
            .map(
              (option) => _buildOptionTile(
                context,
                option.label,
                null,
                option.code,
                settings.uiLanguageCode,
                (value) {
                  notifier.setUILanguage(value);
                  Navigator.pop(context);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  void _showTonePicker(
    BuildContext context,
    AppSettingsNotifier notifier,
    AppSettings settings,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.toneLabel),
        children: [
          _buildOptionTile(
            context,
            l10n.toneCasual.split(' - ')[0],
            l10n.toneCasual.split(' - ')[1],
            'casual',
            settings.tone,
            (value) {
              notifier.setTone(value);
              Navigator.pop(context);
            },
          ),
          _buildOptionTile(
            context,
            l10n.toneNeutral.split(' - ')[0],
            l10n.toneNeutral.split(' - ')[1],
            'neutral',
            settings.tone,
            (value) {
              notifier.setTone(value);
              Navigator.pop(context);
            },
          ),
          _buildOptionTile(
            context,
            l10n.toneFormal.split(' - ')[0],
            l10n.toneFormal.split(' - ')[1],
            'formal',
            settings.tone,
            (value) {
              notifier.setTone(value);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showVocabularyPicker(
    BuildContext context,
    AppSettingsNotifier notifier,
    AppSettings settings,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.vocabularyLevelLabel),
        children: [
          _buildOptionTile(
            context,
            l10n.vocabularySimple.split(' - ')[0],
            l10n.vocabularySimple.split(' - ')[1],
            'simple',
            settings.vocabularyLevel,
            (value) {
              notifier.setVocabularyLevel(value);
              Navigator.pop(context);
            },
          ),
          _buildOptionTile(
            context,
            l10n.vocabularyModerate.split(' - ')[0],
            l10n.vocabularyModerate.split(' - ')[1],
            'moderate',
            settings.vocabularyLevel,
            (value) {
              notifier.setVocabularyLevel(value);
              Navigator.pop(context);
            },
          ),
          _buildOptionTile(
            context,
            l10n.vocabularyAdvanced.split(' - ')[0],
            l10n.vocabularyAdvanced.split(' - ')[1],
            'advanced',
            settings.vocabularyLevel,
            (value) {
              notifier.setVocabularyLevel(value);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context,
    String title,
    String? subtitle,
    String value,
    String currentValue,
    void Function(String) onTap,
  ) {
    final isSelected = value == currentValue;
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: isSelected ? const Icon(Icons.check) : null,
      selected: isSelected,
      onTap: () => onTap(value),
    );
  }

  void _showChapterCountPicker(
    BuildContext context,
    AppSettingsNotifier notifier,
    AppSettings settings,
    AppLocalizations l10n,
  ) {
    // Define chapter count options
    final chapterOptions = [
      (count: 5, label: l10n.shortBook),
      (count: 10, label: l10n.standardBook),
      (count: 15, label: l10n.longerBook),
      (count: 20, label: l10n.fullLengthNovel),
      (count: 25, label: l10n.extendedNovel),
      (count: 30, label: l10n.epicLength),
    ];

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.defaultChapterCountLabel),
        children: chapterOptions
            .map(
              (option) => _buildOptionTile(
                context,
                l10n.chapterCountOption(option.count),
                option.label,
                '${option.count}',
                '${settings.suggestedChapters}',
                (value) {
                  notifier.setSuggestedChapters(int.parse(value));
                  Navigator.pop(context);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  void _showAuthorDialog(
    BuildContext context,
    AppSettingsNotifier notifier,
    AppSettings settings,
    AppLocalizations l10n,
  ) {
    final controller = TextEditingController(
      text: settings.favoriteAuthor ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.favoriteAuthorLabel),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.favoriteAuthorDescription),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: l10n.favoriteAuthorLabel,
                hintText: l10n.favoriteAuthorHint,
                border: const OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          if (settings.favoriteAuthor != null)
            TextButton(
              onPressed: () {
                notifier.setFavoriteAuthor(null);
                Navigator.of(context).pop();
              },
              child: Text(l10n.clearAuthor),
            ),
          FilledButton(
            onPressed: () {
              final author = controller.text.trim();
              notifier.setFavoriteAuthor(author.isEmpty ? null : author);
              Navigator.of(context).pop();
            },
            child: Text(l10n.saveAuthor),
          ),
        ],
      ),
    );
  }
}
