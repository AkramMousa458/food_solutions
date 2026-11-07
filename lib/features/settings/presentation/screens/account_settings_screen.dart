import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/core/error/api_failure_feedback.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/custom_snack_bar.dart';
import 'package:food_solutions/core/utils/service_locator.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/auth/presentation/screens/login_screen.dart';
import 'package:food_solutions/features/settings/presentation/manager/settings_cubit.dart';
import 'package:food_solutions/features/settings/presentation/manager/settings_state.dart';
import 'package:food_solutions/features/settings/presentation/widgets/account_settings_body.dart';
import 'package:go_router/go_router.dart';

class AccountSettingsScreen extends StatelessWidget {
  static const String routeName = '/account-settings';

  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<SettingsCubit>()..loadSettings(),
      child: const _AccountSettingsView(),
    );
  }
}

class _AccountSettingsView extends StatelessWidget {
  const _AccountSettingsView();

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final background = isDark
        ? Theme.of(context).scaffoldBackgroundColor
        : Color.alphaBlend(
            AppColors.secondary.withValues(alpha: 0.08),
            AppColors.lightScaffold,
          );
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: _handleSettingsState,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: background,
          body: SafeArea(
            child: state is SettingsReady
                ? AccountSettingsBody(settings: state)
                : const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
          ),
        );
      },
    );
  }
}

void _handleSettingsState(BuildContext context, SettingsState state) {
  if (state is SettingsSessionEnded) {
    final message = state.message.trim();
    if (message.isNotEmpty) CustomSnackBar.showSuccess(context, message);
    context.go(LoginScreen.routeName);
    return;
  }
  final feedback = state is SettingsReady ? state.feedback : null;
  if (feedback == null || !feedback.isError) return;
  _showDeleteFailure(context, feedback);
}

void _showDeleteFailure(BuildContext context, SettingsFeedback feedback) {
  final status = feedback.status;
  if (status == null) {
    CustomSnackBar.showError(context, feedback.message);
    return;
  }
  switch (feedbackForApiStatus(status)) {
    case ApiFailureFeedback.warning:
      CustomSnackBar.showWarning(context, feedback.message);
    case ApiFailureFeedback.error:
      CustomSnackBar.showError(context, feedback.message);
    case ApiFailureFeedback.endSession:
      CustomSnackBar.showError(context, feedback.message);
      context.go(LoginScreen.routeName);
    case ApiFailureFeedback.ignore:
      return;
  }
}
