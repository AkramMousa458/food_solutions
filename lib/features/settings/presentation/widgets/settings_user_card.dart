import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_identity_card.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_surface.dart';

class SettingsUserCard extends StatelessWidget {
  final ProfileSnapshot profile;

  const SettingsUserCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final titleColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final subtitleColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final role = profile.role.trim();
    return ProfileSurface(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      child: Row(
        children: [
          _SettingsAvatar(initials: profile.initials),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        profile.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.textstyle16.copyWith(
                          color: titleColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (role.isNotEmpty) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          resolveProfileRoleLabel(role),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.textstyle10.copyWith(
                            color: isDark
                                ? AppColors.secondary
                                : AppColors.primaryDark,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (profile.email.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    profile.email,
                    textDirection: TextDirection.ltr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.textstyle12.copyWith(
                      color: subtitleColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsAvatar extends StatelessWidget {
  final String initials;

  const _SettingsAvatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56.w,
      height: 56.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              border: Border.all(color: AppColors.white, width: 2),
            ),
            child: initials.isEmpty
                ? Icon(
                    Icons.person_rounded,
                    color: AppColors.white,
                    size: 26.sp,
                  )
                : Text(
                    initials,
                    style: AppStyles.textstyle14Bold.copyWith(
                      color: AppColors.white,
                    ),
                  ),
          ),
          PositionedDirectional(
            bottom: 2.h,
            end: 0,
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: AppColors.success500,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
