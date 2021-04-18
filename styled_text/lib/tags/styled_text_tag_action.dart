import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:styled_text/tags/styled_text_tag_base.dart';
import 'package:styled_text/tags/styled_text_tag.dart';

class StyledTextTagAction extends StyledTextTag {
  final StyledTextTagActionCallback onTap;

  StyledTextTagAction(
    this.onTap, {
    TextStyle? style,
  }) : super(style: style);

  GestureRecognizer? createRecognizer(String? text, Map<String?, String?> attributes) {
    return TapGestureRecognizer()..onTap = () => onTap(text, attributes);
  }

  /*
  @override
  InlineSpan createSpan({
    String? text,
    List<InlineSpan>? children,
    required Map<String?, String?> attributes,
  }) {
    final TextSpan span = TextSpan(
      // text: text,
      text: '!!!',
      style: style,
      children: children,
      recognizer: StyledTextRecoginzer(text: text, attributes: attributes, onTextTap: onTap),
      // recognizer: TapGestureRecognizer()..onTap = () => debugPrint('TAP!'),
    );
    return span;
  }
  */
}
