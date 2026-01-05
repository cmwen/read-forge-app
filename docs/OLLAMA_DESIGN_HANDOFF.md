# Ollama Integration UX Design - Handoff Document

**To**: @flutter-developer  
**From**: @experience-designer  
**Date**: January 5, 2026  
**Status**: ✅ Ready for Implementation  

---

## 📋 What You're Getting

A complete UX design for adding **Ollama model-based content generation** alongside the existing **copy-paste workflow** in ReadForge. Users can now generate content locally using their own Ollama instance, or continue using ChatGPT/copy-paste as before.

### Design Goals ✅
- ✅ **Seamless mode switching** - One tap to switch between methods
- ✅ **No setup burden** - Copy-paste works without any Ollama config
- ✅ **Transparent status** - Always know if Ollama is connected
- ✅ **Graceful fallback** - If Ollama fails, switch to copy-paste instantly
- ✅ **Accessible design** - WCAG AA compliant, keyboard navigable
- ✅ **Material Design 3** - Consistent with ReadForge's design system

---

## 📚 Documentation Package

You have **5 comprehensive design documents**:

### 1️⃣ UX_DESIGN_OLLAMA_INTEGRATION.md (17.9 KB)
**The main design specification**

Contains:
- Design principles and mental models
- Information architecture
- 5 detailed screen wireframes with ASCII mockups
- Interaction patterns and guidelines
- Accessibility specifications (WCAG AA)
- Visual design specs (colors, typography, spacing)
- Error states and recovery flows
- Success metrics

**When to read**: First - gives you the complete design overview

### 2️⃣ USER_FLOW_OLLAMA_GENERATION.md (15.3 KB)
**Real-world user journeys**

Contains:
- 7 complete user journeys with step-by-step flows
  - Journey 1: First-time Ollama setup (5-10 min)
  - Journey 2: Switching between modes (when one fails)
  - Journey 3: Remote Ollama server configuration
  - Journey 4: Error recovery scenarios
  - Journey 5: Model selection and switching
  - Journey 6: Streaming feedback during generation
  - Journey 7: Offline graceful degradation
- Detailed error scenarios
- Accessibility notes for each interaction

**When to read**: Second - understand how real users will interact with the feature

### 3️⃣ OLLAMA_UI_COMPONENTS.md (25.7 KB)
**Implementation specifications with code**

Contains:
- 5 Flutter widget implementations with full code examples:
  1. **ModeCard + ModeSelector** - Two-button mode choice
  2. **ConnectionStatusPanel** - Shows connection status
  3. **OllamaConfigurationPanel** - Settings section
  4. **OllamaGenerationLoader** - Loading state during generation
  5. **GenerationResultCard** - Unified result display
- Material Design 3 specifications (colors, typography, spacing)
- Animation timings and transitions
- Responsive behavior (phone/tablet/desktop)
- State management structure
- Testing scenarios

**When to read**: During implementation - use as reference for component code

### 4️⃣ OLLAMA_VISUAL_REFERENCE.md (16.4 KB)
**Quick visual guide with ASCII diagrams**

Contains:
- ASCII wireframes for all major UI states
- Color palette with hex codes
- Touch target sizing guide
- Spacing grid reference
- Icon reference table
- Quick copy-paste code snippets
- Quick map of user journeys

**When to read**: Quick reference while coding - bookmark this

### 5️⃣ OLLAMA_IMPLEMENTATION_SUMMARY.md (15.1 KB)
**Overview and next steps**

Contains:
- Design philosophy and core principles
- Quick reference for all 3 main documents
- Key features summary
- Information architecture changes
- Implementation roadmap (Phase 1-4)
- State management structure
- Next steps checklist for you
- Questions? guide

**When to read**: If you're overwhelmed - start here for orientation

---

## 🎯 The Design in One Picture

### User Journey (Happy Path)
```
User wants content generated
     ↓
Taps "Generate" button
     ↓
Sees two options:
[📋 Paste from ChatGPT] [🤖 Ollama (Connected)]
     ↓
Chooses Ollama (faster, local)
     ↓
Content streams in word-by-word
     ↓
Shows result with:
  - Generated content
  - Attribution (model name, time taken)
  - Action buttons: [Edit] [✓ Accept] [↻ Regenerate] [Try Different]
     ↓
User taps Accept
     ↓
Content added to book ✅
```

