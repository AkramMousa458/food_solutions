import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/language/language_cubit.dart';
import 'package:food_solutions/core/theme/theme_cubit.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/service_locator.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/contact/presentation/manager/contact_cubit.dart';
import 'package:food_solutions/features/home/presentation/manager/home_sections_cubit.dart';
import 'package:food_solutions/features/home/presentation/manager/statistics_cubit.dart';
import 'package:food_solutions/features/services/presentation/manager/services_cubit.dart';

Future<void> openProfileSettings(BuildContext context) {
  final isDark = ThemeUtils.isDark(context);
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: isDark ? AppColors.darkCard : AppColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
    ),
    builder: (context) => const ProfileSettingsSheet(),
  );
}

class ProfileSettingsSheet extends StatelessWidget {
  const ProfileSettingsSheet({super.key});

  Future<void> _toggleLanguage(BuildContext context) async {
    final cubit = context.read<LanguageCubit>();
    await cubit.toggleLanguage();
    if (!context.mounted) return;
    await LocalizedApp.of(context).changeLocale(cubit.state);
    locator<ServicesCubit>().fetchServices();
    locator<ContactCubit>().fetchContacts();
    locator<StatisticsCubit>().getStatistics();
    locator<HomeSectionsCubit>().getHomeSections();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<LanguageCubit>().state.languageCode == 'ar';
    final isDark =
        context.watch<ThemeCubit>().state.brightness == Brightness.dark;
    final titleColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 42.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkInputFill
                      : AppColors.lightBorder,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              translate('profile_account_settings'),
              style: AppStyles.textstyle18.copyWith(
                color: titleColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              translate('profile_account_settings_subtitle'),
              style: AppStyles.textstyle12.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16.h),
            _SettingsRow(
              icon: Icons.language_rounded,
              title: translate('language'),
              value: isArabic
                  ? translate('profile_language_arabic')
                  : translate('profile_language_english'),
              onTap: () => _toggleLanguage(context),
            ),
            SizedBox(height: 10.h),
            _SettingsRow(
              icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              title: translate('profile_settings_appearance'),
              value: isDark
                  ? translate('profile_settings_dark')
                  : translate('profile_settings_light'),
              onTap: () => context.read<ThemeCubit>().toggleTheme(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final titleColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final subtitleColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    return Material(
      color: isDark ? AppColors.darkScaffold : AppColors.lightInputFill,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: AppColors.secondary, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppStyles.textstyle14Bold.copyWith(
                        color: titleColor,
                      ),
                    ),
                    Text(
                      value,
                      style: AppStyles.textstyle12.copyWith(
                        color: subtitleColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: subtitleColor),
            ],
          ),
        ),
      ),
    );
  }
}
