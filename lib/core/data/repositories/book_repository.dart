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
    String? genre,
  }) async {
    final id = await _db
        .into(_db.books)
        .insert(
          BooksCompanion.insert(
            uuid: _uuid.v4(),
            title: title,
            subtitle: Value(subtitle),
            author: Value(author),
            description: Value(description),
            genre: Value(genre),
            status: const Value('draft'),
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
}
