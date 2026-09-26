import 'package:flutter/material.dart';

abstract class BookishColor extends ThemeExtension<BookishColor> {
  Color get primaryText;
  Color get secondaryText;
  Color get tertiaryText;
  Color get backgroundColor;
  Color get errorColor;
  Color get borderColor;
  Color get successColor;
  Color get focusBorder;
}