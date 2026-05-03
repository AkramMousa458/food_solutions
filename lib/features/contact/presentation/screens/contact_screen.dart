import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:food_solutions/features/base/presentation/screens/base_screen.dart';
import '../widgets/contact_screen_body.dart';

class ContactScreen extends StatelessWidget {
  static const String routeName = '/contact';

  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.white,
          ), // Arabic uses RTL, back arrow is forward
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              BaseScreen.changeTab(context, 0); // Return to home tab
            }
          },
        ),
        centerTitle: true,
        title: Text(
          translate('contact_us_title'),
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
      body: SafeArea(child: ContactScreenBody()),
    );
  }
}
