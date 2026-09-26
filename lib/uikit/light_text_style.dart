import 'package:bookish_module/uikit/bookish_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LightTextStyle extends BookishTextStyle {
  @override
  ThemeExtension<BookishTextStyle> lerp(
      covariant ThemeExtension<BookishTextStyle>? other, double t) {
    return LightTextStyle();
  }

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
    return TextStyle(
      color: color ?? Colors.red,
      fontSize: 12.sp,
      height: 16 / 12,
      fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w500).fontFamily,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  @override
  TextStyle body3(Color? color) {
    return TextStyle(
      color: color ?? Colors.red,
      fontSize: 12.sp,
      height: 16 / 12,
      fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w400).fontFamily,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  @override
  TextStyle callout1(Color? color) {
    return TextStyle(
      color: color ?? Colors.red,
      fontSize: 10.sp,
      height: 16 / 10,
      fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w500).fontFamily,
      letterSpacing: 1.0,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  @override
  TextStyle caption1(Color? color) {
    return TextStyle(
      color: color ?? Colors.red,
      fontSize: 10.sp,
      height: 16 / 12,
      fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w600).fontFamily,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  @override
  TextStyle caption2(Color? color) {
    return TextStyle(
      color: color ?? Colors.red,
      fontSize: 10.sp,
      height: 16 / 12,
      fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w500).fontFamily,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  @override
  TextStyle cardNumber(Color? color) {
    return TextStyle(
      color: color ?? Colors.red,
      fontSize: 16.sp,
      height: 20 / 16,
      fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w600).fontFamily,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  @override
  ThemeExtension<BookishTextStyle> copyWith() {
    return LightTextStyle();
  }

  @override
  TextStyle formNumber(Color? color) {
    return TextStyle(
      color: color ?? Colors.red,
      fontSize: 20.sp,
      height: 20 / 20,
      fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w500).fontFamily,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  @override
  TextStyle formNumber1(Color? color) {
    return TextStyle(
      color: color ?? Colors.red,
      fontSize: 20.sp,
      height: 20 / 20,
      fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w600).fontFamily,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  @override
  TextStyle headline1(Color? color) {
    return TextStyle(
      color: color ?? Colors.red,
      fontSize: 24.sp,
      height: 36 / 24,
      fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w600).fontFamily,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  @override
  TextStyle heroNumber(Color? color) {
    return TextStyle(
      color: color ?? Colors.red,
      fontSize: 28.sp,
      height: 40 / 28,
      fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w500).fontFamily,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  @override
  TextStyle label1(Color? color) {
    return TextStyle(
      color: color ?? Colors.red,
      fontSize: 10.sp,
      height: 16 / 10,
      fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w500).fontFamily,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  @override
  TextStyle label2(Color? color) {
    return TextStyle(
      color: color ?? Colors.red,
      fontSize: 10.sp,
      height: 16 / 10,
      fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w400).fontFamily,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  @override
  TextStyle title1(Color? color) {
    return TextStyle(
      color: color ?? Colors.red,
      fontSize: 20.sp,
      height: 28 / 20,
      fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w600).fontFamily,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  @override
  TextStyle title2(Color? color) {
    return TextStyle(
      color: color ?? Colors.red,
      fontSize: 18.sp,
      height: 24 / 18,
      fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w500).fontFamily,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  @override
  TextStyle title3(Color? color) {
    return TextStyle(
      color: color ?? Colors.red,
      fontSize: 16.sp,
      height: 24 / 16,
      fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w600).fontFamily,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  @override
  TextStyle uiText1(Color? color) {
    return TextStyle(
      color: color ?? Colors.red,
      fontSize: 14.sp,
      height: 20 / 14,
      fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w600).fontFamily,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  @override
  TextStyle uiText2(Color? color) {
    return TextStyle(
      color: color ?? Colors.red,
      fontSize: 14.sp,
      height: 20 / 14,
      fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w500).fontFamily,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  @override
  TextStyle uiText3(Color? color) {
    return TextStyle(
      color: color ?? Colors.red,
      fontSize: 14.sp,
      height: 24 / 14,
      fontFamily: GoogleFonts.inter(fontWeight: FontWeight.w400).fontFamily,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }
}
