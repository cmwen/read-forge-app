import 'package:read_forge/core/data/database.dart';

/// Domain model for a Book
class BookModel {
  final int id;
  final String uuid;
  final String title;
  final String? subtitle;
  final String? author;
  final String? description;
  final String? coverPath;
  final String? genre;
  final String status;
  final String? parentBookId;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookModel({
    required this.id,
    required this.uuid,
    required this.title,
    this.subtitle,
    this.author,
    this.description,
    this.coverPath,
    this.genre,
    required this.status,
    this.parentBookId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookModel.fromDb(Book book) {
    return BookModel(
      id: book.id,
      uuid: book.uuid,
      title: book.title,
      subtitle: book.subtitle,
      author: book.author,
      description: book.description,
      coverPath: book.coverPath,
      genre: book.genre,
      status: book.status,
      parentBookId: book.parentBookId,
      createdAt: book.createdAt,
      updatedAt: book.updatedAt,
    );
  }

  BookModel copyWith({
    int? id,
    String? uuid,
    String? title,
    String? subtitle,
    String? author,
    String? description,
    String? coverPath,
    String? genre,
    String? status,
    String? parentBookId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookModel(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      author: author ?? this.author,
      description: description ?? this.description,
      coverPath: coverPath ?? this.coverPath,
      genre: genre ?? this.genre,
      status: status ?? this.status,
      parentBookId: parentBookId ?? this.parentBookId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
