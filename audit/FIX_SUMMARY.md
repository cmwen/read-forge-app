# Fix Summary: Chapter Content Import Error

## Problem
When attempting to import chapter content from an LLM (e.g., ChatGPT, Claude), the app showed the following error:

```
Error importing content: InvalidDataException: Sorry, ChaptersCompanion(id: Value(1), uuid: Value.absent(), bookId: Value.absent(), title: Value.absent(), summary: Value.absent(), content: Value(# Chapter 1 - 堅毅的本質"
```

## Root Cause
The issue was in the database update code in `reader_screen.dart` and `book_detail_screen.dart`. 

The code was using Drift's `.replace()` method, which requires providing ALL fields in the table (or explicitly marking them as `.absent()`). However, the code was only providing a few fields:
- `id`
- `content`
- `status`
- `wordCount`
- `updatedAt`

This caused Drift to throw an `InvalidDataException` because required fields like `uuid`, `bookId`, and `title` were missing.

## Solution
Changed from using `.replace()` to using `.write()` with a `where` clause, which allows partial updates of specific fields without requiring all columns.

### Before (Incorrect):
```dart
await database
    .update(database.chapters)
    .replace(
      ChaptersCompanion(
        id: drift.Value(chapter.id),
        content: drift.Value(content),
        status: const drift.Value('generated'),
        wordCount: drift.Value(content.split(' ').length),
        updatedAt: drift.Value(DateTime.now()),
      ),
    );
```

### After (Correct):
```dart
await (database.update(database.chapters)
      ..where((tbl) => tbl.id.equals(chapter.id)))
    .write(
      ChaptersCompanion(
        content: drift.Value(content),
        status: const drift.Value('generated'),
        wordCount: drift.Value(content.split(' ').length),
        updatedAt: drift.Value(DateTime.now()),
      ),
    );
```

## Key Changes
1. Added a `where` clause to specify which row to update
2. Removed the `id` field from the `Companion` object (not needed when using `where`)
3. Used `.write()` instead of `.replace()` to allow partial updates

## Files Modified
1. `lib/features/reader/presentation/reader_screen.dart` - Fixed chapter content import
2. `lib/features/book/presentation/book_detail_screen.dart` - Fixed book details update (had the same issue)

## Testing
- ✅ All 45 existing unit tests pass
- ✅ Flutter analyze shows no issues
- ✅ Code compiles successfully

## Expected Behavior Now
Users should now be able to:
1. Generate a chapter content prompt
2. Share it with their AI assistant (ChatGPT, Claude, etc.)
3. Copy the response (in JSON or plain text format)
4. Paste it back into the app
5. Successfully import the chapter content without errors

The fix handles both JSON format (with `type: "chapter"`) and plain text content.
