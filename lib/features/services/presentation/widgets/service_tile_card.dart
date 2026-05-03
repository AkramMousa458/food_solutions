import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/utils/app_colors.dart';

import 'package:food_solutions/core/utils/theme_utils.dart';
import '../../data/models/service_item_model.dart';

import 'package:go_router/go_router.dart';
import '../screens/service_details_screen.dart';

class ServiceTileCard extends StatelessWidget {
  final ServiceItemModel service;
  final VoidCallback? onTap;

  const ServiceTileCard({super.key, required this.service, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: isDark
            ? Border.all(color: AppColors.white.withValues(alpha: 0.12))
            : Border.all(color: AppColors.grey.withValues(alpha: 0.2)),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: () {
            if (onTap != null) {
              onTap!();
            } else {
              context.push(ServiceDetailsScreen.routeName, extra: service);
            }
          },
          borderRadius: BorderRadius.circular(15.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            child: Row(
              children: [
                // Icon Container
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.room_service_outlined,
                    color: primaryColor,
                    size: 32.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                // Texts
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.titleAr,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.white
                              : AppColors.black.withValues(alpha: 0.87),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        service.shortDescriptionAr,
                        style: TextStyle(
                          fontSize: 13.sp,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.darkTextSecondary.withValues(
                                  alpha: 0.8,
                                )
                              : AppColors.grey.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
