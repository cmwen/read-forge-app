import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_forge/features/reader/services/tts_service.dart';

/// Provider to allow injecting a custom TTS service (e.g., in tests)
final ttsServiceProvider = Provider<TtsServiceBase>((ref) => TtsService());

/// TTS state with real-time progress tracking
class TtsState {
  final bool isPlaying;
  final bool isPaused;
  final bool isInitialized;
  final double speechRate;
  final String? errorMessage;
  final String? currentText;
  final int currentChunk;
  final int totalChunks;

  // Real-time character-level progress
  final int currentCharOffset;
  final int totalCharacters;
  final String currentWord;

  // Time estimation
  final Duration estimatedDuration;
  final Duration estimatedPosition;

  const TtsState({
    this.isPlaying = false,
    this.isPaused = false,
    this.isInitialized = false,
    this.speechRate = 0.5,
    this.errorMessage,
    this.currentText,
    this.currentChunk = 0,
    this.totalChunks = 0,
    this.currentCharOffset = 0,
    this.totalCharacters = 0,
    this.currentWord = '',
    this.estimatedDuration = Duration.zero,
    this.estimatedPosition = Duration.zero,
  });

  /// Progress as a value between 0.0 and 1.0
  double get progress {
    if (totalCharacters == 0) return 0.0;
    return (currentCharOffset / totalCharacters).clamp(0.0, 1.0);
  }

  /// Remaining time estimate
  Duration get estimatedRemaining {
    if (estimatedDuration == Duration.zero) return Duration.zero;
    final remaining = estimatedDuration - estimatedPosition;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  TtsState copyWith({
    bool? isPlaying,
    bool? isPaused,
    bool? isInitialized,
    double? speechRate,
    String? errorMessage,
    String? currentText,
    int? currentChunk,
    int? totalChunks,
    int? currentCharOffset,
    int? totalCharacters,
    String? currentWord,
    Duration? estimatedDuration,
    Duration? estimatedPosition,
    bool clearCurrentText = false,
    bool clearError = false,
  }) {
    return TtsState(
      isPlaying: isPlaying ?? this.isPlaying,
      isPaused: isPaused ?? this.isPaused,
      isInitialized: isInitialized ?? this.isInitialized,
      speechRate: speechRate ?? this.speechRate,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      currentText: clearCurrentText ? null : currentText ?? this.currentText,
      currentChunk: currentChunk ?? this.currentChunk,
      totalChunks: totalChunks ?? this.totalChunks,
      currentCharOffset: currentCharOffset ?? this.currentCharOffset,
      totalCharacters: totalCharacters ?? this.totalCharacters,
      currentWord: currentWord ?? this.currentWord,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      estimatedPosition: estimatedPosition ?? this.estimatedPosition,
    );
  }
}

/// TTS state notifier - manages TTS lifecycle and state
class TtsNotifier extends Notifier<TtsState> {
  late final TtsServiceBase _ttsService;

  @override
  TtsState build() {
    _ttsService = ref.read(ttsServiceProvider);
    ref.onDispose(_ttsService.dispose);
    _setupCallbacks();
    return const TtsState();
  }

  void _setupCallbacks() {
    _ttsService.onStart = () {
      state = state.copyWith(
        isPlaying: true,
        isPaused: false,
        clearError: true,
      );
    };

    _ttsService.onComplete = () {
      state = state.copyWith(
        isPlaying: false,
        isPaused: false,
        currentChunk: 0,
        totalChunks: 0,
        currentCharOffset: 0,
        totalCharacters: 0,
        currentWord: '',
        estimatedPosition: Duration.zero,
        estimatedDuration: Duration.zero,
      );
    };

    _ttsService.onPause = () {
      state = state.copyWith(isPlaying: false, isPaused: true);
    };

    _ttsService.onContinue = () {
      state = state.copyWith(isPlaying: true, isPaused: false);
    };

    _ttsService.onError = (msg) {
      state = state.copyWith(
        isPlaying: false,
        isPaused: false,
        errorMessage: msg,
        currentChunk: 0,
        totalChunks: 0,
      );
    };

    _ttsService.onChunkProgress = (current, total) {
      state = state.copyWith(currentChunk: current, totalChunks: total);
    };

    _ttsService.onWordProgress = (globalCharOffset, totalChars, word) {
      state = state.copyWith(
        currentCharOffset: globalCharOffset,
        totalCharacters: totalChars,
        currentWord: word,
        estimatedDuration: _ttsService.estimatedDuration,
        estimatedPosition: _ttsService.estimatedPosition,
      );
    };
  }

