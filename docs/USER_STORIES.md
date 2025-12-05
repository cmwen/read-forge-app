# ReadForge - User Stories

---
**Created**: December 6, 2025  
**Version**: 1.0  
**Status**: Initial Draft  
**Related**: [PRODUCT_VISION.md](./PRODUCT_VISION.md), [REQUIREMENTS_MVP.md](./REQUIREMENTS_MVP.md)  
---

## User Personas

### Persona 1: Sarah - The Creative Reader
- **Age**: 34
- **Occupation**: Marketing Manager
- **Tech Comfort**: Moderate
- **Goal**: Create personalized bedtime stories for her children
- **Pain Points**: Generic books don't reflect her family's values; LLM-generated content is disorganized
- **Quote**: *"I want stories that teach my kids lessons specific to our family, but I'm not a writer."*

### Persona 2: Marcus - The Language Learner
- **Age**: 28
- **Occupation**: Software Developer
- **Tech Comfort**: High
- **Goal**: Generate reading material in Spanish at his level
- **Pain Points**: Hard to find content at intermediate level; textbooks are boring
- **Quote**: *"I learn better from stories than textbooks, but finding graded readers in topics I care about is impossible."*

### Persona 3: Dr. Amelia - The Educator
- **Age**: 52
- **Occupation**: University Professor
- **Tech Comfort**: Moderate
- **Goal**: Create customized case study materials for her classes
- **Pain Points**: Outdated textbooks; copyright restrictions on existing materials
- **Quote**: *"I need examples that reflect current industry practices, not 10-year-old case studies."*

### Persona 4: Jake - The Privacy Advocate
- **Age**: 41
- **Occupation**: IT Security Consultant
- **Tech Comfort**: Very High
- **Goal**: Use AI tools without giving away his data
- **Pain Points**: Cloud-based tools store his content; concerned about training data usage
- **Quote**: *"I want to use AI, but I want my content to stay on my device."*

---

## Epic 1: Library Management

### US1.1: Create New Book
**As a** creative reader  
**I want to** create a new book with a title and basic information  
**So that** I can start organizing my content creation project

**Acceptance Criteria:**
- [ ] Tapping "Create Book" opens a form with title field (required)
- [ ] Form includes optional fields: subtitle, author, description, genre
- [ ] User can select or capture a cover image
- [ ] Submitting creates the book and navigates to book detail view
- [ ] Book appears in library with cover (or placeholder) and title
- [ ] Created timestamp is automatically recorded

**Priority**: Must Have  
**Story Points**: 5

---

### US1.2: View Book Library
**As a** user with multiple books  
**I want to** see all my books in an organized library view  
**So that** I can quickly find and access any book

**Acceptance Criteria:**
- [ ] Library displays books in grid view by default
- [ ] Each book shows: cover image, title, reading progress bar
- [ ] Toggle between grid and list view
- [ ] List view additionally shows: author, last read date
- [ ] Empty state shows helpful onboarding message
- [ ] Pull to refresh updates any changed metadata

**Priority**: Must Have  
**Story Points**: 5

---

### US1.3: Search and Filter Books
**As a** user with many books  
**I want to** search and filter my library  
**So that** I can quickly find specific books

**Acceptance Criteria:**
- [ ] Search bar at top of library
- [ ] Search matches: title, author, description
- [ ] Results update as user types (debounced)
- [ ] Filter chips for: genre, status (draft/reading/completed)
- [ ] Sort options: title A-Z, created date, last read, progress
- [ ] Filters and search can be combined
- [ ] Clear all filters button

**Priority**: Should Have  
**Story Points**: 3

---

### US1.4: Delete Book
**As a** user  
**I want to** delete books I no longer need  
**So that** I can keep my library organized

**Acceptance Criteria:**
- [ ] Swipe left on book reveals delete option
- [ ] Long press opens context menu with delete option
- [ ] Confirmation dialog warns about permanent deletion
- [ ] Dialog shows book title for verification
- [ ] Undo option available for 5 seconds after deletion
- [ ] All related data (chapters, bookmarks, etc.) is deleted

**Priority**: Must Have  
**Story Points**: 2

---

### US1.5: Create Derivative Book
**As a** language learner  
**I want to** create a variation of an existing book  
**So that** I can have the same structure in a different language or style

