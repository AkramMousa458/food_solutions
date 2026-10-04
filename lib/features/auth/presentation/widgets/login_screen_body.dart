import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/features/auth/presentation/widgets/auth_screen_background.dart';
import 'package:food_solutions/features/auth/presentation/widgets/login_brand_header.dart';
import 'package:food_solutions/features/auth/presentation/widgets/login_footer_links.dart';
import 'package:food_solutions/features/auth/presentation/widgets/login_method_card.dart';

class LoginScreenBody extends StatelessWidget {
  const LoginScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScreenBackground(
      children: [
        const LoginBrandHeader(),
        SizedBox(height: 22.h),
        const LoginMethodCard(),
        SizedBox(height: 14.h),
        SizedBox(height: 22.h),
        const LoginFooterLinks(),
      ],
    );
  }
}
