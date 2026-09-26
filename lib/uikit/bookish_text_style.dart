
import 'package:flutter/material.dart';

abstract class BookishTextStyle extends ThemeExtension<BookishTextStyle> {
  TextStyle headline1(Color? color);
  TextStyle title1(Color? color);
  TextStyle title2(Color? color);
  TextStyle title3(Color? color);
  TextStyle uiText1(Color? color);
  TextStyle uiText2(Color? color);
  TextStyle uiText3(Color? color);
  TextStyle body1(Color? color);
  TextStyle body2(Color? color);
  TextStyle body3(Color? color);
  TextStyle label1(Color? color);
  TextStyle label2(Color? color);
  TextStyle caption1(Color? color);
  TextStyle caption2(Color? color);
  TextStyle callout1(Color? color);

  //OKTO
  TextStyle heroNumber(Color? color);
  TextStyle formNumber(Color? color);
  TextStyle formNumber1(Color? color);
  TextStyle cardNumber(Color? color);
}