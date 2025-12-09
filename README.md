# ReadForge 📚

A local-first AI-powered book creation and reading app. Create, manage, and read LLM-generated books with full data ownership and privacy.

## ✨ Features

- 📖 **AI-Powered Content**: Generate book outlines, titles, and chapters using your favorite LLM (ChatGPT, Claude, etc.)
- 🎨 **Customizable Writing**: Set your preferred writing style, tone, vocabulary level, and favorite author for AI-generated content
- 🌍 **Multi-Language Support**: Full internationalization with 12 languages (English, Spanish, Chinese, French, German, Portuguese, Japanese, Korean, Arabic, Hindi, Russian)
- 📱 **Local-First**: All data stored locally on your device - complete privacy and ownership
- 🎯 **Material Design 3**: Beautiful, accessible UI with light, dark, and sepia reading themes
- 📚 **Library Management**: Organize your AI-generated books in a clean, intuitive library
- 📖 **Rich Reader**: Adjustable font sizes, multiple themes, and comfortable reading experience
- 🔄 **Export/Import**: Export books as JSON for backup or sharing
- 🚀 **Production Ready**: Optimized build system with Java 17, parallel builds, and CI/CD

## 🚀 Quick Start

### Prerequisites

- Flutter SDK 3.10.1+
- Dart 3.10.1+
- Java 17+ (for Android)
- Android device or emulator

Verify: `flutter doctor -v && java -version`

### Setup

```bash
# Clone the repository
git clone https://github.com/cmwen/read-forge-app.git
cd read-forge-app

# Get dependencies
flutter pub get

# Run the app
flutter run
```

## 🎯 How to Use

### 1. Create a Book
- Tap the **+** button in your library
- Fill in at least one field:
  - **Book Title** (Optional): Enter a title or leave empty for AI generation
  - **Description** (Optional): Describe what the book is about
  - **Purpose/Learning Goal** (Optional): What you want to learn from this book
- If you don't provide a title, the app can generate one using AI based on your description or purpose
- Your new book is created!

### 2. Generate Table of Contents
- Open your book
- Tap **Generate TOC**
- Copy the prompt or share it with your AI assistant (ChatGPT, Claude, etc.)
- Paste the AI's response back into ReadForge
- Supports both JSON and plain text formats

### 3. Generate Chapter Content
- Tap any chapter in your book
- Tap **Generate Content**
- Share the prompt with your AI assistant
- Paste the generated content back
- Start reading!

### 4. Customize Writing Preferences
- Go to **Settings** from the library
- Set your preferred:
  - Writing Style (Creative, Balanced, Precise)
  - Language
  - Tone (Casual, Neutral, Formal)
  - Vocabulary Level (Simple, Moderate, Advanced)
  - Favorite Author (for style inspiration)
- These preferences are automatically included in all AI prompts!

### 5. Customize Reading Experience
- While reading, tap the **text settings** icon
- Adjust font size, theme (Light/Dark/Sepia), and font family
- Your preferences are saved automatically

## 💡 Tips for Best Results

### Writing Better Prompts
- Be specific about the genre and style you want
- Provide context in your book description
- Use the writing preferences to guide the AI's output
- Include character descriptions or plot outlines in the book description

### Supported LLM Response Formats
ReadForge accepts responses in multiple formats:

**JSON Format (Recommended):**
```json
{
  "type": "toc",
  "bookTitle": "Your Book Title",
  "chapters": [
    {"number": 1, "title": "Chapter One", "summary": "Brief summary"},
    {"number": 2, "title": "Chapter Two", "summary": "Brief summary"}
  ]
}
```

**Plain Text Format (Also Supported):**
```
1. Chapter Title - Brief summary
2. Another Chapter - Its summary
3. Third Chapter - Summary here
```

For chapter content, any plain text response will work!

### Fault-Tolerant Import
- The app is designed to be forgiving with response formats
- If parsing fails, you'll see a clear error message with details
- Plain text content is always accepted for chapters
- You can always try again if something goes wrong

## 🔧 Building

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (for Play Store)
flutter build appbundle --release
```

## 🏗️ Architecture

- **State Management**: Riverpod for reactive state management
- **Database**: Drift (SQLite) for local-first data storage
- **UI**: Material Design 3 with custom theming
- **Structure**: Feature-based architecture with clean separation of concerns

### Project Structure
```
lib/
├── core/              # Core services and domain models
│   ├── services/      # LLM integration, storage
│   ├── domain/        # Data models
│   └── data/          # Database definitions
├── features/          # Feature modules
│   ├── library/       # Book library
│   ├── book/          # Book details and TOC
│   ├── reader/        # Reading experience
│   └── settings/      # App settings
└── main.dart          # App entry point
```

## 🔐 Privacy & Data

- **100% Local**: All data stored locally on your device using SQLite
- **No Cloud**: No data sent to external servers
- **No Tracking**: No analytics or tracking
- **Full Control**: Export your books anytime as JSON
- **Offline First**: Works completely offline after initial AI content generation

## 🐛 Troubleshooting

### Import Issues
- **"Empty input"**: Make sure you've copied the AI's response
- **"Clipboard placeholder"**: You've pasted the placeholder text, not the actual response
- **"Unable to parse"**: For TOC, use the numbered list format. For chapters, any plain text works!

### Build Issues
- Run `flutter clean && flutter pub get` to reset dependencies
- Make sure you have Java 17+ installed
- Check `flutter doctor -v` for any issues

## 📊 Recent Improvements

### Latest Version
- ✨ **Enhanced Book Creation**: Optional fields for title, description, and learning purpose
- 🤖 **AI Title Generation**: Let AI generate book titles based on your description or purpose
- 🌍 **Full Internationalization**: Support for 12 languages including English, Spanish, Chinese (Simplified & Traditional), French, German, Portuguese, Japanese, Korean, Arabic, Hindi, and Russian
- 📊 **Purpose Tracking**: Track learning goals for each book
- 🔧 **Improved Database**: Added purpose field and AI-generated title tracking

### Version 0.1.0+1
- ✨ User preferences now included in all AI prompts
- 🔧 Fixed error detail dialog display issues
- 📖 Dynamic version display from build configuration
- 🛡️ More fault-tolerant LLM response import
- 📝 Improved error messages and user guidance
- 📚 Updated README with comprehensive usage guide



## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

MIT License - see [LICENSE](LICENSE)

## 🔗 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Drift (SQLite) Documentation](https://drift.simonbinder.eu/)
- [Riverpod Documentation](https://riverpod.dev/)

## 📱 Screenshots

*Coming soon - screenshots of the library, reader, and settings screens*

## ⭐ Star This Project

If you find ReadForge useful, please give it a star! It helps others discover the project.

## License

MIT License - see [LICENSE](LICENSE)
