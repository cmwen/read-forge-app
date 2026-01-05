/// Generation modes available in the app
enum GenerationMode {
  /// Copy-paste from external AI assistants (ChatGPT, Claude, etc.)
  copyPaste,

  /// Local generation using Ollama models
  ollama,
}

extension GenerationModeExtension on GenerationMode {
  String get label {
    switch (this) {
      case GenerationMode.copyPaste:
        return 'Paste from ChatGPT';
      case GenerationMode.ollama:
        return 'Ollama';
    }
  }

  String get subtitle {
    switch (this) {
      case GenerationMode.copyPaste:
        return 'Use your preferred AI assistant';
      case GenerationMode.ollama:
        return 'Local generation';
    }
  }
}
