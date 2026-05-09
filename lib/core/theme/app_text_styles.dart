import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_ui_tokens.dart';

class AppTextStyles {
  static const String fontFamily = AppUiTokens.fontFamily;
  static const String accentFontFamily = AppUiTokens.accentFontFamily;

  static TextStyle regular(
    double fontSize, {
    Color color = AppColors.textPrimary,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle semiBold(
    double fontSize, {
    Color color = AppColors.textPrimary,
  }) {
    return regular(fontSize, color: color, fontWeight: FontWeight.w600);
  }

  static TextStyle bold(
    double fontSize, {
    Color color = AppColors.textPrimary,
  }) {
    return regular(fontSize, color: color, fontWeight: FontWeight.w700);
  }

  static TextStyle extraBold(
    double fontSize, {
    Color color = AppColors.textPrimary,
  }) {
    return regular(fontSize, color: color, fontWeight: FontWeight.w800);
  }

  static TextStyle button(
    double fontSize, {
    Color color = AppColors.white,
  }) {
    return regular(fontSize, color: color, fontWeight: FontWeight.w700);
  }
}
