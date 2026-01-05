import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:read_forge/features/ollama/domain/ollama_config.dart';

/// Service for persisting Ollama configuration
class OllamaConfigPersistenceService {
  final SharedPreferences _prefs;

  static const String _keyConfig = 'ollama_config';
  static const String _keyLastCheck = 'ollama_last_check';
  static const String _keyGenerationMode = 'generation_mode';

  OllamaConfigPersistenceService(this._prefs);

  /// Load Ollama configuration
  OllamaConfig loadConfig() {
    final jsonString = _prefs.getString(_keyConfig);
    if (jsonString == null) {
      return OllamaConfig.defaults();
    }

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return OllamaConfig.fromJson(json);
    } catch (e) {
      return OllamaConfig.defaults();
    }
  }

  /// Save Ollama configuration
  Future<void> saveConfig(OllamaConfig config) async {
    final jsonString = jsonEncode(config.toJson());
    await _prefs.setString(_keyConfig, jsonString);
  }

  /// Save last connection check time
  Future<void> saveLastCheck(DateTime time) async {
    await _prefs.setInt(_keyLastCheck, time.millisecondsSinceEpoch);
  }

  /// Load last connection check time
  DateTime? loadLastCheck() {
    final millis = _prefs.getInt(_keyLastCheck);
    if (millis == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  /// Save preferred generation mode
  Future<void> saveGenerationMode(String mode) async {
    await _prefs.setString(_keyGenerationMode, mode);
  }

  /// Load preferred generation mode
  String? loadGenerationMode() {
    return _prefs.getString(_keyGenerationMode);
  }
}
