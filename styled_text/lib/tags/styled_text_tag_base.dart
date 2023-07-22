import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

abstract class StyledTextTagBase {
  GestureRecognizer? createRecognizer(String? text, Map<String?, String?> attributes) => null;

  InlineSpan createSpan({
    required BuildContext context,
    String? text,
    String? textContent,
    List<InlineSpan>? children,
    required Map<String?, String?> attributes,
    GestureRecognizer? recognizer,
  });
}

typedef StyledTextTagActionCallback = void Function(String? text, Map<String?, String?> attributes);
