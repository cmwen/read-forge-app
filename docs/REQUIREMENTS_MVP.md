# ReadForge - MVP Requirements

---
**Created**: December 6, 2025  
**Version**: 1.0  
**Status**: Initial Draft  
**Target Release**: v1.0  
**Related**: [PRODUCT_VISION.md](./PRODUCT_VISION.md), [USER_STORIES.md](./USER_STORIES.md)  
---

## Scope Definition

### In Scope (MVP)
- Local book library management
- LLM prompt generation via Android Intent sharing
- Manual content pasting from LLM responses
- Essential reading experience
- Data export
- BYOK API key storage

### Out of Scope (Post-MVP)
- P2P sync
- Direct LLM API integration
- iOS/Desktop platforms
- Text-to-speech
- Cloud backup
- Social features

---

## Functional Requirements

### FR1: Library Management

#### FR1.1: Book Creation
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR1.1.1 | User can create a new book with title | Must | Entry point to app |
| FR1.1.2 | User can add optional subtitle, author name, description | Should | Metadata enrichment |
| FR1.1.3 | User can set book cover image from gallery or camera | Should | Visual library |
| FR1.1.4 | User can select book genre/category | Should | Organization aid |
| FR1.1.5 | System auto-generates creation timestamp | Must | Audit trail |
| FR1.1.6 | System assigns unique book ID | Must | Data integrity |

#### FR1.2: Book Library View
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR1.2.1 | Display all books in grid or list view | Must | Core navigation |
| FR1.2.2 | Show book cover, title, progress indicator | Must | Quick scanning |
| FR1.2.3 | Sort by: title, created date, last read, progress | Should | Organization |
| FR1.2.4 | Filter by: genre, status (reading/completed/draft) | Should | Large libraries |
| FR1.2.5 | Search books by title, author, description | Should | Quick access |
| FR1.2.6 | Swipe to delete with confirmation | Must | Data management |

#### FR1.3: Book Derivatives (Forking)
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR1.3.1 | User can create derivative from existing book | Must | Key differentiator |
| FR1.3.2 | Derivative inherits structure (chapters, TOC) | Must | Preserve structure |
| FR1.3.3 | Derivative content is independently editable | Must | No cross-pollution |
| FR1.3.4 | Track parent-child relationship in metadata | Should | Lineage tracking |
| FR1.3.5 | Show derivative indicator in library | Should | Visual distinction |

### FR2: Content Structure

#### FR2.1: Table of Contents
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR2.1.1 | User can generate TOC prompt for LLM | Must | Core workflow |
| FR2.1.2 | User can paste LLM-generated TOC | Must | Core workflow |
| FR2.1.3 | System parses TOC into chapter list | Must | Structure extraction |
| FR2.1.4 | User can manually add/edit/delete chapters | Must | Manual override |
| FR2.1.5 | User can reorder chapters via drag-and-drop | Should | Structure editing |
| FR2.1.6 | Support nested sections (chapters > sections) | Should | Complex books |

#### FR2.2: Chapter Management
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR2.2.1 | Each chapter has: title, summary, content | Must | Core data model |
| FR2.2.2 | Chapter status: empty, draft, generated, reviewed | Must | Workflow tracking |
| FR2.2.3 | User can generate chapter prompt | Must | Core workflow |
| FR2.2.4 | User can paste LLM-generated chapter content | Must | Core workflow |
| FR2.2.5 | User can edit chapter content manually | Must | Refinement |
| FR2.2.6 | System tracks chapter word count | Should | Progress metric |
| FR2.2.7 | System estimates reading time | Should | UX enhancement |

### FR3: LLM Integration

#### FR3.1: Prompt Generation
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR3.1.1 | Generate book outline prompt with user preferences | Must | Core feature |
| FR3.1.2 | Generate chapter prompt with full context | Must | Core feature |
| FR3.1.3 | Include previous chapters summary for context | Must | Coherence |
| FR3.1.4 | Include character list, setting, tone parameters | Should | Consistency |
| FR3.1.5 | Include user's style/language preferences | Must | Personalization |
| FR3.1.6 | User can preview prompt before sharing | Must | Transparency |
| FR3.1.7 | User can edit prompt before sharing | Should | Customization |

#### FR3.2: Context Management
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR3.2.1 | Store book-level context (setting, characters, themes) | Must | Consistency engine |
| FR3.2.2 | Auto-update context from generated content | Should | Living document |
| FR3.2.3 | User can manually edit context | Must | Override capability |
| FR3.2.4 | Show context token count estimate | Should | LLM awareness |
| FR3.2.5 | Smart context pruning for long books | Should | Token management |

#### FR3.3: Intent Sharing
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR3.3.1 | Share prompt via Android Intent (text/plain) | Must | Core mechanism |
| FR3.3.2 | Support sharing to any app (ChatGPT, Claude, etc.) | Must | LLM agnostic |
| FR3.3.3 | Receive shared text from LLM apps | Must | Paste workflow |
| FR3.3.4 | Smart paste detection (TOC vs content) | Should | UX improvement |
| FR3.3.5 | Maintain deep link back to context | Should | Seamless workflow |

