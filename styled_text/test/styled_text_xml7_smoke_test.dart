import 'package:flutter_test/flutter_test.dart';
import 'package:styled_text/styled_text.dart';
import 'package:flutter/widgets.dart';

void main() {
  testWidgets('StyledText parses tags with xml 7', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: StyledText(
          text: 'Hello <b>world</b>',
          tags: {
            'b': StyledTextTag(style: const TextStyle(fontWeight: FontWeight.bold)),
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Hello', findRichText: true), findsOneWidget);
  });
}
