import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/assets.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';

class LoginBrandHeader extends StatelessWidget {
  final String titleKey;
  final String subtitleKey;
  final double logoWidth;

  const LoginBrandHeader({
    super.key,
    this.titleKey = 'login_welcome_title',
    this.subtitleKey = 'login_welcome_subtitle',
    this.logoWidth = 148,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final titleColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final subtitleColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    return Column(
      children: [
        Container(
          padding: isDark ? EdgeInsets.all(12.w) : EdgeInsets.zero,
          decoration: BoxDecoration(
            color: isDark ? AppColors.white : AppColors.transparent,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Image.asset(
            Assets.logo,
            width: logoWidth.w,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 18.h),
        Text(
          translate(titleKey),
          textAlign: TextAlign.center,
          style: AppStyles.textstyle22.copyWith(color: titleColor),
        ),
        SizedBox(height: 6.h),
        Text(
          translate(subtitleKey),
          textAlign: TextAlign.center,
          style: AppStyles.textstyle14.copyWith(
            color: subtitleColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
