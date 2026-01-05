# Ollama Integration UI Components & Specifications

**Date**: January 5, 2026  
**Status**: Component Design  
**Framework**: Flutter with Material Design 3  

---

## Component Library

### 1. Mode Selector Widget

#### Purpose
Allow user to choose between copy-paste generation and Ollama generation.

#### Location
- Primary: Generate Content Dialog
- Secondary: Settings page (to switch default mode)

#### Variants

##### Variant A: Card-Based (Recommended for Dialog)
```dart
class GenerationModeSelector extends StatelessWidget {
  final GenerationMode selectedMode;
  final ValueChanged<GenerationMode> onModeChanged;
  final OllamaConnectionStatus connectionStatus;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Choose generation method:'),
        SizedBox(height: 16),
        // Copy-Paste Card
        ModeCard(
          icon: Icons.description,
          title: 'Paste from ChatGPT',
          subtitle: 'Use your preferred AI assistant',
          isSelected: selectedMode == GenerationMode.copyPaste,
          onTap: () => onModeChanged(GenerationMode.copyPaste),
        ),
        SizedBox(height: 12),
        // Ollama Card
        ModeCard(
          icon: Icons.smart_toy,
          title: 'Ollama (${connectionStatus.label})',
          subtitle: connectionStatus.subtitle,
          isSelected: selectedMode == GenerationMode.ollama,
          status: connectionStatus.badge,
          statusColor: connectionStatus.color,
          onTap: connectionStatus.isAvailable 
            ? () => onModeChanged(GenerationMode.ollama)
            : null,
        ),
      ],
    );
  }
}
```

##### ModeCard Component
```dart
class ModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final String? status;
  final Color? statusColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onTap != null;

    return Card(
      elevation: isSelected ? 4 : 0,
      color: isSelected 
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.surface,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: isSelected 
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected 
                          ? theme.colorScheme.primary
                          : null,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (status != null) ...[
                SizedBox(width: 12),
                Chip(
                  label: Text(
                    status!,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: statusColor?.withOpacity(0.2),
                  labelStyle: TextStyle(color: statusColor),
                  side: BorderSide(color: statusColor!),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
```

**Accessibility:**
```dart
// Semantic wrapper
Semantics(
  button: true,
  enabled: isEnabled,
  label: 'Generate with ${title}. ${subtitle}' + 
         (status != null ? '. Status: $status' : ''),
  onTap: onTap,
  child: // ... ModeCard widget
)
```

**Sizes:**
- Card height: 64dp minimum (for 48dp+ touch target)
- Icon: 32dp
- Padding: 16dp
- Spacing between cards: 12dp

---

### 2. Ollama Connection Status Indicator

#### Purpose
Show current connection status with clear visual indicators.

#### Locations
- Settings: Ollama Configuration section (persistent)
- Generate Dialog: Mode selector card status badge
- Generation Screen: While streaming

#### Component: ConnectionStatusPanel

```dart
class OllamaConnectionStatusPanel extends ConsumerWidget {
  final bool showRefreshButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(ollamaConnectionStatusProvider);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: statusAsync.when(
          data: (status) => _buildStatusContent(context, status),
          loading: () => _buildLoadingState(context),
          error: (error, stack) => _buildErrorState(context, error),
        ),
      ),
    );
  }

  Widget _buildStatusContent(
    BuildContext context,
    OllamaConnectionStatus status,
  ) {
    final theme = Theme.of(context);
    final colors = _getStatusColors(theme, status);

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.indicatorColor,
            boxShadow: [
              BoxShadow(
                color: colors.indicatorColor.withOpacity(0.5),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status.title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.titleColor,
                ),
              ),
              SizedBox(height: 4),
              Text(
                status.subtitle,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (showRefreshButton) ...[
          SizedBox(width: 12),
          IconButton(
            onPressed: _refreshConnection,
            icon: Icon(Icons.refresh),
            tooltip: 'Refresh connection status',
            iconSize: 20,
          ),
        ],
      ],
    );
  }

  // Status colors mapping
  ({Color indicatorColor, Color titleColor}) _getStatusColors(
    ThemeData theme,
    OllamaConnectionStatus status,
  ) {
    return switch (status.type) {
      StatusType.connected => (
        indicatorColor: Color(0xFF4CAF50), // green
        titleColor: theme.colorScheme.onSurface,
      ),
      StatusType.offline => (
        indicatorColor: Color(0xFFF44336), // red
        titleColor: Color(0xFFC62828),
      ),
      StatusType.testing => (
        indicatorColor: Color(0xFFFFC107), // amber
        titleColor: theme.colorScheme.onSurface,
      ),
      StatusType.notConfigured => (
        indicatorColor: Color(0xFFBDBDBD), // gray
        titleColor: theme.colorScheme.onSurfaceVariant,
      ),
    };
  }
}
```

