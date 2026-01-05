# Ollama Integration - Visual Reference Guide

**Quick visual guide for UI designers and developers**

---

## 1. Mode Selector (Primary UX Pattern)

### Visual Layout
```
┌───────────────────────────────────────────────┐
│  Choose generation method:                    │
│                                               │
│  ┌─────────────────────────────────────────┐ │
│  │ 📋 Paste from ChatGPT                   │ │
│  │ Use your preferred AI assistant         │ │
│  │                              [SELECTED] │ │
│  └─────────────────────────────────────────┘ │
│                                               │
│  ┌─────────────────────────────────────────┐ │
│  │ 🤖 Ollama (Connected)                   │ │
│  │ Local generation - llama3.2             │ │
│  │                                [READY] │ │
│  └─────────────────────────────────────────┘ │
│                                               │
│                   [GENERATE]                 │
└───────────────────────────────────────────────┘
```

### Card States
```
SELECTED STATE:
┌─────────────────────────────────┐
│ 📋 Paste from ChatGPT           │ ← blueish background
│ Use your preferred AI assistant │ ← darker text
│            [SELECTED badge]     │
└─────────────────────────────────┘

AVAILABLE STATE:
┌─────────────────────────────────┐
│ 🤖 Ollama (Connected)           │ ← white background
│ Local generation - llama3.2     │ ← normal text
│              [READY badge]      │ ← green badge
└─────────────────────────────────┘

OFFLINE STATE:
┌─────────────────────────────────┐
│ 🤖 Ollama (Offline)             │ ← grayed out
│ Can't reach localhost:11434     │ ← grayed out text
│            [OFFLINE badge]      │ ← red badge
└─────────────────────────────────┘

DISABLED STATE:
┌─────────────────────────────────┐
│ 🤖 Ollama (Not Set Up)          │ ← very grayed out
│ Go to Settings to configure     │ ← light text
│      [SET UP REQUIRED badge]    │ ← gray badge
└─────────────────────────────────┘
  (not clickable)
```

---

## 2. Settings - Ollama Configuration Section

### Layout
```
┌───────────────────────────────────────────────────┐
│ ⇦ Settings                                        │
├───────────────────────────────────────────────────┤
│ Writing Preferences                               │
│   • Writing Style        → [dropdown]             │
│   • Content Language     → [dropdown]             │
│   • Tone                 → [dropdown]             │
│   • Vocabulary Level     → [dropdown]             │
│   • Favorite Author      → [text field]           │
│                                                   │
│                                                   │
│ ┌─ Ollama Configuration ────────────────────────┐ │
│ │                                               │ │
│ │ Connection Status:                            │ │
│ │ 🟢 Connected to localhost:11434              │ │
│ │    Last checked: 1 min ago                    │ │
│ │                                  [Refresh]   │ │
│ │                                               │ │
│ │ Server URL:                                   │ │
│ │ [http://localhost:11434          ] ✓         │ │
│ │ Tip: Include protocol (http://) and port     │ │
│ │                      [Test Connection]       │ │
│ │                                               │ │
│ │ Model Selection:                              │ │
│ │ [▼ llama3.2 (11B)]                           │ │
│ │                                               │ │
│ │ [Manage Models] [Disconnect from Ollama]    │ │
│ │                                               │ │
│ └───────────────────────────────────────────────┘ │
│                                                   │
│ App Preferences                                   │
│   • Theme                → [light / dark / auto] │
│   • Language             → [English]             │
└───────────────────────────────────────────────────┘
```

---

## 3. Generation Loading State

### Visual Progress
```
┌───────────────────────────────────────────────┐
│ X                                             │
├───────────────────────────────────────────────┤
│                                               │
│    ⟳ Generating content...                   │
│                                               │
│    🤖 Using: llama3.2 (local)                │
│    ⟳ Streaming response...                   │
│                                               │
│    ┌─────────────────────────────────────┐  │
│    │ The future of artificial           │  │
│    │ intelligence lies in collaborative │  │
│    │ systems that combine the best of   │  │
│    │ human and machine capabilities.    │  │
│    │ Early research shows promising     │  │
│    │ results in medical diagnosis,      │  │
│    │ scientific discovery, and [...]    │  │
│    └─────────────────────────────────────┘  │
│                                               │
│    Tokens: 145           ⏱ Time: 8.2s        │
│    Speed: 17 tokens/sec                      │
│                                               │
│                    [Cancel Generation]       │
│                                               │
└───────────────────────────────────────────────┘
```

---

## 4. Generation Result

### Display with Attribution
```
┌───────────────────────────────────────────────┐
│ Generated Content                             │
├───────────────────────────────────────────────┤
│                                               │
│ [Full generated content visible here...]      │
│                                               │
│ [More content...]                             │
│                                               │
│ [And more...]                                 │
│                                               │
│ ───────────────────────────────────────────── │
│                                               │
│ 🤖 Generated by: llama3.2 (11B, local)       │
│    Generation time: 21.4s • Speed: 17 t/s    │
│                                               │
│ ───────────────────────────────────────────── │
│                                               │
│ [Edit] [✓ Accept] [↻ Regenerate]            │
│                                               │
│ [Try Different Method]                        │
│                                               │
└───────────────────────────────────────────────┘
```

