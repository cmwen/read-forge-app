import 'dart:convert';

/// Base class for all LLM responses
/// Contains a 'type' field to distinguish between different response types
abstract class LLMResponse {
  final String type;
  final DateTime timestamp;

  LLMResponse({required this.type, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson();

  static LLMResponse? fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    if (type == null) return null;

    switch (type) {
      case 'title':
        return TitleResponse.fromJson(json);
      case 'toc':
        return TOCResponse.fromJson(json);
      case 'chapter':
        return ChapterResponse.fromJson(json);
      case 'context':
        return ContextResponse.fromJson(json);
      default:
        return null;
    }
  }

  static LLMResponse? fromJsonString(String jsonString) {
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return fromJson(json);
    } catch (e) {
      return null;
    }
  }
}

/// Response containing a Table of Contents
class TOCResponse extends LLMResponse {
  final String bookTitle;
  final List<TOCChapter> chapters;

  TOCResponse({
    required this.bookTitle,
    required this.chapters,
    super.timestamp,
  }) : super(type: 'toc');

  factory TOCResponse.fromJson(Map<String, dynamic> json) {
    return TOCResponse(
      bookTitle: json['bookTitle'] as String? ?? '',
      chapters:
          (json['chapters'] as List?)
              ?.map((e) => TOCChapter.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'bookTitle': bookTitle,
      'chapters': chapters.map((c) => c.toJson()).toList(),
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// Individual chapter in TOC
class TOCChapter {
  final int number;
  final String title;
  final String? summary;

  TOCChapter({required this.number, required this.title, this.summary});

  factory TOCChapter.fromJson(Map<String, dynamic> json) {
    return TOCChapter(
      number: json['number'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'title': title,
      if (summary != null) 'summary': summary,
    };
  }
}

/// Response containing chapter content
class ChapterResponse extends LLMResponse {
  final String bookTitle;
  final int chapterNumber;
  final String chapterTitle;
  final String content;

  ChapterResponse({
    required this.bookTitle,
    required this.chapterNumber,
    required this.chapterTitle,
    required this.content,
    super.timestamp,
  }) : super(type: 'chapter');

  factory ChapterResponse.fromJson(Map<String, dynamic> json) {
    return ChapterResponse(
      bookTitle: json['bookTitle'] as String? ?? '',
      chapterNumber: json['chapterNumber'] as int? ?? 0,
      chapterTitle: json['chapterTitle'] as String? ?? '',
      content: json['content'] as String? ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'bookTitle': bookTitle,
      'chapterNumber': chapterNumber,
      'chapterTitle': chapterTitle,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// Response containing generated book title and description
class TitleResponse extends LLMResponse {
  final String title;
  final String? description;

  TitleResponse({required this.title, this.description, super.timestamp})
    : super(type: 'title');

  factory TitleResponse.fromJson(Map<String, dynamic> json) {
    return TitleResponse(
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      if (description != null) 'description': description,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// Response containing book context (characters, settings, themes)
class ContextResponse extends LLMResponse {
  final String bookTitle;
  final String? setting;
  final List<Character> characters;
  final List<String> themes;

  ContextResponse({
    required this.bookTitle,
    this.setting,
    required this.characters,
    required this.themes,
    super.timestamp,
  }) : super(type: 'context');

  factory ContextResponse.fromJson(Map<String, dynamic> json) {
    return ContextResponse(
      bookTitle: json['bookTitle'] as String? ?? '',
      setting: json['setting'] as String?,
      characters:
          (json['characters'] as List?)
              ?.map((e) => Character.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      themes: (json['themes'] as List?)?.cast<String>() ?? [],
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'bookTitle': bookTitle,
      if (setting != null) 'setting': setting,
      'characters': characters.map((c) => c.toJson()).toList(),
      'themes': themes,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// Character in a book
class Character {
  final String name;
  final String? description;
  final String? role;

  Character({required this.name, this.description, this.role});

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description != null) 'description': description,
      if (role != null) 'role': role,
    };
  }
}
