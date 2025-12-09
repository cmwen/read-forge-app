import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_forge/features/settings/presentation/app_settings_provider.dart';

/// Provider that converts the UI language code to a Locale
final localeProvider = Provider<Locale?>((ref) {
  final settings = ref.watch(appSettingsProvider);

  if (settings.uiLanguageCode == 'system') {
    return null; // Return null to use system locale
  }

  // Parse language code and optional country code
  if (settings.uiLanguageCode.contains('_')) {
    final parts = settings.uiLanguageCode.split('_');
    return Locale(parts[0], parts[1]);
  }

  return Locale(settings.uiLanguageCode);
});
