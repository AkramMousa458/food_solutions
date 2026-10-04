import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/features/auth/presentation/screens/login_screen.dart';
import 'package:food_solutions/features/auth/presentation/widgets/auth_account_link.dart';
import 'package:food_solutions/features/auth/presentation/widgets/auth_password_field.dart';
import 'package:food_solutions/features/auth/presentation/widgets/auth_surface_card.dart';
import 'package:food_solutions/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:food_solutions/features/auth/presentation/widgets/login_continue_button.dart';
import 'package:go_router/go_router.dart';

class RegisterFormCard extends StatelessWidget {
  const RegisterFormCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthTextField(
            labelKey: 'register_name_label',
            hintKey: 'register_name_hint',
            icon: Icons.person_outline,
          ),
          SizedBox(height: 14.h),
          const AuthTextField(
            labelKey: 'register_phone_label',
            hintKey: 'register_phone_hint',
            icon: Icons.smartphone_outlined,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 14.h),
          const AuthTextField(
            labelKey: 'register_email_label',
            hintKey: 'register_email_hint',
            icon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 14.h),
          const AuthPasswordField(
            labelKey: 'register_password_label',
            hintKey: 'register_password_hint',
          ),
          SizedBox(height: 14.h),
          const AuthPasswordField(
            labelKey: 'register_confirm_password_label',
            hintKey: 'register_confirm_password_hint',
          ),
          SizedBox(height: 16.h),
          const LoginContinueButton(labelKey: 'register_submit'),
          AuthAccountLink(
            promptKey: 'register_have_account',
            actionKey: 'register_sign_in',
            onActionTap: () => context.go(LoginScreen.routeName),
          ),
        ],
      ),
    );
  }
}
