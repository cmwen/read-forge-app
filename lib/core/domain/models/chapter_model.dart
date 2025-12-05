import 'package:read_forge/core/data/database.dart';

/// Domain model for a Chapter
class ChapterModel {
  final int id;
  final String uuid;
  final int bookId;
  final String title;
  final String? summary;
  final String? content;
  final String status;
  final int orderIndex;
  final int wordCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChapterModel({
    required this.id,
    required this.uuid,
    required this.bookId,
    required this.title,
    this.summary,
    this.content,
    required this.status,
    required this.orderIndex,
    required this.wordCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChapterModel.fromDb(Chapter chapter) {
    return ChapterModel(
      id: chapter.id,
      uuid: chapter.uuid,
      bookId: chapter.bookId,
      title: chapter.title,
      summary: chapter.summary,
      content: chapter.content,
      status: chapter.status,
      orderIndex: chapter.orderIndex,
      wordCount: chapter.wordCount,
      createdAt: chapter.createdAt,
      updatedAt: chapter.updatedAt,
    );
  }

  ChapterModel copyWith({
    int? id,
    String? uuid,
    int? bookId,
    String? title,
    String? summary,
    String? content,
    String? status,
    int? orderIndex,
    int? wordCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChapterModel(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      bookId: bookId ?? this.bookId,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      status: status ?? this.status,
      orderIndex: orderIndex ?? this.orderIndex,
      wordCount: wordCount ?? this.wordCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
