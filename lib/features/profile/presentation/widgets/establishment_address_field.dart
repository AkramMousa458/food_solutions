import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/profile/presentation/widgets/establishment_field_header.dart';
import 'package:food_solutions/features/profile/presentation/widgets/establishment_field_style.dart';

class EstablishmentAddressField extends StatelessWidget {
  final TextEditingController controller;
  final bool isEnabled;

  const EstablishmentAddressField({
    super.key,
    required this.controller,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const EstablishmentFieldHeader(labelKey: 'establishment_address_label'),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          enabled: isEnabled,
          textInputAction: TextInputAction.next,
          style: AppStyles.textstyle14.copyWith(
            color: EstablishmentFieldStyle.text(isDark),
            fontWeight: FontWeight.w500,
          ),
          decoration: EstablishmentFieldStyle.decoration(
            isDark: isDark,
            hintText: translate('establishment_address_hint'),
            icon: Icons.location_on_outlined,
          ),
        ),
      ],
    );
  }
}
