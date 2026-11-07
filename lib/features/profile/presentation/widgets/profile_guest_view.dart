import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';

class ProfileGuestView extends StatelessWidget {
  final VoidCallback onSignIn;

  const ProfileGuestView({super.key, required this.onSignIn});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final titleColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final subtitleColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline_rounded,
              color: AppColors.secondary,
              size: 42.sp,
            ),
            SizedBox(height: 12.h),
            Text(
              translate('guest_title'),
              textAlign: TextAlign.center,
              style: AppStyles.textstyle16.copyWith(color: titleColor),
            ),
            SizedBox(height: 8.h),
            Text(
              translate('guest_subtitle'),
              textAlign: TextAlign.center,
              style: AppStyles.textstyle12.copyWith(
                color: subtitleColor,
                fontWeight: FontWeight.w500,
                height: 1.45,
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                key: const Key('guest-sign-in'),
                onPressed: onSignIn,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(
                  translate('guest_sign_in'),
                  style: AppStyles.textstyle14Bold.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
