import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import 'package:read_forge/core/domain/models/llm_response.dart';

/// Validation result for LLM response parsing
class ParseValidationResult {
  final bool isValid;
  final String? errorMessage;
  final String? errorDetails;
  final LLMResponse? response;

  ParseValidationResult({
    required this.isValid,
    this.errorMessage,
    this.errorDetails,
    this.response,
  });

  factory ParseValidationResult.success(LLMResponse response) {
    return ParseValidationResult(
      isValid: true,
      response: response,
    );
  }

  factory ParseValidationResult.error(String message, {String? details}) {
    return ParseValidationResult(
      isValid: false,
      errorMessage: message,
      errorDetails: details,
    );
  }
}

/// Service for integrating with external LLMs via Intent sharing
class LLMIntegrationService {
  /// Common clipboard placeholder texts that indicate invalid input
  /// These are system-generated texts that appear when clipboard is empty
  static const List<String> _clipboardPlaceholders = [
    '您複製的文字簡訊和影像會自動顯示在此處', // Chinese Android clipboard
    'Copied text messages and images will automatically appear here', // English variant
    'Text you copy will appear here', // Common variant
  ];

  /// Share a prompt with external LLM apps
  /// Returns true if sharing was successful
  Future<bool> sharePrompt(String prompt, {String? subject}) async {
    try {
      final result = await Share.share(
        prompt,
        subject: subject ?? 'ReadForge Prompt',
      );
      return result.status == ShareResultStatus.success;
    } catch (e) {
      return false;
    }
  }

  /// Parse LLM response from text with detailed validation
  /// Returns a ParseValidationResult with error details if parsing fails
  ParseValidationResult parseResponseWithValidation(String text) {
    // Check for empty or whitespace-only input
    if (text.trim().isEmpty) {
      return ParseValidationResult.error(
        'Empty input',
        details: 'The pasted text is empty. Please make sure you\'ve copied '
            'the response from your AI assistant.',
      );
    }

    // Try to parse as JSON first
    try {
      // Check if the text contains JSON
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch != null) {
        final jsonString = jsonMatch.group(0)!;
        final response = LLMResponse.fromJsonString(jsonString);
        if (response != null) {
          return ParseValidationResult.success(response);
        }
      }
    } catch (e) {
      // JSON parsing failed, continue to text parsing
    }

    // Try to parse as plain text TOC
    final response = _parsePlainTextTOC(text);
    if (response != null) {
      return ParseValidationResult.success(response);
    }

    // Only check for clipboard placeholder if we couldn't parse valid content
    // Check if the text is ONLY a clipboard placeholder (with minimal whitespace)
    final trimmedText = text.trim();
    final lowerText = trimmedText.toLowerCase();
    for (final pattern in _clipboardPlaceholders) {
      if (lowerText == pattern.toLowerCase()) {
        return ParseValidationResult.error(
          'Clipboard placeholder detected',
          details: 'It looks like you pasted clipboard placeholder text. '
              'Please copy the actual response from ChatGPT or your AI assistant '
              'and try again.',
        );
      }
    }

