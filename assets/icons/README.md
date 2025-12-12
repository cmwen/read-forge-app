# ReadForge App Icon

## Design Concept

The ReadForge app icon combines three key elements to represent the app's purpose:

### 📖 Book Element
- An open book with two pages displayed in white/light color
- Represents the **reading** aspect of ReadForge
- Features subtle page lines to indicate text content
- Central binding shows the connection between pages

### 🔨 Forge/Anvil Element
- Small anvil/hammer icon at the bottom
- Represents the **creation/forging** aspect
- Symbolizes crafting and building books
- Uses complementary blue shades matching the Material Design 3 theme

### ✨ AI Sparks
- Golden star/sparkle elements around the book
- Represents the **AI-powered** nature of the app
- Positioned strategically to add visual interest
- Creates a sense of magic and intelligence

## Color Palette

- **Primary Blue**: `#2196F3` - Main background, matching Material Design 3
- **Dark Blue**: `#1976D2` - Forge elements and book outline
- **White**: `#FFFFFF` - Book pages
- **Light Blue**: `#E3F2FD` - Book binding
- **Gold**: `#FFD54F` - AI sparkles
- **Orange**: `#FFC107`, `#FF9800` - Hammer tool accent

## File Details

- **Format**: SVG (Scalable Vector Graphics)
- **Size**: 512x512px viewBox
- **Location**: `assets/icons/app_icon.svg`
- **Accessibility**: Fully scalable without quality loss

## Usage

### In Flutter App

The icon is declared in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/icons/app_icon.svg
```

### Loading in Code

```dart
import 'package:flutter_svg/flutter_svg.dart';

// Display the icon
SvgPicture.asset(
  'assets/icons/app_icon.svg',
  width: 48,
  height: 48,
);
```

### For App Launcher Icon

To use this SVG as the Android/iOS launcher icon:

1. Convert SVG to PNG at various resolutions (e.g., using Inkscape, Adobe Illustrator, or online tools)
2. Use `flutter_launcher_icons` package to generate platform-specific icons
3. Add to `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: false  # Set to true for iOS
  image_path: "assets/icons/app_icon.png"  # After converting from SVG
```

4. Run: `flutter pub run flutter_launcher_icons`

## Design Rationale

The icon effectively communicates ReadForge's unique value proposition:

1. **Reading Focus**: The prominent book immediately identifies the app as reading-related
2. **Creation Power**: The forge/anvil indicates content creation capabilities
3. **AI Intelligence**: Sparkles suggest advanced, intelligent features
4. **Professional**: Clean, modern design aligns with Material Design 3
5. **Memorable**: Unique combination of book + forge makes it distinctive

## Modifications

To modify the icon:

1. Open `app_icon.svg` in any SVG editor (Inkscape, Adobe Illustrator, Figma, etc.)
2. Edit the XML directly for precise control
3. Maintain the 512x512 viewBox for consistency
4. Keep colors aligned with app's Material Design theme

## License

This icon is part of the ReadForge project and follows the same license as the main project.

---

**Created**: 2025-12-12  
**Designer**: AI-Generated for ReadForge  
**Version**: 1.0.0