#### FR3.4: User Preferences
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR3.4.1 | Set preferred writing style | Must | Personalization |
| FR3.4.2 | Set preferred language | Must | Internationalization |
| FR3.4.3 | Set preferred tone (formal, casual, etc.) | Must | Voice consistency |
| FR3.4.4 | Set vocabulary level (simple, advanced) | Should | Accessibility |
| FR3.4.5 | Set favorite author for style reference | Should | Style guidance |
| FR3.4.6 | Preferences apply to all prompts by default | Must | Convenience |
| FR3.4.7 | Per-book preference overrides | Should | Flexibility |

#### FR3.5: API Key Management (BYOK)
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR3.5.1 | Securely store API keys locally | Must | Future-proofing |
| FR3.5.2 | Support multiple providers (OpenAI, Anthropic, etc.) | Should | Flexibility |
| FR3.5.3 | Keys never leave device (except to provider) | Must | Security |
| FR3.5.4 | Keys stored in Android Keystore | Must | Platform security |
| FR3.5.5 | Test API key validity | Should | User feedback |

### FR4: Reading Experience

#### FR4.1: Reader View
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR4.1.1 | Display chapter content with proper typography | Must | Core reading |
| FR4.1.2 | Customizable font size | Must | Accessibility |
| FR4.1.3 | Customizable font family | Should | Personalization |
| FR4.1.4 | Light/Dark/Sepia themes | Must | Comfort |
| FR4.1.5 | Adjustable line spacing | Should | Readability |
| FR4.1.6 | Adjustable margins | Should | Screen utilization |
| FR4.1.7 | Keep screen awake while reading | Should | UX |

#### FR4.2: Navigation
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR4.2.1 | Swipe or tap to turn pages | Must | Core interaction |
| FR4.2.2 | Progress bar with percentage | Must | Orientation |
| FR4.2.3 | Jump to chapter via TOC | Must | Navigation |
| FR4.2.4 | "Go to" specific position | Should | Precision |
| FR4.2.5 | Remember last read position | Must | Continuity |
| FR4.2.6 | Reading history (recently read) | Should | Convenience |

#### FR4.3: Bookmarks
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR4.3.1 | Add bookmark at current position | Must | Core feature |
| FR4.3.2 | View list of bookmarks | Must | Navigation |
| FR4.3.3 | Jump to bookmark | Must | Navigation |
| FR4.3.4 | Add optional note to bookmark | Should | Context |
| FR4.3.5 | Delete bookmark | Must | Management |
| FR4.3.6 | Bookmark indicator on page | Should | Visual feedback |

#### FR4.4: Highlights
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR4.4.1 | Select text and highlight | Must | Core feature |
| FR4.4.2 | Multiple highlight colors | Should | Organization |
| FR4.4.3 | View all highlights | Must | Review |
| FR4.4.4 | Jump to highlight in context | Must | Navigation |
| FR4.4.5 | Add note to highlight | Should | Annotation |
| FR4.4.6 | Delete highlight | Must | Management |
| FR4.4.7 | Export highlights | Should | External use |

#### FR4.5: Notes
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR4.5.1 | Add margin note at position | Must | Core feature |
| FR4.5.2 | View all notes | Must | Review |
| FR4.5.3 | Edit notes | Must | Refinement |
| FR4.5.4 | Delete notes | Must | Management |
| FR4.5.5 | Note indicator in reader | Should | Visual feedback |
| FR4.5.6 | Export notes | Should | External use |

#### FR4.6: Progress Tracking
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR4.6.1 | Track reading position per book | Must | Core feature |
| FR4.6.2 | Calculate and display % complete | Must | Progress indicator |
| FR4.6.3 | Track time spent reading | Should | Statistics |
| FR4.6.4 | Show estimated time remaining | Should | Planning |
| FR4.6.5 | Reading history log | Could | Analytics |

### FR5: Data Management

#### FR5.1: Local Storage
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR5.1.1 | All data stored locally on device | Must | Core principle |
| FR5.1.2 | SQLite database for structured data | Must | Implementation |
| FR5.1.3 | File system for large content/images | Must | Performance |
| FR5.1.4 | Automatic backup to app-specific storage | Should | Data safety |
| FR5.1.5 | Data migration between app versions | Must | Upgradability |

#### FR5.2: Export
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR5.2.1 | Export single book as JSON | Must | Data portability |
| FR5.2.2 | Export single book as EPUB | Should | Standard format |
| FR5.2.3 | Export single book as Markdown | Should | Developer-friendly |
| FR5.2.4 | Export all books as ZIP | Should | Full backup |
| FR5.2.5 | Include highlights/notes in export | Should | Complete data |
| FR5.2.6 | Share exported file via Intent | Must | Distribution |

#### FR5.3: Import
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR5.3.1 | Import book from JSON | Must | Restore capability |
| FR5.3.2 | Import from plain text file | Should | Content ingestion |
| FR5.3.3 | Conflict detection on import | Should | Data integrity |
| FR5.3.4 | Import all books from backup ZIP | Should | Full restore |

