import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_forge/features/reader/services/tts_service.dart';

/// Provider to allow injecting a custom TTS service (e.g., in tests)
final ttsServiceProvider = Provider<TtsServiceBase>((ref) => TtsService());

/// TTS state
class TtsState {
  final bool isPlaying;
  final bool isInitialized;
  final double speechRate;
  final String? errorMessage;
  final String? currentText;
  final int currentChunk;
  final int totalChunks;

  const TtsState({
    this.isPlaying = false,
    this.isInitialized = false,
    this.speechRate = 0.5,
    this.errorMessage,
    this.currentText,
    this.currentChunk = 0,
    this.totalChunks = 0,
  });

  TtsState copyWith({
    bool? isPlaying,
    bool? isInitialized,
    double? speechRate,
    String? errorMessage,
    String? currentText,
    int? currentChunk,
    int? totalChunks,
    bool clearCurrentText = false,
  }) {
    return TtsState(
      isPlaying: isPlaying ?? this.isPlaying,
      isInitialized: isInitialized ?? this.isInitialized,
      speechRate: speechRate ?? this.speechRate,
      errorMessage: errorMessage,
      currentText: clearCurrentText ? null : currentText ?? this.currentText,
      currentChunk: currentChunk ?? this.currentChunk,
      totalChunks: totalChunks ?? this.totalChunks,
    );
  }
}

/// TTS state notifier
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
      state = state.copyWith(isPlaying: true, errorMessage: null);
    };

    _ttsService.onComplete = () {
      state = state.copyWith(isPlaying: false, currentChunk: 0, totalChunks: 0);
    };

    _ttsService.onPause = () {
      state = state.copyWith(isPlaying: false);
    };

    _ttsService.onContinue = () {
      state = state.copyWith(isPlaying: true);
    };

    _ttsService.onError = (msg) {
      state = state.copyWith(
        isPlaying: false,
        errorMessage: msg,
        currentChunk: 0,
        totalChunks: 0,
      );
    };

    _ttsService.onProgress = (current, total) {
      state = state.copyWith(currentChunk: current, totalChunks: total);
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

  /// Speak text
  Future<void> speak(String text) async {
    try {
      if (!state.isInitialized) {
        await initialize();
      }
      state = state.copyWith(currentText: text);
      await _ttsService.speak(text);
    } catch (e) {
      state = state.copyWith(isPlaying: false, errorMessage: e.toString());
    }
  }

  /// Pause speaking
  Future<void> pause() async {
    try {
      await _ttsService.pause();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Stop speaking
  Future<void> stop() async {
    try {
      await _ttsService.stop();
      state = state.copyWith(
        isPlaying: false,
        clearCurrentText: true,
        currentChunk: 0,
        totalChunks: 0,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Resume speaking
  Future<void> resume() async {
    try {
      if (state.currentText != null) {
        await _ttsService.speak(state.currentText!);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Rewind (restart from beginning for now)
  Future<void> rewind() async {
    try {
      await _ttsService.stop();
      if (state.currentText != null) {
        await _ttsService.speak(state.currentText!);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Forward (skip to end for now)
  Future<void> forward() async {
    try {
      await _ttsService.stop();
      state = state.copyWith(isPlaying: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Set speech rate
  Future<void> setSpeechRate(double rate) async {
    try {
      await _ttsService.setSpeechRate(rate);
      state = state.copyWith(speechRate: rate);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Seek to specific chunk
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
