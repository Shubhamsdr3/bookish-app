import 'package:bookish/uikit/bookish_color.dart';
import 'package:flutter/material.dart';

class DarkBookishColor implements BookishColor {
  @override
  ThemeExtension<BookishColor> copyWith() {
    return DarkBookishColor();
  }

  @override
  ThemeExtension<BookishColor> lerp(covariant ThemeExtension<BookishColor>? other, double t) {
    return DarkBookishColor();
  }

  @override
  Object get type => BookishColor;

  @override
  Color get backgroundColor => Colors.black;

  @override
  Color get errorColor => Colors.redAccent;

  @override
  Color get primaryText => Colors.white;

  @override
  Color get secondaryText => Colors.white.withOpacity(0.5);

  @override
  Color get tertiaryText => Colors.white.withOpacity(0.7);

  @override
  Color get borderColor => Colors.grey;

  @override
  Color get successColor => Colors.green;

  @override
  Color get focusBorder => Colors.blue;

}