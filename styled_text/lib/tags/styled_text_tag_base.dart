import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

abstract class StyledTextTagBase {
  GestureRecognizer? createRecognizer(String? text, Map<String?, String?> attributes) => null;

  InlineSpan createSpan({
    String? text,
    List<InlineSpan>? children,
    required Map<String?, String?> attributes,
    GestureRecognizer? recognizer,
  });
}

typedef StyledTextTagActionCallback = void Function(String? text, Map<String?, String?> attributes);

/*
class StyledTextRecoginzer extends TapGestureRecognizer {
  StyledTextTagActionCallback? onTextTap;
  String? text;
  Map<String?, String?>? attributes;

  StyledTextRecoginzer({
    this.text,
    this.attributes,
    this.onTextTap,
  }) : super() {
    this.onTap = _textTap;
  }

  void _textTap() {
    onTextTap?.call(text, attributes ?? const {});
  }
}
*/
