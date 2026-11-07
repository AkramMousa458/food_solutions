import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/core/error/api_failure_feedback.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/custom_snack_bar.dart';
import 'package:food_solutions/core/utils/service_locator.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/auth/presentation/screens/login_screen.dart';
import 'package:food_solutions/features/profile/presentation/manager/profile_cubit.dart';
import 'package:food_solutions/features/profile/presentation/manager/profile_state.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_screen_body.dart';
import 'package:food_solutions/features/settings/presentation/manager/settings_cubit.dart';
import 'package:food_solutions/features/settings/presentation/manager/settings_state.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => locator<ProfileCubit>()..loadProfile()),
        BlocProvider(create: (_) => locator<SettingsCubit>()),
      ],
      child: const _ProfileScaffold(),
    );
  }
}

class _ProfileScaffold extends StatelessWidget {
  const _ProfileScaffold();

  void _showEstablishmentFeedback(BuildContext context, ProfileState state) {
    if (state is! ProfileSuccess) return;
    final feedback = state.feedback;
    if (feedback == null) return;
    if (!feedback.isError) {
      final message = feedback.message.trim().isEmpty
          ? translate('establishment_deleted')
          : feedback.message;
      CustomSnackBar.showSuccess(context, message);
      return;
    }
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

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final background = isDark
        ? Theme.of(context).scaffoldBackgroundColor
        : Color.alphaBlend(
            AppColors.secondary.withValues(alpha: 0.08),
            AppColors.lightScaffold,
          );
    return MultiBlocListener(
      listeners: [
        BlocListener<SettingsCubit, SettingsState>(
          listener: (context, state) {
            if (state is SettingsSessionEnded) {
              context.go(LoginScreen.routeName);
            }
          },
        ),
        BlocListener<ProfileCubit, ProfileState>(
          listenWhen: (previous, current) {
            if (current is! ProfileSuccess || current.feedback == null) {
              return false;
            }
            if (previous is! ProfileSuccess) return true;
            return previous.feedback != current.feedback ||
                previous.profile != current.profile;
          },
          listener: _showEstablishmentFeedback,
        ),
      ],
      child: Scaffold(
        backgroundColor: background,
        body: const SafeArea(child: ProfileScreenBody()),
      ),
    );
  }
}
