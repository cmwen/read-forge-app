/// Ollama configuration settings
class OllamaConfig {
  final String? serverUrl;
  final String? selectedModel;
  final bool enabled;

  const OllamaConfig({
    this.serverUrl,
    this.selectedModel,
    this.enabled = false,
  });

  /// Default configuration
  factory OllamaConfig.defaults() {
    return const OllamaConfig(
      serverUrl: 'http://localhost:11434',
      enabled: false,
    );
  }

  /// Check if config is valid (has required fields)
  bool get isValid => serverUrl != null && serverUrl!.isNotEmpty;

  OllamaConfig copyWith({
    String? serverUrl,
    String? selectedModel,
    bool? enabled,
  }) {
    return OllamaConfig(
      serverUrl: serverUrl ?? this.serverUrl,
      selectedModel: selectedModel ?? this.selectedModel,
      enabled: enabled ?? this.enabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serverUrl': serverUrl,
      'selectedModel': selectedModel,
      'enabled': enabled,
    };
  }

  factory OllamaConfig.fromJson(Map<String, dynamic> json) {
    return OllamaConfig(
      serverUrl: json['serverUrl'] as String?,
      selectedModel: json['selectedModel'] as String?,
      enabled: json['enabled'] as bool? ?? false,
    );
  }
}
