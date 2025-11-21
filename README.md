<div align="center">

# 📝 Arabic Justified Text

### Beautiful Arabic text justification using Kashida (ـ) instead of spaces

[![pub package](https://img.shields.io/pub/v/arabic_justified_text.svg)](https://pub.dev/packages/arabic_justified_text)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/AhmedAlboishe/arabic_justified_text/blob/main/LICENSE)

<!-- [English](#english) | [العربية](#arabic)

![Demo](https://via.placeholder.com/800x400/4CAF50/FFFFFF?text=Add+Your+Demo+GIF+Here) -->

</div>

---

## <a name="english"></a>🌟 Overview

**Arabic Justified Text** is a Flutter package that provides beautiful text justification for Arabic text using **Kashida (ـ)** instead of adding extra spaces between words. This creates a more natural and aesthetically pleasing appearance for justified Arabic text.

### ✨ Features

- ✅ **Smart Kashida Distribution** - Intelligently distributes Kashida across words
- ✅ **Diacritics Support** - Properly handles Arabic diacritics (Tashkeel)
- ✅ **Mixed Text Support** - Works with Arabic and English text together
- ✅ **Line Break Support** - Respects `\n` characters in text
- ✅ **Theme Integration** - Inherits default text styles from your app theme
- ✅ **Customizable** - Full control over text styling
- ✅ **Performance Optimized** - Efficient text processing
- ✅ **RTL Support** - Built-in right-to-left text direction

---

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  arabic_justified_text: ^1.0.0
```
Then run:

```Dart
flutter pub get
```

## 🚀 Quick Start
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
  'النص العربي الطويل هنا...',
  style: TextStyle(fontSize: 16, height: 1.8),
  enableKashida: true,
  maxLines: 5,
  overflow: TextOverflow.ellipsis,
)
```

---

## 📖 Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `text` | `String` | **required** | The text to display |
| `style` | `TextStyle?` | `null` | Text style (inherits from theme if null) |
| `enableKashida` | `bool` | `true` | Enable/disable Kashida justification |
| `maxLines` | `int?` | `null` | Maximum number of lines |
| `overflow` | `TextOverflow?` | `null` | How to handle text overflow |

---

## 💡 Examples
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
  'نص طويل جداً...',
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
---

## 🤝 Contributing
Contributions are welcome! Here's how you can help:

1. 🐛 **Report Bugs** - Open an issue describing the bug
2. 💡 **Suggest Features** - Share your ideas for improvements
3. 🔧 **Submit Pull Requests** - Fix bugs or add features
4. 📖 **Improve Documentation** - Help make docs better
5. ⭐ **Star the Repo** - Show your support!

---

## 📋 Roadmap
- Add more customization options
- Support for different Kashida styles
- Performance improvements for very long texts
- Add more examples and use cases
- Support for other RTL languages (Persian, Urdu)
- Web demo

--- 

## 🐛 Known Issues
- Very long words might overflow on narrow screens (use maxLines to handle)
- Performance may vary with extremely long texts (>10,000 characters)

---

## ⭐ Show Your Support
If this package helped you, please give it a ⭐ on [GitHub!](https://github.com/AhmedAlboishe/arabic_justified_text)