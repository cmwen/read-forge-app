import 'package:audio_service/audio_service.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Audio handler for TTS integration with Android media controls
class TtsAudioHandler extends BaseAudioHandler with SeekHandler {
  final FlutterTts _flutterTts = FlutterTts();
  
  // State management
  String? _currentText;
  List<String> _textChunks = [];
  int _currentChunkIndex = 0;
  double _speechRate = 0.5;
  bool _isStopped = false;
  bool _isInitialized = false;
  
  // Callbacks for state updates
  Function()? onComplete;
  Function(int current, int total)? onProgress;
  
  TtsAudioHandler() {
    _init();
  }
  
  Future<void> _init() async {
    if (_isInitialized) return;
    
    // Configure TTS
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(_speechRate);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.awaitSpeakCompletion(true);
    
    // Enable background audio for iOS (Android uses audio_service)
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
    
    // Set up TTS handlers
    _flutterTts.setStartHandler(() {
      _updatePlaybackState(playing: true);
    });
    
    _flutterTts.setCompletionHandler(() async {
      if (!_isStopped && _currentChunkIndex < _textChunks.length - 1) {
        _currentChunkIndex++;
        onProgress?.call(_currentChunkIndex + 1, _textChunks.length);
        await _speakCurrentChunk();
      } else {
        // All chunks completed
        _updatePlaybackState(
          playing: false,
          processingState: AudioProcessingState.completed,
        );
        onComplete?.call();
      }
    });
    
    _flutterTts.setPauseHandler(() {
      _updatePlaybackState(playing: false);
    });
    
    _flutterTts.setContinueHandler(() {
      _updatePlaybackState(playing: true);
    });
    
    _flutterTts.setErrorHandler((msg) {
      _updatePlaybackState(
        playing: false,
        processingState: AudioProcessingState.error,
      );
    });
    
    // Initialize playback state
    _updatePlaybackState(
      playing: false,
      processingState: AudioProcessingState.idle,
    );
    
    _isInitialized = true;
  }
  
  void _updatePlaybackState({
    bool? playing,
    AudioProcessingState? processingState,
  }) {
    playbackState.add(playbackState.value.copyWith(
      playing: playing ?? playbackState.value.playing,
      processingState: processingState ?? playbackState.value.processingState,
      controls: [
        if (playing == true) ...[
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
      androidCompactActionIndices: const [0, 1, 2],
      speed: _speechRate * 2, // Convert 0.0-1.0 to actual speed multiplier
      updatePosition: Duration(
        seconds: _currentChunkIndex * 10, // Rough estimate
      ),
    ));
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
  
  Future<void> speakText(String text, {String? title, String? album}) async {
    if (!_isInitialized) await _init();
    
    // Stop any existing playback first
    await stop();
    
    _currentText = text;
    _textChunks = _splitIntoChunks(text);
    _currentChunkIndex = 0;
    _isStopped = false;
    
    // Update media item - this is critical for notification to show
    final newMediaItem = MediaItem(
      id: 'tts_${DateTime.now().millisecondsSinceEpoch}',
      album: album ?? 'ReadForge',
      title: title ?? 'Text-to-Speech',
      duration: Duration(seconds: _textChunks.length * 30), // Rough estimate
      artUri: null,
    );
    mediaItem.add(newMediaItem);
    
    onProgress?.call(_currentChunkIndex + 1, _textChunks.length);
    
    // Start speaking immediately
    await _speakCurrentChunk();
  }
  
  @override
  Future<void> play() async {
    if (_currentText != null) {
      if (_textChunks.isEmpty) {
        // Restart from beginning if no chunks
        _currentChunkIndex = 0;
      }
      await _speakCurrentChunk();
    }
  }
  
  @override
  Future<void> pause() async {
    await _flutterTts.pause();
  }
  
  @override
  Future<void> stop() async {
    _isStopped = true;
    await _flutterTts.stop();
    _currentText = null;
    _textChunks.clear();
    _currentChunkIndex = 0;
    
    _updatePlaybackState(
      playing: false,
      processingState: AudioProcessingState.idle,
    );
  }
  
  @override
  Future<void> skipToPrevious() async {
    if (_currentChunkIndex > 0) {
      await _flutterTts.stop();
      _currentChunkIndex--;
      onProgress?.call(_currentChunkIndex + 1, _textChunks.length);
      await _speakCurrentChunk();
    }
  }
  
  @override
  Future<void> skipToNext() async {
    if (_currentChunkIndex < _textChunks.length - 1) {
      await _flutterTts.stop();
      _currentChunkIndex++;
      onProgress?.call(_currentChunkIndex + 1, _textChunks.length);
      await _speakCurrentChunk();
    }
  }
  
  /// Seek to specific chunk (0-indexed)
  Future<void> seekToChunk(int chunkIndex) async {
    if (chunkIndex < 0 || chunkIndex >= _textChunks.length) return;
    
    await _flutterTts.stop();
    _currentChunkIndex = chunkIndex;
    onProgress?.call(_currentChunkIndex + 1, _textChunks.length);
    await _speakCurrentChunk();
  }
  
  @override
  Future<void> setSpeed(double speed) async {
    final wasPlaying = playbackState.value.playing;
    _speechRate = speed;
    await _flutterTts.setSpeechRate(_speechRate);
    
    // If currently playing, restart to apply new speed
    if (wasPlaying && _textChunks.isNotEmpty) {
      await _flutterTts.stop();
      await _speakCurrentChunk();
    }
    
    _updatePlaybackState(playing: wasPlaying);
  }
  
  int get currentChunk => _currentChunkIndex + 1;
  int get totalChunks => _textChunks.length;
  double get speechRate => _speechRate;
}
