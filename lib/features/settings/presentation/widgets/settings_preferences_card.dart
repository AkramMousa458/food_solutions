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
import 'package:food_solutions/features/profile/presentation/widgets/profile_surface.dart';
import 'package:food_solutions/features/services/presentation/manager/services_cubit.dart';

class SettingsPreferencesCard extends StatelessWidget {
  const SettingsPreferencesCard({super.key});

  Future<void> _selectLanguage(
    BuildContext context,
    String languageCode,
  ) async {
    final cubit = context.read<LanguageCubit>();
    if (cubit.state.languageCode == languageCode) return;
    if (languageCode == 'ar') {
      await cubit.setArabic();
    } else {
      await cubit.setEnglish();
    }
    if (!context.mounted) return;
    await LocalizedApp.of(context).changeLocale(cubit.state);
    _refreshLocalizedContent();
  }

  void _refreshLocalizedContent() {
    if (locator.isRegistered<ServicesCubit>()) {
      locator<ServicesCubit>().fetchServices();
    }
    if (locator.isRegistered<ContactCubit>()) {
      locator<ContactCubit>().fetchContacts();
    }
    if (locator.isRegistered<StatisticsCubit>()) {
      locator<StatisticsCubit>().getStatistics();
    }
    if (locator.isRegistered<HomeSectionsCubit>()) {
      locator<HomeSectionsCubit>().getHomeSections();
    }
  }

  void _setAppearance(BuildContext context, bool isLight) {
    final cubit = context.read<ThemeCubit>();
    if (isLight) {
      cubit.setLightTheme();
      return;
    }
    cubit.setDarkTheme();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<LanguageCubit>().state.languageCode == 'ar';
    final isDark =
        context.watch<ThemeCubit>().state.brightness == Brightness.dark;
    return ProfileSurface(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      child: Column(
        children: [
          _PreferenceRow(
            icon: Icons.translate_rounded,
            title: translate('settings_app_language'),
            subtitle: translate('settings_app_language_subtitle'),
            trailing: _LanguageControl(
              isArabic: isArabic,
              onSelected: (code) => _selectLanguage(context, code),
            ),
          ),
          Divider(
            height: 8.h,
            color: isDark
                ? AppColors.white.withValues(alpha: 0.08)
                : AppColors.lightBorder,
          ),
          _PreferenceRow(
            icon: isDark ? Icons.dark_mode_rounded : Icons.wb_sunny_rounded,
            title: translate('settings_appearance'),
            subtitle: isDark
                ? translate('settings_appearance_dark')
                : translate('settings_appearance_light'),
            trailing: _DayModeSwitch(
              isLight: !isDark,
              onChanged: (isLight) => _setAppearance(context, isLight),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageControl extends StatelessWidget {
  final bool isArabic;
  final ValueChanged<String> onSelected;

  const _LanguageControl({required this.isArabic, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LanguageChip(
          key: const Key('settings-language-en'),
          label: translate('profile_language_english'),
          isSelected: !isArabic,
          onTap: () => onSelected('en'),
        ),
        SizedBox(width: 6.w),
        _LanguageChip(
          key: const Key('settings-language-ar'),
          label: translate('profile_language_arabic'),
          isSelected: isArabic,
          onTap: () => onSelected('ar'),
        ),
      ],
    );
  }
}

class _LanguageChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final background = isSelected
        ? (isDark ? AppColors.darkScaffold : AppColors.white)
        : (isDark ? AppColors.darkInputFill : AppColors.lightScaffold);
    final foreground = isSelected
        ? AppColors.primary
        : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.35)
                  : AppColors.transparent,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected) ...[
                Icon(
                  Icons.check_rounded,
                  color: AppColors.primary,
                  size: 14.sp,
                ),
                SizedBox(width: 4.w),
              ],
              Text(
                label,
                style: AppStyles.textstyle12.copyWith(
                  color: foreground,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayModeSwitch extends StatelessWidget {
  final bool isLight;
  final ValueChanged<bool> onChanged;

  const _DayModeSwitch({required this.isLight, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Switch(
      key: const Key('settings-appearance-switch'),
      value: isLight,
      thumbIcon: WidgetStateProperty.resolveWith((states) {
        final icon = states.contains(WidgetState.selected)
            ? Icons.wb_sunny_rounded
            : Icons.dark_mode_rounded;
        return Icon(icon, size: 14);
      }),
      thumbColor: WidgetStateProperty.all(AppColors.white),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.lightBorder;
        return AppColors.darkInputFill;
      }),
      trackOutlineColor: WidgetStateProperty.all(AppColors.transparent),
      onChanged: onChanged,
    );
  }
}

class _PreferenceRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _PreferenceRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          _IconBadge(icon: icon),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.textstyle14Bold.copyWith(color: titleColor),
                ),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.textstyle12.copyWith(
                    color: subtitleColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          trailing,
        ],
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;

  const _IconBadge({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(icon, color: AppColors.secondary, size: 20.sp),
    );
  }
}
