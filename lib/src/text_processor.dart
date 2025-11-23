/// Utility class for processing and analyzing Arabic text.
///
/// Provides methods for detecting Arabic characters, handling diacritics,
/// and determining valid Kashida positions in Arabic text.
class TextProcessor {
  static const _excludedWords = [
    'الله',
    'اللَّه',
    'اللّه',
    'ٱلله',
    'ٱللَّه',
    'لله',
    'للَّه',
    'ولله',
    'والله',
    'بالله',
    'تالله',
  ];

  static const _punctuationMarks = [
    '،',
    '.',
    '!',
    '?',
    '؟',
    ';',
    ':',
    '-',
    '–',
    '—',
    '(',
    ')',
    '[',
    ']',
    '{',
    '}',
    '"',
    "'",
    '«',
    '»',
    '…',
    '..',
    '...',
  ];

  /// Checks if a character is an Arabic character.
  ///
  /// Returns true if the character is in the Arabic Unicode range.
  static bool isArabicChar(String char) {
    if (char.isEmpty) return false;
    final code = char.codeUnitAt(0);
    return (code >= 0x0600 && code <= 0x06FF) ||
        (code >= 0x0750 && code <= 0x077F) ||
        (code >= 0xFB50 && code <= 0xFDFF) ||
        (code >= 0xFE70 && code <= 0xFEFF);
  }

  /// Checks if a character is an Arabic diacritic (Tashkeel).
  ///
  /// Returns true for characters like Fatha, Damma, Kasra, Sukun, Shadda, etc.
  static bool isDiacritic(String char) {
    if (char.isEmpty) return false;
    final code = char.codeUnitAt(0);
    return (code >= 0x064B && code <= 0x065F) ||
        code == 0x0670 ||
        (code >= 0x06D6 && code <= 0x06ED);
  }

  /// Checks if a word contains Arabic characters.
  ///
  /// Returns true if at least one character in the word is Arabic.
  static bool isArabicWord(String word) {
    if (word.isEmpty) return false;
    return word.split('').any((char) => isArabicChar(char));
  }

  /// Removes all punctuation marks from the given text.
  ///
  /// This method strips common Arabic and English punctuation marks from the text,
  /// which is useful for comparing words that may have trailing or surrounding
  /// punctuation.
  ///
  /// Parameters:
  /// * [text] - The text to clean
  ///
  /// Returns the text with all punctuation marks removed and trimmed.
  ///
  /// Example:
  /// ```dart
  /// removePunctuation('اللّٰه،')   // Returns: 'اللّٰه'
  /// removePunctuation('(hello!)') // Returns: 'hello'
  /// removePunctuation('text...')  // Returns: 'text'
  /// ```
  ///
  /// See also:
  /// * [cleanWord], which removes both punctuation and diacritics
  /// * [removeDiacritics], which removes only diacritics
  static String removePunctuation(String text) {
    String result = text;
    for (final mark in _punctuationMarks) {
      result = result.replaceAll(mark, '');
    }
    return result.trim();
  }

  /// Removes all diacritics from text.
  ///
  /// Returns the text with all Tashkeel marks removed.
  static String removeDiacritics(String text) {
    return text.split('').where((char) => !isDiacritic(char)).join();
  }

  /// Cleans a word by removing both punctuation marks and diacritics.
  ///
  /// This method performs a complete cleanup of an Arabic word by:
  /// 1. Removing all punctuation marks (using [removePunctuation])
  /// 2. Removing all diacritics/Tashkeel (using [removeDiacritics])
  ///
  /// This is essential for accurate word comparison, especially when checking
  /// against the excluded words list, as words may appear with various
  /// combinations of punctuation and diacritics.
  ///
  /// Parameters:
  /// * [word] - The word to clean
  ///
  /// Returns the word with all punctuation and diacritics removed.
  ///
  /// Example:
  /// ```dart
  /// cleanWord('اللّٰه،')      // Returns: 'اللّٰه'
  /// cleanWord('اللَّه.')     // Returns: 'اللّٰه'
  /// cleanWord('(اللَّه،)')   // Returns: 'اللّٰه'
  /// cleanWord('مُحَمَّد!')   // Returns: 'محمد'
  /// ```
  ///
  /// This ensures that words like "اللّٰه،" or "اللَّه." are correctly
  /// identified as the sacred word "اللّٰه" and excluded from Kashida.
  ///
  /// See also:
  /// * [removePunctuation], which removes only punctuation
  /// * [removeDiacritics], which removes only diacritics
  /// * [isExcludedWord], which uses this method for word comparison
  static String cleanWord(String word) {
    String cleaned = removePunctuation(word);

    cleaned = removeDiacritics(cleaned);

    return cleaned;
  }

