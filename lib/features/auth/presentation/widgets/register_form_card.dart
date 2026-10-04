import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/core/utils/custom_snack_bar.dart';
import 'package:food_solutions/features/auth/presentation/manager/register_cubit.dart';
import 'package:food_solutions/features/auth/presentation/manager/register_state.dart';
import 'package:food_solutions/features/auth/presentation/screens/login_screen.dart';
import 'package:food_solutions/features/auth/presentation/screens/otp_screen.dart';
import 'package:food_solutions/features/auth/presentation/widgets/auth_account_link.dart';
import 'package:food_solutions/features/auth/presentation/widgets/auth_password_field.dart';
import 'package:food_solutions/features/auth/presentation/widgets/auth_surface_card.dart';
import 'package:food_solutions/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:food_solutions/features/auth/presentation/widgets/login_continue_button.dart';
import 'package:go_router/go_router.dart';

class RegisterFormCard extends StatefulWidget {
  const RegisterFormCard({super.key});

  @override
  State<RegisterFormCard> createState() => _RegisterFormCardState();
}

class _RegisterFormCardState extends State<RegisterFormCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  void _submit() {
    FocusManager.instance.primaryFocus?.unfocus();
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
      return;
    }
    context.read<RegisterCubit>().sendRegistrationOtp();
  }

  void _handleState(BuildContext context, RegisterState state) {
    if (state is RegisterOtpSent) {
      final message = state.response.message.trim().isEmpty
          ? 'register_otp_sent'
          : state.response.message;
      CustomSnackBar.showSuccess(context, message);
      final responseIdentifier = state.response.identifier.trim();
      final identifier = responseIdentifier.isNotEmpty
          ? responseIdentifier
          : context.read<RegisterCubit>().emailController.text.trim();
      context.push(OtpScreen.routeName, extra: identifier);
      return;
    }
    if (state is! RegisterFailure) return;
    if (state.status == ApiFailureStatus.tooManyRequests) {
      CustomSnackBar.showWarning(context, state.message);
      return;
    }
    CustomSnackBar.showError(context, state.message);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: _handleState,
      builder: (context, state) {
        final cubit = context.read<RegisterCubit>();
        final isLoading = state is RegisterLoading;
        return Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode,
          child: AuthSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthTextField(
                  labelKey: 'register_name_label',
                  hintKey: 'register_name_hint',
                  icon: Icons.person_outline,
                  controller: cubit.nameController,
                  validator: cubit.validateName,
                  isEnabled: !isLoading,
                ),
                SizedBox(height: 14.h),
                AuthTextField(
                  labelKey: 'register_phone_label',
                  hintKey: 'register_phone_hint',
                  icon: Icons.smartphone_outlined,
                  keyboardType: TextInputType.phone,
                  controller: cubit.phoneController,
                  validator: cubit.validatePhone,
                  isEnabled: !isLoading,
                ),
                SizedBox(height: 14.h),
                AuthTextField(
                  labelKey: 'register_email_label',
                  hintKey: 'register_email_hint',
                  icon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  controller: cubit.emailController,
                  validator: cubit.validateEmail,
                  isEnabled: !isLoading,
                ),
                SizedBox(height: 14.h),
                AuthPasswordField(
                  labelKey: 'register_password_label',
                  hintKey: 'register_password_hint',
                  controller: cubit.passwordController,
                  validator: cubit.validatePassword,
                  isEnabled: !isLoading,
                ),
                SizedBox(height: 14.h),
                AuthPasswordField(
                  labelKey: 'register_confirm_password_label',
                  hintKey: 'register_confirm_password_hint',
                  controller: cubit.confirmPasswordController,
                  validator: cubit.validateConfirmPassword,
                  isEnabled: !isLoading,
                ),
                SizedBox(height: 16.h),
                LoginContinueButton(
                  labelKey: 'register_submit',
                  isLoading: isLoading,
                  onPressed: _submit,
                ),
                AuthAccountLink(
                  promptKey: 'register_have_account',
                  actionKey: 'register_sign_in',
                  onActionTap: isLoading
                      ? () {}
                      : () => context.go(LoginScreen.routeName),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
