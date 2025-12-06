import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:read_forge/core/providers/database_provider.dart';
import 'package:read_forge/core/data/database.dart';

/// Provider for highlights list
final highlightsProvider = FutureProvider.family
    .autoDispose<List<HighlightWithChapter>, int>((ref, bookId) async {
      final repository = ref.watch(bookRepositoryProvider);
      final highlights = await repository.getHighlightsForBook(bookId);

      // Fetch chapter info for each highlight
      final List<HighlightWithChapter> result = [];
      for (final highlight in highlights) {
        final chapter = await repository.getChapterById(highlight.chapterId);
        if (chapter != null) {
          result.add(
            HighlightWithChapter(
              highlight: highlight,
              chapterTitle: chapter.title,
              chapterOrderIndex: chapter.orderIndex,
            ),
          );
        }
      }
      return result;
    });

/// Highlight with chapter info
class HighlightWithChapter {
  final Highlight highlight;
  final String chapterTitle;
  final int chapterOrderIndex;

  HighlightWithChapter({
    required this.highlight,
    required this.chapterTitle,
    required this.chapterOrderIndex,
  });
}

/// Highlight colors
class HighlightColors {
  static const yellow = Color(0xFFFFEB3B);
  static const green = Color(0xFF4CAF50);
  static const blue = Color(0xFF2196F3);
  static const pink = Color(0xFFE91E63);

  static Color fromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'yellow':
        return yellow;
      case 'green':
        return green;
      case 'blue':
        return blue;
      case 'pink':
        return pink;
      default:
        return yellow;
    }
  }

  static String toStringValue(Color color) {
    if (color == yellow) return 'yellow';
    if (color == green) return 'green';
    if (color == blue) return 'blue';
    if (color == pink) return 'pink';
    return 'yellow';
  }

  static List<MapEntry<String, Color>> get all => [
    const MapEntry('yellow', yellow),
    const MapEntry('green', green),
    const MapEntry('blue', blue),
    const MapEntry('pink', pink),
  ];
}

/// Dialog for managing highlights
class HighlightsDialog extends ConsumerWidget {
  final int bookId;
  final Function(int chapterId, int startPosition)? onHighlightTap;

  const HighlightsDialog({
    super.key,
    required this.bookId,
    this.onHighlightTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final highlightsAsync = ref.watch(highlightsProvider(bookId));

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
                  'Highlights',
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
              child: highlightsAsync.when(
                data: (highlights) {
                  if (highlights.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.highlight_outlined,
                            size: 64,
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No highlights yet',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Select text while reading and\ntap "Highlight" to save it',
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
                    itemCount: highlights.length,
                    itemBuilder: (context, index) {
                      final item = highlights[index];
                      return _buildHighlightCard(context, ref, item);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) =>
                    Center(child: Text('Error loading highlights: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightCard(
    BuildContext context,
    WidgetRef ref,
    HighlightWithChapter item,
  ) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final highlightColor = HighlightColors.fromString(item.highlight.color);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          onHighlightTap?.call(
            item.highlight.chapterId,
            item.highlight.startPosition,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with chapter info and actions
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: highlightColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ch ${item.chapterOrderIndex}: ${item.chapterTitle}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'note',
                        child: Row(
                          children: [
                            Icon(Icons.note_add),
                            SizedBox(width: 8),
                            Text('Add Note'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'note') {
                        _showAddNoteDialog(context, ref, item.highlight);
                      } else if (value == 'delete') {
                        _confirmDeleteHighlight(context, ref, item.highlight);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Highlighted text
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: highlightColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  item.highlight.highlightedText,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 8),

              // Note if exists
              if (item.highlight.note != null &&
                  item.highlight.note!.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.note,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.highlight.note!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // Date
              Text(
                dateFormat.format(item.highlight.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddNoteDialog(
    BuildContext context,
    WidgetRef ref,
    Highlight highlight,
  ) {
    final controller = TextEditingController(text: highlight.note ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Note'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter your note...',
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final note = controller.text.trim();
              final repository = ref.read(bookRepositoryProvider);
              await repository.updateHighlightNote(
                highlight.id,
                note.isEmpty ? null : note,
              );
              ref.invalidate(highlightsProvider(bookId));

              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Note saved')));
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteHighlight(
    BuildContext context,
    WidgetRef ref,
    Highlight highlight,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Highlight'),
        content: const Text('Are you sure you want to delete this highlight?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final repository = ref.read(bookRepositoryProvider);
              await repository.deleteHighlight(highlight.id);
              ref.invalidate(highlightsProvider(bookId));

              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Highlight deleted')),
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
