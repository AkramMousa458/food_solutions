import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';

class EstablishmentPrivacyNote extends StatelessWidget {
  const EstablishmentPrivacyNote({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final textColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.establishmentPrivacyFill,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              translate('establishment_privacy_note'),
              style: AppStyles.textstyle12.copyWith(
                color: textColor,
                fontWeight: FontWeight.w500,
                height: 1.45,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Icon(
            Icons.verified_user_outlined,
            color: isDark ? AppColors.primarySoft : AppColors.primary,
            size: 28.sp,
          ),
        ],
      ),
    );
  }
}
