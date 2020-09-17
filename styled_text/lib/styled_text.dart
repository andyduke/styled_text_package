library styled_text;

import 'dart:collection';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:xmlstream/xmlstream.dart';

typedef ActionTappedCallback = void Function(
    TextSpan text, Map<String, String> attributes);

class _StyledTextRecoginzer extends TapGestureRecognizer {
  ActionTappedCallback onTextTap;
  TextSpan text;
  Map<String, String> attributes;

  _StyledTextRecoginzer({
    this.text,
    this.attributes,
    this.onTextTap,
  }) : super() {
    this.onTap = _textTap;
  }

  void _textTap() {
    if (onTextTap != null) {
      onTextTap(text, attributes);
    }
  }
}

class ActionTextStyle extends TextStyle {
  final ActionTappedCallback onTap;

  ActionTextStyle({
    bool inherit = true,
    Color color,
    double fontSize,
    FontWeight fontWeight,
    FontStyle fontStyle,
    double letterSpacing,
    double wordSpacing,
    TextBaseline textBaseline,
    double height,
    Locale locale,
    Paint foreground,
    Paint background,
    List<Shadow> shadows,
    TextDecoration decoration,
    Color decorationColor,
    TextDecorationStyle decorationStyle,
    String debugLabel,
    String fontFamily,
    List<String> fontFamilyFallback,
    String package,
    this.onTap,
  }) : super(
          inherit: inherit,
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          letterSpacing: letterSpacing,
          wordSpacing: wordSpacing,
          textBaseline: textBaseline,
          height: height,
          locale: locale,
          foreground: foreground,
          background: background,
          shadows: shadows,
          decoration: decoration,
          decorationColor: decorationColor,
          decorationStyle: decorationStyle,
          debugLabel: debugLabel,
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          package: package,
        );
}

class IconStyle extends TextStyle {
  final IconData icon;

  IconStyle(this.icon);
}

///
/// Text widget with formatting via tags.
/// 
/// Formatting is specified as xml tags. For each tag, you can specify a style in the [styles] parameter.
/// 
/// Example:
/// ```dart
/// StyledText(
///   text: '<red>Red</red> text.',
///   styles: [
///     'red': TextStyle(color: Colors.red),
///   ],
/// )
/// ```
/// See also:
/// 
/// * [TextStyle], which discusses how to style text.
/// 
class StyledText extends StatefulWidget {

  /// The text to display in this widget. The text must be valid xml.
  final String text;

  /// Do not ignore line feeds in the source text.
  @Deprecated('will be removed in 1.0.2, use newLineAsBreaks instead')
  final bool isNewLineAsBreaks;

  /// Treat newlines as line breaks.
  final bool newLineAsBreaks;

  /// Default text style.
  final TextStyle style;

  /// Style map for tags in text.
  /// 
  /// Example:
  /// ```dart
  /// StyledText(
  ///   text: '<red>Red</red> text.',
  ///   styles: [
  ///     'red': TextStyle(color: Colors.red),
  ///   ],
  /// )
  /// ```
  final Map<String, TextStyle> styles;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// The directionality of the text.
  final TextDirection textDirection;

  /// Whether the text should break at soft line breaks.
  ///
  /// If false, the glyphs in the text will be positioned as if there was unlimited horizontal space.
  final bool softWrap;

  /// How visual overflow should be handled.
  final TextOverflow overflow;

  /// The number of font pixels for each logical pixel.
  ///
  /// For example, if the text scale factor is 1.5, text will be 50% larger than
  /// the specified font size.
  final double textScaleFactor;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be truncated according
  /// to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  final int maxLines;

  /// Used to select a font when the same Unicode character can
  /// be rendered differently, depending on the locale.
  ///
  /// It's rarely necessary to set this property. By default its value
  /// is inherited from the enclosing app with `Localizations.localeOf(context)`.
  ///
  /// See [RenderParagraph.locale] for more information.
  final Locale locale;

  /// {@macro flutter.painting.textPainter.strutStyle}
  final StrutStyle strutStyle;

