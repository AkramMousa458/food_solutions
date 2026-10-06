import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';

class ProfileEstablishmentActions extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isEnabled;

  const ProfileEstablishmentActions({
    super.key,
    this.onEdit,
    this.onDelete,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final edit = onEdit;
    final delete = onDelete;
    if (edit == null && delete == null) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (edit != null)
          _EstablishmentIconButton(
            buttonKey: const Key('profile-edit-establishment'),
            icon: Icons.edit_outlined,
            color: AppColors.primary,
            tooltip: translate('establishment_edit_action'),
            onPressed: isEnabled ? edit : null,
          ),
        if (delete != null) ...[
          SizedBox(width: 4.w),
          _EstablishmentIconButton(
            buttonKey: const Key('profile-delete-establishment'),
            icon: Icons.delete_outline,
            color: AppColors.error500,
            tooltip: translate('establishment_delete_action'),
            onPressed: isEnabled ? delete : null,
          ),
        ],
      ],
    );
  }
}

class _EstablishmentIconButton extends StatelessWidget {
  final Key buttonKey;
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback? onPressed;

  const _EstablishmentIconButton({
    required this.buttonKey,
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36.w,
      height: 36.w,
      child: IconButton(
        key: buttonKey,
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: 20.sp),
      ),
    );
  }
}
