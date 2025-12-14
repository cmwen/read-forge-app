import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:read_forge/core/data/database.dart';
import 'package:read_forge/core/domain/models/book_model.dart';
import 'package:read_forge/core/domain/models/chapter_model.dart';

const _uuid = Uuid();

/// Repository for managing books and chapters
class BookRepository {
  final AppDatabase _db;

  BookRepository(this._db);

  // Books operations

  /// Get all books
  Future<List<BookModel>> getAllBooks() async {
    final books = await _db.select(_db.books).get();
    return books.map((book) => BookModel.fromDb(book)).toList();
  }

  /// Get a book by ID
  Future<BookModel?> getBookById(int id) async {
    final book = await (_db.select(
      _db.books,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    return book != null ? BookModel.fromDb(book) : null;
  }

  /// Create a new book
  Future<BookModel> createBook({
    required String title,
    String? subtitle,
    String? author,
    String? description,
    String? purpose,
    String? genre,
    bool isTitleGenerated = false,
  }) async {
    final bookTitle = title;

    final id = await _db
        .into(_db.books)
        .insert(
          BooksCompanion.insert(
            uuid: _uuid.v4(),
            title: bookTitle,
            subtitle: Value(subtitle),
            author: Value(author),
            description: Value(description),
            purpose: Value(purpose),
            genre: Value(genre),
            status: const Value('draft'),
            isTitleGenerated: Value(isTitleGenerated),
          ),
        );

    final book = await getBookById(id);
    return book!;
  }

  /// Update a book
  Future<void> updateBook(int id, BooksCompanion update) async {
    await (_db.update(_db.books)..where((tbl) => tbl.id.equals(id))).write(
      update.copyWith(updatedAt: Value(DateTime.now())),
    );
  }

  /// Delete a book
  Future<void> deleteBook(int id) async {
    await (_db.delete(_db.books)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Chapters operations

  /// Get chapters for a book
  Future<List<ChapterModel>> getChaptersForBook(int bookId) async {
    final chapters =
        await (_db.select(_db.chapters)
              ..where((tbl) => tbl.bookId.equals(bookId))
              ..orderBy([(tbl) => OrderingTerm(expression: tbl.orderIndex)]))
            .get();
    return chapters.map((chapter) => ChapterModel.fromDb(chapter)).toList();
  }

  /// Get a chapter by ID
  Future<ChapterModel?> getChapterById(int id) async {
    final chapter = await (_db.select(
      _db.chapters,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    return chapter != null ? ChapterModel.fromDb(chapter) : null;
  }

  /// Create a new chapter
  Future<ChapterModel> createChapter({
    required int bookId,
    required String title,
    String? summary,
    String? content,
    required int orderIndex,
  }) async {
    final id = await _db
        .into(_db.chapters)
        .insert(
          ChaptersCompanion.insert(
            uuid: _uuid.v4(),
            bookId: bookId,
            title: title,
            summary: Value(summary),
            content: Value(content),
            orderIndex: orderIndex,
          ),
        );

    final chapter = await getChapterById(id);
    return chapter!;
  }

  /// Update a chapter
  Future<void> updateChapter(int id, ChaptersCompanion update) async {
    await (_db.update(_db.chapters)..where((tbl) => tbl.id.equals(id))).write(
      update.copyWith(updatedAt: Value(DateTime.now())),
    );
  }

  /// Delete a chapter
  Future<void> deleteChapter(int id) async {
    await (_db.delete(_db.chapters)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Get chapter count for a book
  Future<int> getChapterCount(int bookId) async {
    final count =
        await (_db.selectOnly(_db.chapters)
              ..addColumns([_db.chapters.id.count()])
              ..where(_db.chapters.bookId.equals(bookId)))
            .getSingle();
    return count.read(_db.chapters.id.count()) ?? 0;
  }

  // Bookmarks operations

  /// Get all bookmarks for a book
  Future<List<Bookmark>> getBookmarksForBook(int bookId) async {
    return await (_db.select(_db.bookmarks)
          ..where((tbl) => tbl.bookId.equals(bookId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .get();
  }

  /// Create a bookmark
  Future<int> createBookmark({
    required int bookId,
    required int chapterId,
    required int position,
    String? note,
  }) async {
    return await _db
        .into(_db.bookmarks)
        .insert(
          BookmarksCompanion.insert(
            uuid: _uuid.v4(),
            bookId: bookId,
            chapterId: chapterId,
            position: position,
            note: Value(note),
          ),
        );
  }

  /// Delete a bookmark
  Future<void> deleteBookmark(int id) async {
    await (_db.delete(_db.bookmarks)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Notes operations

  /// Get all notes for a book
  Future<List<Note>> getNotesForBook(int bookId) async {
    return await (_db.select(_db.notes)
          ..where((tbl) => tbl.bookId.equals(bookId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .get();
  }

  /// Get notes for a chapter
  Future<List<Note>> getNotesForChapter(int chapterId) async {
    return await (_db.select(
      _db.notes,
    )..where((tbl) => tbl.chapterId.equals(chapterId))).get();
  }

  /// Create a note
  Future<int> createNote({
    required int bookId,
    required int chapterId,
    required int position,
    required String content,
  }) async {
    return await _db
        .into(_db.notes)
        .insert(
          NotesCompanion.insert(
            uuid: _uuid.v4(),
            bookId: bookId,
            chapterId: chapterId,
            position: position,
            content: content,
          ),
        );
  }

  /// Update a note
  Future<void> updateNote(int id, String content) async {
    await (_db.update(_db.notes)..where((tbl) => tbl.id.equals(id))).write(
      NotesCompanion(content: Value(content), updatedAt: Value(DateTime.now())),
    );
  }

  /// Delete a note
  Future<void> deleteNote(int id) async {
    await (_db.delete(_db.notes)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Reading Progress operations

  /// Get reading progress for a book
  Future<ReadingProgressData?> getReadingProgress(int bookId) async {
    return await (_db.select(
      _db.readingProgress,
    )..where((tbl) => tbl.bookId.equals(bookId))).getSingleOrNull();
  }

  /// Update or create reading progress
  Future<void> updateReadingProgress({
    required int bookId,
    required int? lastChapterId,
    required int lastPosition,
    required double percentComplete,
  }) async {
    final existing = await getReadingProgress(bookId);

    if (existing != null) {
      await (_db.update(
        _db.readingProgress,
      )..where((tbl) => tbl.bookId.equals(bookId))).write(
        ReadingProgressCompanion(
          lastChapterId: Value(lastChapterId),
          lastPosition: Value(lastPosition),
          percentComplete: Value(percentComplete),
          lastReadAt: Value(DateTime.now()),
        ),
      );
    } else {
      await _db
          .into(_db.readingProgress)
          .insert(
            ReadingProgressCompanion.insert(
              bookId: bookId,
              lastChapterId: Value(lastChapterId),
              lastPosition: Value(lastPosition),
              percentComplete: Value(percentComplete),
              lastReadAt: Value(DateTime.now()),
            ),
          );
    }
  }

  /// Calculate reading progress percentage
  Future<double> calculateReadingProgress(
    int bookId,
    int currentChapterId,
    int currentPosition,
  ) async {
    final chapters = await getChaptersForBook(bookId);
    if (chapters.isEmpty) return 0.0;

    final currentChapterIndex = chapters.indexWhere(
      (ch) => ch.id == currentChapterId,
    );
    if (currentChapterIndex == -1) return 0.0;

    // Calculate based on chapters completed plus current chapter progress
    final completedChapters = currentChapterIndex;
    final currentChapter = chapters[currentChapterIndex];
    final currentChapterProgress = currentChapter.wordCount > 0
        ? (currentPosition / currentChapter.wordCount).clamp(0.0, 1.0)
        : 0.0;

    final totalProgress =
        (completedChapters + currentChapterProgress) / chapters.length;
    return (totalProgress * 100).clamp(0.0, 100.0);
  }
}
