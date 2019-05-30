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

class StyledText extends StatefulWidget {
  final String text;
  final bool autoLineBreak;
  final TextStyle style;
  final Map<String, TextStyle> styles;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int maxLines;
  final Locale locale;
  final StrutStyle strutStyle;

  StyledText({
    Key key,
    @required this.text,
    this.autoLineBreak;
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
        (widget.styles != oldWidget.styles)) {
      _updateTextSpans();
    }
  }

  // Parse text
  void _updateTextSpans() {
    if (_text != widget.text) {
        
      if(widget.autoLineBreak) {
        _text = widget.text.replaceAll("\n", "<br></br>");
      }else{
        _text = widget.text;
      }
        
      _textSpans = null;
      TextStyle defaultStyle =
          widget.style ?? DefaultTextStyle.of(context).style;
      TextSpan node = TextSpan(style: defaultStyle, children: []);
      ListQueue<TextSpan> textQueue = ListQueue();
      Map<String, String> attributes;

      var xmlStreamer = new XmlStreamer(
          '<?xml version="1.0" encoding="UTF-8"?><root>' + _text + '</root>');
      xmlStreamer.read().listen((e) {
        switch (e.state) {
          case XmlState.Text:
          case XmlState.CDATA:
            node.children
                .add(TextSpan(text: e.value, recognizer: node.recognizer));
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
        if(mounted){
            setState(() {
              _textSpans = node;
            });
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
