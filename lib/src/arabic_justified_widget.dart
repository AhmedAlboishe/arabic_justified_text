import 'package:flutter/material.dart';

import 'kashida_calculator.dart';

class ArabicJustifiedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDirection textDirection;
  final TextAlign textAlign;
  final bool enableKashida;
  final List<String>? excludedWords;

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
        final textStyle = DefaultTextStyle.of(context).style.copyWith(
          color: style?.color,
          fontSize: style?.fontSize,
          fontWeight: style?.fontWeight,
          fontStyle: style?.fontStyle,
          letterSpacing: style?.letterSpacing,
          wordSpacing: style?.wordSpacing,
          height: style?.height,
          decoration: style?.decoration,
          decorationColor: style?.decorationColor,
          decorationStyle: style?.decorationStyle,
          decorationThickness: style?.decorationThickness,
          shadows: style?.shadows,
          fontFamily: style?.fontFamily,
          fontFamilyFallback: style?.fontFamilyFallback,
          backgroundColor: style?.backgroundColor,
          foreground: style?.foreground,
          background: style?.background,
          textBaseline: style?.textBaseline,
          leadingDistribution: style?.leadingDistribution,
          locale: style?.locale,
          fontFeatures: style?.fontFeatures,
          fontVariations: style?.fontVariations,
          debugLabel: style?.debugLabel,
          inherit: style?.inherit,
          overflow: style?.overflow,
        );

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
