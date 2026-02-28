import 'package:read_forge/main.dart' as main_app;
import 'package:read_forge/features/reader/services/tts_audio_handler.dart';

/// Abstraction for Text-to-Speech functionality to enable testing.
///
/// Progress is tracked at two granularities:
/// - **Chunk-level**: Which section (1..N) is currently being spoken
/// - **Character-level**: Exact character offset within the full text,
///   updated word-by-word via flutter_tts's progress handler
///
/// This enables smooth progress bars, estimated time tracking,
/// and word highlighting in the reader view.
abstract class TtsServiceBase {
  Function()? onComplete;
  Function()? onStart;
  Function()? onPause;
  Function()? onContinue;
  Function(String)? onError;
  Function(int current, int total)? onChunkProgress;
  Function(int globalCharOffset, int totalChars, String currentWord)?
  onWordProgress;

  double get speechRate;
  bool get isPlaying;
  bool get isPaused;
  int get currentChunk;
  int get totalChunks;
  int get currentCharOffset;
  int get totalCharacters;
  String get currentWord;
  Duration get estimatedDuration;
  Duration get estimatedPosition;

  Future<void> initialize();
  Future<void> speak(
    String text, {
    String? bookTitle,
    String? chapterTitle,
    String? language,
  });
  Future<void> pause();
  Future<void> resume();
  Future<void> stop();
  Future<void> setSpeechRate(double rate);
  Future<void> setLanguage(String language);
  Future<void> seekToChunk(int chunkIndex);
  Future<void> previousChunk();
  Future<void> nextChunk();
  void dispose();
}

/// Service for Text-to-Speech functionality.
///
/// This is a thin wrapper around TtsAudioHandler that:
/// - Manages initialization of the audio service
/// - Wires callbacks from the audio handler to the provider layer
/// - Delegates all actual TTS operations to the audio handler
///
/// Text chunking is handled entirely by TtsAudioHandler (no duplicate chunking).
class TtsService implements TtsServiceBase {
  TtsAudioHandler get _audioHandler {
    // Lazy initialization of audio service
    main_app.initAudioService();
    return main_app.audioHandler as TtsAudioHandler;
  }

  bool _isPlaying = false;
  bool _isPaused = false;
  double _speechRate = 0.5; // Default rate (0.0 - 1.0)

  // Callbacks
  @override
  Function()? onComplete;
  @override
  Function()? onStart;
  @override
  Function()? onPause;
  @override
  Function()? onContinue;
  @override
  Function(String)? onError;
  @override
  Function(int current, int total)? onChunkProgress;
  @override
  Function(int globalCharOffset, int totalChars, String currentWord)?
  onWordProgress;

  /// Initialize TTS service
  @override
  Future<void> initialize() async {
    // Ensure audio service is initialized
    await main_app.initAudioService();

    // Setup callbacks from audio handler
    _audioHandler.onComplete = () {
      _isPlaying = false;
      _isPaused = false;
      onComplete?.call();
    };

    _audioHandler.onChunkProgress = (current, total) {
      onChunkProgress?.call(current, total);
    };

    _audioHandler.onWordProgress = (globalOffset, totalChars, word) {
      onWordProgress?.call(globalOffset, totalChars, word);
    };

    _audioHandler.onPauseCallback = () {
      _isPlaying = false;
      _isPaused = true;
      onPause?.call();
    };

    _audioHandler.onResumeCallback = () {
      _isPlaying = true;
      _isPaused = false;
      onContinue?.call();
    };
  }

  /// Speak the given text. Chunking is handled by TtsAudioHandler.
  @override
  Future<void> speak(
    String text, {
    String? bookTitle,
    String? chapterTitle,
    String? language,
  }) async {
    await initialize();

    try {
      final sanitizedText = text.trim();
      if (sanitizedText.isEmpty) {
        throw Exception('No readable text found for text-to-speech.');
      }

      _isPlaying = true;
      _isPaused = false;
      onStart?.call();

      // Delegate directly to audio handler - no duplicate chunking
      await _audioHandler.speakText(
        sanitizedText,
        title: chapterTitle ?? 'Text-to-Speech',
        album: bookTitle ?? 'ReadForge',
        language: language,
      );
    } catch (e) {
      _isPlaying = false;
      _isPaused = false;
      throw Exception('Failed to speak: $e');
    }
  }

  /// Pause speaking (preserves position for resume)
  @override
  Future<void> pause() async {
    try {
      await _audioHandler.pause();
      // State updated via callback
    } catch (e) {
      throw Exception('Failed to pause: $e');
    }
  }

  /// Resume speaking from where it was paused
  @override
  Future<void> resume() async {
    try {
      await _audioHandler.play();
      _isPlaying = true;
      _isPaused = false;
      onContinue?.call();
    } catch (e) {
      throw Exception('Failed to resume: $e');
    }
  }

  /// Stop speaking (clears all state)
  @override
  Future<void> stop() async {
    try {
      await _audioHandler.stop();
      _isPlaying = false;
      _isPaused = false;
    } catch (e) {
      throw Exception('Failed to stop: $e');
    }
  }

  /// Set speech rate (0.0 - 1.0, where 0.5 is normal)
  @override
  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate.clamp(0.0, 1.0);
    await _audioHandler.setSpeed(_speechRate);
  }

  /// Set the TTS language (e.g., 'en-US', 'es-ES', 'zh-CN')
  @override
  Future<void> setLanguage(String language) async {
    await _audioHandler.setLanguage(language);
  }

  /// Get current speech rate
  @override
  double get speechRate => _speechRate;

  /// Check if currently playing
  @override
  bool get isPlaying => _isPlaying;

  /// Check if currently paused (can resume)
  @override
  bool get isPaused => _isPaused;

  /// Get current chunk index (1-based for display)
  @override
  int get currentChunk => _audioHandler.currentChunk;

  /// Get total number of chunks
  @override
  int get totalChunks => _audioHandler.totalChunks;

  /// Get current global character offset
  @override
  int get currentCharOffset => _audioHandler.currentCharOffset;

  /// Get total character count
  @override
  int get totalCharacters => _audioHandler.totalCharacters;

  /// Get the word currently being spoken
  @override
  String get currentWord => _audioHandler.currentWord;

  /// Get estimated total duration
  @override
  Duration get estimatedDuration => _audioHandler.estimatedDuration;

  /// Get estimated current position
  @override
  Duration get estimatedPosition => _audioHandler.estimatedPosition;

  /// Seek to specific chunk (0-indexed)
  @override
  Future<void> seekToChunk(int chunkIndex) async {
    if (chunkIndex < 0 || chunkIndex >= _audioHandler.totalChunks) return;

    try {
      await _audioHandler.seekToChunk(chunkIndex);
      _isPlaying = true;
      _isPaused = false;
    } catch (e) {
      throw Exception('Failed to seek: $e');
    }
  }

  /// Go to previous chunk
  @override
  Future<void> previousChunk() async {
    try {
      await _audioHandler.skipToPrevious();
      _isPlaying = true;
      _isPaused = false;
    } catch (e) {
      throw Exception('Failed to go to previous chunk: $e');
    }
  }

  /// Go to next chunk
  @override
  Future<void> nextChunk() async {
    if (_audioHandler.currentChunk >= _audioHandler.totalChunks) return;

    try {
      await _audioHandler.skipToNext();
      _isPlaying = true;
      _isPaused = false;
    } catch (e) {
      throw Exception('Failed to go to next chunk: $e');
    }
  }

  /// Dispose resources
  @override
  void dispose() {
    _audioHandler.stop();
  }
}
