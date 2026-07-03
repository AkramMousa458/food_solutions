import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/features/base/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:food_solutions/features/home/presentation/manager/home_sections_cubit.dart';
import 'package:food_solutions/features/home/presentation/manager/statistics_cubit.dart';
import 'package:food_solutions/features/home/presentation/screens/home_screen.dart';
import 'package:food_solutions/features/services/presentation/screens/services_screen.dart';
import 'package:food_solutions/features/booking/presentation/screens/booking_screen.dart';
import 'package:food_solutions/features/contact/presentation/screens/contact_screen.dart';
import 'package:food_solutions/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:food_solutions/features/services/presentation/manager/services_cubit.dart';
import 'package:food_solutions/features/contact/presentation/manager/contact_cubit.dart';
import 'package:food_solutions/features/favorites/presentation/manager/favorites_cubit.dart';
import 'package:food_solutions/features/reviews/presentation/manager/reviews_cubit.dart';
import 'package:food_solutions/core/utils/service_locator.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});
  static const String routeName = '/base-screen';

  static void changeTab(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_BaseScreenState>();
    if (state != null && state._selectedIndex != index) {
      state._onItemTapped(index);
    }
  }

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ServicesScreen(),
    const FavoritesScreen(),
    const BookingScreen(),
    const ContactScreen(),
  ];

  @override
  void initState() {
    super.initState();
    locator<ServicesCubit>().fetchServices();
    locator<ContactCubit>().fetchContacts();
    locator<StatisticsCubit>().getStatistics();
    locator<HomeSectionsCubit>().getHomeSections();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // if (_selectedIndex == 0) {
      //   locator<ServicesCubit>().fetchServices();
      //   locator<ContactCubit>().fetchContacts();
      // }
    });
  }

  bool get _isOnHomeTab => _selectedIndex == 0;

  void _goToHome() {
    setState(() {
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _isOnHomeTab,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _goToHome();
        }
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: locator<ServicesCubit>()),
          BlocProvider.value(value: locator<ContactCubit>()),
          BlocProvider.value(value: locator<FavoritesCubit>()),
          BlocProvider.value(value: locator<ReviewsCubit>()),
        ],
        child: Scaffold(
          body: _screens[_selectedIndex],
          bottomNavigationBar: CustomBottomNavBar(
            selectedIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
