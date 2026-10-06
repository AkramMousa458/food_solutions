import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
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
      listener: (context, state) {
        if (state is SettingsSessionEnded) {
          context.go(LoginScreen.routeName);
        }
      },
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
