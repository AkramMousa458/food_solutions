import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/auth/presentation/widgets/auth_back_button.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final titleColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    return Row(
      children: [
        AuthBackButton(),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            children: [
              Text(
                translate('profile_account_settings'),
                textAlign: TextAlign.center,
                style: AppStyles.textstyle18.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 32.w),
      ],
    );
  }
}
