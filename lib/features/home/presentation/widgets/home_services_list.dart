import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/features/services/presentation/manager/services_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:food_solutions/features/services/presentation/screens/service_details_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/core/utils/app_colors.dart';

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

          return SizedBox(
            height: 100.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: services.length,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                final service = services[index];
                return SizedBox(
                  width: 130.w,
                  child: HomeServiceCard(
                    title: service.titleAr,
                    imageIcon: service.icon,
                    onTap: () {
                      context.push(
                        ServiceDetailsScreen.routeName,
                        extra: service,
                      );
                    },
                  ),
                );
              },
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

    return SizedBox(
      height: 100.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: 4,
        separatorBuilder: (_, __) => SizedBox(width: 14.w),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              width: 130.w,
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
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    Container(width: 70.w, height: 12.sp, color: Colors.white),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
