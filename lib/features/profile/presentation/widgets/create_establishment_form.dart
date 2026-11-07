import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/features/auth/presentation/widgets/login_continue_button.dart';
import 'package:food_solutions/features/profile/presentation/manager/create_establishment_cubit.dart';
import 'package:food_solutions/features/profile/presentation/manager/create_establishment_state.dart';
import 'package:food_solutions/features/profile/presentation/widgets/establishment_address_field.dart';
import 'package:food_solutions/features/profile/presentation/widgets/establishment_age_field.dart';
import 'package:food_solutions/features/profile/presentation/widgets/establishment_location_field.dart';
import 'package:food_solutions/features/profile/presentation/widgets/establishment_name_field.dart';
import 'package:food_solutions/features/profile/presentation/widgets/establishment_phone_field.dart';
import 'package:food_solutions/features/profile/presentation/widgets/establishment_position_picker.dart';
import 'package:food_solutions/features/profile/presentation/widgets/establishment_privacy_note.dart';
import 'package:food_solutions/features/profile/presentation/widgets/establishment_status_picker.dart';

class CreateEstablishmentForm extends StatefulWidget {
  const CreateEstablishmentForm({super.key});

  @override
  State<CreateEstablishmentForm> createState() =>
      _CreateEstablishmentFormState();
}

class _CreateEstablishmentFormState extends State<CreateEstablishmentForm> {
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
    context.read<CreateEstablishmentCubit>().createEstablishment();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEstablishmentCubit, CreateEstablishmentState>(
      builder: (context, state) {
        final cubit = context.read<CreateEstablishmentCubit>();
        final isLoading = state is CreateEstablishmentLoading;
        return Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
            children: [
              EstablishmentNameField(
                controller: cubit.nameController,
                validator: cubit.validateName,
                isEnabled: !isLoading,
              ),
              SizedBox(height: 20.h),
              EstablishmentPhoneField(
                controller: cubit.phoneController,
                validator: cubit.validatePhone,
                isEnabled: !isLoading,
                country: cubit.phoneCode,
                onCountryChanged: cubit.selectPhoneCode,
              ),
              SizedBox(height: 20.h),
              EstablishmentAgeField(
                value: cubit.selectedAge,
                fallback: cubit.legacyAge,
                onChanged: cubit.selectAge,
                isEnabled: !isLoading,
              ),
              SizedBox(height: 20.h),
              EstablishmentAddressField(
                controller: cubit.addressController,
                isEnabled: !isLoading,
              ),
              SizedBox(height: 20.h),
              EstablishmentLocationField(
                controller: cubit.locationController,
                validator: cubit.validateOptionalUrl,
                isEnabled: !isLoading,
              ),
              SizedBox(height: 22.h),
              EstablishmentStatusPicker(
                value: cubit.status,
                onChanged: cubit.selectStatus,
                isEnabled: !isLoading,
              ),
              SizedBox(height: 22.h),
              EstablishmentPositionPicker(
                value: cubit.userPosition,
                onChanged: cubit.selectPosition,
                isEnabled: !isLoading,
              ),
              SizedBox(height: 18.h),
              const EstablishmentPrivacyNote(),
              SizedBox(height: 24.h),
              LoginContinueButton(
                labelKey: cubit.isEditing
                    ? 'establishment_update_action'
                    : 'establishment_create_action',
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
