import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_string.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';

class ProfileFooter extends StatelessWidget {
  const ProfileFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final color = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final style = AppStyles.textstyle12.copyWith(
      color: color,
      fontWeight: FontWeight.w500,
      height: 1.5,
    );
    final version = translate('profile_footer_version')
        .replaceAll('{version}', AppString.appVersion)
        .replaceAll('{build}', AppString.appBuildNumber);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  '${translate('profile_footer_brand')} • ${translate('profile_footer_tagline')}',
                  textAlign: TextAlign.center,
                  style: style.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(width: 6.w),
              Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(
                  color: AppColors.success500,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            '$version • ${translate('profile_footer_secure')}',
            textAlign: TextAlign.center,
            style: style,
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🇸🇦'),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  translate('profile_footer_license'),
                  textAlign: TextAlign.center,
                  style: style,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
