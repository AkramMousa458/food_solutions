import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';

class EstablishmentFieldStyle {
  static Color accent(bool isDark) {
    return isDark ? AppColors.secondary : AppColors.establishmentAccent;
  }

  static Color text(bool isDark) {
    return isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
  }

  static Color hint(bool isDark) {
    return isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
  }

  static Color fill(bool isDark) {
    return isDark ? AppColors.darkInputFill : AppColors.white;
  }

  static Color border(bool isDark) {
    if (isDark) return AppColors.white.withValues(alpha: 0.08);
    return AppColors.establishmentFieldBorder;
  }

  static Color mutedFill(bool isDark) {
    if (isDark) return AppColors.white.withValues(alpha: 0.06);
    return AppColors.establishmentMutedFill;
  }

  static BoxDecoration box(
    bool isDark, {
    Color? fillColor,
    Color? borderColor,
  }) {
    return BoxDecoration(
      color: fillColor ?? fill(isDark),
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: borderColor ?? border(isDark)),
    );
  }

  static InputDecoration decoration({
    required bool isDark,
    required String hintText,
    required IconData icon,
  }) {
    final idle = border(isDark);
    final accentColor = accent(isDark);
    final radius = BorderRadius.circular(16.r);
    OutlineInputBorder outline(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecoration(
      hintText: hintText,
      hintStyle: AppStyles.textstyle14.copyWith(
        color: hint(isDark),
        fontWeight: FontWeight.w400,
      ),
      prefixIcon: Icon(icon, color: accentColor, size: 20.sp),
      filled: true,
      fillColor: fill(isDark),
      isDense: true,
      errorMaxLines: 2,
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
      border: outline(idle),
      enabledBorder: outline(idle),
      disabledBorder: outline(idle),
      focusedBorder: outline(accentColor, 1.4),
      errorBorder: outline(AppColors.error),
      focusedErrorBorder: outline(AppColors.error, 1.4),
    );
  }
}
