import 'dart:ui' as ui show TextHeightBehavior, BoxHeightStyle, BoxWidthStyle;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:styled_text/src/parsers/text_parser_async.dart';
import 'package:styled_text/src/parsers/text_parser_sync.dart';
import 'package:styled_text/src/tags/styled_text_tag_base.dart';
import 'package:styled_text/src/widgets/custom_styled_text.dart';

///
/// Text widget with formatting via tags.
///
/// Formatting is specified as xml tags. For each tag, you can specify a style, icon, etc. in the [tags] parameter.
///
/// Consider using the [CustomStyledText] instead if you need more customisation.
///
/// Example:
/// ```dart
/// StyledText(
///   text: '&lt;red&gt;Red&lt;/red&gt; text.',
///   tags: [
///     'red': StyledTextTag(style: TextStyle(color: Colors.red)),
///   ],
/// )
/// ```
/// See also:
///
/// * [TextStyle], which discusses how to style text.
///
class StyledText extends StatelessWidget {
  /// The text to display in this widget. The text must be valid xml.
  ///
  /// Tag attributes must be enclosed in double quotes.
  /// You need to escape specific XML characters in text:
  ///
  /// ```
  /// Original character  Escaped character
  /// ------------------  -----------------
  /// "                   &quot;
  /// '                   &apos;
  /// &                   &amp;
  /// <                   &lt;
  /// >                   &gt;
  /// <space>             &space;
  /// ```
  ///
  final String text;

  /// Treat newlines as line breaks.
  final bool newLineAsBreaks;

  /// Is text selectable?
  final bool selectable;

  /// Default text style.
  final TextStyle? style;

  /// Map of tag assignments to text style classes and tag handlers.
  ///
  /// Example:
  /// ```dart
  /// StyledText(
  ///   text: '&lt;red&gt;Red&lt;/red&gt; text.',
  ///   tags: [
  ///     'red': StyledTextTag(style: TextStyle(color: Colors.red)),
  ///   ],
  /// )
  /// ```
  final Map<String, StyledTextTagBase> tags;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// The directionality of the text.
  final TextDirection? textDirection;

  /// Whether the text should break at soft line breaks.
  ///
  /// If false, the glyphs in the text will be positioned as if there was unlimited horizontal space.
  final bool? softWrap;

  /// How visual overflow should be handled.
  final TextOverflow? overflow;

  /// The number of font pixels for each logical pixel.
  ///
  /// For example, if the text scale factor is 1.5, text will be 50% larger than
  /// the specified font size.
  @Deprecated(
    'Use textScaler instead. '
    'Use of textScaleFactor was deprecated in preparation for the upcoming nonlinear text scaling support. '
    'This feature was deprecated in next major release.',
  )
  final double? textScaleFactor;

  /// {@macro flutter.painting.textPainter.textScaler}
  final TextScaler? textScaler;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be truncated according
  /// to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  final int? maxLines;

  /// Used to select a font when the same Unicode character can
  /// be rendered differently, depending on the locale.
  ///
  /// It's rarely necessary to set this property. By default its value
  /// is inherited from the enclosing app with `Localizations.localeOf(context)`.
  ///
  /// See [RenderParagraph.locale] for more information.
  final Locale? locale;

  /// {@macro flutter.painting.textPainter.strutStyle}
  final StrutStyle? strutStyle;

  /// {@macro flutter.painting.textPainter.textWidthBasis}
  final TextWidthBasis? textWidthBasis;

  /// {@macro dart.ui.textHeightBehavior}
  final ui.TextHeightBehavior? textHeightBehavior;

  /// Used for asynchronous text parsing.
  /// Necessary to solve performance problems when a large block
  /// of text with a large number of tags is passed to [StyledText].
  ///
  /// By default, parsing is synchronous.
  ///
  /// **Attention!** With asynchronous parsing, the size of the widget changes,
  /// and flickering is also possible, because first, the widget is rendered empty,
  /// and then (when asynchronous parsing is completed), the widget is redrawn
  /// with the final formatted text.
  final bool async;

