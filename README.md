# styled_text

Text widget with formatting via tags. Makes it easier to use formatted text in multilingual applications.

Formatting is set in the text using xml tags, for which styles are defined separately. It is also possible to insert icons through tags for which icons are set in styles.

You can set the click handler for the tag, through a special style ActionTextStyle.

## Getting Started

In your flutter project add the dependency:

```dart
dependencies:
  ...
  styled_text: ^1.0.0
```

Import package:
```dart
import 'package:styled_text/styled_text.dart';
```

## Usage example

An example of making parts of text bold:
```dart
StyledText(
  text: 'Test: <bold>bold</bold> text.',
  styles: {
    'bold': TextStyle(fontWeight: FontWeight.bold),
  },
)
```
![](https://github.com/andyduke/styled_text_package/blob/master/_screenshots/1-bold.png)

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
![](https://github.com/andyduke/styled_text_package/blob/master/_screenshots/2-bold-and-color.png)

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
![](https://github.com/andyduke/styled_text_package/blob/master/_screenshots/3-icon.png)

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
![](https://github.com/andyduke/styled_text_package/blob/master/_screenshots/4-link.png)
