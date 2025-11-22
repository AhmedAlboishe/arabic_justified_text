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

  static bool isArabicChar(String char) {
    if (char.isEmpty) return false;
    final code = char.codeUnitAt(0);
    return (code >= 0x0600 && code <= 0x06FF) ||
        (code >= 0x0750 && code <= 0x077F) ||
        (code >= 0xFB50 && code <= 0xFDFF) ||
        (code >= 0xFE70 && code <= 0xFEFF);
  }

  static bool isDiacritic(String char) {
    if (char.isEmpty) return false;
    final code = char.codeUnitAt(0);
    return (code >= 0x064B && code <= 0x065F) ||
        code == 0x0670 ||
        (code >= 0x06D6 && code <= 0x06ED);
  }

  static bool isArabicWord(String word) {
    if (word.isEmpty) return false;
    return word.split('').any((char) => isArabicChar(char));
  }

  static String removeDiacritics(String text) {
    return text.split('').where((char) => !isDiacritic(char)).join();
  }

  static bool isExcludedWord(String word, {List<String>? customExcluded}) {
    final allExcluded = [
      ..._excludedWords,
      if (customExcluded != null) ...customExcluded,
    ];

    final wordWithoutDiacritics = removeDiacritics(word);

    for (final excluded in allExcluded) {
      final excludedWithoutDiacritics = removeDiacritics(excluded);
      if (wordWithoutDiacritics == excludedWithoutDiacritics) {
        return true;
      }
    }

    return false;
  }

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

class KashidaPosition {
  final int position;
  final int charIndex;
  final int diacriticCount;

  KashidaPosition({
    required this.position,
    required this.charIndex,
    required this.diacriticCount,
  });
}
