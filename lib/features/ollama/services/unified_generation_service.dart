import 'package:read_forge/core/domain/models/llm_response.dart';
import 'package:read_forge/core/services/llm_integration_service.dart';
import 'package:read_forge/features/ollama/domain/generation_mode.dart';
import 'package:read_forge/ollama_toolkit/ollama_toolkit.dart';

/// Result of a generation attempt
class GenerationResult {
  final TitleResponse? response;
  final bool success;
  final String? error;
  final bool usedFallback;
  final GenerationMode actualMode;

  const GenerationResult({
    this.response,
    required this.success,
    this.error,
    this.usedFallback = false,
    required this.actualMode,
  });

  factory GenerationResult.success(
    TitleResponse response,
    GenerationMode mode, {
    bool usedFallback = false,
  }) {
    return GenerationResult(
      response: response,
      success: true,
      usedFallback: usedFallback,
      actualMode: mode,
    );
  }

  factory GenerationResult.error(String error, GenerationMode mode) {
    return GenerationResult(success: false, error: error, actualMode: mode);
  }
}

/// Unified service for content generation (Ollama + copy-paste)
class UnifiedGenerationService {
  final OllamaClient? ollamaClient;
  final String? selectedModel;
  final LLMIntegrationService llmService;

  UnifiedGenerationService({this.ollamaClient, this.selectedModel})
    : llmService = LLMIntegrationService();

  /// Generate content with smart fallback
  /// If Ollama is requested but fails, falls back to copy-paste
  Future<GenerationResult> generate({
    required String prompt,
    required GenerationMode preferredMode,
    bool allowFallback = true,
  }) async {
    if (preferredMode == GenerationMode.ollama) {
      return _generateWithOllama(prompt, allowFallback: allowFallback);
    } else {
      return _generateWithCopyPaste(prompt);
    }
  }

  /// Generate with Ollama (with optional fallback)
  Future<GenerationResult> _generateWithOllama(
    String prompt, {
    bool allowFallback = true,
  }) async {
    // Check if Ollama is available
    if (ollamaClient == null || selectedModel == null) {
      if (allowFallback) {
        // Fall back to copy-paste
        return _generateWithCopyPaste(prompt, usedFallback: true);
      }
      return GenerationResult.error(
        'Ollama not configured',
        GenerationMode.ollama,
      );
    }

    try {
      // Test connection first
      final isConnected = await ollamaClient!.testConnection();
      if (!isConnected) {
        if (allowFallback) {
          return _generateWithCopyPaste(prompt, usedFallback: true);
        }
        return GenerationResult.error(
          'Cannot reach Ollama server',
          GenerationMode.ollama,
        );
      }

      // Generate with Ollama
      final response = await ollamaClient!.chat(selectedModel!, [
        OllamaMessage.user(prompt),
      ]);

      // Convert to TitleResponse
      final titleResponse = TitleResponse(
        title: _extractTitle(response.message.content) ?? 'Untitled',
        description: _extractDescription(response.message.content),
      );

      return GenerationResult.success(titleResponse, GenerationMode.ollama);
    } catch (e) {
      if (allowFallback) {
        return _generateWithCopyPaste(prompt, usedFallback: true);
      }
      return GenerationResult.error(
        'Ollama generation failed: ${e.toString()}',
        GenerationMode.ollama,
      );
    }
  }

  /// Generate with copy-paste mode
  Future<GenerationResult> _generateWithCopyPaste(
    String prompt, {
    bool usedFallback = false,
  }) async {
    // In copy-paste mode, we don't actually generate
    // We just return a result that indicates the user needs to paste
    return GenerationResult(
      success: true,
      usedFallback: usedFallback,
      actualMode: GenerationMode.copyPaste,
    );
  }

  /// Stream generation with Ollama
  Stream<String> generateStream({
    required String prompt,
    required String model,
  }) async* {
    if (ollamaClient == null) {
      yield 'Error: Ollama not configured';
      return;
    }

    try {
      await for (final chunk in ollamaClient!.chatStream(model, [
        OllamaMessage.user(prompt),
      ])) {
        yield chunk.message.content;
      }
    } catch (e) {
      yield 'Error: ${e.toString()}';
    }
  }

  // Helper methods to extract fields from response
  String? _extractTitle(String content) {
    // Look for title in markdown or plain text
    final titleMatch = RegExp(
      r'(?:Title|Book Title):\s*(.+?)(?:\n|$)',
      caseSensitive: false,
    ).firstMatch(content);
    if (titleMatch != null) {
      return titleMatch.group(1)?.trim();
    }

    // Try to find first line as title
    final lines = content
        .split('\n')
        .where((l) => l.trim().isNotEmpty)
        .toList();
    if (lines.isNotEmpty) {
      return lines.first.replaceAll(RegExp(r'^#+\s*'), '').trim();
    }

    return null;
  }

  String? _extractDescription(String content) {
    final descMatch = RegExp(
      r'(?:Description|Summary):\s*(.+?)(?:\n\n|$)',
      caseSensitive: false,
      dotAll: true,
    ).firstMatch(content);
    return descMatch?.group(1)?.trim();
  }
}
