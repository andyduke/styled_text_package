import 'dart:ui' as ui
    show TextStyle, ParagraphStyle, FontFeature, TextLeadingDistribution;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// @nodoc
@deprecated
class CustomStyle with Diagnosticable implements TextStyle {
  /// Basic text style.
  final TextStyle? baseStyle;

  CustomStyle({this.baseStyle});

  TextStyle get style => baseStyle ?? const TextStyle();

  @override
  TextStyle apply({
    Color? color,
    Color? backgroundColor,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double decorationThicknessFactor = 1.0,
    double decorationThicknessDelta = 0.0,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    double fontSizeFactor = 1.0,
    double fontSizeDelta = 0.0,
    int fontWeightDelta = 0,
    FontStyle? fontStyle,
    double letterSpacingFactor = 1.0,
    double letterSpacingDelta = 0.0,
    double wordSpacingFactor = 1.0,
    double wordSpacingDelta = 0.0,
    double heightFactor = 1.0,
    double heightDelta = 0.0,
    TextBaseline? textBaseline,
    ui.TextLeadingDistribution? leadingDistribution,
    Locale? locale,
    List<Shadow>? shadows,
    List<ui.FontFeature>? fontFeatures,
    TextOverflow? overflow,
  }) {
    return style.apply(
      color: color,
      backgroundColor: backgroundColor,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThicknessFactor: decorationThicknessFactor,
      decorationThicknessDelta: decorationThicknessDelta,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSizeFactor: fontSizeFactor,
      fontSizeDelta: fontSizeDelta,
      fontWeightDelta: fontWeightDelta,
      fontStyle: fontStyle,
      letterSpacingFactor: letterSpacingFactor,
      letterSpacingDelta: letterSpacingDelta,
      wordSpacingFactor: wordSpacingFactor,
      wordSpacingDelta: wordSpacingDelta,
      heightFactor: heightFactor,
      heightDelta: heightDelta,
      textBaseline: textBaseline,
      leadingDistribution: leadingDistribution,
      locale: locale,
      shadows: shadows,
      fontFeatures: fontFeatures,
      overflow: overflow,
    );
  }

  @override
  Paint? get background => style.background;

  @override
  Color? get backgroundColor => style.backgroundColor;

  @override
  Color? get color => style.color;

  @override
  RenderComparison compareTo(TextStyle other) {
    return style.compareTo(other);
  }

  @override
  TextStyle copyWith({
    bool? inherit,
    Color? color,
    Color? backgroundColor,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? height,
    ui.TextLeadingDistribution? leadingDistribution,
    Locale? locale,
    Paint? foreground,
    Paint? background,
    List<Shadow>? shadows,
    List<ui.FontFeature>? fontFeatures,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    String? debugLabel,
    TextOverflow? overflow,
  }) {
    return style.copyWith(
      inherit: inherit,
      color: color,
      backgroundColor: backgroundColor,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      leadingDistribution: leadingDistribution,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      debugLabel: debugLabel,
      overflow: overflow,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties,
      {String prefix = ''}) {
    super.debugFillProperties(properties);
    style.debugFillProperties(properties, prefix: prefix);
  }

  @override
  String? get debugLabel => style.debugLabel;

  @override
  TextDecoration? get decoration => style.decoration;

  @override
  Color? get decorationColor => style.decorationColor;

  @override
  TextDecorationStyle? get decorationStyle => style.decorationStyle;

  @override
  double? get decorationThickness => style.decorationThickness;

  @override
  String? get fontFamily => style.fontFamily;

  @override
  List<String>? get fontFamilyFallback => style.fontFamilyFallback;

  @override
  List<ui.FontFeature>? get fontFeatures => style.fontFeatures;

  @override
  double? get fontSize => style.fontSize;

  @override
  FontStyle? get fontStyle => style.fontStyle;

  @override
  FontWeight? get fontWeight => style.fontWeight;

  @override
  Paint? get foreground => style.foreground;

  @override
  ui.ParagraphStyle getParagraphStyle(
      {TextAlign? textAlign,
      TextDirection? textDirection,
      double textScaleFactor = 1.0,
      String? ellipsis,
      int? maxLines,
      TextHeightBehavior? textHeightBehavior,
      Locale? locale,
      String? fontFamily,
      double? fontSize,
      FontWeight? fontWeight,
      FontStyle? fontStyle,
      double? height,
      StrutStyle? strutStyle}) {
    return style.getParagraphStyle(
      textAlign: textAlign,
      textDirection: textDirection,
      textScaleFactor: textScaleFactor,
      ellipsis: ellipsis,
      maxLines: maxLines,
      textHeightBehavior: textHeightBehavior,
      locale: locale,
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      height: height,
      strutStyle: strutStyle,
    );
  }

  @override
  ui.TextStyle getTextStyle({double textScaleFactor = 1.0}) =>
      style.getTextStyle(textScaleFactor: textScaleFactor);

  @override
  double? get height => style.height;

  @override
  ui.TextLeadingDistribution? get leadingDistribution =>
      style.leadingDistribution;

  @override
  bool get inherit => style.inherit;

  @override
  double? get letterSpacing => style.letterSpacing;

  @override
  Locale? get locale => style.locale;

  @override
  TextStyle merge(TextStyle? other) => style.merge(other);

  @override
  List<Shadow>? get shadows => style.shadows;

  @override
  TextBaseline? get textBaseline => style.textBaseline;

  @override
  String toStringShort() => style.toStringShort();

  @override
  double? get wordSpacing => style.wordSpacing;

  @override
  TextOverflow? get overflow => style.overflow;
}
