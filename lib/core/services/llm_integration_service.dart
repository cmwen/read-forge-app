import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import 'package:read_forge/core/domain/models/llm_response.dart';

/// Service for integrating with external LLMs via Intent sharing
class LLMIntegrationService {
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

  /// Parse LLM response from text
  /// Attempts to parse as JSON first, then falls back to plain text parsing
  LLMResponse? parseResponse(String text) {
    // Try to parse as JSON first
    try {
      // Check if the text contains JSON
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch != null) {
        final jsonString = jsonMatch.group(0)!;
        final response = LLMResponse.fromJsonString(jsonString);
        if (response != null) {
          return response;
        }
      }
    } catch (e) {
      // JSON parsing failed, continue to text parsing
    }

    // Try to parse as plain text TOC
    return _parsePlainTextTOC(text);
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
          chapters.add(TOCChapter(
            number: chapterNumber - 1,
            title: currentTitle,
            summary: currentSummary?.trim(),
          ));
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
      chapters.add(TOCChapter(
        number: chapterNumber - 1,
        title: currentTitle,
        summary: currentSummary?.trim(),
      ));
    }

    if (chapters.isEmpty) {
      return null;
    }

    return TOCResponse(
      bookTitle: 'Untitled',
      chapters: chapters,
    );
  }

  /// Generate a structured JSON prompt for TOC generation
  String generateTOCPromptWithFormat(
    String bookTitle, {
    String? description,
    String? genre,
    int suggestedChapters = 10,
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

    return '''
Please create a detailed Table of Contents for a book.

## Book Information
- Title: $bookTitle
${description != null ? '- Description: $description\n' : ''}${genre != null ? '- Genre: $genre\n' : ''}

## Instructions
1. Generate $suggestedChapters chapters with clear, descriptive titles
2. Each chapter should have a brief 1-2 sentence summary
3. Ensure chapters flow naturally and build upon each other

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
  }) {
    final exampleJson = {
      'type': 'chapter',
      'bookTitle': bookTitle,
      'chapterNumber': chapterNumber,
      'chapterTitle': chapterTitle,
      'content': 'Your generated chapter content here...',
    };

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
''' : ''}

## Instructions
1. Write engaging content that fits the chapter title
2. Maintain consistency with previous chapters
3. Use vivid descriptions and compelling narrative
4. Aim for approximately 1500-2000 words

## Response Format
Please respond with a JSON object in this exact format:

${const JsonEncoder.withIndent('  ').convert(exampleJson)}

IMPORTANT:
- The response must be valid JSON
- Include "type": "chapter" to identify this as chapter content
- The content field should contain the full chapter text
- You can include markdown formatting in the content

Alternatively, you can respond with just the plain text content.
''';
  }
}
