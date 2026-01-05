import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_forge/core/utils/shared_preferences_cache.dart';
import 'package:read_forge/features/ollama/domain/generation_mode.dart';
import 'package:read_forge/features/ollama/domain/ollama_config.dart';
import 'package:read_forge/features/ollama/domain/ollama_connection_status.dart';
import 'package:read_forge/features/ollama/services/ollama_config_persistence_service.dart';
import 'package:read_forge/features/ollama/services/unified_generation_service.dart';
import 'package:read_forge/ollama_toolkit/ollama_toolkit.dart';

/// Provider for OllamaConfigPersistenceService
final ollamaConfigPersistenceServiceProvider =
    Provider<OllamaConfigPersistenceService>((ref) {
      final prefs = getSharedPreferencesCache();
      return OllamaConfigPersistenceService(prefs);
    });

/// Provider for OllamaClient (recreated when config changes)
final ollamaClientProvider = Provider<OllamaClient?>((ref) {
  final config = ref.watch(ollamaConfigProvider);
  if (!config.enabled || config.serverUrl == null) {
    return null;
  }

  return OllamaClient(
    baseUrl: config.serverUrl!,
    timeout: const Duration(seconds: 30),
  );
});

/// Notifier for Ollama configuration
class OllamaConfigNotifier extends Notifier<OllamaConfig> {
  @override
  OllamaConfig build() {
    final service = ref.watch(ollamaConfigPersistenceServiceProvider);
    return service.loadConfig();
  }

  Future<void> setServerUrl(String url) async {
    final service = ref.read(ollamaConfigPersistenceServiceProvider);
    state = state.copyWith(serverUrl: url);
    await service.saveConfig(state);

    // Trigger connection status refresh
    ref.invalidate(ollamaConnectionStatusProvider);
  }

  Future<void> setSelectedModel(String model) async {
    final service = ref.read(ollamaConfigPersistenceServiceProvider);
    state = state.copyWith(selectedModel: model);
    await service.saveConfig(state);
  }

  Future<void> setEnabled(bool enabled) async {
    final service = ref.read(ollamaConfigPersistenceServiceProvider);
    state = state.copyWith(enabled: enabled);
    await service.saveConfig(state);

    // Trigger connection status refresh
    ref.invalidate(ollamaConnectionStatusProvider);
  }

  Future<void> testConnection() async {
    final client = ref.read(ollamaClientProvider);
    if (client == null || state.serverUrl == null) {
      return;
    }

    // Trigger testing state
    ref.invalidate(ollamaConnectionStatusProvider);
  }
}

/// Provider for OllamaConfigNotifier
final ollamaConfigProvider =
    NotifierProvider<OllamaConfigNotifier, OllamaConfig>(
      OllamaConfigNotifier.new,
    );

/// Provider for Ollama connection status
final ollamaConnectionStatusProvider = FutureProvider<OllamaConnectionStatus>((
  ref,
) async {
  final config = ref.watch(ollamaConfigProvider);
  final client = ref.watch(ollamaClientProvider);

  // Not configured
  if (!config.isValid || !config.enabled || client == null) {
    return OllamaConnectionStatus.notConfigured();
  }

  // Test connection
  try {
    final isConnected = await client.testConnection();
    final service = ref.read(ollamaConfigPersistenceServiceProvider);
    final now = DateTime.now();
    await service.saveLastCheck(now);

    if (isConnected) {
      return OllamaConnectionStatus.connected(
        url: config.serverUrl!,
        lastChecked: now,
        selectedModel: config.selectedModel,
      );
    } else {
      return OllamaConnectionStatus.offline(
        url: config.serverUrl!,
        error: 'Connection test failed',
      );
    }
  } catch (e) {
    return OllamaConnectionStatus.offline(
      url: config.serverUrl!,
      error: e.toString(),
    );
  }
});

/// Provider for available Ollama models
final ollamaModelsProvider = FutureProvider<List<OllamaModelInfo>>((ref) async {
  final client = ref.watch(ollamaClientProvider);
  if (client == null) {
    return [];
  }

  try {
    final response = await client.listModels();
    return response.models;
  } catch (e) {
    return [];
  }
});

/// Notifier for current generation mode
class GenerationModeNotifier extends Notifier<GenerationMode> {
  @override
  GenerationMode build() {
    final service = ref.watch(ollamaConfigPersistenceServiceProvider);
    final modeString = service.loadGenerationMode();

    if (modeString == 'ollama') {
      return GenerationMode.ollama;
    }
    return GenerationMode.copyPaste;
  }

  Future<void> setMode(GenerationMode mode) async {
    final service = ref.read(ollamaConfigPersistenceServiceProvider);
    state = mode;
    await service.saveGenerationMode(mode.name);
  }
}

/// Provider for current generation mode
final generationModeProvider =
    NotifierProvider<GenerationModeNotifier, GenerationMode>(
      GenerationModeNotifier.new,
    );

/// Provider for UnifiedGenerationService
final unifiedGenerationServiceProvider = Provider<UnifiedGenerationService>((
  ref,
) {
  final client = ref.watch(ollamaClientProvider);
  final config = ref.watch(ollamaConfigProvider);

  return UnifiedGenerationService(
    ollamaClient: client,
    selectedModel: config.selectedModel,
  );
});
