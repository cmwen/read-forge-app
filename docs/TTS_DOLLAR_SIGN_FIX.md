# TTS Dollar Sign Fix

## Problem
When using the text-to-speech (TTS) feature, the TTS engine would read "one dollar" repeatedly, even though the text "$1" wasn't visible in the rendered markdown content. This occurred due to:

1. **Regex Replacement Bugs**: Using `r'$1'` as a replacement string in regex operations literally inserted the text `$1` into the processed content, which TTS read as "ONE DOLLAR"
2. **Markdown Syntax Characters**: Special markdown characters (asterisks, brackets, parentheses) were being passed to TTS, potentially confusing the engine
3. **Actual Dollar Signs**: Currency amounts, variable names, and math expressions in markdown also contained dollar signs

The main issue was that regex replacement patterns like `r'$1'` were being used instead of callback functions, leaving literal `$1` text that was invisible to users but read aloud by TTS.

## Solution
Created a comprehensive markdown sanitization utility that:

### 1. Uses Callbacks Instead of String Replacements
```dart
// WRONG - leaves literal $1 in text:
text.replaceAll(RegExp(r'\*\*([^*]+)\*\*'), r'$1');

// CORRECT - uses callback function:
text.replaceAllMapped(RegExp(r'\*\*([^*]+)\*\*'), (m) => m.group(1)!);
```

### 2. Converts Currency to Spoken Form
```markdown
Input:  "The price is $100"
Output: "The price is 100 dollars"
```

### 2. Removes Dollar Signs from Variables
```markdown
Input:  "Use the $variable here"
Output: "Use the variable here"
```

### 3. Removes LaTeX Math Expressions
```markdown
Input:  "The formula $$x^2 + y^2 = z^2$$ explains..."
Output: "The formula explains..."
```

### 4. Cleans Up Markdown Punctuation
- Removes standalone asterisks, underscores, hashes
- Removes pipe characters (table markers)
- Normalizes multiple punctuation (!! → !, ?? → ?)
- Cleans up stray brackets and parentheses

## Root Cause

The primary issue was **regex replacement patterns leaving literal `$1` in the text**:

```dart
// This code was creating the problem:
text = text.replaceAll(RegExp(r'([!?.])\1+'), r'$1');
// Result: "Really??" → "Really$1" (TTS reads as "Really ONE DOLLAR")

// Fixed version uses callback:
text = text.replaceAllMapped(RegExp(r'([!?.])\1+'), (m) => m.group(1)!);
// Result: "Really??" → "Really?" (TTS reads correctly)
```

This explains why users couldn't see "one dollar" in the rendered content but heard it through TTS - the `$1` pattern was invisible in normal rendering but pronounced by the TTS engine.

## Implementation

### New Files
- `lib/features/reader/utils/markdown_utils.dart` - Utility class for markdown processing
- `test/features/reader/utils/markdown_utils_test.dart` - Comprehensive test suite (29 tests)

### Modified Files
- `lib/features/reader/presentation/reader_screen.dart` - Updated to use new utility

### Key Features
1. **Order of Operations**: Processes markdown in the correct sequence to avoid regex replacement issues
2. **LaTeX Support**: Removes both display (`$$...$$`) and inline (`$...$`) math
3. **Comprehensive Coverage**: Handles headers, bold, italic, links, code blocks, lists, etc.
4. **TTS-Optimized**: Specifically designed to improve listening experience

## Usage

```dart
import 'package:read_forge/features/reader/utils/markdown_utils.dart';

// Strip markdown for TTS
String markdown = '# Chapter 1\n\nThe price is **$100** for *each* item.';
String plainText = MarkdownUtils.stripMarkdown(markdown);
// Result: "Chapter 1\n\nThe price is 100 dollars for each item."
```

## Testing
All 134 tests pass, including 29 new tests specifically for markdown sanitization:
- ✅ Dollar sign conversion
- ✅ Currency handling
- ✅ Variable name sanitization
- ✅ LaTeX math expression removal
- ✅ Real-world markdown scenarios
- ✅ Edge cases and complex formatting

## Benefits
- 📢 **Natural TTS**: No more "ONE DOLLAR" interruptions
- 📖 **Improved Listening**: Currency amounts read naturally
- 🔧 **Technical Content**: Variables and math expressions handled correctly
- 🎯 **Comprehensive**: Covers all common markdown patterns
- ✅ **Well-Tested**: 29 tests ensure robust behavior

## Example Transformations

### Before (TTS Issues)
```
"Remember: $1 saved is $1 earned!"
→ TTS reads: "Remember: ONE DOLLAR saved is ONE DOLLAR earned!"
```

### After (Natural)
```
"Remember: $1 saved is $1 earned!"
→ Processed: "Remember: 1 dollars saved is 1 dollars earned!"
→ TTS reads: "Remember: one dollars saved is one dollars earned!"
```

## Future Enhancements
Possible improvements for future versions:
- Smarter currency pluralization (1 dollar vs 2 dollars)
- Support for other currencies (€, £, ¥)
- Configurable dollar sign handling strategies
- Language-specific processing rules
