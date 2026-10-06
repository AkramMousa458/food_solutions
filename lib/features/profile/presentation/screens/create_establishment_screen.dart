import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/error/api_failure_feedback.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/custom_snack_bar.dart';
import 'package:food_solutions/core/utils/service_locator.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/auth/presentation/screens/login_screen.dart';
import 'package:food_solutions/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:food_solutions/features/profile/presentation/manager/create_establishment_cubit.dart';
import 'package:food_solutions/features/profile/presentation/manager/create_establishment_state.dart';
import 'package:food_solutions/features/profile/presentation/widgets/create_establishment_form.dart';
import 'package:go_router/go_router.dart';

class CreateEstablishmentScreen extends StatelessWidget {
  static const String routeName = '/create-establishment';

  const CreateEstablishmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<CreateEstablishmentCubit>(),
      child: const _CreateEstablishmentView(),
    );
  }
}

class _CreateEstablishmentView extends StatelessWidget {
  const _CreateEstablishmentView();

  void _handleState(BuildContext context, CreateEstablishmentState state) {
    if (state is CreateEstablishmentSuccess) {
      final message = state.message.trim().isEmpty
          ? translate('establishment_created')
          : state.message;
      CustomSnackBar.showSuccess(context, message);
      context.pop();
      return;
    }
    if (state is! CreateEstablishmentFailure) return;
    switch (feedbackForApiStatus(state.status)) {
      case ApiFailureFeedback.warning:
        CustomSnackBar.showWarning(context, state.message);
      case ApiFailureFeedback.error:
        CustomSnackBar.showError(context, state.message);
      case ApiFailureFeedback.endSession:
        CustomSnackBar.showError(context, state.message);
        context.go(LoginScreen.routeName);
      case ApiFailureFeedback.ignore:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final titleColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    return BlocListener<CreateEstablishmentCubit, CreateEstablishmentState>(
      listener: _handleState,
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkScaffold
            : AppColors.lightScaffold,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AuthBackButton(),
                    SizedBox(height: 16.h),
                    Text(
                      translate('establishment_create_title'),
                      style: AppStyles.textstyle22.copyWith(color: titleColor),
                    ),
                  ],
                ),
              ),
              const Expanded(child: CreateEstablishmentForm()),
            ],
          ),
        ),
      ),
    );
  }
}
