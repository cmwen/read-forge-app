# ReadForge - User Experience Design

---
**Created**: December 6, 2025  
**Version**: 1.0  
**Status**: Design Phase  
**Related**: [PRODUCT_VISION.md](./PRODUCT_VISION.md), [REQUIREMENTS_MVP.md](./REQUIREMENTS_MVP.md), [USER_STORIES.md](./USER_STORIES.md)  
---

## Design Principles

### 1. Local-First Transparency
Users should always know their data is on-device and exportable. Trust through visibility.

### 2. Progressive Disclosure
Start simple, reveal complexity as needed. Don't overwhelm beginners, empower advanced users.

### 3. Context is King
The app maintains context so LLMs can generate coherent content. Show context clearly.

### 4. Reader-First
Generation is a means to an end. Reading experience must be exceptional.

### 5. Intent-Bridge Pattern
The Intent sharing workflow is unique—make it feel natural and seamless.

---

## Information Architecture

```
ReadForge App
│
├── 📚 Library (Home)
│   ├── My Books (Grid/List)
│   ├── Search & Filter
│   └── Create New Book
│
├── 📖 Book Detail
│   ├── Book Info & Metadata
│   ├── Table of Contents
│   ├── Context Manager
│   ├── Reading Progress
│   └── Actions (Read, Edit, Export, Derive)
│
├── ✏️ Chapter Editor
│   ├── Chapter Content
│   ├── Generate Prompt
│   ├── Paste Content
│   └── Edit Manually
│
├── 📄 Reader
│   ├── Chapter Content View
│   ├── Navigation (TOC, Progress)
│   ├── Annotations (Bookmarks, Highlights, Notes)
│   └── Appearance Settings
│
└── ⚙️ Settings
    ├── Writing Preferences
    ├── Reader Preferences
    ├── API Keys (BYOK)
    └── Data Management (Import/Export)
```

---

## User Flows

### Flow 1: First-Time User - Create First Book

```
1. Launch App
   └─► Empty State with Onboarding
       └─► "Create Your First Book" CTA

2. Tap "Create Book"
   └─► Book Creation Form
       ├─ Title (required)
       ├─ Subtitle (optional)
       ├─ Cover Image (camera/gallery)
       ├─ Genre
       └─ Description

3. Save Book
   └─► Book Detail View (empty TOC)
       └─► Onboarding Tooltip: "Generate table of contents to start"

4. Tap "Generate TOC"
   └─► TOC Prompt Settings
       ├─ Show user preferences
       ├─ Preview prompt
       └─ "Share to LLM" button

5. Share via Intent
   └─► Android Share Sheet
       └─► Select LLM app (ChatGPT, Claude, etc.)

6. User copies LLM response
   └─► Return to ReadForge (deep link or manual)

7. Tap "Paste TOC"
   └─► Parse TOC
       ├─ Show preview of parsed chapters
       ├─ Edit if needed
       └─ Confirm

8. TOC Created
   └─► Book Detail with Chapter List
       └─► Tap chapter to generate content
```

**Key UX Decisions:**
- Onboarding integrated into natural workflow
- Clear call-to-action at each step
- Preview before committing
- Edit capabilities throughout

---

### Flow 2: Generate Chapter Content

```
1. Book Detail View
   └─► Tap Chapter (status: empty)

2. Chapter Editor Opens
   └─► Empty state with "Generate Content" CTA

3. Tap "Generate Content"
   └─► Context Review Screen
       ├─ Show what will be included:
       │  ├─ Book metadata
       │  ├─ Previous chapters summary
       │  ├─ Characters & setting
       │  └─ User preferences
       ├─ Token count estimate
       └─► "Customize" or "Continue"

4. Tap "Continue"
   └─► Prompt Preview
       ├─ Scrollable full prompt
       ├─ Edit button (advanced)
       └─► "Share to LLM"

5. Share via Intent
   └─► Android Share Sheet
       └─► Select LLM app

6. User receives LLM response
   └─► Copy to clipboard

7. Return to ReadForge
   └─► Chapter Editor

8. Tap "Paste Content"
   └─► Content Preview
       ├─ Formatted display
       ├─ Word count
       ├─ Reading time estimate
       └─► "Save" or "Discard"

9. Save Content
   └─► Chapter status → "generated"
   └─► Optional: "Extract context" suggestion
       └─► Auto-detect new characters/settings
```

