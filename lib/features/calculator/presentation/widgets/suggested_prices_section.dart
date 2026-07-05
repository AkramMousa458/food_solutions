import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/calculator/domain/food_cost_calculator.dart';

class SuggestedPricesSection extends StatelessWidget {
  final FoodCostResult result;

  const SuggestedPricesSection({super.key, required this.result});

  String _formatMoney(double value) =>
      '${translate('currency_symbol')}${value.toStringAsFixed(2)}';

  Color _priceColor(int target) {
    switch (target) {
      case 25:
        return AppColors.grey;
      case 28:
        return AppColors.success500;
      case 30:
        return AppColors.secondary;
      case 35:
        return AppColors.error;
      default:
        return AppColors.grey;
    }
  }

  String _targetLabel(int target) {
    switch (target) {
      case 25:
        return translate('calc_at_25');
      case 28:
        return translate('calc_at_28');
      case 30:
        return translate('calc_at_30');
      case 35:
        return translate('calc_at_35');
      default:
        return '$target%';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark
            ? primaryColor.withValues(alpha: 0.15)
            : primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: primaryColor.withValues(alpha: isDark ? 0.25 : 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                size: 20.sp,
                color: primaryColor,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  translate('calc_suggested_prices_title'),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 10.h,
              childAspectRatio: 2.2,
            ),
            itemCount: FoodCostCalculator.suggestedTargets.length,
            itemBuilder: (context, index) {
              final target = FoodCostCalculator.suggestedTargets[index];
              final price = result.suggestedPrices[target] ?? 0;

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _targetLabel(target),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _formatMoney(price),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: _priceColor(target),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
