import 'package:audio_service/audio_service.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Audio handler for TTS integration with Android media controls
class TtsAudioHandler extends BaseAudioHandler {
  final FlutterTts _flutterTts;
  
  // State management
  String? _currentText;
  List<String> _textChunks = [];
  int _currentChunkIndex = 0;
  double _speechRate = 0.5;
  bool _isStopped = false;
  
  // Callbacks for state updates
  Function()? onComplete;
  Function(int current, int total)? onProgress;
  
  TtsAudioHandler(this._flutterTts) {
    _init();
  }
  
  Future<void> _init() async {
    // Set up TTS handlers
    _flutterTts.setStartHandler(() {
      playbackState.add(playbackState.value.copyWith(
        playing: true,
        controls: [
          MediaControl.pause,
          MediaControl.stop,
          MediaControl.skipToPrevious,
          MediaControl.skipToNext,
        ],
        processingState: AudioProcessingState.ready,
      ));
    });
    
    _flutterTts.setCompletionHandler(() async {
      if (!_isStopped && _currentChunkIndex < _textChunks.length - 1) {
        _currentChunkIndex++;
        onProgress?.call(_currentChunkIndex + 1, _textChunks.length);
        await _speakCurrentChunk();
      } else {
        // All chunks completed
        playbackState.add(playbackState.value.copyWith(
          playing: false,
          processingState: AudioProcessingState.completed,
        ));
        onComplete?.call();
      }
    });
    
    _flutterTts.setPauseHandler(() {
      playbackState.add(playbackState.value.copyWith(playing: false));
    });
    
    _flutterTts.setContinueHandler(() {
      playbackState.add(playbackState.value.copyWith(playing: true));
    });
    
    _flutterTts.setErrorHandler((msg) {
      playbackState.add(playbackState.value.copyWith(
        playing: false,
        processingState: AudioProcessingState.error,
      ));
    });
    
    // Initialize playback state
    playbackState.add(PlaybackState(
      controls: [MediaControl.play],
      playing: false,
      processingState: AudioProcessingState.idle,
      speed: 1.0,
      updatePosition: Duration.zero,
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
    _currentText = text;
    _textChunks = _splitIntoChunks(text);
    _currentChunkIndex = 0;
    _isStopped = false;
    
    // Update media item
    mediaItem.add(MediaItem(
      id: 'tts_${DateTime.now().millisecondsSinceEpoch}',
      album: album ?? 'ReadForge',
      title: title ?? 'Text-to-Speech',
      duration: Duration.zero,
      artUri: null,
    ));
    
    onProgress?.call(_currentChunkIndex + 1, _textChunks.length);
    await _speakCurrentChunk();
  }
  
  @override
  Future<void> play() async {
    if (_currentText != null && !playbackState.value.playing) {
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
    
    playbackState.add(playbackState.value.copyWith(
      playing: false,
      processingState: AudioProcessingState.idle,
    ));
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
  
  @override
  Future<void> setSpeed(double speed) async {
    _speechRate = speed;
    await _flutterTts.setSpeechRate(_speechRate);
  }
  
  int get currentChunk => _currentChunkIndex + 1;
  int get totalChunks => _textChunks.length;
  double get speechRate => _speechRate;
}
