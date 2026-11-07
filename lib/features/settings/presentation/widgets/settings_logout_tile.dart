import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_surface.dart';
import 'package:food_solutions/features/settings/presentation/manager/settings_cubit.dart';

class SettingsLogoutTile extends StatelessWidget {
  const SettingsLogoutTile({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(translate('settings_logout')),
          content: Text(translate('settings_logout_confirm')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(translate('settings_cancel')),
            ),
            TextButton(
              key: const Key('settings-logout-confirm'),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                translate('settings_logout_action'),
                style: const TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
    if (shouldLogout != true || !context.mounted) return;
    await context.read<SettingsCubit>().logout();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final titleColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final subtitleColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    return ProfileSurface(
      key: const Key('settings-logout'),
      onTap: () => _confirmLogout(context),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.logout_rounded,
              color: AppColors.error,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate('settings_logout'),
                  style: AppStyles.textstyle14Bold.copyWith(color: titleColor),
                ),
                SizedBox(height: 2.h),
                Text(
                  translate('settings_logout_subtitle'),
                  style: AppStyles.textstyle12.copyWith(
                    color: subtitleColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
