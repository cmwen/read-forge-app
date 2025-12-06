# ReadForge LLM Integration Guide

## Overview

ReadForge integrates with external Large Language Model (LLM) applications like ChatGPT, Claude, and others through Android's Intent sharing system. This document explains how the integration works and how to use it.

## Architecture

### JSON Response Format

All LLM responses should include a `type` field to distinguish between different response types:

#### TOC (Table of Contents) Response

```json
{
  "type": "toc",
  "bookTitle": "The Great Adventure",
  "chapters": [
    {
      "number": 1,
      "title": "The Beginning",
      "summary": "Introduction to our hero and their ordinary world"
    },
    {
      "number": 2,
      "title": "The Call to Adventure",
      "summary": "An unexpected event disrupts the hero's life"
    }
  ],
  "timestamp": "2025-12-06T00:00:00.000Z"
}
```

#### Chapter Content Response

```json
{
  "type": "chapter",
  "bookTitle": "The Great Adventure",
  "chapterNumber": 1,
  "chapterTitle": "The Beginning",
  "content": "Once upon a time, in a land far away...",
  "timestamp": "2025-12-06T00:00:00.000Z"
}
```

#### Context Response

```json
{
  "type": "context",
  "bookTitle": "The Great Adventure",
  "setting": "A medieval fantasy world with magic and dragons",
  "characters": [
    {
      "name": "Hero McHeroface",
      "description": "A young adventurer with a mysterious past",
      "role": "protagonist"
    }
  ],
  "themes": ["courage", "friendship", "self-discovery"],
  "timestamp": "2025-12-06T00:00:00.000Z"
}
```

## Workflow

### 1. Generate TOC

1. User taps "Generate TOC" button in book detail screen
2. App generates a structured prompt with:
   - Book information (title, description, genre)
   - Instructions for the LLM
   - Example JSON response format
   - Alternative plain text format
3. User can either:
   - **Share**: Opens system share sheet to send to LLM app
   - **Copy**: Copies prompt to clipboard for manual pasting

### 2. Get LLM Response

User interacts with their preferred LLM app (ChatGPT, Claude, etc.):
1. Paste the prompt into the LLM chat
2. Copy the LLM's response
3. Return to ReadForge

### 3. Import Response

1. App shows paste dialog automatically after sharing/copying
2. User pastes the LLM response
3. App parses the response:
   - **JSON parsing**: Tries to extract and parse JSON from response
   - **Plain text fallback**: Parses numbered list format if JSON fails
4. Chapters are created in the database
5. Success notification shown

## Plain Text Format Support

If the LLM doesn't respond with JSON, ReadForge can parse plain text formats:

```
1. Chapter Title - Brief summary of the chapter
2. Another Chapter - What happens in this chapter
3. Third Chapter - Summary of content
```

Alternative formats supported:
- `1. Title: Summary`
- `Chapter 1: Title`
- Multi-line with `Summary:` on next line

## Response Type Detection

The `type` field in JSON responses allows the app to:
- **TOC (`type: "toc"`)**: Parse and create chapters
- **Chapter (`type: "chapter"`)**: Import chapter content
- **Context (`type: "context"`)**: Update book context (characters, settings, themes)
- **Future types**: Extensible for new use cases (outlines, character profiles, etc.)

## Error Handling

### Parsing Failures

If the response cannot be parsed:
1. User sees error dialog with parsing tips
2. Option to "Try Again" reopens paste dialog
3. User can re-paste or modify the response

### Parsing Tips

The error dialog suggests:
- Ensure JSON is valid
- Use numbered list format as alternative
- Include chapter summaries
- Check response includes all required fields

## Integration Points

### LLMIntegrationService

Located in `lib/core/services/llm_integration_service.dart`:

```dart
// Share prompt via Intent
await llmService.sharePrompt(prompt, subject: 'Generate TOC');

// Parse LLM response
final response = llmService.parseResponse(responseText);

// Check response type
if (response is TOCResponse) {
  // Handle TOC
} else if (response is ChapterResponse) {
  // Handle chapter content
}
```

### Response Models

Located in `lib/core/domain/models/llm_response.dart`:
- `LLMResponse` - Base class with `type` field
- `TOCResponse` - Table of contents with chapters list
- `ChapterResponse` - Chapter content
- `ContextResponse` - Book context (characters, settings, themes)

## Future Enhancements

### Planned Features

1. **Chapter Content Generation**
   - Generate prompt for specific chapter
   - Include previous chapter summaries for context
   - Parse and save chapter content

2. **Context Updates**
   - Extract characters, settings, themes from content
   - Update book context automatically
   - Use context in subsequent chapter generation

3. **Direct LLM Integration**
   - Optional API key configuration
   - In-app generation without switching apps
   - Streaming responses for real-time updates

4. **Smart Parsing Improvements**
   - Better plain text pattern matching
   - Support more response formats
   - Automatic correction of common issues

5. **Batch Operations**
   - Generate multiple chapters at once
   - Queue chapter generation requests
   - Progress tracking for long operations

## Best Practices

### For Users

1. **Use JSON format when possible** - More reliable parsing
2. **Copy entire response** - Include all JSON braces and brackets
3. **Check chapter count** - Verify all chapters were imported
4. **Review summaries** - Edit chapter summaries if needed

### For Developers

1. **Always include `type` field** - Enables proper response routing
2. **Make timestamps optional** - Added by app if not provided
3. **Support multiple formats** - JSON + plain text fallback
4. **Validate before saving** - Check required fields exist
5. **Provide clear error messages** - Help users fix issues

## Testing LLM Integration

### Test TOC Generation

1. Create a test book
2. Generate TOC prompt
3. Test with sample responses:
   - Valid JSON response
   - Plain text numbered list
   - Invalid/malformed response

### Sample Test Responses

**Valid JSON:**
```json
{
  "type": "toc",
  "bookTitle": "Test Book",
  "chapters": [
    {"number": 1, "title": "Chapter One", "summary": "First chapter"},
    {"number": 2, "title": "Chapter Two", "summary": "Second chapter"}
  ]
}
```

**Plain Text:**
```
1. Chapter One - First chapter summary
2. Chapter Two - Second chapter summary
3. Chapter Three - Third chapter summary
```

## Troubleshooting

### Common Issues

**Issue**: Chapters not importing
- **Solution**: Check response format matches examples
- **Solution**: Verify JSON is valid (use JSON validator)
- **Solution**: Try plain text format instead

**Issue**: Share button not working
- **Solution**: Ensure share_plus package is installed
- **Solution**: Check Android permissions
- **Solution**: Try copy to clipboard instead

**Issue**: Wrong number of chapters imported
- **Solution**: Check JSON array length
- **Solution**: Verify all chapters have required fields
- **Solution**: Look for parsing errors in logs

## Security Considerations

1. **No data sent to servers** - All LLM interaction happens externally
2. **User controls data flow** - User manually copies/pastes
3. **Local storage only** - All data stored in SQLite on device
4. **Optional API keys** - For future direct integration
5. **API keys in Android Keystore** - Encrypted at rest

## API Reference

See:
- `lib/core/services/llm_integration_service.dart` - Main service
- `lib/core/domain/models/llm_response.dart` - Response models
- `lib/features/book/presentation/book_detail_screen.dart` - UI implementation

---

**Last Updated**: December 6, 2025  
**Version**: 0.1.0  
**Status**: Implemented ✅
