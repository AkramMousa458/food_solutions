import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/services/data/models/service_item_model.dart';

import 'package:flutter_animate/flutter_animate.dart';

class ServiceInfoSection extends StatelessWidget {
  final ServiceItemModel service;

  const ServiceInfoSection({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final primaryColor = Theme.of(context).primaryColor;

    int animIndex = 0;

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
            )
            .animate()
            .fade(duration: 400.ms, delay: 100.ms)
            .slideY(begin: 0.1, duration: 400.ms, curve: Curves.easeOut),
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
            )
            .animate()
            .fade(duration: 400.ms, delay: 200.ms)
            .slideY(begin: 0.1, duration: 400.ms, curve: Curves.easeOut),
        if (service.points.isNotEmpty) ...[
          SizedBox(height: 30.h),
          ...service.points.map((point) {
            final widget =
                Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              size: 20.sp,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              point,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? AppColors.white
                                    : AppColors.black.withValues(alpha: 0.87),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fade(duration: 400.ms, delay: (300 + (animIndex * 100)).ms)
                    .slideX(
                      begin: 0.1,
                      duration: 400.ms,
                      curve: Curves.easeOut,
                    );
            animIndex++;
            return widget;
          }),
        ],
      ],
    );
  }
}