---

## 5. Error States

### Connection Lost
```
┌───────────────────────────────────────────────┐
│ ⚠️  Connection Lost                           │
├───────────────────────────────────────────────┤
│                                               │
│ Can't reach Ollama at                         │
│ http://localhost:11434                        │
│                                               │
│ Please check:                                 │
│ • Ollama server is running                   │
│ • Network connection is active                │
│ • URL is correct in settings                  │
│                                               │
│                                               │
│           [Try Again]  [Use Copy-Paste]      │
│                                               │
└───────────────────────────────────────────────┘
```

### Invalid URL
```
┌───────────────────────────────────────────────┐
│ Server URL                                    │
│ [192.168.1.100:11434              ] ✗        │
│                                               │
│ ⚠️ URL format error: Protocol required       │
│ Example: http://192.168.1.100:11434         │
│                                               │
│ [Test Connection]                             │
│                                               │
└───────────────────────────────────────────────┘
```

### Model Not Found
```
┌───────────────────────────────────────────────┐
│ ⚠️  Model Not Found                           │
├───────────────────────────────────────────────┤
│                                               │
│ The model "llama3.2" is not currently        │
│ available.                                    │
│                                               │
│ Available models:                             │
│ • qwen2.5 (7B)                               │
│ • mistral (7B)                               │
│ • phi4 (14B)                                 │
│                                               │
│      [Select Different Model]                │
│      [Use Copy-Paste Instead]                │
│                                               │
└───────────────────────────────────────────────┘
```

---

## 6. Connection Status Indicator Variants

### In Settings Panel
```
🟢 CONNECTED                    🔴 OFFLINE                  ⚪ NOT CONFIGURED
Connected to localhost:11434   Offline                     Not Configured
Last checked: 2 min ago        Can't reach 192.168.1.100   Go to Settings
[✓ Success]                    [× Error]                   [⚠ Setup needed]

🟡 TESTING
Testing connection...
Checking localhost:11434
[⟳ In progress...]
```

### As Badge (On Mode Selector)
```
┌─────────────────────────────┐
│ 🤖 Ollama (Connected)       │
│ ... [READY - green badge]   │ ← Connected
└─────────────────────────────┘

┌─────────────────────────────┐
│ 🤖 Ollama (Offline)         │
│ ... [OFFLINE - red badge]   │ ← Offline
└─────────────────────────────┘

┌─────────────────────────────┐
│ 🤖 Ollama (Not Set Up)      │
│ ... [SETUP REQUIRED - gray] │ ← Not configured
└─────────────────────────────┘
```

---

## 7. Color Reference

### Status Colors
```
Connected:     🟢 #4CAF50 (Light) / #66BB6A (Dark)
               On white: GREEN text + GREEN circle indicator

Offline:       🔴 #F44336 (Light) / #EF5350 (Dark)
               On white: RED text + RED circle indicator

Testing:       🟡 #FFC107 (Light) / #FFB74D (Dark)
               On white: AMBER text + AMBER circle indicator

Not Config:    ⚪ #BDBDBD (Light) / #757575 (Dark)
               On white: GRAY text + GRAY circle indicator
```

### Component Colors
```
Primary Button:        colorScheme.primary (deep orange)
Outline Button:        colorScheme.outline
Card Surface:          colorScheme.surface
Card Selected:         colorScheme.primaryContainer
Text Primary:          colorScheme.onSurface
Text Secondary:        colorScheme.onSurfaceVariant
Divider:               colorScheme.outlineVariant
Error:                 colorScheme.error
```

---

## 8. Typography Hierarchy

```
DIALOG TITLES
24sp, weight 600, primary color
"Choose generation method:"

CARD TITLES
16sp, weight 600, primary color when selected
"📋 Paste from ChatGPT"
"🤖 Ollama (Connected)"

CARD SUBTITLES
14sp, weight 400, onSurfaceVariant
"Use your preferred AI assistant"
"Local generation - llama3.2"

BODY TEXT
14sp, weight 400, onSurface
[Generated content appears here]

SMALL LABELS
12sp, weight 500, onSurfaceVariant
"Last checked: 2 min ago"
"Tokens: 145"
```

---

## 9. Touch Target Sizing

```
Large Buttons (Primary actions):
┌──────────────────┐
│  [GENERATE]      │  ← 56dp height × full width
└──────────────────┘

Mode Selector Cards:
┌──────────────────────────────┐
│ 📋 Paste from ChatGPT        │  ← 64dp height minimum
│ Use your preferred...        │     48dp minimum touch target
└──────────────────────────────┘

Standard Buttons:
┌────────────┐
│ [Edit]     │  ← 48dp height
└────────────┘

Icon Buttons:
┌──┐
│🔄│  ← 48dp × 48dp minimum
└──┘

Small Icons:
🔄 ← 24dp (decorative)
```

