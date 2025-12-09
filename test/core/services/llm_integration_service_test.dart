import 'package:flutter_test/flutter_test.dart';
import 'package:read_forge/core/services/llm_integration_service.dart';
import 'package:read_forge/core/domain/models/llm_response.dart';

void main() {
  group('LLMIntegrationService', () {
    late LLMIntegrationService service;

    setUp(() {
      service = LLMIntegrationService();
    });

    group('parseResponse', () {
      group('JSON parsing', () {
        test('should parse valid JSON TOC response', () {
          final jsonResponse = '''
          {
            "type": "toc",
            "bookTitle": "The Great Adventure",
            "chapters": [
              {
                "number": 1,
                "title": "The Beginning",
                "summary": "Introduction to our hero"
              },
              {
                "number": 2,
                "title": "The Journey",
                "summary": "The adventure begins"
              }
            ]
          }
          ''';

          final result = service.parseResponse(jsonResponse);

          expect(result, isA<TOCResponse>());
          final tocResponse = result as TOCResponse;
          expect(tocResponse.bookTitle, 'The Great Adventure');
          expect(tocResponse.chapters.length, 2);
          expect(tocResponse.chapters[0].title, 'The Beginning');
          expect(tocResponse.chapters[1].title, 'The Journey');
        });

        test('should parse JSON embedded in text', () {
          final response = '''
          Here is the table of contents:
          
          {
            "type": "toc",
            "bookTitle": "Test Book",
            "chapters": [
              {
                "number": 1,
                "title": "Chapter One",
                "summary": "First chapter"
              }
            ]
          }
          
          Hope this helps!
          ''';

          final result = service.parseResponse(response);

          expect(result, isA<TOCResponse>());
          final tocResponse = result as TOCResponse;
          expect(tocResponse.bookTitle, 'Test Book');
          expect(tocResponse.chapters.length, 1);
        });

        test('should parse chapter response', () {
          final jsonResponse = '''
          {
            "type": "chapter",
            "bookTitle": "Test Book",
            "chapterNumber": 1,
            "chapterTitle": "Chapter One",
            "content": "This is the chapter content."
          }
          ''';

          final result = service.parseResponse(jsonResponse);

          expect(result, isA<ChapterResponse>());
          final chapterResponse = result as ChapterResponse;
          expect(chapterResponse.chapterTitle, 'Chapter One');
          expect(chapterResponse.content, 'This is the chapter content.');
        });

        test('should parse context response', () {
          final jsonResponse = '''
          {
            "type": "context",
            "bookTitle": "Test Book",
            "setting": "Medieval fantasy world",
            "characters": [
              {
                "name": "Hero",
                "description": "The protagonist"
              }
            ],
            "themes": ["courage", "friendship"]
          }
          ''';

          final result = service.parseResponse(jsonResponse);

          expect(result, isA<ContextResponse>());
          final contextResponse = result as ContextResponse;
          expect(contextResponse.setting, 'Medieval fantasy world');
          expect(contextResponse.characters.length, 1);
          expect(contextResponse.themes, ['courage', 'friendship']);
        });
      });

      group('Plain text parsing', () {
        test('should parse numbered list format "1. Title - Summary"', () {
          final textResponse = '''
          1. The Beginning - Introduction to our hero and their ordinary world
          2. The Call to Adventure - An unexpected event disrupts the hero's life
          3. The Journey Begins - Our hero sets off on their quest
          4. The Challenge - They face their first major obstacle
          5. The Revelation - A truth is revealed that changes everything
          ''';

          final result = service.parseResponse(textResponse);

          expect(result, isA<TOCResponse>());
          final tocResponse = result as TOCResponse;
          expect(tocResponse.chapters.length, 5);
          expect(tocResponse.chapters[0].number, 1);
          expect(tocResponse.chapters[0].title, 'The Beginning');
          expect(
            tocResponse.chapters[0].summary,
            'Introduction to our hero and their ordinary world',
          );
          expect(tocResponse.chapters[4].number, 5);
          expect(tocResponse.chapters[4].title, 'The Revelation');
        });

        test('should parse numbered list with periods "1. Title"', () {
          final textResponse = '''
          1. The Beginning
          2. The Journey
          3. The Challenge
          4. The Victory
          5. The Return
          ''';

          final result = service.parseResponse(textResponse);

          expect(result, isA<TOCResponse>());
          final tocResponse = result as TOCResponse;
          expect(tocResponse.chapters.length, 5);
          expect(tocResponse.chapters[0].title, 'The Beginning');
          expect(tocResponse.chapters[0].summary, null);
        });

        test('should parse with "Summary:" on separate line', () {
          final textResponse = '''
          1. The Beginning
          Summary: Introduction to our hero
          
          2. The Journey
          Summary: The adventure begins
          ''';

          final result = service.parseResponse(textResponse);

          expect(result, isA<TOCResponse>());
          final tocResponse = result as TOCResponse;
          expect(tocResponse.chapters.length, 2);
          expect(tocResponse.chapters[0].title, 'The Beginning');
          expect(tocResponse.chapters[0].summary, 'Introduction to our hero');
          expect(tocResponse.chapters[1].title, 'The Journey');
          expect(tocResponse.chapters[1].summary, 'The adventure begins');
        });

        test('should handle mixed formats', () {
          final textResponse = '''
          1. Chapter One - First chapter summary
          2. Chapter Two
          3. Chapter Three - Third chapter summary
          ''';

          final result = service.parseResponse(textResponse);

          expect(result, isA<TOCResponse>());
          final tocResponse = result as TOCResponse;
          expect(tocResponse.chapters.length, 3);
          expect(tocResponse.chapters[0].summary, 'First chapter summary');
          expect(tocResponse.chapters[1].summary, null);
          expect(tocResponse.chapters[2].summary, 'Third chapter summary');
        });

        test('should handle parentheses format "1) Title"', () {
          final textResponse = '''
          1) The Beginning - Introduction
          2) The Journey - Adventure begins
          3) The Challenge - First obstacle
          ''';

          final result = service.parseResponse(textResponse);

          expect(result, isA<TOCResponse>());
          final tocResponse = result as TOCResponse;
          expect(tocResponse.chapters.length, 3);
          expect(tocResponse.chapters[0].title, 'The Beginning');
          expect(tocResponse.chapters[0].summary, 'Introduction');
        });

        test('should return null for unparseable text', () {
          final textResponse = '''
          This is just some random text
          without any chapter structure
          or JSON format.
          ''';

          final result = service.parseResponse(textResponse);

          expect(result, null);
        });

        test('should return null for empty text', () {
          final result = service.parseResponse('');

          expect(result, null);
        });
      });

      group('parseResponseWithValidation', () {
        test('should return success for valid JSON TOC', () {
          final jsonResponse = '''
          {
            "type": "toc",
            "bookTitle": "Test Book",
            "chapters": [
              {
                "number": 1,
                "title": "Chapter One",
                "summary": "First chapter"
              }
            ]
          }
          ''';

          final result = service.parseResponseWithValidation(jsonResponse);

          expect(result.isValid, true);
          expect(result.response, isA<TOCResponse>());
          expect(result.errorMessage, null);
        });

        test('should return success for valid plain text TOC', () {
          final textResponse = '''
          1. Chapter One - First chapter
          2. Chapter Two - Second chapter
          ''';

          final result = service.parseResponseWithValidation(textResponse);

          expect(result.isValid, true);
          expect(result.response, isA<TOCResponse>());
          expect(result.errorMessage, null);
        });

        test('should detect empty input', () {
          final result = service.parseResponseWithValidation('');

          expect(result.isValid, false);
          expect(result.errorMessage, 'Empty input');
          expect(result.errorDetails, contains('empty'));
        });

        test('should detect whitespace-only input', () {
          final result = service.parseResponseWithValidation('   \n\n  \t  ');

          expect(result.isValid, false);
          expect(result.errorMessage, 'Empty input');
        });

        test('should detect Chinese clipboard placeholder', () {
          final result = service.parseResponseWithValidation(
            '您複製的文字簡訊和影像會自動顯示在此處',
          );

          expect(result.isValid, false);
          expect(result.errorMessage, 'Clipboard placeholder detected');
          expect(result.errorDetails, contains('placeholder'));
          expect(result.errorDetails, contains('ChatGPT'));
        });

        test('should detect English clipboard placeholder', () {
          final result = service.parseResponseWithValidation(
            'Copied text messages and images will automatically appear here',
          );

          expect(result.isValid, false);
          expect(result.errorMessage, 'Clipboard placeholder detected');
        });

        test('should detect clipboard placeholder case-insensitive', () {
          final result = service.parseResponseWithValidation(
            'TEXT YOU COPY WILL APPEAR HERE',
          );

          expect(result.isValid, false);
          expect(result.errorMessage, 'Clipboard placeholder detected');
        });

        test('should return detailed error for unparseable text', () {
          final result = service.parseResponseWithValidation(
            'This is just random text without structure',
          );

          expect(result.isValid, false);
          expect(result.errorMessage, 'Unable to parse response');
          expect(result.errorDetails, contains('JSON format'));
          expect(result.errorDetails, contains('numbered list'));
        });

        test('should handle text with partial JSON', () {
          final result = service.parseResponseWithValidation(
            'Here is some text { "incomplete": "json"',
          );

          expect(result.isValid, false);
          expect(result.errorMessage, 'Unable to parse response');
        });

        test(
          'should NOT detect placeholder when it appears in valid JSON content',
          () {
            // Real case: User pasted valid ChatGPT response with Chinese content
            // that happens to mention clipboard text as part of the actual content
            final validJsonWithPlaceholderInContent = '''
          {
            "type": "chapter",
            "bookTitle": "Test Book",
            "chapterNumber": 1,
            "chapterTitle": "Test Chapter",
            "content": "This chapter discusses how 您複製的文字簡訊和影像會自動顯示在此處 works in Android."
          }
          ''';

            final result = service.parseResponseWithValidation(
              validJsonWithPlaceholderInContent,
            );

            expect(result.isValid, true);
            expect(result.response, isA<ChapterResponse>());
            expect(result.errorMessage, null);
          },
        );

        test('should detect placeholder when it is the only content', () {
          // Only placeholder text, no valid JSON
          final result = service.parseResponseWithValidation(
            '  您複製的文字簡訊和影像會自動顯示在此處  ',
          );

          expect(result.isValid, false);
          expect(result.errorMessage, 'Clipboard placeholder detected');
        });
      });
    });

    group('generateTOCPromptWithFormat', () {
      test('should generate prompt with all parameters', () {
        final prompt = service.generateTOCPromptWithFormat(
          'The Great Adventure',
          description: 'An epic journey',
          genre: 'Fantasy',
          suggestedChapters: 12,
        );

        expect(prompt, contains('The Great Adventure'));
        expect(prompt, contains('An epic journey'));
        expect(prompt, contains('Fantasy'));
        expect(prompt, contains('12 chapters'));
        expect(prompt, contains('"type": "toc"'));
        expect(prompt, contains('Response Format'));
      });

      test('should generate prompt with minimal parameters', () {
        final prompt = service.generateTOCPromptWithFormat('Simple Book');

        expect(prompt, contains('Simple Book'));
        expect(prompt, contains('10 chapters')); // Default
        expect(prompt, contains('"type": "toc"'));
      });

      test('should include JSON example in prompt', () {
        final prompt = service.generateTOCPromptWithFormat('Test Book');

        expect(prompt, contains('"type": "toc"'));
        expect(prompt, contains('"bookTitle"'));
        expect(prompt, contains('"chapters"'));
        expect(prompt, contains('"number"'));
        expect(prompt, contains('"title"'));
        expect(prompt, contains('"summary"'));
      });

      test('should include alternative plain text format', () {
        final prompt = service.generateTOCPromptWithFormat('Test Book');

        expect(prompt, contains('plain text format'));
        expect(prompt, contains('1. Chapter Title - Brief summary'));
      });
    });

    group('generateChapterPromptWithFormat', () {
      test('should generate prompt with all parameters', () {
        final prompt = service.generateChapterPromptWithFormat(
          'The Great Adventure',
          1,
          'The Beginning',
          bookDescription: 'An epic journey',
          previousChapterSummaries: ['Introduction to the world'],
          context: 'Medieval fantasy setting',
        );

        expect(prompt, contains('The Great Adventure'));
        expect(prompt, contains('Chapter: 1'));
        expect(prompt, contains('The Beginning'));
        expect(prompt, contains('An epic journey'));
        expect(prompt, contains('Introduction to the world'));
        expect(prompt, contains('Medieval fantasy setting'));
        expect(prompt, contains('"type": "chapter"'));
      });

      test('should generate prompt with minimal parameters', () {
        final prompt = service.generateChapterPromptWithFormat(
          'Simple Book',
          1,
          'Chapter One',
        );

        expect(prompt, contains('Simple Book'));
        expect(prompt, contains('Chapter: 1'));
        expect(prompt, contains('Chapter One'));
        expect(prompt, contains('"type": "chapter"'));
      });

      test('should include JSON example in prompt', () {
        final prompt = service.generateChapterPromptWithFormat(
          'Test Book',
          1,
          'Test Chapter',
        );

        expect(prompt, contains('"type": "chapter"'));
        expect(prompt, contains('"bookTitle"'));
        expect(prompt, contains('"chapterNumber"'));
        expect(prompt, contains('"chapterTitle"'));
        expect(prompt, contains('"content"'));
      });

      test('should handle multiple previous chapters', () {
        final prompt = service.generateChapterPromptWithFormat(
          'Test Book',
          3,
          'Chapter Three',
          previousChapterSummaries: ['Chapter 1 summary', 'Chapter 2 summary'],
        );

        expect(prompt, contains('Chapter 1 summary'));
        expect(prompt, contains('Chapter 2 summary'));
      });
    });
  });
}
