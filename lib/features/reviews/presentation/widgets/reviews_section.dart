import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import '../manager/reviews_cubit.dart';
import '../manager/reviews_state.dart';
import 'add_review_sheet.dart';
import 'review_card.dart';
import 'star_rating_widget.dart';

class ReviewsSection extends StatelessWidget {
  final int serviceId;

  const ReviewsSection({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final primaryColor = Theme.of(context).primaryColor;

    return BlocBuilder<ReviewsCubit, ReviewsState>(
      builder: (context, state) {
        if (state is! ReviewsLoaded) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final reviews = state.reviewsForService(serviceId);
        final avgRating = state.averageRating(serviceId);
        final reviewCount = state.reviewCount(serviceId);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    translate('reviews_title'),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.white : AppColors.black,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => AddReviewSheet.show(context, serviceId),
                  icon: Icon(Icons.rate_review_outlined, size: 18.sp),
                  label: Text(
                    translate('write_review'),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Text(
                    avgRating > 0 ? avgRating.toStringAsFixed(1) : '—',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StarRatingWidget(rating: avgRating, size: 20),
                      SizedBox(height: 4.h),
                      Text(
                        reviewCount > 0
                            ? translate('review_count').replaceAll(
                                '{count}',
                                reviewCount.toString(),
                              )
                            : translate('no_reviews_yet'),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            if (reviews.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: Column(
                    children: [
                      Icon(
                        Icons.reviews_outlined,
                        size: 48.sp,
                        color: AppColors.grey.withValues(alpha: 0.4),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        translate('be_first_reviewer'),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              ...reviews.map((review) => ReviewCard(review: review)),
          ],
        );
      },
    );
  }
}
