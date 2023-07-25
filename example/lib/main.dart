import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StyledText Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  void _alert(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tapped'),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _openLink(BuildContext context, Map<String?, String?> attrs) {
    final String link = attrs['href'] ?? "";

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Open Link'),
          content: Text(link),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('StyledText Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Simple formatted text
              StyledText(
                text: 'Test: <b>bold</b> text.',
                tags: {
                  'b': StyledTextTag(style: const TextStyle(fontWeight: FontWeight.bold)),
                },
              ),

              // Text with quotes
              const SizedBox(height: 20),
              StyledText(
                text: 'Quoted Test: <b>&quot;bold&quot;</b> text.',
                tags: {
                  'b': StyledTextTag(style: const TextStyle(fontWeight: FontWeight.bold)),
                },
              ),

              // Multiline text without breaks
              const SizedBox(height: 20),
              StyledText(
                text: """Multiline text 
(wo breaks)""",
                tags: {
                  'b': StyledTextTag(style: const TextStyle(fontWeight: FontWeight.bold)),
                },
              ),

              // Multiline text with breaks
              const SizedBox(height: 20),
              StyledText(
                text: """Multiline text
(with breaks)""",
                newLineAsBreaks: true,
                tags: {
                  'b': StyledTextTag(style: const TextStyle(fontWeight: FontWeight.bold)),
                },
              ),

              // Custom tags styles
              const SizedBox(height: 20),
              StyledText(
                text: 'Test: <bold>bold</bold> and <red>red color</red> text.',
                tags: {
                  'bold': StyledTextTag(style: const TextStyle(fontWeight: FontWeight.bold)),
                  'red': StyledTextTag(style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                },
              ),

              // Icon
              const SizedBox(height: 20),
              StyledText(
                text: 'Text with alarm <alarm/> icon.',
                tags: {
                  'alarm': StyledTextIconTag(Icons.alarm),
                },
              ),

              // Action
              const SizedBox(height: 20),
              StyledText(
                text: 'Text with <action>action</action> inside.',
                tags: {
                  'action': StyledTextActionTag(
                    (_, attrs) => _alert(context),
                    style: const TextStyle(decoration: TextDecoration.underline),
                  ),
                },
              ),

              // Link
              const SizedBox(height: 20),
              StyledText(
                text: 'Text with <link href="https://flutter.dev">link</link> inside.',
                tags: {
                  'link': StyledTextActionTag(
                    (_, attrs) => _openLink(context, attrs),
                    style: const TextStyle(decoration: TextDecoration.underline),
                  ),
                },
              ),

              // SelectableText with Link
              const SizedBox(height: 20),
              StyledText.selectable(
                text: 'Text with <link href="https://flutter.dev">link</link> inside.',
                tags: {
                  'link': StyledTextActionTag(
                    (_, attrs) => _openLink(context, attrs),
                    style: const TextStyle(decoration: TextDecoration.underline),
                  ),
                },
              ),

              // Text with superscript
              const SizedBox(height: 20),
              StyledText(
                text: "Famous equation: E=mc<sup>2</sup>",
                tags: {
                  'sup': StyledTextWidgetBuilderTag(
                    (_, attributes, textContent) {
                      return Transform.translate(
                        offset: const Offset(0.5, -4),
                        child: Text(
                          textContent ?? "",
                          textScaleFactor: 0.85,
                        ),
                      );
                    },
                  ),
                },
              ),

              // Text with subscript
              const SizedBox(height: 20),
              StyledText(
                text: "The element of life: H<sub>2</sub>0",
                tags: {
                  'sub': StyledTextWidgetBuilderTag(
                    (_, attributes, textContent) {
                      return Transform.translate(
                        offset: const Offset(0.5, 4),
                        child: Text(
                          textContent ?? "",
                          textScaleFactor: 0.8,
                        ),
                      );
                    },
                  ),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
