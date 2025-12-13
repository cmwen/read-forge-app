import 'package:flutter_tts/flutter_tts.dart';

/// Service for Text-to-Speech functionality
class TtsService {
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
      // Configure TTS for Android
      await _flutterTts.setLanguage("en-US");
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
      await _flutterTts.speak(text);
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

  /// Dispose resources
  void dispose() {
    _flutterTts.stop();
  }
}
