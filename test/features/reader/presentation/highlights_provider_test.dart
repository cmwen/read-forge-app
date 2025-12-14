import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:read_forge/core/data/database.dart';
import 'package:read_forge/core/data/repositories/book_repository.dart';
import 'package:read_forge/core/domain/models/chapter_model.dart';
import 'package:read_forge/core/providers/database_provider.dart';
import 'package:read_forge/features/reader/presentation/highlights_dialog.dart';

class MockBookRepository extends Mock implements BookRepository {}

void main() {
  group('HighlightColors', () {
    test('fromString returns correct colors and defaults to yellow', () {
      expect(HighlightColors.fromString('yellow'), HighlightColors.yellow);
      expect(HighlightColors.fromString('blue'), HighlightColors.blue);
      expect(HighlightColors.fromString('unknown'), HighlightColors.yellow);
    });

    test('toStringValue returns correct string', () {
      expect(HighlightColors.toStringValue(HighlightColors.green), 'green');
      expect(HighlightColors.toStringValue(const Color(0xFFFFFFFF)), 'yellow');
    });
  });

  group('highlightsProvider', () {
    test(
      'returns highlights with chapter info and filters missing chapters',
      () async {
        final repository = MockBookRepository();
        final highlight = Highlight(
          id: 1,
          uuid: 'uuid-1',
          bookId: 10,
          chapterId: 5,
          startPosition: 0,
          endPosition: 10,
          highlightedText: 'Sample text',
          color: 'green',
          note: null,
          createdAt: DateTime(2024, 1, 1),
        );
        final missingChapterHighlight = Highlight(
          id: 2,
          uuid: 'uuid-2',
          bookId: 10,
          chapterId: 6,
          startPosition: 5,
          endPosition: 15,
          highlightedText: 'Other text',
          color: 'yellow',
          note: null,
          createdAt: DateTime(2024, 1, 2),
        );

        when(
          () => repository.getHighlightsForBook(10),
        ).thenAnswer((_) async => [highlight, missingChapterHighlight]);
        when(() => repository.getChapterById(5)).thenAnswer(
          (_) async => ChapterModel(
            id: 5,
            uuid: 'chapter-uuid',
            bookId: 10,
            title: 'Chapter 1',
            summary: null,
            content: null,
            status: 'draft',
            orderIndex: 1,
            wordCount: 100,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
        );
        when(() => repository.getChapterById(6)).thenAnswer((_) async => null);

        final container = ProviderContainer(
          overrides: [bookRepositoryProvider.overrideWithValue(repository)],
        );
        addTearDown(container.dispose);

        final results = await container.read(highlightsProvider(10).future);

        expect(results, hasLength(1));
        expect(results.first.highlight.id, highlight.id);
        expect(results.first.chapterTitle, 'Chapter 1');
        expect(results.first.chapterOrderIndex, 1);
      },
    );
  });
}
