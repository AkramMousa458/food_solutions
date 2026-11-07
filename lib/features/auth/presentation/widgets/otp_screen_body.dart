import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:food_solutions/features/auth/presentation/widgets/auth_screen_background.dart';
import 'package:food_solutions/features/auth/presentation/widgets/login_brand_header.dart';
import 'package:food_solutions/features/auth/presentation/widgets/otp_verify_card.dart';

class OtpScreenBody extends StatelessWidget {
  final String identifier;

  const OtpScreenBody({super.key, required this.identifier});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final emailColor = isDark ? AppColors.primarySoft : AppColors.primary;
    return AuthScreenBackground(
      children: [
        const AuthBackButton(),
        SizedBox(height: 12.h),
        const LoginBrandHeader(
          titleKey: 'otp_title',
          subtitleKey: 'otp_subtitle',
          logoWidth: 112,
        ),
        SizedBox(height: 8.h),
        Text(
          identifier,
          textAlign: TextAlign.center,
          style: AppStyles.textstyle14.copyWith(
            color: emailColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 18.h),
        OtpVerifyCard(identifier: identifier),
      ],
    );
  }
}
