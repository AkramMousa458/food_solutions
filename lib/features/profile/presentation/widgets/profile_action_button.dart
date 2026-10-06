import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';

class ProfileActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isFilled;

  const ProfileActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isFilled = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final titleColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final fillColor = isDark ? AppColors.darkInputFill : AppColors.lightBorder;
    final radius = BorderRadius.circular(16.r);
    return Material(
      color: isFilled
          ? fillColor
          : (isDark ? AppColors.darkCard : AppColors.white),
      borderRadius: radius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: radius,
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 52.h),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: isFilled
                ? null
                : Border.all(
                    color: isDark
                        ? AppColors.darkInputFill
                        : AppColors.lightBorder,
                  ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: titleColor, size: 18.sp),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.textstyle14Bold.copyWith(color: titleColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
