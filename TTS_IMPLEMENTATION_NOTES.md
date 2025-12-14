# TTS Implementation Notes

## Overview
ReadForge uses Flutter TTS (`flutter_tts` package) integrated with `audio_service` for background playback support and Android media controls.

## Architecture

### Components
1. **TtsService** (`lib/features/reader/services/tts_service.dart`)
   - Main TTS service interface and implementation
   - Handles text chunking (max 4000 characters per chunk)
   - Manages speech rate and playback state

2. **TtsAudioHandler** (`lib/features/reader/services/tts_audio_handler.dart`)
   - Integrates TTS with Android AudioService
   - Manages media session and notifications
   - Handles media button events (play/pause/skip)

3. **TtsProvider** (`lib/features/reader/presentation/tts_provider.dart`)
   - Riverpod state management for TTS
   - Exposes TTS controls to UI
   - Manages callbacks and state updates

4. **TtsPlayerScreen** (`lib/features/reader/presentation/tts_player_screen.dart`)
   - Full-screen player interface
   - Chunk-based navigation
   - Speed control
   - Syncs with reading progress

## Key Features

### ✅ Implemented
- **Background Playback**: Continues when app is backgrounded or screen is off
- **Android Media Controls**: Notification with play/pause/skip controls
- **Chunk-based Progress**: Tracks progress by text sections
- **Speed Control**: Adjustable speech rate (0.0 - 1.0)
- **Auto-scroll Sync**: Reader scrolls automatically based on TTS progress
- **Stop Button**: Stops playback and clears state

### ⚠️ Limitations

#### Time-based Tracking Not Available
**flutter_tts** does not provide real-time playback position tracking. The package only provides these callbacks:
- `setStartHandler()` - Called when TTS starts
- `setCompletionHandler()` - Called when TTS completes a chunk
- `setPauseHandler()` - Called when TTS pauses
- `setErrorHandler()` - Called on errors

**What this means:**
- ❌ No time-based progress (e.g., "3:45 / 10:30")
- ❌ No seeking by time (e.g., "jump to 5 minutes")
- ❌ No precise "rewind 10 seconds" or "forward 10 seconds"
- ✅ Instead, we use **chunk-based navigation** (sections of text)

#### Current Implementation
- **Progress**: Tracked by chunks/sections (e.g., "Section 3 of 10")
- **Skip Previous/Next**: Jumps between text chunks
- **Restart**: Replays current chunk from beginning
- **Seek**: Slider jumps to specific chunk, not time position

## Reading & Listening Sync

### How It Works
1. **TTS Progress → Reading Position**
   - As TTS plays each chunk, we calculate an approximate scroll position
   - Formula: `scrollPosition = (currentChunk / totalChunks) * maxScroll`
   - Reader auto-scrolls smoothly to match TTS progress

2. **Reading Position → TTS**
   - User can manually scroll while listening
   - TTS continues from current chunk
   - Progress is saved when user stops playback

3. **Progress Persistence**
   - Reading position saved to database
   - Restored when user returns to chapter
   - Synced across reading and listening modes

### Implementation Details
```dart
// In TtsPlayerScreen
void _syncReadingProgress(int currentChunk, int totalChunks) {
  final progress = (currentChunk / totalChunks * 1000).round();
  // Update scroll position in reader
  final maxScroll = scrollController.position.maxScrollExtent;
  final targetPosition = (progress / 1000.0 * maxScroll);
  scrollController.animateTo(targetPosition, ...);
}
```

## Android Media Controls

### Configuration
**AndroidManifest.xml:**
```xml
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>

<service android:name="com.ryanheise.audioservice.AudioService"
         android:foregroundServiceType="mediaPlayback"
         android:exported="true">
  <intent-filter>
    <action android:name="android.media.browse.MediaBrowserService"/>
  </intent-filter>
</service>
```

### Media Session
- **MediaItem**: Set with book/chapter title
- **PlaybackState**: Updated on play/pause/complete
- **Controls**: Play, Pause, Stop, Skip Previous, Skip Next
- **Compact Actions**: First 3 actions shown in collapsed notification

