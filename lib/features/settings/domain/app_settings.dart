/// Application settings model
class AppSettings {
  final String writingStyle; // 'creative', 'balanced', 'precise'
  final String language; // Language for AI-generated content
  final String
  uiLanguageCode; // UI language code (e.g., 'en', 'es', or 'system' for system default)
  final String tone; // 'casual', 'formal', 'neutral'
  final String vocabularyLevel; // 'simple', 'moderate', 'advanced'
  final String? favoriteAuthor;
  final int suggestedChapters; // Default number of chapters to generate

  const AppSettings({
    this.writingStyle = 'balanced',
    this.language = 'English',
    this.uiLanguageCode = 'system',
    this.tone = 'neutral',
    this.vocabularyLevel = 'moderate',
    this.favoriteAuthor,
    this.suggestedChapters = 10,
  });

  AppSettings copyWith({
    String? writingStyle,
    String? language,
    String? uiLanguageCode,
    String? tone,
    String? vocabularyLevel,
    String? favoriteAuthor,
    int? suggestedChapters,
  }) {
    return AppSettings(
      writingStyle: writingStyle ?? this.writingStyle,
      language: language ?? this.language,
      uiLanguageCode: uiLanguageCode ?? this.uiLanguageCode,
      tone: tone ?? this.tone,
      vocabularyLevel: vocabularyLevel ?? this.vocabularyLevel,
      favoriteAuthor: favoriteAuthor ?? this.favoriteAuthor,
      suggestedChapters: suggestedChapters ?? this.suggestedChapters,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'writingStyle': writingStyle,
      'language': language,
      'uiLanguageCode': uiLanguageCode,
      'tone': tone,
      'vocabularyLevel': vocabularyLevel,
      'favoriteAuthor': favoriteAuthor,
      'suggestedChapters': suggestedChapters,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      writingStyle: json['writingStyle'] as String? ?? 'balanced',
      language: json['language'] as String? ?? 'English',
      uiLanguageCode: json['uiLanguageCode'] as String? ?? 'system',
      tone: json['tone'] as String? ?? 'neutral',
      vocabularyLevel: json['vocabularyLevel'] as String? ?? 'moderate',
      favoriteAuthor: json['favoriteAuthor'] as String?,
      suggestedChapters: json['suggestedChapters'] as int? ?? 10,
    );
  }
}
