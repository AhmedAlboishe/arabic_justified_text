import 'text_processor.dart';

class KashidaCalculator {
  /// أضف كشيدة واحدة للكلمة في أفضل موقع
  static String addOneKashida(String word, int positionIndex) {
    if (!TextProcessor.isArabicWord(word)) return word;

    final positions = TextProcessor.getKashidaPositions(word);
    if (positions.isEmpty || positionIndex >= positions.length) return word;

    final pos = positions[positionIndex];
    return '${word.substring(0, pos)}ـ${word.substring(pos)}';
  }

  /// احصل على عدد مواقع الكشيدة المتاحة
  static int getAvailableKashidaCount(String word) {
    if (!TextProcessor.isArabicWord(word)) return 0;
    return TextProcessor.getKashidaPositions(word).length;
  }
}
