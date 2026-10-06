import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/auth/presentation/screens/login_screen.dart';
import 'package:go_router/go_router.dart';

class AuthBackButton extends StatelessWidget {
  const AuthBackButton({super.key});

  void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final color = isDark ? AppColors.primarySoft : AppColors.primary;
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Material(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: () => _goBack(context),
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back, size: 18.sp, color: color),
                // SizedBox(width: 4.w),
                // Text(
                //   translate('auth_back'),
                //   style: AppStyles.textstyle12.copyWith(
                //     color: color,
                //     fontWeight: FontWeight.w700,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
