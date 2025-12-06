import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:read_forge/core/providers/database_provider.dart';
import 'package:read_forge/features/reader/presentation/reader_preferences_provider.dart';
import 'package:read_forge/core/services/llm_integration_service.dart';
import 'package:read_forge/core/domain/models/llm_response.dart';
import 'package:read_forge/core/data/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:read_forge/features/settings/presentation/app_settings_provider.dart';

/// Provider for a specific chapter
final chapterProvider = FutureProvider.family.autoDispose((
  ref,
  int chapterId,
) async {
  final repository = ref.watch(bookRepositoryProvider);
  return repository.getChapterById(chapterId);
});

/// Simple reader screen for displaying chapter content
class ReaderScreen extends ConsumerWidget {
  final int bookId;
  final int chapterId;

  const ReaderScreen({
    super.key,
    required this.bookId,
    required this.chapterId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapterAsync = ref.watch(chapterProvider(chapterId));
    final preferences = ref.watch(readerPreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: chapterAsync.when(
          data: (chapter) => Text(chapter?.title ?? 'Reader'),
          loading: () => const Text('Loading...'),
          error: (error, stackTrace) => const Text('Error'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.text_fields),
            onPressed: () => _showReaderSettings(context, ref),
          ),
        ],
      ),
      body: chapterAsync.when(
        data: (chapter) {
          if (chapter == null) {
            return const Center(child: Text('Chapter not found'));
          }

          if (chapter.content == null || chapter.content!.isEmpty) {
            return _buildEmptyContent(context, ref, chapter);
          }

          return _buildReader(context, ref, chapter, preferences);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyContent(
    BuildContext context,
    WidgetRef ref,
    dynamic chapter,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 80,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'No content yet',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Generate content for this chapter using AI',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _generateChapterContent(context, ref, chapter),
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Generate Content'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReader(
    BuildContext context,
    WidgetRef ref,
    dynamic chapter,
    dynamic preferences,
  ) {
    // Get theme colors
    final backgroundColor = _getBackgroundColor(context, preferences.theme);
    final textColor = _getTextColor(context, preferences.theme);

    // Get font family
    final fontFamily = _getFontFamily(preferences.fontFamily);

    return Container(
      color: backgroundColor,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Chapter title
          Text(
            chapter.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: fontFamily,
            ),
          ),
          const SizedBox(height: 8),
          Divider(color: textColor.withValues(alpha: 0.2)),
          const SizedBox(height: 24),

          // Chapter content - Markdown support
          MarkdownBody(
            data: chapter.content ?? _getSampleText(),
            styleSheet: MarkdownStyleSheet(
              p: TextStyle(
                height: 1.8,
                fontSize: preferences.fontSize,
                color: textColor,
                fontFamily: fontFamily,
              ),
              h1: TextStyle(
                fontSize: preferences.fontSize * 1.8,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: fontFamily,
              ),
              h2: TextStyle(
                fontSize: preferences.fontSize * 1.5,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: fontFamily,
              ),
              h3: TextStyle(
                fontSize: preferences.fontSize * 1.2,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: fontFamily,
              ),
              h4: TextStyle(
                fontSize: preferences.fontSize * 1.1,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: fontFamily,
              ),
              h5: TextStyle(
                fontSize: preferences.fontSize,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: fontFamily,
              ),
              h6: TextStyle(
                fontSize: preferences.fontSize,
                fontWeight: FontWeight.w600,
                color: textColor,
                fontFamily: fontFamily,
              ),
              strong: TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              em: TextStyle(
                fontStyle: FontStyle.italic,
                color: textColor,
              ),
              blockquote: TextStyle(
                fontSize: preferences.fontSize,
                color: textColor.withValues(alpha: 0.8),
                fontStyle: FontStyle.italic,
                fontFamily: fontFamily,
              ),
              code: TextStyle(
                fontSize: preferences.fontSize * 0.9,
                fontFamily: _getMonospaceFont(),
                backgroundColor: textColor.withValues(alpha: 0.1),
                color: textColor,
              ),
              listBullet: TextStyle(
                fontSize: preferences.fontSize,
                color: textColor,
              ),
            ),
            selectable: true,
          ),

          const SizedBox(height: 48),

          // Navigation buttons
          _buildChapterNavigation(context, ref, chapter),
        ],
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context, String theme) {
    switch (theme) {
      case 'dark':
        return const Color(0xFF1E1E1E);
      case 'sepia':
        return const Color(0xFFF5E6D3);
      case 'light':
      default:
        return Colors.white;
    }
  }

  Color _getTextColor(BuildContext context, String theme) {
    switch (theme) {
      case 'dark':
        return const Color(0xFFE0E0E0);
      case 'sepia':
        return const Color(0xFF5C4A3A);
      case 'light':
      default:
        return Colors.black87;
    }
  }

  String? _getFontFamily(String fontFamily) {
    switch (fontFamily) {
      case 'serif':
        return 'serif';
      case 'sans':
        return null; // Use system default
      case 'system':
      default:
        return null;
    }
  }

  String? _getMonospaceFont() {
    // Return null to use system default monospace font
    // Different platforms will use their appropriate monospace fonts:
    // - Android: Roboto Mono or Droid Sans Mono
    // - iOS: Courier or Menlo
    // - Web: monospace (which resolves to platform default)
    return null;
  }

  Widget _buildChapterNavigation(
    BuildContext context,
    WidgetRef ref,
    dynamic chapter,
  ) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getAdjacentChapters(ref, chapter),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data as Map<String, dynamic>;
        final previousChapter = data['previous'];
        final nextChapter = data['next'];

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (previousChapter != null)
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => ReaderScreen(
                        bookId: bookId,
                        chapterId: previousChapter.id,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.chevron_left),
                label: const Text('Previous'),
              )
            else
              const SizedBox.shrink(),
            if (nextChapter != null)
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => ReaderScreen(
                        bookId: bookId,
                        chapterId: nextChapter.id,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.chevron_right),
                label: const Text('Next'),
                iconAlignment: IconAlignment.end,
              )
            else
              const SizedBox.shrink(),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> _getAdjacentChapters(
    WidgetRef ref,
    dynamic chapter,
  ) async {
    final database = ref.read(databaseProvider);

    // Get all chapters for this book
    final allChapters =
        await (database.select(database.chapters)
              ..where((tbl) => tbl.bookId.equals(bookId))
              ..orderBy([
                (tbl) => drift.OrderingTerm(expression: tbl.orderIndex),
              ]))
            .get();

    // Find current chapter index
    final currentIndex = allChapters.indexWhere((ch) => ch.id == chapter.id);

    if (currentIndex == -1) {
      return {'previous': null, 'next': null};
    }

    return {
      'previous': currentIndex > 0 ? allChapters[currentIndex - 1] : null,
      'next': currentIndex < allChapters.length - 1
          ? allChapters[currentIndex + 1]
          : null,
    };
  }

