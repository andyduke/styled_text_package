import 'package:flutter/material.dart';

typedef ActionTappedCallback = void Function(
    TextSpan? text, Map<String?, String?> attributes);

///
/// A text style to make the text tappable.
///
/// Example:
/// ```dart
/// StyledText(
///   text: 'Text with <link href="https://flutter.dev">link</link> inside.',
///   styles: {
///     'link': ActionTextStyle(
///       decoration: TextDecoration.underline,
///       onTap: (TextSpan text, Map<String, String> attrs) {
///         final String link = attrs['href'];
///         print('The "$link" link is tapped.');
///       },
///     ),
///   },
/// )
/// ```
///
@deprecated
class ActionTextStyle extends TextStyle {
  /// Called when the text is tapped or otherwise activated.
  final ActionTappedCallback? onTap;

  ActionTextStyle({
    bool inherit = true,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? height,
    Locale? locale,
    Paint? foreground,
    Paint? background,
    List<Shadow>? shadows,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    String? debugLabel,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    String? package,
    this.onTap,
  }) : super(
          inherit: inherit,
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          letterSpacing: letterSpacing,
          wordSpacing: wordSpacing,
          textBaseline: textBaseline,
          height: height,
          locale: locale,
          foreground: foreground,
          background: background,
          shadows: shadows,
          decoration: decoration,
          decorationColor: decorationColor,
          decorationStyle: decorationStyle,
          debugLabel: debugLabel,
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          package: package,
        );
}
