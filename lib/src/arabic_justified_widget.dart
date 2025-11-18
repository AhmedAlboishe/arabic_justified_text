import 'package:flutter/material.dart';

import 'kashida_calculator.dart';

class ArabicJustifiedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool enableKashida;

  const ArabicJustifiedText(
    this.text, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
    this.enableKashida = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enableKashida) {
      return Text(
        text,
        style: style,
        textAlign: TextAlign.justify,
        maxLines: maxLines,
        overflow: overflow,
        textDirection: TextDirection.rtl,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final textStyle = style ?? DefaultTextStyle.of(context).style;

        // قسم النص حسب \n أولاً
        final paragraphs = text.split('\n');
        final allSpans = <TextSpan>[];

        for (int p = 0; p < paragraphs.length; p++) {
          final paragraph = paragraphs[p];

          if (paragraph.trim().isEmpty) {
            // سطر فارغ - احتفظ به
            allSpans.add(const TextSpan(text: '\n'));
            continue;
          }

          // قسم الفقرة لأسطر حسب العرض
          final lines = _splitIntoLines(
            paragraph,
            textStyle,
            constraints.maxWidth,
          );

          for (int i = 0; i < lines.length; i++) {
            final isLastLineInParagraph = i == lines.length - 1;

            // برر السطر إذا مو السطر الأخير في الفقرة
            final lineText = isLastLineInParagraph
                ? lines[i]
                : _justifyLine(lines[i], textStyle, constraints.maxWidth);

            allSpans.add(TextSpan(text: lineText));

            // أضف سطر جديد
            if (!isLastLineInParagraph || p < paragraphs.length - 1) {
              allSpans.add(const TextSpan(text: '\n'));
            }
          }
        }

        return RichText(
          textDirection: TextDirection.rtl,
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
        textDirection: TextDirection.rtl,
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

    // قياس العرض الحالي
    final painter = TextPainter(
      text: TextSpan(text: line, style: style),
      textDirection: TextDirection.rtl,
    )..layout();

    final currentWidth = painter.width;

    // قياس عرض الكشيدة
    final kashidaPainter = TextPainter(
      text: TextSpan(text: 'ـ', style: style),
      textDirection: TextDirection.rtl,
    )..layout();

    final kashidaWidth = kashidaPainter.width;

    if (kashidaWidth <= 0 || currentWidth >= maxWidth) return line;

    // احسب كم كشيدة نحتاج
    final spaceNeeded = maxWidth - currentWidth;
    int kashidasNeeded = (spaceNeeded / kashidaWidth).floor();

    if (kashidasNeeded <= 0) return line;

    // ابحث عن الكلمات العربية
    final arabicWordInfo = <MapEntry<int, int>>[];

    for (int i = 0; i < words.length; i++) {
      final count = KashidaCalculator.getAvailableKashidaCount(words[i]);
      if (count > 0) {
        arabicWordInfo.add(MapEntry(i, count));
      }
    }

    if (arabicWordInfo.isEmpty) return line;

    // وزع الكشيدات
    final distribution = <int, int>{};
    int remaining = kashidasNeeded;
    int round = 0;

    while (remaining > 0 && round < 10) {
      bool added = false;

      for (final entry in arabicWordInfo) {
        if (remaining <= 0) break;

        final wordIndex = entry.key;
        final maxKashidas = entry.value;
        final currentKashidas = distribution[wordIndex] ?? 0;

        if (currentKashidas < maxKashidas) {
          distribution[wordIndex] = currentKashidas + 1;
          remaining--;
          added = true;
        }
      }

      if (!added) break;
      round++;
    }

    // طبق الكشيدات
    final resultWords = <String>[];
    for (int i = 0; i < words.length; i++) {
      String word = words[i];
      final kashidaCount = distribution[i] ?? 0;

      for (int k = 0; k < kashidaCount; k++) {
        word = KashidaCalculator.addOneKashida(word, k);
      }

      resultWords.add(word);
    }

    return resultWords.join(' ');
  }
}
