import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:read_forge/core/providers/database_provider.dart';
import 'package:read_forge/core/data/database.dart';

/// Provider for bookmarks list
final bookmarksProvider = FutureProvider.family
    .autoDispose<List<BookmarkWithChapter>, int>((ref, bookId) async {
      final repository = ref.watch(bookRepositoryProvider);
      final bookmarks = await repository.getBookmarksForBook(bookId);

      // Fetch chapter info for each bookmark
      final List<BookmarkWithChapter> result = [];
      for (final bookmark in bookmarks) {
        final chapter = await repository.getChapterById(bookmark.chapterId);
        if (chapter != null) {
          result.add(
            BookmarkWithChapter(
              bookmark: bookmark,
              chapterTitle: chapter.title,
              chapterOrderIndex: chapter.orderIndex,
            ),
          );
        }
      }
      return result;
    });

/// Bookmark with chapter info
class BookmarkWithChapter {
  final Bookmark bookmark;
  final String chapterTitle;
  final int chapterOrderIndex;

  BookmarkWithChapter({
    required this.bookmark,
    required this.chapterTitle,
    required this.chapterOrderIndex,
  });
}

/// Dialog for managing bookmarks
class BookmarksDialog extends ConsumerWidget {
  final int bookId;
  final Function(int chapterId, int position)? onBookmarkTap;

  const BookmarksDialog({super.key, required this.bookId, this.onBookmarkTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarksProvider(bookId));

    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bookmarks',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            Expanded(
              child: bookmarksAsync.when(
                data: (bookmarks) {
                  if (bookmarks.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark_border,
                            size: 64,
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No bookmarks yet',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the bookmark button while reading\nto save your place',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: bookmarks.length,
                    itemBuilder: (context, index) {
                      final item = bookmarks[index];
                      return _buildBookmarkCard(context, ref, item);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) =>
                    Center(child: Text('Error loading bookmarks: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookmarkCard(
    BuildContext context,
    WidgetRef ref,
    BookmarkWithChapter item,
  ) {
    final dateFormat = DateFormat('MMM d, yyyy h:mm a');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.bookmark,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          'Chapter ${item.chapterOrderIndex}: ${item.chapterTitle}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Position: ${item.bookmark.position}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              dateFormat.format(item.bookmark.createdAt),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            if (item.bookmark.note != null && item.bookmark.note!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  item.bookmark.note!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                ),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => _confirmDeleteBookmark(context, ref, item.bookmark),
        ),
        onTap: () {
          Navigator.of(context).pop();
          onBookmarkTap?.call(item.bookmark.chapterId, item.bookmark.position);
        },
      ),
    );
  }

  void _confirmDeleteBookmark(
    BuildContext context,
    WidgetRef ref,
    Bookmark bookmark,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Bookmark'),
        content: const Text('Are you sure you want to delete this bookmark?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final repository = ref.read(bookRepositoryProvider);
              await repository.deleteBookmark(bookmark.id);
              ref.invalidate(bookmarksProvider(bookId));

              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bookmark deleted')),
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
}