### When Ollama Offline
```
User taps Generate
     ↓
Tries Ollama mode
     ↓
Connection fails:
  ⚠️ Connection Lost
  Can't reach localhost:11434
  
  [Try Again] [Use Copy-Paste Instead]
     ↓
User taps "Use Copy-Paste Instead"
     ↓
Switches instantly to paste interface ✅
```

---

## 🏗️ Architecture Overview

### Minimal Codebase Changes
**Only adding, not removing/breaking existing code:**
- ✅ New settings section: Ollama Configuration
- ✅ Enhanced generation dialog: Mode selector added
- ✅ New state management: Ollama providers
- ✅ New UI components: 5 widgets
- ✅ Copy-paste mode: Completely unchanged

### Information Architecture
```
Settings (unchanged navigation)
├── Writing Preferences (existing)
├── Ollama Configuration (NEW - entire section)
└── App Preferences (existing)

Generate Dialog (enhanced)
├── Mode Selector (NEW - choose copy-paste vs Ollama)
└── Generate button (existing)
```

---

## 🛠️ What You Need to Build

### Phase 1: State Management (Riverpod)
```
ollamaConfigProvider
  ├── Server URL (read/write)
  ├── Selected model (read/write)
  ├── Save/load from SharedPreferences

ollamaConnectionStatusProvider
  ├── Connection status (🟢 Connected / 🔴 Offline / ⚪ Not Configured)
  ├── Last checked timestamp
  ├── Auto-refresh every 30 seconds

ollamaModelsProvider
  ├── List of available models
  ├── Model capabilities

currentGenerationModeProvider
  ├── Which mode user selected (copy-paste vs ollama)
  ├── Persisted preference
```

### Phase 2: UI Components
```
ModeCard
  ├── Icon
  ├── Title + subtitle
  ├── Status badge (🟢 READY / 🔴 OFFLINE / ⚪ SETUP REQUIRED)
  ├── Tap handler

ConnectionStatusPanel
  ├── Status indicator
  ├── URL display
  ├── Last checked time
  ├── Refresh button

OllamaConfigurationPanel
  ├── Connection status display
  ├── URL input + validation
  ├── Test Connection button
  ├── Model dropdown
  ├── Disconnect button

OllamaGenerationLoader
  ├── Animated spinner
  ├── Model name display
  ├── Token count + time + speed
  ├── Streaming content preview
  ├── Cancel button

GenerationResultCard
  ├── Generated content
  ├── Attribution (model name, time, tokens)
  ├── Action buttons (Edit, Accept, Regenerate, Try Different)
```

### Phase 3: Integration
```
Update generationProvider
  ├── Add Ollama generation path
  ├── Implement streaming response
  ├── Handle Ollama errors + fallback

Update generation dialog
  ├── Add mode selector
  ├── Show status badge for each mode
  ├── Route to correct generation flow

Update Settings screen
  ├── Add Ollama Configuration section
  ├── Wire up connection status
  ├── Wire up model selection
```

---

## 📱 Key Screens to Build

### 1. Mode Selector Dialog
```
┌─────────────────────────────────────┐
│ Choose generation method:           │
│                                     │
│ [📋 Paste from ChatGPT]            │
│ [🤖 Ollama (Connected) ← NEW]      │
│                                     │
│ [GENERATE]                          │
└─────────────────────────────────────┘
```
**File**: `lib/features/library/presentation/widgets/generation_mode_selector.dart`

### 2. Ollama Settings Section
```
┌─────────────────────────────────────┐
│ Ollama Configuration                │
│                                     │
│ Status: 🟢 Connected               │
│ URL: [localhost:11434    ]         │
│ Model: [▼ llama3.2]                │
│                                     │
│ [Test Connection]                  │
│ [Disconnect]                       │
└─────────────────────────────────────┘
```
**File**: `lib/features/settings/presentation/widgets/ollama_config_panel.dart`

