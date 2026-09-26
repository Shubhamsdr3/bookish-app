import 'package:bookish_module/uikit/bookish_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DarkTextStyle extends BookishTextStyle {
  @override
  TextStyle body1(Color? color) {
    return TextStyle(
      color: color ?? Colors.red,
      fontSize: 12.sp,
      height: 20 / 12,
      fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w600).fontFamily,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  @override
  TextStyle body2(Color? color) {
    // TODO: implement body2
    throw UnimplementedError();
  }

  @override
  TextStyle body3(Color? color) {
    // TODO: implement body3
    throw UnimplementedError();
  }

  @override
  TextStyle callout1(Color? color) {
    // TODO: implement callout1
    throw UnimplementedError();
  }

  @override
  TextStyle caption1(Color? color) {
    // TODO: implement caption1
    throw UnimplementedError();
  }

  @override
  TextStyle caption2(Color? color) {
    // TODO: implement caption2
    throw UnimplementedError();
  }

  @override
  TextStyle cardNumber(Color? color) {
    // TODO: implement cardNumber
    throw UnimplementedError();
  }

  @override
  ThemeExtension<BookishTextStyle> copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  TextStyle formNumber(Color? color) {
    // TODO: implement formNumber
    throw UnimplementedError();
  }

  @override
  TextStyle formNumber1(Color? color) {
    // TODO: implement formNumber1
    throw UnimplementedError();
  }

  @override
  TextStyle headline1(Color? color) {
    // TODO: implement headline1
    throw UnimplementedError();
  }

  @override
  TextStyle heroNumber(Color? color) {
    // TODO: implement heroNumber
    throw UnimplementedError();
  }

  @override
  TextStyle label1(Color? color) {
    // TODO: implement label1
    throw UnimplementedError();
  }

  @override
  TextStyle label2(Color? color) {
    // TODO: implement label2
    throw UnimplementedError();
  }

  @override
  ThemeExtension<BookishTextStyle> lerp(
      covariant ThemeExtension<BookishTextStyle>? other, double t) {
    // TODO: implement lerp
    throw UnimplementedError();
  }

  @override
  TextStyle title1(Color? color) {
    // TODO: implement title1
    throw UnimplementedError();
  }

  @override
  TextStyle title2(Color? color) {
    // TODO: implement title2
    throw UnimplementedError();
  }

  @override
  TextStyle title3(Color? color) {
    // TODO: implement title3
    throw UnimplementedError();
  }

  @override
  TextStyle uiText1(Color? color) {
    // TODO: implement uiText1
    throw UnimplementedError();
  }

  @override
  TextStyle uiText2(Color? color) {
    // TODO: implement uiText2
    throw UnimplementedError();
  }

  @override
  TextStyle uiText3(Color? color) {
    // TODO: implement uiText3
    throw UnimplementedError();
  }
}
