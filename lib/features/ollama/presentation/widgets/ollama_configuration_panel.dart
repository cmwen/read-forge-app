import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_forge/features/ollama/presentation/providers/ollama_providers.dart';
import 'package:read_forge/features/ollama/presentation/widgets/connection_status_panel.dart';

/// Panel for configuring Ollama in Settings screen
class OllamaConfigurationPanel extends ConsumerStatefulWidget {
  const OllamaConfigurationPanel({super.key});

  @override
  ConsumerState<OllamaConfigurationPanel> createState() =>
      _OllamaConfigurationPanelState();
}

class _OllamaConfigurationPanelState
    extends ConsumerState<OllamaConfigurationPanel> {
  late TextEditingController _urlController;
  String? _urlError;

  @override
  void initState() {
    super.initState();
    final config = ref.read(ollamaConfigProvider);
    _urlController = TextEditingController(text: config.serverUrl);
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(ollamaConfigProvider);
    final modelsAsync = ref.watch(ollamaModelsProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Ollama Configuration',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Connection Status Panel
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const ConnectionStatusPanel(showRefreshButton: true),
        ),

        const SizedBox(height: 24),

        // Server URL Configuration
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Server URL', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              TextField(
                controller: _urlController,
                decoration: InputDecoration(
                  hintText: 'http://localhost:11434',
                  helperText: 'Include protocol (http://) and port',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.language),
                  suffixIcon: _urlError != null
                      ? const Icon(Icons.error, color: Colors.red)
                      : config.isValid
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  errorText: _urlError,
                ),
                onChanged: (value) => _validateUrl(value),
                enabled: !config.enabled,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Test Connection'),
                  onPressed: _urlError == null && !config.enabled
                      ? () => _testConnection()
                      : null,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Model Selection
        if (config.enabled) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Model Selection', style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                modelsAsync.when(
                  data: (models) {
                    if (models.isEmpty) {
                      return const Center(
                        child: Text('No models available. Check connection.'),
                      );
                    }
                    return DropdownButtonFormField<String>(
                      initialValue: config.selectedModel,
                      items: models.map((model) {
                        return DropdownMenuItem(
                          value: model.name,
                          child: Text(
                            '${model.name} (${_formatSize(model.size)})',
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          ref
                              .read(ollamaConfigProvider.notifier)
                              .setSelectedModel(value);
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.smart_toy),
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Text(
                    'Error loading models: $error',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],

        // Actions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (config.enabled) ...[
                OutlinedButton.icon(
                  icon: const Icon(Icons.close),
                  label: const Text('Disconnect from Ollama'),
                  onPressed: () => _showDisconnectConfirmation(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  void _validateUrl(String value) {
    setState(() {
      if (value.isEmpty) {
        _urlError = 'URL is required';
      } else if (!value.startsWith('http://') &&
          !value.startsWith('https://')) {
        _urlError = 'URL must start with http:// or https://';
      } else if (!value.contains(':')) {
        _urlError = 'Port number required (e.g., :11434)';
      } else {
        _urlError = null;
      }
    });
  }

  Future<void> _testConnection() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;

    // Save URL first
    await ref.read(ollamaConfigProvider.notifier).setServerUrl(url);

    // Enable Ollama
    await ref.read(ollamaConfigProvider.notifier).setEnabled(true);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Testing connection...')));
    }
  }

  Future<void> _showDisconnectConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disconnect from Ollama?'),
        content: const Text('You can always reconnect later from Settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Disconnect'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(ollamaConfigProvider.notifier).setEnabled(false);
    }
  }

  String _formatSize(int? bytes) {
    if (bytes == null) return 'Unknown';
    final gb = bytes / (1024 * 1024 * 1024);
    return '${gb.toStringAsFixed(1)}GB';
  }
}
