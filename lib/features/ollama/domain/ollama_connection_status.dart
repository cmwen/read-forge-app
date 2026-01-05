/// Connection status types for Ollama server
enum ConnectionStatusType {
  /// Successfully connected to Ollama server
  connected,

  /// Cannot reach Ollama server
  offline,

  /// Currently testing connection
  testing,

  /// Ollama not configured yet
  notConfigured,
}

/// Connection status information for Ollama server
class OllamaConnectionStatus {
  final ConnectionStatusType type;
  final String? url;
  final DateTime? lastChecked;
  final String? error;
  final String? selectedModel;

  const OllamaConnectionStatus({
    required this.type,
    this.url,
    this.lastChecked,
    this.error,
    this.selectedModel,
  });

  /// Factory for connected status
  factory OllamaConnectionStatus.connected({
    required String url,
    required DateTime lastChecked,
    String? selectedModel,
  }) {
    return OllamaConnectionStatus(
      type: ConnectionStatusType.connected,
      url: url,
      lastChecked: lastChecked,
      selectedModel: selectedModel,
    );
  }

  /// Factory for offline status
  factory OllamaConnectionStatus.offline({required String url, String? error}) {
    return OllamaConnectionStatus(
      type: ConnectionStatusType.offline,
      url: url,
      error: error,
    );
  }

  /// Factory for testing status
  factory OllamaConnectionStatus.testing(String url) {
    return OllamaConnectionStatus(type: ConnectionStatusType.testing, url: url);
  }

  /// Factory for not configured status
  factory OllamaConnectionStatus.notConfigured() {
    return const OllamaConnectionStatus(
      type: ConnectionStatusType.notConfigured,
    );
  }

  /// Human-readable title
  String get title {
    switch (type) {
      case ConnectionStatusType.connected:
        return 'Connected to Ollama';
      case ConnectionStatusType.offline:
        return 'Offline';
      case ConnectionStatusType.testing:
        return 'Testing...';
      case ConnectionStatusType.notConfigured:
        return 'Not Configured';
    }
  }

  /// Human-readable subtitle
  String get subtitle {
    switch (type) {
      case ConnectionStatusType.connected:
        return url != null && lastChecked != null
            ? '$url • Last checked: ${_formatTime(lastChecked!)}'
            : url ?? '';
      case ConnectionStatusType.offline:
        return url != null ? 'Can\'t reach $url' : 'Connection failed';
      case ConnectionStatusType.testing:
        return 'Checking connection...';
      case ConnectionStatusType.notConfigured:
        return 'Go to Settings to configure Ollama';
    }
  }

  /// Badge text for UI
  String get badge {
    switch (type) {
      case ConnectionStatusType.connected:
        return 'READY';
      case ConnectionStatusType.offline:
        return 'OFFLINE';
      case ConnectionStatusType.testing:
        return 'TESTING';
      case ConnectionStatusType.notConfigured:
        return 'SETUP REQUIRED';
    }
  }

  /// Whether Ollama is available for generation
  bool get isAvailable => type == ConnectionStatusType.connected;

  /// Format time ago for last checked
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hr ago';
    } else {
      return '${difference.inDays} day ago';
    }
  }

  OllamaConnectionStatus copyWith({
    ConnectionStatusType? type,
    String? url,
    DateTime? lastChecked,
    String? error,
    String? selectedModel,
  }) {
    return OllamaConnectionStatus(
      type: type ?? this.type,
      url: url ?? this.url,
      lastChecked: lastChecked ?? this.lastChecked,
      error: error ?? this.error,
      selectedModel: selectedModel ?? this.selectedModel,
    );
  }
}
