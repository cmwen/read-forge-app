import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:read_forge/features/settings/domain/app_settings.dart';

/// Service for managing application settings
class AppSettingsService {
  static const String _settingsKey = 'app_settings';
  final SharedPreferences _prefs;

  AppSettingsService(this._prefs);

  /// Load application settings
  AppSettings load() {
    final json = _prefs.getString(_settingsKey);
    if (json == null) {
      return const AppSettings();
    }
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return AppSettings.fromJson(map);
    } catch (e) {
      return const AppSettings();
    }
  }

  /// Save application settings
  Future<void> save(AppSettings settings) async {
    final json = jsonEncode(settings.toJson());
    await _prefs.setString(_settingsKey, json);
  }
}
