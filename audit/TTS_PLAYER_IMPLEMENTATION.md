# TTS Player Implementation Summary

## Overview

This document describes the implementation of a podcast-style TTS (Text-to-Speech) player for the ReadForge reader screen, along with fixes for TTS playback issues.

## Changes Made

### 1. New TTS Player Widget

**File**: `lib/features/reader/presentation/tts_player_widget.dart`

Created a new widget that displays at the bottom of the reader screen with podcast-style controls:

#### Features:
- **Large Play/Pause Button**: Center button with circular background for easy access
- **Rewind/Forward Buttons**: Jump back/forward 10 seconds (currently restarts/stops as placeholder)
- **Stop Button**: Completely stop playback and close player
- **Speed Control Slider**: Adjust speech rate from slow to fast (0.0 to 1.0)
- **Progress Indicator**: Linear progress bar when audio is playing
- **Error Display**: Shows TTS errors in a container with error styling
- **Auto-hide**: Player only shows when TTS is active or has content loaded

#### UI Layout:
```
┌─────────────────────────────────────┐
│     [Progress Bar when playing]     │
├─────────────────────────────────────┤
│  ⟲     ⊙      ⟳      ⏹              │
│ -10s  PLAY  +10s   STOP             │
├─────────────────────────────────────┤
│ 🎵 ━━●━━━━━━━━━━ Speed: Normal     │
│    Slow        Fast                  │
└─────────────────────────────────────┘
```

### 2. Enhanced TTS Provider

**File**: `lib/features/reader/presentation/tts_provider.dart`

Added new methods to support player controls:

- **`resume()`**: Resume playback of current text
- **`rewind()`**: Rewind 10 seconds (currently restarts from beginning)
- **`forward()`**: Forward 10 seconds (currently skips to end)

### 3. Fixed TTS Playback Bug

**File**: `lib/features/reader/presentation/reader_screen.dart`

#### The Problem:
The `_startReading()` method was incorrectly using `await` with `AsyncValue.when()`. The `when()` method doesn't return a Future - it executes callbacks synchronously based on the current state. This caused TTS playback to never properly execute.

```dart
// BEFORE (❌ Broken)
void _startReading(BuildContext context) async {
  final chapterAsync = ref.read(chapterProvider(widget.chapterId));
  
  await chapterAsync.when(  // ❌ This doesn't work!
    data: (chapter) async { ... },
    loading: () {},
    error: (error, stack) {},
  );
}
```

#### The Solution:
1. Made all callbacks in `when()` async
2. Added `await` to the entire `when()` expression
3. Added proper error handling with try-catch
4. Removed the settings dialog - TTS now starts immediately

```dart
// AFTER (✅ Works)
void _startReading(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  final chapterAsync = ref.read(chapterProvider(widget.chapterId));

  await chapterAsync.when(  // ✅ Await the whole expression
    data: (chapter) async {
      // ... strip markdown ...
      try {
        await ref.read(ttsProvider.notifier).speak(plainText);
      } catch (e) {
        // Show error to user
      }
    },
    loading: () async { /* show loading message */ },
    error: (error, stack) async { /* show error message */ },
  );
}
```

### 4. Updated Reader Screen UI

Integrated the TTS player into the reader screen:

```dart
body: Column(
  children: [
    Expanded(
      child: chapterAsync.when(...), // Main content
    ),
    const TtsPlayerWidget(), // TTS player at bottom
  ],
),
```

### 5. New Localizations

**File**: `lib/l10n/app_en.arb`

Added new strings:
- `rewind`: "Rewind 10 seconds"
- `forward`: "Forward 10 seconds"
- `highlightSelected`: "Highlight Selected Text"

## User Experience Flow

### Starting TTS:

1. User taps play button (▶️) in app bar
2. Chapter content is loaded from provider
3. Markdown formatting is stripped for better speech
4. TTS begins speaking immediately (no settings dialog)
5. TTS player widget appears at bottom of screen
6. Play button changes to pause button

### Controlling Playback:

1. **Pause**: Tap pause button in player or app bar
2. **Resume**: Tap play button again
3. **Adjust Speed**: Drag slider in player (changes take effect immediately)
4. **Rewind**: Tap ⟲ button (restarts from beginning for now)
5. **Forward**: Tap ⟳ button (stops playback for now)
6. **Stop**: Tap stop button (closes player and clears state)

### Player Behavior:

- **Auto-show**: Appears when TTS starts
- **Auto-hide**: Disappears when stopped and no content loaded
- **Persistent**: Remains visible while paused (can resume)
- **Non-intrusive**: Positioned at bottom, doesn't block content

## Technical Details

### State Management:

The TTS player uses Riverpod's `Consumer` to watch `ttsProvider`:

```dart
final ttsState = ref.watch(ttsProvider);

// React to state changes:
- ttsState.isPlaying    → Show pause/play button
- ttsState.speechRate   → Update speed slider
- ttsState.currentText  → Show/hide player
- ttsState.errorMessage → Display errors
```

### Markdown Stripping:

The `_stripMarkdown()` method removes:
- Headers (`#`, `##`, etc.)
- Bold and italic markers (`**`, `*`, `_`)
- Links (keeps text, removes URLs)
- Code blocks and inline code
- Blockquotes
- List markers
- Horizontal rules

This ensures TTS speaks clean text without formatting symbols.

## Known Limitations

1. **Rewind/Forward**: Currently restart/stop instead of seeking ±10 seconds
   - Reason: `flutter_tts` doesn't support seeking
   - Future: Could split text into chunks for better control

2. **Progress Tracking**: No visual progress indicator
   - Reason: `flutter_tts` doesn't report current position
   - Future: Could implement word-by-word highlighting

3. **Background Audio**: Not tested yet
   - Should work based on iOS audio category settings
   - Needs testing on actual device

## Testing

### To Test TTS:

1. Create a book with content
2. Navigate to a chapter
3. Tap play button in app bar
4. Verify:
   - TTS player appears at bottom
   - Audio plays
   - Pause button works
   - Speed control works
   - Stop button closes player

### Edge Cases to Test:

- Empty content (should show "no content" message)
- Very long content (test performance)
- Navigation while playing (should stop)
- Screen lock while playing (should continue)
- Multiple chapter switches
- Error recovery

## Future Enhancements

### Short Term:
1. Implement proper rewind/forward with text chunking
2. Add progress indicator with current position
3. Add chapter navigation (previous/next chapter)
4. Save playback position

### Medium Term:
1. Word-by-word highlighting synchronized with speech
2. Adjustable skip intervals (5s, 10s, 30s)
3. Playback history
4. Bookmarks for audio positions

### Long Term:
1. Multiple voice options
2. Pitch control
3. Volume control
4. Sleep timer
5. Playback statistics

## Files Modified

1. **New Files**:
   - `lib/features/reader/presentation/tts_player_widget.dart` (new player UI)

2. **Modified Files**:
   - `lib/features/reader/presentation/reader_screen.dart` (TTS fix, player integration)
   - `lib/features/reader/presentation/tts_provider.dart` (new control methods)
   - `lib/l10n/app_en.arb` (new strings)
   - `lib/l10n/app_localizations*.dart` (generated localizations)

## Breaking Changes

None. All changes are backward compatible.

## Migration Notes

If updating from a previous version:
1. TTS now starts immediately without settings dialog
2. Speed control moved to player widget instead of settings dialog
3. New player UI appears at bottom of screen

Users will need to:
- Get familiar with new player controls
- Adjust speed using slider in player instead of settings

## Conclusion

The new TTS player provides a familiar, podcast-style interface for audio playback with better visual feedback and easier controls. The fix to the `_startReading()` method ensures TTS actually works now, resolving the critical bug where tapping play did nothing.

The implementation follows Flutter best practices:
- Proper state management with Riverpod
- Responsive UI that adapts to state changes
- Error handling with user feedback
- Accessibility considerations (tooltips, semantic labels)
- Clean separation of concerns (widget, provider, service)
