import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:read_forge/core/providers/database_provider.dart';
import 'package:read_forge/features/reader/presentation/reader_preferences_provider.dart';
import 'package:read_forge/features/reader/presentation/reading_progress_provider.dart';
import 'package:read_forge/features/reader/presentation/bookmarks_dialog.dart';
import 'package:read_forge/features/reader/presentation/notes_dialog.dart';
import 'package:read_forge/features/reader/presentation/tts_provider.dart';
import 'package:read_forge/features/reader/presentation/tts_player_screen.dart';
import 'package:read_forge/features/reader/presentation/tts_mini_player.dart';
import 'package:read_forge/core/services/llm_integration_service.dart';
import 'package:read_forge/core/domain/models/llm_response.dart';
import 'package:read_forge/core/data/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:read_forge/features/settings/presentation/app_settings_provider.dart';
import 'package:read_forge/l10n/app_localizations.dart';

/// Provider for a specific chapter
final chapterProvider = FutureProvider.family.autoDispose((
  ref,
  int chapterId,
) async {
  final repository = ref.watch(bookRepositoryProvider);
  return repository.getChapterById(chapterId);
});

/// Simple reader screen for displaying chapter content
class ReaderScreen extends ConsumerStatefulWidget {
  final int bookId;
  final int chapterId;

  const ReaderScreen({
    super.key,
    required this.bookId,
    required this.chapterId,
  });

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  bool _playerScreenOpen = false;

