import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';

class ProfileSurface extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Gradient? gradient;
  final VoidCallback? onTap;

  const ProfileSurface({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final radius = BorderRadius.circular(24.r);
    final decoration = BoxDecoration(
      gradient: gradient,
      color: gradient == null
          ? (isDark ? AppColors.darkCard : AppColors.white)
          : null,
      borderRadius: radius,
      border: Border.all(
        color: isDark
            ? AppColors.white.withValues(alpha: 0.08)
            : AppColors.lightBorder,
      ),
      boxShadow: isDark
          ? null
          : [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
    );
    final content = Padding(padding: padding, child: child);
    return Material(
      color: AppColors.transparent,
      child: Ink(
        decoration: decoration,
        child: onTap == null
            ? content
            : InkWell(onTap: onTap, borderRadius: radius, child: content),
      ),
    );
  }
}
