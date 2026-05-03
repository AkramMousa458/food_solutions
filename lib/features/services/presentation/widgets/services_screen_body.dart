import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:food_solutions/core/utils/app_styles.dart';

import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:shimmer/shimmer.dart';

import '../manager/services_cubit.dart';
import 'service_tile_card.dart';

class ServicesScreenBody extends StatelessWidget {
  const ServicesScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      builder: (context, state) {
        if (state is ServicesLoading) {
          return _buildShimmerLoading(context);
        } else if (state is ServicesError) {
          return Center(
            child: Text(
              translate('error_try_again'),
              style: AppStyles.textstyle15.copyWith(color: AppColors.error),
            ),
          );
        } else if (state is ServicesLoaded) {
          final services = state.services;
          if (services.isEmpty) {
            return const Center(child: Text('No services found'));
          }
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            itemCount: services.length,
            itemBuilder: (context, index) {
              return ServiceTileCard(service: services[index]);
            },
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

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
              child: Row(
                children: [
                  Container(
                    width: 56.sp,
                    height: 56.sp,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120.w,
                          height: 18.sp,
                          color: Colors.white,
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          width: double.infinity,
                          height: 13.sp,
                          color: Colors.white,
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          width: 200.w,
                          height: 13.sp,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
