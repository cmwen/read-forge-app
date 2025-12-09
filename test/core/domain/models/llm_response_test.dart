import 'package:flutter_test/flutter_test.dart';
import 'package:read_forge/core/domain/models/llm_response.dart';

void main() {
  group('LLMResponse', () {
    group('TitleResponse', () {
      test('should serialize to JSON correctly', () {
        final response = TitleResponse(
          title: 'The Art of Learning',
          description: 'A guide to mastering learning techniques',
        );

        final json = response.toJson();

        expect(json['type'], 'title');
        expect(json['title'], 'The Art of Learning');
        expect(json['description'], 'A guide to mastering learning techniques');
      });

      test('should deserialize from JSON correctly', () {
        final json = {
          'type': 'title',
          'title': 'The Art of Learning',
          'description': 'A guide to mastering learning techniques',
          'timestamp': '2025-12-06T00:00:00.000Z',
        };

        final response = TitleResponse.fromJson(json);

        expect(response.title, 'The Art of Learning');
        expect(response.description, 'A guide to mastering learning techniques');
      });

      test('should handle missing description field', () {
        final json = {
          'type': 'title',
          'title': 'The Art of Learning',
        };

        final response = TitleResponse.fromJson(json);

        expect(response.title, 'The Art of Learning');
        expect(response.description, null);
      });
    });

    group('TOCResponse', () {
      test('should serialize to JSON correctly', () {
        final response = TOCResponse(
          bookTitle: 'Test Book',
          chapters: [
            TOCChapter(
              number: 1,
              title: 'Chapter One',
              summary: 'First chapter summary',
            ),
            TOCChapter(
              number: 2,
              title: 'Chapter Two',
              summary: 'Second chapter summary',
            ),
          ],
        );

        final json = response.toJson();

        expect(json['type'], 'toc');
        expect(json['bookTitle'], 'Test Book');
        expect(json['chapters'], isA<List>());
        expect(json['chapters'].length, 2);
        expect(json['chapters'][0]['number'], 1);
        expect(json['chapters'][0]['title'], 'Chapter One');
        expect(json['chapters'][0]['summary'], 'First chapter summary');
      });

      test('should deserialize from JSON correctly', () {
        final json = {
          'type': 'toc',
          'bookTitle': 'Test Book',
          'chapters': [
            {
              'number': 1,
              'title': 'Chapter One',
              'summary': 'First chapter summary',
            },
            {
              'number': 2,
              'title': 'Chapter Two',
              'summary': 'Second chapter summary',
            },
          ],
          'timestamp': '2025-12-06T00:00:00.000Z',
        };

        final response = TOCResponse.fromJson(json);

        expect(response.bookTitle, 'Test Book');
        expect(response.chapters.length, 2);
        expect(response.chapters[0].number, 1);
        expect(response.chapters[0].title, 'Chapter One');
        expect(response.chapters[0].summary, 'First chapter summary');
        expect(response.chapters[1].number, 2);
        expect(response.chapters[1].title, 'Chapter Two');
      });

      test('should handle missing optional fields', () {
        final json = {
          'type': 'toc',
          'bookTitle': 'Test Book',
          'chapters': [
            {
              'number': 1,
              'title': 'Chapter One',
              // No summary
            },
          ],
        };

        final response = TOCResponse.fromJson(json);

        expect(response.bookTitle, 'Test Book');
        expect(response.chapters.length, 1);
        expect(response.chapters[0].summary, null);
      });
    });

    group('ChapterResponse', () {
      test('should serialize to JSON correctly', () {
        final response = ChapterResponse(
          bookTitle: 'Test Book',
          chapterNumber: 1,
          chapterTitle: 'Chapter One',
          content: 'This is the chapter content.',
        );

        final json = response.toJson();

        expect(json['type'], 'chapter');
        expect(json['bookTitle'], 'Test Book');
        expect(json['chapterNumber'], 1);
        expect(json['chapterTitle'], 'Chapter One');
        expect(json['content'], 'This is the chapter content.');
      });

      test('should deserialize from JSON correctly', () {
        final json = {
          'type': 'chapter',
          'bookTitle': 'Test Book',
          'chapterNumber': 1,
          'chapterTitle': 'Chapter One',
          'content': 'This is the chapter content.',
          'timestamp': '2025-12-06T00:00:00.000Z',
        };

        final response = ChapterResponse.fromJson(json);

        expect(response.bookTitle, 'Test Book');
        expect(response.chapterNumber, 1);
        expect(response.chapterTitle, 'Chapter One');
        expect(response.content, 'This is the chapter content.');
      });
    });

    group('ContextResponse', () {
      test('should serialize to JSON correctly', () {
        final response = ContextResponse(
          bookTitle: 'Test Book',
          setting: 'Medieval fantasy world',
          characters: [
            Character(
              name: 'Hero',
              description: 'The protagonist',
              role: 'main',
            ),
          ],
          themes: ['courage', 'friendship'],
        );

        final json = response.toJson();

        expect(json['type'], 'context');
        expect(json['bookTitle'], 'Test Book');
        expect(json['setting'], 'Medieval fantasy world');
        expect(json['characters'], isA<List>());
        expect(json['characters'].length, 1);
        expect(json['themes'], ['courage', 'friendship']);
      });

      test('should deserialize from JSON correctly', () {
        final json = {
          'type': 'context',
          'bookTitle': 'Test Book',
          'setting': 'Medieval fantasy world',
          'characters': [
            {'name': 'Hero', 'description': 'The protagonist', 'role': 'main'},
          ],
          'themes': ['courage', 'friendship'],
          'timestamp': '2025-12-06T00:00:00.000Z',
        };

        final response = ContextResponse.fromJson(json);

        expect(response.bookTitle, 'Test Book');
        expect(response.setting, 'Medieval fantasy world');
        expect(response.characters.length, 1);
        expect(response.characters[0].name, 'Hero');
        expect(response.themes, ['courage', 'friendship']);
      });
    });

    group('LLMResponse.fromJson', () {
      test('should correctly identify title response', () {
        final json = {
          'type': 'title',
          'title': 'Test Title',
        };

        final response = LLMResponse.fromJson(json);

        expect(response, isA<TitleResponse>());
      });

      test('should correctly identify TOC response', () {
        final json = {'type': 'toc', 'bookTitle': 'Test Book', 'chapters': []};

        final response = LLMResponse.fromJson(json);

        expect(response, isA<TOCResponse>());
      });

      test('should correctly identify chapter response', () {
        final json = {
          'type': 'chapter',
          'bookTitle': 'Test Book',
          'chapterNumber': 1,
          'chapterTitle': 'Chapter One',
          'content': 'Content',
        };

        final response = LLMResponse.fromJson(json);

        expect(response, isA<ChapterResponse>());
      });

      test('should correctly identify context response', () {
        final json = {
          'type': 'context',
          'bookTitle': 'Test Book',
          'characters': [],
          'themes': [],
        };

        final response = LLMResponse.fromJson(json);

        expect(response, isA<ContextResponse>());
      });

      test('should return null for unknown type', () {
        final json = {'type': 'unknown', 'bookTitle': 'Test Book'};

        final response = LLMResponse.fromJson(json);

        expect(response, null);
      });

      test('should return null for missing type', () {
        final json = {'bookTitle': 'Test Book'};

        final response = LLMResponse.fromJson(json);

        expect(response, null);
      });
    });

    group('LLMResponse.fromJsonString', () {
      test('should parse valid JSON string', () {
        final jsonString = '''
        {
          "type": "toc",
          "bookTitle": "Test Book",
          "chapters": [
            {
              "number": 1,
              "title": "Chapter One",
              "summary": "Summary"
            }
          ]
        }
        ''';

        final response = LLMResponse.fromJsonString(jsonString);

        expect(response, isA<TOCResponse>());
        expect((response as TOCResponse).bookTitle, 'Test Book');
        expect(response.chapters.length, 1);
      });

      test('should return null for invalid JSON', () {
        final jsonString = 'not valid json';

        final response = LLMResponse.fromJsonString(jsonString);

        expect(response, null);
      });
    });
  });
}
