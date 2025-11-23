## 0.0.8
 * **Update README file**



## 0.0.7

### 🐛 Bug Fixes
* **Fixed sacred word detection with punctuation** - Words like "اللّٰه،" or "اللّٰه." are now correctly excluded from Kashida
* **Improved word comparison** - Added punctuation removal before comparing excluded words
* **Better handling of mixed text** - Words with both diacritics and punctuation are now properly cleaned and compared


## 0.0.6

### 📚 Documentation
* **Added comprehensive dartdoc comments** - All public APIs now have detailed documentation
* **Improved API documentation** - Added examples and usage guides for all widgets
* **Clarified WidgetSpan limitation** - Documented that `ArabicJustifiedRichText` does not support `WidgetSpan`


## 0.0.5

### New Features
* Added `ArabicJustifiedRichText` widget for complex multi-style text
* Automatic exclusion of "Allah" (اللّٰه) from Kashida
* Added `excludedWords` parameter for custom word exclusions
* Added `textDirection` and `textAlign` parameters


## 0.0.4
 * **Update README.md file**


## 0.0.3
 * **Fix headers and links in README.md**


## 0.0.2
 * **Update README.md file**


## 0.0.1

### Added
* ✨ Initial release
* ✅ Smart Kashida distribution
* ✅ Diacritics (Tashkeel) support
* ✅ Mixed text support (Arabic + English)
* ✅ Line break (`\n`) support
* ✅ Theme integration
* ✅ Full customization options
* 📖 Comprehensive documentation

### Features
* Intelligent Kashida placement
* Proper handling of Arabic typography rules
* Performance optimized text processing
* RTL text direction support

<!-- ---

## [Unreleased]

### Planned
- [ ] More customization options
- [ ] Performance improvements
- [ ] Support for other RTL languages
