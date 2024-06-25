import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:styled_text/src/tags/styled_text_tag_base.dart';
import 'package:styled_text/src/tags/styled_text_tag.dart';

/// A class that you can use to specify a callback
/// that will be called when the tag is tapped.
///
class StyledTextActionTag extends StyledTextTag {
  /// A callback to be called when the tag is tapped.
  final StyledTextTagActionCallback onTap;

  const StyledTextActionTag(
    this.onTap, {
    TextStyle? style,
  }) : super(style: style);

  @override
  GestureRecognizer? createRecognizer(
      String? text, Map<String?, String?> attributes) {
    return TapGestureRecognizer()..onTap = () => onTap(text, attributes);
  }
}
