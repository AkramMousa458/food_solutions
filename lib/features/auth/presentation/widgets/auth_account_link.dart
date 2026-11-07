import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';

class AuthAccountLink extends StatelessWidget {
  final String promptKey;
  final String actionKey;
  final VoidCallback onActionTap;

  const AuthAccountLink({
    super.key,
    required this.promptKey,
    required this.actionKey,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final promptColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final actionColor = isDark ? AppColors.primarySoft : AppColors.primary;
    return Padding(
      padding: EdgeInsets.only(top: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              translate(promptKey),
              style: AppStyles.textstyle12.copyWith(
                color: promptColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: onActionTap,
            style: TextButton.styleFrom(
              foregroundColor: actionColor,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              translate(actionKey),
              style: AppStyles.textstyle12.copyWith(
                color: actionColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
