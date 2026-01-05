# Ollama Content Generation Flow

## Overview
This document describes the workflow for generating content (TOC and chapters) using Ollama when configured and a model is selected in ReadForge.

## Current Architecture

### Components
1. **OllamaConfigurationPanel** - Settings UI for Ollama configuration
2. **OllamaClient** - Ollama API client from ollama_toolkit
3. **UnifiedGenerationService** - Unified service for both Ollama and copy-paste generation
4. **LLMIntegrationService** - Prompt generation and response parsing
5. **GenerationMode** - Enum for toggling between ollama and copyPaste modes

### Configuration State
```dart
// From ollama_providers.dart
final ollamaConfigProvider = NotifierProvider<OllamaConfigNotifier, OllamaConfig>
final ollamaConnectionStatusProvider = FutureProvider<OllamaConnectionStatus>
final ollamaModelsProvider = FutureProvider<List<OllamaModelInfo>>
final generationModeProvider = NotifierProvider<GenerationModeNotifier, GenerationMode>
```

## Content Generation Flow

### 1. Initial Configuration (One-time)
```
User Opens Settings
    ↓
User Enters Server URL (e.g., http://localhost:11434)
    ↓
Click "Test Connection"
    ↓
Config Provider Updates (serverUrl changed)
    ↓
OllamaConnectionStatusProvider Detects Change
    ↓
Automatically Tests Connection
    ↓
Shows Connection Status (Connected ✓)
    ↓
Loads Available Models (ollamaModelsProvider)
    ↓
User Selects a Model
    ↓
Config Saved (selectedModel updated)
```

### 2. TOC Generation with Ollama

#### 2.1 User Initiates TOC Generation
```
User in Book Detail Screen
    ↓
Clicks "Generate TOC" Button
    ↓
_generateTOCPrompt() Called
    ↓
Two Paths Based on Generation Mode:
```

#### 2.2a: Copy-Paste Mode (Current Implementation)
```
Generate Prompt with LLMIntegrationService
    ↓
Show Dialog:
  - Display Prompt Preview
  - Options: Share, Copy, Cancel
    ↓
User Chooses Action:
  - Share: Opens System Share Sheet
  - Copy: Copies to Clipboard
    ↓
User Manually Pastes to LLM App
    ↓
User Gets Response and Returns to App
    ↓
User Pastes Response in "Import TOC" Dialog
    ↓
LLMIntegrationService Parses Response
    ↓
Creates TOCResponse with Chapters
    ↓
Saves to Database
```

#### 2.2b: Ollama Mode (New Implementation - In Progress)
```
Check Ollama Configuration:
  - Is Ollama Enabled? ✓
  - Is Model Selected? ✓
  - Is Server Connected? ✓
    ↓
IF All Checks Pass:
  Generate Prompt with LLMIntegrationService
    ↓
  Pass to UnifiedGenerationService.generate()
    ↓
  UnifiedGenerationService:
    - Calls OllamaClient.chat(selectedModel, prompt)
    - Gets Response from Ollama
    ↓
  Parse Response with LLMIntegrationService
    ↓
  Create TOCResponse with Chapters
    ↓
  Show Loading Indicator During Generation
    ↓
  Display Result to User:
    - Show Generated TOC Preview
    - Allow: Save, Edit, Cancel
    ↓
  User Confirms
    ↓
  Save to Database
    ↓
  Navigate Back to Book with Chapters Loaded
```

### 3. Chapter Generation with Ollama

#### 3.1 User Initiates Chapter Generation
```
User in Book Detail Screen
    ↓
Clicks "Generate Chapter" for Specific Chapter
    ↓
_generateChapterPrompt() Called
    ↓
Check Ollama Status (same as TOC)
```

#### 3.2a: Copy-Paste Mode
```
Generate Chapter Prompt with Context:
  - Book Title & Description
  - Chapter Number & Title
  - Previous Chapters (for context)
  - User Writing Preferences
    ↓
Show Dialog with Preview
    ↓
User Shares/Copies Prompt
    ↓
User Gets Response from LLM App
    ↓
User Pastes in "Import Chapter" Dialog
    ↓
Parse and Save Chapter
```

#### 3.2b: Ollama Mode
```
Generate Chapter Prompt with Context
    ↓
Pass to UnifiedGenerationService.generate()
    ↓
OllamaClient generates chapter with streaming:
  - await ollamaClient.chat(selectedModel, prompt)
  - Or: Stream via chatStream() for real-time display
    ↓
LLMIntegrationService parses response:
  - Extract title, summary, content
    ↓
Create ChapterResponse
    ↓
Show Generation Progress with Loading Indicator
    ↓
Display Generated Chapter:
  - Preview with Formatting
  - Show Option to Edit, Save, or Discard
    ↓
User Saves Chapter
    ↓
Store in Database
```

