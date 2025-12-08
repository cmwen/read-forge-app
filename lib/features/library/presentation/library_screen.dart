import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_forge/core/domain/models/book_model.dart';
import 'package:read_forge/features/library/presentation/library_provider.dart';
import 'package:read_forge/features/book/presentation/book_detail_screen.dart';
import 'package:read_forge/features/settings/presentation/settings_screen.dart';
import 'package:read_forge/core/services/llm_integration_service.dart';

/// Library screen showing all books
class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(libraryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ReadForge'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: booksAsync.when(
        data: (books) {
          if (books.isEmpty) {
            return _buildEmptyState(context);
          }
          return _buildBookGrid(context, ref, books);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading books: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(libraryProvider.notifier).loadBooks(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateBookDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('New Book'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_books_outlined,
            size: 120,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'No books yet',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to create your first book',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookGrid(
    BuildContext context,
    WidgetRef ref,
    List<BookModel> books,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return _BookCard(book: book);
      },
    );
  }

  void _showCreateBookDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final purposeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Create New Book'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Fill in at least one field below. If you don\'t provide a title, AI can generate one for you based on your description or purpose.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Book Title (Optional)',
                    hintText: 'Enter a title or leave empty for AI generation',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                  maxLines: 1,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Describe what the book is about',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: purposeController,
                  decoration: const InputDecoration(
                    labelText: 'Purpose/Learning Goal (Optional)',
                    hintText: 'What do you want to learn from this book?',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 3,
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
              onPressed: () {
                final title = titleController.text.trim();
                final description = descriptionController.text.trim();
                final purpose = purposeController.text.trim();
                
                // At least one field must be filled
                if (title.isNotEmpty || description.isNotEmpty || purpose.isNotEmpty) {
                  Navigator.of(context).pop();
                  _createBook(context, ref, title, description, purpose);
                } else {
                  // Show error
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in at least one field'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createBook(
    BuildContext context,
    WidgetRef ref,
    String? title,
    String? description,
    String? purpose,
  ) async {
    // If no title provided, we'll show a dialog to generate one with AI
    if (title == null || title.isEmpty) {
      final shouldGenerateTitle = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Generate Title with AI?'),
          content: Text(
            'No title was provided. Would you like to use AI to generate a title based on your ${description != null && description.isNotEmpty ? 'description' : 'purpose'}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Skip'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Generate Title'),
            ),
          ],
        ),
      );

      if (shouldGenerateTitle == true && context.mounted) {
        _showTitleGenerationDialog(context, ref, description, purpose);
        return;
      }
    }

    // Create book with provided information
    final book = await ref.read(libraryProvider.notifier).createBook(
      title: title,
      description: description,
      purpose: purpose,
      isTitleGenerated: false,
    );
    
    if (book != null && context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BookDetailScreen(bookId: book.id),
        ),
      );
    }
  }

  void _showTitleGenerationDialog(
    BuildContext context,
    WidgetRef ref,
    String? description,
    String? purpose,
  ) async {
    final llmService = LLMIntegrationService();
    final prompt = llmService.generateBookTitlePrompt(
      description: description,
      purpose: purpose,
    );

    // Show dialog with prompt
    final action = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate Book Title'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Share this prompt with your AI assistant (ChatGPT, Claude, etc.) to generate a title.',
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
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop('cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: prompt));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Prompt copied to clipboard')),
                );
              }
            },
            child: const Text('Copy'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop('paste'),
            child: const Text('Paste Title'),
          ),
        ],
      ),
    );

    if (action == 'paste' && context.mounted) {
      _pasteAndCreateWithGeneratedTitle(context, ref, description, purpose);
    } else if (action == 'cancel' && context.mounted) {
      // Create book with placeholder title
      final book = await ref.read(libraryProvider.notifier).createBook(
        title: 'Untitled Book',
        description: description,
        purpose: purpose,
        isTitleGenerated: false,
      );
      
      if (book != null && context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BookDetailScreen(bookId: book.id),
          ),
        );
      }
    }
  }

  Future<void> _pasteAndCreateWithGeneratedTitle(
    BuildContext context,
    WidgetRef ref,
    String? description,
    String? purpose,
  ) async {
    // Get text from clipboard
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final generatedTitle = clipboardData?.text?.trim();

    if (generatedTitle == null || generatedTitle.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No title found in clipboard. Creating book with placeholder title.'),
          ),
        );
      }
      
      // Create with placeholder
      final book = await ref.read(libraryProvider.notifier).createBook(
        title: 'Untitled Book',
        description: description,
        purpose: purpose,
        isTitleGenerated: false,
      );
      
      if (book != null && context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BookDetailScreen(bookId: book.id),
          ),
        );
      }
      return;
    }

    // Create book with generated title
    final book = await ref.read(libraryProvider.notifier).createBook(
      title: generatedTitle,
      description: description,
      purpose: purpose,
      isTitleGenerated: true,
    );
    
    if (book != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book created with AI-generated title: "$generatedTitle"'),
          duration: const Duration(seconds: 3),
        ),
      );
      
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BookDetailScreen(bookId: book.id),
        ),
      );
    }
  }
}

/// Card widget for displaying a book
class _BookCard extends ConsumerWidget {
  final BookModel book;

  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BookDetailScreen(bookId: book.id),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cover image placeholder
            Expanded(
              flex: 3,
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.book,
                  size: 64,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            // Book info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (book.author != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        book.author!,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          _getStatusIcon(book.status),
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getStatusText(book.status),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'reading':
        return Icons.menu_book;
      case 'completed':
        return Icons.check_circle;
      case 'draft':
      default:
        return Icons.edit_note;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'reading':
        return 'Reading';
      case 'completed':
        return 'Completed';
      case 'draft':
      default:
        return 'Draft';
    }
  }
}
