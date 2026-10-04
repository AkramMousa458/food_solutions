import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';

class AuthPasswordField extends StatefulWidget {
  final String labelKey;
  final String hintKey;

  const AuthPasswordField({
    super.key,
    required this.labelKey,
    required this.hintKey,
  });

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _isObscured = true;

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final hintColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final accent = isDark ? AppColors.primarySoft : AppColors.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          translate(widget.labelKey),
          style: AppStyles.textstyle14.copyWith(
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          obscureText: _isObscured,
          style: AppStyles.textstyle14.copyWith(
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: translate(widget.hintKey),
            hintStyle: AppStyles.textstyle14.copyWith(
              color: hintColor,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(Icons.lock_outline, color: accent, size: 20.sp),
            suffixIcon: IconButton(
              onPressed: _toggleVisibility,
              icon: Icon(
                _isObscured
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: hintColor,
                size: 20.sp,
              ),
            ),
            filled: true,
            fillColor: isDark
                ? AppColors.darkInputFill
                : AppColors.lightInputFill,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 16.h,
            ),
          ),
        ),
      ],
    );
  }
}
