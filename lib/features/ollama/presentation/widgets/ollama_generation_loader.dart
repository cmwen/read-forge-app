import 'package:flutter/material.dart';

/// Update data during Ollama generation
class OllamaGenerationUpdate {
  final String content;
  final int tokensGenerated;
  final Duration elapsed;
  final String model;

  const OllamaGenerationUpdate({
    required this.content,
    required this.tokensGenerated,
    required this.elapsed,
    required this.model,
  });

  double get tokensPerSecond {
    if (elapsed.inMilliseconds == 0) return 0;
    return tokensGenerated / (elapsed.inMilliseconds / 1000);
  }
}

/// Widget showing Ollama generation progress with streaming
class OllamaGenerationLoader extends StatelessWidget {
  final Stream<String> contentStream;
  final String model;
  final VoidCallback onCancel;

  const OllamaGenerationLoader({
    super.key,
    required this.contentStream,
    required this.model,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<String>(
      stream: contentStream,
      builder: (context, snapshot) {
        final content = snapshot.data ?? '';
        final hasData = snapshot.hasData && content.isNotEmpty;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 12),
                Text(
                  'Generating content...',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Model Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.smart_toy,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Using: $model (local)',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Streaming Content Preview
            if (hasData) ...[
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.outline),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    content,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ] else ...[
              Center(
                child: Text(
                  'Waiting for response...',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Cancel Button
            OutlinedButton.icon(
              icon: const Icon(Icons.close),
              label: const Text('Cancel Generation'),
              onPressed: onCancel,
            ),
          ],
        );
      },
    );
  }
}