**Acceptance Criteria:**
- [ ] Book detail has "Create Derivative" option
- [ ] Dialog allows selecting what to copy: structure only, or structure + context
- [ ] New book is created with "(Derivative)" suffix in title
- [ ] User can rename the derivative immediately
- [ ] Derivative shows link to parent book
- [ ] Parent book shows count of derivatives
- [ ] Editing derivative doesn't affect parent

**Priority**: Must Have  
**Story Points**: 5

---

## Epic 2: Content Generation

### US2.1: Generate Table of Contents
**As a** creative reader  
**I want to** generate a table of contents prompt  
**So that** I can ask an LLM to structure my book

**Acceptance Criteria:**
- [ ] "Generate TOC" button in empty book view
- [ ] System builds prompt including: book title, description, user preferences
- [ ] Prompt preview shows full text before sharing
- [ ] User can edit prompt before sharing
- [ ] "Share to LLM" opens Android share sheet
- [ ] Prompt is shared as plain text

**Priority**: Must Have  
**Story Points**: 3

---

### US2.2: Import TOC from LLM Response
**As a** user who received an LLM response  
**I want to** paste and parse the table of contents  
**So that** my book structure is created automatically

**Acceptance Criteria:**
- [ ] "Paste TOC" button in book view
- [ ] Large text input area for pasting
- [ ] System attempts to parse numbered/bulleted list into chapters
- [ ] Preview shows parsed chapters before confirming
- [ ] User can edit chapter titles before confirming
- [ ] Confirming creates chapter entries
- [ ] Error message if parsing fails with manual entry option

**Priority**: Must Have  
**Story Points**: 5

---

### US2.3: Generate Chapter Content Prompt
**As a** user writing a book  
**I want to** generate a prompt for a specific chapter  
**So that** I can ask an LLM to write that chapter with proper context

**Acceptance Criteria:**
- [ ] Chapter view has "Generate Content" button
- [ ] Prompt includes: book context, previous chapters summary, chapter title
- [ ] Prompt includes: user's style, tone, language preferences
- [ ] Token count estimate shown (approximate)
- [ ] User can preview and edit prompt
- [ ] Share button opens Android share sheet
- [ ] For long context, system suggests which chapters to summarize

**Priority**: Must Have  
**Story Points**: 8

---

### US2.4: Import Chapter Content
**As a** user who received chapter content from LLM  
**I want to** paste it into the appropriate chapter  
**So that** my book progresses

**Acceptance Criteria:**
- [ ] Chapter view has "Paste Content" button
- [ ] Large text input area for pasting
- [ ] Preview shows formatted content
- [ ] Confirm replaces (or appends to) existing content
- [ ] Chapter status updates to "generated"
- [ ] Word count and reading time update
- [ ] Book context is optionally updated with new characters/settings

**Priority**: Must Have  
**Story Points**: 5

---

### US2.5: Manage Book Context
**As a** user generating multi-chapter content  
**I want to** maintain and edit the book's context  
**So that** LLM-generated content remains consistent

**Acceptance Criteria:**
- [ ] Book has "Context" section accessible from menu
- [ ] Context includes: setting, characters list, themes, custom notes
- [ ] Each character has: name, description, relationships
- [ ] User can manually add/edit/delete any context item
- [ ] Context is included in all chapter prompts
- [ ] Toggle to include/exclude specific context in next prompt
- [ ] "Summarize from content" suggests context updates

**Priority**: Must Have  
**Story Points**: 8

---

## Epic 3: User Preferences

### US3.1: Set Writing Style Preferences
**As a** user  
**I want to** configure my preferred writing style  
**So that** all generated prompts reflect my preferences

**Acceptance Criteria:**
- [ ] Settings screen with "Writing Preferences" section
- [ ] Language selection (dropdown with common languages)
- [ ] Writing style (dropdown: descriptive, concise, poetic, technical)
- [ ] Tone (dropdown: formal, casual, humorous, serious)
- [ ] Vocabulary level (slider: simple to advanced)
- [ ] Preferences saved locally and persist across sessions
- [ ] Preferences automatically included in prompts

**Priority**: Must Have  
**Story Points**: 3

---

### US3.2: Set Favorite Author Reference
**As a** user who appreciates specific writing styles  
**I want to** optionally specify a favorite author  
**So that** the LLM can emulate that style (with disclaimer)

