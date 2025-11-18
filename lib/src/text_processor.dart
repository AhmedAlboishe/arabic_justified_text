class TextProcessor {
  /// تحقق إذا كان الحرف عربي
  static bool isArabicChar(String char) {
    if (char.isEmpty) return false;
    final code = char.codeUnitAt(0);
    return (code >= 0x0600 && code <= 0x06FF) ||
        (code >= 0x0750 && code <= 0x077F) ||
        (code >= 0xFB50 && code <= 0xFDFF) ||
        (code >= 0xFE70 && code <= 0xFEFF);
  }

  /// تحقق إذا كان الحرف تشكيل
  static bool isDiacritic(String char) {
    if (char.isEmpty) return false;
    final code = char.codeUnitAt(0);
    return (code >= 0x064B && code <= 0x065F) || // التشكيل الأساسي
        code == 0x0670 || // ألف خنجرية
        (code >= 0x06D6 && code <= 0x06ED); // تشكيلات إضافية
  }

  /// تحقق إذا كانت الكلمة عربية
  static bool isArabicWord(String word) {
    if (word.isEmpty) return false;
    return word.split('').any((char) => isArabicChar(char));
  }

  /// تحقق إذا يمكن إضافة كشيدة
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

  /// احصل على عدد التشكيلات بعد الحرف
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

  /// احصل على مواقع الكشيدة في الكلمة (مع مراعاة التشكيل)
  static List<KashidaPosition> getKashidaPositions(String word) {
    final positions = <KashidaPosition>[];

    int i = 0;
    while (i < word.length - 1) {
      final char = word[i];

      // تخطى التشكيل
      int diacriticCount = countDiacriticsAfter(word, i);

      // الحرف التالي (بعد التشكيل)
      int nextCharIndex = i + 1 + diacriticCount;

      if (nextCharIndex < word.length) {
        final nextChar = word[nextCharIndex];

        if (canAddKashida(char, nextChar)) {
          // الموقع يكون بعد الحرف والتشكيل
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

/// معلومات موقع الكشيدة
class KashidaPosition {
  final int position; // الموقع الفعلي للإضافة (بعد التشكيل)
  final int charIndex; // فهرس الحرف الأساسي
  final int diacriticCount; // عدد التشكيلات

  KashidaPosition({
    required this.position,
    required this.charIndex,
    required this.diacriticCount,
  });
}
