import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_forge/features/book/presentation/book_detail_provider.dart';
import 'package:read_forge/features/library/presentation/library_provider.dart';
import 'package:read_forge/features/reader/presentation/reader_screen.dart';
import 'package:read_forge/core/services/llm_integration_service.dart';
import 'package:read_forge/core/domain/models/llm_response.dart';
import 'package:read_forge/core/providers/database_provider.dart';
import 'package:read_forge/core/data/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import 'package:read_forge/features/settings/presentation/app_settings_provider.dart';
import 'package:read_forge/l10n/app_localizations.dart';
import 'package:read_forge/features/reader/presentation/tts_mini_player.dart';
import 'package:read_forge/features/ollama/presentation/providers/ollama_providers.dart';
import 'package:read_forge/ollama_toolkit/ollama_toolkit.dart';
import 'package:read_forge/features/ollama/domain/ollama_connection_status.dart';

/// Provider for book reading progress
final bookReadingProgressProvider = FutureProvider.family
    .autoDispose<double, int>((ref, bookId) async {
      final repository = ref.watch(bookRepositoryProvider);
      final progress = await repository.getReadingProgress(bookId);
      return progress?.percentComplete ?? 0.0;
    });

/// Book detail screen showing TOC and book metadata
class BookDetailScreen extends ConsumerWidget {
  final int bookId;

