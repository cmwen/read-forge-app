import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_forge/features/settings/presentation/app_settings_provider.dart';
import 'package:read_forge/features/settings/domain/app_settings.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Settings screen for app-wide preferences
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Writing Preferences Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Writing Preferences',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.style),
            title: const Text('Writing Style'),
            subtitle: Text(_getWritingStyleLabel(settings.writingStyle)),
            onTap: () => _showWritingStylePicker(context, notifier, settings),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: Text(settings.language),
            onTap: () => _showLanguagePicker(context, notifier, settings),
          ),
          ListTile(
            leading: const Icon(Icons.mood),
            title: const Text('Tone'),
            subtitle: Text(_getToneLabel(settings.tone)),
            onTap: () => _showTonePicker(context, notifier, settings),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text('Vocabulary Level'),
            subtitle: Text(_getVocabularyLabel(settings.vocabularyLevel)),
            onTap: () => _showVocabularyPicker(context, notifier, settings),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Favorite Author'),
            subtitle: Text(
              settings.favoriteAuthor ?? 'Not set (for style inspiration)',
            ),
            onTap: () => _showAuthorDialog(context, notifier, settings),
          ),

          const Divider(),

          // Content Generation Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Content Generation',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.format_list_numbered),
            title: const Text('Default Chapter Count'),
            subtitle: Text('${settings.suggestedChapters} chapters'),
            onTap: () => _showChapterCountPicker(context, notifier, settings),
          ),

          const Divider(),

          // About Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'About',
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
                title: const Text('Version'),
                subtitle: Text('$version+$buildNumber'),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('License'),
            subtitle: const Text('MIT License'),
          ),
        ],
      ),
    );
  }

  String _getWritingStyleLabel(String style) {
    switch (style) {
      case 'creative':
        return 'Creative - Imaginative and expressive';
      case 'precise':
        return 'Precise - Clear and concise';
      case 'balanced':
      default:
        return 'Balanced - Moderate creativity';
    }
  }

  String _getToneLabel(String tone) {
    switch (tone) {
      case 'casual':
        return 'Casual - Friendly and relaxed';
      case 'formal':
        return 'Formal - Professional and serious';
      case 'neutral':
      default:
        return 'Neutral - Balanced tone';
    }
  }

  String _getVocabularyLabel(String level) {
    switch (level) {
      case 'simple':
        return 'Simple - Easy to understand';
      case 'advanced':
        return 'Advanced - Rich vocabulary';
      case 'moderate':
      default:
        return 'Moderate - Balanced vocabulary';
    }
  }

  void _showWritingStylePicker(
    BuildContext context,
    AppSettingsNotifier notifier,
    AppSettings settings,
  ) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Writing Style'),
        children: [
          _buildOptionTile(
            context,
            'Creative',
            'Imaginative and expressive',
            'creative',
            settings.writingStyle,
            (value) {
              notifier.setWritingStyle(value);
              Navigator.pop(context);
            },
          ),
          _buildOptionTile(
            context,
            'Balanced',
            'Moderate creativity',
            'balanced',
            settings.writingStyle,
            (value) {
              notifier.setWritingStyle(value);
              Navigator.pop(context);
            },
          ),
          _buildOptionTile(
            context,
            'Precise',
            'Clear and concise',
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

  void _showLanguagePicker(
    BuildContext context,
    AppSettingsNotifier notifier,
    AppSettings settings,
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
        title: const Text('Language'),
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

  void _showTonePicker(
    BuildContext context,
    AppSettingsNotifier notifier,
    AppSettings settings,
  ) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Tone'),
        children: [
          _buildOptionTile(
            context,
            'Casual',
            'Friendly and relaxed',
            'casual',
            settings.tone,
            (value) {
              notifier.setTone(value);
              Navigator.pop(context);
            },
          ),
          _buildOptionTile(
            context,
            'Neutral',
            'Balanced tone',
            'neutral',
            settings.tone,
            (value) {
              notifier.setTone(value);
              Navigator.pop(context);
            },
          ),
          _buildOptionTile(
            context,
            'Formal',
            'Professional and serious',
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
  ) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Vocabulary Level'),
        children: [
          _buildOptionTile(
            context,
            'Simple',
            'Easy to understand',
            'simple',
            settings.vocabularyLevel,
            (value) {
              notifier.setVocabularyLevel(value);
              Navigator.pop(context);
            },
          ),
          _buildOptionTile(
            context,
            'Moderate',
            'Balanced vocabulary',
            'moderate',
            settings.vocabularyLevel,
            (value) {
              notifier.setVocabularyLevel(value);
              Navigator.pop(context);
            },
          ),
          _buildOptionTile(
            context,
            'Advanced',
            'Rich vocabulary',
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
  ) {
    // Define chapter count options
    final chapterOptions = [
      (count: 5, label: 'Short book'),
      (count: 10, label: 'Standard book'),
      (count: 15, label: 'Longer book'),
      (count: 20, label: 'Full-length novel'),
      (count: 25, label: 'Extended novel'),
      (count: 30, label: 'Epic length'),
    ];

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Default Chapter Count'),
        children: chapterOptions
            .map(
              (option) => _buildOptionTile(
                context,
                '${option.count} chapters',
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
  ) {
    final controller = TextEditingController(
      text: settings.favoriteAuthor ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Favorite Author'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter the name of your favorite author for AI to emulate their writing style (optional).',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Author Name',
                hintText: 'e.g., J.K. Rowling',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          if (settings.favoriteAuthor != null)
            TextButton(
              onPressed: () {
                notifier.setFavoriteAuthor(null);
                Navigator.of(context).pop();
              },
              child: const Text('Clear'),
            ),
          FilledButton(
            onPressed: () {
              final author = controller.text.trim();
              notifier.setFavoriteAuthor(author.isEmpty ? null : author);
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
