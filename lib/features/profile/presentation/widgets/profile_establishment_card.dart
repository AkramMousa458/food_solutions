import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/media_url.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_identity_card.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_action_button.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_establishment_actions.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_establishment_status_chip.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_location_button.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_surface.dart';

class ProfileEstablishmentCard extends StatelessWidget {
  final ProfileEstablishmentSnapshot? establishment;
  final VoidCallback onSwitchBranch;
  final VoidCallback? onOpenLocation;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isBusy;

  const ProfileEstablishmentCard({
    super.key,
    required this.establishment,
    required this.onSwitchBranch,
    this.onOpenLocation,
    this.onEdit,
    this.onDelete,
    this.isBusy = false,
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
    final currentEstablishment = establishment;
    final name =
        currentEstablishment?.name ?? translate('profile_no_establishment');
    final status = profileEstablishmentStatus(currentEstablishment);
    final middle = profileEstablishmentMiddle(currentEstablishment);
    final openLocation = onOpenLocation;
    return ProfileSurface(
      padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 14.h),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  translate('profile_current_establishment'),
                  style: AppStyles.textstyle12.copyWith(
                    color: subtitleColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              if (status != null) ...[
                SizedBox(width: 8.w),
                ProfileEstablishmentStatusChip(
                  label: status.label,
                  color: status.color,
                ),
              ],
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _StoreBadge(imageUrl: currentEstablishment?.imageUrl),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.textstyle16.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ProfileEstablishmentActions(
                onEdit: onEdit,
                onDelete: onDelete,
                isEnabled: !isBusy,
              ),
            ],
          ),
          SizedBox(height: 14.h),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _ProfileStatTile(
                    label: translate('profile_headquarters'),
                    value: profileValueOrFallback(establishment?.headquarters),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _ProfileStatTile(
                    label: middle.label,
                    value: middle.value,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _ProfileStatTile(
                    label: translate('profile_establishment_age'),
                    value: formatEstablishmentAge(establishment),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          if (openLocation != null) ...[
            ProfileLocationButton(onPressed: openLocation),
            SizedBox(height: 10.h),
          ],
          ProfileActionButton(
            label: translate('profile_switch_branch'),
            icon: Icons.storefront_outlined,
            isFilled: true,
            onPressed: onSwitchBranch,
          ),
        ],
      ),
    );
  }
}

String profileValueOrFallback(String? value) {
  final trimmed = value?.trim() ?? '';
  if (trimmed.isEmpty) return translate('profile_value_unavailable');
  return trimmed;
}

({String label, String value}) profileEstablishmentMiddle(
  ProfileEstablishmentSnapshot? establishment,
) {
  final activity = establishment?.activity?.trim() ?? '';
  if (activity.isNotEmpty) {
    return (label: translate('profile_business_activity'), value: activity);
  }
  final position = establishment?.userPosition?.trim() ?? '';
  if (position.isNotEmpty) {
    return (
      label: translate('profile_user_position'),
      value: resolveProfileRoleLabel(position),
    );
  }
  return (
    label: translate('profile_business_activity'),
    value: translate('profile_value_unavailable'),
  );
}

String formatEstablishmentAge(ProfileEstablishmentSnapshot? establishment) {
  final label = establishment?.ageLabel?.trim() ?? '';
  if (label.isNotEmpty) return label;
  return formatProfileAge(establishment?.ageInMonths);
}

String formatProfileAge(int? months) {
  if (months == null) return translate('profile_value_unavailable');
  final years = months ~/ 12;
  if (years < 1) {
    return translate('profile_age_months').replaceAll('{count}', '$months');
  }
  return translate(
    'profile_age_years',
  ).replaceAll('{years}', '$years').replaceAll('{months}', '$months');
}

class _StoreBadge extends StatelessWidget {
  final String? imageUrl;

  const _StoreBadge({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim() ?? '';
    return Container(
      width: 48.w,
      height: 48.w,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: url.isEmpty
          ? const _StoreIcon()
          : CachedNetworkImage(
              imageUrl: resolveMediaUrl(url),
              fit: BoxFit.cover,
              errorWidget: (_, _, _) => const _StoreIcon(),
            ),
    );
  }
}

class _StoreIcon extends StatelessWidget {
  const _StoreIcon();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.storefront_rounded,
      color: AppColors.secondary,
      size: 26.sp,
    );
  }
}

class _ProfileStatTile extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileStatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final titleColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final subtitleColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkScaffold : AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? AppColors.white.withValues(alpha: 0.08)
              : AppColors.lightBorder,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.textstyle10.copyWith(
              color: subtitleColor,
              fontWeight: FontWeight.w600,
              fontSize: 11.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.textstyle12.copyWith(
              color: titleColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