### Troubleshooting Media Controls

If notification doesn't appear:
1. Check AudioService is initialized: `await initAudioService()`
2. Verify MediaItem is set: `mediaItem.add(newMediaItem)`
3. Ensure PlaybackState is updated: `playbackState.add(...)`
4. Check permissions in AndroidManifest.xml
5. Test on physical device (emulator may not show media controls)

**Common Issues:**
- **Notification not showing**: MediaItem may not be set before starting playback
- **Controls not working**: PlaybackState controls list may be empty
- **No lock screen controls**: Ensure `androidNotificationOngoing: true`

## Testing

### Unit Tests
- `test/features/reader/presentation/tts_provider_test.dart`
- Covers basic TTS operations and state management
- Uses mock TTS service to avoid platform dependencies

### Manual Testing Checklist
- [ ] Start TTS playback from reader
- [ ] Player screen opens automatically
- [ ] Progress indicator shows current chunk
- [ ] Play/Pause works
- [ ] Skip Previous/Next works between chunks
- [ ] Restart replays current chunk
- [ ] Speed slider changes speech rate
- [ ] Stop button ends playback
- [ ] Notification appears on Android
- [ ] Lock screen controls work
- [ ] Background playback continues
- [ ] Reader auto-scrolls with TTS progress
- [ ] Progress is saved when stopped

## Future Improvements

### Possible Enhancements
1. **Chapter Navigation**: Skip to previous/next chapter
2. **Bookmarks Integration**: Jump to bookmarked positions
3. **Sleep Timer**: Auto-stop after X minutes
4. **Voice Selection**: Choose TTS voice
5. **Persistent Playback**: Resume from last position
6. **Better Chunking**: Use sentence/paragraph boundaries
7. **Visual Highlighting**: Highlight current sentence being read

### Alternative Approaches
For apps requiring precise time-based tracking:
- **Pre-recorded Audio**: Generate TTS audio files and play with just_audio
  - ✅ Accurate time tracking
  - ✅ Seek by time position
  - ✅ Show duration/position
  - ❌ Requires storage for audio files
  - ❌ Can't change voice/speed easily

## Dependencies

```yaml
flutter_tts: ^4.2.0          # TTS engine
audio_service: ^0.18.15       # Background audio & media controls
just_audio: ^0.9.42           # Audio playback support (used by audio_service)
```

## References
- [flutter_tts package](https://pub.dev/packages/flutter_tts)
- [audio_service package](https://pub.dev/packages/audio_service)
- [Android Media Controls Guide](https://developer.android.com/guide/topics/media/mediasession)
- [Flutter TTS limitations discussion](https://github.com/dlutton/flutter_tts/issues)

## Notes for Developers

### Adding New TTS Controls
1. Add method to `TtsServiceBase` interface
2. Implement in `TtsService`
3. Add to `TtsAudioHandler` if needed for media controls
4. Expose in `TtsNotifier`
5. Update UI in `TtsPlayerScreen`

### Debugging TTS Issues
```dart
// Enable TTS logging
_flutterTts.setErrorHandler((msg) {
  debugPrint('TTS Error: $msg');
});

// Check audio service status
debugPrint('AudioHandler initialized: ${_audioHandler != null}');
debugPrint('Playing: ${playbackState.value.playing}');
```

### Performance Considerations
- **Chunking**: 4000 character limit prevents TTS buffer overflow
- **State Updates**: Debounce progress callbacks to avoid excessive rebuilds
- **Memory**: Clean up resources in dispose methods
- **Battery**: Audio service manages wake locks automatically

## Conclusion

While flutter_tts doesn't support time-based seeking, the chunk-based approach provides:
- Reliable progress tracking
- Smooth navigation between sections
- Good sync with reading position
- Full Android media integration

For most reading use cases, this is sufficient and simpler than managing pre-recorded audio files.