**Status Models:**
```dart
enum StatusType { connected, offline, testing, notConfigured }

class OllamaConnectionStatus {
  final StatusType type;
  final String url;
  final DateTime? lastChecked;
  final String? error;

  String get title => switch (type) {
    StatusType.connected => '🟢 Connected to Ollama',
    StatusType.offline => '🔴 Offline',
    StatusType.testing => '🟡 Testing...',
    StatusType.notConfigured => '⚪ Not Configured',
  };

  String get subtitle => switch (type) {
    StatusType.connected => 
      '$url • Last checked: ${_timeAgo(lastChecked)}',
    StatusType.offline => 
      'Can\'t reach $url',
    StatusType.testing => 
      'Checking connection...',
    StatusType.notConfigured => 
      'Go to Settings to configure Ollama',
  };

  bool get isAvailable => type == StatusType.connected;
}
```

---

### 3. Ollama Configuration Panel

#### Location
Settings Screen → Ollama Configuration Section

#### Component: OllamaConfigurationPanel

```dart
class OllamaConfigurationPanel extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(ollamaConfigProvider);
    final notifier = ref.read(ollamaConfigProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Ollama Configuration',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Connection Status Panel
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: OllamaConnectionStatusPanel(showRefreshButton: true),
        ),

        SizedBox(height: 24),

        // Server URL Configuration
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Server URL',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: 8),
              TextField(
                controller: _urlController,
                decoration: InputDecoration(
                  hintText: 'http://localhost:11434',
                  helperText: 'Include protocol (http://) and port',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.language),
                  suffixIcon: _urlError != null
                    ? Icon(Icons.error, color: Colors.red)
                    : Icon(Icons.check, color: Colors.green),
                ),
                onChanged: (value) => _validateUrl(value),
                enabled: config.connectionStatus.type != StatusType.testing,
              ),
              if (_urlError != null) ...[
                SizedBox(height: 8),
                Text(
                  _urlError!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.red,
                  ),
                ),
              ],
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.check),
                  label: Text(
                    config.connectionStatus.type == StatusType.testing
                      ? 'Testing...'
                      : 'Test Connection',
                  ),
                  onPressed: 
                    _urlError == null && config.connectionStatus.type != StatusType.testing
                    ? () => notifier.testConnection(_urlController.text)
                    : null,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 24),

        // Model Selection
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Model Selection',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: 8),
              if (config.availableModels.isEmpty)
                Center(
                  child: Text('No models available. Check connection.'),
                )
              else
                DropdownButtonFormField<String>(
                  value: config.selectedModel,
                  items: config.availableModels.map((model) {
                    return DropdownMenuItem(
                      value: model.id,
                      child: Text('${model.name} (${model.size})'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      notifier.selectModel(value);
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.smart_toy),
                  ),
                ),
            ],
          ),
        ),

        SizedBox(height: 24),

        // Actions
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.open_in_browser),
                label: Text('Manage Models (Ollama Web UI)'),
                onPressed: () => _openOllamaWebUI(config.serverUrl),
              ),
              SizedBox(height: 12),
              OutlinedButton.icon(
                icon: Icon(Icons.close),
                label: Text('Disconnect from Ollama'),
                onPressed: () => _showDisconnectConfirmation(context, notifier),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: BorderSide(color: Colors.red),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16),
      ],
    );
  }
}
```

