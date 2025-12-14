import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_forge/features/reader/presentation/tts_provider.dart';
import 'package:read_forge/l10n/app_localizations.dart';

/// TTS Player widget with podcast-style controls
class TtsPlayerWidget extends ConsumerWidget {
  final VoidCallback? onClose;

  const TtsPlayerWidget({
    super.key,
    this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ttsState = ref.watch(ttsProvider);
    final l10n = AppLocalizations.of(context)!;

    if (!ttsState.isPlaying && ttsState.currentText == null) {
      return const SizedBox.shrink();
    }

    return Material(
      elevation: 8,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress indicator with chunk information
            if (ttsState.isPlaying || ttsState.totalChunks > 0) ...[
              if (ttsState.totalChunks > 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.article_outlined,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Section ${ttsState.currentChunk} of ${ttsState.totalChunks}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              LinearProgressIndicator(
                value: ttsState.totalChunks > 0
                    ? ttsState.currentChunk / ttsState.totalChunks
                    : null,
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              const SizedBox(height: 16),
            ],

            // Playback controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Rewind 10 seconds
                IconButton(
                  icon: const Icon(Icons.replay_10),
                  onPressed: ttsState.isPlaying
                      ? () => ref.read(ttsProvider.notifier).rewind()
                      : null,
                  tooltip: l10n.rewind,
                ),

                // Play/Pause
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: IconButton(
                    icon: Icon(
                      ttsState.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    iconSize: 32,
                    onPressed: () {
                      if (ttsState.isPlaying) {
                        ref.read(ttsProvider.notifier).pause();
                      } else {
                        ref.read(ttsProvider.notifier).resume();
                      }
                    },
                    tooltip: ttsState.isPlaying ? l10n.pause : l10n.play,
                  ),
                ),

                // Forward 10 seconds
                IconButton(
                  icon: const Icon(Icons.forward_10),
                  onPressed: ttsState.isPlaying
                      ? () => ref.read(ttsProvider.notifier).forward()
                      : null,
                  tooltip: l10n.forward,
                ),

                // Stop
                IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: () {
                    ref.read(ttsProvider.notifier).stop();
                    onClose?.call();
                  },
                  tooltip: l10n.stop,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Speed control
            Row(
              children: [
                Icon(
                  Icons.speed,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        l10n.slow,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Expanded(
                        child: Slider(
                          value: ttsState.speechRate,
                          min: 0.0,
                          max: 1.0,
                          divisions: 10,
                          label: _getSpeechRateLabel(ttsState.speechRate, l10n),
                          onChanged: (value) {
                            ref.read(ttsProvider.notifier).setSpeechRate(value);
                          },
                        ),
                      ),
                      Text(
                        l10n.fast,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Text(
                  _getSpeechRateLabel(ttsState.speechRate, l10n),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // Error message
            if (ttsState.errorMessage != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 20,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        ttsState.errorMessage!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getSpeechRateLabel(double rate, AppLocalizations l10n) {
    if (rate < 0.4) return l10n.slow;
    if (rate > 0.6) return l10n.fast;
    return l10n.normal;
  }
}
