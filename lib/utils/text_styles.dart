import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  // Large
  static const TextStyle largeBold =
  TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary);

  static const TextStyle largeMedium =
  TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.textPrimary);

  // Medium
  static const TextStyle mediumBold =
  TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary);

  static const TextStyle mediumRegular =
  TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary);

  // Small
  static const TextStyle smallRegular =
  TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary);

  static const TextStyle smallHint =
  TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textHint);

  static const TextStyle smallError =
  TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.error);
}