  /// Initialize TTS
  Future<void> initialize() async {
    try {
      await _ttsService.initialize();
      state = state.copyWith(
        isInitialized: true,
        speechRate: _ttsService.speechRate,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Speak text - stops any existing playback first (singleton enforcement)
  Future<void> speak(
    String text, {
    String? bookTitle,
    String? chapterTitle,
    String? language,
  }) async {
    try {
      if (!state.isInitialized) {
        await initialize();
      }
      state = state.copyWith(currentText: text, clearError: true);
      await _ttsService.speak(
        text,
        bookTitle: bookTitle,
        chapterTitle: chapterTitle,
        language: language,
      );
    } catch (e) {
      state = state.copyWith(isPlaying: false, errorMessage: e.toString());
    }
  }

  /// Pause speaking (preserves position)
  Future<void> pause() async {
    try {
      await _ttsService.pause();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Stop speaking (clears all state)
  Future<void> stop() async {
    try {
      await _ttsService.stop();
      state = state.copyWith(
        isPlaying: false,
        isPaused: false,
        clearCurrentText: true,
        currentChunk: 0,
        totalChunks: 0,
        currentCharOffset: 0,
        totalCharacters: 0,
        currentWord: '',
        estimatedPosition: Duration.zero,
        estimatedDuration: Duration.zero,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Resume from pause (does NOT restart from beginning)
  Future<void> resume() async {
    try {
      if (state.isPaused) {
        // True resume from pause point
        await _ttsService.resume();
      } else if (state.currentText != null) {
        // If stopped (not paused), restart from beginning
        await _ttsService.speak(state.currentText!);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Rewind: restart current chunk from beginning
  Future<void> rewind() async {
    try {
      if (state.currentChunk > 0) {
        // Seek to beginning of current chunk
        await _ttsService.seekToChunk(state.currentChunk - 1);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Forward: skip to next chunk
  Future<void> forward() async {
    try {
      await _ttsService.nextChunk();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Set speech rate (applies immediately, restarts playback if needed)
  Future<void> setSpeechRate(double rate) async {
    try {
      final wasPlaying = state.isPlaying;
      await _ttsService.setSpeechRate(rate);
      state = state.copyWith(
        speechRate: rate,
        isPlaying: wasPlaying,
        estimatedDuration: _ttsService.estimatedDuration,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Set TTS language
  Future<void> setLanguage(String language) async {
    try {
      await _ttsService.setLanguage(language);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Seek to specific chunk (1-indexed from UI)
  Future<void> seekToChunk(int chunkIndex) async {
    try {
      await _ttsService.seekToChunk(chunkIndex - 1); // Convert to 0-indexed
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Go to previous chunk
  Future<void> previousChunk() async {
    try {
      await _ttsService.previousChunk();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Go to next chunk
  Future<void> nextChunk() async {
    try {
      await _ttsService.nextChunk();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}

/// TTS provider
final ttsProvider = NotifierProvider<TtsNotifier, TtsState>(() {
  return TtsNotifier();
});

/// TTS context to track which book/chapter is currently being played
class TtsContext {
  final int? bookId;
  final int? chapterId;

  const TtsContext({this.bookId, this.chapterId});

  TtsContext copyWith({int? bookId, int? chapterId}) {
    return TtsContext(
      bookId: bookId ?? this.bookId,
      chapterId: chapterId ?? this.chapterId,
    );
  }
}

/// Notifier for TTS context
class TtsContextNotifier extends Notifier<TtsContext> {
  @override
  TtsContext build() => const TtsContext();

  void setContext(int bookId, int chapterId) {
    state = TtsContext(bookId: bookId, chapterId: chapterId);
  }

  void clear() {
    state = const TtsContext();
  }
}

/// Provider for TTS context
final ttsContextProvider = NotifierProvider<TtsContextNotifier, TtsContext>(
  TtsContextNotifier.new,
);
