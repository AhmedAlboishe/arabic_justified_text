import 'package:flutter/material.dart';

import 'kashida_calculator.dart';

/// A widget that displays rich text (with multiple styles) with Kashida justification.
///
/// This widget is similar to [ArabicJustifiedText] but supports [TextSpan] with
/// multiple styles, allowing for complex text formatting with different colors,
/// fonts, and decorations while maintaining Kashida-based justification.
///
/// **Note:** This widget currently does **not** support [WidgetSpan]. If your
/// [textSpan] contains any [WidgetSpan] children, the widget will fall back to
/// standard [RichText] rendering without Kashida justification. Use
/// [ArabicJustifiedText] for simple text or consider splitting your text
/// if you need both widgets and Kashida.
///
/// Example:
/// ```dart
/// ArabicJustifiedRichText(
///   textSpan: TextSpan(
///     style: TextStyle(fontSize: 18),
///     children: [
///       TextSpan(text: 'بسم الله '),
///       TextSpan(
///         text: 'الرحمن الرحيم',
///         style: TextStyle(
///           fontWeight: FontWeight.bold,
///           color: Colors.blue,
///         ),
///       ),
///     ],
///   ),
/// )
/// ```
///
/// See also:
/// * [ArabicJustifiedText], for simple text with single style
/// * [RichText], the underlying Flutter widget for rich text
class ArabicJustifiedRichText extends StatelessWidget {
  /// The text span to display with multiple styles.
  ///
  /// Must contain only [TextSpan] children. [WidgetSpan] is not supported
  /// and will cause the widget to fall back to standard [RichText] rendering.
  final InlineSpan textSpan;

  /// An optional maximum number of lines for the text to span.
  ///
  /// If the text exceeds the given number of lines, it will be truncated
  /// according to [overflow].
  final int? maxLines;

  /// How visual overflow should be handled.
  ///
  /// Defaults to [TextOverflow.clip] if null
  final TextOverflow? overflow;

  /// Whether to enable Kashida-based justification.
  ///
  /// If false, uses standard [RichText] rendering without Kashida.
  /// Defaults to true.
  final bool enableKashida;

  /// The directionality of the text.
  ///
  /// Defaults to [TextDirection.rtl] (right-to-left) for Arabic text.
  final TextDirection textDirection;

  /// How the text should be aligned horizontally.
  ///
  /// Defaults to [TextAlign.justify].
  final TextAlign textAlign;

  /// A list of words to exclude from Kashida application.
  ///
  /// Words in this list will not have Kashida characters added.
  /// The word "Allah" (الله) and its variations are automatically excluded.
  ///
  /// Example:
  /// ```dart
  /// ArabicJustifiedRichText(
  ///   excludedWords: ['محمد', 'رسول', 'الرحمن'],
  ///   textSpan: TextSpan(text: '...'),
  /// )
  /// ```
  final List<String>? excludedWords;

  /// Creates an Arabic justified rich text widget.
  ///
  /// The [textSpan] argument must not be null and should contain only
  /// [TextSpan] children (no [WidgetSpan]).
  ///
  /// Example:
  /// ```dart
  /// ArabicJustifiedRichText(
  ///   textSpan: TextSpan(
  ///     children: [
  ///       TextSpan(text: 'عادي '),
  ///       TextSpan(text: 'عريض', style: TextStyle(fontWeight: FontWeight.bold)),
  ///     ],
  ///   ),
  /// )
  /// ```
  const ArabicJustifiedRichText({
    super.key,
    required this.textSpan,
    this.maxLines,
    this.overflow,
    this.enableKashida = true,
    this.textDirection = TextDirection.rtl,
    this.textAlign = TextAlign.justify,
    this.excludedWords,
  });

  @override
  Widget build(BuildContext context) {
    if (!enableKashida) {
      return RichText(
        text: textSpan,
        textDirection: textDirection,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow ?? TextOverflow.clip,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final segments = _extractTextSegments(textSpan);

        final lines = _splitIntoLines(segments, constraints.maxWidth);

        final processedSpans = _buildJustifiedSpans(
          lines,
          constraints.maxWidth,
        );

        return RichText(
          textDirection: textDirection,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow ?? TextOverflow.clip,
          text: TextSpan(children: processedSpans),
        );
      },
    );
  }

  List<TextSegment> _extractTextSegments(InlineSpan span) {
    final segments = <TextSegment>[];

    void extractFromSpan(InlineSpan span, TextStyle? parentStyle) {
      if (span is TextSpan) {
        final style = parentStyle?.merge(span.style) ?? span.style;

        if (span.text != null && span.text!.isNotEmpty) {
          segments.add(
            TextSegment(
              text: span.text!,
              style: style,
            ),
          );
        }

        if (span.children != null) {
          for (final child in span.children!) {
            extractFromSpan(child, style);
          }
        }
      }
    }

    extractFromSpan(span, null);
    return segments;
  }

