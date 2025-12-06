/// Application settings model
class AppSettings {
  final String writingStyle; // 'creative', 'balanced', 'precise'
  final String language;
  final String tone; // 'casual', 'formal', 'neutral'
  final String vocabularyLevel; // 'simple', 'moderate', 'advanced'
  final String? favoriteAuthor;

  const AppSettings({
    this.writingStyle = 'balanced',
    this.language = 'English',
    this.tone = 'neutral',
    this.vocabularyLevel = 'moderate',
    this.favoriteAuthor,
  });

  AppSettings copyWith({
    String? writingStyle,
    String? language,
    String? tone,
    String? vocabularyLevel,
    String? favoriteAuthor,
  }) {
    return AppSettings(
      writingStyle: writingStyle ?? this.writingStyle,
      language: language ?? this.language,
      tone: tone ?? this.tone,
      vocabularyLevel: vocabularyLevel ?? this.vocabularyLevel,
      favoriteAuthor: favoriteAuthor ?? this.favoriteAuthor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'writingStyle': writingStyle,
      'language': language,
      'tone': tone,
      'vocabularyLevel': vocabularyLevel,
      'favoriteAuthor': favoriteAuthor,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      writingStyle: json['writingStyle'] as String? ?? 'balanced',
      language: json['language'] as String? ?? 'English',
      tone: json['tone'] as String? ?? 'neutral',
      vocabularyLevel: json['vocabularyLevel'] as String? ?? 'moderate',
      favoriteAuthor: json['favoriteAuthor'] as String?,
    );
  }
}
