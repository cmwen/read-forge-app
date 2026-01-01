import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_forge/features/settings/domain/app_settings.dart';
import 'package:read_forge/features/settings/services/app_settings_service.dart';
import 'package:read_forge/core/utils/shared_preferences_cache.dart';

/// Provider for AppSettingsService
final appSettingsServiceProvider = Provider<AppSettingsService>((ref) {
  // SharedPreferences should be initialized in main() before the app runs
  // Get the cached SharedPreferences instance
  // This is safe because initSharedPreferencesCache() is called in main()
  final prefs = getSharedPreferencesCache();
  return AppSettingsService(prefs);
});

/// Notifier for managing app settings
class AppSettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    final service = ref.watch(appSettingsServiceProvider);
    return service.load();
  }

  Future<void> setWritingStyle(String style) async {
    final service = ref.read(appSettingsServiceProvider);
    state = state.copyWith(writingStyle: style);
    await service.save(state);
  }

  Future<void> setLanguage(String language) async {
    final service = ref.read(appSettingsServiceProvider);
    state = state.copyWith(language: language);
    await service.save(state);
  }

  Future<void> setUILanguage(String languageCode) async {
    final service = ref.read(appSettingsServiceProvider);
    state = state.copyWith(uiLanguageCode: languageCode);
    await service.save(state);
  }

  Future<void> setTone(String tone) async {
    final service = ref.read(appSettingsServiceProvider);
    state = state.copyWith(tone: tone);
    await service.save(state);
  }

  Future<void> setVocabularyLevel(String level) async {
    final service = ref.read(appSettingsServiceProvider);
    state = state.copyWith(vocabularyLevel: level);
    await service.save(state);
  }

  Future<void> setFavoriteAuthor(String? author) async {
    final service = ref.read(appSettingsServiceProvider);
    state = state.copyWith(favoriteAuthor: author);
    await service.save(state);
  }

  Future<void> setSuggestedChapters(int count) async {
    final service = ref.read(appSettingsServiceProvider);
    state = state.copyWith(suggestedChapters: count);
    await service.save(state);
  }
}

/// Provider for AppSettingsNotifier
final appSettingsProvider = NotifierProvider<AppSettingsNotifier, AppSettings>(
  AppSettingsNotifier.new,
);
