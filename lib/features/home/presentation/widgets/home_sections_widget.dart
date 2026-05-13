import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:shimmer/shimmer.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/home/data/models/home_section_model.dart';
import 'package:food_solutions/features/home/presentation/manager/home_sections_cubit.dart';
import 'package:food_solutions/features/home/presentation/manager/home_sections_state.dart';

class HomeSectionsWidget extends StatelessWidget {
  const HomeSectionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeSectionsCubit, HomeSectionsState>(
      builder: (context, state) {
        if (state is HomeSectionsLoading || state is HomeSectionsInitial) {
          return _HomeSectionsShimmer();
        }
        if (state is HomeSectionsSuccess) {
          if (state.sections.isEmpty) return const SizedBox();
          return _HomeSectionsList(sections: state.sections);
        }
        return const SizedBox();
      },
    );
  }
}

// ─────────────────────────────────────────────
// Real Content
// ─────────────────────────────────────────────

class _HomeSectionsList extends StatelessWidget {
  final List<HomeSectionModel> sections;

  const _HomeSectionsList({required this.sections});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = ThemeUtils.isDark(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              Container(
                width: 4.w,
                height: 22.h,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                translate('sections'),
                style: AppStyles.textstyle18.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.white : AppColors.black,
                ),
              ),
            ],
          ),
        ).animate().fade(duration: 400.ms).slideX(begin: -0.1),

        SizedBox(height: 12.h),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemCount: sections.length,
          separatorBuilder: (_, __) => SizedBox(height: 16.h),
          itemBuilder: (context, index) =>
              _SectionCard(section: sections[index], index: index)
                  .animate()
                  .fade(duration: 500.ms, delay: (index * 150).ms)
                  .slideY(
                    begin: 0.1,
                    duration: 500.ms,
                    curve: Curves.easeOutQuad,
                  ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final HomeSectionModel section;
  final int index;

  const _SectionCard({required this.section, required this.index});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isDark
              ? AppColors.white.withValues(alpha: 0.08)
              : AppColors.lightBorder,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image
          if (section.image.isNotEmpty) _SectionImage(imageUrl: section.image),

          // Content
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                if (section.title.isNotEmpty)
                  Text(
                    section.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.white
                          : AppColors.lightTextPrimary,
                      height: 1.4,
                    ),
                  ),

                // Subtitle chip
                if (section.subtitle.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(bottom: 8.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Text(
                      section.subtitle,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ),

                // Description
                if (section.description.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Text(
                    section.description,
                    style: TextStyle(
                      fontSize: 13.sp,
                      height: 1.6,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionImage extends StatelessWidget {
  final String imageUrl;

  const _SectionImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Placeholder background
          Container(
            color: isDark ? AppColors.darkInputFill : AppColors.lightScaffold,
          ),
          CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Container(
              color: isDark ? AppColors.darkInputFill : AppColors.lightScaffold,
              child: Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: 40.sp,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.grey.withValues(alpha: 0.5),
                ),
              ),
            ),
            fadeInDuration: const Duration(milliseconds: 200),
            placeholder: (context, url) {
              return Shimmer.fromColors(
                baseColor: isDark
                    ? AppColors.shimmerDarkBaseColor
                    : AppColors.shimmerLightBaseColor,
                highlightColor: isDark
                    ? AppColors.shimmerDarkHighlightColor
                    : AppColors.shimmerLightHighlightColor,
                child: Container(
                  color: isDark ? AppColors.darkCard : AppColors.white,
                ),
              );
            },
          ),
          // Subtle gradient overlay at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 60.h,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.black.withValues(alpha: 0.35),
                    AppColors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Shimmer Loading
// ─────────────────────────────────────────────

class _HomeSectionsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final baseColor = isDark
        ? AppColors.shimmerDarkBaseColor
        : AppColors.shimmerLightBaseColor;
    final highlightColor = isDark
        ? AppColors.shimmerDarkHighlightColor
        : AppColors.shimmerLightHighlightColor;
    final cardColor = isDark
        ? AppColors.shimmerDarkCardColor
        : AppColors.shimmerLightCardColor;
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header shimmer
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Row(
              children: [
                Container(
                  width: 4.w,
                  height: 22.h,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(width: 10.w),
                Container(
                  width: 120.w,
                  height: 18.h,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 16.h),

        // 2 card skeletons
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: List.generate(
              2,
              (i) => Padding(
                padding: EdgeInsets.only(bottom: i == 0 ? 16.h : 0),
                child: Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image placeholder
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkInputFill
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18.r),
                                topRight: Radius.circular(18.r),
                              ),
                            ),
                          ),
                        ),
                        // Text placeholders
                        Padding(
                          padding: EdgeInsets.all(16.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 70.w,
                                height: 14.h,
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Container(
                                width: 180.w,
                                height: 16.h,
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                width: double.infinity,
                                height: 12.h,
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Container(
                                width: 220.w,
                                height: 12.h,
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(6.r),
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
            ),
          ),
        ),
      ],
    );
  }
}
