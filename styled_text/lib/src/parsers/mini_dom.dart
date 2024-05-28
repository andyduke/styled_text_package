import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:styled_text/src/tags/styled_text_tag_base.dart';

/// Abstract base class for representing tags and text in a hierarchy of parsed text.
abstract class StyledNode {
  /// Node text content.
  String? get text => null;

  /// Child nodes of this node.
  final List<StyledNode> children = [];

  /// Text content of a node, including text content of child nodes.
  String get textContent => children.fold(text ?? '', (prevText, tag) => prevText + tag.textContent);

  /// Creates a Span based on node information for a RichText widget.
  InlineSpan createSpan({
    required BuildContext context,
    GestureRecognizer? recognizer,
  });

  /// Sets node attributes.
  void configure(Map<String?, String?>? attributes) {}

  /// Creates a list of Spans from child nodes for a RichText widget.
  List<InlineSpan> createChildren({
    required BuildContext context,
    GestureRecognizer? recognizer,
  }) {
    return children.map((c) => c.createSpan(context: context, recognizer: recognizer)).toList();
  }

  /// Discards any resources used by the object.
  /// After this is called, the object is not in a usable state and should be discarded.
  void dispose() {
    for (var node in children) {
      node.dispose();
    }
  }
}

/// A node class to represent tags in a hierarchy of parsed text.
class StyledTagNode extends StyledNode {
  /// A StyledText tag representing this node.
  final StyledTextTagBase? tag;

  /// Node attributes.
  final Map<String?, String?> attributes = {};

  /// Node gesture recognizer.
  GestureRecognizer? _recognizer;

  String? _textContent;

  /// Creates a node class to represent tags in the hierarchy of parsed text.
  StyledTagNode({
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
    _recognizer = tag?.createRecognizer(_textContent ??= textContent, attributes) ?? recognizer;
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

/// A node class for representing text in the parsed text hierarchy.
class StyledTextNode extends StyledNode {
  final String? _rawText;

  /// Creates a node class to represent text in the parsed text hierarchy.
  StyledTextNode({
    String? text,
  }) : _rawText = text;

  @override
  String? get text => _rawText
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
