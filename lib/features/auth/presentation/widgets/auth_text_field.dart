import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';

class AuthTextField extends StatelessWidget {
  final String labelKey;
  final String hintKey;
  final IconData icon;
  final TextInputType keyboardType;

  const AuthTextField({
    super.key,
    required this.labelKey,
    required this.hintKey,
    required this.icon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final hintColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final accent = isDark ? AppColors.primarySoft : AppColors.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          translate(labelKey),
          style: AppStyles.textstyle14.copyWith(
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          keyboardType: keyboardType,
          style: AppStyles.textstyle14.copyWith(
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: translate(hintKey),
            hintStyle: AppStyles.textstyle14.copyWith(
              color: hintColor,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(icon, color: accent, size: 20.sp),
            filled: true,
            fillColor: isDark
                ? AppColors.darkInputFill
                : AppColors.lightInputFill,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 16.h,
            ),
          ),
        ),
      ],
    );
  }
}