  const BookDetailScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookAsync = ref.watch(bookDetailProvider(bookId));
    final chaptersAsync = ref.watch(bookChaptersProvider(bookId));
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: bookAsync.when(
          data: (book) => Text(book?.title ?? l10n.bookDetails),
          loading: () => Text(l10n.loading),
          error: (error, stackTrace) => Text(l10n.error),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showBookMenu(context, ref),
          ),
        ],
      ),
      body: Stack(
        children: [
          bookAsync.when(
            data: (book) {
              if (book == null) {
                return Center(child: Text(l10n.bookNotFound));
              }
              return _buildBookDetail(context, ref, book, chaptersAsync, l10n);
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
    );
  }

  Widget _buildBookDetail(
    BuildContext context,
    WidgetRef ref,
    dynamic book,
    AsyncValue chaptersAsync,
    AppLocalizations l10n,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Book header
          Container(
            padding: const EdgeInsets.all(24),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Column(
              children: [
                Icon(
                  Icons.book,
                  size: 80,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(height: 16),
                Text(
                  book.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (book.author != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.byAuthor(book.author!),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
                if (book.description != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    book.description!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
                // Reading progress
                const SizedBox(height: 16),
                Consumer(
                  builder: (context, ref, _) {
                    final progressAsync = ref.watch(
                      bookReadingProgressProvider(book.id),
                    );
                    return progressAsync.when(
                      data: (progress) {
                        if (progress > 0) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.auto_stories,
                                    size: 16,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    l10n.percentComplete(
                                      progress.toStringAsFixed(1),
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: progress / 100,
                                  minHeight: 8,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer
                                      .withValues(alpha: 0.3),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (error, stack) => const SizedBox.shrink(),
                    );
                  },
                ),
              ],
            ),
          ),

          // TOC section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.tableOfContents,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () =>
                          _generateTOCPrompt(context, ref, book, l10n),
                      icon: const Icon(Icons.auto_awesome, size: 20),
                      label: Text(l10n.generateTOC),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                chaptersAsync.when(
                  data: (chapters) {
                    if (chapters.isEmpty) {
                      return _buildEmptyChapters(context, l10n);
                    }
                    return _buildChaptersList(context, chapters);
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (error, stack) =>
                      Text(l10n.errorLoadingChapters(error.toString())),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChapters(BuildContext context, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.list_alt,
              size: 64,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noChaptersYet,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.generateTOCPrompt,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChaptersList(BuildContext context, List chapters) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: chapters.length,
      itemBuilder: (context, index) {
        final chapter = chapters[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(chapter.title),
            subtitle: chapter.summary != null ? Text(chapter.summary!) : null,
            trailing: Icon(
              _getChapterStatusIcon(chapter.status),
              color: Theme.of(context).colorScheme.primary,
            ),
            onTap: () {
              // Navigate to reader for this chapter
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ReaderScreen(bookId: bookId, chapterId: chapter.id),
                ),
              );
            },
          ),
        );
      },
    );
  }

  IconData _getChapterStatusIcon(String status) {
    switch (status) {
      case 'generated':
      case 'reviewed':
        return Icons.check_circle;
      case 'draft':
        return Icons.edit;
      case 'empty':
      default:
        return Icons.circle_outlined;
    }
  }

  void _generateTOCPrompt(
    BuildContext context,
    WidgetRef ref,
    dynamic book,
    AppLocalizations l10n,
  ) async {
    // Check if Ollama is configured and ready
    final ollamaConfig = ref.read(ollamaConfigProvider);
    
    // Wait for connection status to complete
    bool isConnected = false;
    if (ollamaConfig.enabled && ollamaConfig.selectedModel != null) {
      try {
        final connectionStatus = await ref.read(ollamaConnectionStatusProvider.future);
        isConnected = connectionStatus.type == ConnectionStatusType.connected;
      } catch (e) {
        isConnected = false;
      }
    }
    
    final isOllamaReady = ollamaConfig.enabled && 
        ollamaConfig.selectedModel != null &&
        isConnected;
    
    if (isOllamaReady) {
      // Use Ollama generation directly
      _generateTOCWithOllama(context, ref, book, l10n);
    } else {
      // Fall back to copy-paste mode
      _generateTOCWithCopyPaste(context, ref, book, l10n);
    }
  }

  void _generateTOCWithOllama(
    BuildContext context,
    WidgetRef ref,
    dynamic book,
    AppLocalizations l10n,
  ) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(l10n.loading),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text('Generating Table of Contents with Ollama...'),
              const SizedBox(height: 8),
              Text(
                'This may take a minute for large models',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );

      final llmService = LLMIntegrationService();
      final settings = ref.read(appSettingsProvider);
      final ollamaConfig = ref.read(ollamaConfigProvider);
      final ollamaClient = ref.read(ollamaClientProvider);

      // Generate prompt
      final prompt = llmService.generateTOCPromptWithFormat(
        book.title,
        description: book.description,
        purpose: book.purpose,
        suggestedChapters: settings.suggestedChapters,
        writingStyle: settings.writingStyle,
        language: settings.language,
        tone: settings.tone,
        vocabularyLevel: settings.vocabularyLevel,
        favoriteAuthor: settings.favoriteAuthor,
      );

      // Generate with Ollama
      if (ollamaClient == null || ollamaConfig.selectedModel == null) {
        if (context.mounted) {
          Navigator.of(context).pop(); // Close loading
          _showOllamaErrorDialog(
            context,
            'Ollama not configured',
            l10n,
          );
        }
        return;
      }

      try {
        final response = await ollamaClient.chat(
          ollamaConfig.selectedModel!,
          [OllamaMessage.user(prompt)],
        );

        if (!context.mounted) return;
        Navigator.of(context).pop(); // Close loading

        // Parse response
        final tocResponse = llmService.parseResponse(response.message.content);

        if (tocResponse is TOCResponse) {
          // Show preview dialog
          _showTOCPreview(context, ref, book, tocResponse, l10n);
        } else {
          _showOllamaErrorDialog(
            context,
            'Failed to parse Ollama response',
            l10n,
          );
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.of(context).pop(); // Close loading
          _showOllamaErrorDialog(
            context,
            'Ollama generation error: ${e.toString()}',
            l10n,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading
        _showOllamaErrorDialog(
          context,
          'Error: ${e.toString()}',
          l10n,
        );
      }
    }
  }

  void _generateTOCWithCopyPaste(
    BuildContext context,
    WidgetRef ref,
    dynamic book,
    AppLocalizations l10n,
  ) async {
    final llmService = LLMIntegrationService();
    final settings = ref.read(appSettingsProvider);
    final prompt = llmService.generateTOCPromptWithFormat(
      book.title,
      description: book.description,
      purpose: book.purpose,
      suggestedChapters: settings.suggestedChapters,
      writingStyle: settings.writingStyle,
      language: settings.language,
      tone: settings.tone,
      vocabularyLevel: settings.vocabularyLevel,
      favoriteAuthor: settings.favoriteAuthor,
    );

    // Show dialog with options to share or copy
    final action = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.generateTableOfContents),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.shareTOCPromptMessage,
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
        subject: 'Generate TOC for ${book.title}',
      );

      if (shared && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.promptSharedMessage),
            duration: const Duration(seconds: 3),
          ),
        );
        // Show paste dialog after a short delay
        await Future.delayed(const Duration(milliseconds: 500));
        if (context.mounted) {
          _showPasteDialog(context, ref, book, l10n);
        }
      }
    } else if (action == 'copy' && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.promptCopied)));
      // Show paste dialog
      _showPasteDialog(context, ref, book, l10n);
    }
  }

  void _showOllamaErrorDialog(
    BuildContext context,
    String error,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _showTOCPreview(
    BuildContext context,
    WidgetRef ref,
    dynamic book,
    TOCResponse tocResponse,
    AppLocalizations l10n,
  ) async {
    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generated Table of Contents'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (tocResponse.description != null) ...[
                Text(
                  'Description:',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  tocResponse.description!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
              ],
              Text(
                'Chapters:',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 8),
              ...tocResponse.chapters.map((chapter) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '${chapter.number}. ${chapter.title}\n${chapter.summary}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (shouldSave == true && context.mounted) {
      _saveTOCToDatabase(context, ref, book, tocResponse);
    }
  }

  void _saveTOCToDatabase(
    BuildContext context,
    WidgetRef ref,
    dynamic book,
    TOCResponse tocResponse,
  ) async {
    try {
      final database = ref.read(databaseProvider);
      final uuid = const Uuid();
      final l10n = AppLocalizations.of(context)!;

      // Update book title if provided and different from "Untitled"
      if (tocResponse.bookTitle.isNotEmpty &&
          tocResponse.bookTitle != 'Untitled' &&
          (book.title == l10n.untitledBook || book.title.isEmpty)) {
        await (database.update(
          database.books,
        )..where((tbl) => tbl.id.equals(book.id))).write(
          BooksCompanion(
            title: drift.Value(tocResponse.bookTitle),
            description: tocResponse.description != null
                ? drift.Value(tocResponse.description)
                : drift.Value(book.description),
            updatedAt: drift.Value(DateTime.now()),
          ),
        );

        // Invalidate book provider to refresh
        ref.invalidate(bookDetailProvider(book.id));

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.bookTitleUpdated(tocResponse.bookTitle)),
              backgroundColor: Colors.blue,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else if (tocResponse.description != null &&
          (book.description == null || book.description!.isEmpty)) {
        // Update only description if no title update was needed
        await (database.update(
          database.books,
        )..where((tbl) => tbl.id.equals(book.id))).write(
          BooksCompanion(
            description: drift.Value(tocResponse.description),
            updatedAt: drift.Value(DateTime.now()),
          ),
        );

        // Invalidate book provider to refresh
        ref.invalidate(bookDetailProvider(book.id));
      }

      for (final tocChapter in tocResponse.chapters) {
        await database
            .into(database.chapters)
            .insert(
              ChaptersCompanion.insert(
                uuid: uuid.v4(),
                bookId: book.id,
                title: tocChapter.title,
                summary: drift.Value(tocChapter.summary),
                orderIndex: tocChapter.number,
                status: drift.Value('empty'),
              ),
            );
      }

      // Invalidate the chapters provider to refresh the UI
      ref.invalidate(bookChaptersProvider(book.id));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.chaptersImported(tocResponse.chapters.length)),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorImportingChapters(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showPasteDialog(
    BuildContext context,
    WidgetRef ref,
    dynamic book,
    AppLocalizations l10n,
  ) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.pasteLLMResponse),
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
                maxLines: 10,
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
                _processTOCResponse(context, ref, book, text, l10n);
              }
            },
            icon: const Icon(Icons.check),
            label: Text(l10n.import),
          ),
        ],
      ),
    );
  }

  void _processTOCResponse(
    BuildContext context,
    WidgetRef ref,
    dynamic book,
    String responseText,
    AppLocalizations l10n,
  ) async {
    final llmService = LLMIntegrationService();
    final validationResult = llmService.parseResponseWithValidation(
      responseText,
    );

    if (validationResult.isValid && validationResult.response is TOCResponse) {
      final response = validationResult.response as TOCResponse;
      // Import chapters
      try {
        final database = ref.read(databaseProvider);
        final uuid = const Uuid();

        // Update book title if provided and different from "Untitled"
        if (response.bookTitle.isNotEmpty &&
            response.bookTitle != 'Untitled' &&
            (book.title == l10n.untitledBook || book.title.isEmpty)) {
          await (database.update(
            database.books,
          )..where((tbl) => tbl.id.equals(book.id))).write(
            BooksCompanion(
              title: drift.Value(response.bookTitle),
              description: response.description != null
                  ? drift.Value(response.description)
                  : drift.Value(book.description),
              updatedAt: drift.Value(DateTime.now()),
            ),
          );

          // Invalidate book provider to refresh
          ref.invalidate(bookDetailProvider(book.id));

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.bookTitleUpdated(response.bookTitle)),
                backgroundColor: Colors.blue,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } else if (response.description != null &&
            (book.description == null || book.description!.isEmpty)) {
          // Update only description if no title update was needed
          await (database.update(
            database.books,
          )..where((tbl) => tbl.id.equals(book.id))).write(
            BooksCompanion(
              description: drift.Value(response.description),
              updatedAt: drift.Value(DateTime.now()),
            ),
          );

          // Invalidate book provider to refresh
          ref.invalidate(bookDetailProvider(book.id));
        }

        for (final tocChapter in response.chapters) {
          await database
              .into(database.chapters)
              .insert(
                ChaptersCompanion.insert(
                  uuid: uuid.v4(),
                  bookId: book.id,
                  title: tocChapter.title,
                  summary: drift.Value(tocChapter.summary),
                  orderIndex: tocChapter.number,
                  status: drift.Value('empty'),
                ),
              );
        }

        // Invalidate the chapters provider to refresh the UI
        ref.invalidate(bookChaptersProvider(book.id));

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.chaptersImported(response.chapters.length)),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.errorImportingChapters(e.toString())),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      // Failed to parse - show detailed error message
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
                  _showPasteDialog(context, ref, book, l10n);
                },
                child: Text(l10n.tryAgain),
              ),
            ],
          ),
        );
      }
    }
  }

  void _showBookMenu(BuildContext context, WidgetRef ref) async {
    final bookAsync = ref.read(bookDetailProvider(bookId));
    final book = bookAsync.value;
    if (book == null) return;

    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text(l10n.editBookDetails),
            onTap: () {
              Navigator.pop(context);
              _showEditBookDialog(context, ref, book);
            },
          ),
          ListTile(
            leading: const Icon(Icons.file_download),
            title: Text(l10n.exportBook),
            onTap: () {
              Navigator.pop(context);
              _exportBook(context, ref, book);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: Text(
              l10n.deleteBook,
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
              _confirmDeleteBook(context, ref, book);
            },
          ),
        ],
      ),
    );
  }

  void _showEditBookDialog(BuildContext context, WidgetRef ref, dynamic book) {
    final l10n = AppLocalizations.of(context)!;
    final titleController = TextEditingController(text: book.title);
    final authorController = TextEditingController(text: book.author ?? '');
    final descriptionController = TextEditingController(
      text: book.description ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editBookDetails),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: l10n.title,
                  border: const OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: authorController,
                decoration: InputDecoration(
                  labelText: l10n.author,
                  border: const OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: l10n.description,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              final title = titleController.text.trim();
              if (title.isEmpty) return;

              final database = ref.read(databaseProvider);
              await (database.update(
                database.books,
              )..where((tbl) => tbl.id.equals(book.id))).write(
                BooksCompanion(
                  title: drift.Value(title),
                  author: drift.Value(
                    authorController.text.trim().isEmpty
                        ? null
                        : authorController.text.trim(),
                  ),
                  description: drift.Value(
                    descriptionController.text.trim().isEmpty
                        ? null
                        : descriptionController.text.trim(),
                  ),
                  updatedAt: drift.Value(DateTime.now()),
                ),
              );

              // Invalidate the book provider to refresh
              ref.invalidate(bookDetailProvider(book.id));

              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.bookUpdated)));
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteBook(BuildContext context, WidgetRef ref, dynamic book) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteBook),
        content: Text(l10n.confirmDeleteBook(book.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              final libraryNotifier = ref.read(libraryProvider.notifier);
              await libraryNotifier.deleteBook(book.id);

              if (context.mounted) {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to library
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.bookDeleted(book.title))),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _exportBook(BuildContext context, WidgetRef ref, dynamic book) async {
    final l10n = AppLocalizations.of(context)!;
    final database = ref.read(databaseProvider);

    // Get all chapters for this book
    final chapters =
        await (database.select(database.chapters)
              ..where((tbl) => tbl.bookId.equals(book.id))
              ..orderBy([
                (tbl) => drift.OrderingTerm(expression: tbl.orderIndex),
              ]))
            .get();

    // Create JSON export
    final export = {
      'book': {
        'title': book.title,
        'author': book.author,
        'description': book.description,
        'genre': book.genre,
        'createdAt': book.createdAt.toIso8601String(),
      },
      'chapters': chapters
          .map(
            (ch) => {
              'title': ch.title,
              'summary': ch.summary,
              'content': ch.content,
              'orderIndex': ch.orderIndex,
            },
          )
          .toList(),
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(export);

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.exportBook),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.bookExported,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      jsonString,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.close),
            ),
            FilledButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: jsonString));
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.copiedToClipboard)));
              },
              icon: const Icon(Icons.copy),
              label: Text(l10n.copy),
            ),
          ],
        ),
      );
    }
  }
}
