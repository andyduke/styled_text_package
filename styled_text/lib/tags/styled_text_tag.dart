import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:styled_text/tags/styled_text_tag_base.dart';

class StyledTextTag extends StyledTextTagBase {
  final TextStyle? style;

  StyledTextTag({
    this.style,
  });

  @override
  InlineSpan createSpan({
    required BuildContext context,
    String? text,
    List<InlineSpan>? children,
    required Map<String?, String?> attributes,
    GestureRecognizer? recognizer,
  }) {
    final TextSpan span = TextSpan(
      text: text,
      style: style,
      children: children,
      recognizer: recognizer,
    );
    return span;
  }
}
