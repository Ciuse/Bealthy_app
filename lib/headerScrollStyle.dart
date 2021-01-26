import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'Login/config/palette.dart';

class HeaderScrollStyle {
  /// Responsible for making title Text centered.
  final bool centerHeaderTitle;

  /// Responsible for FormatButton visibility.
  final bool formatButtonVisible;

  /// Controls the text inside FormatButton.
  /// * `true` - the button will show next CalendarFormat
  /// * `false` - the button will show current CalendarFormat
  final bool formatButtonShowsNext;

  /// Use to customize header's title text (eg. with different `DateFormat`).
  /// You can use `String` transformations to further customize the text.
  /// Defaults to simple `'yMMMM'` format (eg. January 2019, February 2019, March 2019, etc.).
  ///
  /// Example usage:
  /// ```dart
  /// titleTextBuilder: (date, locale) => DateFormat.yM(locale).format(date),
  /// ```
  final TextBuilder titleTextBuilder;

  /// Style for title Text (month-year) displayed in header.
  final TextStyle titleTextStyle;

  /// Style for FormatButton `Text`.
  final TextStyle formatButtonTextStyle;

  /// Background `Decoration` for FormatButton.
  final Decoration formatButtonDecoration;

  /// Inside padding of the whole header.
  final EdgeInsets headerPadding;

  /// Outside margin of the whole header.
  final EdgeInsets headerMargin;

  /// Inside padding for FormatButton.
  final EdgeInsets formatButtonPadding;

  /// Inside padding for left chevron.
  final EdgeInsets leftChevronPadding;

  /// Inside padding for right chevron.
  final EdgeInsets rightChevronPadding;

  /// Outside margin for left chevron.
  final EdgeInsets leftChevronMargin;

  /// Outside margin for right chevron.
  final EdgeInsets rightChevronMargin;

  /// Icon used for left chevron.
  /// Defaults to black `Icons.chevron_left`.
  final Icon leftChevronIcon;

  /// Icon used for right chevron.
  /// Defaults to black `Icons.chevron_right`.
  final Icon rightChevronIcon;

  /// Header decoration, used to draw border or shadow or change color of the header
  /// Defaults to empty BoxDecoration.
  final BoxDecoration decoration;

  const HeaderScrollStyle({
    this.centerHeaderTitle = true,
    this.formatButtonVisible = true,
    this.formatButtonShowsNext = true,
    this.titleTextBuilder,
    this.titleTextStyle = const TextStyle(fontSize: 17.0),
    this.formatButtonTextStyle = const TextStyle(),
    this.formatButtonDecoration = const BoxDecoration(
      border: const Border(
          top: BorderSide(),
          bottom: BorderSide(),
          left: BorderSide(),
          right: BorderSide()),
      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
    ),
    this.headerMargin= const EdgeInsets.symmetric(horizontal: 4.0),
    this.headerPadding = const EdgeInsets.symmetric(vertical: 8.0),
    this.formatButtonPadding =
    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
    this.leftChevronPadding = const EdgeInsets.all(12.0),
    this.rightChevronPadding = const EdgeInsets.all(12.0),
    this.leftChevronMargin = const EdgeInsets.symmetric(horizontal: 8.0),
    this.rightChevronMargin = const EdgeInsets.symmetric(horizontal: 8.0),
    this.leftChevronIcon = const Icon(Icons.chevron_left, color: Palette.primaryDark),
    this.rightChevronIcon =
    const Icon(Icons.chevron_right, color: Palette.primaryDark),
    this.decoration = const BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.all(const Radius.circular(5)),
      boxShadow:[
        BoxShadow(
            spreadRadius: 0.3, //spread radius
            blurRadius: 1.4, //
            color:  const Color(0x66a6a6a6),
            offset: const Offset(0, 2)
        )
        //you can set more BoxShadow() here
      ],
    ),
  });


}