  // Listen to TTS state and navigate to player screen when playing
  @override
  void initState() {
    super.initState();
    // Listen to TTS state changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(ttsProvider, (previous, next) {
        if (!mounted) return;

        // Navigate to player screen when TTS starts playing (only once)
        if (next.isPlaying &&
            (previous?.isPlaying != true) &&
            !_playerScreenOpen) {
          _playerScreenOpen = true;
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => TtsPlayerScreen(
                    bookId: widget.bookId,
                    chapterId: widget.chapterId,
                  ),
                ),
              )
              .then((_) {
                _playerScreenOpen = false;
              });
        }
      });
    });
  }

  @override
  void dispose() {
    // Progress is already saved before navigation in _buildChapterNavigation
    // and when navigating to TTS player. Don't use ref here as it's unsafe
    // when the widget is being unmounted.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chapterAsync = ref.watch(chapterProvider(widget.chapterId));
    final preferences = ref.watch(readerPreferencesProvider);
    final ttsState = ref.watch(ttsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: chapterAsync.when(
          data: (chapter) => Text(chapter?.title ?? l10n.reader),
          loading: () => Text(l10n.loading),
          error: (error, stackTrace) => Text(l10n.error),
        ),
        actions: [
          // TTS controls - show different button based on state
          Consumer(
            builder: (context, ref, _) {
              final ttsState = ref.watch(ttsProvider);
              if (ttsState.isPlaying || ttsState.currentText != null) {
                // Show "Now Playing" button to open player
                return IconButton(
                  icon: Badge(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(Icons.graphic_eq),
                  ),
                  onPressed: () {
                    if (!_playerScreenOpen) {
                      _playerScreenOpen = true;
                      Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder: (context) => TtsPlayerScreen(
                                bookId: widget.bookId,
                                chapterId: widget.chapterId,
                              ),
                            ),
                          )
                          .then((_) {
                            _playerScreenOpen = false;
                          });
                    }
                  },
                  tooltip: l10n.textToSpeech,
                );
              }
              // Show play button when not playing
              return IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () => _startReading(context),
                tooltip: l10n.play,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () => _showBookmarksDialog(context),
            tooltip: l10n.bookmarks,
          ),
          IconButton(
            icon: const Icon(Icons.note),
            onPressed: () => _showNotesDialog(context),
            tooltip: l10n.notes,
          ),
          IconButton(
            icon: const Icon(Icons.text_fields),
            onPressed: () => _showReaderSettings(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          chapterAsync.when(
            data: (chapter) {
              if (chapter == null) {
                return Center(child: Text(l10n.chapterNotFound));
              }

              if (chapter.content == null || chapter.content!.isEmpty) {
                return _buildEmptyContent(context, chapter, l10n);
              }

              return _buildReader(context, chapter, preferences, l10n);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(l10n.errorMessage(error.toString())),
                ],
              ),
            ),
          ),
          // Floating mini player
          const TtsMiniPlayer(),
        ],
      ),
      floatingActionButton: chapterAsync.maybeWhen(
        data: (chapter) {
          if (chapter != null &&
              chapter.content != null &&
              chapter.content!.isNotEmpty) {
            // Add bottom padding when mini player is visible
            final bottomPadding =
                (ttsState.isPlaying || ttsState.currentText != null)
                ? 88.0
                : 0.0;
            return Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    heroTag: 'note_fab',
                    onPressed: () => _addNote(context),
                    tooltip: l10n.addNote,
                    child: const Icon(Icons.note_add),
                  ),
                  const SizedBox(height: 12),
                  FloatingActionButton(
                    heroTag: 'bookmark_fab',
                    onPressed: () => _addBookmark(context),
                    tooltip: l10n.addBookmark,
                    child: const Icon(Icons.bookmark_add),
                  ),
                ],
              ),
            );
          }
          return null;
        },
        orElse: () => null,
      ),
    );
  }

  Widget _buildEmptyContent(
    BuildContext context,
    dynamic chapter,
    AppLocalizations l10n,
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
              l10n.noContentYet,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.generateContentPrompt,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _generateChapterContent(context, chapter, l10n),
              icon: const Icon(Icons.auto_awesome),
              label: Text(l10n.generateContent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReader(
    BuildContext context,
    dynamic chapter,
    dynamic preferences,
    AppLocalizations l10n,
  ) {
    // Get theme colors
    final backgroundColor = _getBackgroundColor(context, preferences.theme);
    final textColor = _getTextColor(context, preferences.theme);

    // Get font family
    final fontFamily = _getFontFamily(preferences.fontFamily);

    // Get scroll controller from reading progress provider
    final progressState = ref.watch(
      readingProgressProvider(
        ReadingProgressParams(
          bookId: widget.bookId,
          chapterId: widget.chapterId,
        ),
      ),
    );

    return Container(
      color: backgroundColor,
      child: ListView(
        controller: progressState.scrollController,
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

          // Chapter content - Markdown support with text selection
          SelectionArea(
            child: MarkdownBody(
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
                em: TextStyle(fontStyle: FontStyle.italic, color: textColor),
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
              selectable: false, // Handled by parent SelectionArea
            ),
          ),

          const SizedBox(height: 48),

          // Navigation buttons
          _buildChapterNavigation(context, chapter),
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

  Widget _buildChapterNavigation(BuildContext context, dynamic chapter) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<Map<String, dynamic>>(
      future: _getAdjacentChapters(chapter),
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
                  // Save progress before navigating
                  final progressNotifier = ref.read(
                    readingProgressProvider(
                      ReadingProgressParams(
                        bookId: widget.bookId,
                        chapterId: widget.chapterId,
                      ),
                    ),
                  );
                  progressNotifier.saveProgress();

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => ReaderScreen(
                        bookId: widget.bookId,
                        chapterId: previousChapter.id,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.chevron_left),
                label: Text(l10n.previous),
              )
            else
              const SizedBox.shrink(),
            if (nextChapter != null)
              TextButton.icon(
                onPressed: () {
                  // Save progress before navigating
                  final progressNotifier = ref.read(
                    readingProgressProvider(
                      ReadingProgressParams(
                        bookId: widget.bookId,
                        chapterId: widget.chapterId,
                      ),
                    ),
                  );
                  progressNotifier.saveProgress();

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => ReaderScreen(
                        bookId: widget.bookId,
                        chapterId: nextChapter.id,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.chevron_right),
                label: Text(l10n.next),
                iconAlignment: IconAlignment.end,
              )
            else
              const SizedBox.shrink(),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> _getAdjacentChapters(dynamic chapter) async {
    final database = ref.read(databaseProvider);

    // Get all chapters for this book
    final allChapters =
        await (database.select(database.chapters)
              ..where((tbl) => tbl.bookId.equals(widget.bookId))
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

  void _showReaderSettings(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                  l10n.settings,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),

                // Font Size
                Text(
                  l10n.fontSize,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  children: [
                    const Text('A', style: TextStyle(fontSize: 12)),
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
                    const Text('A', style: TextStyle(fontSize: 24)),
                  ],
                ),
                const SizedBox(height: 16),

                // Theme
                Text(
                  l10n.theme,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(
                      value: 'light',
                      label: Text(l10n.light),
                      icon: const Icon(Icons.light_mode),
                    ),
                    ButtonSegment(
                      value: 'dark',
                      label: Text(l10n.dark),
                      icon: const Icon(Icons.dark_mode),
                    ),
                    ButtonSegment(
                      value: 'sepia',
                      label: Text(l10n.sepia),
                      icon: const Icon(Icons.auto_stories),
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
                  l10n.fontFamily,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(value: 'system', label: Text(l10n.system)),
                    ButtonSegment(value: 'serif', label: Text(l10n.serif)),
                    ButtonSegment(value: 'sans', label: Text(l10n.sans)),
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
    dynamic chapter,
    AppLocalizations l10n,
  ) async {
    final llmService = LLMIntegrationService();

    // Get book info for context
    final database = ref.read(databaseProvider);
    final book = await (database.select(
      database.books,
    )..where((tbl) => tbl.id.equals(widget.bookId))).getSingleOrNull();

    if (book == null) return;

    // Get previous chapters for context
    final previousChapters =
        await (database.select(database.chapters)
              ..where((tbl) => tbl.bookId.equals(widget.bookId))
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
        title: Text(l10n.generateChapterContent),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.shareChapterPromptMessage,
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
                l10n.afterGenerationMessage,
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
            child: Text(l10n.cancel),
          ),
          OutlinedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: prompt));
              Navigator.of(context).pop('copy');
            },
            icon: const Icon(Icons.copy),
            label: Text(l10n.copy),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop('share'),
            icon: const Icon(Icons.share),
            label: Text(l10n.share),
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
          SnackBar(
            content: Text(l10n.promptSharedMessage),
            duration: const Duration(seconds: 3),
          ),
        );
        await Future.delayed(const Duration(milliseconds: 500));
        if (context.mounted) {
          _showPasteChapterDialog(context, chapter, l10n);
        }
      }
    } else if (action == 'copy' && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.promptCopied)));
      _showPasteChapterDialog(context, chapter, l10n);
    }
  }

  void _showPasteChapterDialog(
    BuildContext context,
    dynamic chapter,
    AppLocalizations l10n,
  ) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.pasteChapterContent),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.pasteResponseInstructions,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                maxLines: 15,
                decoration: InputDecoration(
                  hintText: l10n.pasteHint,
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
            child: Text(l10n.cancel),
          ),
          FilledButton.icon(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                Navigator.of(context).pop();
                _processChapterContent(context, chapter, text, l10n);
              }
            },
            icon: const Icon(Icons.check),
            label: Text(l10n.import),
          ),
        ],
      ),
    );
  }

  void _processChapterContent(
    BuildContext context,
    dynamic chapter,
    String responseText,
    AppLocalizations l10n,
  ) async {
    final llmService = LLMIntegrationService();
    final validationResult = llmService.parseResponseWithValidation(
      responseText,
    );

    // Check for validation errors that should block import
    if (!validationResult.isValid) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(validationResult.errorMessage ?? l10n.parseError),
            content: SingleChildScrollView(
              child: Text(
                validationResult.errorDetails ?? l10n.parseErrorMessage,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.ok),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showPasteChapterDialog(context, chapter, l10n);
                },
                child: Text(l10n.tryAgain),
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
      await (database.update(
        database.chapters,
      )..where((tbl) => tbl.id.equals(chapter.id))).write(
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
          SnackBar(
            content: Text(l10n.contentImported),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorImportingContent(e.toString())),
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

  // Dialog methods for bookmarks, highlights, and notes

  void _showBookmarksDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BookmarksDialog(
        bookId: widget.bookId,
        onBookmarkTap: (chapterId, position) {
          if (chapterId == widget.chapterId) {
            // Same chapter, scroll to position
            final progressState = ref.read(
              readingProgressProvider(
                ReadingProgressParams(
                  bookId: widget.bookId,
                  chapterId: widget.chapterId,
                ),
              ),
            );
            if (progressState.scrollController.hasClients) {
              final maxScroll =
                  progressState.scrollController.position.maxScrollExtent;
              final targetPosition = (position / 1000.0 * maxScroll).clamp(
                0.0,
                maxScroll,
              );
              progressState.scrollController.animateTo(
                targetPosition,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          } else {
            // Different chapter, navigate
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    ReaderScreen(bookId: widget.bookId, chapterId: chapterId),
              ),
            );
          }
        },
      ),
    );
  }

  void _showNotesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => NotesDialog(
        bookId: widget.bookId,
        onNoteTap: (chapterId, position) {
          if (chapterId == widget.chapterId) {
            // Same chapter, scroll to position
            final progressState = ref.read(
              readingProgressProvider(
                ReadingProgressParams(
                  bookId: widget.bookId,
                  chapterId: widget.chapterId,
                ),
              ),
            );
            if (progressState.scrollController.hasClients) {
              final maxScroll =
                  progressState.scrollController.position.maxScrollExtent;
              final targetPosition = (position / 1000.0 * maxScroll).clamp(
                0.0,
                maxScroll,
              );
              progressState.scrollController.animateTo(
                targetPosition,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          } else {
            // Different chapter, navigate
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    ReaderScreen(bookId: widget.bookId, chapterId: chapterId),
              ),
            );
          }
        },
      ),
    );
  }

  // FAB action methods

  void _addBookmark(BuildContext context) async {
    final progressState = ref.read(
      readingProgressProvider(
        ReadingProgressParams(
          bookId: widget.bookId,
          chapterId: widget.chapterId,
        ),
      ),
    );

    final repository = ref.read(bookRepositoryProvider);

    try {
      await repository.createBookmark(
        bookId: widget.bookId,
        chapterId: widget.chapterId,
        position: progressState.currentPosition,
      );

      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.bookmarkAdded),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorAddingBookmark(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _addNote(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addNote),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter your note...',
            border: OutlineInputBorder(),
          ),
          maxLines: 5,
          textCapitalization: TextCapitalization.sentences,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              final content = controller.text.trim();
              if (content.isEmpty) return;

              final progressState = ref.read(
                readingProgressProvider(
                  ReadingProgressParams(
                    bookId: widget.bookId,
                    chapterId: widget.chapterId,
                  ),
                ),
              );

              final repository = ref.read(bookRepositoryProvider);

              try {
                await repository.createNote(
                  bookId: widget.bookId,
                  chapterId: widget.chapterId,
                  position: progressState.currentPosition,
                  content: content,
                );

                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.noteAdded)));
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.errorAddingNote(e.toString())),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  // TTS methods

  void _startReading(BuildContext context) async {
    // Stop any existing playback first
    await ref.read(ttsProvider.notifier).stop();

    // Set TTS context for this book/chapter
    ref
        .read(ttsContextProvider.notifier)
        .setContext(widget.bookId, widget.chapterId);

    final l10n = AppLocalizations.of(context)!;
    final chapterAsync = ref.read(chapterProvider(widget.chapterId));

    await chapterAsync.when(
      data: (chapter) async {
        if (chapter?.content != null && chapter!.content!.isNotEmpty) {
          // Strip markdown formatting for better TTS
          final plainText = _stripMarkdown(chapter.content!);

          // Get book for metadata
          final bookRepo = ref.read(bookRepositoryProvider);
          final book = await bookRepo.getBookById(widget.bookId);

          try {
            await ref
                .read(ttsProvider.notifier)
                .speak(
                  plainText,
                  bookTitle: book?.title,
                  chapterTitle: chapter.title,
                );
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('TTS Error: ${e.toString()}')),
              );
            }
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.noContentYet)));
          }
        }
      },
      loading: () async {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.loading)));
        }
      },
      error: (error, stack) async {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.errorMessage(error.toString()))),
          );
        }
      },
    );
  }

  String _stripMarkdown(String markdown) {
    // Remove markdown formatting for better TTS reading
    String text = markdown;

    // Remove headers
    text = text.replaceAll(RegExp(r'^#{1,6}\s+', multiLine: true), '');

    // Remove bold and italic
    text = text.replaceAll(RegExp(r'\*\*([^*]+)\*\*'), r'$1');
    text = text.replaceAll(RegExp(r'\*([^*]+)\*'), r'$1');
    text = text.replaceAll(RegExp(r'__([^_]+)__'), r'$1');
    text = text.replaceAll(RegExp(r'_([^_]+)_'), r'$1');

    // Remove links but keep text
    text = text.replaceAll(RegExp(r'\[([^\]]+)\]\([^)]+\)'), r'$1');

    // Remove inline code
    text = text.replaceAll(RegExp(r'`([^`]+)`'), r'$1');

    // Remove code blocks
    text = text.replaceAll(RegExp(r'```[^`]*```'), '');

    // Remove blockquotes
    text = text.replaceAll(RegExp(r'^>\s+', multiLine: true), '');

    // Remove list markers
    text = text.replaceAll(RegExp(r'^[-*+]\s+', multiLine: true), '');
    text = text.replaceAll(RegExp(r'^\d+\.\s+', multiLine: true), '');

    // Remove horizontal rules
    text = text.replaceAll(RegExp(r'^[-*_]{3,}$', multiLine: true), '');

    // Clean up extra whitespace
    text = text.replaceAll(RegExp(r'\n\n+'), '\n\n');
    text = text.trim();

    return text;
  }
}
