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
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:food_solutions/features/profile/presentation/manager/edit_profile_cubit.dart';
import 'package:food_solutions/features/profile/presentation/manager/edit_profile_state.dart';
import 'package:food_solutions/features/profile/presentation/widgets/edit_profile_form.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatelessWidget {
  static const String routeName = '/edit-profile';
  final ProfileSnapshot? profile;

  const EditProfileScreen({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = locator<EditProfileCubit>();
        final initial = profile;
        if (initial != null) cubit.prefill(initial);
        return cubit;
      },
      child: const _EditProfileView(),
    );
  }
}

class _EditProfileView extends StatelessWidget {
  const _EditProfileView();

  void _handleState(BuildContext context, EditProfileState state) {
    if (state is EditProfileSuccess) {
      CustomSnackBar.showSuccess(context, translate('profile_updated'));
      context.pop(true);
      return;
    }
    if (state is! EditProfileFailure) return;
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
    return BlocListener<EditProfileCubit, EditProfileState>(
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
                      translate('profile_edit_title'),
                      style: AppStyles.textstyle22.copyWith(color: titleColor),
                    ),
                  ],
                ),
              ),
              const Expanded(child: EditProfileForm()),
            ],
          ),
        ),
      ),
    );
  }
}
