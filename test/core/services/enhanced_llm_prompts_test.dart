import 'package:flutter_test/flutter_test.dart';
import 'package:read_forge/core/services/llm_integration_service.dart';
import 'package:read_forge/core/domain/models/llm_response.dart';

void main() {
  group('Enhanced LLM Prompt Generation', () {
    late LLMIntegrationService llmService;

    setUp(() {
      llmService = LLMIntegrationService();
    });

    group('TOC Prompt - Description Generation', () {
      test('Should request LLM to generate description when not provided', () {
        final prompt = llmService.generateTOCPromptWithFormat('My Book');

        expect(
          prompt,
          contains('IF NOT PROVIDED, GENERATE A COMPELLING DESCRIPTION'),
        );
        expect(prompt, contains('compelling and engaging book description'));
      });

      test(
        'Should NOT request description generation when description is provided',
        () {
          final prompt = llmService.generateTOCPromptWithFormat(
            'My Book',
            description: 'This is a test description',
          );

          expect(
            prompt,
            isNot(
              contains('IF NOT PROVIDED, GENERATE A COMPELLING DESCRIPTION'),
            ),
          );
        },
      );

      test(
        'Example JSON should include description field when no description provided',
        () {
          final prompt = llmService.generateTOCPromptWithFormat('Test Book');

          expect(prompt, contains('"description":'));
          expect(
            prompt,
            contains(
              'A compelling description of the book that captures its essence',
            ),
          );
        },
      );

      test('Example JSON should include description field in example', () {
        final prompt = llmService.generateTOCPromptWithFormat('Test Book');

        // Should have description in the JSON example
        expect(prompt, contains('"description"'));
      });

      test(
        'Real-world scenario: Importing LLM-generated TOC with description',
        () {
          final llmResponse = '''{
            "type": "toc",
            "bookTitle": "The Journey of Self-Discovery",
            "description": "An inspiring guide that takes readers through personal transformation, helping them discover their true potential and build meaningful relationships.",
            "chapters": [
              {"number": 1, "title": "Understanding Yourself", "summary": "Explore who you are and what drives you"},
              {"number": 2, "title": "Breaking Barriers", "summary": "Overcome limiting beliefs and mental blocks"}
            ]
          }''';

          final response = LLMResponse.fromJsonString(llmResponse);

          expect(response, isA<TOCResponse>());
          final tocResponse = response as TOCResponse;
          expect(tocResponse.bookTitle, 'The Journey of Self-Discovery');
          expect(
            tocResponse.description,
            'An inspiring guide that takes readers through personal transformation, helping them discover their true potential and build meaningful relationships.',
          );
          expect(tocResponse.chapters.length, 2);
        },
      );

      test('Should handle TOC response with generated description', () {
        final response = TOCResponse(
          bookTitle: 'Advanced Programming',
          description: 'A comprehensive guide to advanced programming concepts',
          chapters: [
            TOCChapter(
              number: 1,
              title: 'Design Patterns',
              summary: 'Learn common design patterns',
            ),
          ],
        );

        final json = response.toJson();

        expect(json['description'], isNotNull);
        expect(
          json['description'],
          'A comprehensive guide to advanced programming concepts',
        );
      });
    });

    group('Chapter Prompt - Enhanced Context', () {
      test('Should include purpose in chapter prompt when provided', () {
        final prompt = llmService.generateChapterPromptWithFormat(
          'My Book',
          1,
          'Chapter One',
          bookPurpose: 'To help readers become better developers',
        );

        expect(
          prompt,
          contains(
            '- Book Purpose/Goal: To help readers become better developers',
          ),
        );
        expect(
          prompt,
          contains('Ensure the content supports the book\'s purpose'),
        );
      });

      test('Should NOT include purpose when not provided', () {
        final prompt = llmService.generateChapterPromptWithFormat(
          'My Book',
          1,
          'Chapter One',
        );

        expect(prompt, isNot(contains('- Book Purpose/Goal:')));
      });

      test('Should include full TOC with chapter numbers when provided', () {
        final chapterTitles = [
          'Chapter 1: Introduction',
          'Chapter 2: Basics',
          'Chapter 3: Advanced Topics',
          'Chapter 4: Conclusion',
        ];

        final prompt = llmService.generateChapterPromptWithFormat(
          'My Book',
          2,
          'Basics',
          chapterTitles: chapterTitles,
        );

        expect(prompt, contains('## Table of Contents'));
        expect(prompt, contains('1. Chapter 1: Introduction'));
        expect(prompt, contains('2. Chapter 2: Basics (Current Chapter)'));
        expect(prompt, contains('3. Chapter 3: Advanced Topics'));
        expect(prompt, contains('4. Chapter 4: Conclusion'));
      });

      test('Should indicate which chapter is current in TOC', () {
        final chapterTitles = ['Chapter 1', 'Chapter 2', 'Chapter 3'];

        final prompt = llmService.generateChapterPromptWithFormat(
          'Test',
          2,
          'Chapter 2',
          chapterTitles: chapterTitles,
        );

        expect(prompt, contains('(Current Chapter)'));
        // Verify it's only marking chapter 2 as current
        final lines = prompt.split('\n');
        int currentCount = 0;
        for (final line in lines) {
          if (line.contains('(Current Chapter)')) {
            currentCount++;
          }
        }
        expect(currentCount, 1);
      });

      test('Should include both purpose and TOC together', () {
        final prompt = llmService.generateChapterPromptWithFormat(
          'Learning Flutter',
          1,
          'Getting Started',
          bookPurpose: 'Master Flutter development',
          chapterTitles: [
            'Getting Started',
            'Widgets Deep Dive',
            'State Management',
          ],
        );

        expect(
          prompt,
          contains('- Book Purpose/Goal: Master Flutter development'),
        );
        expect(prompt, contains('## Table of Contents'));
        expect(prompt, contains('1. Getting Started (Current Chapter)'));
        expect(prompt, contains('2. Widgets Deep Dive'));
        expect(prompt, contains('3. State Management'));
      });

      test('Chapter prompt should maintain all context together', () {
        final prompt = llmService.generateChapterPromptWithFormat(
          'The Complete Guide',
          2,
          'Advanced Concepts',
          bookDescription: 'A comprehensive guide for developers',
          bookPurpose: 'To empower developers with advanced skills',
          chapterTitles: [
            'Fundamentals',
            'Advanced Concepts',
            'Best Practices',
          ],
          previousChapterSummaries: ['Covered the basics and core concepts'],
        );

        expect(
          prompt,
          contains('- Book Description: A comprehensive guide for developers'),
        );
        expect(
          prompt,
          contains(
            '- Book Purpose/Goal: To empower developers with advanced skills',
          ),
        );
        expect(prompt, contains('## Table of Contents'));
        expect(prompt, contains('## Previous Chapters Summary'));
        expect(prompt, contains('1. Covered the basics and core concepts'));
      });

      test('Real-world scenario: Chapter generation with complete context', () {
        final prompt = llmService.generateChapterPromptWithFormat(
          'The Art of Negotiation',
          3,
          'Advanced Negotiation Tactics',
          bookDescription:
              'Master the skills of negotiation in business and personal contexts',
          bookPurpose:
              'To transform readers into confident, effective negotiators',
          chapterTitles: [
            '1. Foundations of Negotiation',
            '2. Communication Skills',
            '3. Advanced Negotiation Tactics',
            '4. Building Long-term Relationships',
            '5. Handling Difficult Situations',
          ],
          previousChapterSummaries: [
            'Introduced fundamental negotiation principles and their importance',
            'Covered verbal and non-verbal communication techniques',
          ],
          writingStyle: 'Practical with real examples',
          tone: 'Professional and encouraging',
        );

        // Verify all sections are present
        expect(prompt, contains('- Title: The Art of Negotiation'));
        expect(
          prompt,
          contains(
            '- Book Description: Master the skills of negotiation in business and personal contexts',
          ),
        );
        expect(
          prompt,
          contains(
            '- Book Purpose/Goal: To transform readers into confident, effective negotiators',
          ),
        );
        expect(
          prompt,
          contains('3. Advanced Negotiation Tactics (Current Chapter)'),
        );
        expect(
          prompt,
          contains('1. Introduced fundamental negotiation principles'),
        );
        expect(
          prompt,
          contains('2. Covered verbal and non-verbal communication techniques'),
        );
        expect(
          prompt,
          contains('- Writing Style: Practical with real examples'),
        );
        expect(prompt, contains('- Tone: Professional and encouraging'));
      });

      test('Should handle empty chapterTitles gracefully', () {
        final prompt = llmService.generateChapterPromptWithFormat(
          'Test',
          1,
          'Chapter 1',
          chapterTitles: [],
        );

        expect(prompt, isNotEmpty);
        expect(prompt, isNot(contains('## Table of Contents')));
      });

      test('Should not include TOC section if chapterTitles is null', () {
        final prompt = llmService.generateChapterPromptWithFormat(
          'Test',
          1,
          'Chapter 1',
          chapterTitles: null,
        );

        expect(prompt, isNot(contains('## Table of Contents')));
      });
    });

    group('Roundtrip Serialization', () {
      test(
        'TOC with LLM-generated description should survive serialization',
        () {
          final original = TOCResponse(
            bookTitle: 'Test Book',
            description: 'LLM generated description',
            chapters: [
              TOCChapter(number: 1, title: 'Ch 1', summary: 'Summary 1'),
            ],
          );

          final json = original.toJson();
          final deserialized = TOCResponse.fromJson(json);

          expect(deserialized.bookTitle, original.bookTitle);
          expect(deserialized.description, original.description);
          expect(deserialized.chapters.length, original.chapters.length);
        },
      );

      test('Full roundtrip with LLM response should preserve description', () {
        final llmJson = '''{
            "type": "toc",
            "bookTitle": "Complete Guide",
            "description": "A thorough and comprehensive guide for everyone",
            "chapters": [
              {"number": 1, "title": "Start", "summary": "Begin here"},
              {"number": 2, "title": "Middle", "summary": "Progress forward"}
            ]
          }''';

        final parsed = LLMResponse.fromJsonString(llmJson) as TOCResponse;
        final serialized = parsed.toJson();
        final reParsed = TOCResponse.fromJson(serialized);

        expect(reParsed.description, parsed.description);
        expect(reParsed.bookTitle, parsed.bookTitle);
        expect(reParsed.chapters.length, parsed.chapters.length);
      });

      test('Should treat empty string description same as null', () {
        final promptWithNull = llmService.generateTOCPromptWithFormat(
          'My Book',
        );
        final promptWithEmpty = llmService.generateTOCPromptWithFormat(
          'My Book',
          description: '',
        );

        expect(
          promptWithNull,
          contains('IF NOT PROVIDED, GENERATE A COMPELLING DESCRIPTION'),
        );
        expect(
          promptWithEmpty,
          contains('IF NOT PROVIDED, GENERATE A COMPELLING DESCRIPTION'),
        );
      });

      test('Should NOT generate description when description has content', () {
        final prompt = llmService.generateTOCPromptWithFormat(
          'My Book',
          description: 'A meaningful description',
        );

        expect(
          prompt,
          isNot(contains('IF NOT PROVIDED, GENERATE A COMPELLING DESCRIPTION')),
        );
        expect(
          prompt,
          isNot(
            contains(
              '- Include a "description" field with the generated book description',
            ),
          ),
        );
      });
    });

    group('Title Prompt - Empty Input Handling', () {
      test('Should generate title even with no context provided', () {
        final prompt = llmService.generateBookTitlePrompt();

        expect(prompt, contains('generate creative and engaging title'));
        expect(prompt, contains('ALWAYS include a description'));
      });

      test('Should specify description is required in title generation', () {
        final prompt = llmService.generateBookTitlePrompt();

        expect(prompt, contains('description (1-2 sentences)'));
        expect(prompt, contains('"description" field is REQUIRED'));
      });
    });
  });
}
