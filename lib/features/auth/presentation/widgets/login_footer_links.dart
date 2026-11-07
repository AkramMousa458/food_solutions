import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';

class LoginFooterLinks extends StatelessWidget {
  const LoginFooterLinks({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final color = isDark ? AppColors.primarySoft : AppColors.primary;
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        _LoginFooterLink(
          icon: Icons.headset_mic_outlined,
          labelKey: 'login_support',
          color: color,
        ),
        Container(
          width: 4.w,
          height: 4.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        _LoginFooterLink(
          icon: Icons.menu_book_outlined,
          labelKey: 'login_guide',
          color: color,
        ),
      ],
    );
  }
}

class _LoginFooterLink extends StatelessWidget {
  final IconData icon;
  final String labelKey;
  final Color color;

  const _LoginFooterLink({
    required this.icon,
    required this.labelKey,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.sp, color: color),
            SizedBox(width: 6.w),
            Flexible(
              child: Text(
                translate(labelKey),
                style: AppStyles.textstyle12.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