    // No valid format detected
    return ParseValidationResult.error(
      'Unable to parse response',
      details: 'The text doesn\'t match any expected format. Please ensure '
          'the response is either:\n'
          '• JSON format with type: "toc"\n'
          '• Plain text numbered list like:\n'
          '  1. Chapter Title - Summary\n'
          '  2. Chapter Title - Summary',
    );
  }

  /// Parse LLM response from text
  /// Attempts to parse as JSON first, then falls back to plain text parsing
  /// For backward compatibility - returns null if parsing fails
  LLMResponse? parseResponse(String text) {
    final result = parseResponseWithValidation(text);
    return result.response;
  }

  /// Parse plain text TOC response
  TOCResponse? _parsePlainTextTOC(String text) {
    final chapters = <TOCChapter>[];
    final lines = text.split('\n');

    int chapterNumber = 1;
    String? currentTitle;
    String? currentSummary;

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      // Match patterns like:
      // "1. Chapter Title"
      // "Chapter 1: Title"
      // "1. Title - Summary"
      final numberPattern = RegExp(r'^(\d+)[\.\):\s]+(.+)$');
      final match = numberPattern.firstMatch(line);

      if (match != null) {
        // Save previous chapter if exists
        if (currentTitle != null) {
          chapters.add(
            TOCChapter(
              number: chapterNumber - 1,
              title: currentTitle,
              summary: currentSummary?.trim(),
            ),
          );
        }

        chapterNumber = int.tryParse(match.group(1)!) ?? chapterNumber;
        final titleAndSummary = match.group(2)!;

        // Check if summary is included with separator (-, :, Summary:)
        final summaryPattern = RegExp(r'^(.+?)\s*[-:]\s*(.+)$');
        final summaryMatch = summaryPattern.firstMatch(titleAndSummary);

        if (summaryMatch != null) {
          currentTitle = summaryMatch.group(1)!.trim();
          currentSummary = summaryMatch.group(2)!.trim();
        } else {
          currentTitle = titleAndSummary.trim();
          currentSummary = null;
        }

        chapterNumber++;
      } else if (currentTitle != null &&
          (line.toLowerCase().startsWith('summary:') ||
              line.toLowerCase().startsWith('description:'))) {
        // Summary on separate line
        currentSummary = line.replaceFirst(
          RegExp(r'^(summary|description):\s*', caseSensitive: false),
          '',
        );
      } else if (currentTitle != null && currentSummary == null) {
        // Continuation of summary
        currentSummary = line;
      }
    }

    // Add last chapter
    if (currentTitle != null) {
      chapters.add(
        TOCChapter(
          number: chapterNumber - 1,
          title: currentTitle,
          summary: currentSummary?.trim(),
        ),
      );
    }

    if (chapters.isEmpty) {
      return null;
    }

    return TOCResponse(bookTitle: 'Untitled', chapters: chapters);
  }

  /// Generate a structured JSON prompt for TOC generation
  String generateTOCPromptWithFormat(
    String bookTitle, {
    String? description,
    String? genre,
    int suggestedChapters = 10,
    String? writingStyle,
    String? language,
    String? tone,
    String? vocabularyLevel,
    String? favoriteAuthor,
  }) {
    final exampleJson = {
      'type': 'toc',
      'bookTitle': bookTitle,
      'chapters': [
        {
          'number': 1,
          'title': 'Introduction to the Journey',
          'summary': 'Setting the stage for the adventure ahead',
        },
        {
          'number': 2,
          'title': 'The First Challenge',
          'summary': 'Our protagonist faces their first obstacle',
        },
      ],
    };

    // Build writing preferences section
    final preferencesSection = StringBuffer();
    if (writingStyle != null || language != null || tone != null || vocabularyLevel != null || favoriteAuthor != null) {
      preferencesSection.writeln('\n## Writing Preferences');
      if (language != null) preferencesSection.writeln('- Language: $language');
      if (writingStyle != null) preferencesSection.writeln('- Writing Style: $writingStyle');
      if (tone != null) preferencesSection.writeln('- Tone: $tone');
      if (vocabularyLevel != null) preferencesSection.writeln('- Vocabulary Level: $vocabularyLevel');
      if (favoriteAuthor != null) preferencesSection.writeln('- Inspired by author: $favoriteAuthor');
    }

    return '''
Please create a detailed Table of Contents for a book.

## Book Information
- Title: $bookTitle
${description != null ? '- Description: $description\n' : ''}${genre != null ? '- Genre: $genre\n' : ''}$preferencesSection
## Instructions
1. Generate $suggestedChapters chapters with clear, descriptive titles
2. Each chapter should have a brief 1-2 sentence summary
3. Ensure chapters flow naturally and build upon each other${preferencesSection.isNotEmpty ? '\n4. Follow the writing preferences specified above' : ''}

## Response Format
Please respond with a JSON object in this exact format:

${const JsonEncoder.withIndent('  ').convert(exampleJson)}

IMPORTANT: 
- The response must be valid JSON
- Include "type": "toc" to identify this as a Table of Contents response
- Number chapters sequentially starting from 1
- Each chapter must have a title and summary

Alternatively, you can respond in plain text format:
1. Chapter Title - Brief summary
2. Chapter Title - Brief summary
... and so on
''';
  }

  /// Generate a structured JSON prompt for chapter content generation
  String generateChapterPromptWithFormat(
    String bookTitle,
    int chapterNumber,
    String chapterTitle, {
    String? bookDescription,
    List<String>? previousChapterSummaries,
    String? context,
    String? writingStyle,
    String? language,
    String? tone,
    String? vocabularyLevel,
    String? favoriteAuthor,
  }) {
    final exampleJson = {
      'type': 'chapter',
      'bookTitle': bookTitle,
      'chapterNumber': chapterNumber,
      'chapterTitle': chapterTitle,
      'content': 'Your generated chapter content here...',
    };

    // Build writing preferences section
    final preferencesSection = StringBuffer();
    if (writingStyle != null || language != null || tone != null || vocabularyLevel != null || favoriteAuthor != null) {
      preferencesSection.writeln('\n## Writing Preferences');
      if (language != null) preferencesSection.writeln('- Language: $language');
      if (writingStyle != null) preferencesSection.writeln('- Writing Style: $writingStyle');
      if (tone != null) preferencesSection.writeln('- Tone: $tone');
      if (vocabularyLevel != null) preferencesSection.writeln('- Vocabulary Level: $vocabularyLevel');
      if (favoriteAuthor != null) preferencesSection.writeln('- Inspired by author: $favoriteAuthor');
    }

    return '''
Please write the content for a chapter in a book.

## Book Information
- Title: $bookTitle
- Chapter: $chapterNumber - $chapterTitle
${bookDescription != null ? '- Book Description: $bookDescription\n' : ''}

${previousChapterSummaries != null && previousChapterSummaries.isNotEmpty ? '''
## Previous Chapters Summary
${previousChapterSummaries.asMap().entries.map((e) => '${e.key + 1}. ${e.value}').join('\n')}
''' : ''}

${context != null ? '''
## Context
$context
''' : ''}$preferencesSection
## Instructions
1. Write engaging content that fits the chapter title
2. Maintain consistency with previous chapters
3. Use vivid descriptions and compelling narrative
4. Aim for approximately 1500-2000 words${preferencesSection.isNotEmpty ? '\n5. Follow the writing preferences specified above' : ''}
5. **Use Markdown formatting** for better readability (headers, bold, italic, lists, etc.)

## Response Format
Please respond with a JSON object in this exact format:

${const JsonEncoder.withIndent('  ').convert(exampleJson)}

IMPORTANT:
- The response must be valid JSON
- Include "type": "chapter" to identify this as chapter content
- The content field should contain the full chapter text
- **Use Markdown formatting** in the content (e.g., ## for headers, **bold**, *italic*, - for lists)

Alternatively, you can respond with just the Markdown-formatted text content.
''';
  }
}
