import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:read_forge/features/reader/domain/reader_preferences.dart';
import 'package:read_forge/features/reader/services/reader_preferences_service.dart';

/// Provider for SharedPreferences
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) {
  return SharedPreferences.getInstance();
});

/// Provider for ReaderPreferencesService
final readerPreferencesServiceProvider = Provider<ReaderPreferencesService>((
  ref,
) {
  final prefs = ref
      .watch(sharedPreferencesProvider)
      .maybeWhen(
        data: (prefs) => prefs,
        orElse: () => throw StateError('SharedPreferences not initialized'),
      );
  return ReaderPreferencesService(prefs);
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
