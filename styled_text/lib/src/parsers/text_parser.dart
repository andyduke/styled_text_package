import 'package:styled_text/src/parsers/mini_dom.dart';
import 'package:styled_text/src/tags/styled_text_tag_base.dart';

/// Callback signature for style lookup by tag name.
typedef StyledTextParserTagCallback = StyledTextTagBase? Function(String? tag);

/// Signature of the callback called when text parsing is complete.
typedef StyledTextParserCallback = void Function(StyledNode node, bool async);

/// Abstract base text parser class that creates a tree of nodes from tagged text.
abstract class StyledTextParser {
  /// Callback to look up a style by tag name.
  ///
  /// Receives the tag name as a parameter and must return the style for the tag,
  /// or `null` if the style for the tag is not defined.
  final StyledTextParserTagCallback onTag;

  /// Callback called when text parsing and node tree construction are complete.
  final StyledTextParserCallback onParsed;

  /// Creates a text parser class that creates a tree of nodes from tagged text.
  const StyledTextParser({
    required this.onTag,
    required this.onParsed,
  });

  /// Parses text and creates a hierarchy of [StyledNode] based on tags and
  /// text pieces in the text.
  ///
  /// When parsing is complete, calls the [onParsed] callback.
  void parse(String text);
}
