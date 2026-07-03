import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import '../manager/reviews_cubit.dart';
import '../manager/reviews_state.dart';
import 'star_rating_widget.dart';

class ServiceRatingBadge extends StatelessWidget {
  final int serviceId;
  final bool compact;

  const ServiceRatingBadge({
    super.key,
    required this.serviceId,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewsCubit, ReviewsState>(
      builder: (context, state) {
        if (state is! ReviewsLoaded) return const SizedBox.shrink();

        final count = state.reviewCount(serviceId);
        if (count == 0) return const SizedBox.shrink();

        final avg = state.averageRating(serviceId);

        if (compact) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded, size: 14.sp, color: AppColors.secondary),
              SizedBox(width: 2.w),
              Text(
                avg.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
            ],
          );
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StarRatingWidget(rating: avg, size: 14),
            SizedBox(width: 6.w),
            Text(
              '($count)',
              style: TextStyle(fontSize: 12.sp, color: AppColors.grey),
            ),
          ],
        );
      },
    );
  }
}
