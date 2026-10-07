import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/profile/data/models/create_establishment_request.dart';
import 'package:food_solutions/features/profile/presentation/widgets/establishment_field_header.dart';
import 'package:food_solutions/features/profile/presentation/widgets/establishment_field_style.dart';

class EstablishmentPositionPicker extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final bool isEnabled;

  const EstablishmentPositionPicker({
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
          labelKey: 'establishment_position_label',
          isRequired: true,
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 52.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var index = 0; index < _options.length; index++) ...[
                if (index > 0) SizedBox(width: 8.w),
                Expanded(
                  child: _PositionButton(
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

class _PositionOption {
  final String value;
  final String labelKey;
  final IconData? icon;

  const _PositionOption({
    required this.value,
    required this.labelKey,
    required this.icon,
  });
}

const List<_PositionOption> _options = [
  _PositionOption(
    value: CreateEstablishmentRequest.ownerPosition,
    labelKey: 'establishment_position_owner',
    icon: null,
  ),

  _PositionOption(
    value: CreateEstablishmentRequest.managerPosition,
    labelKey: 'establishment_position_manager',
    icon: Icons.badge_outlined,
  ),
  _PositionOption(
    value: CreateEstablishmentRequest.authorizedPosition,
    labelKey: 'establishment_position_authorized',
    icon: Icons.assignment_ind_outlined,
  ),
];

class _PositionButton extends StatelessWidget {
  final _PositionOption option;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback onTap;

  const _PositionButton({
    required this.option,
    required this.isSelected,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final accent = EstablishmentFieldStyle.accent(isDark);
    final foreground = isSelected
        ? AppColors.white
        : EstablishmentFieldStyle.text(isDark);
    final radius = BorderRadius.circular(16.r);
    return Semantics(
      button: true,
      selected: isSelected,
      label: translate(option.labelKey),
      child: Material(
        color: AppColors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: isSelected ? accent : EstablishmentFieldStyle.fill(isDark),
            borderRadius: radius,
            border: Border.all(
              color: isSelected
                  ? accent
                  : EstablishmentFieldStyle.border(isDark),
            ),
          ),
          child: InkWell(
            onTap: isEnabled ? onTap : null,
            borderRadius: radius,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      translate(option.labelKey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.textstyle14.copyWith(
                        color: foreground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  _CrownOrIcon(option: option, color: foreground),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CrownOrIcon extends StatelessWidget {
  final _PositionOption option;
  final Color color;

  const _CrownOrIcon({required this.option, required this.color});

  @override
  Widget build(BuildContext context) {
    final icon = option.icon;
    if (icon == null) return _CrownIcon(color: color, size: 16.sp);
    return Icon(icon, color: color, size: 18.sp);
  }
}

class _CrownIcon extends StatelessWidget {
  final Color color;
  final double size;

  const _CrownIcon({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.square(size), painter: _CrownPainter(color));
  }
}

class _CrownPainter extends CustomPainter {
  final Color color;

  const _CrownPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final width = size.width;
    final height = size.height;
    final crown = Path()
      ..moveTo(width * 0.08, height * 0.78)
      ..lineTo(width * 0.08, height * 0.46)
      ..lineTo(width * 0.28, height * 0.64)
      ..lineTo(width * 0.5, height * 0.16)
      ..lineTo(width * 0.72, height * 0.64)
      ..lineTo(width * 0.92, height * 0.46)
      ..lineTo(width * 0.92, height * 0.78)
      ..close();
    canvas.drawPath(crown, paint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, height * 0.74, width, height * 0.18),
        Radius.circular(width * 0.08),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CrownPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
