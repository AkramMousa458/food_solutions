import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';

class EstablishmentOptionField extends StatelessWidget {
  final String labelKey;
  final String value;
  final List<String> options;
  final String Function(String option) labelFor;
  final ValueChanged<String> onChanged;
  final bool isEnabled;

  const EstablishmentOptionField({
    super.key,
    required this.labelKey,
    required this.value,
    required this.options,
    required this.labelFor,
    required this.onChanged,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final fillColor = isDark
        ? AppColors.darkInputFill
        : AppColors.lightInputFill;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          translate(labelKey),
          style: AppStyles.textstyle14.copyWith(
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        SizedBox(height: 8.h),
        DropdownButtonFormField<String>(
          initialValue: options.contains(value) ? value : null,
          items: options
              .map(
                (option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(labelFor(option)),
                ),
              )
              .toList(),
          onChanged: isEnabled
              ? (selected) {
                  if (selected == null) return;
                  onChanged(selected);
                }
              : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 16.h,
            ),
          ),
          style: AppStyles.textstyle14.copyWith(
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
