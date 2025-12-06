/// Reader preferences model
class ReaderPreferences {
  final double fontSize;
  final String theme; // 'light', 'dark', 'sepia'
  final String fontFamily; // 'system', 'serif', 'sans'

  const ReaderPreferences({
    this.fontSize = 18.0,
    this.theme = 'light',
    this.fontFamily = 'system',
  });

  ReaderPreferences copyWith({
    double? fontSize,
    String? theme,
    String? fontFamily,
  }) {
    return ReaderPreferences(
      fontSize: fontSize ?? this.fontSize,
      theme: theme ?? this.theme,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  Map<String, dynamic> toJson() {
    return {'fontSize': fontSize, 'theme': theme, 'fontFamily': fontFamily};
  }

  factory ReaderPreferences.fromJson(Map<String, dynamic> json) {
    return ReaderPreferences(
      fontSize: json['fontSize'] as double? ?? 18.0,
      theme: json['theme'] as String? ?? 'light',
      fontFamily: json['fontFamily'] as String? ?? 'system',
    );
  }
}