**Key UX Decisions:**
- Context review builds trust in prompt quality
- Token estimate manages expectations
- Preview prevents accidental saves
- Auto-extraction reduces manual work

---

### Flow 3: Reading Experience

```
1. Book Detail View
   └─► Tap "Read" or Resume

2. Reader Opens
   ├─► Full-screen content
   ├─► Status bar: time, battery
   ├─► Top bar (auto-hide): back, chapter title, menu
   └─► Bottom bar (auto-hide): progress, page number

3. Navigation
   ├─ Tap edges → Turn page
   ├─ Swipe → Turn page
   ├─ Tap center → Toggle toolbars
   └─ Tap progress bar → Scrubber

4. Interactions
   ├─ Long press text → Select
   │  └─► Context menu:
   │      ├─ Highlight (color picker)
   │      ├─ Add Note
   │      └─ Copy
   │
   ├─ Tap bookmark icon → Add/remove bookmark
   │  └─► Optional: Add note
   │
   └─ Tap menu → Options
       ├─ Table of Contents
       ├─ Bookmarks List
       ├─ Highlights List
       ├─ Notes List
       └─ Appearance Settings

5. Exit Reader
   └─► Position auto-saved
   └─► Return to Book Detail
```

**Key UX Decisions:**
- Auto-hiding UI maximizes reading space
- Multiple navigation methods (tap, swipe) suit different preferences
- Context menu at point of selection
- Immediate feedback for all actions

---

### Flow 4: Create Derivative Book

```
1. Book Detail View
   └─► Menu → "Create Derivative"

2. Derivative Options Dialog
   ├─ Copy structure only (TOC)
   ├─ Copy structure + context
   └─ Copy structure + context + content
       (with editable text)

3. Select option and confirm
   └─► New book created
       ├─ Title: "[Original Title] (Derivative)"
       ├─ All settings copied
       └─► Immediate rename prompt

4. Rename Derivative
   └─► Edit title
       └─► Example: "Spanish Version" or "Simplified Edition"

5. Customize Context
   └─► Context Manager
       ├─ Update language preference
       ├─ Modify tone/style
       └─► Save

6. Generate New Content
   └─► Follow standard chapter generation flow
       └─► Prompts use updated context
```

**Key UX Decisions:**
- Clear options about what's copied
- Immediate rename prevents confusion
- Context editable before generation
- Original book remains untouched

---

## Screen Designs

### Screen 1: Library (Home)

**Layout: Grid View**
```
┌─────────────────────────────────────┐
│ ☰  Library          🔍  ⋮           │ ← App bar
├─────────────────────────────────────┤
│ ┌─────────┐ ┌─────────┐ ┌─────────┐│
│ │  Cover  │ │  Cover  │ │  Cover  ││
│ │  Image  │ │  Image  │ │  Image  ││
│ │         │ │         │ │         ││
│ └─────────┘ └─────────┘ └─────────┘│
│  Book Title  Book Title  Book Title │
│  ▓▓▓░░ 60%  ▓▓░░░ 45%   ░░░░░ 0%   │ ← Progress
│                                     │
│ ┌─────────┐ ┌─────────┐ ┌─────────┐│
│ │  Cover  │ │  Cover  │ │  Cover  ││
│ │  Image  │ │  Image  │ │  Image  ││
│ │         │ │         │ │         ││
│ └─────────┘ └─────────┘ └─────────┘│
│  Book Title  Book Title  Book Title │
│  ▓▓▓▓▓ 100% ▓░░░░ 25%   ▓▓▓░░ 70%  │
│                                     │
└─────────────────────────────────────┘
│          [+] Create Book            │ ← FAB
└─────────────────────────────────────┘
```

