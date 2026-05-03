import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_hero_section.dart';
import 'home_sections_widget.dart';
import 'home_services_list.dart';
import 'home_action_buttons.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const HomeHeroSection(),
          SizedBox(height: 50.h),
          const HomeServicesList(),
          SizedBox(height: 18.h),
          const HomeSectionsWidget(),
          SizedBox(height: 30.h),
          const HomeActionButtons(),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
