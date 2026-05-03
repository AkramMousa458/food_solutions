import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/services/data/models/service_item_model.dart';

class ServiceInfoSection extends StatelessWidget {
  final ServiceItemModel service;

  const ServiceInfoSection({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      children: [
        Text(
          service.titleAr,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.white : const Color(0xFF0D1B2A),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          service.longDescriptionAr,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.sp,
            height: 1.6,
            fontWeight: FontWeight.w500,
            color: isDark
                ? AppColors.darkTextSecondary.withValues(alpha: 0.8)
                : AppColors.grey.withValues(alpha: 0.7),
          ),
        ),
        if (service.points.isNotEmpty) ...[
          SizedBox(height: 30.h),
          ...service.points.map((point) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, size: 20.sp, color: primaryColor),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    point,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.white
                          : AppColors.black.withValues(alpha: 0.87),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }
}
