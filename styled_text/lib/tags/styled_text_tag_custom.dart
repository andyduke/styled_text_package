import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:styled_text/tags/styled_text_tag_base.dart';

/// The signature of the tag attribute parser.
typedef StyledTextCustomTagParser = TextStyle? Function(TextStyle? baseStyle, Map<String?, String?> attributes);

/// A custom text style, for which you can specify the processing of attributes of the tag.
///
class StyledTextCustomTag extends StyledTextTagBase {
  /// The default base style is passed to [parse].
  final TextStyle? baseStyle;

  /// Called when parsing the attributes of a tag.
  final StyledTextCustomTagParser parse;

  StyledTextCustomTag({
    required this.parse,
    this.baseStyle,
  });

  @override
  InlineSpan createSpan({
    required BuildContext context,
    String? text,
    String? textContent,
    List<InlineSpan>? children,
    required Map<String?, String?> attributes,
    GestureRecognizer? recognizer,
  }) {
    final TextStyle? style = parse(baseStyle, attributes) ?? baseStyle;
    final TextSpan span = TextSpan(
      text: text,
      style: style,
      children: children,
      recognizer: recognizer,
    );
    return span;
  }
}
