import 'package:flutter_tts/flutter_tts.dart';

/// Abstraction for Text-to-Speech functionality to enable testing
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
  Future<void> speak(String text);
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
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;
  bool _isPlaying = false;
  double _speechRate = 0.5; // Default rate (0.0 - 1.0)

  // Text chunking for long content
  static const int _maxChunkLength = 4000; // Android TTS character limit
  List<String> _textChunks = [];
  int _currentChunkIndex = 0;
  bool _isStopped = false;

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
    if (_isInitialized) return;

    try {
      await _flutterTts.awaitSpeakCompletion(true);

      await _configureLanguage();

      // Configure TTS for Android
      await _flutterTts.setSpeechRate(_speechRate);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      // Enable background audio (allows screen to be turned off)
      await _flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
        ],
        IosTextToSpeechAudioMode.voicePrompt,
      );

      // Set up handlers
      _flutterTts.setStartHandler(() {
        _isPlaying = true;
        // Only call onStart for the first chunk
        if (_currentChunkIndex == 0) {
          onStart?.call();
        }
      });

      _flutterTts.setCompletionHandler(() async {
        // Move to next chunk if available
        if (!_isStopped && _currentChunkIndex < _textChunks.length - 1) {
          _currentChunkIndex++;
          await _speakCurrentChunk();
        } else {
          // All chunks completed
          _isPlaying = false;
          _textChunks.clear();
          _currentChunkIndex = 0;
          onComplete?.call();
        }
      });

      _flutterTts.setPauseHandler(() {
        _isPlaying = false;
        onPause?.call();
      });

      _flutterTts.setContinueHandler(() {
        _isPlaying = true;
        onContinue?.call();
      });

      _flutterTts.setErrorHandler((msg) {
        _isPlaying = false;
        _textChunks.clear();
        _currentChunkIndex = 0;
        onError?.call(msg);
      });

      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize TTS: $e');
    }
  }

  /// Speak the given text (automatically chunks long text)
  @override
  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final sanitizedText = text.trim();
      if (sanitizedText.isEmpty) {
        throw Exception('No readable text found for text-to-speech.');
      }

      // Split text into chunks if needed
      _textChunks = _splitTextIntoChunks(sanitizedText);
      _currentChunkIndex = 0;
      _isStopped = false;

      // Start speaking the first chunk
      await _speakCurrentChunk();
    } catch (e) {
      throw Exception('Failed to speak: $e');
    }
  }

  /// Speak the current chunk
  Future<void> _speakCurrentChunk() async {
    if (_currentChunkIndex < _textChunks.length) {
      // Report progress
      onProgress?.call(_currentChunkIndex + 1, _textChunks.length);
      await _flutterTts.speak(_textChunks[_currentChunkIndex]);
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
    if (!_isInitialized) return;

    try {
      await _flutterTts.pause();
      _isPlaying = false;
    } catch (e) {
      throw Exception('Failed to pause: $e');
    }
  }

  /// Stop speaking
  @override
  Future<void> stop() async {
    if (!_isInitialized) return;

    try {
      _isStopped = true;
      _textChunks.clear();
      _currentChunkIndex = 0;
      await _flutterTts.stop();
      _isPlaying = false;
    } catch (e) {
      throw Exception('Failed to stop: $e');
    }
  }

  /// Set speech rate (0.0 - 1.0, where 0.5 is normal)
  @override
  Future<void> setSpeechRate(double rate) async {
    if (!_isInitialized) {
      await initialize();
    }

    _speechRate = rate.clamp(0.0, 1.0);
    await _flutterTts.setSpeechRate(_speechRate);
  }

  /// Get current speech rate
  @override
  double get speechRate => _speechRate;

  /// Check if currently playing
  @override
  bool get isPlaying => _isPlaying;

  /// Get current chunk index (1-based for display)
  @override
  int get currentChunk => _currentChunkIndex + 1;

  /// Get total number of chunks
  @override
  int get totalChunks => _textChunks.length;

  /// Get available languages
  Future<List<dynamic>> getLanguages() async {
    if (!_isInitialized) {
      await initialize();
    }
    return await _flutterTts.getLanguages;
  }

  /// Set language
  Future<void> setLanguage(String language) async {
    if (!_isInitialized) {
      await initialize();
    }
    await _flutterTts.setLanguage(language);
  }

  /// Get available voices
  Future<List<dynamic>> getVoices() async {
    if (!_isInitialized) {
      await initialize();
    }
    return await _flutterTts.getVoices;
  }

  Future<void> _configureLanguage() async {
    final languages = await _flutterTts.getLanguages;
    if (languages == null) return;

    const preferredLanguages = ['en-US', 'en_US'];
    String? selectedLanguage;

    for (final preferred in preferredLanguages) {
      if (languages.contains(preferred)) {
        selectedLanguage = preferred;
        break;
      }
    }

    selectedLanguage ??= languages.isNotEmpty
        ? languages.first.toString()
        : null;

    if (selectedLanguage == null) return;

    final availability = await _flutterTts.isLanguageAvailable(
      selectedLanguage,
    );
    final isAvailable =
        availability == true || availability == 1 || availability == "1";

    if (isAvailable) {
      await _flutterTts.setLanguage(selectedLanguage);
    }
  }

  /// Seek to specific chunk
  @override
  Future<void> seekToChunk(int chunkIndex) async {
    if (!_isInitialized) return;
    if (chunkIndex < 0 || chunkIndex >= _textChunks.length) return;

    try {
      await _flutterTts.stop();
      _currentChunkIndex = chunkIndex;
      await _speakCurrentChunk();
    } catch (e) {
      throw Exception('Failed to seek: $e');
    }
  }

  /// Go to previous chunk
  @override
  Future<void> previousChunk() async {
    if (!_isInitialized) return;
    if (_currentChunkIndex <= 0) return;

    try {
      await _flutterTts.stop();
      _currentChunkIndex--;
      await _speakCurrentChunk();
    } catch (e) {
      throw Exception('Failed to go to previous chunk: $e');
    }
  }

  /// Go to next chunk
  @override
  Future<void> nextChunk() async {
    if (!_isInitialized) return;
    if (_currentChunkIndex >= _textChunks.length - 1) return;

    try {
      await _flutterTts.stop();
      _currentChunkIndex++;
      await _speakCurrentChunk();
    } catch (e) {
      throw Exception('Failed to go to next chunk: $e');
    }
  }

  /// Dispose resources
  @override
  void dispose() {
    _flutterTts.stop();
  }
}
