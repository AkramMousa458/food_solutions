import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/language/language_cubit.dart';
import 'package:food_solutions/core/utils/service_locator.dart';
import 'package:food_solutions/features/contact/presentation/manager/contact_cubit.dart';
import 'package:food_solutions/features/home/presentation/manager/home_sections_cubit.dart';
import 'package:food_solutions/features/home/presentation/manager/statistics_cubit.dart';
import 'package:food_solutions/features/services/presentation/manager/services_cubit.dart';

/// A reusable language toggle button widget
class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  Future<void> _onLanguageToggled(BuildContext context) async {
    final cubit = context.read<LanguageCubit>();
    await cubit.toggleLanguage();

    if (!context.mounted) return;

    await LocalizedApp.of(context).changeLocale(cubit.state);
    _refetchLocalizedContent();
  }

  void _refetchLocalizedContent() {
    locator<ServicesCubit>().fetchServices();
    locator<ContactCubit>().fetchContacts();
    locator<StatisticsCubit>().getStatistics();
    locator<HomeSectionsCubit>().getHomeSections();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, Locale>(
      builder: (context, locale) {
        final isArabic = locale.languageCode == 'ar';

        return InkWell(
          onTap: () => _onLanguageToggled(context),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.language,
                  size: 20.w,
                  color: Theme.of(context).appBarTheme.foregroundColor,
                ),
                SizedBox(width: 4.w),
                Text(
                  isArabic ? '🇪🇬' : '🇺🇸',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).appBarTheme.foregroundColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
