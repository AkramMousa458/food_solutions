import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';

class ServiceImageHeader extends StatelessWidget {
  final String imageUrl;

  const ServiceImageHeader({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: 300.h,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        height: 300.h,
        color: isDark
            ? AppColors.white.withValues(alpha: 0.1)
            : AppColors.grey.withValues(alpha: 0.2),
      ),
      errorWidget: (context, url, error) => Container(
        height: 300.h,
        color: isDark
            ? AppColors.white.withValues(alpha: 0.1)
            : AppColors.grey.withValues(alpha: 0.2),
        child: Icon(Icons.broken_image, color: AppColors.grey, size: 50.sp),
      ),
    );
  }
}