## Implementation Status

### ✅ Completed Components
- [x] OllamaClient integration (ollama_toolkit)
- [x] OllamaConfig domain model
- [x] OllamaConfigPersistenceService
- [x] OllamaConfigurationPanel (Settings UI)
- [x] Connection status monitoring
- [x] Model selection
- [x] GenerationMode provider (ollama vs copyPaste)
- [x] UnifiedGenerationService (basic structure)
- [x] ollama_providers (Riverpod setup)

### 🔄 In Progress
- [ ] Integration of UnifiedGenerationService in book detail screen
- [ ] Handle Ollama generation in TOC workflow
- [ ] Show loading indicators during Ollama generation
- [ ] Display generated TOC preview before saving
- [ ] Handle streaming for longer chapter generation
- [ ] Error handling and fallback to copy-paste

### 📋 To Do
- [ ] Chapter generation with Ollama
- [ ] Streaming generation UI with real-time display
- [ ] Edit generated content before saving
- [ ] Ollama generation mode toggle in book detail screen
- [ ] Test Ollama generation with various models
- [ ] Error handling and retry logic
- [ ] Analytics for generation success rates

## Code Files to Update

### 1. Book Detail Screen
**File**: `lib/features/book/presentation/book_detail_screen.dart`

**What to Update**:
- Import `generationModeProvider` and `unifiedGenerationServiceProvider`
- Modify `_generateTOCPrompt()` to:
  - Check generation mode
  - If Ollama: Use UnifiedGenerationService
  - Show loading while generating
  - Display preview before saving
- Modify chapter generation similarly

**Current Code** (Lines 316-410):
```dart
void _generateTOCPrompt(...) async {
  final llmService = LLMIntegrationService();
  final prompt = llmService.generateTOCPromptWithFormat(...);
  
  // Shows share/copy dialog (copy-paste mode only)
  final action = await showDialog<String>(...);
}
```

**New Logic**:
```dart
void _generateTOCPrompt(...) async {
  final generationMode = ref.read(generationModeProvider);
  final llmService = LLMIntegrationService();
  final prompt = llmService.generateTOCPromptWithFormat(...);
  
  if (generationMode == GenerationMode.ollama) {
    // Use Ollama generation
    _generateTOCWithOllama(context, ref, book, prompt, l10n);
  } else {
    // Use copy-paste mode (existing implementation)
    _generateTOCWithCopyPaste(context, ref, book, prompt, l10n);
  }
}

Future<void> _generateTOCWithOllama(
  BuildContext context,
  WidgetRef ref,
  dynamic book,
  String prompt,
  AppLocalizations l10n,
) async {
  try {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        title: Text('Generating TOC...'),
        content: CircularProgressIndicator(),
      ),
    );

    // Generate with Ollama
    final generationService = ref.read(unifiedGenerationServiceProvider);
    final result = await generationService.generate(
      prompt: prompt,
      preferredMode: GenerationMode.ollama,
      allowFallback: true,
    );

    if (!context.mounted) return;
    Navigator.of(context).pop(); // Close loading dialog

    if (result.success) {
      // Parse and show preview
      final llmService = LLMIntegrationService();
      final response = llmService.parseResponse(
        // Get the actual response from Ollama
      );

      // Show preview dialog
      _showTOCPreview(context, ref, book, response, l10n);
    } else {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Generation failed: ${result.error}')),
      );
    }
  } catch (e) {
    if (context.mounted) {
      Navigator.of(context).pop(); // Close loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}
```

### 2. UnifiedGenerationService Enhancement
**File**: `lib/features/ollama/services/unified_generation_service.dart`

**Current Issue**: The service returns `GenerationResult` with `TitleResponse`, but we need to:
- Return the full response from Ollama (not just title)
- Support all response types (TOCResponse, ChapterResponse, etc.)
- Make streaming available for UI

**Needed Changes**:
```dart
// Instead of returning GenerationResult with TitleResponse,
// return the raw Ollama response and let the caller parse it

Future<String> generateWithOllama({
  required String prompt,
  bool allowFallback = true,
}) async {
  // Returns raw response string for parsing
}

// Or better: Return parsed response object
Future<LLMResponse> generateParsedResponse({
  required String prompt,
  required GenerationMode preferredMode,
}) async {
  // Returns parsed TOCResponse, ChapterResponse, etc.
}
```

