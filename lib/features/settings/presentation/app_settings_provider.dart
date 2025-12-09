import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_forge/features/settings/domain/app_settings.dart';
import 'package:read_forge/features/settings/services/app_settings_service.dart';
import 'package:read_forge/features/reader/presentation/reader_preferences_provider.dart';

/// Provider for AppSettingsService
final appSettingsServiceProvider = Provider<AppSettingsService>((ref) {
  final prefs = ref
      .watch(sharedPreferencesProvider)
      .maybeWhen(
        data: (prefs) => prefs,
        orElse: () => throw StateError('SharedPreferences not initialized'),
      );
  return AppSettingsService(prefs);
});

/// StateNotifier for managing app settings
class AppSettingsNotifier extends StateNotifier<AppSettings> {
  final AppSettingsService _service;

  AppSettingsNotifier(this._service) : super(const AppSettings()) {
    _loadSettings();
  }

  void _loadSettings() {
    state = _service.load();
  }

  Future<void> setWritingStyle(String style) async {
    state = state.copyWith(writingStyle: style);
    await _service.save(state);
  }

  Future<void> setLanguage(String language) async {
    state = state.copyWith(language: language);
    await _service.save(state);
  }

  Future<void> setUILanguage(String languageCode) async {
    state = state.copyWith(uiLanguageCode: languageCode);
    await _service.save(state);
  }

  Future<void> setTone(String tone) async {
    state = state.copyWith(tone: tone);
    await _service.save(state);
  }

  Future<void> setVocabularyLevel(String level) async {
    state = state.copyWith(vocabularyLevel: level);
    await _service.save(state);
  }

  Future<void> setFavoriteAuthor(String? author) async {
    state = state.copyWith(favoriteAuthor: author);
    await _service.save(state);
  }

  Future<void> setSuggestedChapters(int count) async {
    state = state.copyWith(suggestedChapters: count);
    await _service.save(state);
  }
}

/// Provider for AppSettingsNotifier
final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
      final service = ref.watch(appSettingsServiceProvider);
      return AppSettingsNotifier(service);
    });
