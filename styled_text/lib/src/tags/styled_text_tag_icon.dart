import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:styled_text/src/tags/styled_text_tag_base.dart';

/// The class with which you can specify the icon for the tag.
///
class StyledTextIconTag extends StyledTextTagBase {
  /// Icon to insert into text
  final IconData icon;

  /// Icon color
  final Color? color;

  /// Icon size
  final double? size;

  /// Icon background color
  final Color? backgroundColor;

  /// Aligning the icon relative to the text
  final PlaceholderAlignment alignment;

  /// The [TextBaseline] to align against when using [PlaceholderAlignment.baseline],
  /// [PlaceholderAlignment.aboveBaseline], and [PlaceholderAlignment.belowBaseline].
  ///
  /// This is ignored when using other alignment modes.
  final TextBaseline? baseline;

  /// Called when the text is tapped or otherwise activated.
  final StyledTextTagActionCallback? onTap;

  const StyledTextIconTag(
    this.icon, {
    this.color,
    this.size,
    this.backgroundColor,
    this.alignment = PlaceholderAlignment.middle,
    this.baseline = TextBaseline.alphabetic,
    this.onTap,
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
    Widget iconWidget = Icon(
      icon,
      color: color,
      size: size,
    );
    if (onTap != null) {
      iconWidget = GestureDetector(
        child: iconWidget,
        onTap: () => onTap!(text, attributes),
      );
    }

    final InlineSpan span = TextSpan(
      children: [
        WidgetSpan(
          child: iconWidget,
          alignment: alignment,
          baseline: baseline,
          style: TextStyle(backgroundColor: backgroundColor),
        ),
      ],
    );

    return span;
  }
}
