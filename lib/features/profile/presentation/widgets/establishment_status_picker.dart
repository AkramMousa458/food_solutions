import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/profile/data/models/create_establishment_request.dart';
import 'package:food_solutions/features/profile/presentation/widgets/establishment_field_header.dart';
import 'package:food_solutions/features/profile/presentation/widgets/establishment_field_style.dart';

class EstablishmentStatusPicker extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final bool isEnabled;

  const EstablishmentStatusPicker({
    super.key,
    required this.value,
    required this.onChanged,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const EstablishmentFieldHeader(
          labelKey: 'establishment_status_label',
          isRequired: true,
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 135.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var index = 0; index < _options.length; index++) ...[
                if (index > 0) SizedBox(width: 8.w),
                Expanded(
                  child: _StatusCard(
                    option: _options[index],
                    isSelected: value == _options[index].value,
                    isEnabled: isEnabled,
                    onTap: () => onChanged(_options[index].value),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusOption {
  final String value;
  final String titleKey;
  final String detailKey;
  final IconData icon;

  const _StatusOption({
    required this.value,
    required this.titleKey,
    required this.detailKey,
    required this.icon,
  });
}

const List<_StatusOption> _options = [
  _StatusOption(
    value: CreateEstablishmentRequest.existingStatus,
    titleKey: 'establishment_status_existing',
    detailKey: 'establishment_status_existing_detail',
    icon: Icons.restaurant,
  ),

  _StatusOption(
    value: CreateEstablishmentRequest.underConstructionStatus,
    titleKey: 'establishment_status_under_construction',
    detailKey: 'establishment_status_under_construction_detail',
    icon: Icons.handyman_outlined,
  ),
  _StatusOption(
    value: CreateEstablishmentRequest.ideaStatus,
    titleKey: 'establishment_status_idea',
    detailKey: 'establishment_status_idea_detail',
    icon: Icons.lightbulb_outline,
  ),
];

class _StatusCard extends StatelessWidget {
  final _StatusOption option;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback onTap;

  const _StatusCard({
    required this.option,
    required this.isSelected,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final accent = EstablishmentFieldStyle.accent(isDark);
    final radius = BorderRadius.circular(18.r);
    final fill = isSelected
        ? (isDark
              ? accent.withValues(alpha: 0.18)
              : AppColors.establishmentAccentSoft)
        : EstablishmentFieldStyle.fill(isDark);
    final border = isSelected ? accent : EstablishmentFieldStyle.border(isDark);
    final titleColor = isSelected
        ? accent
        : EstablishmentFieldStyle.text(isDark);
    final detailColor = isSelected
        ? accent.withValues(alpha: 0.8)
        : EstablishmentFieldStyle.hint(isDark);
    return Semantics(
      button: true,
      selected: isSelected,
      label: '${translate(option.titleKey)} ${translate(option.detailKey)}',
      child: Material(
        color: AppColors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: fill,
            borderRadius: radius,
            border: Border.all(color: border, width: isSelected ? 1.4 : 1),
          ),
          child: InkWell(
            onTap: isEnabled ? onTap : null,
            borderRadius: radius,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(6.w, 16.h, 6.w, 12.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatusIcon(icon: option.icon, isSelected: isSelected),
                      SizedBox(height: 10.h),
                      Text(
                        translate(option.titleKey),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.textstyle12.copyWith(
                          color: titleColor,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        translate(option.detailKey),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.textstyle12.copyWith(
                          color: detailColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  PositionedDirectional(
                    top: 8.h,
                    start: 8.w,
                    child: Container(
                      width: 18.r,
                      height: 18.r,
                      decoration: BoxDecoration(
                        color: accent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: AppColors.white,
                        size: 12.sp,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;

  const _StatusIcon({required this.icon, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final accent = EstablishmentFieldStyle.accent(isDark);
    return Container(
      width: 44.r,
      height: 44.r,
      decoration: BoxDecoration(
        color: isSelected ? accent : EstablishmentFieldStyle.mutedFill(isDark),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 22.sp,
        color: isSelected
            ? AppColors.white
            : EstablishmentFieldStyle.hint(isDark),
      ),
    );
  }
}
