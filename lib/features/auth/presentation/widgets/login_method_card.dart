import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/custom_snack_bar.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/auth/presentation/manager/login_cubit.dart';
import 'package:food_solutions/features/auth/presentation/manager/login_state.dart';
import 'package:food_solutions/features/auth/presentation/screens/otp_screen.dart';
import 'package:food_solutions/features/auth/presentation/widgets/auth_surface_card.dart';
import 'package:food_solutions/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:food_solutions/features/auth/presentation/widgets/login_continue_button.dart';
import 'package:food_solutions/features/base/presentation/screens/base_screen.dart';
import 'package:go_router/go_router.dart';

class LoginMethodCard extends StatefulWidget {
  const LoginMethodCard({super.key});

  @override
  State<LoginMethodCard> createState() => _LoginMethodCardState();
}

class _LoginMethodCardState extends State<LoginMethodCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submit() {
    FocusManager.instance.primaryFocus?.unfocus();
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    context.read<LoginCubit>().sendOtp();
  }

  void _handleState(BuildContext context, LoginState state) {
    if (state is LoginOtpSent) {
      context.push(OtpScreen.routeName, extra: state.phone);
      return;
    }
    if (state is LoginGuest) {
      context.go(BaseScreen.routeName);
      return;
    }
    if (state is! LoginFailure) return;
    if (state.status == ApiFailureStatus.tooManyRequests) {
      CustomSnackBar.showWarning(context, state.message);
      return;
    }
    CustomSnackBar.showError(context, state.message);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: _handleState,
      builder: (context, state) {
        final cubit = context.read<LoginCubit>();
        final isLoading = state is LoginLoading;
        return Form(
          key: _formKey,
          child: AuthSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthTextField(
                  labelKey: 'login_phone_label',
                  hintKey: 'login_phone_hint',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  controller: cubit.phoneController,
                  validator: cubit.validatePhone,
                  isEnabled: !isLoading,
                ),
                SizedBox(height: 24.h),
                LoginContinueButton(isLoading: isLoading, onPressed: _submit),
                SizedBox(height: 24.h),
                OutlinedButton(
                  key: const Key('login-guest'),
                  onPressed: isLoading ? null : () => cubit.continueAsGuest(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.35),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    minimumSize: Size(double.infinity, 48.h),
                  ),
                  child: Text(
                    translate('login_continue_as_guest'),
                    style: AppStyles.textstyle14Bold.copyWith(
                      color: ThemeUtils.isDark(context)
                          ? AppColors.primarySoft
                          : AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
