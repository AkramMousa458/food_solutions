import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/utils/app_colors.dart';

import 'package:food_solutions/core/utils/theme_utils.dart';

class HomeStatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const HomeStatItem({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.white
                    : AppColors.black.withValues(alpha: 0.87),
              ),
            ),
            SizedBox(width: 4.w),
            Icon(icon, color: primaryColor, size: 24.sp),
          ],
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.white.withValues(alpha: 0.8)
                : AppColors.grey,
          ),
        ),
      ],
    );
  }
}
