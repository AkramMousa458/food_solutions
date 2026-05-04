import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/utils/app_colors.dart';

import 'package:food_solutions/core/utils/theme_utils.dart';
import '../../data/models/service_item_model.dart';

import 'package:go_router/go_router.dart';
import '../screens/service_details_screen.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class ServiceTileCard extends StatelessWidget {
  final ServiceItemModel service;
  final VoidCallback? onTap;

  const ServiceTileCard({super.key, required this.service, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
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
          onTap: () {
            if (onTap != null) {
              onTap!();
            } else {
              context.push(ServiceDetailsScreen.routeName, extra: service);
            }
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image and Icon Stack
              SizedBox(
                height: 140.h,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Main Image
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16.r),
                      ),
                      child: service.image != null && service.image!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: service.image!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: isDark
                                    ? AppColors.shimmerDarkBaseColor
                                    : AppColors.shimmerLightBaseColor,
                                highlightColor: isDark
                                    ? AppColors.shimmerDarkHighlightColor
                                    : AppColors.shimmerLightHighlightColor,
                                child: Container(color: Colors.white),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: isDark
                                    ? AppColors.darkInputFill
                                    : AppColors.lightScaffold,
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.grey.withValues(alpha: 0.5),
                                ),
                              ),
                            )
                          : Container(
                              color: isDark
                                  ? AppColors.darkInputFill
                                  : AppColors.lightScaffold,
                              child: Icon(
                                Icons.image_outlined,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.grey.withValues(alpha: 0.5),
                                size: 40.sp,
                              ),
                            ),
                    ),
                    // Gradient overlay to make it look premium
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16.r),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.black.withValues(alpha: 0.4),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Text Content
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    // Icon Container
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: service.icon.isNotEmpty && service.icon != '-'
                          ? CachedNetworkImage(
                              imageUrl: service.icon,
                              width: 32.sp,
                              height: 32.sp,
                              fit: BoxFit.contain,
                              errorWidget: (context, url, error) => Icon(
                                Icons.room_service_outlined,
                                color: primaryColor,
                                size: 32.sp,
                              ),
                            )
                          : Icon(
                              Icons.room_service_outlined,
                              color: primaryColor,
                              size: 32.sp,
                            ),
                    ),
                    SizedBox(width: 16.w),
                    // Texts
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.titleAr,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.black.withValues(alpha: 0.87),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            service.shortDescriptionAr,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.sp,
                              height: 1.5,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.darkTextSecondary.withValues(
                                      alpha: 0.8,
                                    )
                                  : AppColors.grey.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
