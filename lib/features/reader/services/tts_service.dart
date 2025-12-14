import 'package:flutter_tts/flutter_tts.dart';

/// Abstraction for Text-to-Speech functionality to enable testing
abstract class TtsServiceBase {
  Function()? onComplete;
  Function()? onStart;
  Function()? onPause;
  Function()? onContinue;
  Function(String)? onError;

  double get speechRate;
  bool get isPlaying;

  Future<void> initialize();
  Future<void> speak(String text);
  Future<void> pause();
  Future<void> stop();
  Future<void> setSpeechRate(double rate);
  void dispose();
}

/// Service for Text-to-Speech functionality
class TtsService implements TtsServiceBase {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;
  bool _isPlaying = false;
  double _speechRate = 0.5; // Default rate (0.0 - 1.0)

  // Callbacks
  Function()? onComplete;
  Function()? onStart;
  Function()? onPause;
  Function()? onContinue;
  Function(String)? onError;

  /// Initialize TTS service
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
        onStart?.call();
      });

      _flutterTts.setCompletionHandler(() {
        _isPlaying = false;
        onComplete?.call();
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
        onError?.call(msg);
      });

      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize TTS: $e');
    }
  }

  /// Speak the given text
  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final sanitizedText = text.trim();
      if (sanitizedText.isEmpty) {
        throw Exception('No readable text found for text-to-speech.');
      }

      await _flutterTts.speak(sanitizedText);
    } catch (e) {
      throw Exception('Failed to speak: $e');
    }
  }

  /// Pause speaking
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
  Future<void> stop() async {
    if (!_isInitialized) return;

    try {
      await _flutterTts.stop();
      _isPlaying = false;
    } catch (e) {
      throw Exception('Failed to stop: $e');
    }
  }

  /// Set speech rate (0.0 - 1.0, where 0.5 is normal)
  Future<void> setSpeechRate(double rate) async {
    if (!_isInitialized) {
      await initialize();
    }

    _speechRate = rate.clamp(0.0, 1.0);
    await _flutterTts.setSpeechRate(_speechRate);
  }

  /// Get current speech rate
  double get speechRate => _speechRate;

  /// Check if currently playing
  bool get isPlaying => _isPlaying;

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

    selectedLanguage ??=
        languages.isNotEmpty ? languages.first.toString() : null;

    if (selectedLanguage == null) return;

    final availability = await _flutterTts.isLanguageAvailable(selectedLanguage);
    final isAvailable =
        availability == true || availability == 1 || availability == "1";

    if (isAvailable) {
      await _flutterTts.setLanguage(selectedLanguage);
    }
  }

  /// Dispose resources
  void dispose() {
    _flutterTts.stop();
  }
}
