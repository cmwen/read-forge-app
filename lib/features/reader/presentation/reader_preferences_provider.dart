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

/// StateNotifier for managing reader preferences
class ReaderPreferencesNotifier extends StateNotifier<ReaderPreferences> {
  final ReaderPreferencesService _service;

  ReaderPreferencesNotifier(this._service) : super(const ReaderPreferences()) {
    _loadPreferences();
  }

  void _loadPreferences() {
    state = _service.load();
  }

  Future<void> setFontSize(double size) async {
    state = state.copyWith(fontSize: size);
    await _service.save(state);
  }

  Future<void> setTheme(String theme) async {
    state = state.copyWith(theme: theme);
    await _service.save(state);
  }

  Future<void> setFontFamily(String fontFamily) async {
    state = state.copyWith(fontFamily: fontFamily);
    await _service.save(state);
  }
}

/// Provider for ReaderPreferencesNotifier
final readerPreferencesProvider =
    StateNotifierProvider<ReaderPreferencesNotifier, ReaderPreferences>((ref) {
      final service = ref.watch(readerPreferencesServiceProvider);
      return ReaderPreferencesNotifier(service);
    });
