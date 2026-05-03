import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/features/services/data/models/service_item_model.dart';

import 'package:go_router/go_router.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';

import 'request_service_button.dart';
import 'service_image_header.dart';
import 'service_info_section.dart';

class ServiceDetailsBody extends StatelessWidget {
  final ServiceItemModel service;

  const ServiceDetailsBody({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (service.image != null)
            Stack(
              children: [
                ServiceImageHeader(imageUrl: service.image!),
                PositionedDirectional(
                  top: MediaQuery.of(context).padding.top,
                  // end: 20.w,
                  start: 20.w,
                  child: InkWell(
                    onTap: () => context.pop(),
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkCard.withValues(alpha: 0.9)
                            : AppColors.white.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          if (!isDark)
                            BoxShadow(
                              color: AppColors.black.withValues(alpha: 0.12),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: isDark ? AppColors.white : AppColors.black,
                        size: 22.sp,
                      ),
                    ),
                  ),
                ),
              ],
            )
          else ...[
            SizedBox(height: MediaQuery.of(context).padding.top + 10.h),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
          ],
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              children: [
                ServiceInfoSection(service: service),
                SizedBox(height: 65.h),
                RequestServiceButton(service: service),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
