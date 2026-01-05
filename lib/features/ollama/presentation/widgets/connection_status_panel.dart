import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_forge/features/ollama/domain/ollama_connection_status.dart';
import 'package:read_forge/features/ollama/presentation/providers/ollama_providers.dart';

/// Panel showing Ollama connection status
class ConnectionStatusPanel extends ConsumerWidget {
  final bool showRefreshButton;

  const ConnectionStatusPanel({super.key, this.showRefreshButton = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(ollamaConnectionStatusProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: statusAsync.when(
          data: (status) => _buildStatusContent(context, ref, status),
          loading: () => _buildLoadingState(context),
          error: (error, stack) => _buildErrorState(context, error),
        ),
      ),
    );
  }

  Widget _buildStatusContent(
    BuildContext context,
    WidgetRef ref,
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
                color: colors.indicatorColor.withValues(alpha: 0.5),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
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
              const SizedBox(height: 4),
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
          const SizedBox(width: 12),
          IconButton(
            onPressed: () => ref.invalidate(ollamaConnectionStatusProvider),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh connection status',
            iconSize: 20,
          ),
        ],
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return const Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        SizedBox(width: 12),
        Text('Checking connection...'),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(Icons.error, color: theme.colorScheme.error),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Error: ${error.toString()}',
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ),
      ],
    );
  }

  ({Color indicatorColor, Color titleColor}) _getStatusColors(
    ThemeData theme,
    OllamaConnectionStatus status,
  ) {
    return switch (status.type) {
      ConnectionStatusType.connected => (
        indicatorColor: const Color(0xFF4CAF50), // Green
        titleColor: theme.colorScheme.onSurface,
      ),
      ConnectionStatusType.offline => (
        indicatorColor: const Color(0xFFF44336), // Red
        titleColor: const Color(0xFFC62828),
      ),
      ConnectionStatusType.testing => (
        indicatorColor: const Color(0xFFFFC107), // Amber
        titleColor: theme.colorScheme.onSurface,
      ),
      ConnectionStatusType.notConfigured => (
        indicatorColor: const Color(0xFFBDBDBD), // Gray
        titleColor: theme.colorScheme.onSurfaceVariant,
      ),
    };
  }
}
