# ReadForge - LLM Prompt Strategy

---
**Created**: December 6, 2025  
**Version**: 1.0  
**Status**: Design  
**Related**: [REQUIREMENTS_MVP.md](./REQUIREMENTS_MVP.md)  
---

## Overview

This document defines the prompt generation strategy for ReadForge. The app generates prompts that users share with external LLMs via Android Intent. Prompts must be:

1. **Self-contained**: LLM has no memory of previous conversations
2. **Context-rich**: Include all necessary information for coherent generation
3. **User-tailored**: Reflect user's style, language, and preferences
4. **Token-efficient**: Maximize value within context limits

---

## Prompt Templates

### 1. Book Outline / Table of Contents

**Purpose**: Generate structured chapter list for a new book

**Template**:
```
I need you to create a detailed table of contents for a book.

## Book Information
- Title: {book.title}
- Subtitle: {book.subtitle || "N/A"}
- Genre: {book.genre || "General"}
- Description: {book.description || "No description provided"}

## Writing Preferences
- Language: {preferences.language}
- Style: {preferences.writingStyle}
- Tone: {preferences.tone}
- Vocabulary Level: {preferences.vocabularyLevel}
{if preferences.favoriteAuthor}
- Style Inspiration: Write in a style inspired by {preferences.favoriteAuthor}
{/if}

## Requirements
1. Create a logical chapter structure with {suggested_chapter_count || "8-12"} chapters
2. Each chapter should have a clear, descriptive title
3. Include a brief 1-2 sentence summary for each chapter
4. Ensure chapters flow naturally and build upon each other
5. Format the output as a numbered list

## Output Format
Please format your response as follows:
1. Chapter Title
   Summary: Brief description of chapter content

2. Chapter Title
   Summary: Brief description of chapter content

(continue for all chapters)
```

**Token Estimate**: ~300-400 tokens

---

### 2. Chapter Content Generation

**Purpose**: Generate content for a specific chapter with full context

**Template**:
```
I need you to write the content for a chapter in a book.

## Book Information
- Title: {book.title}
- Genre: {book.genre}
- Description: {book.description}

## Writing Preferences
- Language: {preferences.language}
- Style: {preferences.writingStyle}
- Tone: {preferences.tone}
- Vocabulary Level: {preferences.vocabularyLevel}
{if preferences.favoriteAuthor}
- Style Inspiration: Write in a style inspired by {preferences.favoriteAuthor}
{/if}

## Book Context
{if context.setting}
### Setting
{context.setting}
{/if}

{if context.characters.length > 0}
### Characters
{for each character in context.characters}
- {character.name}: {character.description}
{/for}
{/if}

{if context.themes.length > 0}
### Themes
{context.themes.join(", ")}
{/if}

{if context.customContext}
### Additional Context
{context.customContext}
{/if}

## Previous Chapters Summary
{if previousChapters.length > 0}
{for each chapter in previousChapters}
Chapter {chapter.orderIndex}: {chapter.title}
{chapter.summary}

{/for}
{else}
This is the first chapter.
{/if}

## Current Chapter
- Chapter Number: {chapter.orderIndex}
- Chapter Title: {chapter.title}
{if chapter.summary}
- Chapter Summary: {chapter.summary}
{/if}

## Requirements
1. Write the complete chapter content (approximately {target_word_count || "1500-2500"} words)
2. Maintain consistency with the established context and previous chapters
3. Follow the writing style and tone preferences
4. Start with engaging opening content
5. End with natural transition or hook for next chapter
6. Use proper paragraph breaks and pacing

## Output
Write only the chapter content. Do not include the chapter title or any meta-commentary.
```

**Token Estimate**: ~500-800 tokens (varies with context size)

---

### 3. Chapter Summary Generation

**Purpose**: Generate summary of existing chapter for context

**Template**:
```
Please summarize the following chapter in 2-3 sentences, capturing the key events, character developments, and important plot points.

## Chapter Information
- Chapter Number: {chapter.orderIndex}
- Chapter Title: {chapter.title}

## Chapter Content
{chapter.content}

## Requirements
- Keep summary to 2-3 sentences
- Focus on plot-critical information
- Note any character introductions or developments
- Mention setting changes if relevant
```

**Token Estimate**: Varies with chapter length

---

### 4. Context Extraction

**Purpose**: Extract characters/settings from generated content

**Template**:
```
Please analyze the following chapter and extract:
1. Characters (name, brief description, role)
2. Settings/Locations (name, description)
3. Key themes or motifs

## Chapter Content
{chapter.content}

## Output Format
### Characters
- Name: Description (role in story)

### Settings
- Location: Description

### Themes
- Theme 1
- Theme 2
```

**Token Estimate**: Varies with chapter length

---

## Context Management Strategy

### Token Budget Allocation

For a typical 8K context window LLM:

| Component | Token Budget | Notes |
|-----------|--------------|-------|
| System/Instructions | 500 | Fixed overhead |
| Book Metadata | 100 | Title, genre, description |
| User Preferences | 100 | Style, language, tone |
| Book Context | 500 | Characters, setting, themes |
| Previous Chapters | 1500-3000 | Summaries, not full content |
| Current Chapter Info | 100 | Title, summary |
| Output Space | 3000-4000 | Generated content |

