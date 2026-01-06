import 'package:flutter_test/flutter_test.dart';
import 'package:read_forge/features/reader/utils/markdown_utils.dart';

void main() {
  group('MarkdownUtils.stripMarkdown', () {
    test('should handle empty string', () {
      expect(MarkdownUtils.stripMarkdown(''), '');
    });

    group('Dollar sign sanitization (TTS fix)', () {
      test('should convert dollar amounts to "dollars" text', () {
        expect(
          MarkdownUtils.stripMarkdown('The price is \$100'),
          'The price is 100 dollars',
        );
        expect(
          MarkdownUtils.stripMarkdown('It costs \$1'),
          'It costs 1 dollars',
        );
        expect(
          MarkdownUtils.stripMarkdown('Pay \$99.99 for this item'),
          'Pay 99.99 dollars for this item',
        );
        expect(
          MarkdownUtils.stripMarkdown('\$50.25 per hour'),
          '50.25 dollars per hour',
        );
      });

      test('should remove dollar signs from variable names', () {
        expect(
          MarkdownUtils.stripMarkdown('Use the \$variable here'),
          'Use the variable here',
        );
        expect(
          MarkdownUtils.stripMarkdown('Value of \$count is 5'),
          'Value of count is 5',
        );
        expect(
          MarkdownUtils.stripMarkdown('The \$_privateVar is hidden'),
          'The _privateVar is hidden',
        );
      });

      test('should handle multiple dollar signs in text', () {
        final input = r'Items cost $1, $2, and $3 respectively';
        final result = MarkdownUtils.stripMarkdown(input);
        // The $ character needs proper handling - each should be converted
        expect(result, contains('1 dollars'));
        expect(result, contains('2 dollars'));
        expect(result, contains('3 dollars'));
      });

      test('should remove LaTeX math expressions', () {
        expect(
          MarkdownUtils.stripMarkdown('This is a formula: \$\$x^2 + y^2 = z^2\$\$'),
          'This is a formula:',
        );
        expect(
          MarkdownUtils.stripMarkdown('Inline math \$x = 5\$ is here'),
          'Inline math is here',
        );
        expect(
          MarkdownUtils.stripMarkdown(r'Display math \[E = mc^2\] is physics'),
          'Display math is physics',
        );
        expect(
          MarkdownUtils.stripMarkdown(r'Inline \(a + b = c\) works'),
          'Inline works',
        );
      });

      test('should handle mixed currency and LaTeX', () {
        expect(
          MarkdownUtils.stripMarkdown(
            'The equation \$\$x = 100\$\$ costs \$50 to compute',
          ),
          'The equation costs 50 dollars to compute',
        );
      });
    });

    group('Basic markdown removal', () {
      test('should remove headers', () {
        expect(MarkdownUtils.stripMarkdown('# Header 1'), 'Header 1');
        expect(MarkdownUtils.stripMarkdown('## Header 2'), 'Header 2');
        expect(MarkdownUtils.stripMarkdown('### Header 3'), 'Header 3');
        expect(
          MarkdownUtils.stripMarkdown('# Title\nContent'),
          'Title\nContent',
        );
      });

      test('should remove bold formatting', () {
        expect(
          MarkdownUtils.stripMarkdown('This is **bold** text'),
          'This is bold text',
        );
        expect(
          MarkdownUtils.stripMarkdown('This is __bold__ text'),
          'This is bold text',
        );
      });

      test('should remove italic formatting', () {
        expect(
          MarkdownUtils.stripMarkdown('This is *italic* text'),
          'This is italic text',
        );
        expect(
          MarkdownUtils.stripMarkdown('This is _italic_ text'),
          'This is italic text',
        );
      });

      test('should remove bold and italic combined', () {
        expect(
          MarkdownUtils.stripMarkdown('This is ***bold italic*** text'),
          'This is bold italic text',
        );
        expect(
          MarkdownUtils.stripMarkdown('This is ___bold italic___ text'),
          'This is bold italic text',
        );
      });

      test('should remove strikethrough', () {
        expect(
          MarkdownUtils.stripMarkdown('This is ~~strikethrough~~ text'),
          'This is strikethrough text',
        );
      });
    });

    group('Links and images', () {
      test('should extract link text and remove URL', () {
        expect(
          MarkdownUtils.stripMarkdown('[Click here](https://example.com)'),
          'Click here',
        );
        expect(
          MarkdownUtils.stripMarkdown(
            'Visit [Google](https://google.com) now',
          ),
          'Visit Google now',
        );
      });

      test('should handle reference-style links', () {
        expect(
          MarkdownUtils.stripMarkdown('[Link text][ref]'),
          'Link text',
        );
      });

      test('should remove images', () {
        expect(
          MarkdownUtils.stripMarkdown('![Alt text](image.png)'),
          '',
        );
        expect(
          MarkdownUtils.stripMarkdown('See ![diagram](chart.png) above'),
          'See above',
        );
      });
    });

    group('Code handling', () {
      test('should remove inline code backticks', () {
        expect(
          MarkdownUtils.stripMarkdown('Use the `code` function'),
          'Use the code function',
        );
        expect(
          MarkdownUtils.stripMarkdown('Variables like `x` and `y`'),
          'Variables like x and y',
        );
      });

      test('should remove code blocks', () {
        expect(
          MarkdownUtils.stripMarkdown('Text\n```\ncode block\n```\nMore text'),
          'Text\n\nMore text',
        );
        expect(
          MarkdownUtils.stripMarkdown('Text\n~~~\ncode block\n~~~\nMore text'),
          'Text\n\nMore text',
        );
      });

      test('should not process dollar signs inside code blocks', () {
        // Code blocks are removed entirely, so dollar signs inside them are gone too
        final result = MarkdownUtils.stripMarkdown(
          'Before\n```\n\$1 + \$2 = \$3\n```\nAfter',
        );
        expect(result, 'Before\n\nAfter');
      });
    });

    group('Lists and blockquotes', () {
      test('should remove unordered list markers', () {
        expect(MarkdownUtils.stripMarkdown('- Item 1'), 'Item 1');
        expect(MarkdownUtils.stripMarkdown('* Item 2'), 'Item 2');
        expect(MarkdownUtils.stripMarkdown('+ Item 3'), 'Item 3');
      });

      test('should remove ordered list markers', () {
        expect(MarkdownUtils.stripMarkdown('1. First'), 'First');
        expect(MarkdownUtils.stripMarkdown('2. Second'), 'Second');
        expect(MarkdownUtils.stripMarkdown('10. Tenth'), 'Tenth');
      });

      test('should remove blockquote markers', () {
        expect(MarkdownUtils.stripMarkdown('> Quote'), 'Quote');
        expect(
          MarkdownUtils.stripMarkdown('> Quote\n> Continued'),
          'Quote\nContinued',
        );
      });
    });

    group('Horizontal rules and HTML', () {
      test('should remove horizontal rules', () {
        expect(MarkdownUtils.stripMarkdown('---'), '');
        expect(MarkdownUtils.stripMarkdown('***'), '');
        expect(MarkdownUtils.stripMarkdown('___'), '');
        expect(
          MarkdownUtils.stripMarkdown('Text\n---\nMore text'),
          'Text\n\nMore text',
        );
      });

      test('should remove HTML tags', () {
        expect(
          MarkdownUtils.stripMarkdown('Text with <b>HTML</b>'),
          'Text with HTML',
        );
        expect(
          MarkdownUtils.stripMarkdown('<div>Content</div>'),
          'Content',
        );
      });

      test('should remove footnote references', () {
        expect(
          MarkdownUtils.stripMarkdown('Text with footnote[^1]'),
          'Text with footnote',
        );
      });
    });

    group('Whitespace handling', () {
      test('should clean up extra line breaks', () {
        expect(
          MarkdownUtils.stripMarkdown('Line 1\n\n\n\nLine 2'),
          'Line 1\n\nLine 2',
        );
      });

      test('should clean up extra spaces', () {
        expect(
          MarkdownUtils.stripMarkdown('Text    with     spaces'),
          'Text with spaces',
        );
      });

      test('should trim leading and trailing whitespace', () {
        expect(MarkdownUtils.stripMarkdown('  Text  '), 'Text');
        expect(MarkdownUtils.stripMarkdown('\n\nText\n\n'), 'Text');
      });
    });

    group('Markdown punctuation cleanup', () {
      test('should remove standalone asterisks and underscores', () {
        expect(
          MarkdownUtils.stripMarkdown('Text with * standalone * marks'),
          'Text with standalone marks',
        );
        expect(
          MarkdownUtils.stripMarkdown('Text with _ standalone _ marks'),
          'Text with standalone marks',
        );
      });

      test('should remove pipe characters (table markers)', () {
        expect(
          MarkdownUtils.stripMarkdown('| Column 1 | Column 2 |'),
          'Column 1 Column 2',
        );
      });

      test('should clean up stray brackets and parentheses', () {
        expect(
          MarkdownUtils.stripMarkdown('Text [ with ] brackets'),
          contains('Text'),
        );
        expect(
          MarkdownUtils.stripMarkdown('Text [ with ] brackets'),
          contains('with'),
        );
      });

      test('should normalize multiple punctuation marks', () {
        expect(
          MarkdownUtils.stripMarkdown('Really?? Amazing!!'),
          'Really? Amazing!',
        );
      });
    });

    group('Real-world scenarios', () {
      test('should handle complex markdown with dollar signs', () {
        final markdown = '''
# Chapter 1: Economics

The **price** is \$100 for *each* item.

Use the formula: \$\$profit = revenue - cost\$\$

Variables:
- \$revenue is income
- \$cost is expense
- Total: \$500

> Remember: \$1 saved is \$1 earned!

Visit [our site](https://example.com) for `\$variable` details.
''';

        final result = MarkdownUtils.stripMarkdown(markdown);

        // Should not contain "ONE DOLLAR" triggers
        expect(result, isNot(contains(r'$1')));
        expect(result, isNot(contains(r'$100')));
        expect(result, isNot(contains(r'$500')));
        expect(result, isNot(contains(r'$variable')));
        expect(result, isNot(contains(r'$$')));

        // Should convert prices properly
        expect(result, contains('100 dollars'));
        expect(result, contains('500 dollars'));
        // "Remember: $1 saved is $1 earned!" should have dollar amounts converted
        expect(result, contains('1 dollars'));

        // Should remove markdown
        expect(result, isNot(contains('**')));
        expect(result, isNot(contains('*')));
        expect(result, isNot(contains('##')));
        expect(result, isNot(contains('- ')));
        expect(result, isNot(contains('> ')));
      });

      test('should handle technical content with mixed formatting', () {
        final markdown = '''
## Tutorial

To use the API:
1. Set `\$API_KEY` environment variable
2. Pay \$50.00 per month
3. Calculate cost: \$base_cost + \$usage

```bash
export API_KEY="\$1"
echo "Cost: \$2"
```

**Note**: Prices start at \$10.
''';

        final result = MarkdownUtils.stripMarkdown(markdown);

        // Verify no dollar triggers remain
        expect(result, isNot(contains(RegExp(r'\$\d+'))));
        expect(result, isNot(contains(r'$API_KEY')));
        expect(result, isNot(contains(r'$base_cost')));

        // Should have converted prices
        expect(result, contains('50.00 dollars'));
        expect(result, contains('10 dollars'));
      });

      test('should preserve readability for TTS', () {
        final markdown = '''
**Important**: The cost is \$25.99 per hour.

Calculate using: \$rate * \$hours
''';

        final result = MarkdownUtils.stripMarkdown(markdown);

        // Should be natural to read aloud
        expect(result, contains('Important'));
        expect(result, contains('25.99 dollars per hour'));
        expect(result, isNot(contains('**')));
        expect(result, isNot(contains(r'$rate')));
      });
    });
  });
}
