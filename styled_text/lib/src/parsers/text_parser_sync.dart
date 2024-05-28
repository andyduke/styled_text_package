import 'dart:collection';
import 'package:styled_text/src/parsers/mini_dom.dart';
import 'package:styled_text/src/parsers/text_parser.dart';
import 'package:styled_text/src/tags/styled_text_tag_base.dart';
import 'package:xml/xml_events.dart';

/// A synchronous text parser that builds a tree of tag nodes and
/// text pieces from text marked with tags.
class StyledTextParserSync extends StyledTextParser {
  /// Creates a synchronous text parser that builds a tree of tag
  /// nodes and text pieces from text marked with tags.
  StyledTextParserSync({
    required super.onTag,
    required super.onParsed,
  });

  @override
  void parse(String text) {
    StyledNode node = StyledTextNode();
    ListQueue<StyledNode> textQueue = ListQueue();

    void onEndElement() {
      if (textQueue.isNotEmpty) {
        final StyledNode child = node;
        node = textQueue.removeLast();
        node.children.add(child);
      }
    }

    for (final e in parseEvents(text)) {
      if (e is XmlTextEvent) {
        node.children.add(StyledTextNode(text: e.value));
      } else if (e is XmlCDATAEvent) {
        node.children.add(StyledTextNode(text: e.value));
      } else if (e is XmlStartElementEvent) {
        textQueue.addLast(node);

        if (e.name == 'br') {
          node = StyledTextNode(text: "\n");
        } else {
          StyledTextTagBase? tag = onTag(e.name);
          node = StyledTagNode(tag: tag);
          node.configure(
            {
              for (final attribute in e.attributes)
                attribute.name: attribute.value,
            },
          );
        }
        if (e.isSelfClosing) {
          onEndElement();
        }
      } else if (e is XmlEndElementEvent) {
        onEndElement();
      }
    }

    onParsed(node, true);
  }
}
