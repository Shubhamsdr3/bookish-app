import 'package:bookish_module/uikit/bookish_color.dart';
import 'package:flutter/material.dart';

class LightBookishColor implements BookishColor {
  @override
  ThemeExtension<BookishColor> copyWith() {
    return LightBookishColor();
  }

  @override
  ThemeExtension<BookishColor> lerp(
      covariant ThemeExtension<BookishColor>? other, double t) {
    return LightBookishColor();
  }

  @override
  Object get type => BookishColor;

  @override
  Color get backgroundColor => Colors.white;

  @override
  Color get primaryText => Colors.black;

  @override
  Color get secondaryText => Colors.black.withOpacity(0.5);

  @override
  Color get tertiaryText => Colors.black.withOpacity(0.7);

  @override
  Color get errorColor => Colors.redAccent;

  @override
  Color get borderColor => Colors.grey;

  @override
  Color get successColor => Colors.green;

  @override
  Color get focusBorder => Colors.lightBlue;
}