---

## Non-Functional Requirements

### NFR1: Performance
| ID | Requirement | Target | Notes |
|----|-------------|--------|-------|
| NFR1.1 | App cold start time | < 2 seconds | First impression |
| NFR1.2 | Library load time (100 books) | < 1 second | Responsiveness |
| NFR1.3 | Chapter render time | < 500ms | Reading fluidity |
| NFR1.4 | Search response time | < 1 second | Usability |
| NFR1.5 | Memory usage (reading) | < 200MB | Device compatibility |

### NFR2: Storage
| ID | Requirement | Target | Notes |
|----|-------------|--------|-------|
| NFR2.1 | App size (APK) | < 30MB | Download friction |
| NFR2.2 | Per-book storage overhead | < 5% | Efficiency |
| NFR2.3 | Image compression | Automatic | Space management |

### NFR3: Reliability
| ID | Requirement | Target | Notes |
|----|-------------|--------|-------|
| NFR3.1 | Crash-free rate | > 99.5% | Stability |
| NFR3.2 | Data loss prevention | 100% | Critical |
| NFR3.3 | Auto-save frequency | Every edit | No work loss |

### NFR4: Security
| ID | Requirement | Target | Notes |
|----|-------------|--------|-------|
| NFR4.1 | API keys encrypted at rest | Yes | Platform Keystore |
| NFR4.2 | No telemetry without consent | Yes | Privacy |
| NFR4.3 | No network calls without user action | Yes | Offline-first |

### NFR5: Usability
| ID | Requirement | Target | Notes |
|----|-------------|--------|-------|
| NFR5.1 | Minimum Android version | API 24 (Android 7.0) | Market coverage |
| NFR5.2 | Accessibility compliance | WCAG 2.1 AA | Inclusivity |
| NFR5.3 | RTL language support | Yes | Internationalization |
| NFR5.4 | Dark mode support | System + Manual | User preference |

### NFR6: Maintainability
| ID | Requirement | Target | Notes |
|----|-------------|--------|-------|
| NFR6.1 | Code test coverage | > 70% | Quality |
| NFR6.2 | Documentation coverage | All public APIs | Maintainability |
| NFR6.3 | Modular architecture | Feature-based | Scalability |

---

## Data Model Overview

```
Book
├── id: UUID
├── title: String
├── subtitle: String?
├── author: String?
├── description: String?
├── coverPath: String?
├── genre: String?
├── status: Enum (draft, reading, completed)
├── parentBookId: UUID? (for derivatives)
├── createdAt: DateTime
├── updatedAt: DateTime
├── context: BookContext
│   ├── setting: String?
│   ├── characters: List<Character>
│   ├── themes: List<String>
│   ├── style: String?
│   └── customPromptContext: String?
├── chapters: List<Chapter>
│   ├── id: UUID
│   ├── title: String
│   ├── summary: String?
│   ├── content: String?
│   ├── status: Enum (empty, draft, generated, reviewed)
│   ├── orderIndex: Int
│   ├── wordCount: Int
│   └── sections: List<Section>?
├── readingProgress: ReadingProgress
│   ├── lastChapterId: UUID?
│   ├── lastPosition: Int
│   ├── percentComplete: Double
│   └── lastReadAt: DateTime?
├── bookmarks: List<Bookmark>
│   ├── id: UUID
│   ├── chapterId: UUID
│   ├── position: Int
│   ├── note: String?
│   └── createdAt: DateTime
├── highlights: List<Highlight>
│   ├── id: UUID
│   ├── chapterId: UUID
│   ├── startPosition: Int
│   ├── endPosition: Int
│   ├── text: String
│   ├── color: String
│   ├── note: String?
│   └── createdAt: DateTime
└── notes: List<Note>
    ├── id: UUID
    ├── chapterId: UUID
    ├── position: Int
    ├── content: String
    └── createdAt: DateTime

UserPreferences
├── writingStyle: String
├── language: String
├── tone: String
├── vocabularyLevel: String
├── favoriteAuthor: String?
├── readerFontSize: Int
├── readerFontFamily: String
├── readerTheme: Enum (light, dark, sepia)
├── readerLineSpacing: Double
└── readerMargins: Int

APIKey
├── id: UUID
├── provider: Enum (openai, anthropic, custom)
├── encryptedKey: Bytes
├── label: String
└── createdAt: DateTime
```

---

## Acceptance Criteria Summary

### MVP Launch Criteria
- [ ] User can create, view, and manage books in library
- [ ] User can generate and share TOC prompts via Intent
- [ ] User can paste and parse TOC from LLM response  
- [ ] User can generate and share chapter prompts via Intent
- [ ] User can paste chapter content from LLM response
- [ ] User can read books with basic reader controls
- [ ] User can bookmark, highlight, and add notes
- [ ] Reading progress is tracked automatically
- [ ] User can export books as JSON
- [ ] User can set and save style preferences
- [ ] User can create derivative books
- [ ] App works offline (except Intent sharing)

---

*See [USER_STORIES.md](./USER_STORIES.md) for detailed user stories and acceptance criteria.*
