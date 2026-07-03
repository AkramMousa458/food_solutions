import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/utils/app_colors.dart';

class StarRatingWidget extends StatelessWidget {
  final double rating;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool interactive;
  final ValueChanged<int>? onRatingChanged;

  const StarRatingWidget({
    super.key,
    required this.rating,
    this.size = 20,
    this.activeColor,
    this.inactiveColor,
    this.interactive = false,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    final active = activeColor ?? AppColors.secondary;
    final inactive = inactiveColor ?? AppColors.grey.withValues(alpha: 0.35);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        final isFilled = rating >= starValue;
        final isHalf = !isFilled && rating > index && rating < starValue;

        return GestureDetector(
          onTap: interactive && onRatingChanged != null
              ? () => onRatingChanged!(starValue)
              : null,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.w),
            child: Icon(
              isFilled
                  ? Icons.star_rounded
                  : isHalf
                  ? Icons.star_half_rounded
                  : Icons.star_outline_rounded,
              size: size.sp,
              color: isFilled || isHalf ? active : inactive,
            ),
          ),
        );
      }),
    );
  }
}
