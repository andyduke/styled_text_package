library styled_text;

import 'dart:collection';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:styled_text/action_text_style.dart';
import 'package:styled_text/custom_text_style.dart';
import 'package:xmlstream/xmlstream.dart';

export 'custom_text_style.dart';
export 'action_text_style.dart';

///
/// The style to insert the icon into styled text.
///
/// Example:
/// ```dart
/// StyledText(
///   text: 'Text with alarm <alarm/> icon.',
///   styles: {
///     'alarm': IconStyle(Icons.alarm),
///   },
/// )
/// ```
///
class IconStyle extends TextStyle {
  /// Icon to insert into text
  final IconData icon;

  /// Icon color
  final Color? color;

  /// Icon size
  final double? size;

  /// Icon background color
  final Color? backgroundColor;

  IconStyle(
    this.icon, {
    this.color,
    this.size,
    this.backgroundColor,
  });
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
  ///
  /// Tag attributes must be enclosed in double quotes.
  /// You need to escape specific XML characters in text:
  ///
  /// ```
  /// Original character  Escaped character
  /// ------------------  -----------------
  /// "                   &quot;
  /// '                   &apos;
  /// &                   &amp;
  /// <                   &lt;
  /// >                   &gt;
  /// <space>             &space;
  /// ```
  ///
  final String text;

  /// Treat newlines as line breaks.
  final bool newLineAsBreaks;

  /// Is text selectable?
  final bool selectable;

  /// Default text style.
  final TextStyle? style;

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
  final TextDirection? textDirection;

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
  final int? maxLines;

  /// Used to select a font when the same Unicode character can
  /// be rendered differently, depending on the locale.
  ///
  /// It's rarely necessary to set this property. By default its value
  /// is inherited from the enclosing app with `Localizations.localeOf(context)`.
  ///
  /// See [RenderParagraph.locale] for more information.
  final Locale? locale;

  /// {@macro flutter.painting.textPainter.strutStyle}
  final StrutStyle? strutStyle;

  /// Create a text widget with formatting via tags.
  ///
  StyledText({
    Key? key,
    required this.text,
    this.newLineAsBreaks = false,
    this.style,
    required this.styles,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.locale,
    this.strutStyle,
  })  : this.selectable = false,
        this._focusNode = null,
        this._showCursor = false,
        this._autofocus = false,
        this._toolbarOptions = null,
        this._cursorWidth = null,
        this._cursorHeight = null,
        this._cursorRadius = null,
        this._cursorColor = null,
        this._dragStartBehavior = DragStartBehavior.start,
        this._enableInteractiveSelection = false,
        this._onTap = null,
        this._scrollPhysics = null,
        this._textHeightBehavior = null,
        this._textWidthBasis = null,
        super(key: key);

  /// Create a selectable text widget with formatting via tags.
  ///
  /// See [SelectableText.rich] for more options.
  StyledText.selectable(
      {Key? key,
      required this.text,
      this.newLineAsBreaks = false,
      this.style,
      required this.styles,
      this.textAlign = TextAlign.start,
      this.textDirection,
      this.textScaleFactor = 1.0,
      this.maxLines,
      this.strutStyle,
      FocusNode? focusNode,
      bool showCursor = false,
      bool autofocus = false,
      ToolbarOptions? toolbarOptions,
      double cursorWidth = 2.0,
      double? cursorHeight,
      Radius? cursorRadius,
      Color? cursorColor,
      DragStartBehavior dragStartBehavior = DragStartBehavior.start,
      bool enableInteractiveSelection = true,
      GestureTapCallback? onTap,
      ScrollPhysics? scrollPhysics,
      TextHeightBehavior? textHeightBehavior,
      TextWidthBasis? textWidthBasis})
      : this.selectable = true,
        this.softWrap = true,
        this.overflow = TextOverflow.clip,
        this.locale = null,
        this._focusNode = focusNode,
        this._showCursor = showCursor,
        this._autofocus = autofocus,
        this._toolbarOptions = toolbarOptions ??
            const ToolbarOptions(
              selectAll: true,
              copy: true,
            ),
        this._cursorWidth = cursorWidth,
        this._cursorHeight = cursorHeight,
        this._cursorRadius = cursorRadius,
        this._cursorColor = cursorColor,
        this._dragStartBehavior = dragStartBehavior,
        this._enableInteractiveSelection = enableInteractiveSelection,
        this._onTap = onTap,
        this._scrollPhysics = scrollPhysics,
        this._textHeightBehavior = textHeightBehavior,
        this._textWidthBasis = textWidthBasis,
        super(key: key);

  final FocusNode? _focusNode;
  final bool _showCursor;
  final bool _autofocus;
  final ToolbarOptions? _toolbarOptions;
  final double? _cursorWidth;
  final double? _cursorHeight;
  final Radius? _cursorRadius;
  final Color? _cursorColor;
  final DragStartBehavior _dragStartBehavior;
  final bool _enableInteractiveSelection;
  final GestureTapCallback? _onTap;
  final ScrollPhysics? _scrollPhysics;
  final TextHeightBehavior? _textHeightBehavior;
  final TextWidthBasis? _textWidthBasis;

