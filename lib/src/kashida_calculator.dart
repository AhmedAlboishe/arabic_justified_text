import 'text_processor.dart';

/// Utility class for calculating and applying Kashida to Arabic words.
///
/// This class provides static methods to determine valid Kashida positions
/// in Arabic words and apply Kashida characters for text justification.
class KashidaCalculator {
  /// Adds Kashida characters to an Arabic word.
  ///
  /// Distributes the specified number of Kashida characters across
  /// valid positions in the word while respecting Arabic typography rules.
  ///
  /// Parameters:
  /// * [word] - The Arabic word to process
  /// * [totalKashidas] - Number of Kashida characters to add
  /// * [excludedWords] - Optional list of words to exclude from processing
  ///
  /// Returns the word with Kashida characters added, or the original word
  /// if it's not Arabic or is in the excluded list.
  static String addKashidasToWord(
    String word,
    int totalKashidas, {
    List<String>? excludedWords,
  }) {
    if (totalKashidas <= 0 || !TextProcessor.isArabicWord(word)) {
      return word;
    }

    final positions = TextProcessor.getKashidaPositions(
      word,
      customExcluded: excludedWords,
    );
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
        result = result.substring(0, pos.position) +
            kashidas +
            result.substring(pos.position);
      }
    }

    return result;
  }

  /// Gets the number of valid Kashida positions in a word.
  ///
  /// Returns the count of positions where Kashida can be added
  /// according to Arabic typography rules.
  ///
  /// Parameters:
  /// * [word] - The word to analyze
  /// * [excludedWords] - Optional list of words to exclude
  ///
  /// Returns 0 if the word is not Arabic or is excluded.
  static int getAvailableKashidaCount(
    String word, {
    List<String>? excludedWords,
  }) {
    if (!TextProcessor.isArabicWord(word)) return 0;
    return TextProcessor.getKashidaPositions(
      word,
      customExcluded: excludedWords,
    ).length;
  }
}