  /// Create a text widget with formatting via tags. 
  ///
  StyledText({
    Key key,
    @required this.text,
    @Deprecated('will be removed in 1.0.2, use newLineAsBreaks instead') this.isNewLineAsBreaks = false,
    this.newLineAsBreaks = false,
    this.style,
    @required this.styles,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor,
    this.maxLines,
    this.locale,
    this.strutStyle,
  }) : super(key: key);

  @override
  _StyledTextState createState() => _StyledTextState();
}

class _StyledTextState extends State<StyledText> {
  String _text;
  TextSpan _textSpans;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateTextSpans();
  }

  @override
  void didUpdateWidget(StyledText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if ((widget.text != oldWidget.text) ||
        (widget.styles != oldWidget.styles) ||
        (widget.style != oldWidget.style) ||
        (widget.newLineAsBreaks != oldWidget.newLineAsBreaks) ||
        (widget.isNewLineAsBreaks != oldWidget.isNewLineAsBreaks)) {
      _updateTextSpans(force: true);
    }
  }

  // Parse text
  void _updateTextSpans({bool force = false}) {
    if (_text != widget.text || force) {
      _text = widget.text;

      String textValue = _text;

      if (widget.newLineAsBreaks || widget.isNewLineAsBreaks) {
        textValue = textValue.replaceAll("\n", '<br/>');
      }

      TextStyle defaultStyle = (widget.style != null)
          ? DefaultTextStyle.of(context).style.merge(widget.style)
          : DefaultTextStyle.of(context).style;
      TextSpan node = TextSpan(style: defaultStyle, children: []);
      ListQueue<TextSpan> textQueue = ListQueue();
      Map<String, String> attributes;

      var xmlStreamer = new XmlStreamer(
          '<?xml version="1.0" encoding="UTF-8"?><root>' + textValue + '</root>');
      xmlStreamer.read().listen((e) {
        switch (e.state) {
          case XmlState.Text:
          case XmlState.CDATA:
            node.children.add(TextSpan(
                text: e.value
                    .replaceAll('&quot;', '"')
                    .replaceAll('&apos;', "'")
                    .replaceAll('&amp;', '&')
                    .replaceAll('&lt;', "<")
                    .replaceAll('&gt;', ">"),
                recognizer: node.recognizer));
            break;

          case XmlState.Open:
            textQueue.addLast(node);

            if (e.value == 'br') {
              node = TextSpan(text: "\n");
            } else {
              final TextStyle style = widget.styles[e.value];
              attributes = {};

              if (style is IconStyle) {
                node = TextSpan(
                  text: String.fromCharCode(style.icon.codePoint),
                  style: TextStyle(
                    fontFamily: style.icon.fontFamily,
                    package: style.icon.fontPackage,
                  ),
                );
              } else {
                final _StyledTextRecoginzer recognizer =
                    ((style is ActionTextStyle) && style.onTap != null)
                        ? _StyledTextRecoginzer(onTextTap: style.onTap)
                        : null;

                node = TextSpan(
                    style: style, children: [], recognizer: recognizer);
              }
            }

            break;

          case XmlState.Closed:
            if (node.recognizer is _StyledTextRecoginzer) {
              (node.recognizer as _StyledTextRecoginzer)
                ..text = node
                ..attributes = attributes;
            }

            final TextSpan child = node;
            node = textQueue.removeLast();
            node.children.add(child);

            break;

          case XmlState.Attribute:
            attributes[e.key] = e.value;
            break;

          case XmlState.Comment:
          case XmlState.StartDocument:
          case XmlState.EndDocument:
          case XmlState.Namespace:
          case XmlState.Top:
            break;
        }
      }).onDone(() {
        if (mounted) {
          setState(() {
            _textSpans = node;
          });
        } else {
          _textSpans = node;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (_textSpans != null)
        ? RichText(
            textAlign: widget.textAlign,
            textDirection: widget.textDirection,
            softWrap: widget.softWrap,
            overflow: widget.overflow,
            textScaleFactor: widget.textScaleFactor ??
                MediaQuery.of(context).textScaleFactor,
            maxLines: widget.maxLines,
            locale: widget.locale,
            strutStyle: widget.strutStyle,
            text: _textSpans,
          )
        : const SizedBox();
  }
}
