import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Audio handler for TTS integration with Android media controls.
///
/// This is the core engine that manages FlutterTts and exposes it through
/// the audio_service BaseAudioHandler for media notification integration.
///
/// Key design decisions:
/// - Uses setProgressHandler for real-time word-level progress tracking
/// - Properly supports pause/resume without restarting from the beginning
/// - Tracks character-level position for accurate progress bars
/// - Provides estimated duration based on speech rate and character count
/// - Uses a Completer-based mutex to ensure only one speakText() runs at a time
class TtsAudioHandler extends BaseAudioHandler with SeekHandler {
  final FlutterTts _flutterTts = FlutterTts();

  // State management
  String? _currentText;
  List<String> _textChunks = [];
  int _currentChunkIndex = 0;
  double _speechRate = 0.5;
  bool _isStopped = false;
  bool _isPaused = false;
  bool _isInitialized = false;
  String? _language;

  // Mutex to prevent concurrent speakText calls
  Completer<void>? _speakLock;

  // Character-level progress tracking
  int _currentCharOffsetInChunk = 0;
  int _totalCharacters = 0;
  String _currentWord = '';

  // Pre-computed chunk offsets for global position calculation
  // _chunkStartOffsets[i] = sum of lengths of chunks 0..i-1
  List<int> _chunkStartOffsets = [];

  // Time estimation constants
  // At speechRate 0.5 (normal), ~14 chars/second for English TTS
  static const double _baseCharsPerSecond = 14.0;

  // Callbacks for state updates
  Function()? onComplete;
  Function(int current, int total)? onChunkProgress;
  Function(int globalCharOffset, int totalChars, String currentWord)?
  onWordProgress;
  Function()? onPauseCallback;
  Function()? onResumeCallback;

  TtsAudioHandler() {
    _init();
  }

  Future<void> _init() async {
    if (_isInitialized) return;

    // Configure TTS defaults
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(_speechRate);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.awaitSpeakCompletion(true);

    // Set up TTS handlers
    _flutterTts.setStartHandler(() {
      _isPaused = false;
      _updatePlaybackState(
        playing: true,
        processingState: AudioProcessingState.ready,
      );
    });

    _flutterTts.setCompletionHandler(() async {
      if (!_isStopped && _currentChunkIndex < _textChunks.length - 1) {
        // Advance to next chunk
        _currentChunkIndex++;
        _currentCharOffsetInChunk = 0;
        onChunkProgress?.call(_currentChunkIndex + 1, _textChunks.length);
        _updatePlaybackState(playing: true);
        await _speakCurrentChunk();
      } else if (!_isStopped) {
        // All chunks completed
        _updatePlaybackState(
          playing: false,
          processingState: AudioProcessingState.completed,
        );
        onComplete?.call();
      }
    });

    _flutterTts.setPauseHandler(() {
      _isPaused = true;
      _updatePlaybackState(playing: false);
      onPauseCallback?.call();
    });

    _flutterTts.setContinueHandler(() {
      _isPaused = false;
      _updatePlaybackState(playing: true);
      onResumeCallback?.call();
    });

    _flutterTts.setErrorHandler((msg) {
      _updatePlaybackState(
        playing: false,
        processingState: AudioProcessingState.error,
      );
    });

    // Word-level progress tracking
    _flutterTts.setProgressHandler((
      String text,
      int startOffset,
      int endOffset,
      String word,
    ) {
      _currentCharOffsetInChunk = startOffset;
      _currentWord = word;

      // Calculate global character offset
      final globalOffset = _getGlobalCharOffset();
      onWordProgress?.call(globalOffset, _totalCharacters, word);

      // Update notification position
      _updatePlaybackState(playing: true);
    });

    // Initialize playback state
    _updatePlaybackState(
      playing: false,
      processingState: AudioProcessingState.idle,
    );

    _isInitialized = true;
  }

  /// Calculate the global character offset across all chunks
  int _getGlobalCharOffset() {
    if (_currentChunkIndex >= _chunkStartOffsets.length) return 0;
    return _chunkStartOffsets[_currentChunkIndex] + _currentCharOffsetInChunk;
  }

  /// Estimate duration based on character count and speech rate
  Duration _estimateDuration() {
    if (_totalCharacters == 0) return Duration.zero;
    // Speech rate 0.0 = very slow, 0.5 = normal, 1.0 = very fast
    // Scale chars/second: at 0.0 -> ~5 cps, at 0.5 -> ~14 cps, at 1.0 -> ~28 cps
    final charsPerSecond = _baseCharsPerSecond * (_speechRate + 0.5);
    final seconds = _totalCharacters / charsPerSecond;
    return Duration(seconds: seconds.round());
  }

