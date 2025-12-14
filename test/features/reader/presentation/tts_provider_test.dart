import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_forge/features/reader/presentation/tts_provider.dart';
import 'package:read_forge/features/reader/services/tts_service.dart';

class FakeTtsService implements TtsServiceBase {
  bool initialized = false;
  bool playing = false;
  double rate = 0.5;
  String? lastText;
  bool throwOnSpeak = false;
  int _currentChunk = 0;
  int _totalChunks = 0;

  @override
  Function()? onComplete;

  @override
  Function()? onContinue;

  @override
  Function(String p1)? onError;

  @override
  Function()? onPause;

  @override
  Function()? onStart;

  @override
  Function(int current, int total)? onProgress;

  @override
  bool get isPlaying => playing;

  @override
  double get speechRate => rate;

  @override
  int get currentChunk => _currentChunk;

  @override
  int get totalChunks => _totalChunks;

  @override
  Future<void> initialize() async {
    initialized = true;
  }

  @override
  Future<void> pause() async {
    playing = false;
    onPause?.call();
  }

  @override
  Future<void> setSpeechRate(double rate) async {
    this.rate = rate.clamp(0.0, 1.0);
  }

  @override
  Future<void> speak(String text, {String? bookTitle, String? chapterTitle}) async {
    if (throwOnSpeak) {
      throw Exception('speak failed');
    }
    lastText = text;
    playing = true;
    _currentChunk = 1;
    _totalChunks = 1;
    onProgress?.call(1, 1);
    onStart?.call();
  }

  @override
  Future<void> stop() async {
    playing = false;
    _currentChunk = 0;
    _totalChunks = 0;
    onComplete?.call();
  }

  @override
  void dispose() {}

  @override
  Future<void> seekToChunk(int chunkIndex) async {
    _currentChunk = chunkIndex + 1;
  }

  @override
  Future<void> previousChunk() async {
    if (_currentChunk > 1) _currentChunk--;
  }

  @override
  Future<void> nextChunk() async {
    if (_currentChunk < _totalChunks) _currentChunk++;
  }
}

void main() {
  group('TtsNotifier', () {
    test('initializes service and updates state', () async {
      final service = FakeTtsService();
      final container = ProviderContainer(
        overrides: [ttsServiceProvider.overrideWithValue(service)],
      );
      addTearDown(container.dispose);

      await container.read(ttsProvider.notifier).initialize();

      final state = container.read(ttsProvider);
      expect(service.initialized, isTrue);
      expect(state.isInitialized, isTrue);
      expect(state.speechRate, 0.5);
    });

    test('speak stores text and sets playing state', () async {
      final service = FakeTtsService();
      final container = ProviderContainer(
        overrides: [ttsServiceProvider.overrideWithValue(service)],
      );
      addTearDown(container.dispose);

      await container.read(ttsProvider.notifier).speak('Hello world');

      final state = container.read(ttsProvider);
      expect(state.currentText, 'Hello world');
      expect(state.isPlaying, isTrue);
      expect(service.lastText, 'Hello world');
    });

    test('pause and stop update state', () async {
      final service = FakeTtsService();
      final container = ProviderContainer(
        overrides: [ttsServiceProvider.overrideWithValue(service)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(ttsProvider.notifier);
      await notifier.speak('Hello world');
      await notifier.pause();
      expect(container.read(ttsProvider).isPlaying, isFalse);

      await notifier.stop();
      final state = container.read(ttsProvider);
      expect(state.isPlaying, isFalse);
      expect(state.currentText, isNull);
    });

    test('setSpeechRate clamps and updates state', () async {
      final service = FakeTtsService();
      final container = ProviderContainer(
        overrides: [ttsServiceProvider.overrideWithValue(service)],
      );
      addTearDown(container.dispose);

      await container.read(ttsProvider.notifier).setSpeechRate(0.9);

      final state = container.read(ttsProvider);
      expect(state.speechRate, 0.9);
      expect(service.rate, 0.9);
    });

    test('speak surfaces errors into state', () async {
      final service = FakeTtsService()..throwOnSpeak = true;
      final container = ProviderContainer(
        overrides: [ttsServiceProvider.overrideWithValue(service)],
      );
      addTearDown(container.dispose);

      await container.read(ttsProvider.notifier).speak('Hello world');

      final state = container.read(ttsProvider);
      expect(state.isPlaying, isFalse);
      expect(state.errorMessage, isNotNull);
    });
  });
}
