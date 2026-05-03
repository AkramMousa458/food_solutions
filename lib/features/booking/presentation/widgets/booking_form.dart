import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/widgets/custom_button.dart';
import 'package:food_solutions/core/widgets/custom_text_field.dart';
import 'package:food_solutions/core/widgets/custom_dropdown_field.dart';
import 'package:food_solutions/features/base/presentation/screens/base_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:food_solutions/features/services/data/models/service_item_model.dart';
import 'package:food_solutions/features/services/presentation/manager/services_cubit.dart';
import '../manager/booking_cubit.dart';
import '../manager/booking_state.dart';

class BookingForm extends StatefulWidget {
  final ServiceItemModel? initialService;

  const BookingForm({super.key, this.initialService});

  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedServiceId;

  @override
  void initState() {
    super.initState();
    if (widget.initialService != null) {
      _selectedServiceId = widget.initialService!.id;
    }
  }

  // @override
  // void dispose() {
  // context.read<BookingCubit>().nameController.dispose();
  // context.read<BookingCubit>().phoneController.dispose();
  // context.read<BookingCubit>().emailController.dispose();
  // context.read<BookingCubit>().detailsController.dispose();
  //   super.dispose();
  // }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<BookingCubit>().submitBooking(
        serviceId: _selectedServiceId!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is BookingSuccess) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.success(message: "تم إرسال طلبك بنجاح"),
          );

          // ✅ clear بس — الـ dispose مسؤولية الـ Cubit
          final cubit = context.read<BookingCubit>();
          cubit.nameController.clear();
          cubit.phoneController.clear();
          cubit.emailController.clear();
          cubit.detailsController.clear();

          setState(() {
            _selectedServiceId = null;
          });

          context.go(BaseScreen.routeName);
          BaseScreen.changeTab(context, 0);
        } else if (state is BookingFailure) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(message: state.errorMessage),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is BookingLoading;

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  label: translate('booking_name_label'),
                  hintText: translate('booking_name_hint'),
                  controller: context.read<BookingCubit>().nameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return translate('booking_validation_required');
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  label: translate('booking_phone_label'),
                  hintText: translate('booking_phone_hint'),
                  controller: context.read<BookingCubit>().phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return translate('booking_validation_required');
                    }
                    if (value.length < 9) {
                      // Basic validation example
                      return translate('booking_validation_phone');
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  label: translate('booking_email_label'),
                  hintText: translate('booking_email_hint'),
                  controller: context.read<BookingCubit>().emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!value.contains('@') || !value.contains('.')) {
                        return translate('booking_validation_email');
                      }
                    } else if (value == null || value.trim().isEmpty) {
                      return translate('booking_validation_required');
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                BlocBuilder<ServicesCubit, ServicesState>(
                  builder: (context, servicesState) {
                    if (servicesState is ServicesLoading) {
                      return CustomDropdownField<int>(
                        label: translate('booking_service_label'),
                        hintText: translate('loading'),
                        value: _selectedServiceId,
                        items: [],
                        onChanged: (value) {
                          setState(() {
                            _selectedServiceId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return translate('booking_validation_required');
                          }
                          return null;
                        },
                      );
                    } else if (servicesState is ServicesError) {
                      return Text(
                        translate('error_try_again'),
                        style: AppStyles.textstyle15.copyWith(
                          color: AppColors.error,
                        ),
                      );
                    } else if (servicesState is ServicesLoaded) {
                      final services = servicesState.services;
                      return CustomDropdownField<int>(
                        label: translate('booking_service_label'),
                        hintText: translate('booking_service_hint'),
                        value: _selectedServiceId,
                        items: services.map((service) {
                          final title = service.titleAr;
                          return DropdownMenuItem<int>(
                            value: service.id,
                            child: Text(title),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedServiceId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return translate('booking_validation_required');
                          }
                          return null;
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  label: translate('booking_details_label'),
                  hintText: translate('booking_details_hint'),
                  controller: context.read<BookingCubit>().detailsController,
                  maxLines: 5,
                  // validator: (value) {
                  //   if (value == null || value.trim().isEmpty) {
                  //     return translate('booking_validation_required');
                  //   }
                  //   return null;
                  // },
                ),
                SizedBox(height: 40.h),
                CustomButton(
                  text: translate('booking_submit'),
                  icon: const Icon(Icons.send_outlined, color: AppColors.white),
                  isLoading: isLoading,
                  onPressed: _submitForm,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