**Layout: List View**
```
┌─────────────────────────────────────┐
│ ☰  Library          🔍  ⋮           │
├─────────────────────────────────────┤
│ ┌───┐                               │
│ │ C │  Book Title                  ↗│ ← Derivative indicator
│ │ V │  by Author Name               │
│ │ R │  ▓▓▓▓░░░░░░ 45% • Ch 4/10     │
│ └───┘  Last read 2 hours ago        │
├─────────────────────────────────────┤
│ ┌───┐                               │
│ │ C │  Another Book Title           │
│ │ V │  by Another Author            │
│ │ R │  ▓▓▓▓▓▓▓▓▓▓ 100% • Completed  │
│ └───┘  Finished 3 days ago          │
├─────────────────────────────────────┤
│ ┌───┐                               │
│ │ C │  Third Book                   │
│ │ V │  No author                    │
│ │ R │  ░░░░░░░░░░ 0% • Not started  │
│ └───┘  Created today                │
└─────────────────────────────────────┘
```

**Features:**
- Toggle grid/list view (icon in app bar)
- Search bar expands when tapped
- Sort/filter in menu (⋮)
- Swipe left on item → Delete (with confirmation)
- Long press → Context menu (Edit, Derive, Export, Delete)

**Empty State:**
```
┌─────────────────────────────────────┐
│                                     │
│             📚                      │
│                                     │
│      Your Library Awaits            │
│                                     │
│  Create your first AI-generated     │
│  book and start reading             │
│                                     │
│      [Create Your First Book]       │
│                                     │
└─────────────────────────────────────┘
```

---

### Screen 2: Book Detail

```
┌─────────────────────────────────────┐
│ ←  Book Title                  ⋮    │ ← Menu: Derive, Export, Delete
├─────────────────────────────────────┤
│ ┌─────────────────┐                 │
│ │                 │  Book Title     │
│ │   Book Cover    │  Subtitle       │
│ │     Image       │  by Author      │
│ │                 │                 │
│ │                 │  Fantasy • Draft│
│ └─────────────────┘                 │
│                                     │
│  📝 "Book description here..."      │
│                                     │
│  ▓▓▓▓▓░░░░░░░░ 35% Complete         │
│                                     │
├─────────────────────────────────────┤
│  📚 Table of Contents               │
│  ┌─────────────────────────────────┐│
│  │ ✓ 1. The Beginning         3500w││ ← Checkmark = completed
│  │ ✓ 2. The Journey           4200w││
│  │ ⚪ 3. The Discovery         0w  ││ ← Empty = not started
│  │ ⚪ 4. The Revelation        0w  ││
│  │ ⚪ 5. The Climax            0w  ││
│  │ ⚪ 6. The Resolution        0w  ││
│  └─────────────────────────────────┘│
│                                     │
│  [Generate TOC] (if empty)          │
│  [Paste TOC]    (if empty)          │
│                                     │
├─────────────────────────────────────┤
│  🎭 Context                    >    │ ← Expandable section
│  🔖 Bookmarks (5)              >    │
│  ✨ Highlights (12)            >    │
│  📝 Notes (8)                  >    │
├─────────────────────────────────────┤
│  [Continue Reading]  [Start Reading]│ ← Primary action
└─────────────────────────────────────┘
```

**Interactions:**
- Tap chapter → Open chapter editor
- Tap completed chapter → Jump to reader at that chapter
- Tap "Context" → Open context manager
- Tap bookmarks/highlights/notes → View list
- Swipe chapter left → Options (Regenerate, Delete)

---

### Screen 3: Chapter Editor

