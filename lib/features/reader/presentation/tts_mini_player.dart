import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_forge/features/reader/presentation/tts_provider.dart';
import 'package:read_forge/features/reader/presentation/tts_player_screen.dart';
import 'package:read_forge/l10n/app_localizations.dart';

/// A reusable floating mini player widget for TTS control.
/// Shows at the bottom of any screen when TTS is active.
/// Displays real-time progress and basic play/pause/stop controls.
class TtsMiniPlayer extends ConsumerStatefulWidget {
  const TtsMiniPlayer({super.key});

  @override
  ConsumerState<TtsMiniPlayer> createState() => _TtsMiniPlayerState();
}

class _TtsMiniPlayerState extends ConsumerState<TtsMiniPlayer> {
  bool _playerScreenOpen = false;

  void _openPlayerScreen(BuildContext context, int bookId, int chapterId) {
    if (!_playerScreenOpen) {
      _playerScreenOpen = true;
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (context) =>
                  TtsPlayerScreen(bookId: bookId, chapterId: chapterId),
            ),
          )
          .then((_) {
            if (mounted) {
              _playerScreenOpen = false;
            }
          });
    }
  }

  /// Format a Duration as "m:ss"
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final ttsState = ref.watch(ttsProvider);
    final ttsContext = ref.watch(ttsContextProvider);
    final l10n = AppLocalizations.of(context)!;

    // Don't show if TTS is not active or no context
    final isActive =
        ttsState.isPlaying || ttsState.isPaused || ttsState.currentText != null;
    if (!isActive ||
        ttsContext.bookId == null ||
        ttsContext.chapterId == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Material(
        elevation: 8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Smooth progress bar at top of mini player
            if (ttsState.totalCharacters > 0)
              LinearProgressIndicator(
                value: ttsState.progress,
                minHeight: 3,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            Container(
              height: 68,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                border: ttsState.totalCharacters == 0
                    ? Border(
                        top: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          width: 1,
                        ),
                      )
                    : null,
              ),
              child: InkWell(
                onTap: () => _openPlayerScreen(
                  context,
                  ttsContext.bookId!,
                  ttsContext.chapterId!,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      // Animated playing icon
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          ttsState.isPlaying ? Icons.graphic_eq : Icons.pause,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Text info with time and current word
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ttsState.currentWord.isNotEmpty
                                  ? '...${ttsState.currentWord}...'
                                  : l10n.textToSpeech,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            if (ttsState.estimatedDuration > Duration.zero)
                              Text(
                                '${_formatDuration(ttsState.estimatedPosition)} / ${_formatDuration(ttsState.estimatedDuration)}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              )
                            else if (ttsState.totalChunks > 0)
                              Text(
                                '${ttsState.currentChunk} / ${ttsState.totalChunks}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              )
                            else
                              Text(
                                ttsState.isPlaying ? l10n.playing : l10n.paused,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                          ],
                        ),
                      ),
                      // Play/Pause button
                      IconButton(
                        icon: Icon(
                          ttsState.isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 28,
                        ),
                        onPressed: () {
                          final notifier = ref.read(ttsProvider.notifier);
                          if (ttsState.isPlaying) {
                            notifier.pause();
                          } else {
                            notifier.resume();
                          }
                        },
                        tooltip: ttsState.isPlaying ? l10n.pause : l10n.play,
                      ),
                      // Stop button
                      IconButton(
                        icon: const Icon(Icons.stop, size: 24),
                        onPressed: () {
                          final notifier = ref.read(ttsProvider.notifier);
                          notifier.stop();
                          ref.read(ttsContextProvider.notifier).clear();
                        },
                        tooltip: l10n.stop,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
