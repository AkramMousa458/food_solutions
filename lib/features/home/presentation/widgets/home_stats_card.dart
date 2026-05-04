import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/home/presentation/manager/statistics_cubit.dart';
import 'package:food_solutions/features/home/presentation/manager/statistics_state.dart';

import 'package:flutter_animate/flutter_animate.dart';

import 'home_stat_item.dart';

class HomeStatsCard extends StatelessWidget {
  const HomeStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return BlocBuilder<StatisticsCubit, StatisticsState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.white,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: switch (state) {
            StatisticsSuccess() => Row(
              children: [
                Expanded(
                  child:
                      HomeStatItem(
                            icon: Icons.calendar_month,
                            value: '+${state.statistics.yearsOfExperience}',
                            label: 'سنوات خبرة',
                          )
                          .animate()
                          .fade(duration: 400.ms)
                          .scale(begin: const Offset(0.8, 0.8)),
                ),
                _buildDivider(isDark),
                Expanded(
                  child:
                      HomeStatItem(
                            icon: Icons.handshake_outlined,
                            value: '+${state.statistics.clientsCount}',
                            label: 'عميل راضي',
                          )
                          .animate()
                          .fade(duration: 400.ms, delay: 100.ms)
                          .scale(begin: const Offset(0.8, 0.8)),
                ),
                _buildDivider(isDark),
                Expanded(
                  child:
                      HomeStatItem(
                            icon: Icons.business,
                            value: '+${state.statistics.projectsCount}',
                            label: 'مشروع مكتمل',
                          )
                          .animate()
                          .fade(duration: 400.ms, delay: 200.ms)
                          .scale(begin: const Offset(0.8, 0.8)),
                ),
              ],
            ),
            StatisticsLoading() => Row(
              children: [
                Expanded(child: _buildShimmerItem(isDark)),
                _buildDivider(isDark),
                Expanded(child: _buildShimmerItem(isDark)),
                _buildDivider(isDark),
                Expanded(child: _buildShimmerItem(isDark)),
              ],
            ),
            _ => const Row(
              children: [
                Expanded(
                  child: HomeStatItem(
                    icon: Icons.calendar_month,
                    value: '+10',
                    label: 'سنوات خبرة',
                  ),
                ),
              ],
            ),
          },
        );
      },
    );
  }

  Widget _buildShimmerItem(bool isDark) {
    final shimmerColor = isDark
        ? AppColors.white.withValues(alpha: 0.08)
        : AppColors.grey.withValues(alpha: 0.15);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 16.h,
          width: 50.w,
          decoration: BoxDecoration(
            color: shimmerColor,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          height: 10.h,
          width: 40.w,
          decoration: BoxDecoration(
            color: shimmerColor,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      height: 40.h,
      width: 1,
      color: isDark
          ? AppColors.white.withValues(alpha: 0.24)
          : AppColors.grey.withValues(alpha: 0.3),
    );
  }
}
