# ReadForge MVP Implementation

**Status**: 🚧 In Progress  
**Date**: December 6, 2025  
**Version**: 0.2.0

## Overview

This document describes the MVP (Minimum Viable Product) implementation for ReadForge, an AI-powered book library app.

## Recent Updates (December 6, 2025)

### ✅ Markdown Support Added
- **flutter_markdown_plus** package integrated for rendering Markdown content
- Reader now supports full Markdown formatting:
  - Headers (H1-H6) with responsive sizing based on font preferences
  - Bold (**text**) and italic (*text*) formatting
  - Lists (bulleted and numbered)
  - Code blocks and inline code
  - Blockquotes
  - Horizontal rules
- Sample text updated to demonstrate Markdown capabilities
- LLM prompts updated to explicitly request Markdown formatting
- Maintains backward compatibility with plain text content

### ✅ Content Length Preferences Added
- **Default Chapter Count** setting added to app settings
- Users can choose from 5, 10, 15, 20, 25, or 30 chapters
- Default value: 10 chapters
- Setting accessible via Settings > Content Generation
- Automatically applied to TOC generation prompts
- Stored persistently in SharedPreferences

## Implemented Features

### 1. Database Setup ✅

**Technology**: Drift (SQLite) for local data persistence

**Schema**:
- **Books Table**: Stores book metadata (title, author, description, status, etc.)
- **Chapters Table**: Stores chapter data with order index and content
- **Bookmarks Table**: Reading bookmarks with optional notes
- **Highlights Table**: Text highlights with colors and notes
- **Notes Table**: Margin notes at specific positions
- **ReadingProgress Table**: Tracks reading position and completion

**Repository Pattern**: Clean architecture with `BookRepository` for all database operations

### 2. State Management ✅

**Technology**: Riverpod 2.6.1

**Providers**:
- `databaseProvider`: Singleton database instance
- `bookRepositoryProvider`: Repository for data access
- `libraryProvider`: StateNotifier for library management
- `bookDetailProvider`: FutureProvider for individual books
- `bookChaptersProvider`: FutureProvider for book chapters
- `chapterProvider`: FutureProvider for individual chapters

### 3. Library Screen ✅

**Features**:
- Grid view of all books with cover placeholders
- Empty state with helpful message
- Book cards showing title, author, and status
- FAB (Floating Action Button) to create new books
- Dialog for book creation with title input
- Navigation to book detail screen
- Status indicators (Draft, Reading, Completed)

### 4. Book Creation ✅

**Features**:
- Simple dialog with title input
- UUID generation for unique book IDs
- Automatic timestamp tracking
- Database persistence
- Navigation to newly created book

### 5. Book Detail/TOC Screen ✅

**Features**:
- Book metadata display (title, author, description)
- Table of Contents section
- Empty state when no chapters exist
- "Generate TOC" button with prompt generation
- Prompt copy-to-clipboard functionality
- Chapter list with status indicators
- Navigation to reader for each chapter
- Bottom sheet menu for book actions (Edit, Derivative, Export, Delete)

**TOC Prompt Generation**:
- Contextual prompt based on book title and description
- Copy to clipboard functionality
- Dialog with formatted prompt preview
- Instructions for using with AI assistants

### 6. Reader Screen ✅

**Features**:
- Chapter title display
- Selectable text content
- Sample text for demonstration
- Empty state with "Generate Content" prompt
- Navigation buttons (Previous/Next chapters - placeholder)
- Reader settings menu (Font size, Theme, Font family - placeholder)
- Proper typography with comfortable line spacing

**Reading Experience**:
- 18px font size with 1.8 line height
- Proper margins and padding
- Material Design 3 theming
- Support for both light and dark modes

## Architecture

### Folder Structure

```
lib/
├── core/
│   ├── data/
│   │   ├── database.dart          # Drift database schema
│   │   └── repositories/
│   │       └── book_repository.dart
│   ├── domain/
│   │   └── models/
│   │       ├── book_model.dart
│   │       └── chapter_model.dart
│   └── providers/
│       └── database_provider.dart
├── features/
│   ├── library/
│   │   └── presentation/
│   │       ├── library_screen.dart
│   │       └── library_provider.dart
│   ├── book/
│   │   └── presentation/
│   │       ├── book_detail_screen.dart
│   │       └── book_detail_provider.dart
│   └── reader/
│       └── presentation/
│           └── reader_screen.dart
└── main.dart
```

### Clean Architecture Layers

1. **Presentation Layer**: Flutter widgets, screens, and Riverpod providers
2. **Domain Layer**: Business models (BookModel, ChapterModel)
3. **Data Layer**: Database schema, repositories, and data sources

## Dependencies Added

```yaml
dependencies:
  flutter_riverpod: ^2.6.1          # State management
  drift: ^2.20.3                     # SQLite database
  drift_flutter: ^0.2.0              # Flutter integration
  sqlite3_flutter_libs: ^0.5.24     # SQLite native libs
  uuid: ^4.5.1                       # UUID generation
  intl: ^0.19.0                      # Internationalization
  flutter_markdown_plus: ^1.0.5     # Markdown rendering (NEW)
  share_plus: ^10.1.2                # Intent sharing
  receive_sharing_intent: ^1.8.0    # Receive shared content
  shared_preferences: ^2.3.0        # Settings storage
  path_provider: ^2.1.0              # File paths
  package_info_plus: ^8.1.2          # Version info

dev_dependencies:
  drift_dev: ^2.20.3                 # Code generation
  build_runner: ^2.4.13              # Build system
```

## Core Workflows

### Creating a Book

1. User taps FAB on Library screen
2. Dialog prompts for book title
3. Book created with UUID and timestamp
4. User navigated to Book Detail screen
5. Book appears in library grid

### Generating TOC

1. User taps "Generate TOC" button on Book Detail screen
2. Prompt dialog displays AI-ready prompt
3. User copies prompt and shares with AI assistant (ChatGPT, Claude, etc.)
4. User pastes response back (future feature)
5. Chapters parsed and displayed in TOC

### Reading a Chapter

1. User selects chapter from TOC
2. Reader screen displays chapter content
3. User can select text (for future highlights)
4. Navigation between chapters (placeholder)

## Known Limitations (MVP)

1. **No highlights/bookmarks UI** - Database schema exists but UI not fully implemented
2. **No book editing UI** - Can create but limited editing capabilities
3. **No derivatives UI** - Schema supports but not implemented
4. **No EPUB export** - Planned for future release
5. **Limited file import** - Only JSON import supported currently

## Testing

- Basic widget test verifies app structure
- Tests pass successfully
- Code analysis shows no issues
- All code formatted with `dart format`

## Next Steps for Post-MVP

1. **Reader Features**: Complete highlights, bookmarks, and notes UI
2. **Book Management**: Edit book metadata, delete with confirmation, derivatives
3. **EPUB Export**: Implement EPUB export functionality for cross-platform reading
4. **Advanced Markdown**: Support for tables, images, and custom styling
5. **Testing**: Add comprehensive unit tests for new features
6. **Performance**: Optimize Markdown rendering for long chapters
7. **Accessibility**: Ensure Markdown content is screen-reader friendly

## Build Instructions

```bash
# Get dependencies
flutter pub get

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Analyze code
flutter analyze

# Format code
dart format .

# Run tests
flutter test

# Run on device
flutter run
```

## Notes

- CI will handle APK building automatically
- Database is created automatically on first run
- All data is stored locally on device
- App works offline (except for AI prompt generation via external apps)
