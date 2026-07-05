import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/base/presentation/screens/base_screen.dart';
import 'package:food_solutions/features/calculator/domain/food_cost_calculator.dart';
import 'package:food_solutions/features/calculator/presentation/widgets/calculator_input_field.dart';
import 'package:food_solutions/features/calculator/presentation/widgets/food_cost_gauge.dart';
import 'package:food_solutions/features/calculator/presentation/widgets/food_cost_metrics_grid.dart';
import 'package:food_solutions/features/calculator/presentation/widgets/suggested_prices_section.dart';

class FoodCostCalculatorBody extends StatefulWidget {
  const FoodCostCalculatorBody({super.key});

  @override
  State<FoodCostCalculatorBody> createState() => _FoodCostCalculatorBodyState();
}

class _FoodCostCalculatorBodyState extends State<FoodCostCalculatorBody> {
  final _formKey = GlobalKey<FormState>();
  final _ingredientCostController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _servingsController = TextEditingController(text: '1');

  FoodCostResult? _result;

  @override
  void dispose() {
    _ingredientCostController.dispose();
    _sellingPriceController.dispose();
    _servingsController.dispose();
    super.dispose();
  }

  double? _parseInput(String value) {
    final parsed = double.tryParse(value.trim());
    if (parsed == null) return null;
    return parsed;
  }

  void _calculate() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final ingredientCost = _parseInput(_ingredientCostController.text)!;
    final sellingPrice = _parseInput(_sellingPriceController.text)!;
    final servings = _parseInput(_servingsController.text)!;

    final result = FoodCostCalculator.calculate(
      ingredientCost: ingredientCost,
      sellingPrice: sellingPrice,
      servings: servings,
    );

    setState(() => _result = result);
  }

  void _reset() {
    _ingredientCostController.clear();
    _sellingPriceController.clear();
    _servingsController.text = '1';
    setState(() => _result = null);
  }

  String _statusMessage(FoodCostStatus status) {
    switch (status) {
      case FoodCostStatus.good:
        return translate('calc_status_good');
      case FoodCostStatus.low:
        return translate('calc_status_low');
      case FoodCostStatus.average:
        return translate('calc_status_average');
      case FoodCostStatus.high:
        return translate('calc_status_high');
    }
  }

  Color _statusColor(FoodCostStatus status) {
    switch (status) {
      case FoodCostStatus.good:
        return AppColors.success500;
      case FoodCostStatus.low:
        return AppColors.primarySoft;
      case FoodCostStatus.average:
        return AppColors.warning500;
      case FoodCostStatus.high:
        return AppColors.error;
    }
  }

  Color _statusBackground(FoodCostStatus status, bool isDark) {
    final color = _statusColor(status);
    return color.withValues(alpha: isDark ? 0.2 : 0.12);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final primaryColor = Theme.of(context).primaryColor;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInputCard(isDark, primaryColor),
            if (_result != null) ...[
              SizedBox(height: 16.h),
              _buildResultsCard(isDark, primaryColor, _result!),
              SizedBox(height: 16.h),
              SuggestedPricesSection(result: _result!),
            ],
            SizedBox(height: 20.h),
            _buildCtaBanner(isDark, primaryColor),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard(bool isDark, Color primaryColor) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? AppColors.white.withValues(alpha: 0.1)
              : AppColors.grey.withValues(alpha: 0.15),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translate('calc_food_cost_title'),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            translate('calc_food_cost_subtitle'),
            style: TextStyle(
              fontSize: 13.sp,
              height: 1.5,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          SizedBox(height: 20.h),
          CalculatorInputField(
            label: translate('calc_ingredient_cost_label'),
            hintText: '0.00',
            controller: _ingredientCostController,
            prefix: '${translate('currency_symbol')} ',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return translate('booking_validation_required');
              }
              final parsed = _parseInput(value);
              if (parsed == null || parsed < 0) {
                return translate('calc_validation_number');
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),
          CalculatorInputField(
            label: translate('calc_selling_price_label'),
            hintText: '0.00',
            controller: _sellingPriceController,
            prefix: '${translate('currency_symbol')} ',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return translate('booking_validation_required');
              }
              final parsed = _parseInput(value);
              if (parsed == null || parsed <= 0) {
                return translate('calc_validation_positive');
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),
          CalculatorInputField(
            label: translate('calc_servings_label'),
            hintText: '1',
            controller: _servingsController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return translate('booking_validation_required');
              }
              final parsed = _parseInput(value);
              if (parsed == null || parsed <= 0) {
                return translate('calc_validation_positive');
              }
              return null;
            },
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _reset,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.secondary,
                    side: const BorderSide(color: AppColors.secondary),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    translate('calc_reset'),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _calculate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    translate('calc_calculate'),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultsCard(
    bool isDark,
    Color primaryColor,
    FoodCostResult result,
  ) {
    final statusColor = _statusColor(result.status);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? AppColors.white.withValues(alpha: 0.1)
              : AppColors.grey.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translate('calc_food_cost_percentage'),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '${result.foodCostPercentage.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 36.sp,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: _statusBackground(result.status, isDark),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    _statusMessage(result.status),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          FoodCostGauge(foodCostPercentage: result.foodCostPercentage),
          SizedBox(height: 20.h),
          FoodCostMetricsGrid(result: result),
        ],
      ),
    );
  }

  Widget _buildCtaBanner(bool isDark, Color primaryColor) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: () => BaseScreen.changeTab(context, 4),
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: LinearGradient(
              colors: [primaryColor, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  translate('calc_cta_text'),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    color: AppColors.white,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Icon(
                Directionality.of(context) == TextDirection.rtl
                    ? Icons.arrow_forward_ios_rounded
                    : Icons.arrow_back_ios_rounded,
                color: AppColors.white,
                size: 18.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
