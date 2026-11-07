import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/custom_snack_bar.dart';
import 'package:food_solutions/features/auth/presentation/manager/otp_cubit.dart';
import 'package:food_solutions/features/auth/presentation/manager/otp_state.dart';
import 'package:food_solutions/features/auth/presentation/screens/login_screen.dart';
import 'package:food_solutions/features/auth/presentation/widgets/auth_account_link.dart';
import 'package:food_solutions/features/auth/presentation/widgets/auth_surface_card.dart';
import 'package:food_solutions/features/auth/presentation/widgets/login_continue_button.dart';
import 'package:food_solutions/features/auth/presentation/widgets/otp_code_field.dart';
import 'package:go_router/go_router.dart';

class OtpVerifyCard extends StatefulWidget {
  final String identifier;

  const OtpVerifyCard({super.key, required this.identifier});

  @override
  State<OtpVerifyCard> createState() => _OtpVerifyCardState();
}

class _OtpVerifyCardState extends State<OtpVerifyCard> {
  String _code = '';
  int _clearToken = 0;

  void _onCodeChanged(String value) {
    setState(() => _code = value);
    final cubit = context.read<OtpCubit>();
    if (value.length < OtpCubit.codeLength) {
      cubit.clearStatus();
      return;
    }
    cubit.verifyOtp(identifier: widget.identifier, code: value);
  }

  void _verify() {
    context.read<OtpCubit>().verifyOtp(
      identifier: widget.identifier,
      code: _code,
    );
  }

  void _resend() {
    context.read<OtpCubit>().resendOtp(identifier: widget.identifier);
  }

  void _handleState(BuildContext context, OtpState state) {
    if (state is OtpResent) {
      setState(() {
        _code = '';
        _clearToken += 1;
      });
      CustomSnackBar.showSuccess(context, state.message);
      return;
    }
    if (state is! OtpFailure) return;
    if (state.status == ApiFailureStatus.tooManyRequests) {
      CustomSnackBar.showWarning(context, state.message);
      return;
    }
    CustomSnackBar.showError(context, state.message);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpCubit, OtpState>(
      listener: _handleState,
      builder: (context, state) {
        if (state is OtpVerified) {
          return _OtpVerifiedContent(message: state.response.message);
        }
        final isBusy = state is OtpVerifying || state is OtpResending;
        final failureMessage = state is OtpFailure ? state.message : null;
        return AuthSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OtpCodeField(
                isEnabled: !isBusy,
                hasError: failureMessage != null,
                clearToken: _clearToken,
                onChanged: _onCodeChanged,
              ),
              if (failureMessage != null) ...[
                SizedBox(height: 12.h),
                Text(
                  failureMessage,
                  textAlign: TextAlign.center,
                  style: AppStyles.textstyle12.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              SizedBox(height: 16.h),
              LoginContinueButton(
                labelKey: 'otp_verify',
                isLoading: isBusy,
                onPressed: _verify,
              ),
              AuthAccountLink(
                promptKey: 'otp_resend_prompt',
                actionKey: 'otp_resend',
                onActionTap: isBusy ? () {} : _resend,
              ),
            ],
          ),
        );
      },
    );
  }
}

const Duration otpVerifiedNavigationDelay = Duration(milliseconds: 1500);

class _OtpVerifiedContent extends StatefulWidget {
  final String message;

  const _OtpVerifiedContent({required this.message});

  @override
  State<_OtpVerifiedContent> createState() => _OtpVerifiedContentState();
}

class _OtpVerifiedContentState extends State<_OtpVerifiedContent> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(otpVerifiedNavigationDelay, () {
      if (!mounted) return;
      context.go(LoginScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = translate('otp_verified_title');
    final detail = widget.message.trim();
    final titleColor = Theme.of(context).textTheme.bodyLarge?.color;
    return AuthSurfaceCard(
      child: Column(
        children: [
          Container(
                width: 88.r,
                height: 88.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.success500.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success500,
                  size: 56.sp,
                ),
              )
              .animate()
              .fadeIn(duration: 250.ms)
              .scale(
                begin: const Offset(0.35, 0.35),
                duration: 700.ms,
                curve: Curves.elasticOut,
              ),
          SizedBox(height: 14.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppStyles.textstyle16.copyWith(
              color: titleColor,
              fontWeight: FontWeight.w700,
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 350.ms),
          if (detail.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              detail,
              textAlign: TextAlign.center,
              style: AppStyles.textstyle14.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ).animate().fadeIn(delay: 320.ms, duration: 350.ms),
          ],
        ],
      ),
    );
  }
}
