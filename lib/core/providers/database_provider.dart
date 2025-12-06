import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_forge/core/data/database.dart';
import 'package:read_forge/core/data/repositories/book_repository.dart';

/// Provider for the app database
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

/// Provider for the book repository
final bookRepositoryProvider = Provider<BookRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return BookRepository(db);
});
