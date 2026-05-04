import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_animate/flutter_animate.dart';

import 'home_hero_section.dart';
import 'home_sections_widget.dart';
import 'home_services_list.dart';
import 'home_action_buttons.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const HomeHeroSection()
              .animate()
              .fade(duration: 500.ms)
              .slideY(
                begin: -0.05,
                duration: 500.ms,
                curve: Curves.easeOutQuad,
              ),
          SizedBox(height: 55.h),
          const HomeServicesList(),
          SizedBox(height: 18.h),
          const HomeSectionsWidget(),
          SizedBox(height: 30.h),
          const HomeActionButtons()
              .animate()
              .fade(duration: 500.ms, delay: 300.ms)
              .scale(
                begin: const Offset(0.95, 0.95),
                curve: Curves.easeOutQuad,
              ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
