import 'text_processor.dart';

class KashidaCalculator {
  static String addKashidasToWord(String word, int totalKashidas) {
    if (totalKashidas <= 0 || !TextProcessor.isArabicWord(word)) {
      return word;
    }

    final positions = TextProcessor.getKashidaPositions(word);
    if (positions.isEmpty) return word;

    final kashidasPerPosition = List<int>.filled(positions.length, 0);

    for (int i = 0; i < totalKashidas; i++) {
      final posIndex = i % positions.length;
      kashidasPerPosition[posIndex]++;
    }

    String result = word;
    for (int i = positions.length - 1; i >= 0; i--) {
      final pos = positions[i];
      final kashidaCount = kashidasPerPosition[i];

      if (kashidaCount > 0) {
        final kashidas = 'ـ' * kashidaCount;
        result =
            result.substring(0, pos.position) +
            kashidas +
            result.substring(pos.position);
      }
    }

    return result;
  }

  static int getAvailableKashidaCount(String word) {
    if (!TextProcessor.isArabicWord(word)) return 0;
    return TextProcessor.getKashidaPositions(word).length;
  }
}
