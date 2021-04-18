import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:styled_text/tags/styled_text_tag_base.dart';

class StyledTextTagIcon extends StyledTextTagBase {
  /// Icon to insert into text
  final IconData icon;

  /// Icon color
  final Color? color;

  /// Icon size
  final double? size;

  /// Icon background color
  final Color? backgroundColor;

  final StyledTextTagActionCallback? onTap;

  StyledTextTagIcon(
    this.icon, {
    this.color,
    this.size,
    this.backgroundColor,
    this.onTap,
  });

  // TODO: override createRecognizer

  @override
  InlineSpan createSpan({
    String? text,
    List<InlineSpan>? children,
    required Map<String?, String?> attributes,
    GestureRecognizer? recognizer,
  }) {
    final TextSpan span = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
        color: color,
        fontSize: size,
        backgroundColor: backgroundColor,
      ),
      children: children,
      // TODO: Recognizer
      // recognizer: (onTap != null) ? StyledTextRecoginzer(onTextTap: onTap) : null,
      recognizer: recognizer,
    );
    return span;
  }
}
