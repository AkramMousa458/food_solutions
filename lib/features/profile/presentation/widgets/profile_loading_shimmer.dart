import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_surface.dart';
import 'package:shimmer/shimmer.dart';

class ProfileLoadingShimmer extends StatelessWidget {
  const ProfileLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      children: [
        const _IdentitySkeleton(),
        SizedBox(height: 14.h),
        const _EstablishmentSkeleton(),
        SizedBox(height: 14.h),
        const _RowSkeleton(),
        SizedBox(height: 14.h),
        const _RowSkeleton(isCompact: true),
      ],
    );
  }
}

class _IdentitySkeleton extends StatelessWidget {
  const _IdentitySkeleton();

  @override
  Widget build(BuildContext context) {
    return ProfileSurface(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 16.h),
      child: Column(
        children: [
          const _Bone(width: 96, height: 96, isCircle: true),
          SizedBox(height: 16.h),
          const _Bone(width: 168, height: 18),
          SizedBox(height: 12.h),
          const _Bone(width: 112, height: 28, radius: 20),
          SizedBox(height: 10.h),
          const _Bone(width: 180, height: 32, radius: 20),
          SizedBox(height: 8.h),
          const _Bone(width: 210, height: 32, radius: 20),
          SizedBox(height: 18.h),
          const _Bone(height: 52, radius: 16),
        ],
      ),
    );
  }
}

class _EstablishmentSkeleton extends StatelessWidget {
  const _EstablishmentSkeleton();

  @override
  Widget build(BuildContext context) {
    return ProfileSurface(
      padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Bone(width: 148, height: 12),
          SizedBox(height: 16.h),
          Row(
            children: [
              const _Bone(width: 48, height: 48, radius: 14),
              SizedBox(width: 10.w),
              const Expanded(child: _Bone(height: 16)),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              const Expanded(child: _Bone(height: 72, radius: 16)),
              SizedBox(width: 8.w),
              const Expanded(child: _Bone(height: 72, radius: 16)),
              SizedBox(width: 8.w),
              const Expanded(child: _Bone(height: 72, radius: 16)),
            ],
          ),
          SizedBox(height: 16.h),
          const _Bone(height: 52, radius: 16),
        ],
      ),
    );
  }
}

class _RowSkeleton extends StatelessWidget {
  final bool isCompact;

  const _RowSkeleton({this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    return ProfileSurface(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      child: Row(
        children: [
          const _Bone(width: 48, height: 48, radius: 16),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Bone(width: 140, height: 14),
                if (!isCompact) ...[
                  SizedBox(height: 8.h),
                  const _Bone(width: 190, height: 10),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bone extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;
  final bool isCircle;

  const _Bone({
    this.width,
    required this.height,
    this.radius = 8,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final baseColor = isDark
        ? const Color.fromARGB(255, 62, 90, 135)
        : AppColors.shimmerLightBaseColor;
    final highlightColor = isDark
        ? AppColors.shimmerDarkHighlightColor
        : AppColors.shimmerLightHighlightColor;
    final boneWidth = isCircle
        ? height.w
        : (width == null ? double.infinity : width!.w);
    final boneHeight = isCircle ? height.w : height.h;
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: boneWidth,
        height: boneHeight,
        decoration: BoxDecoration(
          color: baseColor,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : BorderRadius.circular(radius.r),
        ),
      ),
    );
  }
}