  /// Estimate current position based on global character offset
  Duration _estimatePosition() {
    if (_totalCharacters == 0) return Duration.zero;
    final globalOffset = _getGlobalCharOffset();
    final progress = globalOffset / _totalCharacters;
    final totalDuration = _estimateDuration();
    return Duration(
      milliseconds: (totalDuration.inMilliseconds * progress).round(),
    );
  }

  void _updatePlaybackState({
    bool? playing,
    AudioProcessingState? processingState,
  }) {
    final isPlaying = playing ?? playbackState.value.playing;

    playbackState.add(
      playbackState.value.copyWith(
        playing: isPlaying,
        processingState: processingState ?? playbackState.value.processingState,
        controls: [
          if (isPlaying) ...[
            MediaControl.pause,
            MediaControl.skipToPrevious,
            MediaControl.skipToNext,
            MediaControl.stop,
          ] else ...[
            MediaControl.play,
            MediaControl.skipToPrevious,
            MediaControl.skipToNext,
            MediaControl.stop,
          ],
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 2],
        speed: _speechRate * 2, // Convert 0.0-1.0 to display multiplier
        updatePosition: _estimatePosition(),
      ),
    );
  }

  Future<void> _speakCurrentChunk() async {
    if (_currentChunkIndex < _textChunks.length) {
      await _flutterTts.speak(_textChunks[_currentChunkIndex]);
    }
  }

  List<String> _splitIntoChunks(String text) {
    const maxLength = 4000;
    final chunks = <String>[];

    if (text.length <= maxLength) {
      return [text];
    }

    final sentences = text.split(RegExp(r'[.!?]\s+'));
    String currentChunk = '';

    for (final sentence in sentences) {
      if ((currentChunk + sentence).length <= maxLength) {
        currentChunk += '$sentence. ';
      } else {
        if (currentChunk.isNotEmpty) {
          chunks.add(currentChunk.trim());
        }
        currentChunk = '$sentence. ';
      }
    }

    if (currentChunk.isNotEmpty) {
      chunks.add(currentChunk.trim());
    }

    return chunks.isEmpty ? [text] : chunks;
  }

  /// Precompute chunk start offsets for O(1) global position lookup
  void _computeChunkOffsets() {
    _chunkStartOffsets = List<int>.filled(_textChunks.length, 0);
    int offset = 0;
    for (int i = 0; i < _textChunks.length; i++) {
      _chunkStartOffsets[i] = offset;
      offset += _textChunks[i].length;
    }
    _totalCharacters = offset;
  }

  /// Start speaking new text. Stops any existing playback first.
  /// Uses a mutex to prevent concurrent calls from overlapping.
  Future<void> speakText(
    String text, {
    String? title,
    String? album,
    String? language,
  }) async {
    // Mutex: wait for any in-progress speakText to finish stopping.
    // Use a local variable to hold this invocation's own Completer so
    // the finally block always completes the correct future, even when
    // multiple callers race past the guard and each creates a new lock.
    if (_speakLock != null && !_speakLock!.isCompleted) {
      await _speakLock!.future;
    }
    final lock = Completer<void>();
    _speakLock = lock;

    try {
      if (!_isInitialized) await _init();

      // Stop any existing playback first
      await _stopInternal();

      // Set language if provided
      if (language != null && language != _language) {
        _language = language;
        await _flutterTts.setLanguage(language);
      }

      _currentText = text;
      _textChunks = _splitIntoChunks(text);
      _computeChunkOffsets();
      _currentChunkIndex = 0;
      _currentCharOffsetInChunk = 0;
      _currentWord = '';
      _isStopped = false;
      _isPaused = false;

      // Update media item for notification
      final estimatedDuration = _estimateDuration();
      final newMediaItem = MediaItem(
        id: 'tts_${DateTime.now().millisecondsSinceEpoch}',
        album: album ?? 'ReadForge',
        title: title ?? 'Text-to-Speech',
        artist: 'Text-to-Speech',
        duration: estimatedDuration,
        artUri: null,
        displayTitle: title,
        displaySubtitle: album,
      );
      mediaItem.add(newMediaItem);

      // Set initial playback state
      _updatePlaybackState(
        playing: true,
        processingState: AudioProcessingState.ready,
      );

      onChunkProgress?.call(1, _textChunks.length);

      // Start speaking
      await _speakCurrentChunk();
    } finally {
      lock.complete();
    }
  }

  /// Internal stop without mutex (used by speakText to avoid deadlock)
  Future<void> _stopInternal() async {
    _isStopped = true;
    _isPaused = false;
    await _flutterTts.stop();
    _currentText = null;
    _textChunks.clear();
    _chunkStartOffsets.clear();
    _currentChunkIndex = 0;
    _currentCharOffsetInChunk = 0;
    _totalCharacters = 0;
    _currentWord = '';

    _updatePlaybackState(
      playing: false,
      processingState: AudioProcessingState.idle,
    );
  }