  @override
  _StyledTextState createState() => _StyledTextState();
}

class _StyledTextState extends State<StyledText> {
  String? _text;
  TextSpan? _textSpans;

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
        (widget.newLineAsBreaks != oldWidget.newLineAsBreaks)) {
      _updateTextSpans(force: true);
    }
  }

  // Parse text
  void _updateTextSpans({bool force = false}) {
    if (_text != widget.text || force) {
      _text = widget.text;

      String? textValue = _text;
      if (textValue == null) return;

      if (widget.newLineAsBreaks) {
        textValue = textValue.replaceAll("\n", '<br/>');
      }

      TextStyle defaultStyle = (widget.style != null)
          ? DefaultTextStyle.of(context).style.merge(widget.style)
          : DefaultTextStyle.of(context).style;
      TextSpan node = TextSpan(style: defaultStyle, children: []);
      ListQueue<TextSpan> textQueue = ListQueue();
      Map<String?, String?>? attributes;

      var xmlStreamer =
          new XmlStreamer('<?xml version="1.0" encoding="UTF-8"?><root>' + textValue + '</root>', trimSpaces: false);
      xmlStreamer.read().listen((e) {
        switch (e.state) {
          case XmlState.Text:
          case XmlState.CDATA:
            if (node.children != null) {
              node.children!.add(TextSpan(
                  text: (e.value != null)
                      ? e.value!
                          .replaceAll('&space;', ' ')
                          .replaceAll('&nbsp;', ' ')
                          .replaceAll('&quot;', '"')
                          .replaceAll('&apos;', "'")
                          .replaceAll('&amp;', '&')
                          .replaceAll('&lt;', "<")
                          .replaceAll('&gt;', ">")
                      : e.value,
                  recognizer: node.recognizer));
            }
            break;

          case XmlState.Open:
            textQueue.addLast(node);

            if (e.value == 'br') {
              node = TextSpan(text: "\n");
            } else {
              TextStyle? style = (e.value != null) ? widget.styles[e.value!] : null;
              attributes = {};

              if (style is IconStyle) {
                node = TextSpan(
                  text: String.fromCharCode(style.icon.codePoint),
                  style: TextStyle(
                    fontFamily: style.icon.fontFamily,
                    package: style.icon.fontPackage,
                    color: style.color,
                    fontSize: style.size,
                    backgroundColor: style.backgroundColor,
                  ),
                );
              } else {
                final _StyledTextRecoginzer? recognizer = ((style is ActionTextStyle) && style.onTap != null)
                    ? _StyledTextRecoginzer(onTextTap: style.onTap)
                    : null;

                node = TextSpan(style: style, children: [], recognizer: recognizer);
              }
            }

            break;

          case XmlState.Closed:
            if (node.recognizer is _StyledTextRecoginzer) {
              (node.recognizer as _StyledTextRecoginzer)
                ..text = node
                ..attributes = attributes;
            }

            if (node.style is CustomTextStyle) {
              (node.style as CustomTextStyle).configure(attributes);
            }

            if (textQueue.isNotEmpty) {
              final TextSpan child = node;
              node = textQueue.removeLast();
              node.children?.add(child);
            }

            break;

          case XmlState.Attribute:
            if (e.key != null && attributes != null) {
              attributes![e.key] = e.value;
            }
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
    if (_textSpans == null) return const SizedBox();

    if (!widget.selectable) {
      return RichText(
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        softWrap: widget.softWrap,
        overflow: widget.overflow,
        textScaleFactor: widget.textScaleFactor,
        maxLines: widget.maxLines,
        locale: widget.locale,
        strutStyle: widget.strutStyle,
        text: _textSpans!,
      );
    } else {
      return SelectableText.rich(
        _textSpans!,
        focusNode: widget._focusNode,
        showCursor: widget._showCursor,
        autofocus: widget._autofocus,
        toolbarOptions: widget._toolbarOptions,
        cursorWidth: widget._cursorWidth!,
        cursorHeight: widget._cursorHeight,
        cursorRadius: widget._cursorRadius,
        cursorColor: widget._cursorColor,
        dragStartBehavior: widget._dragStartBehavior,
        enableInteractiveSelection: widget._enableInteractiveSelection,
        onTap: widget._onTap,
        scrollPhysics: widget._scrollPhysics,
        textHeightBehavior: widget._textHeightBehavior,
        textWidthBasis: widget._textWidthBasis,
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        // softWrap
        // overflow
        textScaleFactor: widget.textScaleFactor,
        maxLines: widget.maxLines,
        // locale
        strutStyle: widget.strutStyle,
      );
    }
  }
}

class _StyledTextRecoginzer extends TapGestureRecognizer {
  ActionTappedCallback? onTextTap;
  TextSpan? text;
  Map<String?, String?>? attributes;

  _StyledTextRecoginzer({
    this.text,
    this.attributes,
    this.onTextTap,
  }) : super() {
    this.onTap = _textTap;
  }

  void _textTap() {
    onTextTap?.call(text, attributes ?? const {});
  }
}
