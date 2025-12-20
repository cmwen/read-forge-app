import 'package:read_forge/main.dart' as main_app;
import 'package:read_forge/features/reader/services/tts_audio_handler.dart';

/// Abstraction for Text-to-Speech functionality to enable testing
///
/// **TTS Time Tracking Limitations:**
/// Flutter TTS does not provide real-time playback position tracking.
/// It only provides callbacks for start, complete, pause, and error events.
/// Therefore, this implementation uses chunk-based progress tracking instead
/// of time-based tracking. Each "chunk" represents a section of text being spoken.
///
/// This means:
/// - Progress is tracked by chunks (sections) not by time/position
/// - Rewind/Forward operations skip between chunks, not by seconds
/// - Seek operations jump to specific chunks, not time positions
///
/// For apps requiring precise time-based tracking, consider using
/// just_audio with pre-recorded TTS audio files instead of live TTS.
abstract class TtsServiceBase {
  Function()? onComplete;
  Function()? onStart;
  Function()? onPause;
  Function()? onContinue;
  Function(String)? onError;
  Function(int current, int total)? onProgress;

  double get speechRate;
  bool get isPlaying;
  int get currentChunk;
  int get totalChunks;

  Future<void> initialize();
  Future<void> speak(String text, {String? bookTitle, String? chapterTitle});
  Future<void> pause();
  Future<void> stop();
  Future<void> setSpeechRate(double rate);
  Future<void> seekToChunk(int chunkIndex);
  Future<void> previousChunk();
  Future<void> nextChunk();
  void dispose();
}

/// Service for Text-to-Speech functionality
class TtsService implements TtsServiceBase {
  TtsAudioHandler get _audioHandler {
    // Lazy initialization of audio service
    main_app.initAudioService();
    return main_app.audioHandler as TtsAudioHandler;
  }

  bool _isPlaying = false;
  double _speechRate = 0.5; // Default rate (0.0 - 1.0)

  // Text chunking for long content
  static const int _maxChunkLength = 4000; // Android TTS character limit
  List<String> _textChunks = [];

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
  Function(int current, int total)? onProgress;

  /// Initialize TTS service
  @override
  Future<void> initialize() async {
    // Ensure audio service is initialized
    await main_app.initAudioService();

    // Setup callbacks from audio handler
    _audioHandler.onComplete = () {
      _isPlaying = false;
      _textChunks.clear();
      onComplete?.call();
    };

    _audioHandler.onProgress = (current, total) {
      onProgress?.call(current, total);
    };
  }

  /// Speak the given text (automatically chunks long text)
  @override
  Future<void> speak(
    String text, {
    String? bookTitle,
    String? chapterTitle,
  }) async {
    await initialize();

    try {
      final sanitizedText = text.trim();
      if (sanitizedText.isEmpty) {
        throw Exception('No readable text found for text-to-speech.');
      }

      // Split text into chunks if needed
      _textChunks = _splitTextIntoChunks(sanitizedText);

      _isPlaying = true;
      onStart?.call();

      // Use audio handler for proper media integration
      final fullText = _textChunks.join(' ');
      await _audioHandler.speakText(
        fullText,
        title: chapterTitle ?? 'Text-to-Speech',
        album: bookTitle ?? 'ReadForge',
      );
    } catch (e) {
      throw Exception('Failed to speak: $e');
    }
  }

  /// Split text into manageable chunks for TTS
  List<String> _splitTextIntoChunks(String text) {
    if (text.length <= _maxChunkLength) {
      return [text];
    }

    final chunks = <String>[];
    var startIndex = 0;

    while (startIndex < text.length) {
      var endIndex = startIndex + _maxChunkLength;

      // If this is not the last chunk, try to break at a sentence boundary
      if (endIndex < text.length) {
        // Look for sentence endings: period, exclamation, question mark
        final sentenceEnd = text.lastIndexOf(RegExp(r'[.!?]\s'), endIndex);
        if (sentenceEnd > startIndex) {
          endIndex = sentenceEnd + 1;
        } else {
          // No sentence break found, try to break at word boundary
          final spaceIndex = text.lastIndexOf(' ', endIndex);
          if (spaceIndex > startIndex) {
            endIndex = spaceIndex;
          }
        }
      } else {
        endIndex = text.length;
      }

      chunks.add(text.substring(startIndex, endIndex).trim());
      startIndex = endIndex;
    }

    return chunks;
  }

  /// Pause speaking
  @override
  Future<void> pause() async {
    try {
      await _audioHandler.pause();
      _isPlaying = false;
      onPause?.call();
    } catch (e) {
      throw Exception('Failed to pause: $e');
    }
  }

  /// Stop speaking
  @override
  Future<void> stop() async {
    try {
      _textChunks.clear();
      await _audioHandler.stop();
      _isPlaying = false;
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

  /// Get current speech rate
  @override
  double get speechRate => _speechRate;

  /// Check if currently playing
  @override
  bool get isPlaying => _isPlaying;

  /// Get current chunk index (1-based for display)
  @override
  int get currentChunk => _audioHandler.currentChunk;

  /// Get total number of chunks
  @override
  int get totalChunks => _audioHandler.totalChunks;

  /// Seek to specific chunk
  @override
  Future<void> seekToChunk(int chunkIndex) async {
    if (chunkIndex < 0 || chunkIndex >= _audioHandler.totalChunks) return;

    try {
      await _audioHandler.seekToChunk(chunkIndex);
    } catch (e) {
      throw Exception('Failed to seek: $e');
    }
  }

  /// Go to previous chunk
  @override
  Future<void> previousChunk() async {
    if (_audioHandler.currentChunk <= 1) return;

    try {
      await _audioHandler.skipToPrevious();
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
