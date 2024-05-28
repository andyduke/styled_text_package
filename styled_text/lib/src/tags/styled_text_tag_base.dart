import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// Abstract base class for specifying tag style.
abstract class StyledTextTagBase {
  /// @nodoc
  const StyledTextTagBase();

  /// Creates a Gesture Recognizer for a given style.
  GestureRecognizer? createRecognizer(
          String? text, Map<String?, String?> attributes) =>
      null;

  /// Creates a style-based Span for a RichText widget.
  InlineSpan createSpan({
    required BuildContext context,
    String? text,
    String? textContent,
    List<InlineSpan>? children,
    required Map<String?, String?> attributes,
    GestureRecognizer? recognizer,
  });
}

/// Callback to an action called from a style (for example, tapping text inside a style).
typedef StyledTextTagActionCallback = void Function(
    String? text, Map<String?, String?> attributes);
