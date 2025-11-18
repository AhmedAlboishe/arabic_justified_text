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

    const excluded = [
      'ا',
      'أ',
      'إ',
      'آ',
      'د',
      'ذ',
      'ر',
      'ز',
      'و',
      'ء',
      '،',
      'َ',
      'ٕ',
      'ً',
      'ّ',
      'ٌ',
      'ٍ',
      'ْ',
      'ٔ',
      'ٰ',
      'ٖ',
      'ٓ',
      'ِ',
      'ُ',
    ];

    return connecting.contains(char) &&
        !excluded.contains(nextChar) &&
        isArabicChar(nextChar);
  }

  /// احصل على مواقع الكشيدة في الكلمة
  static List<int> getKashidaPositions(String word) {
    final positions = <int>[];
    for (int i = 0; i < word.length - 1; i++) {
      if (canAddKashida(word[i], word[i + 1])) {
        positions.add(i + 1);
      }
    }
    return positions;
  }
}
