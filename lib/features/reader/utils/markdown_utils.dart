/// Utilities for processing markdown text, especially for Text-to-Speech
class MarkdownUtils {
  /// Strip markdown formatting for better TTS reading
  /// 
  /// This function removes markdown syntax and sanitizes text to improve
  /// the listening experience when using text-to-speech features.
  /// 
  /// Handles:
  /// - Headers (# ## ###)
  /// - Bold (**text** or __text__)
  /// - Italic (*text* or _text_)
  /// - Links [text](url)
  /// - Inline code `code`
  /// - Code blocks ```code```
  /// - Blockquotes (> text)
  /// - List markers (- * + or 1. 2. 3.)
  /// - Horizontal rules (--- or ***)
  /// - Dollar signs and currency (to prevent TTS from reading "$1" as "ONE DOLLAR")
  /// - Math expressions and LaTeX-style formulas
  static String stripMarkdown(String markdown) {
    if (markdown.isEmpty) return markdown;
    
    String text = markdown;

    // Remove code blocks first (to avoid processing their contents)
    text = text.replaceAll(RegExp(r'```[^`]*```', multiLine: true), '');
    text = text.replaceAll(RegExp(r'~~~[^~]*~~~', multiLine: true), '');

    // Remove LaTeX/Math expressions (common in technical books)
    // Remove display math: $$...$$ or \[...\]
    text = text.replaceAll(RegExp(r'\$\$[^$]*\$\$'), '');
    text = text.replaceAll(RegExp(r'\\\[[^\]]*\\\]'), '');
    
    // Remove inline math: $...$ or \(...\)
    // NOTE: Use non-greedy matching and require non-space, non-digit start
    // to avoid matching currency like "$1 saved is $1"
    text = text.replaceAll(RegExp(r'\$[a-zA-Z\\][^$\n]*?\$'), '');
    text = text.replaceAll(RegExp(r'\\\([^)]*\\\)'), '');

    // Remove headers
    text = text.replaceAll(RegExp(r'^#{1,6}\s+', multiLine: true), '');

    // Remove bold and italic (use callback to avoid $1 in replacement)
    text = text.replaceAllMapped(
      RegExp(r'\*\*\*([^*]+)\*\*\*'),
      (m) => m.group(1)!,
    ); // Bold+Italic
    text = text.replaceAllMapped(
      RegExp(r'\*\*([^*]+)\*\*'),
      (m) => m.group(1)!,
    ); // Bold
    text = text.replaceAllMapped(
      RegExp(r'\*([^*]+)\*'),
      (m) => m.group(1)!,
    ); // Italic
    text = text.replaceAllMapped(
      RegExp(r'___([^_]+)___'),
      (m) => m.group(1)!,
    ); // Bold+Italic
    text = text.replaceAllMapped(
      RegExp(r'__([^_]+)__'),
      (m) => m.group(1)!,
    ); // Bold
    text = text.replaceAllMapped(
      RegExp(r'_([^_]+)_'),
      (m) => m.group(1)!,
    ); // Italic

    // Remove strikethrough
    text = text.replaceAllMapped(
      RegExp(r'~~([^~]+)~~'),
      (m) => m.group(1)!,
    );

    // Remove inline code (after most markdown processing)
    text = text.replaceAllMapped(
      RegExp(r'`([^`]+)`'),
      (m) => m.group(1)!,
    );

    // Remove images ![alt](url) - MUST be before links!
    text = text.replaceAll(RegExp(r'!\[[^\]]*\]\([^)]+\)'), '');

    // Remove links but keep text [text](url)
    text = text.replaceAllMapped(
      RegExp(r'\[([^\]]+)\]\([^)]+\)'),
      (m) => m.group(1)!,
    );
    
    // Remove reference-style links [text][ref]
    text = text.replaceAllMapped(
      RegExp(r'\[([^\]]+)\]\[[^\]]+\]'),
      (m) => m.group(1)!,
    );

    // Remove blockquotes
    text = text.replaceAll(RegExp(r'^>\s+', multiLine: true), '');

    // Remove list markers
    text = text.replaceAll(RegExp(r'^[-*+]\s+', multiLine: true), '');
    text = text.replaceAll(RegExp(r'^\d+\.\s+', multiLine: true), '');

    // Remove horizontal rules
    text = text.replaceAll(RegExp(r'^[-*_]{3,}$', multiLine: true), '');

    // Remove HTML tags (basic)
    text = text.replaceAll(RegExp(r'<[^>]+>'), '');

    // Remove footnote references [^1]
    text = text.replaceAll(RegExp(r'\[\^[^\]]+\]'), '');

    // NOW sanitize remaining dollar signs for better TTS
    // (After all markdown processing to avoid issues with $1 in regex replacements)
    // Replace common currency patterns: $100 -> 100 dollars
    text = text.replaceAllMapped(
      RegExp(r'\$(\d+(?:\.\d{2})?)'),
      (match) => '${match.group(1)} dollars',
    );
    
    // Replace remaining dollar signs (e.g., in variable names like $var)
    // Remove dollar sign before alphanumeric characters
    text = text.replaceAllMapped(
      RegExp(r'\$([a-zA-Z_]\w*)'),
      (m) => m.group(1)!,
    );
    
    // Replace any remaining standalone dollar signs
    text = text.replaceAll(r'$', '');

    // Remove any remaining markdown punctuation that could confuse TTS
    // Remove standalone brackets, parentheses that aren't part of words
    text = text.replaceAll(RegExp(r'\s*\[\s*'), ' ');
    text = text.replaceAll(RegExp(r'\s*\]\s*'), ' ');
    text = text.replaceAll(RegExp(r'\s*\(\s*'), ' (');
    text = text.replaceAll(RegExp(r'\s*\)\s*'), ') ');
    
    // Remove standalone asterisks, underscores, hashes
    text = text.replaceAll(RegExp(r'(?<!\w)[*_#]+(?!\w)'), '');
    
    // Remove pipe characters (table markers)
    text = text.replaceAll('|', '');
    
    // Remove multiple punctuation marks (like !!, ??, ...)
    text = text.replaceAllMapped(
      RegExp(r'([!?.])\1+'),
      (m) => m.group(1)!,
    );

    // Clean up extra whitespace
    text = text.replaceAll(RegExp(r'\n\n+'), '\n\n');
    text = text.replaceAll(RegExp(r'[ \t]+'), ' ');
    text = text.trim();

    return text;
  }
}
