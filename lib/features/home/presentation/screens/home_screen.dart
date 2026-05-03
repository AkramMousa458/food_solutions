import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/core/utils/assets.dart';
import 'package:food_solutions/core/utils/service_locator.dart';
import 'package:food_solutions/core/widgets/theme_toggle_button.dart';
import 'package:food_solutions/features/contact/presentation/manager/contact_cubit.dart';
import 'package:food_solutions/features/home/presentation/manager/home_sections_cubit.dart';
import 'package:food_solutions/features/home/presentation/manager/statistics_cubit.dart';
import 'package:food_solutions/features/home/presentation/widgets/home_screen_body.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/services/presentation/manager/services_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home-screen';

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: locator<StatisticsCubit>()),
        BlocProvider.value(value: locator<HomeSectionsCubit>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: isDark
              ? Theme.of(context).scaffoldBackgroundColor
              : AppColors.white,
          elevation: 0,
          toolbarHeight: 70,
          title: Image.asset(Assets.logoHorizontal, height: 45),
          centerTitle: false,
          actions: const [ThemeToggleButton(), SizedBox(width: 10)],
        ),
        body: SafeArea(
          child: RefreshIndicator(
            color: AppColors.primary,
            backgroundColor: isDark ? AppColors.darkCard : AppColors.white,
            onRefresh: () async {
              locator<ServicesCubit>().fetchServices();
              locator<ContactCubit>().fetchContacts();
              locator<StatisticsCubit>().getStatistics();
              locator<HomeSectionsCubit>().getHomeSections();
            },
            child: const HomeScreenBody(),
          ),
        ),
      ),
    );
  }
}
