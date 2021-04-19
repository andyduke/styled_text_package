import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:styled_text/tags/styled_text_tag_base.dart';

class StyledTextTagWidgetBuilder extends StyledTextTagBase {
  /// Widget to insert into text
  final WidgetBuilder builder;

  final Size? size;

  final BoxConstraints? constraints;

  /// Aligning the icon relative to the text
  final PlaceholderAlignment alignment;

  /// The [TextBaseline] to align against when using [ui.PlaceholderAlignment.baseline],
  /// [ui.PlaceholderAlignment.aboveBaseline], and [ui.PlaceholderAlignment.belowBaseline].
  ///
  /// This is ignored when using other alignment modes.
  final TextBaseline? baseline;

  StyledTextTagWidgetBuilder(
    this.builder, {
    this.size,
    this.constraints,
    this.alignment = PlaceholderAlignment.middle,
    this.baseline = TextBaseline.alphabetic,
  });

  @override
  InlineSpan createSpan({
    required BuildContext context,
    String? text,
    List<InlineSpan>? children,
    required Map<String?, String?> attributes,
    GestureRecognizer? recognizer,
  }) {
    Widget widget = builder(context);

    if (size != null) {
      widget = SizedBox(
        width: (size!.width == double.infinity) ? null : size!.width,
        height: (size!.height == double.infinity) ? null : size!.height,
        child: widget,
      );
    }

    if (constraints != null) {
      widget = ConstrainedBox(
        constraints: constraints!,
        child: widget,
      );
    }

    final InlineSpan span = TextSpan(
      children: [
        WidgetSpan(
          child: widget,
          alignment: alignment,
          baseline: baseline,
          // style: TextStyle(backgroundColor: backgroundColor),
        ),
      ],
    );

    return span;
  }
}
