import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/app_styles.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/auth/presentation/manager/otp_cubit.dart';

class OtpCodeField extends StatefulWidget {
  final bool isEnabled;
  final bool hasError;
  final int clearToken;
  final ValueChanged<String> onChanged;

  const OtpCodeField({
    super.key,
    required this.isEnabled,
    required this.hasError,
    required this.clearToken,
    required this.onChanged,
  });

  @override
  State<OtpCodeField> createState() => _OtpCodeFieldState();
}

class _OtpCodeFieldState extends State<OtpCodeField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_rebuild);
  }

  @override
  void didUpdateWidget(OtpCodeField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.clearToken != oldWidget.clearToken) {
      _controller.clear();
      _rebuild();
    }
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  void _onChanged(String value) {
    _rebuild();
    widget.onChanged(value);
  }

  bool _isActive(int index) {
    if (!_focusNode.hasFocus) return false;
    if (_controller.text.length >= OtpCubit.codeLength) return index == 5;
    return index == _controller.text.length;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_rebuild);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final code = _controller.text;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                enabled: widget.isEnabled,
                autofocus: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.oneTimeCode],
                showCursor: false,
                enableInteractiveSelection: false,
                cursorWidth: 0,
                style: const TextStyle(
                  color: AppColors.transparent,
                  fontSize: 1,
                  height: 1,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(OtpCubit.codeLength),
                ],
                decoration: const InputDecoration(
                  filled: false,
                  isCollapsed: true,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  counterText: '',
                ),
                onChanged: _onChanged,
              ),
            ),
          ),
          IgnorePointer(
            child: Row(
              children: [
                for (var index = 0; index < OtpCubit.codeLength; index++) ...[
                  if (index > 0) SizedBox(width: 8.w),
                  Expanded(
                    child: _OtpDigitBox(
                      key: ValueKey('otp_digit_$index'),
                      digit: index < code.length ? code[index] : '',
                      isActive: _isActive(index),
                      hasError: widget.hasError,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OtpDigitBox extends StatelessWidget {
  final String digit;
  final bool isActive;
  final bool hasError;

  const _OtpDigitBox({
    super.key,
    required this.digit,
    required this.isActive,
    required this.hasError,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final borderColor = hasError
        ? AppColors.error
        : isActive || digit.isNotEmpty
        ? (isDark ? AppColors.primarySoft : AppColors.primary)
        : (isDark
              ? AppColors.white.withValues(alpha: 0.12)
              : AppColors.lightBorder);
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: 58.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInputFill : AppColors.lightInputFill,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: borderColor,
          width: isActive || hasError ? 1.6 : 1,
        ),
      ),
      child: Text(
        digit,
        style: AppStyles.textstyle20.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
