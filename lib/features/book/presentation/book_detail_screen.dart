import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_forge/features/book/presentation/book_detail_provider.dart';
import 'package:read_forge/features/reader/presentation/reader_screen.dart';

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
                      onPressed: () => _generateTOCPrompt(context, book),
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

  void _generateTOCPrompt(BuildContext context, dynamic book) {
    final prompt = _buildTOCPrompt(book);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('TOC Generation Prompt'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Copy this prompt and share it with your preferred AI assistant (ChatGPT, Claude, etc.):',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  prompt,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
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
              Clipboard.setData(ClipboardData(text: prompt));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Prompt copied to clipboard')),
              );
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copy'),
          ),
        ],
      ),
    );
  }

  String _buildTOCPrompt(dynamic book) {
    return '''
Please create a detailed Table of Contents for a book titled "${book.title}".

${book.description != null ? 'Book Description: ${book.description}\n' : ''}
Please generate a comprehensive TOC with chapter titles and brief summaries for each chapter.

Format your response as a numbered list:
1. Chapter Title - Brief summary of what this chapter covers
2. Chapter Title - Brief summary of what this chapter covers
... and so on

Make sure each chapter builds logically on the previous ones and creates a cohesive narrative or learning path.
''';
  }

  void _showBookMenu(BuildContext context, WidgetRef ref) {
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
              // TODO: Navigate to edit screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.copy),
            title: const Text('Create Derivative'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Create derivative
            },
          ),
          ListTile(
            leading: const Icon(Icons.file_download),
            title: const Text('Export Book'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Export functionality
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
              // TODO: Delete with confirmation
            },
          ),
        ],
      ),
    );
  }
}
