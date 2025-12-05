import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_forge/core/domain/models/book_model.dart';
import 'package:read_forge/core/domain/models/chapter_model.dart';
import 'package:read_forge/core/providers/database_provider.dart';

/// Provider for a specific book
final bookDetailProvider = FutureProvider.family<BookModel?, int>((
  ref,
  bookId,
) async {
  final repository = ref.watch(bookRepositoryProvider);
  return repository.getBookById(bookId);
});

/// Provider for chapters of a specific book
final bookChaptersProvider = FutureProvider.family<List<ChapterModel>, int>((
  ref,
  bookId,
) async {
  final repository = ref.watch(bookRepositoryProvider);
  return repository.getChaptersForBook(bookId);
});