  @override
  Future<void> play() async {
    if (_isPaused && _currentText != null) {
      // Resume from where we paused - flutter_tts handles this internally
      // on Android SDK >= 26 by re-creating text from the pause point
      await _speakCurrentChunk();
    } else if (_currentText != null && _textChunks.isNotEmpty) {
      // Restart current chunk from beginning
      _currentCharOffsetInChunk = 0;
      await _speakCurrentChunk();
    }
  }

  @override
  Future<void> pause() async {
    await _flutterTts.pause();
    // _isPaused is set in the pause handler callback
  }

  @override
  Future<void> stop() async {
    await _stopInternal();
  }

  @override
  Future<void> skipToPrevious() async {
    if (_currentChunkIndex > 0) {
      await _flutterTts.stop();
      _currentChunkIndex--;
      _currentCharOffsetInChunk = 0;
      _isPaused = false;
      onChunkProgress?.call(_currentChunkIndex + 1, _textChunks.length);
      _updatePlaybackState(playing: true);
      await _speakCurrentChunk();
    } else {
      // Already at first chunk - restart it
      await _flutterTts.stop();
      _currentCharOffsetInChunk = 0;
      _isPaused = false;
      _updatePlaybackState(playing: true);
      await _speakCurrentChunk();
    }
  }

  @override
  Future<void> skipToNext() async {
    if (_currentChunkIndex < _textChunks.length - 1) {
      await _flutterTts.stop();
      _currentChunkIndex++;
      _currentCharOffsetInChunk = 0;
      _isPaused = false;
      onChunkProgress?.call(_currentChunkIndex + 1, _textChunks.length);
      _updatePlaybackState(playing: true);
      await _speakCurrentChunk();
    }
  }

  /// Seek to a specific chunk (0-indexed)
  Future<void> seekToChunk(int chunkIndex) async {
    if (chunkIndex < 0 || chunkIndex >= _textChunks.length) return;

    await _flutterTts.stop();
    _currentChunkIndex = chunkIndex;
    _currentCharOffsetInChunk = 0;
    _isPaused = false;
    onChunkProgress?.call(_currentChunkIndex + 1, _textChunks.length);
    _updatePlaybackState(playing: true);
    await _speakCurrentChunk();
  }

  /// Seek to a global character position (for notification seek bar)
  @override
  Future<void> seek(Duration position) async {
    if (_totalCharacters == 0) return;

    final totalDuration = _estimateDuration();
    if (totalDuration.inMilliseconds == 0) return;

    // Convert duration position to character position
    final progress = position.inMilliseconds / totalDuration.inMilliseconds;
    final targetCharOffset = (progress * _totalCharacters).round().clamp(
      0,
      _totalCharacters - 1,
    );

    // Find which chunk this falls into
    int targetChunk = 0;
    for (int i = _chunkStartOffsets.length - 1; i >= 0; i--) {
      if (targetCharOffset >= _chunkStartOffsets[i]) {
        targetChunk = i;
        break;
      }
    }

    await _flutterTts.stop();
    _currentChunkIndex = targetChunk;
    _currentCharOffsetInChunk = 0; // Start from beginning of target chunk
    _isPaused = false;
    onChunkProgress?.call(_currentChunkIndex + 1, _textChunks.length);
    _updatePlaybackState(playing: true);
    await _speakCurrentChunk();
  }

  @override
  Future<void> setSpeed(double speed) async {
    final wasPlaying = playbackState.value.playing;
    _speechRate = speed;
    await _flutterTts.setSpeechRate(_speechRate);

    // Update media item duration estimate with new speed
    if (_currentText != null) {
      final currentMediaItem = mediaItem.value;
      if (currentMediaItem != null) {
        mediaItem.add(currentMediaItem.copyWith(duration: _estimateDuration()));
      }
    }

    // If currently playing, restart current chunk to apply new speed
    if (wasPlaying && _textChunks.isNotEmpty) {
      await _flutterTts.stop();
      _isPaused = false;
      await _speakCurrentChunk();
    }

    _updatePlaybackState(playing: wasPlaying);
  }

  /// Set the TTS language
  Future<void> setLanguage(String language) async {
    if (language == _language) return;
    _language = language;
    await _flutterTts.setLanguage(language);
  }

  // Public getters
  int get currentChunk => _currentChunkIndex + 1; // 1-indexed for display
  int get totalChunks => _textChunks.length;
  double get speechRate => _speechRate;
  bool get isPaused => _isPaused;
  bool get isStopped => _isStopped;
  int get currentCharOffset => _getGlobalCharOffset();
  int get totalCharacters => _totalCharacters;
  String get currentWord => _currentWord;
  Duration get estimatedDuration => _estimateDuration();
  Duration get estimatedPosition => _estimatePosition();
  String? get language => _language;
}
