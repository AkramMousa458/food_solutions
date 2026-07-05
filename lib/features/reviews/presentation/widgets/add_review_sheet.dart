import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/widgets/custom_button.dart';
import 'package:food_solutions/core/widgets/custom_text_field.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../manager/reviews_cubit.dart';
import '../manager/reviews_state.dart';
import 'star_rating_widget.dart';

class AddReviewSheet extends StatefulWidget {
  final int serviceId;

  const AddReviewSheet({super.key, required this.serviceId});

  static Future<void> show(BuildContext context, int serviceId) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<ReviewsCubit>(),
        child: AddReviewSheet(serviceId: serviceId),
      ),
    );
  }

  @override
  State<AddReviewSheet> createState() => _AddReviewSheetState();
}

class _AddReviewSheetState extends State<AddReviewSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _commentController = TextEditingController();
  int _selectedRating = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedRating == 0) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(message: translate('review_rating_required')),
      );
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;

    try {
      await context.read<ReviewsCubit>().submitReview(
        serviceId: widget.serviceId,
        name: _nameController.text.trim(),
        rating: _selectedRating,
        comment: _commentController.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(message: translate('review_submit_success')),
      );
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().replaceFirst('Exception: ', '');
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(message: message),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  translate('write_review'),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.white : AppColors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                Text(
                  translate('your_rating'),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                SizedBox(height: 8.h),
                Center(
                  child: StarRatingWidget(
                    rating: _selectedRating.toDouble(),
                    size: 36,
                    interactive: true,
                    onRatingChanged: (rating) {
                      setState(() => _selectedRating = rating);
                    },
                  ),
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  controller: _nameController,
                  label: translate('review_name_label'),
                  hintText: translate('review_name_hint'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return translate('booking_validation_required');
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: _commentController,
                  label: translate('review_comment_label'),
                  hintText: translate('review_comment_hint'),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return translate('booking_validation_required');
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),
                BlocBuilder<ReviewsCubit, ReviewsState>(
                  builder: (context, state) {
                    final isLoading =
                        state is ReviewsLoaded && state.isSubmitting;
                    return CustomButton(
                      text: 'review_submit',
                      onPressed: isLoading ? null : _submit,
                      isLoading: isLoading,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
  }
}