  /// Checks if a word should be excluded from Kashida application.
  ///
  /// Parameters:
  /// * [word] - The word to check
  /// * [customExcluded] - Optional additional words to exclude
  ///
  /// Returns true if the word is in the default excluded list (like "اللّٰه")
  /// or in the custom excluded list.
  static bool isExcludedWord(String word, {List<String>? customExcluded}) {
    final allExcluded = [
      ..._excludedWords,
      if (customExcluded != null) ...customExcluded,
    ];

    final cleanedWord = cleanWord(word);

    if (cleanedWord.isEmpty) return false;

    for (final excluded in allExcluded) {
      final cleanedExcluded = cleanWord(excluded);
      if (cleanedWord == cleanedExcluded) {
        return true;
      }
    }

    return false;
  }

  /// Checks if Kashida can be added after a character.
  ///
  /// Parameters:
  /// * [char] - The current character
  /// * [nextChar] - The following character
  ///
  /// Returns true if Kashida can be placed between these characters
  /// according to Arabic typography rules.
  static bool canAddKashida(String char, String nextChar) {
    const connecting = [
      'ب',
      'ت',
      'ث',
      'ن',
      'ي',
      'س',
      'ش',
      'ف',
      'ق',
      'ل',
      'م',
      'ك',
      'ط',
      'ظ',
      'ع',
      'غ',
      'ه',
      'ح',
      'ج',
      'خ',
      'ص',
      'ض',
      'ة',
      'ى',
    ];

    const excluded = ['ا', 'أ', 'إ', 'آ', 'د', 'ذ', 'ر', 'ز', 'و', 'ء', '،'];

    return connecting.contains(char) &&
        !excluded.contains(nextChar) &&
        isArabicChar(nextChar);
  }

  /// Counts the number of diacritics after a position in a word.
  static int countDiacriticsAfter(String word, int position) {
    int count = 0;
    for (int i = position + 1; i < word.length; i++) {
      if (isDiacritic(word[i])) {
        count++;
      } else {
        break;
      }
    }
    return count;
  }

  /// Gets all valid Kashida positions in a word.
  ///
  /// Parameters:
  /// * [word] - The word to analyze
  /// * [customExcluded] - Optional words to exclude
  ///
  /// Returns a list of [KashidaPosition] objects indicating where
  /// Kashida can be added.
  static List<KashidaPosition> getKashidaPositions(
    String word, {
    List<String>? customExcluded,
  }) {
    if (isExcludedWord(word, customExcluded: customExcluded)) {
      return [];
    }

    final positions = <KashidaPosition>[];

    int i = 0;
    while (i < word.length - 1) {
      final char = word[i];

      int diacriticCount = countDiacriticsAfter(word, i);

      int nextCharIndex = i + 1 + diacriticCount;

      if (nextCharIndex < word.length) {
        final nextChar = word[nextCharIndex];

        if (canAddKashida(char, nextChar)) {
          positions.add(
            KashidaPosition(
              position: i + 1 + diacriticCount,
              charIndex: i,
              diacriticCount: diacriticCount,
            ),
          );
        }
      }

      i++;
    }

    return positions;
  }
}

/// Represents a position where Kashida can be inserted in a word.
///
/// Contains information about the insertion point and any diacritics
/// that need to be preserved.
class KashidaPosition {
  /// The position in the string where Kashida should be inserted.
  final int position;

  /// The index of the base character (before diacritics).
  final int charIndex;

  /// The number of diacritics after the base character.
  final int diacriticCount;

  /// Creates a Kashida position descriptor.
  KashidaPosition({
    required this.position,
    required this.charIndex,
    required this.diacriticCount,
  });
}
