import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:styled_text/tags/styled_text_tag_base.dart';
import 'dart:ui' as ui show ParagraphBuilder;

class StyledTextTagIcon extends StyledTextTagBase {
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

  /// The [TextBaseline] to align against when using [ui.PlaceholderAlignment.baseline],
  /// [ui.PlaceholderAlignment.aboveBaseline], and [ui.PlaceholderAlignment.belowBaseline].
  ///
  /// This is ignored when using other alignment modes.
  final TextBaseline? baseline;

  /// Called when the text is tapped or otherwise activated.
  final StyledTextTagActionCallback? onTap;

  StyledTextTagIcon(
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

    /*
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
      recognizer: recognizer,
    );
    */

    /*
    final TextSpan span = TextSpan(
      children: [
        WidgetSpan(
          child: iconWidget,
          style: TextStyle(backgroundColor: backgroundColor),
        ),
        if (children != null) ...children,
      ],
    );
    */

    // final InlineSpan span = WidgetSpan(
    //   child: iconWidget,
    //   alignment: alignment,
    //   baseline: baseline,
    //   style: TextStyle(backgroundColor: backgroundColor),
    // );

    final InlineSpan span = TextSpan(
      children: [
        WidgetSpan(
          child: iconWidget,
          alignment: alignment,
          baseline: baseline,
          style: TextStyle(backgroundColor: backgroundColor),
        ),
        /*
        IconSpan(
          icon: icon,
          size: size,
          color: color,
          style: TextStyle(backgroundColor: backgroundColor),
          alignment: alignment,
          baseline: baseline,
          onTap: (onTap != null) ? () => onTap!(text, attributes) : null,
        ),
        */
      ],
    );

    return span;
  }
}

/*
class IconSpan extends WidgetSpan {
  final IconData icon;
  final Color? color;
  final double? size;
  final VoidCallback? onTap;

  IconSpan({
    required this.icon,
    this.size,
    this.color,
    PlaceholderAlignment alignment = PlaceholderAlignment.middle,
    TextBaseline? baseline,
    TextStyle? style,
    this.onTap,
  }) : super(
          child: (onTap == null)
              ? Icon(
                  icon,
                  color: color,
                  size: size,
                )
              : GestureDetector(
                  child: Icon(
                    icon,
                    color: color,
                    size: size,
                  ),
                  onTap: onTap,
                ),
          alignment: alignment,
          baseline: baseline,
          style: style,
        );

  /*
  @override
  void build(
    ui.ParagraphBuilder builder, {
    double textScaleFactor = 1.0,
    List<PlaceholderDimensions>? dimensions,
  }) {
    super.build(
      builder,
      textScaleFactor: textScaleFactor,
      dimensions: dimensions,
    );
  }
  */
}
*/
