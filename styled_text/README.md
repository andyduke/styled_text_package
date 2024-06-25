# StyledText

Text widget with formatted text using tags. Makes it easier to use formatted text in multilingual applications.

Formatting is set in the text using **xml tags**, for which styles and other behaviors are defined separately. It is also possible to insert icons and widgets through tags.

You can set the click handler for the tag, through a tag definition class `StyledTextActionTag`.

## Table of Contents

- [Getting Started](#getting-Started)
  - [Escaping & special characters](#escaping--special-characters)
  - [Line breaks](#line-breaks)
- [Usage examples](#usage-examples)
  - [How to insert a widget into text](#an-example-of-inserting-an-input-field-widget-in-place-of-a-tag)
- [Migration from version 2.0](#migration-from-version-20)

## Getting Started

In your flutter project add the dependency:

```dart
dependencies:
  styled_text: ^[version]
```

Import package:
```dart
import 'package:styled_text/styled_text.dart';
```

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

By default, line breaks are not ignored, all line breaks `\n` are automatically translated into the `<br/>` tag. To disable this behavior, you can set the `newLineAsBreaks` parameter to `false` and insert the `<br/>` tag where you want to break to a new line.

## Usage examples

### An example of making parts of text bold:
```dart
StyledText(
  text: 'Test: <bold>bold</bold> text.',
  tags: {
    'bold': StyledTextTag(style: TextStyle(fontWeight: FontWeight.bold)),
  },
)
```
![](https://github.com/andyduke/styled_text_package/raw/master/screenshots/1-bold.png)

---

### Example of highlighting a part of the text by different styles:
```dart
StyledText(
  text: 'Test: <bold>bold</bold> and <red>red color</red> text.',
  tags: {
    'bold': StyledTextTag(style: TextStyle(fontWeight: FontWeight.bold)),
    'red': StyledTextTag(style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
  },
)
```
![](https://github.com/andyduke/styled_text_package/raw/master/screenshots/2-bold-and-color.png)

---

### Example of inserting icons into the text:
```dart
StyledText(
  text: 'Text with alarm <alarm/> icon.',
  tags: {
    'alarm': StyledTextIconTag(Icons.alarm),
  },
)
```
![](https://github.com/andyduke/styled_text_package/raw/master/screenshots/3-icon.png)

---

### Example of using a tag handler:
```dart
StyledText(
  text: 'Text with <link href="https://flutter.dev">link</link> inside.',
  tags: {
    'link': StyledTextActionTag(
      (String? text, Map<String?, String?> attrs) => {
        final String link = attrs['href'];
        print('The "$link" link is tapped.');
      },
      style: TextStyle(decoration: TextDecoration.underline),
    ),
  },
)
```
![](https://github.com/andyduke/styled_text_package/raw/master/screenshots/4-link.png)

---

### Example of using a custom tag attributes handler, highlights text with the color specified in the "text" attribute of the tag:
```dart
StyledText(
 text:
     'Text with <text color="#ff5500">custom <text weight="bold" color="#eeca9d">nested</text> tags</text> text.',
 tags: {
   'text': StyledTextCustomTag(
       baseStyle: const TextStyle(fontStyle: FontStyle.italic),
       parse: (style, attributes) {
         //Tag color
         final textColor = attributes['color'];
         if (textColor != null &&
             (textColor.substring(0, 1) == '#') &&
             textColor.length >= 6) {
           final String hexColor = textColor.substring(1);
           final String alphaChannel = (hexColor.length == 8)
               ? hexColor.substring(6, 8)
               : 'FF';
           final Color color = Color(int.parse(
               '0x$alphaChannel${hexColor.substring(0, 6)}'));
           return style?.copyWith(color: color);
         }

         //Tag bold

         final weight = attributes['weight'];
         if (weight != null) {
           if (weight == 'bold') {
             style = style?.copyWith(
               fontWeight: FontWeight.w900,
             );
           }
         }
         return style;
       }),
 },
),
```
![](https://github.com/andyduke/styled_text_package/raw/master/screenshots/5-custom_tags.png)
---

### An example of inserting an input field widget in place of a tag:
```dart
StyledText(
  text: 'Text with <input/> inside.',
  tags: {
    'input': StyledTextWidgetTag(
      TextField(
        decoration: InputDecoration(
          hintText: 'Input',
        ),
      ),
      size: Size.fromWidth(200),
      constraints: BoxConstraints.tight(Size(100, 50)),
    ),
  },
)
```
---

### An example of using a widget with the ability to select rich text:
```dart
StyledText.selectable(
  text: 'Test: <bold>bold</bold> text.',
  tags: {
    'bold': StyledTextTag(style: TextStyle(fontWeight: FontWeight.bold)),
  },
)
```

## Migration from version 2.0

Starting from version 3.0, the way of specifying styles and behavior for tags has changed. Now for this you need to use the `tags` parameter instead of `styles` and another set of classes to define styles and behavior.

Below are examples of converting old code to new.

### Specifying the text style

**OLD**
```dart
StyledText(
  text: 'Example: <b>bold</b> text.',
  styles: {
    'b': TextStyle(fontWeight: FontWeight.bold),
  },
)
```

**NEW**
```dart
StyledText(
  text: 'Example: <b>bold</b> text.',
  tags: {
    'b': StyledTextTag(style: TextStyle(fontWeight: FontWeight.bold)),
  },
)
```
---

### Specifying the icon

**OLD**
```dart
StyledText(
  text: 'Text with alarm <alarm/> icon.',
  styles: {
    'alarm': IconStyle(Icons.alarm),
  },
)
```

**NEW**
```dart
StyledText(
  text: 'Text with alarm <alarm/> icon.',
  tags: {
    'alarm': StyledTextIconTag(Icons.alarm),
  },
)
```
---

### Specifying a tap handler 

**OLD**
```dart
StyledText(
  text: 'Text with <link href="https://flutter.dev">link</link> inside.',
  styles: {
    'link': ActionTextStyle(
      decoration: TextDecoration.underline,
      onTap: (_, attrs) => _openLink(context, attrs),
    ),
  },
)
```

**NEW**
```dart
StyledText(
  text: 'Text with <link href="https://flutter.dev">link</link> inside.',
  tags: {
    'link': StyledTextActionTag(
      (_, attrs) => _openLink(context, attrs),
      style: TextStyle(decoration: TextDecoration.underline),
    ),
  },
)
```
---

### Specifying a custom parser for attributes and creating a style

**OLD**
```dart
StyledText(
  text: 'Text with custom <color text="#ff5500">color</color> text.',
  styles: {
    'color': CustomTextStyle(
        baseStyle: TextStyle(fontStyle: FontStyle.italic),
        parse: (baseStyle, attributes) {
          // Parser code here...
        }),
  },
)
```

**NEW**
```dart
StyledText(
  text: 'Text with custom <color text="#ff5500">color</color> text.',
  tags: {
    'color': StyledTextCustomTag(
        baseStyle: TextStyle(fontStyle: FontStyle.italic),
        parse: (baseStyle, attributes) {
          // Parser code here...
        }),
  },
)
```
