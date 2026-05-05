import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/services/url_launcher_service.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/contact/data/models/contact_model.dart';

class ContactInfoCard extends StatelessWidget {
  final ContactItemModel info;

  const ContactInfoCard({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final primaryColor = Theme.of(context).primaryColor;

    final iconColor = info.color == Colors.grey ? primaryColor : info.color;
    final iconBgColor = iconColor.withValues(alpha: 0.12);

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? AppColors.white.withValues(alpha: 0.1)
              : const Color(0xFFE2E8F0),
        ),
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
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            if (info.value.contains('+')) {
              UrlLauncherService.launchCall(info.value);
            } else if (info.value.contains('@')) {
              UrlLauncherService.launchEmail(info.value);
            } else {
              UrlLauncherService.launchExternalUrl(info.link);
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: info.iconImage != null
                      ? CachedNetworkImage(
                          imageUrl: info.iconImage!,
                          width: 24.w,
                          height: 24.w,
                        )
                      : Icon(Icons.link, color: iconColor, size: 24.sp),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        info.title,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        info.value,
                        textDirection: info.value.contains('+')
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 13.sp,
                          height: 1.5,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