  /// Create a text widget with formatting via tags.
  ///
  const StyledText({
    Key? key,
    required this.text,
    this.newLineAsBreaks = true,
    this.style,
    Map<String, StyledTextTagBase>? tags,
    this.textAlign,
    this.textDirection,
    this.softWrap = true,
    this.overflow,
    this.textScaleFactor,
    this.textScaler,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.async = false,
  })  : tags = tags ?? const {},
        selectable = false,
        _focusNode = null,
        _showCursor = false,
        _autofocus = false,
        _toolbarOptions = null,
        _contextMenuBuilder = null,
        _selectionControls = null,
        _selectionHeightStyle = null,
        _selectionWidthStyle = null,
        _onSelectionChanged = null,
        _magnifierConfiguration = null,
        _cursorWidth = null,
        _cursorHeight = null,
        _cursorRadius = null,
        _cursorColor = null,
        _dragStartBehavior = DragStartBehavior.start,
        _enableInteractiveSelection = false,
        _onTap = null,
        _scrollPhysics = null,
        _semanticsLabel = null,
        super(key: key);

  /// Create a selectable text widget with formatting via tags.
  ///
  /// See [SelectableText.rich] for more options.
  const StyledText.selectable({
    Key? key,
    required this.text,
    this.newLineAsBreaks = false,
    this.style,
    Map<String, StyledTextTagBase>? tags,
    this.textAlign,
    this.textDirection,
    this.textScaleFactor,
    this.textScaler,
    this.maxLines,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
    FocusNode? focusNode,
    bool showCursor = false,
    bool autofocus = false,
    this.async = false,
    @Deprecated(
      'Use `contextMenuBuilder` instead. '
      'This feature was deprecated after Flutter v3.3.0-0.5.pre.',
    )
    // ignore: deprecated_member_use
    ToolbarOptions? toolbarOptions,
    EditableTextContextMenuBuilder contextMenuBuilder =
        _defaultContextMenuBuilder,
    TextSelectionControls? selectionControls,
    ui.BoxHeightStyle selectionHeightStyle = ui.BoxHeightStyle.tight,
    ui.BoxWidthStyle selectionWidthStyle = ui.BoxWidthStyle.tight,
    SelectionChangedCallback? onSelectionChanged,
    TextMagnifierConfiguration? magnifierConfiguration,
    double cursorWidth = 2.0,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    bool enableInteractiveSelection = true,
    GestureTapCallback? onTap,
    ScrollPhysics? scrollPhysics,
    String? semanticsLabel,
  })  : tags = tags ?? const {},
        selectable = true,
        softWrap = true,
        overflow = TextOverflow.clip,
        locale = null,
        _focusNode = focusNode,
        _showCursor = showCursor,
        _autofocus = autofocus,
        _toolbarOptions = toolbarOptions ??
            // ignore: deprecated_member_use
            const ToolbarOptions(
              selectAll: true,
              copy: true,
            ),
        _contextMenuBuilder = contextMenuBuilder,
        _selectionHeightStyle = selectionHeightStyle,
        _selectionWidthStyle = selectionWidthStyle,
        _selectionControls = selectionControls,
        _onSelectionChanged = onSelectionChanged,
        _magnifierConfiguration = magnifierConfiguration,
        _cursorWidth = cursorWidth,
        _cursorHeight = cursorHeight,
        _cursorRadius = cursorRadius,
        _cursorColor = cursorColor,
        _dragStartBehavior = dragStartBehavior,
        _enableInteractiveSelection = enableInteractiveSelection,
        _onTap = onTap,
        _scrollPhysics = scrollPhysics,
        _semanticsLabel = semanticsLabel,
        super(key: key);

  final FocusNode? _focusNode;
  final bool _showCursor;
  final bool _autofocus;

  // ignore: deprecated_member_use
  final ToolbarOptions? _toolbarOptions;
  final EditableTextContextMenuBuilder? _contextMenuBuilder;
  final TextSelectionControls? _selectionControls;
  final ui.BoxHeightStyle? _selectionHeightStyle;
  final ui.BoxWidthStyle? _selectionWidthStyle;
  final SelectionChangedCallback? _onSelectionChanged;
  final TextMagnifierConfiguration? _magnifierConfiguration;
  final double? _cursorWidth;
  final double? _cursorHeight;
  final Radius? _cursorRadius;
  final Color? _cursorColor;
  final DragStartBehavior _dragStartBehavior;
  final bool _enableInteractiveSelection;
  final GestureTapCallback? _onTap;
  final ScrollPhysics? _scrollPhysics;
  final String? _semanticsLabel;

