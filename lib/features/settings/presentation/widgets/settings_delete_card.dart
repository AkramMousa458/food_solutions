import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/features/settings/presentation/manager/settings_cubit.dart';
import 'package:food_solutions/features/settings/presentation/manager/settings_state.dart';

class SettingsDeleteCard extends StatelessWidget {
  const SettingsDeleteCard({super.key});

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: Icon(
            Icons.warning_amber_rounded,
            color: AppColors.error500,
            size: 28.sp,
          ),
          title: Text(translate('settings_delete_title')),
          content: Text(translate('settings_delete_confirm')),
          actions: [
            TextButton(
              key: const Key('settings-delete-cancel'),
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(translate('settings_cancel')),
            ),
            TextButton(
              key: const Key('settings-delete-confirm'),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                translate('settings_delete_action'),
                style: const TextStyle(color: AppColors.error500),
              ),
            ),
          ],
        );
      },
    );
    if (shouldDelete != true || !context.mounted) return;
    await context.read<SettingsCubit>().deleteAccount();
  }

  @override
  Widget build(BuildContext context) {
    final isDeleting = context.select((SettingsCubit cubit) {
      final current = cubit.state;
      return current is SettingsReady && current.isDeleting;
    });
    return Material(
      color: AppColors.error500.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        key: const Key('settings-delete'),
        onTap: isDeleting ? null : () => _confirmDelete(context),
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: AppColors.error500.withValues(alpha: 0.28),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isDeleting
                  ? SizedBox(
                      width: 26.sp,
                      height: 26.sp,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.error500,
                      ),
                    )
                  : Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.error500,
                      size: 26.sp,
                    ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translate('settings_delete_title'),
                      style: AppStyles.textstyle14Bold.copyWith(
                        color: AppColors.error500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      translate('settings_delete_message'),
                      style: AppStyles.textstyle12.copyWith(
                        color: AppColors.error500.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
