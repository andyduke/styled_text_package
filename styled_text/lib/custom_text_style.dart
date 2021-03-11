import 'package:flutter/material.dart';
import 'package:styled_text/custom_style.dart';

typedef CustomTextStyleCallback = TextStyle? Function(
    TextStyle? baseStyle, Map<String?, String?> attributes);

///
/// A custom text style, for which you can specify the processing of attributes of the tag.
///
/// Example:
/// ```dart
/// StyledText(
///   text: 'Text with custom <color text="#ff5500">color</color> text.',
///   styles: {
///     'color': CustomTextStyle(
///       baseStyle: TextStyle(fontStyle: FontStyle.italic),
///       parse: (baseStyle, attributes) {
///         if (attributes.containsKey('text') &&
///             (attributes['text'].substring(0, 1) == '#') &&
///             attributes['text'].length >= 6) {
///           final String hexColor = attributes['text'].substring(1);
///           final String alphaChannel = (hexColor.length == 8) ? hexColor.substring(6, 8) : 'FF';
///           final Color color = Color(int.parse('0x$alphaChannel' + hexColor.substring(0, 6)));
///           return baseStyle.copyWith(color: color);
///         } else {
///           return baseStyle;
///         }
///       }),
///   },
/// )
/// ```
///
class CustomTextStyle extends CustomStyle {
  /// Called when parsing the attributes of a tag.
  final CustomTextStyleCallback parse;

  final Map<String?, String?> _attributes = {};
  final _Holder<TextStyle> _style = _Holder<TextStyle>();

  CustomTextStyle({
    required this.parse,
    TextStyle? baseStyle,
  }) : super(baseStyle: baseStyle);

  void configure(Map<String?, String?>? attributes) {
    if (attributes != null && attributes.isNotEmpty) {
      this._attributes.addAll(attributes);
    }
  }

  TextStyle get style {
    if (_style.object == null) {
      final TextStyle? _baseStyle = super.baseStyle;
      _style.object = this.parse(_baseStyle, _attributes) ?? _baseStyle;
    }
    return _style.object ?? const TextStyle();
  }
}

class _Holder<T> {
  T? object;

  _Holder({this.object});
}
