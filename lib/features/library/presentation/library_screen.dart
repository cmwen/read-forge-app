import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_forge/core/domain/models/book_model.dart';
import 'package:read_forge/core/domain/models/llm_response.dart';
import 'package:read_forge/features/library/presentation/library_provider.dart';
import 'package:read_forge/features/book/presentation/book_detail_screen.dart';
import 'package:read_forge/features/settings/presentation/settings_screen.dart';
import 'package:read_forge/core/services/llm_integration_service.dart';
import 'package:read_forge/l10n/app_localizations.dart';

/// Library screen showing all books
class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(libraryProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.libraryTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: l10n.settings,
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
            return _buildEmptyState(context, l10n);
          }
          return _buildBookGrid(context, ref, books, l10n);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(l10n.errorLoadingBooks(error.toString())),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(libraryProvider.notifier).loadBooks(),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateBookDialog(context, ref, l10n),
        icon: const Icon(Icons.add),
        label: Text(l10n.newBook),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
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
            l10n.noBooksYet,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.tapToCreateFirstBook,
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
    AppLocalizations l10n,
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

  void _showCreateBookDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final purposeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.createNewBook),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.createBookInstructions,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: l10n.bookTitleOptional,
                    hintText: l10n.bookTitleHint,
                    border: const OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                  maxLines: 1,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: l10n.descriptionOptional,
                    hintText: l10n.descriptionHint,
                    border: const OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: purposeController,
                  decoration: InputDecoration(
                    labelText: l10n.purposeOptional,
                    hintText: l10n.purposeHint,
                    border: const OutlineInputBorder(),
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
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                final title = titleController.text.trim();
                final description = descriptionController.text.trim();
                final purpose = purposeController.text.trim();

                // At least one field must be filled
                if (title.isNotEmpty ||
                    description.isNotEmpty ||
                    purpose.isNotEmpty) {
                  Navigator.of(context).pop();
                  _createBook(context, ref, l10n, title, description, purpose);
                } else {
                  // Show error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.fillAtLeastOneField),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text(l10n.create),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createBook(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String? title,
    String? description,
    String? purpose,
  ) async {
    // If no title provided, we'll show a dialog to generate one with AI
    if (title == null || title.isEmpty) {
      final contentType = description != null && description.isNotEmpty
          ? 'description'
          : 'purpose';
      final shouldGenerateTitle = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.generateTitleWithAI),
          content: Text(l10n.noTitleProvidedPrompt(contentType)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.skip),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.generateTitle),
            ),
          ],
        ),
      );

      if (shouldGenerateTitle == true && context.mounted) {
        _showTitleGenerationDialog(context, ref, l10n, description, purpose);
        return;
      }
    }

    // Create book with provided information
    final book = await ref
        .read(libraryProvider.notifier)
        .createBook(
          title: title ?? l10n.untitledBook,
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
    AppLocalizations l10n,
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
        title: Text(l10n.generateBookTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.sharePromptWithAI,
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
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop('cancel'),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: prompt));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.promptCopiedToClipboard)),
                );
              }
            },
            child: Text(l10n.copy),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop('paste'),
            child: Text(l10n.pasteTitle),
          ),
        ],
      ),
    );

    if (action == 'paste' && context.mounted) {
      _pasteAndCreateWithGeneratedTitle(
        context,
        ref,
        l10n,
        description,
        purpose,
      );
    } else if (action == 'cancel' && context.mounted) {
      // Create book with placeholder title
      final book = await ref
          .read(libraryProvider.notifier)
          .createBook(
            title: l10n.untitledBook,
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
    AppLocalizations l10n,
    String? description,
    String? purpose,
  ) async {
    // Get text from clipboard
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final responseText = clipboardData?.text?.trim();

    if (responseText == null || responseText.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.noTitleInClipboard)));
      }

      // Create with placeholder
      final book = await ref
          .read(libraryProvider.notifier)
          .createBook(
            title: l10n.untitledBook,
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

    // Try to parse the response as a structured LLM response
    final llmService = LLMIntegrationService();
    final parseResult = llmService.parseResponseWithValidation(responseText);

    if (!parseResult.isValid) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(parseResult.errorMessage ?? 'Invalid response'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    // Extract title and optional description from response
    String? generatedTitle;
    String? generatedDescription = description; // Keep original description

    if (parseResult.response is TitleResponse) {
      final titleResponse = parseResult.response as TitleResponse;
      generatedTitle = titleResponse.title;
      // Use generated description if provided and no original description exists
      if (description == null || description.isEmpty) {
        generatedDescription = titleResponse.description;
      }
    } else {
      // For backward compatibility: treat plain text as title
      generatedTitle = responseText;
    }

    if (generatedTitle.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.noTitleInClipboard)));
      }
      return;
    }

    // Create book with generated title and optional generated description
    final book = await ref
        .read(libraryProvider.notifier)
        .createBook(
          title: generatedTitle,
          description: generatedDescription,
          purpose: purpose,
          isTitleGenerated: true,
        );

    if (book != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.bookCreatedWithTitle(generatedTitle)),
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
                          _getStatusText(book.status, context),
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

  String _getStatusText(String status, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (status) {
      case 'reading':
        return l10n.reading;
      case 'completed':
        return l10n.completed;
      case 'draft':
      default:
        return l10n.draft;
    }
  }
}
