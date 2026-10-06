import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:food_solutions/features/auth/presentation/widgets/login_continue_button.dart';
import 'package:food_solutions/features/profile/data/models/create_establishment_request.dart';
import 'package:food_solutions/features/profile/presentation/manager/create_establishment_cubit.dart';
import 'package:food_solutions/features/profile/presentation/manager/create_establishment_state.dart';
import 'package:food_solutions/features/profile/presentation/widgets/establishment_option_field.dart';

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
              AuthTextField(
                labelKey: 'establishment_name_label',
                hintKey: 'establishment_name_hint',
                icon: Icons.storefront_outlined,
                controller: cubit.nameController,
                validator: cubit.validateName,
                isEnabled: !isLoading,
              ),
              SizedBox(height: 14.h),
              AuthTextField(
                labelKey: 'establishment_phone_label',
                hintKey: 'establishment_phone_hint',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                controller: cubit.phoneController,
                validator: cubit.validatePhone,
                isEnabled: !isLoading,
              ),
              SizedBox(height: 14.h),
              AuthTextField(
                labelKey: 'establishment_age_label',
                hintKey: 'establishment_age_hint',
                icon: Icons.calendar_month_outlined,
                controller: cubit.ageController,
                isEnabled: !isLoading,
              ),
              SizedBox(height: 14.h),
              AuthTextField(
                labelKey: 'establishment_address_label',
                hintKey: 'establishment_address_hint',
                icon: Icons.location_on_outlined,
                controller: cubit.addressController,
                // validator: cubit.validateAddress,
                isEnabled: !isLoading,
              ),
              SizedBox(height: 14.h),
              AuthTextField(
                labelKey: 'establishment_location_label',
                hintKey: 'establishment_location_hint',
                icon: Icons.map_outlined,
                keyboardType: TextInputType.url,
                controller: cubit.locationController,
                isEnabled: !isLoading,
              ),
              SizedBox(height: 14.h),
              AuthTextField(
                labelKey: 'establishment_image_label',
                hintKey: 'establishment_image_hint',
                icon: Icons.image_outlined,
                keyboardType: TextInputType.url,
                controller: cubit.imageController,
                validator: cubit.validateOptionalUrl,
                isEnabled: !isLoading,
              ),
              SizedBox(height: 14.h),
              EstablishmentOptionField(
                labelKey: 'establishment_status_label',
                value: cubit.status,
                options: CreateEstablishmentRequest.statuses,
                labelFor: _statusLabel,
                onChanged: cubit.selectStatus,
                isEnabled: !isLoading,
              ),
              SizedBox(height: 14.h),
              EstablishmentOptionField(
                labelKey: 'establishment_position_label',
                value: cubit.userPosition,
                options: CreateEstablishmentRequest.positions,
                labelFor: _positionLabel,
                onChanged: cubit.selectPosition,
                isEnabled: !isLoading,
              ),
              SizedBox(height: 20.h),
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

  String _statusLabel(String status) {
    switch (status) {
      case CreateEstablishmentRequest.underConstructionStatus:
        return translate('establishment_status_under_construction');
      case CreateEstablishmentRequest.ideaStatus:
        return translate('establishment_status_idea');
      case CreateEstablishmentRequest.existingStatus:
        return translate('establishment_status_existing');
      default:
        return status;
    }
  }

  String _positionLabel(String position) {
    switch (position) {
      case CreateEstablishmentRequest.managerPosition:
        return translate('establishment_position_manager');
      case CreateEstablishmentRequest.authorizedPosition:
        return translate('establishment_position_authorized');
      case CreateEstablishmentRequest.ownerPosition:
        return translate('establishment_position_owner');
      default:
        return position;
    }
  }
}