**Acceptance Criteria:**
- [ ] Optional "Style Inspiration" field in preferences
- [ ] Text field for author name
- [ ] Disclaimer shown: "For style inspiration only, not reproduction"
- [ ] When set, prompts include: "Write in a style inspired by [author]"
- [ ] Can be cleared at any time
- [ ] Per-book override available

**Priority**: Should Have  
**Story Points**: 2

---

### US3.3: Store API Keys (BYOK)
**As a** privacy-conscious user  
**I want to** store my own LLM API keys  
**So that** I can use direct API integration in the future

**Acceptance Criteria:**
- [ ] Settings screen has "API Keys" section
- [ ] Can add keys for: OpenAI, Anthropic, Custom
- [ ] Keys are encrypted using Android Keystore
- [ ] Keys are masked in UI (show last 4 characters)
- [ ] Can delete stored keys
- [ ] Keys never transmitted except to their respective provider
- [ ] Note: MVP uses Intent sharing; direct API is future feature

**Priority**: Must Have  
**Story Points**: 5

---

## Epic 4: Reading Experience

### US4.1: Read Chapter Content
**As a** user who has generated content  
**I want to** read my book in a comfortable reader view  
**So that** I can enjoy the content I've created

**Acceptance Criteria:**
- [ ] Tapping chapter opens full-screen reader
- [ ] Content displays with proper typography (paragraphs, spacing)
- [ ] Tap left/right edges or swipe to navigate pages
- [ ] Progress bar at bottom shows position in chapter
- [ ] Tap center reveals top/bottom toolbars
- [ ] Top toolbar: back button, chapter title, menu
- [ ] Bottom toolbar: page progress, chapter navigation

**Priority**: Must Have  
**Story Points**: 8

---

### US4.2: Customize Reader Appearance
**As a** reader with visual preferences  
**I want to** customize the reader's appearance  
**So that** reading is comfortable for my eyes

**Acceptance Criteria:**
- [ ] Reader menu has "Appearance" option
- [ ] Font size: slider from 12pt to 36pt
- [ ] Font family: 5+ options including serif and sans-serif
- [ ] Theme: Light, Dark, Sepia
- [ ] Line spacing: slider from 1.0 to 2.0
- [ ] Margins: slider from small to large
- [ ] Settings preview in real-time
- [ ] Settings persist across sessions

**Priority**: Must Have  
**Story Points**: 5

---

### US4.3: Navigate Within Book
**As a** reader  
**I want to** easily navigate to different parts of the book  
**So that** I can jump to specific chapters or return to where I was

**Acceptance Criteria:**
- [ ] Table of Contents accessible from reader menu
- [ ] TOC shows all chapters with completion status
- [ ] Tapping chapter navigates directly to it
- [ ] Current chapter highlighted in TOC
- [ ] "Resume" button returns to last read position
- [ ] Book automatically opens to last position

**Priority**: Must Have  
**Story Points**: 3

---

### US4.4: Add Bookmark
**As a** reader  
**I want to** bookmark important pages  
**So that** I can return to them later

**Acceptance Criteria:**
- [ ] Bookmark icon in reader toolbar
- [ ] Tapping adds/removes bookmark at current position
- [ ] Visual indicator when page is bookmarked
- [ ] Optional: add note when bookmarking
- [ ] Bookmarks list accessible from menu
- [ ] Tap bookmark in list to navigate to position
- [ ] Swipe to delete bookmark

**Priority**: Must Have  
**Story Points**: 3

---

### US4.5: Highlight Text
**As a** reader  
**I want to** highlight important passages  
**So that** I can remember and review key content

**Acceptance Criteria:**
- [ ] Long press to select text
- [ ] Selection handles appear for adjustment
- [ ] Context menu shows: Highlight, Copy, Add Note
- [ ] Highlight colors: Yellow, Green, Blue, Pink
- [ ] Highlighted text remains visible on subsequent reads
- [ ] Highlights list accessible from menu
- [ ] Can add note to existing highlight
- [ ] Tap highlight in list to navigate to context

**Priority**: Must Have  
**Story Points**: 5

---

### US4.6: Add Notes
**As a** reader  
**I want to** add my own notes at specific positions  
**So that** I can record my thoughts while reading

