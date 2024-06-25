import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // showPerformanceOverlay: true,
      title: 'StyledText Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool async = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StyledText Demo'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch.adaptive(
                    value: async,
                    onChanged: (value) => setState(() {
                      async = value;
                    }),
                  ),
                  const SizedBox(width: 8.0),
                  const Text('Async?'),
                ],
              ),

              //
              const Divider(),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SimpleDemoPage(async: async)),
                  );
                },
                child: const Text('Simple Demo'),
              ),

              //
              const SizedBox(height: 24),

              //
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LargeTextDemo(async: async)),
                  );
                },
                child: const Text('Large Text Demo'),
              ),

              //
              const SizedBox(height: 24),

              //
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListDemo(async: async)),
                  );
                },
                child: const Text('List Demo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SimpleDemoPage extends StatelessWidget {
  final bool async;

  const SimpleDemoPage({
    super.key,
    this.async = false,
  });

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
          title: const Text('Simple Demo'),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Simple formatted text
                StyledText(
                  async: async,
                  text: 'Test: <b>bold</b> text.',
                  tags: const {
                    'b': StyledTextTag(style: TextStyle(fontWeight: FontWeight.bold)),
                  },
                ),

                // Text with quotes
                const SizedBox(height: 20),
                StyledText(
                  async: async,
                  text: 'Quoted Test: <b>&quot;bold&quot;</b> text.',
                  tags: const {
                    'b': StyledTextTag(style: TextStyle(fontWeight: FontWeight.bold)),
                  },
                ),

                // Multiline text without breaks
                const SizedBox(height: 20),
                StyledText(
                  async: async,
                  text: """Multiline text 
(wo breaks)""",
                  tags: const {
                    'b': StyledTextTag(style: TextStyle(fontWeight: FontWeight.bold)),
                  },
                ),

                // Multiline text with breaks
                const SizedBox(height: 20),
                StyledText(
                  async: async,
                  text: """Multiline text
(with breaks)""",
                  newLineAsBreaks: true,
                  tags: const {
                    'b': StyledTextTag(style: TextStyle(fontWeight: FontWeight.bold)),
                  },
                ),

                // Custom tags styles
                const SizedBox(height: 20),
                StyledText(
                  async: async,
                  text: 'Test: <bold>bold</bold> and <red>red color</red> text.',
                  tags: const {
                    'bold': StyledTextTag(style: TextStyle(fontWeight: FontWeight.bold)),
                    'red': StyledTextTag(style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                  },
                ),

                // Icon
                const SizedBox(height: 20),
                StyledText(
                  async: async,
                  text: 'Text with alarm <alarm/> icon.',
                  tags: const {
                    'alarm': StyledTextIconTag(Icons.alarm),
                  },
                ),

                // Action
                const SizedBox(height: 20),
                StyledText(
                  async: async,
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
                  async: async,
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
                  async: async,
                  text: 'Selectable text with <link href="https://flutter.dev">link</link> inside.',
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
                  async: async,
                  text: "Famous equation: E=mc<sup>2</sup>",
                  tags: {
                    'sup': StyledTextWidgetBuilderTag(
                      (_, attributes, textContent) {
                        return Transform.translate(
                          offset: const Offset(0.5, -4),
                          child: Text(
                            textContent ?? "",
                            textScaler: TextScaler.linear(MediaQuery.of(context).textScaler.scale(0.85)),
                          ),
                        );
                      },
                    ),
                  },
                ),

                // Text with subscript
                const SizedBox(height: 20),
                StyledText(
                  async: async,
                  text: "The element of life: H<sub>2</sub>0",
                  tags: {
                    'sub': StyledTextWidgetBuilderTag(
                      (_, attributes, textContent) {
                        return Transform.translate(
                          offset: const Offset(0.5, 4),
                          child: Text(
                            textContent ?? "",
                            textScaler: TextScaler.linear(MediaQuery.of(context).textScaler.scale(0.8)),
                          ),
                        );
                      },
                    ),
                  },
                ),

                // Custom attributes
                const SizedBox(height: 20),
                StyledText(
                  async: async,
                  text:
                      'Text with <text color="#ff5500">custom <text weight="bold" color="#00ca9d">nested</text> tags</text> text.',
                  tags: {
                    'text': StyledTextCustomTag(
                      baseStyle: const TextStyle(fontStyle: FontStyle.italic),
                      parse: (style, attributes) {
                        // Text color
                        final textColor = attributes['color'];
                        if (textColor != null && (textColor.substring(0, 1) == '#') && textColor.length >= 6) {
                          final String hexColor = textColor.substring(1);
                          final String alphaChannel = (hexColor.length == 8) ? hexColor.substring(6, 8) : 'FF';
                          final Color color = Color(int.parse('0x$alphaChannel${hexColor.substring(0, 6)}'));
                          return style?.copyWith(color: color);
                        }

                        // Font style
                        if (attributes['weight'] == 'bold') {
                          style = style?.copyWith(
                            fontWeight: FontWeight.w900,
                          );
                        }
                        return style;
                      },
                    ),
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LargeTextDemo extends StatefulWidget {
  final bool async;

  const LargeTextDemo({
    super.key,
    this.async = false,
  });

  @override
  State<LargeTextDemo> createState() => _LargeTextDemoState();
}

class _LargeTextDemoState extends State<LargeTextDemo> {
  Key _textKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Large Text Demo'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _textKey = UniqueKey();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: StyledText(
            key: _textKey,
            async: widget.async,
            text: '''
Lorem ipsum dolor sit <b>amet</b>, consectetuer adipiscing elit. Sed <i>dapibus, ante ultricies adipiscing pulvinar</i>, enim tellus volutpat odio, vel <b>pretium <i>ligula</i> purus</b> vel ligula. In posuere justo eget libero. Cras consequat quam sit amet metus. Sed vitae nulla. Cras imperdiet sapien vitae ipsum. Curabitur tristique. Aliquam non tellus eget sem commodo tincidunt. Phasellus cursus nunc. Integer vel mi. Aenean rutrum libero sit amet enim. Nunc elementum, erat eu volutpat ultricies, eros justo scelerisque leo, quis sollicitudin purus ipsum at purus. Aenean ut nulla.
Lorem ipsum dolor sit <b>amet</b>, consectetuer adipiscing elit. Sed <i>dapibus, ante ultricies adipiscing pulvinar</i>, enim tellus volutpat odio, vel <b>pretium <i>ligula</i> purus</b> vel ligula. In posuere justo eget libero. Cras consequat quam sit amet metus. Sed vitae nulla. Cras imperdiet sapien vitae ipsum. Curabitur tristique. Aliquam non tellus eget sem commodo tincidunt. Phasellus cursus nunc. Integer vel mi. Aenean rutrum libero sit amet enim. Nunc elementum, erat eu volutpat ultricies, eros justo scelerisque leo, quis sollicitudin purus ipsum at purus. Aenean ut nulla.
Lorem ipsum dolor sit <b>amet</b>, consectetuer adipiscing elit. Sed <i>dapibus, ante ultricies adipiscing pulvinar</i>, enim tellus volutpat odio, vel <b>pretium <i>ligula</i> purus</b> vel ligula. In posuere justo eget libero. Cras consequat quam sit amet metus. Sed vitae nulla. Cras imperdiet sapien vitae ipsum. Curabitur tristique. Aliquam non tellus eget sem commodo tincidunt. Phasellus cursus nunc. Integer vel mi. Aenean rutrum libero sit amet enim. Nunc elementum, erat eu volutpat ultricies, eros justo scelerisque leo, quis sollicitudin purus ipsum at purus. Aenean ut nulla.
Lorem ipsum dolor sit <b>amet</b>, consectetuer adipiscing elit. Sed <i>dapibus, ante ultricies adipiscing pulvinar</i>, enim tellus volutpat odio, vel <b>pretium <i>ligula</i> purus</b> vel ligula. In posuere justo eget libero. Cras consequat quam sit amet metus. Sed vitae nulla. Cras imperdiet sapien vitae ipsum. Curabitur tristique. Aliquam non tellus eget sem commodo tincidunt. Phasellus cursus nunc. Integer vel mi. Aenean rutrum libero sit amet enim. Nunc elementum, erat eu volutpat ultricies, eros justo scelerisque leo, quis sollicitudin purus ipsum at purus. Aenean ut nulla.
Lorem ipsum dolor sit <b>amet</b>, consectetuer adipiscing elit. Sed <i>dapibus, ante ultricies adipiscing pulvinar</i>, enim tellus volutpat odio, vel <b>pretium <i>ligula</i> purus</b> vel ligula. In posuere justo eget libero. Cras consequat quam sit amet metus. Sed vitae nulla. Cras imperdiet sapien vitae ipsum. Curabitur tristique. Aliquam non tellus eget sem commodo tincidunt. Phasellus cursus nunc. Integer vel mi. Aenean rutrum libero sit amet enim. Nunc elementum, erat eu volutpat ultricies, eros justo scelerisque leo, quis sollicitudin purus ipsum at purus. Aenean ut nulla.
Lorem ipsum dolor sit <b>amet</b>, consectetuer adipiscing elit. Sed <i>dapibus, ante ultricies adipiscing pulvinar</i>, enim tellus volutpat odio, vel <b>pretium <i>ligula</i> purus</b> vel ligula. In posuere justo eget libero. Cras consequat quam sit amet metus. Sed vitae nulla. Cras imperdiet sapien vitae ipsum. Curabitur tristique. Aliquam non tellus eget sem commodo tincidunt. Phasellus cursus nunc. Integer vel mi. Aenean rutrum libero sit amet enim. Nunc elementum, erat eu volutpat ultricies, eros justo scelerisque leo, quis sollicitudin purus ipsum at purus. Aenean ut nulla.
Lorem ipsum dolor sit <b>amet</b>, consectetuer adipiscing elit. Sed <i>dapibus, ante ultricies adipiscing pulvinar</i>, enim tellus volutpat odio, vel <b>pretium <i>ligula</i> purus</b> vel ligula. In posuere justo eget libero. Cras consequat quam sit amet metus. Sed vitae nulla. Cras imperdiet sapien vitae ipsum. Curabitur tristique. Aliquam non tellus eget sem commodo tincidunt. Phasellus cursus nunc. Integer vel mi. Aenean rutrum libero sit amet enim. Nunc elementum, erat eu volutpat ultricies, eros justo scelerisque leo, quis sollicitudin purus ipsum at purus. Aenean ut nulla.
Lorem ipsum dolor sit <b>amet</b>, consectetuer adipiscing elit. Sed <i>dapibus, ante ultricies adipiscing pulvinar</i>, enim tellus volutpat odio, vel <b>pretium <i>ligula</i> purus</b> vel ligula. In posuere justo eget libero. Cras consequat quam sit amet metus. Sed vitae nulla. Cras imperdiet sapien vitae ipsum. Curabitur tristique. Aliquam non tellus eget sem commodo tincidunt. Phasellus cursus nunc. Integer vel mi. Aenean rutrum libero sit amet enim. Nunc elementum, erat eu volutpat ultricies, eros justo scelerisque leo, quis sollicitudin purus ipsum at purus. Aenean ut nulla.
Lorem ipsum dolor sit <b>amet</b>, consectetuer adipiscing elit. Sed <i>dapibus, ante ultricies adipiscing pulvinar</i>, enim tellus volutpat odio, vel <b>pretium <i>ligula</i> purus</b> vel ligula. In posuere justo eget libero. Cras consequat quam sit amet metus. Sed vitae nulla. Cras imperdiet sapien vitae ipsum. Curabitur tristique. Aliquam non tellus eget sem commodo tincidunt. Phasellus cursus nunc. Integer vel mi. Aenean rutrum libero sit amet enim. Nunc elementum, erat eu volutpat ultricies, eros justo scelerisque leo, quis sollicitudin purus ipsum at purus. Aenean ut nulla.
Lorem ipsum dolor sit <b>amet</b>, consectetuer adipiscing elit. Sed <i>dapibus, ante ultricies adipiscing pulvinar</i>, enim tellus volutpat odio, vel <b>pretium <i>ligula</i> purus</b> vel ligula. In posuere justo eget libero. Cras consequat quam sit amet metus. Sed vitae nulla. Cras imperdiet sapien vitae ipsum. Curabitur tristique. Aliquam non tellus eget sem commodo tincidunt. Phasellus cursus nunc. Integer vel mi. Aenean rutrum libero sit amet enim. Nunc elementum, erat eu volutpat ultricies, eros justo scelerisque leo, quis sollicitudin purus ipsum at purus. Aenean ut nulla.
''',
            tags: const {
              'b': StyledTextTag(style: TextStyle(fontWeight: FontWeight.bold)),
              'i': StyledTextTag(style: TextStyle(fontStyle: FontStyle.italic)),
            },
          ),
        ),
      ),
    );
  }
}

class ListDemo extends StatelessWidget {
  final bool async;

  const ListDemo({
    super.key,
    this.async = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Demo'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 100,
        itemBuilder: (context, index) => StyledText(
          async: async,
          text: '''
Lorem ipsum dolor sit <b>amet</b>, consectetuer adipiscing elit. Sed <i>dapibus, ante ultricies adipiscing pulvinar</i>, enim tellus volutpat odio.
        ''',
          tags: const {
            'b': StyledTextTag(style: TextStyle(fontWeight: FontWeight.bold)),
            'i': StyledTextTag(style: TextStyle(fontStyle: FontStyle.italic)),
          },
        ),
      ),
    );
  }
}
