import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_forge/features/ollama/domain/generation_mode.dart';
import 'package:read_forge/features/ollama/domain/ollama_connection_status.dart';
import 'package:read_forge/features/ollama/presentation/providers/ollama_providers.dart';
import 'package:read_forge/features/ollama/presentation/widgets/mode_card.dart';

/// Widget for selecting generation mode (copy-paste vs Ollama)
class GenerationModeSelector extends ConsumerWidget {
  final GenerationMode selectedMode;
  final ValueChanged<GenerationMode> onModeChanged;

  const GenerationModeSelector({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionStatusAsync = ref.watch(ollamaConnectionStatusProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Choose generation method:', style: theme.textTheme.titleMedium),
        const SizedBox(height: 16),

        // Copy-Paste Mode Card (always available)
        ModeCard(
          icon: Icons.description,
          title: GenerationMode.copyPaste.label,
          subtitle: GenerationMode.copyPaste.subtitle,
          isSelected: selectedMode == GenerationMode.copyPaste,
          onTap: () => onModeChanged(GenerationMode.copyPaste),
        ),

        const SizedBox(height: 12),

        // Ollama Mode Card (status-dependent)
        connectionStatusAsync.when(
          data: (status) => _buildOllamaCard(context, status),
          loading: () =>
              _buildOllamaCard(context, OllamaConnectionStatus.testing('...')),
          error: (error, _) =>
              _buildOllamaCard(context, OllamaConnectionStatus.notConfigured()),
        ),
      ],
    );
  }

  Widget _buildOllamaCard(BuildContext context, OllamaConnectionStatus status) {
    Color? statusColor;
    switch (status.type) {
      case ConnectionStatusType.connected:
        statusColor = const Color(0xFF4CAF50); // Green
        break;
      case ConnectionStatusType.offline:
        statusColor = const Color(0xFFF44336); // Red
        break;
      case ConnectionStatusType.testing:
        statusColor = const Color(0xFFFFC107); // Amber
        break;
      case ConnectionStatusType.notConfigured:
        statusColor = const Color(0xFFBDBDBD); // Gray
        break;
    }

    final subtitle = status.selectedModel != null
        ? 'Local generation - ${status.selectedModel}'
        : 'Local generation';

    return ModeCard(
      icon: Icons.smart_toy,
      title: '${GenerationMode.ollama.label} (${status.title})',
      subtitle: subtitle,
      isSelected: selectedMode == GenerationMode.ollama,
      statusBadge: status.badge,
      statusColor: statusColor,
      onTap: status.isAvailable
          ? () => onModeChanged(GenerationMode.ollama)
          : null,
    );
  }
}
