# ReadForge - Product Summary

---
**App Name**: ReadForge  
**Tagline**: *Forge Your Own Stories*  
**Version**: 0.1.0 (Alpha)  
**Created**: December 6, 2025  
---

## What is ReadForge?

ReadForge is a **local-first Android app** that combines:
- 📚 **Book Library Management** - Organize your AI-generated books
- 🤖 **LLM Integration** - Generate content via Intent sharing with any LLM app
- 📖 **E-Reader Experience** - Full reading features inspired by KOReader
- 🔐 **Data Ownership** - All data stored locally, fully exportable

## Core Workflow

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  Create     │───►│  Generate   │───►│  Share to   │───►│  Paste      │
│  Book       │    │  Prompt     │    │  LLM App    │    │  Response   │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
                          │                                     │
                          ▼                                     ▼
                   ┌─────────────┐                       ┌─────────────┐
                   │  Context    │◄──────────────────────│  Parse &    │
                   │  Updated    │                       │  Store      │
                   └─────────────┘                       └─────────────┘
                          │
                          ▼
                   ┌─────────────┐
                   │  READ &     │
                   │  ENJOY      │
                   └─────────────┘
```

## Key Differentiators

| Feature | ReadForge | ChatGPT/Claude | Other E-Readers |
|---------|-----------|----------------|-----------------|
| Organized book structure | ✅ | ❌ | ✅ |
| Context-aware generation | ✅ | ❌ | N/A |
| Local-first storage | ✅ | ❌ | ✅ |
| LLM agnostic | ✅ | ❌ | N/A |
| Full reading experience | ✅ | ❌ | ✅ |
| AI content generation | ✅ | ✅ | ❌ |
| Data export | ✅ | Limited | Varies |
| Book derivatives/forking | ✅ | ❌ | ❌ |

## Product Documentation

| Document | Purpose |
|----------|---------|
| [PRODUCT_VISION.md](./docs/PRODUCT_VISION.md) | Strategic vision and market positioning |
| [REQUIREMENTS_MVP.md](./docs/REQUIREMENTS_MVP.md) | Detailed functional & non-functional requirements |
| [USER_STORIES.md](./docs/USER_STORIES.md) | User personas and user stories with acceptance criteria |
| [ROADMAP.md](./docs/ROADMAP.md) | Release timeline and feature planning |
| [PROMPT_STRATEGY.md](./docs/PROMPT_STRATEGY.md) | LLM prompt templates and context management |

## MVP Feature Set

### ✅ Library Management
- Create books with metadata (title, author, cover, genre)
- Grid/list library views with search and filter
- Book derivatives (fork existing books)
- Delete with confirmation

### ✅ Content Generation
- Generate TOC prompts with user preferences
- Parse and import TOC from LLM responses
- Generate chapter prompts with full context
- Context management (characters, setting, themes)
- Android Intent sharing to any LLM app

### ✅ Reading Experience
- Full-screen reader with customizable typography
- Light/Dark/Sepia themes
- Bookmarks, highlights (with colors), and notes
- Progress tracking and navigation
- TOC-based chapter navigation

### ✅ User Preferences
- Writing style, language, tone settings
- Vocabulary level control
- Optional favorite author for style inspiration
- BYOK API key storage (for future direct integration)

### ✅ Data Management
- All data stored locally (SQLite + files)
- JSON export/import
- Highlights and notes export

## Tech Stack

- **Framework**: Flutter 3.10.1+
- **Language**: Dart 3.10.1+
- **Platform**: Android (API 24+)
- **Database**: SQLite via Drift (recommended)
- **State Management**: Riverpod (recommended)
- **Storage**: Local filesystem + Android Keystore

## Quick Links

- **For Development**: See [AGENTS.md](./AGENTS.md) for agent workflows
- **For Architecture**: See @architect agent prompts
- **For Implementation**: See @flutter-developer agent prompts

---

## Next Steps

1. **Architecture Design** - Define folder structure, data models, state management
2. **Database Setup** - Implement Drift database with all models
3. **Core UI** - Library view, book detail, chapter management
4. **Reader Implementation** - Full reading experience
5. **Intent Integration** - Share/receive prompts via Android Intent
6. **Testing** - Unit tests, widget tests, integration tests

---

*ReadForge: Where AI meets the art of storytelling, and you own every word.*