  List<LineSegments> _splitIntoLines(
    List<TextSegment> segments,
    double maxWidth,
  ) {
    final lines = <LineSegments>[];
    var currentLine = <TextSegment>[];
    var currentWidth = 0.0;

    for (final segment in segments) {
      final parts = segment.text.split('\n');

      for (int i = 0; i < parts.length; i++) {
        final part = parts[i];

        if (part.isEmpty) {
          if (i > 0) {
            if (currentLine.isNotEmpty) {
              lines.add(LineSegments(segments: List.from(currentLine)));
              currentLine.clear();
              currentWidth = 0;
            }
          }
          continue;
        }

        final words = part.split(' ');

        for (int wordIndex = 0; wordIndex < words.length; wordIndex++) {
          final word = words[wordIndex];
          final testText = word + (wordIndex < words.length - 1 ? ' ' : '');

          final painter = TextPainter(
            text: TextSpan(text: testText, style: segment.style),
            textDirection: textDirection,
          )..layout();

          if (currentWidth + painter.width <= maxWidth) {
            currentLine.add(
              TextSegment(
                text: testText,
                style: segment.style,
              ),
            );
            currentWidth += painter.width;
          } else {
            if (currentLine.isNotEmpty) {
              lines.add(LineSegments(segments: List.from(currentLine)));
              currentLine.clear();
              currentWidth = 0;
            }

            currentLine.add(
              TextSegment(
                text: testText,
                style: segment.style,
              ),
            );
            currentWidth = painter.width;
          }
        }

        if (i < parts.length - 1) {
          if (currentLine.isNotEmpty) {
            lines.add(LineSegments(segments: List.from(currentLine)));
            currentLine.clear();
            currentWidth = 0;
          }
        }
      }
    }

    if (currentLine.isNotEmpty) {
      lines.add(LineSegments(segments: currentLine));
    }

    return lines;
  }

  List<InlineSpan> _buildJustifiedSpans(
    List<LineSegments> lines,
    double maxWidth,
  ) {
    final spans = <InlineSpan>[];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final isLastLine = i == lines.length - 1;

      if (isLastLine || line.segments.length == 1) {
        for (final segment in line.segments) {
          spans.add(TextSpan(text: segment.text, style: segment.style));
        }
      } else {
        final justifiedSegments = _justifyLine(line, maxWidth);
        for (final segment in justifiedSegments) {
          spans.add(TextSpan(text: segment.text, style: segment.style));
        }
      }

      if (!isLastLine) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return spans;
  }

  List<TextSegment> _justifyLine(LineSegments line, double maxWidth) {
    double currentWidth = 0;
    for (final segment in line.segments) {
      final painter = TextPainter(
        text: TextSpan(text: segment.text, style: segment.style),
        textDirection: textDirection,
      )..layout();
      currentWidth += painter.width;
    }

    final firstStyle = line.segments.first.style;
    final kashidaPainter = TextPainter(
      text: TextSpan(text: 'ـ', style: firstStyle),
      textDirection: textDirection,
    )..layout();
    final kashidaWidth = kashidaPainter.width;

    if (kashidaWidth <= 0 || currentWidth >= maxWidth) {
      return line.segments;
    }

    final spaceNeeded = maxWidth - currentWidth;
    int kashidasNeeded = (spaceNeeded / kashidaWidth).floor();

    if (kashidasNeeded <= 0) {
      return line.segments;
    }

    final arabicWordsInfo = <_ArabicWordInfo>[];

    for (int segIndex = 0; segIndex < line.segments.length; segIndex++) {
      final segment = line.segments[segIndex];
      final words = segment.text.split(' ');

      for (int wordIndex = 0; wordIndex < words.length; wordIndex++) {
        final word = words[wordIndex];
        final availablePositions = KashidaCalculator.getAvailableKashidaCount(
          word,
          excludedWords: excludedWords,
        );

        if (availablePositions > 0) {
          arabicWordsInfo.add(
            _ArabicWordInfo(
              segmentIndex: segIndex,
              wordIndex: wordIndex,
              word: word,
              maxPositions: availablePositions,
              kashidaCount: 0,
            ),
          );
        }
      }
    }

    if (arabicWordsInfo.isEmpty) {
      return line.segments;
    }

    int remaining = kashidasNeeded;
    int round = 0;
    const maxRounds = 20;

    while (remaining > 0 && round < maxRounds) {
      bool distributed = false;

      for (final wordInfo in arabicWordsInfo) {
        if (remaining <= 0) break;

        final maxKashidas = wordInfo.maxPositions * 3;

        if (wordInfo.kashidaCount < maxKashidas) {
          wordInfo.kashidaCount++;
          remaining--;
          distributed = true;
        }
      }

      if (!distributed) break;
      round++;
    }

    final result = <TextSegment>[];

    for (int segIndex = 0; segIndex < line.segments.length; segIndex++) {
      final segment = line.segments[segIndex];
      final words = segment.text.split(' ');
      final processedWords = <String>[];

      for (int wordIndex = 0; wordIndex < words.length; wordIndex++) {
        final word = words[wordIndex];

        final wordInfo = arabicWordsInfo.firstWhere(
          (info) =>
              info.segmentIndex == segIndex && info.wordIndex == wordIndex,
          orElse: () => _ArabicWordInfo(
            segmentIndex: segIndex,
            wordIndex: wordIndex,
            word: word,
            maxPositions: 0,
            kashidaCount: 0,
          ),
        );

        if (wordInfo.kashidaCount > 0) {
          processedWords.add(
            KashidaCalculator.addKashidasToWord(
              word,
              wordInfo.kashidaCount,
              excludedWords: excludedWords,
            ),
          );
        } else {
          processedWords.add(word);
        }
      }

      result.add(
        TextSegment(
          text: processedWords.join(' '),
          style: segment.style,
        ),
      );
    }

    return result;
  }
}

class TextSegment {
  final String text;
  final TextStyle? style;

  TextSegment({required this.text, this.style});
}

class LineSegments {
  final List<TextSegment> segments;

  LineSegments({required this.segments});
}

class _ArabicWordInfo {
  final int segmentIndex;
  final int wordIndex;
  final String word;
  final int maxPositions;
  int kashidaCount;

  _ArabicWordInfo({
    required this.segmentIndex,
    required this.wordIndex,
    required this.word,
    required this.maxPositions,
    required this.kashidaCount,
  });
}