### 3. Generation Loading State
```
⟳ Generating content...
🤖 Using: llama3.2
[Content streaming...]
Tokens: 145  Time: 8.2s
[Cancel]
```
**File**: `lib/features/library/presentation/widgets/ollama_generation_loader.dart`

---

## ✅ Implementation Checklist

### Phase 1: Setup
- [ ] Read all 5 design documents (start with OLLAMA_IMPLEMENTATION_SUMMARY.md)
- [ ] Understand the user flows (read USER_FLOW_OLLAMA_GENERATION.md)
- [ ] Review component specs (skim OLLAMA_UI_COMPONENTS.md)

### Phase 2: State Management
- [ ] Create Riverpod providers for Ollama config
- [ ] Implement connection status checking
- [ ] Add model listing
- [ ] Wire up SharedPreferences persistence

### Phase 3: UI Components
- [ ] Build ModeCard widget
- [ ] Build ConnectionStatusPanel
- [ ] Build OllamaConfigurationPanel (integrate into Settings screen)
- [ ] Build OllamaGenerationLoader
- [ ] Update GenerationResultCard (support both modes)

### Phase 4: Integration
- [ ] Add mode selector to generation dialog
- [ ] Route to Ollama generation path
- [ ] Implement streaming response display
- [ ] Add error handling and fallback logic
- [ ] Test with real Ollama instance

### Phase 5: Testing
- [ ] Happy path: Setup → Generate → Accept
- [ ] Error path: Connection fails → Fallback to copy-paste
- [ ] Edge cases: URL validation, model switching, offline recovery
- [ ] Accessibility: Keyboard nav, screen reader, contrast

---

## 🎨 Design System Reference

### Colors
```
Connected:     #4CAF50 (green)
Offline:       #F44336 (red)
Testing:       #FFC107 (amber)
Not Config:    #BDBDBD (gray)
```

### Typography
- **Dialog titles**: 24sp, bold
- **Section headers**: 20sp, bold
- **Card titles**: 16sp, semi-bold
- **Body text**: 14sp, regular
- **Labels**: 12sp, semi-bold

### Spacing (8dp grid)
- Section padding: 16dp
- Between sections: 24dp
- Between items: 12dp
- Card gap: 12dp

### Touch Targets
- Buttons: 48dp minimum height
- Cards: 64dp minimum height
- Icons: 24dp (actionable)

---

## 🚨 Common Pitfalls to Avoid

### ❌ Don't
- Make Ollama setup mandatory
- Hide copy-paste option when Ollama is available
- Block the app if Ollama is offline
- Show too much technical information (model architecture, parameters)
- Use only color for status indicators (use icons too)
- Make buttons smaller than 48dp

### ✅ Do
- Keep copy-paste as the default/primary method
- Always show both options in mode selector
- Gracefully fall back to copy-paste on any error
- Show only essential info (model name, connection status, generation time)
- Use color + icon for all status indicators
- Make buttons at least 48dp × 48dp
- Test with keyboard navigation and screen readers

---

## 📞 Questions? Reference Guide

| Question | Answer Location |
|----------|-----------------|
| "What should this screen look like?" | UX_DESIGN_OLLAMA_INTEGRATION.md (wireframes) |
| "How should the user interact with this?" | USER_FLOW_OLLAMA_GENERATION.md (step-by-step journeys) |
| "What Flutter code should I use?" | OLLAMA_UI_COMPONENTS.md (code examples) |
| "What's the quick reference?" | OLLAMA_VISUAL_REFERENCE.md (ASCII diagrams + quick refs) |
| "What are the next steps?" | OLLAMA_IMPLEMENTATION_SUMMARY.md (phases 1-4) |
| "Should we support X feature?" | Check Phase 1-4 roadmap in OLLAMA_IMPLEMENTATION_SUMMARY.md |

---

## 🚀 Getting Started

