import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';

import 'package:food_solutions/core/utils/theme_utils.dart';

import 'package:food_solutions/features/favorites/presentation/widgets/favorite_button.dart';

class HomeServiceCard extends StatelessWidget {
  final String title;
  final String imageIcon;
  final int? serviceId;
  final VoidCallback? onTap;

  const HomeServiceCard({
    super.key,
    required this.title,
    required this.imageIcon,
    this.serviceId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: isDark
            ? Border.all(color: AppColors.white.withValues(alpha: 0.12))
            : Border.all(color: AppColors.grey.withValues(alpha: 0.2)),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onTap ?? () {},
          borderRadius: BorderRadius.circular(15.r),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                imageIcon.isEmpty
                    ? Icon(
                        Icons.room_service_outlined,
                        color: primaryColor,
                        size: 40.sp,
                      )
                    : CachedNetworkImage(
                        imageUrl: imageIcon,
                        width: 40.w,
                        height: 40.h,
                        fit: BoxFit.contain,
                        errorWidget: (context, url, error) {
                          return Icon(
                            Icons.room_service_outlined,
                            color: primaryColor,
                            size: 40.sp,
                          );
                        },
                      ),
                SizedBox(height: 8.h),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: AppStyles.textstyle12.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.white
                        : AppColors.black.withValues(alpha: 0.87),
                  ),
                ),
                SizedBox(height: 4.h),
                  ],
                ),
              ),
              if (serviceId != null)
                PositionedDirectional(
                  top: 4.h,
                  end: 4.w,
                  child: FavoriteButton(serviceId: serviceId!, size: 18),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
