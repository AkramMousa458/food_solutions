import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/features/profile/data/models/create_establishment_request.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';

class ProfileEstablishmentStatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const ProfileEstablishmentStatusChip({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.textstyle10.copyWith(
                color: AppColors.white,
                fontSize: 11.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

({String label, Color color})? profileEstablishmentStatus(
  ProfileEstablishmentSnapshot? establishment,
) {
  if (establishment == null) return null;
  final status = establishment.status?.trim().toLowerCase() ?? '';
  if (status.isEmpty) {
    if (!establishment.isActive) return null;
    return _statusStyle(CreateEstablishmentRequest.existingStatus);
  }
  return _statusStyle(status);
}

({String label, Color color}) _statusStyle(String status) {
  switch (status) {
    case CreateEstablishmentRequest.underConstructionStatus:
      return (
        label: translate('establishment_status_under_construction'),
        color: AppColors.warning500,
      );
    case CreateEstablishmentRequest.ideaStatus:
      return (
        label: translate('establishment_status_idea'),
        color: AppColors.secondary,
      );
    case 'closed':
    case 'inactive':
    case 'suspended':
      return (
        label: translate('establishment_status_closed'),
        color: AppColors.grey,
      );
    case CreateEstablishmentRequest.existingStatus:
    case 'active':
    case 'operating':
      return (
        label: translate('establishment_status_existing'),
        color: AppColors.primary,
      );
    default:
      return (label: status, color: AppColors.grey);
  }
}
