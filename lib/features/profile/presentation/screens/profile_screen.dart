import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/service_locator.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/profile/presentation/manager/profile_cubit.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_screen_body.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<ProfileCubit>()..loadProfile(),
      child: const _ProfileScaffold(),
    );
  }
}

class _ProfileScaffold extends StatelessWidget {
  const _ProfileScaffold();

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final background = isDark
        ? Theme.of(context).scaffoldBackgroundColor
        : Color.alphaBlend(
            AppColors.secondary.withValues(alpha: 0.08),
            AppColors.lightScaffold,
          );
    return Scaffold(
      backgroundColor: background,
      body: const SafeArea(child: ProfileScreenBody()),
    );
  }
}