---

## 10. Spacing Grid

```
16dp Padding:
┌────────────────────────────────┐
│ Content                        │
│ [16dp from edge]               │
└────────────────────────────────┘

12dp Between Items:
├─ Item 1
├─ [12dp gap]
├─ Item 2
├─ [12dp gap]
└─ Item 3

24dp Section Spacing:
┌──────────────────────┐
│ Section A            │
└──────────────────────┘
[24dp gap]
┌──────────────────────┐
│ Section B            │
└──────────────────────┘
```

---

## 11. User Journey Quick Map

```
NEW USER:
Settings → Ollama Config → Enter URL → Test → Select Model → Done
    ↓
Next Generate → Mode Selector → Pick Ollama → Generate

EXISTING USER (Ollama Available):
Generate → Mode Selector → Pick Ollama → Content → Accept

EXISTING USER (Ollama Offline):
Generate → Mode Selector → Pick Ollama → Error → Try Copy-Paste

MODE SWITCHER:
Using Ollama → Not Happy → [Try Different Method] → Copy-Paste Mode
```

---

## 12. Animation Timings

```
Button press:          100ms scale (0.98x)
Card elevation change: 150ms easeInOut
Modal fade in:         200ms easeInOut
Status badge update:   300ms easeInOut
Streaming content:     No discrete jumps (smooth continuous)
Error appearance:      300ms fadeIn
Loading spinner:       1500ms rotation (continuous)
```

---

## 13. Responsive Breakpoints

```
PHONE (< 600dp):
┌─────────────────────────┐
│ Full width buttons      │
│ Single column layout    │
│ Compact spacing (12dp)  │
│ Bottom sheet dialogs    │
└─────────────────────────┘

TABLET (600-840dp):
┌───────────────────────────────────┐
│ Side-by-side buttons (50% + gap)  │
│ Two column layout where relevant   │
│ Standard spacing (16-24dp)        │
└───────────────────────────────────┘

DESKTOP (> 840dp):
┌─────────────────────────────────────────┐
│ Multi-column layout                     │
│ Wide content areas                      │
│ Generous spacing (24-32dp)             │
│ Floating dialogs instead of bottom sheet│
└─────────────────────────────────────────┘
```

---

## 14. State Flow Diagram

```
START: App Loads
  │
  ├─ First Time? → Settings → Ollama Config → Testing → Connected/Offline
  │                                                          │
  │                                                          ↓
  └─────────────────────────────────────→ User Taps Generate
                                              │
                                    ┌─────────┴──────────┐
                                    │                    │
                                    ↓                    ↓
                          [📋 Paste]         [🤖 Ollama]
                              │                    │
                     Paste Interface         Streaming...
                              │                    │
                              └──────┬─────────────┘
                                     │
                              Result Display
                                     │
                          ┌──────────┴──────────┐
                          │                     │
                     Accept?              Try Different?
                          │                     │
                          ✓                  [Switch Mode]
                                                 │
                                        [Restart Generation]
```

---

## 15. Icon Reference

| Purpose | Icon | Fallback |
|---------|------|----------|
| Copy-Paste | Icons.description | 📋 |
| Ollama | Icons.smart_toy | 🤖 |
| Settings | Icons.settings | ⚙️ |
| Connection OK | Icons.check_circle | ✓ |
| Connection Error | Icons.error | ✗ |
| Testing | Icons.schedule | ⟳ |
| Model | Icons.smart_toy | 🤖 |
| Edit | Icons.edit | ✏️ |
| Delete | Icons.delete | 🗑️ |
| Refresh | Icons.refresh | 🔄 |
| Language | Icons.language | 🌐 |
| Info | Icons.info | ℹ️ |
| Close | Icons.close | ✕ |

---

## 16. Accessibility Quick Check

```
✅ Color Contrast:
   Text on background: 4.5:1 minimum
   All status indicators use both color AND icon

✅ Touch Targets:
   All buttons: 48dp × 48dp minimum
   Cards: 64dp height minimum

✅ Semantic Labels:
   "Connected to Ollama at localhost:11434"
   "Ollama status: offline"
   "Generate using Ollama llama3.2 model"

✅ Keyboard Navigation:
   Tab through controls in logical order
   Enter/Space to activate
   Arrow keys for dropdowns
   Escape to dismiss dialogs

✅ Screen Reader:
   All status changes announced
   Form labels descriptive
   Error messages read clearly
   Progress announced during generation
```

---

## Quick Copy-Paste Hex Colors

```dart
// Status colors
const green = Color(0xFF4CAF50);     // Connected
const red = Color(0xFFF44336);       // Offline
const amber = Color(0xFFFFC107);     // Testing
const gray = Color(0xFFBDBDDB);      // Not configured

// Material DeepOrange (default seed)
const primary = Color(0xFFFF5722);
const darkPrimary = Color(0xFFE64A19);
```

---

**Version**: 1.0  
**Updated**: January 5, 2026  
**Purpose**: Quick visual reference for implementation
