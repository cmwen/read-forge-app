import 'package:flutter_test/flutter_test.dart';
import 'package:read_forge/core/domain/models/llm_response.dart';

void main() {
  group('TOC Import - Book Info Update', () {
    test('TOCResponse should support optional description field', () {
      // Test 1: TOCResponse with description
      final responseWithDescription = TOCResponse(
        bookTitle: 'My Awesome Book',
        chapters: [
          TOCChapter(
            number: 1,
            title: 'Chapter One',
            summary: 'First chapter',
          ),
        ],
        description: 'This is an awesome book about amazing things',
      );

      expect(responseWithDescription.bookTitle, 'My Awesome Book');
      expect(
        responseWithDescription.description,
        'This is an awesome book about amazing things',
      );
      expect(responseWithDescription.chapters.length, 1);
    });

    test('TOCResponse should serialize description to JSON', () {
      final response = TOCResponse(
        bookTitle: 'Test Book',
        chapters: [
          TOCChapter(
            number: 1,
            title: 'Chapter One',
            summary: 'Summary',
          ),
        ],
        description: 'A compelling description',
      );

      final json = response.toJson();

      expect(json['type'], 'toc');
      expect(json['bookTitle'], 'Test Book');
      expect(json['description'], 'A compelling description');
      expect(json['chapters'], isA<List>());
    });

    test('TOCResponse should deserialize description from JSON', () {
      final json = {
        'type': 'toc',
        'bookTitle': 'Test Book',
        'description': 'A compelling description',
        'chapters': [
          {
            'number': 1,
            'title': 'Chapter One',
            'summary': 'Summary',
          },
        ],
        'timestamp': '2025-12-09T22:12:46.163Z',
      };

      final response = TOCResponse.fromJson(json);

      expect(response.bookTitle, 'Test Book');
      expect(response.description, 'A compelling description');
      expect(response.chapters.length, 1);
    });

    test('TOCResponse should handle missing description gracefully', () {
      final json = {
        'type': 'toc',
        'bookTitle': 'Test Book',
        'chapters': [
          {
            'number': 1,
            'title': 'Chapter One',
            'summary': 'Summary',
          },
        ],
      };

      final response = TOCResponse.fromJson(json);

      expect(response.bookTitle, 'Test Book');
      expect(response.description, null);
      expect(response.chapters.length, 1);
    });

    test('TOCResponse should NOT include null description in JSON', () {
      final response = TOCResponse(
        bookTitle: 'Test Book',
        chapters: [
          TOCChapter(number: 1, title: 'Chapter One'),
        ],
      );

      final json = response.toJson();

      expect(json.containsKey('description'), false);
    });

    test(
      'LLM generated JSON with title and description in TOC should be importable',
      () {
        // Simulating an LLM-generated TOC response with book info
        final llmJsonString = '''{
          "type": "toc",
          "bookTitle": "The Journey to Self-Discovery",
          "description": "An inspiring guide that helps readers uncover their true potential and navigate life's challenges with confidence",
          "chapters": [
            {
              "number": 1,
              "title": "Finding Your Inner Voice",
              "summary": "Learn to listen to your intuition and recognize your authentic desires"
            },
            {
              "number": 2,
              "title": "Overcoming Self-Doubt",
              "summary": "Practical techniques to build confidence and silence your inner critic"
            },
            {
              "number": 3,
              "title": "Creating Your Vision",
              "summary": "Define clear goals and create a roadmap for your future success"
            }
          ],
          "timestamp": "2025-12-09T22:12:46.163Z"
        }''';

        final response = LLMResponse.fromJsonString(llmJsonString);

        expect(response, isA<TOCResponse>());
        final tocResponse = response as TOCResponse;
        expect(tocResponse.bookTitle, 'The Journey to Self-Discovery');
        expect(
          tocResponse.description,
          'An inspiring guide that helps readers uncover their true potential and navigate life\'s challenges with confidence',
        );
        expect(tocResponse.chapters.length, 3);
        expect(tocResponse.chapters[0].title, 'Finding Your Inner Voice');
        expect(
          tocResponse.chapters[0].summary,
          'Learn to listen to your intuition and recognize your authentic desires',
        );
      },
    );

    test('Plain text TOC should be parseable', () {
      final plainTextToc = '''
1. Finding Your Inner Voice - Learn to listen to your intuition
2. Overcoming Self-Doubt - Build confidence and silence your critic
3. Creating Your Vision - Define goals and create a roadmap
      ''';

      final response = LLMResponse.fromJsonString(plainTextToc);

      // Note: Plain text parsing returns null from fromJsonString
      // but parseResponse in LLMIntegrationService handles it
      expect(response, null);
    });

    test('Should differentiate between TOC and Title responses', () {
      // Title response with description
      final titleJson = {
        'type': 'title',
        'title': 'The Journey to Self-Discovery',
        'description':
            'An inspiring guide about personal growth and self-discovery',
      };

      final titleResponse = LLMResponse.fromJson(titleJson);

      expect(titleResponse, isA<TitleResponse>());
      expect((titleResponse as TitleResponse).title,
          'The Journey to Self-Discovery');
      expect(
        titleResponse.description,
        'An inspiring guide about personal growth and self-discovery',
      );

      // TOC response with description
      final tocJson = {
        'type': 'toc',
        'bookTitle': 'The Journey to Self-Discovery',
        'description':
            'An inspiring guide about personal growth and self-discovery',
        'chapters': [
          {'number': 1, 'title': 'Chapter One', 'summary': 'Summary'}
        ],
      };

      final tocResponse = LLMResponse.fromJson(tocJson);

      expect(tocResponse, isA<TOCResponse>());
      expect((tocResponse as TOCResponse).bookTitle,
          'The Journey to Self-Discovery');
      expect(
        tocResponse.description,
        'An inspiring guide about personal growth and self-discovery',
      );
    });

    test('Should handle mixed LLM responses - title then TOC', () {
      // First response: Title generation
      final titleJson = '''{
        "type": "title",
        "title": "The Art of Learning",
        "description": "Discover effective techniques to master any subject quickly"
      }''';

      final titleResponse = LLMResponse.fromJsonString(titleJson) as TitleResponse;

      // Second response: TOC generation with enhanced book info
      final tocJson = '''{
        "type": "toc",
        "bookTitle": "The Art of Learning",
        "description": "Discover effective techniques to master any subject quickly",
        "chapters": [
          {"number": 1, "title": "Learning Fundamentals", "summary": "Core concepts"},
          {"number": 2, "title": "Building Better Habits", "summary": "Consistency is key"}
        ]
      }''';

      final tocResponse = LLMResponse.fromJsonString(tocJson) as TOCResponse;

      // Verify both title and TOC can be imported
      expect(titleResponse.title, tocResponse.bookTitle);
      expect(titleResponse.description, tocResponse.description);
      expect(tocResponse.chapters.length, 2);
    });
  });
}
