import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';

Future<void> openProfileBranches({
  required BuildContext context,
  required List<ProfileEstablishmentSnapshot> establishments,
  required int selectedIndex,
  required ValueChanged<int> onSelected,
}) {
  final isDark = ThemeUtils.isDark(context);
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: isDark ? AppColors.darkCard : AppColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
    ),
    builder: (context) {
      return ProfileBranchSheet(
        establishments: establishments,
        selectedIndex: selectedIndex,
        onSelected: (index) {
          onSelected(index);
          Navigator.of(context).pop();
        },
      );
    },
  );
}

class ProfileBranchSheet extends StatelessWidget {
  final List<ProfileEstablishmentSnapshot> establishments;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const ProfileBranchSheet({
    super.key,
    required this.establishments,
    required this.selectedIndex,
    required this.onSelected,
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
              translate('profile_switch_branch'),
              style: AppStyles.textstyle16.copyWith(
                color: titleColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 14.h),
            if (establishments.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Text(
                  translate('profile_no_establishment'),
                  textAlign: TextAlign.center,
                  style: AppStyles.textstyle14.copyWith(color: subtitleColor),
                ),
              )
            else
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 320.h),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: establishments.length,
                  separatorBuilder: (_, _) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    final establishment = establishments[index];
                    final isSelected = index == selectedIndex;
                    return Material(
                      color: isDark
                          ? AppColors.darkScaffold
                          : AppColors.lightInputFill,
                      borderRadius: BorderRadius.circular(16.r),
                      child: InkWell(
                        onTap: () => onSelected(index),
                        borderRadius: BorderRadius.circular(16.r),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 12.h,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.storefront_rounded,
                                color: AppColors.secondary,
                                size: 22.sp,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  establishment.name,
                                  style: AppStyles.textstyle14Bold.copyWith(
                                    color: titleColor,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.primary,
                                  size: 20.sp,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
