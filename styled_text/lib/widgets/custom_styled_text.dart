import 'dart:collection';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:styled_text/tags/styled_text_tag_base.dart';
import 'package:styled_text/widgets/styled_text.dart';
import 'package:xmlstream/xmlstream.dart';

/// The builder callback for the [CustomStyledText] widget.
typedef StyledTextWidgetBuilderCallback = Widget Function(
    BuildContext context, TextSpan textSpan);

///
/// Custom widget with formatting via tags.
///
/// Formatting is specified as xml tags. For each tag, you can specify a style, icon, etc. in the [tags] parameter.
///
/// Consider using the simpler [StyledText] instead.
///
/// Example:
/// ```dart
/// CustomStyledText(
///   text: '&lt;red&gt;Red&lt;/red&gt; text.',
///   tags: [
///     'red': StyledTextTag(style: TextStyle(color: Colors.red)),
///   ],
///   builder: (context, textSpan) => Text.rich(textSpan),
/// )
/// ```
/// See also:
///
/// * [TextStyle], which discusses how to style text.
///
class CustomStyledText extends StatefulWidget {
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

  /// Default text style.
  final TextStyle? style;

  /// Map of tag assignments to text style classes and tag handlers.
  ///
  /// Example:
  /// ```dart
  /// CustomStyledText(
  ///   text: '&lt;red&gt;Red&lt;/red&gt; text.',
  ///   tags: [
  ///     'red': StyledTextTag(style: TextStyle(color: Colors.red)),
  ///   ],
  ///   ...
  /// )
  /// ```
  final Map<String, StyledTextTagBase> tags;

  /// The builder with the generated [TextSpan] as input.
  final StyledTextWidgetBuilderCallback builder;

  /// Create a [CustomStyledText] with your own builder function.
  ///
  /// This way you can manage the resulting [TextSpan] by yourself.
  CustomStyledText({
    super.key,
    this.newLineAsBreaks = true,
    required this.text,
    this.tags = const {},
    this.style,
    required this.builder,
  });

  @override
  _CustomStyledTextState createState() => _CustomStyledTextState();
}

class _CustomStyledTextState extends State<CustomStyledText> {
  String? _text;
  TextSpan? _textSpans;
  _Node? _rootNode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateTextSpans();
  }

  @override
  void didUpdateWidget(CustomStyledText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if ((widget.text != oldWidget.text) ||
        (widget.tags != oldWidget.tags) ||
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

    return null;
  }

  // Parse text
  void _updateTextSpans({bool force = false}) {
    if ((_text != widget.text) || (_textSpans == null) || force) {
      _text = widget.text;
      // _textSpans = null;

      String? textValue = _text;
      if (textValue == null) return;

      if (widget.newLineAsBreaks) {
        textValue = textValue.replaceAll("\n", '<br/>');
      }

      _rootNode?.dispose();

      _Node node = _TextNode();
      ListQueue<_Node> textQueue = ListQueue();
      Map<String?, String?>? attributes;

      final xmlStreamer = XmlStreamer(
        '<?xml version="1.0" encoding="UTF-8"?><root>' + textValue + '</root>',
        trimSpaces: false,
      );
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
        _buildTextSpans(_rootNode);
      });
    } else {
      if (_rootNode != null && _textSpans == null) {
        _buildTextSpans(_rootNode);
      }
    }
  }

  void _buildTextSpans(_Node? node) {
    if (node != null) {
      if (mounted) {
        final span = node.createSpan(context: context);
        _textSpans = TextSpan(children: [span]);
        setState(() {});
      } else {
        _textSpans = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_textSpans == null) return const SizedBox();

    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle? effectiveTextStyle = widget.style;
    if (widget.style == null || widget.style!.inherit)
      effectiveTextStyle = defaultTextStyle.style.merge(widget.style);
    if (MediaQuery.boldTextOf(context))
      effectiveTextStyle = effectiveTextStyle!
          .merge(const TextStyle(fontWeight: FontWeight.bold));

    final span = TextSpan(
      style: effectiveTextStyle,
      children: [_textSpans!],
    );

    return widget.builder.call(context, span);
  }
}

abstract class _Node {
  String? text;
  final List<_Node> children = [];

  String get textContent =>
      children.fold(text ?? '', (prevText, tag) => prevText + tag.textContent);

  InlineSpan createSpan({
    required BuildContext context,
    GestureRecognizer? recognizer,
  });

  void configure(Map<String?, String?>? attributes) {}

  List<InlineSpan> createChildren({
    required BuildContext context,
    GestureRecognizer? recognizer,
  }) {
    return children
        .map((c) => c.createSpan(context: context, recognizer: recognizer))
        .toList();
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
  String? _textContent;

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
    _recognizer =
        tag?.createRecognizer(_textContent ??= textContent, attributes) ??
            recognizer;
    InlineSpan? result = (tag != null)
        ? tag!.createSpan(
            context: context,
            text: text,
            textContent: textContent,
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
