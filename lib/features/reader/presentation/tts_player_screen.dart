import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_forge/features/reader/presentation/tts_provider.dart';
import 'package:read_forge/features/reader/presentation/reading_progress_provider.dart';
import 'package:read_forge/l10n/app_localizations.dart';
import 'package:read_forge/core/providers/database_provider.dart';

/// Full-screen TTS player with controls and progress
class TtsPlayerScreen extends ConsumerStatefulWidget {
  final int bookId;
  final int chapterId;

  const TtsPlayerScreen({
    super.key,
    required this.bookId,
    required this.chapterId,
  });

  @override
  ConsumerState<TtsPlayerScreen> createState() => _TtsPlayerScreenState();
}

class _TtsPlayerScreenState extends ConsumerState<TtsPlayerScreen> {
  // Scale factor for progress calculation (0-1000 for precision)
  static const int _progressScale = 1000;
  
  @override
  void initState() {
    super.initState();
  }
  
  /// Sync reading scroll position with TTS chunk progress
  void _syncReadingProgress(int currentChunk, int totalChunks) {
    if (!mounted) return;
    
    // Calculate approximate position based on chunk progress
    final progress = (currentChunk / totalChunks * _progressScale).round();
    
    // Update reading progress (this will auto-scroll if user returns to reader)
    final progressNotifier = ref.read(
      readingProgressProvider(
        ReadingProgressParams(
          bookId: widget.bookId,
          chapterId: widget.chapterId,
        ),
      ),
    );
    
    // Update the position but don't save immediately (save on playback end)
    if (mounted && progressNotifier.scrollController.hasClients) {
      final maxScroll = progressNotifier.scrollController.position.maxScrollExtent;
      final targetPosition = (progress / _progressScale.toDouble() * maxScroll).clamp(0.0, maxScroll);
      
      // Smoothly scroll to sync position
      progressNotifier.scrollController.animateTo(
        targetPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ttsState = ref.watch(ttsProvider);
    final l10n = AppLocalizations.of(context)!;
    
    // Listen to TTS state changes for auto-close and progress sync
    ref.listen<TtsState>(ttsProvider, (previous, next) {
      // Auto-close screen when playback stops
      if (previous?.isPlaying == true && !next.isPlaying && next.currentText == null) {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }
      
      // Sync reading progress when chunk changes
      if (next.totalChunks > 0 && 
          previous?.currentChunk != next.currentChunk) {
        _syncReadingProgress(next.currentChunk, next.totalChunks);
      }
    });

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        // Keep TTS playing when navigating back
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: Text(l10n.textToSpeech),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                ref.read(ttsProvider.notifier).stop();
                Navigator.of(context).pop();
              },
              tooltip: l10n.stop,
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Book/Chapter info
                FutureBuilder(
                  future: _getChapterInfo(ref),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data as Map<String, String>;
                      return Column(
                        children: [
                          Text(
                            data['bookTitle'] ?? '',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            data['chapterTitle'] ?? '',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                const SizedBox(height: 48),

                // Large play/pause button
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      ttsState.isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 64,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
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

                const SizedBox(height: 48),

                // Progress section with better visual indication
                if (ttsState.totalChunks > 0) ...[
                  // Current section indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: 20,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Section ${ttsState.currentChunk}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' of ${ttsState.totalChunks}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Progress bar with seek capability
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 6,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 8,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 16,
                            ),
                          ),
                          child: Slider(
                            value: ttsState.currentChunk.toDouble(),
                            min: 1,
                            max: ttsState.totalChunks.toDouble(),
                            divisions: ttsState.totalChunks > 1
                                ? ttsState.totalChunks - 1
                                : 1,
                            label: 'Section ${ttsState.currentChunk}',
                            onChanged: (value) {
                              ref.read(ttsProvider.notifier).seekToChunk(value.toInt());
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Start',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              'End',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],

                // Control buttons row - chunk-based navigation
                // Note: TTS doesn't support time-based seeking, only chunk-based
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Previous section
                    IconButton(
                      icon: const Icon(Icons.skip_previous),
                      iconSize: 36,
                      onPressed: ttsState.currentChunk > 1
                          ? () => ref.read(ttsProvider.notifier).previousChunk()
                          : null,
                      tooltip: l10n.previous,
                    ),

                    // Restart current section
                    IconButton(
                      icon: const Icon(Icons.replay),
                      iconSize: 36,
                      onPressed: ttsState.isPlaying || ttsState.currentText != null
                          ? () => ref.read(ttsProvider.notifier).rewind()
                          : null,
                      tooltip: l10n.rewind,
                    ),

                    // Next section
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      iconSize: 36,
                      onPressed: ttsState.currentChunk < ttsState.totalChunks
                          ? () => ref.read(ttsProvider.notifier).nextChunk()
                          : null,
                      tooltip: l10n.next,
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // Speed control
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.speed,
                              size: 20,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.playbackSpeed,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const Spacer(),
                            Text(
                              _getSpeechRateLabel(ttsState.speechRate, l10n),
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
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
                      ],
                    ),
                  ),
                ),

                // Error message
                if (ttsState.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            ttsState.errorMessage!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
        ),
      ),
    );
  }

  Future<Map<String, String>> _getChapterInfo(WidgetRef ref) async {
    final repository = ref.read(bookRepositoryProvider);
    final book = await repository.getBookById(widget.bookId);
    final chapter = await repository.getChapterById(widget.chapterId);
    
    return {
      'bookTitle': book?.title ?? '',
      'chapterTitle': chapter?.title ?? '',
    };
  }

  String _getSpeechRateLabel(double rate, AppLocalizations l10n) {
    if (rate < 0.4) return l10n.slow;
    if (rate > 0.6) return l10n.fast;
    return l10n.normal;
  }
}