### Progressive Context Compression

As books grow, context must be managed:

1. **Chapters 1-3**: Include full previous chapter summaries
2. **Chapters 4-8**: Include last 2 full summaries + compressed earlier
3. **Chapters 9+**: Include last 2 full + major plot points only
4. **Characters**: Prioritize recently active characters
5. **Settings**: Include current setting + referenced settings

### Smart Summary Hierarchy

```
Book Summary (50 words)
├── Act 1 Summary (100 words)
│   ├── Chapter 1 Summary (50 words)
│   └── Chapter 2 Summary (50 words)
├── Act 2 Summary (100 words)
│   ├── Chapter 3 Summary (50 words)
│   └── ...
└── Recent Chapters (full summaries)
    ├── Chapter N-2 Summary (100 words)
    ├── Chapter N-1 Summary (100 words)
    └── Chapter N (current)
```

---

## User Preference Mapping

### Writing Style Options
| UI Option | Prompt Phrase |
|-----------|---------------|
| Descriptive | "Use rich, detailed descriptions and vivid imagery" |
| Concise | "Use clear, efficient prose without unnecessary embellishment" |
| Poetic | "Use lyrical language with attention to rhythm and metaphor" |
| Technical | "Use precise, informative language with clear explanations" |
| Conversational | "Use a friendly, natural voice as if speaking to a friend" |

### Tone Options
| UI Option | Prompt Phrase |
|-----------|---------------|
| Formal | "Maintain a formal, professional tone throughout" |
| Casual | "Use a relaxed, casual tone" |
| Humorous | "Include wit and humor where appropriate" |
| Serious | "Maintain a serious, thoughtful tone" |
| Dramatic | "Use dramatic tension and emotional intensity" |
| Whimsical | "Use a light, playful, and imaginative tone" |

### Vocabulary Level
| UI Option | Prompt Phrase |
|-----------|---------------|
| Simple | "Use simple vocabulary suitable for casual readers (grade 6-8 level)" |
| Moderate | "Use moderate vocabulary accessible to general audiences" |
| Advanced | "Use sophisticated vocabulary for well-read audiences" |
| Academic | "Use academic vocabulary with field-specific terminology" |

---

## Parsing LLM Responses

### TOC Parsing Rules

Expected formats to handle:
```
# Format 1: Numbered with summary
1. Chapter Title
   Summary: Description here

# Format 2: Numbered inline
1. Chapter Title - Description here

# Format 3: Bullet points
• Chapter Title
  Description here

# Format 4: Markdown headers
## Chapter 1: Title
Description here

# Format 5: Simple numbered
1. Chapter Title
2. Chapter Title
```

**Parsing Strategy**:
1. Split by line breaks
2. Identify chapter markers (numbers, bullets, headers)
3. Extract title (text after marker, before colon/dash/newline)
4. Extract summary (remaining text or following line)
5. Handle multi-line descriptions
6. Validate: reject if < 3 chapters detected

### Content Validation

After pasting chapter content:
1. Check minimum word count (100+ words)
2. Warn if contains markdown headers (might be meta-content)
3. Warn if starts with "Chapter" or chapter number
4. Strip leading/trailing whitespace
5. Normalize paragraph breaks

---

## Intent Sharing Implementation

### Sharing Prompt

```dart
final intent = AndroidIntent(
  action: 'android.intent.action.SEND',
  type: 'text/plain',
  arguments: {
    'android.intent.extra.TEXT': generatedPrompt,
    'android.intent.extra.SUBJECT': 'ReadForge: Generate ${book.title} - ${chapter.title}',
  },
);
await intent.launch();
```

### Receiving Content

Register for `android.intent.action.SEND` with `text/plain` MIME type:
- Deep link to specific book/chapter if context available
- Otherwise, offer to paste into current draft chapter
- Show paste destination picker if multiple options

---

## Error Handling

### Common Issues

| Issue | Detection | Recovery |
|-------|-----------|----------|
| Partial response | Word count < expected | Show warning, allow retry |
| Wrong format | Parsing fails | Show raw text, manual edit |
| Off-topic | N/A (hard to detect) | User judgment, regenerate |
| Inconsistent | N/A (hard to detect) | Highlight in context for next prompt |
| Truncated | Ends mid-sentence | Append "[Response truncated]" warning |

---

## Future: Direct API Integration

When BYOK API integration is implemented:

### Request Structure
```dart
class LLMRequest {
  String model;
  String prompt;
  int maxTokens;
  double temperature;
  String? systemPrompt;
}
```

### Provider Adapters
- OpenAI: Chat completions API
- Anthropic: Messages API
- Custom: User-defined endpoint

### Streaming Support
- Display generation in real-time
- Allow cancellation mid-generation
- Save partial results on cancel

---

*This document guides prompt generation implementation. See [REQUIREMENTS_MVP.md](./REQUIREMENTS_MVP.md) for full requirements.*
