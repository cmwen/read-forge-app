import 'package:flutter_test/flutter_test.dart';
import 'package:read_forge/core/services/llm_integration_service.dart';

void main() {
  group('TOC Prompt Generation with Book Metadata', () {
    late LLMIntegrationService llmService;

    setUp(() {
      llmService = LLMIntegrationService();
    });

    test('generateTOCPromptWithFormat should include book title', () {
      final prompt = llmService.generateTOCPromptWithFormat('My Awesome Book');

      expect(prompt, contains('- Title: My Awesome Book'));
    });

    test(
      'generateTOCPromptWithFormat should include description when provided',
      () {
        final prompt = llmService.generateTOCPromptWithFormat(
          'My Book',
          description: 'This is a great book about learning',
        );

        expect(
          prompt,
          contains('- Description: This is a great book about learning'),
        );
      },
    );

    test(
      'generateTOCPromptWithFormat should request description generation when not provided',
      () {
        final prompt = llmService.generateTOCPromptWithFormat('My Book');

        // Now it should show the description line with instruction to generate
        expect(prompt, contains('- Description:'));
        expect(
          prompt,
          contains('IF NOT PROVIDED, GENERATE A COMPELLING DESCRIPTION'),
        );
      },
    );

    test(
      'generateTOCPromptWithFormat should include purpose when provided',
      () {
        final prompt = llmService.generateTOCPromptWithFormat(
          'My Book',
          purpose: 'To teach readers how to code effectively',
        );

        expect(
          prompt,
          contains('- Purpose/Goal: To teach readers how to code effectively'),
        );
      },
    );

    test(
      'generateTOCPromptWithFormat should NOT include purpose when not provided',
      () {
        final prompt = llmService.generateTOCPromptWithFormat('My Book');

        expect(prompt, isNot(contains('- Purpose/Goal:')));
      },
    );

    test(
      'generateTOCPromptWithFormat should include title, description, and purpose together',
      () {
        final prompt = llmService.generateTOCPromptWithFormat(
          'The Complete Guide to Flutter',
          description:
              'A comprehensive guide covering all aspects of Flutter development',
          purpose:
              'To help developers master Flutter and build production apps',
        );

        expect(prompt, contains('- Title: The Complete Guide to Flutter'));
        expect(
          prompt,
          contains(
            '- Description: A comprehensive guide covering all aspects of Flutter development',
          ),
        );
        expect(
          prompt,
          contains(
            '- Purpose/Goal: To help developers master Flutter and build production apps',
          ),
        );
      },
    );

    test('generateTOCPromptWithFormat should include genre when provided', () {
      final prompt = llmService.generateTOCPromptWithFormat(
        'My Book',
        genre: 'Educational',
      );

      expect(prompt, contains('- Genre: Educational'));
    });

    test(
      'generateTOCPromptWithFormat should include all metadata together',
      () {
        final prompt = llmService.generateTOCPromptWithFormat(
          'Advanced Python Programming',
          description: 'Learn advanced Python techniques and patterns',
          purpose: 'To help intermediate Python developers level up',
          genre: 'Technical',
          suggestedChapters: 15,
          writingStyle: 'Technical with practical examples',
          language: 'English',
          tone: 'Professional',
          vocabularyLevel: 'Advanced',
          favoriteAuthor: 'Guido van Rossum',
        );

        // Check book information
        expect(prompt, contains('- Title: Advanced Python Programming'));
        expect(
          prompt,
          contains(
            '- Description: Learn advanced Python techniques and patterns',
          ),
        );
        expect(
          prompt,
          contains(
            '- Purpose/Goal: To help intermediate Python developers level up',
          ),
        );
        expect(prompt, contains('- Genre: Technical'));

        // Check instructions
        expect(prompt, contains('Generate 15 chapters'));

        // Check preferences
        expect(prompt, contains('- Language: English'));
        expect(
          prompt,
          contains('- Writing Style: Technical with practical examples'),
        );
        expect(prompt, contains('- Tone: Professional'));
        expect(prompt, contains('- Vocabulary Level: Advanced'));
        expect(prompt, contains('- Inspired by author: Guido van Rossum'));
      },
    );

    test(
      'generateTOCPromptWithFormat should have proper markdown structure',
      () {
        final prompt = llmService.generateTOCPromptWithFormat(
          'Test Book',
          description: 'Test Description',
          purpose: 'Test Purpose',
          writingStyle: 'Casual', // Add at least one preference
        );

        expect(prompt, contains('## Book Information'));
        expect(prompt, contains('## Instructions'));
        expect(prompt, contains('## Response Format'));
        expect(prompt, contains('## Writing Preferences'));
      },
    );

    test(
      'generateTOCPromptWithFormat should include JSON example in prompt',
      () {
        final prompt = llmService.generateTOCPromptWithFormat('Test Book');

        expect(prompt, contains('"type": "toc"'));
        expect(prompt, contains('"bookTitle"'));
        expect(prompt, contains('"chapters"'));
      },
    );

    test(
      'generateTOCPromptWithFormat should mention alternative plain text format',
      () {
        final prompt = llmService.generateTOCPromptWithFormat('Test Book');

        expect(
          prompt,
          contains('Alternatively, you can respond in plain text format'),
        );
        expect(prompt, contains('Chapter Title - Brief summary'));
      },
    );

    test(
      'generateTOCPromptWithFormat should handle special characters in metadata',
      () {
        final prompt = llmService.generateTOCPromptWithFormat(
          'Book\'s Guide to "Advanced" Topics',
          description: 'A guide about "advanced" & specialized topics',
          purpose: 'To help users learn & master new skills',
        );

        expect(prompt, contains('Book\'s Guide to "Advanced" Topics'));
        expect(prompt, contains('"advanced" & specialized topics'));
        expect(prompt, contains('learn & master new skills'));
      },
    );

    test('generateTOCPromptWithFormat should work with empty strings', () {
      final prompt = llmService.generateTOCPromptWithFormat(
        '',
        description: '',
        purpose: '',
      );

      // Should not crash and should generate valid prompt
      expect(prompt, isNotEmpty);
      expect(prompt, contains('## Book Information'));
    });

    test(
      'generateTOCPromptWithFormat should handle long descriptions and purposes',
      () {
        final longDescription =
            'This is a very long description that spans multiple lines '
            'and contains comprehensive information about what the book is about. '
            'It should be able to handle this long text without any issues '
            'and include it in the prompt properly.';

        final longPurpose =
            'The purpose of this book is to provide comprehensive coverage '
            'of the topic and help readers understand every aspect of it in detail. '
            'It aims to be a complete reference guide for professionals.';

        final prompt = llmService.generateTOCPromptWithFormat(
          'Comprehensive Guide',
          description: longDescription,
          purpose: longPurpose,
        );

        expect(prompt, contains(longDescription));
        expect(prompt, contains(longPurpose));
      },
    );

    test(
      'generateTOCPromptWithFormat should maintain consistent order of metadata',
      () {
        final prompt = llmService.generateTOCPromptWithFormat(
          'Test Book',
          description: 'Test Description',
          purpose: 'Test Purpose',
          genre: 'Test Genre',
        );

        final titleIndex = prompt.indexOf('- Title:');
        final descriptionIndex = prompt.indexOf('- Description:');
        final purposeIndex = prompt.indexOf('- Purpose/Goal:');
        final genreIndex = prompt.indexOf('- Genre:');

        // Title should come first
        expect(titleIndex, lessThan(descriptionIndex));
        // Description should come before purpose
        expect(descriptionIndex, lessThan(purposeIndex));
        // Purpose should come before genre
        expect(purposeIndex, lessThan(genreIndex));
      },
    );

    test(
      'generateTOCPromptWithFormat should only include writing preferences when provided',
      () {
        final promptWithoutPreferences = llmService.generateTOCPromptWithFormat(
          'Test Book',
        );

        // Preferences section shouldn't appear
        expect(
          promptWithoutPreferences,
          isNot(contains('## Writing Preferences')),
        );

        final promptWithPreferences = llmService.generateTOCPromptWithFormat(
          'Test Book',
          writingStyle: 'Casual',
        );

        // Preferences section should appear
        expect(promptWithPreferences, contains('## Writing Preferences'));
        expect(promptWithPreferences, contains('- Writing Style: Casual'));
      },
    );

    test('Real-world scenario: Complete book setup with all metadata', () {
      final prompt = llmService.generateTOCPromptWithFormat(
        'The Art of Effective Communication',
        description:
            'Master the skills of clear, persuasive, and empathetic communication '
            'in both personal and professional contexts.',
        purpose:
            'To transform how readers connect with others and build stronger relationships',
        genre: 'Self-Help',
        suggestedChapters: 12,
        writingStyle: 'Practical and engaging',
        language: 'English',
        tone: 'Motivational',
        vocabularyLevel: 'Intermediate',
        favoriteAuthor: 'Dale Carnegie',
      );

      // Verify all sections are present and in order
      expect(prompt, contains('Please create a detailed Table of Contents'));
      expect(prompt, contains('- Title: The Art of Effective Communication'));
      expect(prompt, contains('- Description:'));
      expect(prompt, contains('- Purpose/Goal:'));
      expect(prompt, contains('- Genre: Self-Help'));
      expect(prompt, contains('Generate 12 chapters'));
      expect(prompt, contains('## Writing Preferences'));
      expect(prompt, contains('- Language: English'));
      expect(prompt, contains('- Writing Style: Practical and engaging'));
      expect(prompt, contains('- Tone: Motivational'));
      expect(prompt, contains('- Vocabulary Level: Intermediate'));
      expect(prompt, contains('- Inspired by author: Dale Carnegie'));
      expect(prompt, contains('## Response Format'));
      expect(prompt, contains('"type": "toc"'));
    });
  });
}
