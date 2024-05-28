## 9.0.0-beta-2

* The constructors of some widgets and classes are now constant:
  - StyledText
  - CustomStyledText
  - StyledTextTagBase
  - StyledTextTag
  - StyledTextWidgetBuilderTag
  - StyledTextIconTag
  - StyledTextActionTag
  - StyledTextCustomTag

## 9.0.0-beta-1

* Text parsing has been changed from **asynchronous** to **synchronous**.
  This fixes an issue with the `StyledText` widget resizing when text parsing is complete, which was causing problems in lists.
  To return asynchronous parsing, the `async` parameter has been added to the `StyledText` constructor.
  This change was made possible thanks to the help of [@Maatteogekko](https://github.com/Maatteogekko).
* Require Flutter 3.16 and Dart 3.2.

## 8.1.0

* A new base widget, `CustomStyledText`, has been added that allows you to implement the construction of a `RichText` widget, for example, when using the `AutoSizeText` widget (thanks to [@maeddin](https://github.com/maeddin)).

## 8.0.0

* A new parameter has been added to the `builder` signature of the `StyledTextWidgetBuilderTag` widget: `textContent` - the text content of the tag; thanks to [@ThomasGysemans](https://github.com/ThomasGysemans).

  Usage example:
  ```dart
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
  ```

## 7.0.0

* Compatibility with Flutter 3.7.0.
* New parameters `contextMenuBuilder`, `selectionControls`, `selectionHeightStyle`, `selectionWidthStyle`, `onSelectionChanged`, `magnifierConfiguration`, `semanticsLabel` have been added to `StyledText.selectable`.
* In `StyledText.selectable`, the `toolbarOptions` parameter has been deprecated.

## 6.0.0

* Added support for `SelectionArea`.

## 5.1.0

* Fixed a bug that caused building after dispose.

## 5.0.0+1

* `StyledText` now reacts to theme and default text style changes. 
* Fixed flickering when rebuilding without changing text and styles.
* Removed deprecated stuff.

## 4.0.0+1

* **[Breaking Changes]** Removed deprecated widgets and classes from version 2.x.

## 3.0.4+1

* Fixed a bug in `StyledTextActionTag` (tag's content was not passed to the first parameter of the callback).

## 3.0.3

**Attention!** Deprecated constructs from version 2.x will be removed in the next update.

* Flutter 2.5 compatibility.

## 3.0.2

* **[Breaking Changes]** In `StyledTextWidgetBuilderTag.builder` now the tag attributes are passed as the second parameter.

## 3.0.1

* Fixed a bug when unmounting a widget from a tree during text parsing.

## 3.0.0

* Flutter 2.2 compatibility.

## 3.0.0-beta+2

* **[Breaking Changes]** Changed the way text tags are styled. Now, instead of `TextStyle` and classes that implement it, you need to use new classes that describe the styles and behavior of tags.
* **[Breaking changes]** The `newLineAsBreaks` parameter is now `true` by default.
* Added the ability to insert any widgets into the text.

## 2.0.0

* Fixed a typo in the example.

## 2.0.0-nullsafety.0

* Migrate to null safety.

## 1.0.3+4

* Improved handling of broken xml.

## 1.0.3+3

* Fixed a bug when the space between two tags was eaten.

## 1.0.3+2

* Made a workaround to keep whitespace between tags: `<b>bold</b>&space;<i>italic</i>`.
* Added `size`, `color` and `backgroundColor` parameters to `IconStyle` class.

## 1.0.3+1

* Added `CustomTextStyle` text style, for which you can specify handling of tag attributes.

## 1.0.2+1

* Added the `StyledText.selectable` constructor to create selectable text.
* Added guidance on escaping XML special characters in text.
* The deprecated `isNewLineAsBreaks` parameter has been removed.

## 1.0.1+3

* Fixed flickering when changing style, styles and text.

## 1.0.1+2

* Improved support for DefaultTextSyle, now `style` property is merging with DefaultTextSyle.
* Fixed a bug where no redrawing occurred when changing `style` property.

## 1.0.1+1

* The parameter isNewLineAsBreaks has been renamed to newLineAsBreaks, isNewLineAsBreaks is deprecated.

## 1.0.1

* The parameter isNewLineAsBreaks has been added, indicating not to ignore line breaks in the source text.
* Added description of parameters via doc comments.

## 1.0.0+2

* Allow XML special chars: &lt; (<), &amp; (&), &gt; (>), &quot; ("), and &apos; (')
* Avoid memory leak log message

## 1.0.0+1

* Example added.

## 1.0.0

* Initial release.
