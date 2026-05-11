import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/features/services/presentation/manager/services_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:food_solutions/features/services/presentation/screens/service_details_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/core/utils/app_colors.dart';

import 'package:flutter_animate/flutter_animate.dart';

import 'home_service_card.dart';

class HomeServicesList extends StatelessWidget {
  const HomeServicesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      builder: (context, state) {
        if (state is ServicesLoading) {
          return _buildShimmerLoading(context);
        } else if (state is ServicesError) {
          return const SizedBox();
        } else if (state is ServicesLoaded) {
          final services = state.services;
          if (services.isEmpty) return const SizedBox();

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final entry in services.asMap().entries) ...[
                    if (entry.key > 0) SizedBox(width: 12.w),
                    SizedBox(
                      width: 150.w,
                      child:
                          HomeServiceCard(
                                title: entry.value.titleAr,
                                imageIcon: entry.value.icon,
                                onTap: () {
                                  context.push(
                                    ServiceDetailsScreen.routeName,
                                    extra: entry.value,
                                  );
                                },
                              )
                              .animate()
                              .fade(
                                duration: 400.ms,
                                delay: (entry.key * 50).ms,
                              )
                              .slideX(
                                begin: 0.1,
                                duration: 400.ms,
                                curve: Curves.easeOut,
                              ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildShimmerLoading(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final baseColor = isDark ? AppColors.darkCard : Colors.grey[300]!;
    final highlightColor = isDark ? AppColors.darkInputFill : Colors.grey[100]!;
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int index = 0; index < 4; index++) ...[
              if (index > 0) SizedBox(width: 14.w),
              Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Container(
                  width: 150.w,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [
                      if (!isDark)
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 10.h,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 36.sp,
                          height: 36.sp,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          width: 70.w,
                          height: 10.sp,
                          color: Colors.white,
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          width: 90.w,
                          height: 10.sp,
                          color: Colors.white,
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          width: 60.w,
                          height: 10.sp,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
