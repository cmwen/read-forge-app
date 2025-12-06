import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_forge/core/data/repositories/book_repository.dart';
import 'package:read_forge/core/domain/models/book_model.dart';
import 'package:read_forge/core/providers/database_provider.dart';

/// State notifier for managing the library
class LibraryNotifier extends StateNotifier<AsyncValue<List<BookModel>>> {
  final BookRepository _repository;

  LibraryNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadBooks();
  }

  /// Load all books
  Future<void> loadBooks() async {
    state = const AsyncValue.loading();
    try {
      final books = await _repository.getAllBooks();
      state = AsyncValue.data(books);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Create a new book
  Future<BookModel?> createBook(String title) async {
    try {
      final book = await _repository.createBook(title: title);
      await loadBooks(); // Reload the list
      return book;
    } catch (e) {
      return null;
    }
  }

  /// Delete a book
  Future<void> deleteBook(int id) async {
    try {
      await _repository.deleteBook(id);
      await loadBooks();
    } catch (e) {
      // Handle error
    }
  }
}

/// Provider for the library
final libraryProvider =
    StateNotifierProvider<LibraryNotifier, AsyncValue<List<BookModel>>>((ref) {
      final repository = ref.watch(bookRepositoryProvider);
      return LibraryNotifier(repository);
    });
