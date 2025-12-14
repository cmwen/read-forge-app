import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:read_forge/features/library/presentation/library_screen.dart';
import 'package:read_forge/features/settings/presentation/locale_provider.dart';
import 'package:read_forge/l10n/app_localizations.dart';
import 'package:audio_service/audio_service.dart';
import 'package:read_forge/features/reader/services/tts_audio_handler.dart';

AudioHandler? _audioHandler;

AudioHandler get audioHandler {
  if (_audioHandler == null) {
    throw StateError('AudioHandler not initialized. Call initAudioService() first.');
  }
  return _audioHandler!;
}

Future<void> initAudioService() async {
  if (_audioHandler != null) return;
  
  try {
    _audioHandler = await AudioService.init(
      builder: () => TtsAudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.cmwen.read_forge.audio',
        androidNotificationChannelName: 'Text-to-Speech Playback',
        androidNotificationOngoing: true,
        androidNotificationIcon: 'mipmap/ic_launcher',
        androidShowNotificationBadge: true,
      ),
    );
  } catch (e) {
    debugPrint('Failed to initialize AudioService: $e');
    // Create a dummy handler if initialization fails
    _audioHandler = TtsAudioHandler();
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Don't block app startup on audio service initialization
  // Initialize it lazily when needed
  
  runApp(const ProviderScope(child: MyApp()));
}

/// The root widget of the application.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('es'), // Spanish
        Locale('zh'), // Chinese (Simplified)
        Locale('zh', 'TW'), // Chinese (Traditional) - Taiwan
        Locale('fr'), // French
        Locale('de'), // German
        Locale('pt'), // Portuguese
        Locale('ja'), // Japanese
        Locale('ko'), // Korean
        Locale('ar'), // Arabic
        Locale('hi'), // Hindi
        Locale('ru'), // Russian
      ],
      locale: locale,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const LibraryScreen(),
    );
  }
}
