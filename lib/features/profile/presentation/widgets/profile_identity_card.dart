import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_action_button.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_surface.dart';

class ProfileIdentityCard extends StatelessWidget {
  final ProfileSnapshot profile;
  final VoidCallback onEditProfile;

  const ProfileIdentityCard({
    super.key,
    required this.profile,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final titleColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final surfaceEnd = isDark ? AppColors.darkCard : AppColors.white;
    return ProfileSurface(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 16.h),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.secondary.withValues(alpha: isDark ? 0.22 : 0.16),
          surfaceEnd,
          surfaceEnd,
        ],
        stops: const [0, 0.42, 1],
      ),
      child: Column(
        children: [
          _ProfileAvatar(initials: profile.initials),
          SizedBox(height: 14.h),
          Text(
            profile.name,
            textAlign: TextAlign.center,
            style: AppStyles.textstyle22.copyWith(color: titleColor),
          ),
          if (profile.role.trim().isNotEmpty) ...[
            SizedBox(height: 10.h),
            _ProfilePill(
              label: resolveProfileRoleLabel(profile.role),
              icon: Icons.verified_user_outlined,
              foreground: isDark ? AppColors.secondary : AppColors.primaryDark,
              background: AppColors.secondary.withValues(alpha: 0.16),
            ),
          ],
          if (profile.phone.isNotEmpty) ...[
            SizedBox(height: 8.h),
            _ProfilePill(
              label: profile.phone,
              keepLabelDirection: true,
              trailing: profile.isPhoneVerified ? const _VerifiedMark() : null,
              foreground: titleColor,
              background: isDark
                  ? AppColors.darkInputFill
                  : AppColors.lightInputFill,
              borderColor: isDark
                  ? AppColors.white.withValues(alpha: 0.08)
                  : AppColors.lightBorder,
            ),
          ],
          if (profile.email.isNotEmpty) ...[
            SizedBox(height: 8.h),
            _ProfilePill(
              label: profile.email,
              keepLabelDirection: true,
              trailing: profile.isEmailVerified
                  ? const _VerifiedMark()
                  : Icon(
                      Icons.mail_outline_rounded,
                      size: 16.sp,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
              foreground: titleColor,
              background: isDark
                  ? AppColors.darkInputFill
                  : AppColors.lightInputFill,
              borderColor: isDark
                  ? AppColors.white.withValues(alpha: 0.08)
                  : AppColors.lightBorder,
            ),
          ],
          SizedBox(height: 16.h),
          ProfileActionButton(
            label: translate('profile_edit'),
            icon: Icons.tune_rounded,
            onPressed: onEditProfile,
          ),
        ],
      ),
    );
  }
}

String resolveProfileRoleLabel(String role) {
  final normalized = role.trim().toLowerCase();
  if (normalized == 'owner' || normalized == 'establishment_owner') {
    return translate('profile_role_owner');
  }
  if (normalized == 'partner' || normalized == 'founding_partner') {
    return translate('profile_role_partner');
  }
  if (normalized == 'manager' || normalized == 'restaurant_manager') {
    return translate('settings_user_role_manager');
  }
  if (normalized == 'admin') return translate('profile_role_admin');
  return role.trim();
}

class _ProfileAvatar extends StatelessWidget {
  final String initials;

  const _ProfileAvatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 108.w,
      height: 108.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 96.w,
            height: 96.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              border: Border.all(color: AppColors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: initials.isEmpty
                ? Icon(
                    Icons.person_rounded,
                    color: AppColors.white,
                    size: 42.sp,
                  )
                : Text(
                    initials,
                    style: AppStyles.textstyle22.copyWith(
                      color: AppColors.white,
                    ),
                  ),
          ),
          PositionedDirectional(
            bottom: 4.h,
            end: 4.w,
            child: Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 2),
              ),
              child: Icon(
                Icons.photo_camera_rounded,
                color: AppColors.white,
                size: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VerifiedMark extends StatelessWidget {
  const _VerifiedMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18.w,
      height: 18.w,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.check_rounded, color: AppColors.white, size: 12.sp),
    );
  }
}

class _ProfilePill extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Widget? trailing;
  final Color foreground;
  final Color background;
  final Color? borderColor;
  final bool keepLabelDirection;

  const _ProfilePill({
    required this.label,
    required this.foreground,
    required this.background,
    this.icon,
    this.trailing,
    this.borderColor,
    this.keepLabelDirection = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20.r),
        border: borderColor == null ? null : Border.all(color: borderColor!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15.sp, color: foreground),
            SizedBox(width: 6.w),
          ],
          Flexible(
            child: Text(
              label,
              textDirection: keepLabelDirection ? TextDirection.ltr : null,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.textstyle12.copyWith(
                color: foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (trailing != null) ...[SizedBox(width: 6.w), trailing!],
        ],
      ),
    );
  }
}
