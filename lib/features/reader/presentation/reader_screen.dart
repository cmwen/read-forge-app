import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_forge/core/providers/database_provider.dart';

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
            onPressed: () => _showReaderSettings(context),
          ),
        ],
      ),
      body: chapterAsync.when(
        data: (chapter) {
          if (chapter == null) {
            return const Center(child: Text('Chapter not found'));
          }

          if (chapter.content == null || chapter.content!.isEmpty) {
            return _buildEmptyContent(context);
          }

          return _buildReader(context, chapter);
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

  Widget _buildEmptyContent(BuildContext context) {
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
              onPressed: () {
                // TODO: Generate chapter prompt
              },
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Generate Content'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReader(BuildContext context, dynamic chapter) {
    // Sample text for demonstration if content is empty
    final content = chapter.content ?? _getSampleText();

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Chapter title
        Text(
          chapter.title,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 24),

        // Chapter content
        SelectableText(
          content,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(height: 1.8, fontSize: 18),
        ),

        const SizedBox(height: 48),

        // Navigation buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () {
                // TODO: Navigate to previous chapter
              },
              icon: const Icon(Icons.chevron_left),
              label: const Text('Previous'),
            ),
            TextButton.icon(
              onPressed: () {
                // TODO: Navigate to next chapter
              },
              icon: const Icon(Icons.chevron_right),
              label: const Text('Next'),
              iconAlignment: IconAlignment.end,
            ),
          ],
        ),
      ],
    );
  }

  void _showReaderSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reader Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.format_size),
              title: const Text('Font Size'),
              subtitle: const Text('Adjust text size'),
              onTap: () {
                // TODO: Font size picker
              },
            ),
            ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Theme'),
              subtitle: const Text('Light, Dark, or Sepia'),
              onTap: () {
                // TODO: Theme picker
              },
            ),
            ListTile(
              leading: const Icon(Icons.font_download),
              title: const Text('Font Family'),
              subtitle: const Text('Change reading font'),
              onTap: () {
                // TODO: Font family picker
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getSampleText() {
    return '''
This is a sample chapter for demonstration purposes. In a real ReadForge book, this content would be generated by an AI assistant based on your prompts.

The reader provides a comfortable reading experience with:
• Adjustable font sizes
• Multiple theme options (Light, Dark, Sepia)
• Text selection for highlights
• Bookmarking capabilities
• Reading progress tracking

You can navigate between chapters using the Previous and Next buttons at the bottom of the screen.

To add real content to this chapter:
1. Go back to the book's Table of Contents
2. Tap "Generate TOC" to create a complete chapter outline
3. Use the AI prompts to generate content for each chapter
4. Paste the generated content back into ReadForge

ReadForge keeps your data completely local on your device, giving you full control and ownership of your AI-generated books.

This sample text demonstrates how longer content will flow naturally in the reader, with proper line spacing and margins for comfortable reading. The text is selectable, so you can highlight passages, add notes, and bookmark important sections as you read.

Enjoy creating and reading your AI-powered books!
''';
  }
}
