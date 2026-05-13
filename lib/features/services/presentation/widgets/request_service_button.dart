import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:food_solutions/features/services/data/models/service_item_model.dart';
import 'package:food_solutions/features/booking/presentation/screens/booking_screen.dart';

class RequestServiceButton extends StatelessWidget {
  final ServiceItemModel service;

  const RequestServiceButton({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55.h,
      child: ElevatedButton(
        onPressed: () {
          context.push(BookingScreen.routeName, extra: service);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.r),
          ),
          elevation: 0,
        ),
        child: Text(
          translate('request_service'),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
