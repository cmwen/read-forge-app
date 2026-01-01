import 'package:shared_preferences/shared_preferences.dart';

/// Global cache for SharedPreferences instance.
/// Must be initialized in main() before the app runs.
late SharedPreferences _sharedPreferencesInstance;

/// Initialize the SharedPreferences cache.
/// This should be called in main() before running the app.
Future<void> initSharedPreferencesCache() async {
  _sharedPreferencesInstance = await SharedPreferences.getInstance();
}

/// Get the cached SharedPreferences instance.
/// This will throw if initSharedPreferencesCache() hasn't been called yet.
SharedPreferences getSharedPreferencesCache() {
  return _sharedPreferencesInstance;
}
