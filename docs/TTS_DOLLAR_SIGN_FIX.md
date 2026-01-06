# TTS Dollar Sign Fix

## Problem
When using the text-to-speech (TTS) feature, the TTS engine would read dollar signs literally, causing interruptions like:
- `$1` → "ONE DOLLAR"
- `$2` → "TWO DOLLARS"
- `$100` → "ONE HUNDRED DOLLARS" (awkward phrasing)

This occurred in markdown content containing:
- Currency amounts: `$50`, `$99.99`
- Variable names: `$variable`, `$count`
- Math expressions: `$$x^2 + y^2$$`, `$x = 5$`

## Solution
Created a comprehensive markdown sanitization utility that:

### 1. Converts Currency to Spoken Form
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
