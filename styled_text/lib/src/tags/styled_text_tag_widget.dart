import 'package:flutter/widgets.dart';
import 'package:styled_text/src/tags/styled_text_tag_widget_builder.dart';

/// The class with which you can specify the widget to insert in place of the tag.
///
/// In the example below, an input field is inserted in place of the tag:
/// ```dart
/// StyledText(
///   text: 'Text with <input/> inside.',
///   tags: {
///     'input': StyledTextWidgetTag(
///       TextField(
///         decoration: InputDecoration(
///           hintText: 'Input',
///         ),
///       ),
///       size: Size.fromWidth(200),
///       constraints: BoxConstraints.tight(Size(100, 50)),
///     ),
///   },
/// )
/// ```
class StyledTextWidgetTag extends StyledTextWidgetBuilderTag {
  StyledTextWidgetTag(
    Widget child, {
    Size? size,
    String? textContent,
    BoxConstraints? constraints,
    PlaceholderAlignment alignment = PlaceholderAlignment.middle,
    TextBaseline baseline = TextBaseline.alphabetic,
  }) : super(
          (context, attributes, textContent) => child,
          size: size,
          constraints: constraints,
          alignment: alignment,
          baseline: baseline,
        );
}