  void _showReaderSettings(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final preferences = ref.watch(readerPreferencesProvider);
          final notifier = ref.read(readerPreferencesProvider.notifier);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reader Settings',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),

                // Font Size
                Text(
                  'Font Size',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  children: [
                    Text('A', style: TextStyle(fontSize: 12)),
                    Expanded(
                      child: Slider(
                        value: preferences.fontSize,
                        min: 12.0,
                        max: 32.0,
                        divisions: 20,
                        label: preferences.fontSize.toStringAsFixed(0),
                        onChanged: (value) => notifier.setFontSize(value),
                      ),
                    ),
                    Text('A', style: TextStyle(fontSize: 24)),
                  ],
                ),
                const SizedBox(height: 16),

                // Theme
                Text('Theme', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'light',
                      label: Text('Light'),
                      icon: Icon(Icons.light_mode),
                    ),
                    ButtonSegment(
                      value: 'dark',
                      label: Text('Dark'),
                      icon: Icon(Icons.dark_mode),
                    ),
                    ButtonSegment(
                      value: 'sepia',
                      label: Text('Sepia'),
                      icon: Icon(Icons.auto_stories),
                    ),
                  ],
                  selected: {preferences.theme},
                  onSelectionChanged: (Set<String> newSelection) {
                    notifier.setTheme(newSelection.first);
                  },
                ),
                const SizedBox(height: 16),

                // Font Family
                Text(
                  'Font Family',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'system', label: Text('System')),
                    ButtonSegment(value: 'serif', label: Text('Serif')),
                    ButtonSegment(value: 'sans', label: Text('Sans')),
                  ],
                  selected: {preferences.fontFamily},
                  onSelectionChanged: (Set<String> newSelection) {
                    notifier.setFontFamily(newSelection.first);
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  void _generateChapterContent(
    BuildContext context,
    WidgetRef ref,
    dynamic chapter,
  ) async {
    final llmService = LLMIntegrationService();

    // Get book info for context
    final database = ref.read(databaseProvider);
    final book = await (database.select(
      database.books,
    )..where((tbl) => tbl.id.equals(bookId))).getSingleOrNull();

    if (book == null) return;

    // Get previous chapters for context
    final previousChapters =
        await (database.select(database.chapters)
              ..where((tbl) => tbl.bookId.equals(bookId))
              ..where(
                (tbl) => tbl.orderIndex.isSmallerThanValue(chapter.orderIndex),
              )
              ..orderBy([
                (tbl) => drift.OrderingTerm(expression: tbl.orderIndex),
              ]))
            .get();

    final previousSummaries = previousChapters
        .where((ch) => ch.summary != null)
        .map((ch) => ch.summary!)
        .toList();

    final settings = ref.read(appSettingsProvider);
    final prompt = llmService.generateChapterPromptWithFormat(
      book.title,
      chapter.orderIndex,
      chapter.title,
      bookDescription: book.description,
      previousChapterSummaries: previousSummaries.isNotEmpty
          ? previousSummaries
          : null,
      writingStyle: settings.writingStyle,
      language: settings.language,
      tone: settings.tone,
      vocabularyLevel: settings.vocabularyLevel,
      favoriteAuthor: settings.favoriteAuthor,
    );

    if (!context.mounted) return;

    // Show dialog with options to share or copy
    final action = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate Chapter Content'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Share this prompt with your preferred AI assistant to generate chapter content.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                constraints: const BoxConstraints(maxHeight: 200),
                child: SingleChildScrollView(
                  child: SelectableText(
                    prompt,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'After getting the response, come back and paste it here.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          OutlinedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: prompt));
              Navigator.of(context).pop('copy');
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copy'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop('share'),
            icon: const Icon(Icons.share),
            label: const Text('Share'),
          ),
        ],
      ),
    );

    if (action == 'share' && context.mounted) {
      final shared = await llmService.sharePrompt(
        prompt,
        subject: 'Generate content for ${chapter.title}',
      );

      if (shared && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Prompt shared! Paste the response when ready.'),
            duration: Duration(seconds: 3),
          ),
        );
        await Future.delayed(const Duration(milliseconds: 500));
        if (context.mounted) {
          _showPasteChapterDialog(context, ref, chapter);
        }
      }
    } else if (action == 'copy' && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prompt copied to clipboard')),
      );
      _showPasteChapterDialog(context, ref, chapter);
    }
  }

  void _showPasteChapterDialog(
    BuildContext context,
    WidgetRef ref,
    dynamic chapter,
  ) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Paste Chapter Content'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Paste the generated content from your AI assistant:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                maxLines: 15,
                decoration: InputDecoration(
                  hintText:
                      'Paste content here...\n\nSupports both JSON and plain text',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                Navigator.of(context).pop();
                _processChapterContent(context, ref, chapter, text);
              }
            },
            icon: const Icon(Icons.check),
            label: const Text('Import'),
          ),
        ],
      ),
    );
  }

  void _processChapterContent(
    BuildContext context,
    WidgetRef ref,
    dynamic chapter,
    String responseText,
  ) async {
    final llmService = LLMIntegrationService();
    final validationResult = llmService.parseResponseWithValidation(responseText);

    // Check for validation errors that should block import
    if (!validationResult.isValid) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(validationResult.errorMessage ?? 'Parse Error'),
            content: SingleChildScrollView(
              child: Text(
                validationResult.errorDetails ??
                    'Unable to import content. Please check the format.',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showPasteChapterDialog(context, ref, chapter);
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
        );
      }
      return;
    }

    String content;
    if (validationResult.response is ChapterResponse) {
      content = (validationResult.response as ChapterResponse).content;
    } else {
      // Use the original text as plain text content
      // This path is reached when:
      // 1. Response is not valid JSON (validation treats it as plain text and returns null response)
      // 2. Response is valid JSON but not a ChapterResponse (e.g., TOCResponse)
      // In both cases, we use the original text which has been validated as non-empty and not a placeholder
      content = responseText;
    }

    try {
      final database = ref.read(databaseProvider);
      await (database.update(database.chapters)
            ..where((tbl) => tbl.id.equals(chapter.id)))
          .write(
            ChaptersCompanion(
              content: drift.Value(content),
              status: const drift.Value('generated'),
              wordCount: drift.Value(content.split(' ').length),
              updatedAt: drift.Value(DateTime.now()),
            ),
          );

      // Invalidate the chapter provider to refresh the UI
      ref.invalidate(chapterProvider(chapter.id));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Chapter content imported successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error importing content: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getSampleText() {
    return '''
# Sample Chapter

This is a **sample chapter** for demonstration purposes. In a real ReadForge book, this content would be generated by an *AI assistant* based on your prompts.

## Markdown Support

ReadForge now supports **Markdown formatting**, which is the standard format used by most LLMs like ChatGPT, Claude, and Gemini. This means you can:

- Use **bold** and *italic* text
- Create headers at different levels
- Make bulleted and numbered lists
- Add `inline code` and code blocks
- Include blockquotes
- And much more!

## Reading Features

The reader provides a comfortable reading experience with:

1. **Adjustable font sizes** - Scale text to your preference
2. **Multiple theme options** - Light, Dark, and Sepia themes
3. **Text selection** - Select and copy any text
4. **Bookmarking capabilities** - Save your place
5. **Reading progress tracking** - Know how far you've read

### Navigation

You can navigate between chapters using the Previous and Next buttons at the bottom of the screen.

> **Tip:** ReadForge keeps your data completely local on your device, giving you full control and ownership of your AI-generated books.

## Getting Started

To add real content to this chapter:

1. Go back to the book's Table of Contents
2. Tap "Generate TOC" to create a complete chapter outline
3. Use the AI prompts to generate content for each chapter
4. Paste the generated content back into ReadForge

### Example Formatting

You can format text like:
- **Bold text** with `**bold**`
- *Italic text* with `*italic*`
- `Code` with backticks
- Lists like this one!

---

*Enjoy creating and reading your AI-powered books!*
''';
  }
}
