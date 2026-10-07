import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/profile/data/models/create_establishment_request.dart';
import 'package:food_solutions/features/profile/presentation/widgets/establishment_field_header.dart';
import 'package:food_solutions/features/profile/presentation/widgets/establishment_field_style.dart';

class EstablishmentAgeField extends StatelessWidget {
  final String? value;
  final String fallback;
  final ValueChanged<String> onChanged;
  final bool isEnabled;

  const EstablishmentAgeField({
    super.key,
    required this.value,
    required this.fallback,
    required this.onChanged,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final labelKey = value == null
        ? null
        : CreateEstablishmentRequest.ageLabelKeys[value!];
    final selectedText = labelKey == null ? null : translate(labelKey);
    final legacy = fallback.trim();
    final text = selectedText ?? (legacy.isEmpty ? null : legacy);
    final isPlaceholder = text == null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const EstablishmentFieldHeader(
          labelKey: 'establishment_age_label',
          badgeKey: 'establishment_age_optional',
          helpKey: 'establishment_age_help',
        ),
        SizedBox(height: 8.h),
        Material(
          color: AppColors.transparent,
          child: Ink(
            decoration: EstablishmentFieldStyle.box(isDark),
            child: InkWell(
              onTap: isEnabled ? () => _openMenu(context) : null,
              borderRadius: BorderRadius.circular(16.r),
              child: SizedBox(
                height: 54.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        color: EstablishmentFieldStyle.accent(isDark),
                        size: 20.sp,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          text ?? translate('establishment_age_hint'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.textstyle14.copyWith(
                            color: isPlaceholder
                                ? EstablishmentFieldStyle.hint(isDark)
                                : EstablishmentFieldStyle.text(isDark),
                            fontWeight: isPlaceholder
                                ? FontWeight.w400
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: EstablishmentFieldStyle.hint(isDark),
                        size: 22.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openMenu(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final box = context.findRenderObject();
    final overlay = Overlay.maybeOf(context)?.context.findRenderObject();
    if (box is! RenderBox || overlay is! RenderBox || !box.hasSize) return;
    final topLeft = box.localToGlobal(Offset.zero, ancestor: overlay);
    final selected = await showMenu<String>(
      context: context,
      color: AppColors.establishmentMenu,
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
      constraints: BoxConstraints(
        minWidth: box.size.width,
        maxWidth: box.size.width,
      ),
      position: RelativeRect.fromRect(
        Rect.fromLTWH(
          topLeft.dx,
          topLeft.dy + box.size.height + 6.h,
          box.size.width,
          0,
        ),
        Offset.zero & overlay.size,
      ),
      items: _menuItems(),
    );
    if (selected == null) return;
    onChanged(selected);
  }

  List<PopupMenuEntry<String>> _menuItems() {
    return [
      PopupMenuItem<String>(
        enabled: false,
        height: 42.h,
        child: Text(
          translate('establishment_age_hint'),
          style: AppStyles.textstyle12.copyWith(
            color: AppColors.white.withValues(alpha: 0.55),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      for (final age in CreateEstablishmentRequest.ages)
        PopupMenuItem<String>(
          value: age,
          height: 46.h,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  translate(CreateEstablishmentRequest.ageLabelKeys[age]!),
                  style: AppStyles.textstyle14.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (age == value)
                Icon(Icons.check, color: AppColors.white, size: 18.sp),
            ],
          ),
        ),
    ];
  }
}
