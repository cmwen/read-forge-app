import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_forge/core/domain/models/book_model.dart';
import 'package:read_forge/core/providers/database_provider.dart';

/// Notifier for managing the library
class LibraryNotifier extends AsyncNotifier<List<BookModel>> {
  @override
  Future<List<BookModel>> build() async {
    return await _loadBooks();
  }

  Future<List<BookModel>> _loadBooks() async {
    final repository = ref.watch(bookRepositoryProvider);
    return await repository.getAllBooks();
  }

  /// Load all books
  Future<void> loadBooks() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _loadBooks();
    });
  }

  /// Create a new book
  Future<BookModel?> createBook(String title) async {
    try {
      final repository = ref.read(bookRepositoryProvider);
      final book = await repository.createBook(title: title);
      await loadBooks(); // Reload the list
      return book;
    } catch (e) {
      return null;
    }
  }

  /// Delete a book
  Future<void> deleteBook(int id) async {
    try {
      final repository = ref.read(bookRepositoryProvider);
      await repository.deleteBook(id);
      await loadBooks();
    } catch (e) {
      // Handle error
    }
  }
}

/// Provider for the library
final libraryProvider =
    AsyncNotifierProvider<LibraryNotifier, List<BookModel>>(
      LibraryNotifier.new,
    );
