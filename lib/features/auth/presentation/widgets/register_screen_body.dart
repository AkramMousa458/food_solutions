import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:food_solutions/features/auth/presentation/widgets/auth_screen_background.dart';
import 'package:food_solutions/features/auth/presentation/widgets/login_brand_header.dart';
import 'package:food_solutions/features/auth/presentation/widgets/register_form_card.dart';

class RegisterScreenBody extends StatelessWidget {
  const RegisterScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScreenBackground(
      children: [
        const AuthBackButton(),
        SizedBox(height: 12.h),
        const LoginBrandHeader(
          titleKey: 'register_title',
          subtitleKey: 'register_subtitle',
          logoWidth: 112,
        ),
        SizedBox(height: 18.h),
        const RegisterFormCard(),
      ],
    );
  }
}
