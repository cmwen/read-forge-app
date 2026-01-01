import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:read_forge/features/reader/domain/reader_preferences.dart';
import 'package:read_forge/features/reader/services/reader_preferences_service.dart';
import 'package:read_forge/core/utils/shared_preferences_cache.dart';

/// Provider for SharedPreferences
/// Note: SharedPreferences must be initialized in main() before the app runs
/// This is no longer used as a FutureProvider; kept for backwards compatibility
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) {
  return SharedPreferences.getInstance();
});

/// Provider for ReaderPreferencesService
final readerPreferencesServiceProvider = Provider<ReaderPreferencesService>((
  ref,
) {
  // Get the cached SharedPreferences instance
  // This is safe because initSharedPreferencesCache() is called in main()
  final prefsInstance = getSharedPreferencesCache();
  return ReaderPreferencesService(prefsInstance);
});

/// Notifier for managing reader preferences
class ReaderPreferencesNotifier extends Notifier<ReaderPreferences> {
  @override
  ReaderPreferences build() {
    final service = ref.watch(readerPreferencesServiceProvider);
    return service.load();
  }

  Future<void> setFontSize(double size) async {
    final service = ref.read(readerPreferencesServiceProvider);
    state = state.copyWith(fontSize: size);
    await service.save(state);
  }

  Future<void> setTheme(String theme) async {
    final service = ref.read(readerPreferencesServiceProvider);
    state = state.copyWith(theme: theme);
    await service.save(state);
  }

  Future<void> setFontFamily(String fontFamily) async {
    final service = ref.read(readerPreferencesServiceProvider);
    state = state.copyWith(fontFamily: fontFamily);
    await service.save(state);
  }
}

/// Provider for ReaderPreferencesNotifier
final readerPreferencesProvider =
    NotifierProvider<ReaderPreferencesNotifier, ReaderPreferences>(
      ReaderPreferencesNotifier.new,
    );
