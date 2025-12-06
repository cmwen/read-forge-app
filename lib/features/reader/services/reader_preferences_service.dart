import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:read_forge/features/reader/domain/reader_preferences.dart';

/// Service for managing reader preferences
class ReaderPreferencesService {
  static const String _prefsKey = 'reader_preferences';
  final SharedPreferences _prefs;

  ReaderPreferencesService(this._prefs);

  /// Load reader preferences
  ReaderPreferences load() {
    final json = _prefs.getString(_prefsKey);
    if (json == null) {
      return const ReaderPreferences();
    }
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return ReaderPreferences.fromJson(map);
    } catch (e) {
      return const ReaderPreferences();
    }
  }

  /// Save reader preferences
  Future<void> save(ReaderPreferences preferences) async {
    final json = jsonEncode(preferences.toJson());
    await _prefs.setString(_prefsKey, json);
  }
}
