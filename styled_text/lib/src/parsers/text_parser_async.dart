import 'dart:collection';
import 'package:styled_text/src/parsers/mini_dom.dart';
import 'package:styled_text/src/parsers/text_parser.dart';
import 'package:styled_text/src/tags/styled_text_tag_base.dart';
import 'package:xmlstream/xmlstream.dart';

/// An asynchronous text parser that builds a tree of tag nodes and
/// text pieces from text marked with tags.
class StyledTextParserAsync extends StyledTextParser {
  /// Creates an asynchronous text parser that builds a tree of tag
  /// nodes and text pieces from text marked with tags.
  StyledTextParserAsync({
    required super.onTag,
    required super.onParsed,
  });

  XmlStreamer? _xmlStreamer;

  @override
  void parse(String text) {
    // Stop previous parsing
    if (_xmlStreamer != null) {
      _xmlStreamer!.shutdown();
      _xmlStreamer = null;
    }

    StyledNode node = StyledTextNode();
    ListQueue<StyledNode> textQueue = ListQueue();
    Map<String?, String?> attributes = {};

    _xmlStreamer = XmlStreamer(
      '<?xml version="1.0" encoding="UTF-8"?><root>$text</root>',
      trimSpaces: false,
    );
    _xmlStreamer!.read().listen((e) {
      switch (e.state) {
        case XmlState.Text:
        case XmlState.CDATA:
          node.children.add(
            StyledTextNode(text: e.value),
          );
          break;

        case XmlState.Open:
          textQueue.addLast(node);

          if (e.value == 'br') {
            node = StyledTextNode(text: "\n");
          } else {
            StyledTextTagBase? tag = onTag(e.value);
            node = StyledTagNode(tag: tag);
            attributes = {};
          }

          break;

        case XmlState.Closed:
          node.configure(attributes);

          if (textQueue.isNotEmpty) {
            final StyledNode child = node;
            node = textQueue.removeLast();
            node.children.add(child);
          }

          break;

        case XmlState.Attribute:
          if (e.key != null) {
            attributes[e.key] = e.value;
          }
          break;

        case XmlState.Comment:
        case XmlState.StartDocument:
        case XmlState.EndDocument:
        case XmlState.Namespace:
        case XmlState.Top:
          break;
      }
    }).onDone(() {
      onParsed(node, true);
    });
  }
}