---

### 4. Generation Loading State

#### Location
Appears during Ollama generation

#### Component: OllamaGenerationLoader

```dart
class OllamaGenerationLoader extends ConsumerWidget {
  final Stream<OllamaGenerationUpdate> updates;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<OllamaGenerationUpdate>(
      stream: updates,
      builder: (context, snapshot) {
        final update = snapshot.data;
        final theme = Theme.of(context);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Generating content...',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),

            SizedBox(height: 16),

            // Model Info
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.smart_toy,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Using: ${update?.model ?? '...'}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Streaming Content Preview
            if (update?.content != null) ...[
              Container(
                constraints: BoxConstraints(maxHeight: 200),
                child: SingleChildScrollView(
                  child: SelectableText(
                    update!.content,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],

            // Statistics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  icon: Icons.numbers,
                  label: 'Tokens',
                  value: '${update?.tokensGenerated ?? 0}',
                ),
                _StatItem(
                  icon: Icons.schedule,
                  label: 'Time',
                  value: _formatDuration(update?.elapsed ?? Duration.zero),
                ),
                _StatItem(
                  icon: Icons.speed,
                  label: 'Speed',
                  value: '${_calculateSpeed(update)} t/s',
                ),
              ],
            ),

            SizedBox(height: 16),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: Icon(Icons.close),
                label: Text('Cancel Generation'),
                onPressed: onCancel,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, size: 18),
        SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
```

---

### 5. Generation Result Card

#### Location
Displayed after generation completes (both copy-paste and Ollama)

#### Component: GenerationResultCard

```dart
class GenerationResultCard extends ConsumerWidget {
  final String content;
  final GenerationMetadata metadata;
  final VoidCallback onEdit;
  final VoidCallback onAccept;
  final VoidCallback onRegenerate;
  final VoidCallback onTryDifferentMethod;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Content Display
        SelectableText(
          content,
          style: theme.textTheme.bodyLarge,
        ),

        SizedBox(height: 16),

        // Divider
        Divider(
          thickness: 1,
          color: theme.colorScheme.outlineVariant,
        ),

        SizedBox(height: 12),

        // Attribution
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                metadata.isOllama ? Icons.smart_toy : Icons.description,
                size: 18,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      metadata.isOllama
                        ? 'Generated by: ${metadata.model}'
                        : 'Pasted from: ${metadata.source}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Time: ${metadata.formattedDuration} • '
                      'Tokens: ${metadata.tokensCount}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16),

        // Action Buttons
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              icon: Icon(Icons.check),
              label: Text('Accept'),
              onPressed: onAccept,
            ),
            FilledTonalButton.icon(
              icon: Icon(Icons.edit),
              label: Text('Edit'),
              onPressed: onEdit,
            ),
            FilledTonalButton.icon(
              icon: Icon(Icons.refresh),
              label: Text('Regenerate'),
              onPressed: onRegenerate,
            ),
          ],
        ),

        SizedBox(height: 8),

        OutlinedButton.icon(
          icon: Icon(Icons.swap_horiz),
          label: Text('Try Different Method'),
          onPressed: onTryDifferentMethod,
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
```

---

## Material Design 3 Specifications

### Color Palette

| Element | Light Mode | Dark Mode | Usage |
|---------|-----------|----------|-------|
| **Connected** | #4CAF50 (Green) | #66BB6A | Connection status indicator |
| **Offline** | #F44336 (Red) | #EF5350 | Error/offline state |
| **Testing** | #FFC107 (Amber) | #FFB74D | Loading/testing state |
| **Not Configured** | #BDBDBD (Gray) | #757575 | Disabled/inactive state |
| **Primary** | Dynamic seedColor | Dynamic seedColor | Main actions |
| **Surface** | White | #121212 | Card backgrounds |

