import 'package:flutter/material.dart';
import 'package:styled_text/src/parsers/mini_dom.dart';
import 'package:styled_text/src/parsers/text_parser.dart';
import 'package:styled_text/src/parsers/text_parser_sync.dart';
import 'package:styled_text/src/tags/styled_text_tag_base.dart';
import 'package:styled_text/src/widgets/styled_text.dart';

/// The builder callback for the [CustomStyledText] widget.
typedef StyledTextWidgetBuilderCallback = Widget Function(BuildContext context, TextSpan textSpan);

/// The text parser builder callback signature for the [CustomStyledText] widget.
typedef StyledTextWidgetParserBuilderCallback = StyledTextParser Function(
  StyledTextParserTagCallback onTag,
  StyledTextParserCallback onParsed,
);

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

  /// Text parser builder, makes it possible to use any text
  /// parser that implements the [StyledTextParser] interface.
  final StyledTextWidgetParserBuilderCallback? textParserBuilder;

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
    this.textParserBuilder,
  });

  @override
  _CustomStyledTextState createState() => _CustomStyledTextState();
}

class _CustomStyledTextState extends State<CustomStyledText> {
  String? _text;
  TextSpan? _textSpans;
  StyledNode? _rootNode;

  late StyledTextParser _parser = (widget.textParserBuilder ?? _defaultParserBuilder)(_tag, _parsed);

  StyledTextParser _defaultParserBuilder(StyledTextParserTagCallback onTag, StyledTextParserCallback onParsed) {
    return StyledTextParserSync(
      onTag: onTag,
      onParsed: onParsed,
    );
  }

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

      String? textValue = _text;
      if (textValue == null) return;

      if (widget.newLineAsBreaks) {
        textValue = textValue.replaceAll("\n", '<br/>');
      }

      _rootNode?.dispose();
      _rootNode = null;

      _parser.parse(textValue);
    } else {
      if (_rootNode != null && _textSpans == null) {
        _buildTextSpans(_rootNode);
      }
    }
  }

  void _parsed(StyledNode? node, bool async) {
    _rootNode = node;
    _buildTextSpans(_rootNode);
  }

  void _buildTextSpans(StyledNode? node) {
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
    if (widget.style == null || widget.style!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(widget.style);
    }
    if (MediaQuery.boldTextOf(context)) {
      effectiveTextStyle = effectiveTextStyle!.merge(const TextStyle(fontWeight: FontWeight.bold));
    }

    final span = TextSpan(
      style: effectiveTextStyle,
      children: [_textSpans!],
    );

    return widget.builder.call(context, span);
  }
}
