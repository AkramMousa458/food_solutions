import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';

import 'home_stats_card.dart';

class HomeHeroSection extends StatelessWidget {
  const HomeHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background Image with dark overlay
        Container(
          height: 200.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: primaryColor.withValues(
              alpha: 0.9,
            ), // Fallback solid background
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                'https://images.unsplash.com/photo-1556155092-490a1ba16284?auto=format&fit=crop&w=800&q=80',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
              Container(
                color: AppColors.black.withValues(alpha: 0.6), // Dark overlay
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'شريكك في عالم المطاعم',
                      textAlign: TextAlign.center,
                      style: AppStyles.textstyle20Bold.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'نساعدك في تطوير وإدارة مطعمك بكفاءة واحترافية',
                      textAlign: TextAlign.center,
                      style: AppStyles.textstyle12.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: 20.h), // space for overlapping card
                  ],
                ),
              ),
            ],
          ),
        ),

        // Overlapping Stats Card
        Positioned(
          bottom: -35.h,
          left: 20.w,
          right: 20.w,
          child: const HomeStatsCard(),
        ),
      ],
    );
  }
}
