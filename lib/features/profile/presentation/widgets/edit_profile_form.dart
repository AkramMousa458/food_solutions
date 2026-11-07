import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:food_solutions/features/auth/presentation/widgets/login_continue_button.dart';
import 'package:food_solutions/features/profile/presentation/manager/edit_profile_cubit.dart';
import 'package:food_solutions/features/profile/presentation/manager/edit_profile_state.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
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
    context.read<EditProfileCubit>().updateProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (context, state) {
        final cubit = context.read<EditProfileCubit>();
        final isLoading = state is EditProfileLoading;
        return Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
            children: [
              AuthTextField(
                labelKey: 'register_name_label',
                hintKey: 'register_name_hint',
                icon: Icons.person_outline_rounded,
                controller: cubit.nameController,
                validator: cubit.validateName,
                isEnabled: !isLoading,
              ),
              SizedBox(height: 14.h),
              AuthTextField(
                labelKey: 'register_phone_label',
                hintKey: 'register_phone_hint',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                controller: cubit.phoneController,
                validator: cubit.validatePhone,
                isEnabled: !isLoading,
              ),
              SizedBox(height: 14.h),
              AuthTextField(
                labelKey: 'register_email_label',
                hintKey: 'register_email_hint',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                controller: cubit.emailController,
                validator: cubit.validateEmail,
                isEnabled: !isLoading,
              ),
              SizedBox(height: 20.h),
              LoginContinueButton(
                labelKey: 'profile_save_action',
                isLoading: isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        );
      },
    );
  }
}
