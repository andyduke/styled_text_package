import 'package:flutter/widgets.dart';

///
/// The style to insert the icon into styled text.
///
/// Example:
/// ```dart
/// StyledText(
///   text: 'Text with alarm <alarm/> icon.',
///   styles: {
///     'alarm': IconStyle(Icons.alarm),
///   },
/// )
/// ```
///
@deprecated
class IconStyle extends TextStyle {
  /// Icon to insert into text
  final IconData icon;

  /// Icon color
  final Color? color;

  /// Icon size
  final double? size;

  /// Icon background color
  final Color? backgroundColor;

  IconStyle(
    this.icon, {
    this.color,
    this.size,
    this.backgroundColor,
  });
}
