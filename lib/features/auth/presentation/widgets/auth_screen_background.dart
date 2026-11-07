import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';

class AuthScreenBackground extends StatelessWidget {
  final List<Widget> children;

  const AuthScreenBackground({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withValues(alpha: isDark ? 0.28 : 0.12),
              isDark ? AppColors.darkScaffold : AppColors.lightScaffold,
            ],
            stops: const [0, 0.42],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
            child: Column(children: children),
          ),
        ),
      ),
    );
  }
}
