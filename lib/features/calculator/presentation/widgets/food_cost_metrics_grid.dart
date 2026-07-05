import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/calculator/domain/food_cost_calculator.dart';

class FoodCostMetricsGrid extends StatelessWidget {
  final FoodCostResult result;

  const FoodCostMetricsGrid({super.key, required this.result});

  String _formatMoney(double value) =>
      '${translate('currency_symbol')}${value.toStringAsFixed(2)}';

  String _formatPercent(double value) => '${value.toStringAsFixed(1)}%';

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    final items = [
      _MetricItem(
        label: translate('calc_cost_per_serving'),
        value: _formatMoney(result.costPerServing),
        valueColor: null,
      ),
      _MetricItem(
        label: translate('calc_profit_per_serving'),
        value: _formatMoney(result.profitPerServing),
        valueColor: AppColors.success500,
      ),
      _MetricItem(
        label: translate('calc_profit_margin'),
        value: _formatPercent(result.profitMargin),
        valueColor: null,
      ),
      _MetricItem(
        label: translate('calc_markup'),
        value: _formatPercent(result.markup),
        valueColor: AppColors.secondary,
      ),
      _MetricItem(
        label: translate('calc_total_revenue'),
        value: _formatMoney(result.totalRevenue),
        valueColor: null,
      ),
      _MetricItem(
        label: translate('calc_total_profit'),
        value: _formatMoney(result.totalProfit),
        valueColor: AppColors.success500,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 1.6,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkInputFill.withValues(alpha: 0.5)
                : AppColors.secondary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.08)
                  : AppColors.secondary.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                item.value,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: item.valueColor ??
                      (isDark ? AppColors.white : AppColors.lightTextPrimary),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MetricItem {
  final String label;
  final String value;
  final Color? valueColor;

  const _MetricItem({
    required this.label,
    required this.value,
    this.valueColor,
  });
}
