import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_forge/features/book/presentation/book_detail_provider.dart';
import 'package:read_forge/features/reader/presentation/reader_screen.dart';
import 'package:read_forge/core/services/llm_integration_service.dart';
import 'package:read_forge/core/domain/models/llm_response.dart';
import 'package:read_forge/core/providers/database_provider.dart';
import 'package:read_forge/core/data/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';

/// Book detail screen showing TOC and book metadata
class BookDetailScreen extends ConsumerWidget {
  final int bookId;

  const BookDetailScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookAsync = ref.watch(bookDetailProvider(bookId));
    final chaptersAsync = ref.watch(bookChaptersProvider(bookId));

    return Scaffold(
      appBar: AppBar(
        title: bookAsync.when(
          data: (book) => Text(book?.title ?? 'Book Details'),
          loading: () => const Text('Loading...'),
          error: (error, stackTrace) => const Text('Error'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showBookMenu(context, ref),
          ),
        ],
      ),
      body: bookAsync.when(
        data: (book) {
          if (book == null) {
            return const Center(child: Text('Book not found'));
          }
          return _buildBookDetail(context, ref, book, chaptersAsync);
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

  Widget _buildBookDetail(
    BuildContext context,
    WidgetRef ref,
    dynamic book,
    AsyncValue chaptersAsync,
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
                    'by ${book.author}',
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
                      'Table of Contents',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () => _generateTOCPrompt(context, ref, book),
                      icon: const Icon(Icons.auto_awesome, size: 20),
                      label: const Text('Generate TOC'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                chaptersAsync.when(
                  data: (chapters) {
                    if (chapters.isEmpty) {
                      return _buildEmptyChapters(context);
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
                      Text('Error loading chapters: $error'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChapters(BuildContext context) {
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
              'No chapters yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Generate a Table of Contents using AI to get started',
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
  ) async {
    final llmService = LLMIntegrationService();
    final prompt = llmService.generateTOCPromptWithFormat(
      book.title,
      description: book.description,
    );

    // Show dialog with options to share or copy
    final action = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate Table of Contents'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Share this prompt with your preferred AI assistant (ChatGPT, Claude, etc.) to generate a table of contents.',
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
        subject: 'Generate TOC for ${book.title}',
      );

      if (shared && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Prompt shared! Paste the response when ready.'),
            duration: Duration(seconds: 3),
          ),
        );
        // Show paste dialog after a short delay
        await Future.delayed(const Duration(milliseconds: 500));
        if (context.mounted) {
          _showPasteDialog(context, ref, book);
        }
      }
    } else if (action == 'copy' && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prompt copied to clipboard')),
      );
      // Show paste dialog
      _showPasteDialog(context, ref, book);
    }
  }

  void _showPasteDialog(BuildContext context, WidgetRef ref, dynamic book) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Paste LLM Response'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Paste the response from your AI assistant:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText:
                      'Paste response here...\n\nSupports both JSON and plain text formats',
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
                _processTOCResponse(context, ref, book, text);
              }
            },
            icon: const Icon(Icons.check),
            label: const Text('Import'),
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
  ) async {
    final llmService = LLMIntegrationService();
    final validationResult = llmService.parseResponseWithValidation(responseText);

    if (validationResult.isValid && validationResult.response is TOCResponse) {
      final response = validationResult.response as TOCResponse;
      // Import chapters
      try {
        final database = ref.read(databaseProvider);
        final uuid = const Uuid();

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
              content: Text(
                'Successfully imported ${response.chapters.length} chapters!',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error importing chapters: $e'),
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
            title: Text(validationResult.errorMessage ?? 'Parse Error'),
            content: SingleChildScrollView(
              child: Text(
                validationResult.errorDetails ??
                    'Could not parse the response. Please make sure the response is in the correct format.',
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
                  _showPasteDialog(context, ref, book);
                },
                child: const Text('Try Again'),
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

    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Book Details'),
            onTap: () {
              Navigator.pop(context);
              _showEditBookDialog(context, ref, book);
            },
          ),
          ListTile(
            leading: const Icon(Icons.file_download),
            title: const Text('Export Book'),
            onTap: () {
              Navigator.pop(context);
              _exportBook(context, ref, book);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text(
              'Delete Book',
              style: TextStyle(color: Colors.red),
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
    final titleController = TextEditingController(text: book.title);
    final authorController = TextEditingController(text: book.author ?? '');
    final descriptionController = TextEditingController(
      text: book.description ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Book Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: authorController,
                decoration: const InputDecoration(
                  labelText: 'Author',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
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
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final title = titleController.text.trim();
              if (title.isEmpty) return;

              final database = ref.read(databaseProvider);
              await database
                  .update(database.books)
                  .replace(
                    BooksCompanion(
                      id: drift.Value(book.id),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Book updated successfully')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteBook(BuildContext context, WidgetRef ref, dynamic book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Book'),
        content: Text(
          'Are you sure you want to delete "${book.title}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final repository = ref.read(bookRepositoryProvider);
              await repository.deleteBook(book.id);

              if (context.mounted) {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to library
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Deleted "${book.title}"')),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _exportBook(BuildContext context, WidgetRef ref, dynamic book) async {
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
          title: const Text('Export Book'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Book exported as JSON. Copy the text below:',
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
              child: const Text('Close'),
            ),
            FilledButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: jsonString));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied to clipboard')),
                );
              },
              icon: const Icon(Icons.copy),
              label: const Text('Copy'),
            ),
          ],
        ),
      );
    }
  }
}
