import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/features/auth/presentation/screens/register_screen.dart';
import 'package:food_solutions/features/auth/presentation/widgets/auth_account_link.dart';
import 'package:food_solutions/features/auth/presentation/widgets/auth_password_field.dart';
import 'package:food_solutions/features/auth/presentation/widgets/auth_surface_card.dart';
import 'package:food_solutions/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:food_solutions/features/auth/presentation/widgets/login_continue_button.dart';
import 'package:go_router/go_router.dart';

class LoginMethodCard extends StatelessWidget {
  const LoginMethodCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthTextField(
            labelKey: 'login_email_label',
            hintKey: 'login_email_hint',
            icon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 14.h),
          const AuthPasswordField(
            labelKey: 'login_password_label',
            hintKey: 'login_password_hint',
          ),
          SizedBox(height: 16.h),
          const LoginContinueButton(),
          AuthAccountLink(
            promptKey: 'login_no_account',
            actionKey: 'login_create_account',
            onActionTap: () => context.push(RegisterScreen.routeName),
          ),
        ],
      ),
    );
  }
}
