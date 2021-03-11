# StyledText

Text widget with formatted text using tags. Makes it easier to use formatted text in multilingual applications.

Formatting is set in the text using **xml tags**, for which styles are defined separately. It is also possible to insert icons through tags for which icons are set in styles.

You can set the click handler for the tag, through a special style `ActionTextStyle`.

### Escaping & special characters

Tag attributes must be enclosed in double quotes, for example: `<link href="https://flutter.dev">`.

You need to escape specific XML characters in text:
```
Original character  Escaped character
------------------  -----------------
"                   &quot;
'                   &apos;
&                   &amp;
<                   &lt;
>                   &gt;
<space>             &space;
```

### Line breaks

To force the text to wrap on a new line, you must use the `<br/>` tag (as in HTML). An alternative would be to set the `newLineAsBreaks = true` parameter in the constructor, then all line breaks `\n` will be automatically converted to `<br/>`.

## Getting Started

In your flutter project add the dependency:

```dart
dependencies:
  ...
  styled_text: ^[version]
```

Import package:
```dart
import 'package:styled_text/styled_text.dart';
```

## Usage examples

An example of making parts of text bold:
```dart
StyledText(
  text: 'Test: <bold>bold</bold> text.',
  styles: {
    'bold': TextStyle(fontWeight: FontWeight.bold),
  },
)
```
![](https://github.com/andyduke/styled_text_package/blob/master/screenshots/1-bold.png)

---

Example of highlighting a part of the text by different styles:
```dart
StyledText(
  text: 'Test: <bold>bold</bold> and <red>red color</red> text.',
  styles: {
    'bold': TextStyle(fontWeight: FontWeight.bold),
    'red': TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
  },
)
```
![](https://github.com/andyduke/styled_text_package/blob/master/screenshots/2-bold-and-color.png)

---

Example of inserting icons into the text:
```dart
StyledText(
  text: 'Text with alarm <alarm/> icon.',
  styles: {
    'alarm': IconStyle(Icons.alarm),
  },
)
```
![](https://github.com/andyduke/styled_text_package/blob/master/screenshots/3-icon.png)

---

Example of using a tag handler:
```dart
StyledText(
  text: 'Text with <link href="https://flutter.dev">link</link> inside.',
  styles: {
    'link': ActionTextStyle(
      decoration: TextDecoration.underline,
      onTap: (TextSpan text, Map<String, String> attrs) => {
        final String link = attrs['href'];
        print('The "$link" link is tapped.');
      },
    ),
  },
)
```
![](https://github.com/andyduke/styled_text_package/blob/master/screenshots/4-link.png)

---

Example of using a custom tag attributes handler, highlights text with the color specified in the "text" attribute of the tag:
```dart
StyledText(
  text: 'Text with custom <color text="#ff5500">color</color> text.',
  styles: {
    'color': CustomTextStyle(
        baseStyle: TextStyle(fontStyle: FontStyle.italic),
        parse: (baseStyle, attributes) {
          if (attributes.containsKey('text') &&
              (attributes['text'].substring(0, 1) == '#') &&
              attributes['text'].length >= 6) {
            final String hexColor = attributes['text'].substring(1);
            final String alphaChannel = (hexColor.length == 8) ? hexColor.substring(6, 8) : 'FF';
            final Color color = Color(int.parse('0x$alphaChannel' + hexColor.substring(0, 6)));
            return baseStyle.copyWith(color: color);
          } else {
            return baseStyle;
          }
        }),
  },
)
```

---

An example of using a widget with the ability to select rich text:
```dart
StyledText.selectable(
  text: 'Test: <bold>bold</bold> text.',
  styles: {
    'bold': TextStyle(fontWeight: FontWeight.bold),
  },
)
```