### Typography

| Element | Style | Usage |
|---------|-------|-------|
| **Title** | headline5 (28sp), w600 | Dialog/Section titles |
| **Subtitle** | titleMedium (16sp), w500 | Card titles |
| **Body** | bodyMedium (14sp), w400 | Main content |
| **Label** | labelSmall (12sp), w500 | Status, hints |
| **Code/Mono** | RobotoMono, 12sp | URLs, model names |

### Spacing Grid (8dp baseline)

```
Standard Spacing:
• Padding: 16, 24, 32dp
• Margin: 8, 12, 16, 24dp
• Gap between items: 8, 12, 16dp
• Section spacing: 24, 32dp

Touch Targets:
• Buttons: minimum 48dp height
• Icons: 24dp (actionable), 18dp (decorative)
• Cards: 64dp minimum height
```

### Elevation

| Component | Z-level | Usage |
|-----------|---------|-------|
| **Dialogs** | 3 | Modal overlays |
| **Cards** (selected) | 3 | Highlighted cards |
| **Cards** (default) | 1 | Standard cards |
| **FAB** | 6 | Floating action button |
| **SnackBar** | 6 | Notifications |

---

## Animation Specifications

### Transitions

| Action | Duration | Easing | Notes |
|--------|----------|--------|-------|
| **Mode selection** | 200ms | easeInOut | Highlight change |
| **Card elevation** | 150ms | easeInOut | Hover/press effect |
| **Status update** | 300ms | easeInOut | Status change fade |
| **Content fade** | 400ms | easeInOut | Generation complete |
| **Loading spinner** | 1500ms | linear | Continuous rotation |

### Feedback

- **Button press**: Scale 0.98x, 100ms
- **Card hover**: Elevation change, 150ms
- **Error appearance**: Fade in, 300ms
- **Generation streaming**: Content appears smoothly, no discrete jumps

---

## Responsive Behavior

### Phone (< 600dp width)
- Single column layout
- Full-width cards and buttons
- Bottom sheet for mode selection
- Compact spacing: 12dp

### Tablet (600-840dp width)
- Two-column layout where applicable
- Side-by-side buttons
- Standard spacing: 16-24dp

### Desktop (> 840dp width)
- Multi-column layout
- Wider content areas
- Expanded spacing: 24-32dp
- Desktop-optimized navigation

---

## State Diagram

```
┌─────────────────────────────────────────┐
│     Ollama Configuration States         │
└─────────────────────────────────────────┘

       ┌─────────────────┐
       │  Unconfigured   │ (user hasn't set URL)
       └────────┬────────┘
                │ User enters URL
                ↓
       ┌─────────────────┐
       │     Testing     │ (waiting for connection)
       └────────┬────────┘
                │
        ┌───────┴────────┐
        │                │
        ↓                ↓
   ✓ Connected      ✗ Failed
        │                │
        │                └──→ offline (user can retry)
        │
        ↓
   ┌─────────────────┐
   │   Connected     │ (ready for generation)
   │ (polling keeps  │
   │  this updated)  │
   └────────┬────────┘
            │ User generates
            ↓
    ┌──────────────────┐
    │    Generating    │ (streaming in progress)
    │  (can cancel)    │
    └────────┬─────────┘
             │
        ┌────┴──────────┐
        │               │
        ↓               ↓
    Complete      Cancelled
        │               │
        └───────┬───────┘
                │ back to Connected
                ↓
        (can generate again)
```

---

**Document Version**: 1.0  
**Last Updated**: January 5, 2026  
**Framework**: Flutter with Material Design 3  
**Dependencies**: flutter_riverpod, material design 3 components