### 3. Ollama Providers Update
**File**: `lib/features/ollama/presentation/providers/ollama_providers.dart`

**New Providers to Add**:
```dart
/// Provider for checking if Ollama is properly configured for generation
final ollamaReadyForGenerationProvider = FutureProvider<bool>((ref) async {
  final status = await ref.watch(ollamaConnectionStatusProvider.future);
  final config = ref.watch(ollamaConfigProvider);
  return status is ConnectedStatus && config.selectedModel != null;
});
```

## Error Handling Strategy

### Connection Issues
```
IF Ollama Connection Fails:
  - If allowFallback = true:
    → Fallback to copy-paste mode
    → Show notification: "Ollama unavailable, using copy-paste"
  - If allowFallback = false:
    → Show error dialog
    → Allow user to enable copy-paste or retry
```

### Generation Timeout
```
IF Generation Takes > 30 seconds:
  - Show progress indicator with timeout warning
  - Allow user to cancel and try copy-paste
```

### Invalid Ollama Response
```
IF Ollama Returns Non-JSON Text:
  - Try to parse as plain text format
  - If parsing fails:
    → Show error with Ollama response
    → Allow user to manually edit and save
```

## User Experience Flow

### Scenario 1: Ollama Configured & Working
```
User: "Generate TOC"
  ↓
App: Shows Loading "Generating with Ollama..."
  ↓
Ollama Generates Content (1-5 seconds typically)
  ↓
App: Shows Preview Dialog with:
    - Generated TOC
    - Edit Button
    - Save Button
    - Cancel Button
  ↓
User: Reviews and clicks "Save"
  ↓
TOC Saved to Database
```

### Scenario 2: Ollama Down/Unavailable
```
User: "Generate TOC"
  ↓
App: "Ollama unavailable. Using copy-paste mode"
  ↓
Shows Share/Copy Dialog (current behavior)
  ↓
User: Shares to External LLM App
  ↓
Returns with Response
  ↓
User: Pastes in Import Dialog
  ↓
TOC Saved
```

### Scenario 3: User Prefers Copy-Paste
```
User: Opens Settings
  ↓
User: Selects "Generation Mode: Copy-Paste"
  ↓
User: "Generate TOC"
  ↓
Shows Share/Copy Dialog (current behavior)
  ↓
[Same as Scenario 2]
```

## Testing Checklist

### Unit Tests
- [ ] UnifiedGenerationService with mock OllamaClient
- [ ] TOC response parsing from Ollama
- [ ] Chapter response parsing from Ollama
- [ ] Fallback behavior when Ollama unavailable
- [ ] Timeout handling

### Integration Tests
- [ ] Full TOC generation flow with Ollama
- [ ] Full chapter generation flow with Ollama
- [ ] Fallback to copy-paste
- [ ] Model selection and switching
- [ ] Connection status updates

### Manual Tests
- [ ] Test with local Ollama instance
- [ ] Test with various models (llama2, mistral, etc.)
- [ ] Test slow generation (monitor timeout handling)
- [ ] Test connection loss during generation
- [ ] Test switching between Ollama and copy-paste modes

## Next Steps

1. **Enhance UnifiedGenerationService**
   - Make it return parsed LLM responses, not just titles
   - Add proper error messages
   - Support streaming for long generations

2. **Update Book Detail Screen**
   - Import and use generation mode
   - Call UnifiedGenerationService for Ollama
   - Show loading indicators
   - Display previews before saving

3. **Add Generation UI Components**
   - Loading dialog with progress
   - Preview dialog with edit capability
   - Error handling dialogs

4. **Testing**
   - Write unit tests for service
   - Manual testing with real Ollama instance
   - Test error scenarios

5. **Documentation**
   - Update README with Ollama setup instructions
   - Add troubleshooting guide for Ollama issues
   - Document fallback behavior

## Related Files
- [LLM_INTEGRATION_GUIDE.md](LLM_INTEGRATION_GUIDE.md) - Prompt generation details
- [OLLAMA_QUICK_START.md](OLLAMA_QUICK_START.md) - Ollama setup
- [ollama_providers.dart](../lib/features/ollama/presentation/providers/ollama_providers.dart) - State management
- [unified_generation_service.dart](../lib/features/ollama/services/unified_generation_service.dart) - Generation service
- [book_detail_screen.dart](../lib/features/book/presentation/book_detail_screen.dart) - UI integration point
