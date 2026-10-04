import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/service_locator.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/auth/presentation/manager/otp_cubit.dart';
import 'package:food_solutions/features/auth/presentation/widgets/otp_screen_body.dart';

class OtpScreen extends StatelessWidget {
  static const String routeName = '/otp';

  final String identifier;

  const OtpScreen({super.key, required this.identifier});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<OtpCubit>(),
      child: _OtpView(identifier: identifier),
    );
  }
}

class _OtpView extends StatelessWidget {
  final String identifier;

  const _OtpView({required this.identifier});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkScaffold
          : AppColors.lightScaffold,
      body: OtpScreenBody(identifier: identifier),
    );
  }
}
