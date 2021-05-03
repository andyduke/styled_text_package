library styled_text;

import 'dart:collection';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:xmlstream/xmlstream.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/tags/styled_text_tag_base.dart';

export 'icon_style.dart';
export 'custom_text_style.dart';
export 'action_text_style.dart';

export 'tags/styled_text_tag_base.dart';
export 'tags/styled_text_tag.dart';
export 'tags/styled_text_tag_icon.dart';
export 'tags/styled_text_tag_action.dart';
export 'tags/styled_text_tag_widget.dart';
export 'tags/styled_text_tag_widget_builder.dart';
export 'tags/styled_text_tag_custom.dart';

///
/// Text widget with formatting via tags.
///
/// Formatting is specified as xml tags. For each tag, you can specify a style, icon, etc. in the [tags] parameter.
///
/// Example:
/// ```dart
/// StyledText(
///   text: '<red>Red</red> text.',
///   tags: [
///     'red': StyledTextTag(style: TextStyle(color: Colors.red)),
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
  @deprecated
  final Map<String, TextStyle> styles;

  /// Map of tag assignments to text style classes and tag handlers.
  ///
  /// Example:
  /// ```dart
  /// StyledText(
  ///   text: '<red>Red</red> text.',
  ///   tags: [
  ///     'red': StyledTextTag(style: TextStyle(color: Colors.red)),
  ///   ],
  /// )
  /// ```
  final Map<String, StyledTextTagBase> tags;

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
    @Deprecated('Use tags property instead of styles') Map<String, TextStyle>? styles,
    Map<String, StyledTextTagBase>? tags,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.locale,
    this.strutStyle,
  })  : assert(
          styles != null || tags != null,
          'Styles and tags cannot be used at the same time. Use styles for compatibility only. They will be removed in future versions.',
        ),
        this.styles = styles ?? const {},
        this.tags = tags ?? const {},
        this.selectable = false,
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
      @Deprecated('Use tags property instead of styles') Map<String, TextStyle>? styles,
      Map<String, StyledTextTagBase>? tags,
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
      : assert(
          styles != null || tags != null,
          'Styles and tags cannot be used at the same time. Use styles for compatibility only. They will be removed in future versions.',
        ),
        this.styles = styles ?? const {},
        this.tags = tags ?? const {},
        this.selectable = true,
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
  _Node? _rootNode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateTextSpans();
  }

  @override
  void didUpdateWidget(StyledText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if ((widget.text != oldWidget.text) ||
        (widget.tags != oldWidget.tags) ||
        (widget.styles != oldWidget.styles) ||
        (widget.style != oldWidget.style) ||
        (widget.newLineAsBreaks != oldWidget.newLineAsBreaks)) {
      _updateTextSpans(force: true);
    }
  }

  StyledTextTagBase? _tag(String? tagName) {
    if (tagName == null) return null;

    if (widget.tags.containsKey(tagName)) {
      return widget.tags[tagName];
    }

    if (widget.styles.containsKey(tagName)) {
      return StyledTextTag(style: widget.styles[tagName]);
    }

    return null;
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

      _rootNode?.dispose();

      TextStyle defaultStyle = (widget.style != null)
          ? DefaultTextStyle.of(context).style.merge(widget.style)
          : DefaultTextStyle.of(context).style;
      _Node node = _TextNode();
      ListQueue<_Node> textQueue = ListQueue();
      Map<String?, String?>? attributes;

      var xmlStreamer =
          new XmlStreamer('<?xml version="1.0" encoding="UTF-8"?><root>' + textValue + '</root>', trimSpaces: false);
      xmlStreamer.read().listen((e) {
        switch (e.state) {
          case XmlState.Text:
          case XmlState.CDATA:
            node.children.add(
              _TextNode(text: e.value),
            );
            break;

          case XmlState.Open:
            textQueue.addLast(node);

            if (e.value == 'br') {
              node = _TextNode(text: "\n");
            } else {
              StyledTextTagBase? tag = _tag(e.value);
              node = _TagNode(tag: tag);
              attributes = {};
            }

            break;

          case XmlState.Closed:
            node.configure(attributes);

            if (textQueue.isNotEmpty) {
              final _Node child = node;
              node = textQueue.removeLast();
              node.children.add(child);
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
        _rootNode = node;
        final span = node.createSpan(context: context);
        _textSpans = TextSpan(style: defaultStyle, children: [span]);

        if (mounted) {
          setState(() {});
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

abstract class _Node {
  String? text;
  final List<_Node> children = [];

  InlineSpan createSpan({
    required BuildContext context,
    GestureRecognizer? recognizer,
  });

  void configure(Map<String?, String?>? attributes) {}

  List<InlineSpan> createChildren({
    required BuildContext context,
    GestureRecognizer? recognizer,
  }) {
    return children.map((c) => c.createSpan(context: context, recognizer: recognizer)).toList();
  }

  void dispose() {
    for (var node in children) {
      node.dispose();
    }
  }
}

class _TagNode extends _Node {
  StyledTextTagBase? tag;
  Map<String?, String?> attributes = {};
  GestureRecognizer? _recognizer;

  _TagNode({
    this.tag,
  });

  @override
  void dispose() {
    _recognizer?.dispose();
    super.dispose();
  }

  @override
  void configure(Map<String?, String?>? attributes) {
    if (attributes != null && attributes.isNotEmpty) {
      this.attributes.addAll(attributes);
    }
  }

  @override
  InlineSpan createSpan({
    required BuildContext context,
    GestureRecognizer? recognizer,
  }) {
    _recognizer = tag?.createRecognizer(text, attributes) ?? recognizer;
    InlineSpan? result = (tag != null)
        ? tag!.createSpan(
            context: context,
            text: text,
            children: createChildren(context: context, recognizer: _recognizer),
            attributes: attributes,
            recognizer: _recognizer,
          )
        : null;
    if (result == null) {
      result = TextSpan(
        text: text,
        children: createChildren(context: context, recognizer: _recognizer),
      );
    }
    return result;
  }
}

class _TextNode extends _Node {
  final String? _text;

  _TextNode({
    String? text,
  }) : _text = text;

  @override
  String? get text => _text
      ?.replaceAll('&space;', ' ')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&quot;', '"')
      .replaceAll('&apos;', "'")
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', "<")
      .replaceAll('&gt;', ">");

  @override
  InlineSpan createSpan({
    required BuildContext context,
    GestureRecognizer? recognizer,
  }) {
    return TextSpan(
      text: text,
      children: createChildren(context: context, recognizer: recognizer),
      recognizer: recognizer,
    );
  }
}
