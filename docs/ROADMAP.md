# ReadForge - Product Roadmap

---
**Created**: December 6, 2025  
**Version**: 1.0  
**Status**: Planning  
**Related**: [PRODUCT_VISION.md](./PRODUCT_VISION.md), [REQUIREMENTS_MVP.md](./REQUIREMENTS_MVP.md), [USER_STORIES.md](./USER_STORIES.md)  
---

## Release Timeline

```
2024 Q4                2025 Q1                2025 Q2                2025 Q3
   │                      │                      │                      │
   ▼                      ▼                      ▼                      ▼
┌──────────┐         ┌──────────┐         ┌──────────┐         ┌──────────┐
│  v0.1    │         │  v1.0    │         │  v1.5    │         │  v2.0    │
│  Alpha   │ ──────► │   MVP    │ ──────► │Enhanced  │ ──────► │  Sync    │
│          │         │          │         │          │         │          │
└──────────┘         └──────────┘         └──────────┘         └──────────┘
   Dev                 Launch               Polish               Growth
```

---

## v0.1 - Alpha (Development)

**Goal**: Core infrastructure and basic workflows

**Target**: 4-6 weeks from start

### Features
- [x] Project setup and architecture
- [ ] Local database (SQLite/Drift)
- [ ] Book CRUD operations
- [ ] Basic chapter management
- [ ] Simple prompt generation
- [ ] Android Intent sharing
- [ ] Basic reader view (no customization)
- [ ] Minimal viable UI

### Success Criteria
- Can create a book, generate TOC prompt, paste result
- Can generate chapter prompts and paste content
- Can read content in basic reader

---

## v1.0 - MVP Launch

**Goal**: Feature-complete for core use cases

**Target**: 8-10 weeks from start

### Features

#### Library Management
- [ ] Book creation with metadata
- [ ] Cover image support
- [ ] Grid/list library views
- [ ] Search and filter
- [ ] Sort options
- [ ] Delete with confirmation
- [ ] Derivative books (forking)

#### Content Generation
- [ ] TOC prompt generation
- [ ] TOC parsing from paste
- [ ] Chapter prompt generation
- [ ] Context management (characters, setting, themes)
- [ ] Previous chapters summarization
- [ ] Token count estimation

#### User Preferences
- [ ] Writing style preferences
- [ ] Language selection
- [ ] Tone and vocabulary settings
- [ ] Favorite author (optional)
- [ ] BYOK API key storage

#### Reading Experience
- [ ] Full-screen reader
- [ ] Font size/family customization
- [ ] Light/Dark/Sepia themes
- [ ] Line spacing and margins
- [ ] Tap/swipe navigation
- [ ] Progress tracking
- [ ] Bookmarks
- [ ] Highlights with colors
- [ ] Notes

#### Data Management
- [ ] JSON export (single book)
- [ ] JSON import
- [ ] Export highlights/notes

### Success Criteria
- Complete end-to-end workflow
- Reading experience comparable to basic e-readers
- All data exportable
- < 2 critical bugs
- 4+ star average in early feedback

---

## v1.1 - Polish

**Goal**: UX improvements based on MVP feedback

**Target**: 2-3 weeks after MVP

### Features
- [ ] Onboarding tutorial
- [ ] Improved TOC parsing (more formats)
- [ ] Undo/redo in editor
- [ ] Reading statistics
- [ ] Chapter auto-summary generation
- [ ] UI/UX refinements

---

## v1.5 - Enhanced

**Goal**: Expanded export and usability

**Target**: 4-6 weeks after v1.1

### Features

#### Enhanced Export
- [ ] EPUB export
- [ ] Markdown export
- [ ] PDF export
- [ ] Full library backup (ZIP)
- [ ] Custom cover templates

#### Enhanced Reading
- [ ] Text-to-speech integration
- [ ] Reading goals and streaks
- [ ] Chapter audio generation
- [ ] Dictionary lookup (offline)

#### Enhanced Generation
- [ ] Direct LLM API integration (OpenAI, Anthropic)
- [ ] In-app generation (with BYOK)
- [ ] Streaming responses
- [ ] Prompt templates library

### Success Criteria
- EPUB works in major e-readers
- TTS works for all content
- API integration stable

---

## v2.0 - Sync & Community

**Goal**: Multi-device and optional community features

**Target**: 8-10 weeks after v1.5

### Features

#### P2P Sync
- [ ] Device discovery (local network)
- [ ] QR code pairing
- [ ] Selective book sync
- [ ] Conflict resolution
- [ ] Sync status and history

#### Community (Optional)
- [ ] Share book templates (structure only)
- [ ] Import community templates
- [ ] Template ratings

#### Platform Expansion
- [ ] Desktop (Linux) via Flutter
- [ ] iOS preparation (if viable)

### Success Criteria
- Sync works reliably between 2+ Android devices
- No data loss in conflict scenarios
- Template sharing works

---

## Future Considerations (v2.5+)

### Potential Features
- **Plugin System**: Extensibility for advanced users
- **Web Companion**: View library on web (read-only)
- **AI Illustrations**: Generate cover art and illustrations
- **Collaborative Books**: Multi-user book creation
- **Audio Books**: Full audiobook generation
- **Import Existing**: Import PDF/EPUB to fork structure
- **Translation Mode**: Generate same book in multiple languages
- **Study Mode**: Flashcards from highlights

### Platform Expansion
- iOS (App Store considerations)
- macOS/Windows desktop
- E-ink device support (if technically feasible)

---

## Risk Assessment

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| LLM context limits | High | High | Smart summarization, modular context |
| Android Intent limitations | Medium | Medium | Fallback to clipboard |
| Large book performance | Medium | Medium | Lazy loading, pagination |
| EPUB complexity | Medium | Low | Third-party library, phased rollout |
| P2P sync complexity | High | Medium | Extensive testing, conflict logging |
| API cost for BYOK | Low | Low | User's own keys, their choice |

---

## Resource Requirements

### Development
- 1 Flutter developer (full-time)
- 1 UX designer (part-time, v0.1-v1.0)
- 1 QA (part-time, all versions)

### Infrastructure
- GitHub repository
- CI/CD (GitHub Actions)
- Beta testing (Firebase App Distribution or similar)
- No cloud infrastructure (local-first)

### Third-Party Services
- None required for MVP (local-first)
- Post-MVP: LLM APIs (user's keys)

---

## Key Decisions Required

| Decision | Options | Recommendation | Status |
|----------|---------|----------------|--------|
| Database | SQLite/Drift vs Hive vs Isar | Drift (SQL power, type-safe) | Pending |
| State Management | Provider vs Riverpod vs BLoC | Riverpod (modern, testable) | Pending |
| EPUB Library | epub_flutter vs custom | epub_flutter | Pending |
| Reader Engine | Custom Flutter vs WebView | Custom Flutter (control) | Pending |
| P2P Protocol | Custom vs libp2p | Research needed | Future |

---

## Metrics & KPIs

### MVP Launch
- **Activation**: % users who create first book
- **Engagement**: Books created per user
- **Retention**: D7, D30 retention
- **Quality**: Crash-free rate, ANR rate

### Post-Launch
- **Content Velocity**: Chapters generated per week
- **Reading Engagement**: Hours read per week
- **Export Rate**: % books exported
- **Derivative Rate**: % books forked

---

*This roadmap is subject to change based on user feedback and resource availability.*
