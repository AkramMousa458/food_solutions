import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';

class EstablishmentFieldHeader extends StatelessWidget {
  final String labelKey;
  final bool isRequired;
  final String? captionKey;
  final String? badgeKey;
  final String? helpKey;

  const EstablishmentFieldHeader({
    super.key,
    required this.labelKey,
    this.isRequired = false,
    this.captionKey,
    this.badgeKey,
    this.helpKey,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final hintColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isRequired) ...[
          Text(
            '*',
            style: AppStyles.textstyle16.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: 4.w),
        ],
        Text(
          translate(labelKey),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppStyles.textstyle12.copyWith(
            color: textColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (helpKey != null) ...[
          SizedBox(width: 4.w),
          Tooltip(
            message: translate(helpKey!),
            child: Icon(Icons.help_outline, size: 16.sp, color: hintColor),
          ),
        ],
        const Spacer(),
        if (badgeKey != null)
          _OptionalBadge(labelKey: badgeKey!)
        else if (captionKey != null)
          Text(
            translate(captionKey!),
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.textstyle10.copyWith(
              color: hintColor,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }
}

class _OptionalBadge extends StatelessWidget {
  final String labelKey;

  const _OptionalBadge({required this.labelKey});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.white.withValues(alpha: 0.08)
            : AppColors.establishmentOptionalFill,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        translate(labelKey),
        style: AppStyles.textstyle12.copyWith(
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.establishmentOptionalText,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
