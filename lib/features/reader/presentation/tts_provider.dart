import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_forge/features/reader/services/tts_service.dart';

/// TTS state
class TtsState {
  final bool isPlaying;
  final bool isInitialized;
  final double speechRate;
  final String? errorMessage;
  final String? currentText;

  const TtsState({
    this.isPlaying = false,
    this.isInitialized = false,
    this.speechRate = 0.5,
    this.errorMessage,
    this.currentText,
  });

  TtsState copyWith({
    bool? isPlaying,
    bool? isInitialized,
    double? speechRate,
    String? errorMessage,
    String? currentText,
  }) {
    return TtsState(
      isPlaying: isPlaying ?? this.isPlaying,
      isInitialized: isInitialized ?? this.isInitialized,
      speechRate: speechRate ?? this.speechRate,
      errorMessage: errorMessage,
      currentText: currentText ?? this.currentText,
    );
  }
}

/// TTS state notifier
class TtsNotifier extends Notifier<TtsState> {
  late final TtsService _ttsService;

  @override
  TtsState build() {
    _ttsService = TtsService();
    _setupCallbacks();
    return const TtsState();
  }

  void _setupCallbacks() {
    _ttsService.onStart = () {
      state = state.copyWith(isPlaying: true, errorMessage: null);
    };

    _ttsService.onComplete = () {
      state = state.copyWith(isPlaying: false);
    };

    _ttsService.onPause = () {
      state = state.copyWith(isPlaying: false);
    };

    _ttsService.onContinue = () {
      state = state.copyWith(isPlaying: true);
    };

    _ttsService.onError = (msg) {
      state = state.copyWith(isPlaying: false, errorMessage: msg);
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
      state = state.copyWith(
        isPlaying: false,
        errorMessage: e.toString(),
      );
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
      state = state.copyWith(isPlaying: false, currentText: null);
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
}

/// TTS provider
final ttsProvider = NotifierProvider<TtsNotifier, TtsState>(() {
  return TtsNotifier();
});