**Acceptance Criteria:**
- [ ] Can add note without selecting text
- [ ] Note icon appears in margin at note position
- [ ] Tapping note icon shows note content
- [ ] Can edit or delete note
- [ ] Notes list accessible from menu
- [ ] Tap note in list to navigate to position
- [ ] Notes exportable separately

**Priority**: Must Have  
**Story Points**: 5

---

### US4.7: Track Reading Progress
**As a** reader  
**I want to** see my reading progress  
**So that** I know how far I've come and how much is left

**Acceptance Criteria:**
- [ ] Progress percentage in reader footer
- [ ] Progress bar in library book card
- [ ] "X minutes remaining" estimate in reader
- [ ] Reading sessions tracked (optional statistic)
- [ ] Progress syncs immediately as user reads
- [ ] Completion celebrated when book finished

**Priority**: Must Have  
**Story Points**: 3

---

## Epic 5: Data Management

### US5.1: Export Single Book
**As a** user who values data ownership  
**I want to** export a book to a file  
**So that** I have a backup and can use the content elsewhere

**Acceptance Criteria:**
- [ ] Book menu has "Export" option
- [ ] Export format options: JSON, EPUB, Markdown
- [ ] Export includes: content, structure, bookmarks, highlights, notes
- [ ] Progress indicator during export
- [ ] Share sheet opens with exported file
- [ ] Can save to device storage
- [ ] EPUB readable in standard e-readers

**Priority**: Must Have (JSON), Should Have (EPUB, Markdown)  
**Story Points**: 8

---

### US5.2: Export All Books
**As a** user migrating or backing up  
**I want to** export my entire library  
**So that** I have a complete backup of all my work

**Acceptance Criteria:**
- [ ] Settings has "Export All" option
- [ ] Creates ZIP file with all books as JSON
- [ ] Includes: all books, preferences, API keys (encrypted)
- [ ] Progress indicator shows book-by-book progress
- [ ] Final file can be shared or saved
- [ ] File size warning if very large

**Priority**: Should Have  
**Story Points**: 5

---

### US5.3: Import Book
**As a** user restoring from backup  
**I want to** import a previously exported book  
**So that** I can recover my content

**Acceptance Criteria:**
- [ ] Settings has "Import" option
- [ ] Supports JSON format from export
- [ ] Preview shows book info before confirming
- [ ] Duplicate detection by book ID
- [ ] Option to replace or create new on duplicate
- [ ] Success/error feedback after import

**Priority**: Must Have  
**Story Points**: 5

---

### US5.4: Export Highlights and Notes
**As a** reader who takes notes  
**I want to** export just my highlights and notes  
**So that** I can review them outside the app

**Acceptance Criteria:**
- [ ] Book menu has "Export Annotations" option
- [ ] Format: Markdown or plain text
- [ ] Includes: highlight text, color, note, chapter reference
- [ ] Grouped by chapter
- [ ] Share sheet for export

**Priority**: Should Have  
**Story Points**: 3

---

## Epic 6: Future - P2P Sync (Post-MVP)

### US6.1: Sync Between Devices (Future)
**As a** user with multiple devices  
**I want to** sync my library between devices  
**So that** I can read on any device

**Acceptance Criteria:**
- [ ] Device pairing via QR code or local network discovery
- [ ] Peer-to-peer sync (no cloud server)
- [ ] Conflict resolution for concurrent edits
- [ ] Selective sync (choose which books)
- [ ] Sync status indicator

**Priority**: Future (Post-MVP)  
**Story Points**: 21

---

## Story Map Summary

### MVP Release (v1.0)

| Priority | Epic | User Stories |
|----------|------|--------------|
| Critical | Library | US1.1, US1.2, US1.4 |
| Critical | Generation | US2.1, US2.2, US2.3, US2.4, US2.5 |
| Critical | Reading | US4.1, US4.2, US4.3, US4.7 |
| High | Library | US1.3, US1.5 |
| High | Preferences | US3.1, US3.3 |
| High | Reading | US4.4, US4.5, US4.6 |
| High | Data | US5.1, US5.3 |
| Medium | Preferences | US3.2 |
| Medium | Data | US5.2, US5.4 |

### Post-MVP
- P2P Sync (US6.1)
- Direct LLM API Integration
- Voice/TTS Features
- Additional Platforms

---

*This document contains user stories for development. See [REQUIREMENTS_MVP.md](./REQUIREMENTS_MVP.md) for technical requirements.*
