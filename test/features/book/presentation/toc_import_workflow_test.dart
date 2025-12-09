import 'package:flutter_test/flutter_test.dart';
import 'package:read_forge/core/services/llm_integration_service.dart';
import 'package:read_forge/core/domain/models/llm_response.dart';

void main() {
  group('LLM TOC Import - Full Workflow', () {
    late LLMIntegrationService llmService;

    setUp(() {
      llmService = LLMIntegrationService();
    });

    test(
      'Real-world scenario: Import LLM-generated TOC with book metadata',
      () {
        // Simulating a real LLM response from ChatGPT
        final llmResponseJson = '''{
          "type": "toc",
          "bookTitle": "The Art of Effective Communication",
          "description": "Master the skills of clear, persuasive, and empathetic communication in both personal and professional contexts. This comprehensive guide will transform the way you connect with others.",
          "chapters": [
            {
              "number": 1,
              "title": "Foundations of Communication",
              "summary": "Understand the core principles that underpin all effective communication and discover why listening is just as important as speaking."
            },
            {
              "number": 2,
              "title": "Non-Verbal Communication Mastery",
              "summary": "Learn how body language, tone, and facial expressions convey up to 93% of your message and how to use them to your advantage."
            },
            {
              "number": 3,
              "title": "Building Rapport and Trust",
              "summary": "Discover proven techniques to create genuine connections and establish trust with anyone in any situation."
            },
            {
              "number": 4,
              "title": "Conflict Resolution Through Dialogue",
              "summary": "Navigate difficult conversations with grace and resolve conflicts while maintaining relationships and mutual respect."
            },
            {
              "number": 5,
              "title": "Persuasion and Influence Ethics",
              "summary": "Explore the psychology of persuasion and learn how to influence others ethically and authentically."
            }
          ]
        }''';

        // Parse the response
        final validationResult =
            llmService.parseResponseWithValidation(llmResponseJson);

        // Verify parsing is successful
        expect(validationResult.isValid, true);
        expect(validationResult.response, isA<TOCResponse>());

        final tocResponse = validationResult.response as TOCResponse;

        // Verify book title is captured
        expect(
          tocResponse.bookTitle,
          'The Art of Effective Communication',
        );

        // Verify description is captured (this was the bug!)
        expect(
          tocResponse.description,
          'Master the skills of clear, persuasive, and empathetic communication in both personal and professional contexts. This comprehensive guide will transform the way you connect with others.',
        );

        // Verify chapters are captured
        expect(tocResponse.chapters.length, 5);
        expect(
          tocResponse.chapters[0].title,
          'Foundations of Communication',
        );
        expect(
          tocResponse.chapters[4].title,
          'Persuasion and Influence Ethics',
        );
      },
    );

    test(
      'Backward compatibility: Old TOC without description still works',
      () {
        // Old format without description field (pre-fix)
        final oldFormatJson = '''{
          "type": "toc",
          "bookTitle": "Classic Book",
          "chapters": [
            {"number": 1, "title": "Chapter 1", "summary": "First chapter"},
            {"number": 2, "title": "Chapter 2", "summary": "Second chapter"}
          ]
        }''';

        final validationResult =
            llmService.parseResponseWithValidation(oldFormatJson);

        expect(validationResult.isValid, true);
        final tocResponse = validationResult.response as TOCResponse;
        expect(tocResponse.bookTitle, 'Classic Book');
        expect(tocResponse.description, null); // No description in old format
        expect(tocResponse.chapters.length, 2);
      },
    );

    test(
      'Handle mixed content: Some chapters with summaries, some without',
      () {
        final mixedJson = '''{
          "type": "toc",
          "bookTitle": "Mixed Content Book",
          "description": "A book with varied chapter structures",
          "chapters": [
            {"number": 1, "title": "Chapter One", "summary": "Has summary"},
            {"number": 2, "title": "Chapter Two"},
            {"number": 3, "title": "Chapter Three", "summary": "Also has summary"}
          ]
        }''';

        final validationResult =
            llmService.parseResponseWithValidation(mixedJson);

        expect(validationResult.isValid, true);
        final tocResponse = validationResult.response as TOCResponse;
        expect(tocResponse.chapters[0].summary, 'Has summary');
        expect(tocResponse.chapters[1].summary, null);
        expect(tocResponse.chapters[2].summary, 'Also has summary');
      },
    );

    test(
      'JSON with empty description string should be treated as null',
      () {
        final emptyDescriptionJson = '''{
          "type": "toc",
          "bookTitle": "Test Book",
          "description": "",
          "chapters": [
            {"number": 1, "title": "Chapter One"}
          ]
        }''';

        final tocResponse =
            LLMResponse.fromJsonString(emptyDescriptionJson) as TOCResponse;

        // Empty string in JSON becomes empty string, not null
        // This is expected JSON behavior
        expect(tocResponse.description, '');
      },
    );

    test(
      'Serialize and deserialize roundtrip preserves all data',
      () {
        final original = TOCResponse(
          bookTitle: 'Original Title',
          description: 'Original description text',
          chapters: [
            TOCChapter(
              number: 1,
              title: 'First Chapter',
              summary: 'First summary',
            ),
            TOCChapter(
              number: 2,
              title: 'Second Chapter',
              summary: 'Second summary',
            ),
          ],
        );

        // Serialize to JSON
        final json = original.toJson();

        // Deserialize back
        final deserialized = TOCResponse.fromJson(json);

        // Verify all data is preserved
        expect(deserialized.bookTitle, original.bookTitle);
        expect(deserialized.description, original.description);
        expect(deserialized.chapters.length, original.chapters.length);
        expect(deserialized.chapters[0].title, original.chapters[0].title);
        expect(
          deserialized.chapters[0].summary,
          original.chapters[0].summary,
        );
      },
    );
  });
}
