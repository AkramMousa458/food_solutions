import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/profile/presentation/establishment_phone.dart';
import 'package:food_solutions/features/profile/presentation/widgets/establishment_field_header.dart';
import 'package:food_solutions/features/profile/presentation/widgets/establishment_field_style.dart';

class EstablishmentPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isEnabled;
  final ArabPhoneCode country;
  final ValueChanged<String> onCountryChanged;

  const EstablishmentPhoneField({
    super.key,
    required this.controller,
    required this.validator,
    required this.isEnabled,
    required this.country,
    required this.onCountryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final hint = country.isSaudi
        ? translate('establishment_phone_hint')
        : List.filled(country.maxLength, 'X').join();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const EstablishmentFieldHeader(
          labelKey: 'establishment_phone_label',
          captionKey: 'establishment_phone_caption',
          isRequired: true,
        ),
        SizedBox(height: 8.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CountryCodeChip(
              country: country,
              isEnabled: isEnabled,
              onChanged: onCountryChanged,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: TextFormField(
                controller: controller,
                enabled: isEnabled,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                inputFormatters: [_LocalPhoneFormatter(country)],
                validator: validator,
                style: AppStyles.textstyle14.copyWith(
                  color: EstablishmentFieldStyle.text(isDark),
                  fontWeight: FontWeight.w500,
                ),
                decoration: EstablishmentFieldStyle.decoration(
                  isDark: isDark,
                  hintText: hint,
                  icon: Icons.phone_outlined,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CountryCodeChip extends StatelessWidget {
  final ArabPhoneCode country;
  final bool isEnabled;
  final ValueChanged<String> onChanged;

  const _CountryCodeChip({
    required this.country,
    required this.isEnabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final radius = BorderRadius.circular(16.r);
    return Material(
      color: AppColors.transparent,
      child: Ink(
        decoration: EstablishmentFieldStyle.box(
          isDark,
          fillColor: EstablishmentFieldStyle.mutedFill(isDark),
        ),
        child: InkWell(
          onTap: isEnabled ? () => _openPicker(context) : null,
          borderRadius: radius,
          child: SizedBox(
            height: 54.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                textDirection: TextDirection.ltr,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Flag(flag: country.flag),
                  SizedBox(width: 6.w),
                  Text(
                    country.displayCode,
                    style: AppStyles.textstyle14.copyWith(
                      color: EstablishmentFieldStyle.text(isDark),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18.sp,
                    color: EstablishmentFieldStyle.hint(isDark),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openPicker(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final selected = await showModalBottomSheet<ArabPhoneCode>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ThemeUtils.isDark(context)
          ? AppColors.darkCard
          : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (context) => _CountryCodeSheet(selectedDial: country.dial),
    );
    if (selected == null) return;
    onChanged(selected.dial);
  }
}

class _CountryCodeSheet extends StatelessWidget {
  final String selectedDial;

  const _CountryCodeSheet({required this.selectedDial});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final codes = [...EstablishmentPhone.arabCodes]
      ..sort(
        (left, right) =>
            translate(left.nameKey).compareTo(translate(right.nameKey)),
      );
    final height = MediaQuery.sizeOf(context).height * 0.72;
    return SafeArea(
      child: SizedBox(
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10.h),
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: EstablishmentFieldStyle.hint(isDark),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
              child: Text(
                translate('phone_country_picker'),
                style: AppStyles.textstyle16.copyWith(
                  color: EstablishmentFieldStyle.text(isDark),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: codes.length,
                itemBuilder: (context, index) {
                  final code = codes[index];
                  final isSelected = code.dial == selectedDial;
                  return ListTile(
                    onTap: () => Navigator.of(context).pop(code),
                    leading: _Flag(flag: code.flag, size: 22.sp),
                    title: Text(
                      translate(code.nameKey),
                      style: AppStyles.textstyle14.copyWith(
                        color: EstablishmentFieldStyle.text(isDark),
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          code.displayCode,
                          textDirection: TextDirection.ltr,
                          style: AppStyles.textstyle14.copyWith(
                            color: isSelected
                                ? EstablishmentFieldStyle.accent(isDark)
                                : EstablishmentFieldStyle.hint(isDark),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (isSelected) ...[
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.check,
                            color: EstablishmentFieldStyle.accent(isDark),
                            size: 18.sp,
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Flag extends StatelessWidget {
  final String flag;
  final double? size;

  const _Flag({required this.flag, this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      flag,
      style: TextStyle(
        fontSize: size ?? 16.sp,
        fontFamily: 'Apple Color Emoji',
        fontFamilyFallback: const ['Noto Color Emoji', 'Segoe UI Emoji'],
      ),
    );
  }
}

class _LocalPhoneFormatter extends TextInputFormatter {
  final ArabPhoneCode country;

  const _LocalPhoneFormatter(this.country);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = EstablishmentPhone.local(newValue.text, country);
    final offset = newValue.selection.end.clamp(0, digits.length);
    return TextEditingValue(
      text: digits,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}
