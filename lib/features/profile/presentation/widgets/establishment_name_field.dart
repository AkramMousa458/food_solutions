import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/profile/presentation/widgets/establishment_field_header.dart';
import 'package:food_solutions/features/profile/presentation/widgets/establishment_field_style.dart';

class EstablishmentNameField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isEnabled;

  const EstablishmentNameField({
    super.key,
    required this.controller,
    required this.validator,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const EstablishmentFieldHeader(
          labelKey: 'establishment_name_label',
          captionKey: 'establishment_name_caption',
          isRequired: true,
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          enabled: isEnabled,
          textInputAction: TextInputAction.next,
          validator: validator,
          style: AppStyles.textstyle14.copyWith(
            color: EstablishmentFieldStyle.text(isDark),
            fontWeight: FontWeight.w500,
          ),
          decoration: EstablishmentFieldStyle.decoration(
            isDark: isDark,
            hintText: translate('establishment_name_hint'),
            icon: Icons.apartment_outlined,
          ),
        ),
      ],
    );
  }
}