```
┌─────────────────────────────────────┐
│ ←  Chapter 3: The Discovery    ⋮    │ ← Menu: Generate, Paste, Edit
├─────────────────────────────────────┤
│ Status: Empty                       │
│ 0 words • 0 min read                │
├─────────────────────────────────────┤
│                                     │
│   ┌─────────────────────────────┐   │
│   │                             │   │
│   │      🤖                      │   │
│   │                             │   │
│   │  Generate content with AI   │   │
│   │                             │   │
│   │  [Generate Prompt]          │   │
│   │                             │   │
│   └─────────────────────────────┘   │
│                                     │
│   ┌─────────────────────────────┐   │
│   │                             │   │
│   │      📋                      │   │
│   │                             │   │
│   │  Paste from LLM response    │   │
│   │                             │   │
│   │  [Paste Content]            │   │
│   │                             │   │
│   └─────────────────────────────┘   │
│                                     │
│   ┌─────────────────────────────┐   │
│   │                             │   │
│   │      ✏️                      │   │
│   │                             │   │
│   │  Write manually             │   │
│   │                             │   │
│   │  [Start Writing]            │   │
│   │                             │   │
│   └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

**When Content Exists:**
```
┌─────────────────────────────────────┐
│ ←  Chapter 3: The Discovery    ⋮    │
├─────────────────────────────────────┤
│ Status: Generated                   │
│ 2,450 words • 12 min read           │
├─────────────────────────────────────┤
│                                     │
│  Chapter content appears here       │
│  with proper formatting and         │
│  paragraph breaks. The content      │
│  is displayed in a readable         │
│  format with...                     │
│                                     │
│  [Show more]                        │
│                                     │
├─────────────────────────────────────┤
│  [Read Chapter]  [Edit Content]     │
└─────────────────────────────────────┘
```

---

### Screen 4: Prompt Generation

```
┌─────────────────────────────────────┐
│ ←  Generate Prompt                  │
├─────────────────────────────────────┤
│  📊 Context Summary                 │
│  ┌─────────────────────────────────┐│
│  │ Previous chapters: 2             ││
│  │ Characters: 3                    ││
│  │ Settings: 2 locations            ││
│  │ Themes: Adventure, Discovery     ││
│  │                                  ││
│  │ Estimated tokens: ~650           ││
│  └─────────────────────────────────┘│
│                                     │
│  ℹ️ Your writing preferences        │
│  ┌─────────────────────────────────┐│
│  │ Language: English                ││
│  │ Style: Descriptive               ││
│  │ Tone: Adventurous                ││
│  │ Vocabulary: Moderate             ││
│  └─────────────────────────────────┘│
│                                     │
│  [Customize Context]                │
│                                     │
│  📝 Prompt Preview                  │
│  ┌─────────────────────────────────┐│
│  │ I need you to write the         ││
│  │ content for a chapter in a      ││
│  │ book.                           ││
│  │                                 ││
│  │ ## Book Information             ││
│  │ - Title: My Adventure           ││
│  │ ...                             ││
│  │                                 ││
│  │ [Expand to see full prompt]     ││
│  └─────────────────────────────────┘│
│                                     │
│  [Edit Prompt (Advanced)]           │
│                                     │
├─────────────────────────────────────┤
│  [Share to LLM App]                 │ ← Primary action
└─────────────────────────────────────┘
```

**After sharing:**
```
┌─────────────────────────────────────┐
│  ✓ Prompt shared!                   │
│                                     │
│  📱 Waiting for LLM response...     │
│                                     │
│  Steps:                             │
│  1. ✓ Prompt shared to LLM          │
│  2. ⏳ Generate content in LLM app   │
│  3. ⏳ Copy response                 │
│  4. ⏳ Return to ReadForge           │
│  5. ⏳ Paste content                 │
│                                     │
│  [I've copied the response]         │
│                                     │
└─────────────────────────────────────┘
```

---

### Screen 5: Context Manager

```
┌─────────────────────────────────────┐
│ ←  Book Context                ⋮    │
├─────────────────────────────────────┤
│  📍 Setting                         │
│  ┌─────────────────────────────────┐│
│  │ A medieval fantasy kingdom      ││
│  │ with magic and dragons. The     ││
│  │ capital city sits on a cliff... ││
│  │                      [Edit]     ││
│  └─────────────────────────────────┘│
│                                     │
│  👥 Characters                  [+] │
│  ┌─────────────────────────────────┐│
│  │ • Aria (Protagonist)             ││
│  │   Young mage discovering powers  ││
│  │                                  ││
│  │ • Master Theron                  ││
│  │   Aria's mentor and guide        ││
│  │                                  ││
│  │ • The Shadow                     ││
│  │   Mysterious antagonist          ││
│  └─────────────────────────────────┘│
│                                     │
│  🎨 Themes & Motifs             [+] │
│  ┌─────────────────────────────────┐│
│  │ • Coming of age                  ││
│  │ • Power and responsibility       ││
│  │ • Finding inner strength         ││
│  └─────────────────────────────────┘│
│                                     │
│  📝 Custom Context Notes            │
│  ┌─────────────────────────────────┐│
│  │ This story emphasizes personal  ││
│  │ growth over action. Keep magic  ││
│  │ system consistent with...        ││
│  │                      [Edit]     ││
│  └─────────────────────────────────┘│
│                                     │
│  [Extract from Chapters]            │
│  [Save Changes]                     │
└─────────────────────────────────────┘
```

---

### Screen 6: Reader View

```
┌─────────────────────────────────────┐
│ ←  Ch 1: The Beginning         ☰ ⋮ │ ← Auto-hide top bar
├─────────────────────────────────────┤
│                                     │
│    The morning sun cast golden     │
│    rays across the valley as        │
│    Aria stood at the edge of the    │
│    cliff. She had never felt        │
│    more alone, yet strangely at     │
│    peace with the silence.          │
│                                     │
│    Below her, the kingdom           │
│    stretched out like a tapestry    │
│    of greens and browns. In the     │
│    distance, she could see the      │
│    smoke rising from the capital.   │
│    Home. But was it really home     │
│    anymore?                         │
│                                     │
│    "You're thinking too loudly,"    │
│    a voice said behind her.         │
│                                     │
│    She didn't need to turn          │
│    around. She knew that voice      │
│    anywhere.                        │
│                                     │
│    "Master Theron," she said        │
│    softly. "I wasn't expecting—"    │
│                                     │
├─────────────────────────────────────┤
│ ▓▓▓▓▓▓▓░░░░░░░░░░░░  35% │ 🔖  ⚙️ │ ← Auto-hide bottom bar
└─────────────────────────────────────┘
    Page 12 of 34
```

**Reader Menu (tap ⋮):**
```
┌─────────────────────────────────────┐
│  📖 Table of Contents               │
│  🔖 Bookmarks (5)                   │
│  ✨ Highlights (12)                 │
│  📝 Notes (8)                       │
│  ──────────────────────                │
│  👁 Appearance                      │
│  ℹ️ Book Info                       │
│  📤 Share                           │
└─────────────────────────────────────┘
```

**Text Selection:**
```
┌─────────────────────────────────────┐
│                                     │
│    The morning sun cast golden     │
│    rays across the valley as        │
│  ┌─Aria stood at the edge of the──┐ │
│  │ cliff. She had never felt       │ │
│  │ more alone, yet strangely at    │ │
│  └─peace with the silence.─────────┘ │
│    ◉                           ◉    │ ← Selection handles
│                                     │
│  ┌───────────────────────────────┐  │
│  │ 💛 Highlight                  │  │ ← Context menu
│  │ 📝 Add Note                   │  │
│  │ 📋 Copy                       │  │
│  └───────────────────────────────┘  │
│                                     │
└─────────────────────────────────────┘
```

**Highlight Color Picker:**
```
┌─────────────────────────────────────┐
│  Choose highlight color:            │
│                                     │
│  ⬤ Yellow    ⬤ Green    ⬤ Blue     │
│  ⬤ Pink      ⬤ Orange   ⬤ Purple   │
│                                     │
│  📝 Add note (optional)             │
│  ┌─────────────────────────────────┐│
│  │ Type your note here...          ││
│  └─────────────────────────────────┘│
│                                     │
│  [Cancel]              [Highlight]  │
└─────────────────────────────────────┘
```

---

### Screen 7: Reader Appearance

```
┌─────────────────────────────────────┐
│ ←  Appearance                       │
├─────────────────────────────────────┤
│  Preview                            │
│  ┌─────────────────────────────────┐│
│  │ The morning sun cast golden    ││ ← Live preview
│  │ rays across the valley as       ││
│  │ Aria stood at the edge...       ││
│  └─────────────────────────────────┘│
│                                     │
│  Font Size                          │
│  ├───────●─────────────┤  18pt      │
│  12pt                        36pt   │
│                                     │
│  Font Family                        │
│  [ Merriweather ▼ ]                 │
│  • Merriweather (Serif)             │
│  • Open Sans (Sans-serif)           │
│  • Roboto Slab                      │
│  • Georgia                          │
│  • System Default                   │
│                                     │
│  Theme                              │
│  ⬜ Light  ⬛ Dark  🟨 Sepia         │
│                                     │
│  Line Spacing                       │
│  ├───────●─────────────┤  1.5       │
│  1.0                         2.0    │
│                                     │
│  Margins                            │
│  ├───────●─────────────┤  Medium    │
│  Small                      Large   │
│                                     │
│  [Reset to Defaults]                │
└─────────────────────────────────────┘
```

---

### Screen 8: Settings

```
┌─────────────────────────────────────┐
│ ←  Settings                         │
├─────────────────────────────────────┤
│  ✍️ Writing Preferences              │
│  Configure AI generation style      │
│  Language, tone, vocabulary...  >   │
│                                     │
│  📖 Reader Preferences              │
│  Customize reading appearance       │
│  Font, theme, spacing...        >   │
│                                     │
│  🔑 API Keys                        │
│  Manage LLM API keys (BYOK)         │
│  OpenAI, Anthropic, Custom...   >   │
│                                     │
│  💾 Data Management                 │
│  Import, export, backup             │
│  Your data, your control        >   │
│                                     │
│  ℹ️ About                            │
│  Version, licenses, support     >   │
│                                     │
│  ──────────────────────                │
│                                     │
│  🔒 Privacy: All data stored locally│
│  📤 Export your data anytime        │
│                                     │
└─────────────────────────────────────┘
```

**Writing Preferences:**
```
┌─────────────────────────────────────┐
│ ←  Writing Preferences              │
├─────────────────────────────────────┤
│  Language                           │
│  [ English ▼ ]                      │
│  English, Spanish, French, German...│
│                                     │
│  Writing Style                      │
│  [ Descriptive ▼ ]                  │
│  • Descriptive                      │
│  • Concise                          │
│  • Poetic                           │
│  • Technical                        │
│  • Conversational                   │
│                                     │
│  Tone                               │
│  [ Adventurous ▼ ]                  │
│  Formal, Casual, Humorous, Serious...│
│                                     │
│  Vocabulary Level                   │
│  ├───────●─────────────┤  Moderate  │
│  Simple                   Advanced  │
│                                     │
│  Style Inspiration (Optional)       │
│  ┌─────────────────────────────────┐│
│  │ J.R.R. Tolkien                  ││
│  └─────────────────────────────────┘│
│  ℹ️ For style inspiration only      │
│                                     │
│  [Save Preferences]                 │
└─────────────────────────────────────┘
```

---

## Interaction Patterns

### Pattern 1: Intent Bridge

**Challenge**: Users must leave the app to generate content.

**Solution**: Multi-step progress indicator

```
Step Indicator:
1. ✓ Prompt generated
2. ⏳ Share to LLM → [Share button]
3. ⏳ Generate in LLM app
4. ⏳ Copy & return → [Paste button]
```

**Key Features:**
- Clear steps with checkmarks
- Help text for first-time users
- Deep linking to return seamlessly
- Clipboard detection (offer auto-paste)

---

### Pattern 2: Context Awareness

**Visual Language:**
- 🎭 Context icon appears throughout
- Tappable to view/edit context
- Badge shows context item count
- Highlight what's included in prompts

**Example in Chapter Editor:**
```
┌─────────────────────────────────────┐
│  🎭 Context (5 items)           >   │
│  ✓ 2 previous chapters              │
│  ✓ 3 characters                     │
│  ✓ 1 setting                        │
└─────────────────────────────────────┘
```

---

### Pattern 3: Progressive Actions

**Principle**: Start simple, offer advanced options

**Example: Generate TOC**
```
Basic:
[Generate TOC] → Default prompt → Share

Advanced:
[Generate TOC] → Review context → 
  [Customize] → Edit prompt → Share
```

**UI Pattern:**
- Primary action is one-tap
- "Customize" or "Advanced" clearly labeled
- Defaults work for 80% of users
- Power users can dive deep

---

### Pattern 4: Forgiving Workflows

**Undo/Preview Pattern:**

Before commits:
- Preview parsed TOC
- Preview pasted content
- Preview context changes

After commits:
- Undo available (5 seconds)
- Edit always available
- Regenerate option

---

### Pattern 5: Empty States

**Principle**: Guide next action

```
Empty Library:
┌─────────────────────────────────────┐
│         📚                          │
│    Your Library Awaits              │
│    [Create Your First Book]         │
└─────────────────────────────────────┘

Empty TOC:
┌─────────────────────────────────────┐
│         📑                          │
│    No chapters yet                  │
│    [Generate TOC]  [Add Manually]   │
└─────────────────────────────────────┘

Empty Chapter:
┌─────────────────────────────────────┐
│         🤖                          │
│    Ready to generate?               │
│    [Generate Content]               │
└─────────────────────────────────────┘
```

---

## Accessibility Considerations

### Vision
- Minimum font size: 12pt (adjustable to 36pt)
- High contrast themes (Dark mode)
- Semantic colors (not color-alone indicators)
- Screen reader support for all actions

### Motor
- Large tap targets (48x48dp minimum)
- Swipe alternatives for all gestures
- Voice input support
- Adjustable navigation zones

### Cognitive
- Clear, simple language
- Progress indicators
- Undo capabilities
- Consistent patterns

### Internationalization
- RTL language support
- Language-specific typography
- Cultural color considerations
- Locale-aware formatting

---

## Responsive Design

### Portrait (Primary)
- Full-width content
- Bottom sheets for modals
- FAB for primary actions

### Landscape
- Two-pane layout where appropriate
- TOC sidebar + content
- Maximize reading width

### Tablet
- Side-by-side book list + detail
- Expanded reader margins
- Larger typography scale

---

## Animation & Feedback

### Micro-interactions
- Button press: Scale 0.95
- Success: Green checkmark animation
- Error: Red shake animation
- Loading: Skeleton screens

### Transitions
- Screen transitions: 300ms ease-out
- Modal appear: Slide up + fade
- List item actions: Swipe reveal

### Haptics
- Button tap: Light impact
- Success action: Success impact
- Error: Warning impact
- Long press: Medium impact

---

## Dark Patterns to Avoid

### ❌ Don't:
- Hide export functionality
- Make deletion difficult
- Lock features behind paywalls (MVP is free)
- Use confusing language
- Auto-opt-in to telemetry

### ✅ Do:
- Make export prominent
- Confirm destructive actions
- Be transparent about data usage
- Use clear, honest language
- Respect user privacy

---

## Success Metrics

### Usability Metrics
- Time to first book: < 5 minutes
- Time to first chapter: < 10 minutes
- Task completion rate: > 90%
- Error rate: < 5%

### Engagement Metrics
- Reading session length: > 15 minutes
- Return rate: > 3 times per week
- Books completed: > 20% of started
- Derivative creation: > 10% of books

---

*This UX design document guides implementation. Work with @flutter-developer to implement these screens and flows.*
