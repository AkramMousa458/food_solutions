import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/services/url_launcher_service.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/contact/data/models/contact_model.dart';

class SocialMediaRow extends StatelessWidget {
  final List<SocialItemModel> items;

  const SocialMediaRow({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          translate('contact_follow_us'),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.white : const Color(0xFF0F172A),
          ),
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: items.map((item) => _SocialButton(item: item)).toList(),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final SocialItemModel item;

  const _SocialButton({required this.item});

  @override
  Widget build(BuildContext context) {
    // final isDark = ThemeUtils.isDark(context);
    return Material(
      color: AppColors.transparent,
      // shape: const CircleBorder(),
      // clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => UrlLauncherService.launchExternalUrl(item.link),
        child: CachedNetworkImage(
          imageUrl: item.iconImage,
          width: 48.w,
          height: 48.w,
        ),
      ),
    );
  }
}