  static Widget _defaultContextMenuBuilder(
      BuildContext context, EditableTextState editableTextState) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }

  Widget _buildText(BuildContext context, TextSpan textSpan) {
    final defaultTextStyle = DefaultTextStyle.of(context);
    final registrar = SelectionContainer.maybeOf(context);

    final effectiveTextScaler = textScaler ??
        // ignore: deprecated_member_use_from_same_package
        ((textScaleFactor != null)
            // ignore: deprecated_member_use_from_same_package
            ? TextScaler.linear(textScaleFactor!)
            : null) ??
        MediaQuery.textScalerOf(context);

    Widget result = RichText(
      textAlign: textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start,
      textDirection: textDirection,
      softWrap: softWrap ?? defaultTextStyle.softWrap,
      overflow:
          overflow ?? textSpan.style?.overflow ?? defaultTextStyle.overflow,
      textScaler: effectiveTextScaler,
      maxLines: maxLines ?? defaultTextStyle.maxLines,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis ?? defaultTextStyle.textWidthBasis,
      textHeightBehavior: textHeightBehavior ??
          defaultTextStyle.textHeightBehavior ??
          DefaultTextHeightBehavior.maybeOf(context),
      text: textSpan,
      selectionRegistrar: registrar,
      selectionColor: DefaultSelectionStyle.of(context).selectionColor,
    );

    if (registrar != null) {
      result = MouseRegion(
        cursor: SystemMouseCursors.text,
        child: result,
      );
    }

    return result;
  }

  Widget _buildSelectableText(BuildContext context, TextSpan textSpan) {
    final defaultTextStyle = DefaultTextStyle.of(context);

    final effectiveTextScaler = textScaler ??
        // ignore: deprecated_member_use_from_same_package
        ((textScaleFactor != null)
            // ignore: deprecated_member_use_from_same_package
            ? TextScaler.linear(textScaleFactor!)
            : null) ??
        MediaQuery.textScalerOf(context);

    return SelectableText.rich(
      textSpan,
      focusNode: _focusNode,
      showCursor: _showCursor,
      autofocus: _autofocus,
      // ignore: deprecated_member_use
      toolbarOptions: _toolbarOptions,
      contextMenuBuilder: _contextMenuBuilder,
      selectionControls: _selectionControls,
      selectionHeightStyle: _selectionHeightStyle!,
      selectionWidthStyle: _selectionWidthStyle!,
      onSelectionChanged: _onSelectionChanged,
      magnifierConfiguration: _magnifierConfiguration,
      cursorWidth: _cursorWidth!,
      cursorHeight: _cursorHeight,
      cursorRadius: _cursorRadius,
      cursorColor: _cursorColor,
      dragStartBehavior: _dragStartBehavior,
      enableInteractiveSelection: _enableInteractiveSelection,
      onTap: _onTap,
      scrollPhysics: _scrollPhysics,
      textWidthBasis: textWidthBasis ?? defaultTextStyle.textWidthBasis,
      textHeightBehavior: textHeightBehavior ??
          defaultTextStyle.textHeightBehavior ??
          DefaultTextHeightBehavior.maybeOf(context),
      textAlign: textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start,
      textDirection: textDirection,
      // softWrap
      // overflow
      textScaler: effectiveTextScaler,
      maxLines: maxLines ?? defaultTextStyle.maxLines,
      // locale
      strutStyle: strutStyle,
      semanticsLabel: _semanticsLabel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomStyledText(
      style: style,
      newLineAsBreaks: newLineAsBreaks,
      text: text,
      tags: tags,
      builder: selectable ? _buildSelectableText : _buildText,
      textParserBuilder: async
          ? ((onTag, onParsed) =>
              StyledTextParserAsync(onTag: onTag, onParsed: onParsed))
          : ((onTag, onParsed) =>
              StyledTextParserSync(onTag: onTag, onParsed: onParsed)),
    );
  }
}
