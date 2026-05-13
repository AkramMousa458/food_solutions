import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/service_locator.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/booking/presentation/manager/booking_cubit.dart';
import 'package:food_solutions/features/services/data/models/service_item_model.dart';
import 'package:food_solutions/features/services/presentation/manager/services_cubit.dart';
import '../widgets/booking_form.dart';

class BookingScreen extends StatelessWidget {
  static const String routeName = '/booking-screen';
  final ServiceItemModel? initialService;

  const BookingScreen({super.key, this.initialService});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final primaryColor = Theme.of(context).primaryColor;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: locator<BookingCubit>()),
        BlocProvider.value(value: locator<ServicesCubit>()),
      ],
      child: Scaffold(
        backgroundColor: isDark
            ? Theme.of(context).scaffoldBackgroundColor
            : AppColors.white,
        appBar: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            translate('booking_title'),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          actions: [
            SizedBox(width: 48.w), // Balance the leading icon
          ],
        ),
        body: SafeArea(child: BookingForm(initialService: initialService)),
      ),
    );
  }
}
