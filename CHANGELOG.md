# Changelog

All notable changes to ReadForge are documented in this file.

## [0.2.0] - 2026-01-05

### ✨ Features

#### App Icons & Visual Identity
- Generated launcher icons for all Android resolutions (mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi)
- Added flutter_launcher_icons package for automatic icon generation
- Ensures consistent app branding across devices

#### Text-to-Speech (TTS) System
- Implemented comprehensive TTS feature for book content
- Support for background audio playback during app minimize
- Configurable speech rate and language settings
- Audio service integration with native Android support
- PlayPause, Skip, and Rewind controls
- Device speaker/earphone auto-detection

#### Ollama Integration
- Added Ollama LLM backend support for local AI generation
- Model selection and management interface
- Connection status monitoring
- Fallback to copy-paste mode when Ollama unavailable
- Table of Contents (TOC) generation with Ollama
- Chapter content generation with Ollama

#### Internationalization (i18n)
- Multi-language support: English, Spanish, Chinese, French, German, Portuguese, Japanese, Korean, Arabic, Hindi, Russian
- Generated localization files for 12 languages
- Material 3 theme support across all languages

#### Reader Features
- Multiple reading themes: Light, Dark, Sepia
- Adjustable font sizes and line heights
- Word highlighting for selected text
- Copy-to-clipboard functionality
- Settings persistence
- Smooth page navigation

#### Library Management
- Book creation with title, description, and purpose fields
- Book organization and browsing
- Book deletion and management
- Export/Import books as JSON
- Metadata preservation

### 🐛 Bug Fixes

- Fixed deprecated Share API usage - migrated to SharePlus with ShareParams
- Removed debug print statements from production code
- Fixed broken test files referencing old package names
- Cleaned up test directory structure

### 🔧 Technical Improvements

- Removed broken Ollama test files that referenced incorrect package names
- Updated code to remove all debug logging from production code
- Improved error handling in LLM integration service
- Java 17 compilation with proper version targeting
- R8 code shrinking and resource shrinking enabled

### 📦 Dependencies

**New**
- `flutter_launcher_icons: ^0.14.2` - Icon generation for Android

**Updated**
- `share_plus: ^12.0.1` - Modern sharing API
- `flutter_tts: ^4.2.0` - Text-to-speech
- `audio_service: ^0.18.15` - Background audio support
- `just_audio: ^0.10.5` - Audio playback engine

### 🏗️ Build & Release

- Verified Android signing configuration in build.gradle.kts
- Confirmed release build process works correctly
- App compilation clean with zero errors
- Code analysis shows only minor linting warnings

### 📋 Notes for Developers

- All debug print statements have been removed for production release
- Test files have been cleaned up
- Icon generation is automatic via flutter_launcher_icons.yaml config
- App is production-ready for Play Store submission

## [0.1.0] - Initial Release

### Features

- AI-powered book creation and management
- Local-first data storage
- Multi-language support
- Material Design 3 UI
- Reader with customizable themes
- Full user preferences system
