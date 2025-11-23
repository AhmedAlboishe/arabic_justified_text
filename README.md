
<img width="1484" height="267" alt="Frame 5" src="https://github.com/user-attachments/assets/44c98131-f1b1-433a-acb8-67afe2750cb5" />


<div align="center">

# 📝 Arabic Justified Text

### Beautiful Arabic text justification using Kashida (ـ) instead of spaces

[![pub package](https://img.shields.io/pub/v/arabic_justified_text.svg)](https://pub.dev/packages/arabic_justified_text)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/AhmedAlboishe/arabic_justified_text/blob/main/LICENSE)


</div>



## Table of Contents

- [🌟 Overview](#overview)
- [✨ Features](#features)
- [📦 Installation](#installation)
- [🚀 Quick Start](#quick-start)
- [📖 Parameters](#parameters)
- [💡 Examples](#examples)
- [🕌 Special Features](#special-features)
- [🎨 Advanced Usage](#advanced-usage)
- [🤝 Contributing](#contributing)
- [📋 Roadmap](#roadmap)
- [🐛 Known Issues](#known-issues)
- [⭐ Show Your Support](#show-your-support)



<h2 id="overview">🌟 Overview</h2>

**Arabic Justified Text** is a Flutter package that provides beautiful text justification for Arabic text using **Kashida (ـ)** instead of adding extra spaces between words. This creates a more natural and aesthetically pleasing appearance for justified Arabic text.



<h2 id="features">✨ Features</h2>

- ✅ **Smart Kashida Distribution** - Intelligently distributes Kashida across words
- ✅ **Diacritics Support** - Properly handles Arabic diacritics (Tashkeel)
- ✅ **Mixed Text Support** - Works with Arabic and English text together
- ✅ **Line Break Support** - Respects `\n` characters in text
- ✅ **Theme Integration** - Inherits default text styles from your app theme
- ✅ **RichText Support** - Advanced styling with `ArabicJustifiedRichText`
- ✅ **Sacred Text Handling** - Automatically excludes "Allah" (اللّٰه) from Kashida
- ✅ **Customizable Exclusions** - Add your own words to exclude from Kashida
- ✅ **Performance Optimized** - Efficient text processing
- ✅ **RTL/LTR Support** - Configurable text direction (RTL by default)



<h2 id="installation">📦 Installation</h2>

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  arabic_justified_text: ^0.0.7
```
Then run:

```Dart
flutter pub get
```



<h2 id="quick-start">🚀 Quick Start</h2>

### Basic Usage

```Dart
import 'package:arabic_justified_text/arabic_justified_text.dart';

ArabicJustifiedText(
  'في عالم التكنولوجيا الحديثة، أصبحت تطبيقات الهاتف المحمول جزءاً أساسياً من حياتنا اليومية.',
)
```

### With Custom Style

```Dart
ArabicJustifiedText(
  'النص العربي هنا',
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  ),
)
```
### With All Options

```Dart
ArabicJustifiedText(
  'أشهد أن لا إله إلا اللّٰه، وأن محمدًا رسول اللّٰه',
  style: TextStyle(fontSize: 16, height: 1.8),
  enableKashida: true,
  maxLines: 5,
  overflow: TextOverflow.ellipsis,
  textAlign: TextAlign.justify,
  textDirection: TextDirection.rtl,
  excludedWords: ['محمدا', 'رسول'], // Optional: exclude specific words
)
```



<h2 id="parameters">📖 Parameters</h2>

### ArabicJustifiedText
For simple text with single style.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `text` | `String` | **required** | The text to display |
| `style` | `TextStyle?` | `null` | Text style (inherits from theme if null) |
| `maxLines` | `int?` | `null` | Maximum number of lines |
| `overflow` | `TextOverflow?` | `null` | How to handle text overflow |
| `textDirection` | `TextDirection` | `TextDirection.rtl` | Text direction (RTL/LTR) |
| `textAlign` | `TextAlign` | `TextAlign.justify` | Text alignment |
| `enableKashida` | `bool` | `true` | Enable/disable Kashida justification |
| `excludedWords` | `List<String>?` | `null` | Words to exclude from Kashida |


### ArabicJustifiedRichText
For complex text with multiple styles.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `textSpan` | `InlineSpan` | **required** | The text span to display |
| `maxLines` | `int?` | `null` | Maximum number of lines |
| `overflow` | `TextOverflow?` | `null` | How to handle text overflow |
| `textDirection` | `TextDirection` | `TextDirection.rtl` | Text direction (RTL/LTR) |
| `textAlign` | `TextAlign` | `TextAlign.justify` | Text alignment |
| `enableKashida` | `bool` | `true` | Enable/disable Kashida justification |
| `excludedWords` | `List<String>?` | `null` | Words to exclude from Kashida |



<h2 id="examples">💡 Examples</h2>

### 1. Simple Text

```Dart
ArabicJustifiedText(
  'مرحباً بك في عالم البرمجة الجميل',
)
``` 

### 2. Text with Diacritics (Tashkeel)

```Dart
ArabicJustifiedText(
  'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
)
```

### 3. Multi-line Text with Line Breaks

```Dart
ArabicJustifiedText(
  '''السطر الأول من النص
السطر الثاني من النص
السطر الثالث من النص''',
  style: TextStyle(fontSize: 16, height: 2.0),
)
```

### 4. Mixed Arabic and English

```Dart
ArabicJustifiedText(
  'استخدم Flutter لبناء تطبيقات mobile رائعة',
  style: TextStyle(fontSize: 18),
)
```

### 5. With Maximum Lines

```Dart
ArabicJustifiedText(
  'نص طويل جداً يحتوي على الكثير من الكلمات والجمل...',
  maxLines: 3,
  overflow: TextOverflow.ellipsis,
)
```

### 6. Toggle Kashida On/Off

```Dart
bool useKashida = true;

ArabicJustifiedText(
  'النص العربي هنا',
  enableKashida: useKashida,
)
```



<h2 id="special-features">🕌 Special Features</h2>

### Respectful Handling of Sacred Words
The package automatically excludes the word (اللّٰه) and its variations from Kashida application, preserving its traditional appearance.

```Dart
// The word "اللّٰه" will never automatically receive Kashida
ArabicJustifiedText('بسم اللّٰه الرحمن الرحيم')
// Result: بـسـم اللّٰه الـرحمـن الـرحيـم (اللّٰه remains unchanged)
```

#### Automatically excluded variations:

- اللّٰه، اللَّه، ٱللّٰه، للّٰه، وللّٰه، واللّٰه، باللّٰه، تاللّٰه


### Custom Word Exclusions

You can exclude additional words from Kashida application:

```Dart
ArabicJustifiedText(
  'اللهم صل وسلم وبارك على نبينا محمد وعلى آله وصحبه أجمعين',
  excludedWords: ['محمد', 'اللهم'],
)
```

#### Use cases:

- 📖 Religious texts (prophets' names, sacred terms)
- 📚 Brand names or proper nouns
- ✍️ Technical terms that should remain unchanged



<h2 id="advanced-usage">🎨 Advanced Usage</h2>

### Using ArabicJustifiedRichText

> **⚠️ Important:** `ArabicJustifiedRichText` currently does **not** support `WidgetSpan`. 
> If your text contains widgets (icons, images, etc.), the Kashida justification will be 
> disabled and it will fall back to standard `RichText` rendering.

For complex text with multiple styles, colors, or interactions:

```Dart
ArabicJustifiedRichText(
  enableKashida: true,
  textSpan: TextSpan(
    style: TextStyle(fontSize: 18),
    children: [
      TextSpan(text: 'النص العادي '),
      TextSpan(
        text: 'النص العريض',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
      ),
      TextSpan(text: ' المزيد من النص'),
    ],
  ),
)
```



<h2 id="contributing">🤝 Contributing</h2>

Contributions are welcome! Here's how you can help:

1. 🐛 **Report Bugs** - Open an issue describing the bug
2. 💡 **Suggest Features** - Share your ideas for improvements
3. 🔧 **Submit Pull Requests** - Fix bugs or add features
4. 📖 **Improve Documentation** - Help make docs better
5. ⭐ **Star the Repo** - Show your support!



<h2 id="roadmap">📋 Roadmap</h2>

- [ ] **WidgetSpan support for ArabicJustifiedRichText** - Allow mixing text and widgets with Kashida
- [ ] Add more customization options for Kashida density
- [ ] Performance improvements for very long texts
- [ ] Support for other RTL languages (Persian, Urdu)



<h2 id="known-issues">🐛 Known Issues</h2>

- **WidgetSpan not supported in ArabicJustifiedRichText** - If you need to mix text with widgets (icons, images), use `enableKashida: false` or use standard `RichText`
- Very long words might overflow on narrow screens (use `maxLines` to handle)
- Performance may vary with extremely long texts (>10,000 characters)



<h2 id="show-your-support">⭐ Show Your Support</h2>

If you find this package useful, please consider giving it a ⭐ on [GitHub!](https://github.com/AhmedAlboishe/arabic_justified_text)


<h2></h2>


<div align="center">
Made with ❤️ for the Arabic Flutter Community

[Report Bug](https://github.com/AhmedAlboishe/arabic_justified_text/issues) · [Request Feature](https://github.com/AhmedAlboishe/arabic_justified_text/issues)

</div>
