# Text-to-Speech (TTS) Feature Documentation

## Overview
The ReadForge app now includes a comprehensive Text-to-Speech feature that allows users to listen to book content using Android's native TTS API.

## Features

### 🎙️ Read Aloud
- Listen to chapter content with natural speech synthesis
- Automatically strips markdown formatting for better listening experience
- Clear, natural-sounding voice output

### 🎚️ Speed Control
- **Slow**: 0.0 - 0.4 speech rate
- **Normal**: 0.4 - 0.6 speech rate (default: 0.5)
- **Fast**: 0.6 - 1.0 speech rate
- Adjustable via settings dialog with real-time preview

### 🌙 Background Playback
- Audio continues even when screen is turned off
- Ideal for listening before sleep or while doing other activities
- Properly configured iOS audio categories for uninterrupted playback

### 🎮 Playback Controls
Located in the reader screen app bar:
- **Play Button** (▶️): Start reading from the current chapter
- **Pause Button** (⏸️): Pause playback (appears when playing)
- **Stop Button** (⏹️): Stop playback completely

## How to Use

### Starting Playback
1. Open a book and navigate to a chapter with content
2. Tap the **Play** button (▶️) in the app bar
3. A settings dialog appears:
   - Adjust speech speed using the slider
   - Tap **Play** to start reading

### During Playback
- **Pause**: Tap the pause button (⏸️) to temporarily pause
- **Resume**: Tap play button (▶️) to continue
- **Stop**: Tap stop button (⏹️) to end playback
- **Change Speed**: Stop playback, start again to access settings

### Automatic Cleanup
- TTS automatically stops when you navigate away from the reader
- No need to manually stop before closing

## Technical Implementation

### Architecture
```
TtsService (Core Service)
    ↓
TtsNotifier (Riverpod State Management)
    ↓
ttsProvider (Provider)
    ↓
ReaderScreen (UI Integration)
```

### Key Components

#### TtsService (`lib/features/reader/services/tts_service.dart`)
- Wraps `flutter_tts` package functionality
- Handles initialization, playback, error handling
- Manages speech rate, volume, pitch
- Provides callbacks for state changes

#### TtsNotifier (`lib/features/reader/presentation/tts_provider.dart`)
- Riverpod 3.x Notifier for state management
- Manages: isPlaying, isInitialized, speechRate, errors
- Provides methods: speak(), pause(), stop(), setSpeechRate()

#### ReaderScreen Integration
- Play/pause/stop buttons in app bar
- TTS settings dialog
- Markdown stripping for clean text
- Automatic cleanup on dispose

### Markdown Stripping
The TTS engine receives clean text by removing:
- Headers (#, ##, ###, etc.)
- Bold/italic markers (**, *, __, _)
- Links (keeps text, removes URLs)
- Code blocks and inline code
- Blockquotes markers
- List markers (-, *, +, 1., etc.)
- Horizontal rules

This ensures natural, flowing speech output.

## Localization

New localization keys added (in `lib/l10n/app_en.arb`):
- `readAloud`: "Read Aloud"
- `play`: "Play"
- `pause`: "Pause"
- `stop`: "Stop"
- `speechSpeed`: "Speech Speed"
- `slow`: "Slow"
- `normal`: "Normal"
- `fast`: "Fast"
- `ttsSettings`: "Read Aloud Settings"
- `ttsError`: "Text-to-speech error: {error}"
- `audioScreenOffInfo`: "Audio will continue even with screen off"

## Dependencies

### flutter_tts: ^4.2.0
- **Purpose**: Android TTS API integration
- **Security**: No known vulnerabilities
- **License**: MIT
- **Platform Support**: Android, iOS, Web, macOS, Windows, Linux

## Future Enhancements (Potential)

1. **Voice Selection**: Allow users to choose different TTS voices
2. **Language Selection**: Support for multiple languages
3. **Pitch Control**: Adjust voice pitch
4. **Volume Control**: Independent TTS volume
5. **Auto-advance**: Automatically move to next chapter when finished
6. **Reading Progress**: Visual indicator of current reading position
7. **Bookmarking**: Save listening position
8. **Playback Rate Presets**: Quick access to favorite speeds

## Troubleshooting

### No Sound
1. Check device volume
2. Ensure TTS engine is installed on device (Android Settings > Accessibility > Text-to-Speech)
3. Verify permissions if prompted

### Choppy Playback
1. Try reducing speech rate
2. Close other apps using audio
3. Restart the app

### Error Messages
- Check TTS state error messages
- Verify device TTS configuration
- Ensure content exists in chapter

## Development Notes

### Testing
- Unit tests for TTS service should be added
- Widget tests for UI controls
- Integration tests for full playback flow

### Performance
- TTS service is initialized lazily (on first use)
- Minimal memory footprint
- Proper resource cleanup prevents leaks

### Accessibility
- TTS feature enhances accessibility for visually impaired users
- Screen reader compatible UI controls
- Semantic labels on all buttons

## Code Example

```dart
// Access TTS state
final ttsState = ref.watch(ttsProvider);

// Start reading
if (ttsState.isPlaying) {
  await ref.read(ttsProvider.notifier).pause();
} else {
  await ref.read(ttsProvider.notifier).speak("Text to read");
}

// Adjust speed
await ref.read(ttsProvider.notifier).setSpeechRate(0.7);

// Stop reading
await ref.read(ttsProvider.notifier).stop();
```

## Summary

The TTS feature provides a comprehensive listening experience for ReadForge users, enabling them to consume content hands-free with customizable playback settings. The implementation follows Flutter and Riverpod best practices, with proper state management, error handling, and resource cleanup.
