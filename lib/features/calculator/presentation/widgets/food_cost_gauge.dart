import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';

class FoodCostGauge extends StatelessWidget {
  final double foodCostPercentage;

  const FoodCostGauge({super.key, required this.foodCostPercentage});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final primaryColor = Theme.of(context).primaryColor;
    final progress = (foodCostPercentage / 50).clamp(0.0, 1.0);

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10.h,
            backgroundColor: isDark
                ? AppColors.darkInputFill
                : AppColors.lightBorder,
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _label('0%', isDark, bold: false),
            _label(translate('calc_gauge_ideal'), isDark, bold: true),
            _label('35%', isDark, bold: false),
            _label(translate('calc_gauge_high'), isDark, bold: false),
          ],
        ),
      ],
    );
  }

  Widget _label(String text, bool isDark, {required bool bold}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11.sp,
        fontWeight: bold ? FontWeight.bold : FontWeight.w500,
        color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
      ),
    );
  }
}
