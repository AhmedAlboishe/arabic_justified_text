import 'package:flutter/material.dart';

import 'kashida_calculator.dart';

/// A widget that displays Arabic text with beautiful justification using Kashida (ـ).
///
/// This widget provides natural Arabic text justification by adding Kashida characters
/// instead of increasing spaces between words, creating a more aesthetically pleasing
/// appearance for justified Arabic text.
///
/// Example:
/// ```dart
/// ArabicJustifiedText(
///   'في عالم التكنولوجيا الحديثة، أصبحت تطبيقات الهاتف المحمول جزءاً أساسياً',
///   style: TextStyle(fontSize: 18),
///   enableKashida: true,
/// )
/// ```
///
/// See also:
/// * [ArabicJustifiedRichText], for complex text with multiple styles
class ArabicJustifiedText extends StatelessWidget {
  /// The text to display.
  ///
  /// This will be justified using Kashida if [enableKashida] is true.
  final String text;

  /// The style to use for the text.
  ///
  /// If null, defaults to the [DefaultTextStyle] of the [BuildContext].
  final TextStyle? style;

  /// An optional maximum number of lines for the text to span.
  ///
  /// If the text exceeds the given number of lines, it will be truncated
  /// according to [overflow].
  final int? maxLines;

  /// How visual overflow should be handled.
  ///
  /// Defaults to [TextOverflow.clip] if null.
  final TextOverflow? overflow;

  /// The directionality of the text.
  ///
  /// Defaults to [TextDirection.rtl] (right-to-left) for Arabic text.
  final TextDirection textDirection;

  /// How the text should be aligned horizontally.
  ///
  /// Defaults to [TextAlign.justify].
  final TextAlign textAlign;

  /// Whether to enable Kashida-based justification.
  ///
  /// If false, uses standard text justification with spaces.
  /// Defaults to true.
  final bool enableKashida;

  /// A list of words to exclude from Kashida application.
  ///
  /// Words in this list will not have Kashida characters added.
  /// The word "Allah" (الله) and its variations are automatically excluded.
  ///
  /// Example:
  /// ```dart
  /// ArabicJustifiedText(
  ///   'محمد رسول الله',
  ///   excludedWords: ['محمد', 'رسول'],
  /// )
  /// ```
  final List<String>? excludedWords;

  /// Creates an Arabic justified text widget.
  ///
  /// The [text] argument must not be null.
  ///
  /// Example:
  /// ```dart
  /// ArabicJustifiedText(
  ///   'النص العربي هنا',
  ///   style: TextStyle(fontSize: 16),
  ///   enableKashida: true,
  ///   maxLines: 5,
  /// )
  /// ```
  const ArabicJustifiedText(
    this.text, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
    this.textDirection = TextDirection.rtl,
    this.textAlign = TextAlign.justify,
    this.enableKashida = true,
    this.excludedWords,
  });

  @override
  Widget build(BuildContext context) {
    if (!enableKashida) {
      return Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        textDirection: textDirection,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final textStyle = DefaultTextStyle.of(context).style.merge(style);

        final paragraphs = text.split('\n');
        final allSpans = <TextSpan>[];

        for (int p = 0; p < paragraphs.length; p++) {
          final paragraph = paragraphs[p];

          if (paragraph.trim().isEmpty) {
            allSpans.add(const TextSpan(text: '\n'));
            continue;
          }

          final lines = _splitIntoLines(
            paragraph,
            textStyle,
            constraints.maxWidth,
          );

          for (int i = 0; i < lines.length; i++) {
            final isLastLineInParagraph = i == lines.length - 1;

            final lineText = isLastLineInParagraph
                ? lines[i]
                : _justifyLine(lines[i], textStyle, constraints.maxWidth);

            allSpans.add(TextSpan(text: lineText));

            if (!isLastLineInParagraph || p < paragraphs.length - 1) {
              allSpans.add(const TextSpan(text: '\n'));
            }
          }
        }

        return RichText(
          textDirection: textDirection,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow ?? TextOverflow.clip,
          text: TextSpan(style: textStyle, children: allSpans),
        );
      },
    );
  }

  List<String> _splitIntoLines(String text, TextStyle style, double maxWidth) {
    final words = text.split(RegExp(r'\s+'));
    final lines = <String>[];
    String currentLine = '';

    for (final word in words) {
      final testLine = currentLine.isEmpty ? word : '$currentLine $word';

      final painter = TextPainter(
        text: TextSpan(text: testLine, style: style),
        textDirection: textDirection,
      )..layout();

      if (painter.width <= maxWidth) {
        currentLine = testLine;
      } else {
        if (currentLine.isNotEmpty) {
          lines.add(currentLine);
        }
        currentLine = word;
      }
    }

    if (currentLine.isNotEmpty) {
      lines.add(currentLine);
    }

    return lines;
  }

  String _justifyLine(String line, TextStyle style, double maxWidth) {
    final words = line.split(' ');

    if (words.length <= 1) return line;

    final painter = TextPainter(
      text: TextSpan(text: line, style: style),
      textDirection: textDirection,
    )..layout();

    final currentWidth = painter.width;

    final kashidaPainter = TextPainter(
      text: TextSpan(text: 'ـ', style: style),
      textDirection: textDirection,
    )..layout();

    final kashidaWidth = kashidaPainter.width;

    if (kashidaWidth <= 0 || currentWidth >= maxWidth) return line;

    final spaceNeeded = maxWidth - currentWidth;
    int kashidasNeeded = (spaceNeeded / kashidaWidth).floor();

    if (kashidasNeeded <= 0) return line;

    final arabicWordInfo = <MapEntry<int, int>>[];

    for (int i = 0; i < words.length; i++) {
      final count = KashidaCalculator.getAvailableKashidaCount(
        words[i],
        excludedWords: excludedWords,
      );
      if (count > 0) {
        arabicWordInfo.add(MapEntry(i, count));
      }
    }

    if (arabicWordInfo.isEmpty) return line;

    final distribution = <int, int>{};
    int remaining = kashidasNeeded;

    while (remaining > 0) {
      bool distributed = false;

      for (final entry in arabicWordInfo) {
        if (remaining <= 0) break;

        final wordIndex = entry.key;
        final maxPositions = entry.value;
        final currentKashidas = distribution[wordIndex] ?? 0;

        final maxKashidasPerWord = maxPositions * 3;

        if (currentKashidas < maxKashidasPerWord) {
          distribution[wordIndex] = currentKashidas + 1;
          remaining--;
          distributed = true;
        }
      }

      if (!distributed) break;
    }

    final resultWords = <String>[];
    for (int i = 0; i < words.length; i++) {
      String word = words[i];
      final kashidaCount = distribution[i] ?? 0;

      word = KashidaCalculator.addKashidasToWord(
        word,
        kashidaCount,
        excludedWords: excludedWords,
      );

      resultWords.add(word);
    }

    return resultWords.join(' ');
  }
}
