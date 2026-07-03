import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/features/services/data/models/service_item_model.dart';

import 'package:go_router/go_router.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';

import 'package:flutter_animate/flutter_animate.dart';

import 'package:food_solutions/features/favorites/presentation/widgets/favorite_button.dart';
import 'package:food_solutions/features/reviews/presentation/widgets/reviews_section.dart';

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
                ServiceImageHeader(imageUrl: service.image!)
                    .animate()
                    .fade(duration: 500.ms)
                    .slideY(
                      begin: -0.05,
                      duration: 500.ms,
                      curve: Curves.easeOutQuad,
                    ),
                PositionedDirectional(
                  top: MediaQuery.of(context).padding.top,
                  start: 20.w,
                  end: 20.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
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
                                  color: AppColors.black.withValues(
                                    alpha: 0.12,
                                  ),
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
                      FavoriteButton(
                        serviceId: service.id,
                        size: 26,
                        showBackground: true,
                      ),
                    ],
                  )
                      .animate()
                      .fade(duration: 400.ms, delay: 200.ms)
                      .slideY(begin: -0.2, duration: 400.ms, curve: Curves.easeOut),
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
                SizedBox(height: 32.h),
                ReviewsSection(serviceId: service.id),
                SizedBox(height: 32.h),
                RequestServiceButton(service: service)
                    .animate()
                    .fade(duration: 500.ms, delay: 300.ms)
                    .scale(
                      begin: const Offset(0.95, 0.95),
                      curve: Curves.easeOutQuad,
                    ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