### Step 1: Orient Yourself (30 min)
1. Read OLLAMA_IMPLEMENTATION_SUMMARY.md (full overview)
2. Skim USER_FLOW_OLLAMA_GENERATION.md (understand user experience)
3. Bookmark OLLAMA_VISUAL_REFERENCE.md (you'll need it while coding)

### Step 2: Deep Dive (1 hour)
1. Read UX_DESIGN_OLLAMA_INTEGRATION.md (complete design)
2. Read OLLAMA_UI_COMPONENTS.md (implementation specs)
3. Review state management structure

### Step 3: Start Building (Follow phases)
1. Phase 1: Create Riverpod providers
2. Phase 2: Build UI components
3. Phase 3: Integrate with generation flow
4. Phase 4: Error handling and polish
5. Phase 5: Testing and accessibility

### Step 4: Reference While Coding
- Use OLLAMA_UI_COMPONENTS.md for component code
- Use OLLAMA_VISUAL_REFERENCE.md for quick lookups
- Use UX_DESIGN_OLLAMA_INTEGRATION.md for design details

---

## 📊 Design Stats

| Metric | Value |
|--------|-------|
| **Documents** | 5 comprehensive guides |
| **Total Pages** | ~85 KB of documentation |
| **User Journeys** | 7 detailed flows |
| **UI Components** | 5 new widgets |
| **Code Examples** | 20+ Dart examples |
| **Wireframes** | 15+ ASCII diagrams |
| **Accessibility Checks** | Full WCAG AA compliance |
| **Implementation Phases** | 5 phases |
| **Estimated Build Time** | 40-60 hours (with testing) |

---

## 🎯 Success Definition

You'll know you've succeeded when:

✅ User can switch between copy-paste and Ollama with 1-2 taps  
✅ Connection status is always visible when needed  
✅ All controls have 48dp+ touch targets  
✅ Keyboard navigation works throughout  
✅ Screen reader can announce status changes  
✅ Copy-paste continues working even if Ollama is offline  
✅ Errors show helpful messages + recovery steps  
✅ Generation streams in real-time (not chunks)  
✅ No existing functionality is broken  
✅ All tests pass (existing + new)  

---

## 📝 Notes for You

- **This is detailed**: 5 documents, 85 KB of design. Use them!
- **Start simple**: Phase 1 state management is the foundation
- **No breaking changes**: All additions, no modifications to existing code
- **Test early**: Build components one at a time and test
- **Accessibility matters**: It's baked into the design from the start
- **Lean on OLLAMA_VISUAL_REFERENCE.md**: Keep it open while coding

---

## 🤝 Collaboration

**Questions during implementation?**
→ Check the relevant design document first (see Questions? Reference Guide above)

**Design refinements?**
→ All decisions are documented with rationale in UX_DESIGN_OLLAMA_INTEGRATION.md

**Want to add a feature?**
→ Check Phase 1-4 roadmap in OLLAMA_IMPLEMENTATION_SUMMARY.md first

---

## 📚 Reading Order Recommendation

1. **This document** (you are here) - 5 min
2. **OLLAMA_IMPLEMENTATION_SUMMARY.md** - 10 min
3. **USER_FLOW_OLLAMA_GENERATION.md** - 20 min (read journeys 1-3 deeply, skim 4-7)
4. **UX_DESIGN_OLLAMA_INTEGRATION.md** - 30 min (deep dive)
5. **OLLAMA_UI_COMPONENTS.md** - Reference while building (20 min per component)
6. **OLLAMA_VISUAL_REFERENCE.md** - Keep open while coding

**Total prep time**: ~2 hours  
**Then**: Start Phase 1 implementation

---

## ✨ Final Thoughts

This design is focused on **simplicity** and **user experience**. The core insight is that Ollama should be **optional** and **convenient**, not required or complex.

Every design decision serves one of these principles:
- **Effortless**: Can user accomplish task with minimal taps/clicks?
- **Transparent**: Does user always know what's happening?
- **Graceful**: Does app handle errors without disruption?
- **Progressive**: Is basic use simple, advanced use discoverable?
- **Accessible**: Can all users interact with the feature?

Use these principles as a guide when making decisions during implementation.

---

**Ready to build? Start with OLLAMA_IMPLEMENTATION_SUMMARY.md** 🚀

---

**Document Version**: 1.0  
**Status**: ✅ Ready for Implementation  
**Last Updated**: January 5, 2026  
**Prepared by**: @experience-designer  
**For**: @flutter-developer
