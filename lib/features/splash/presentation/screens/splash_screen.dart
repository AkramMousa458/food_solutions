import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_solutions/core/utils/assets.dart';
import 'package:food_solutions/core/utils/service_locator.dart';
import 'package:food_solutions/core/utils/theme_utils.dart';
import 'package:food_solutions/features/auth/presentation/screens/login_screen.dart';
import 'package:food_solutions/features/base/presentation/screens/base_screen.dart';
import 'package:food_solutions/features/splash/presentation/manager/splash_cubit.dart';
import 'package:food_solutions/features/splash/presentation/manager/splash_state.dart';
import 'package:go_router/go_router.dart';

const Duration splashNavigationDelay = Duration(seconds: 2);

class SplashScreen extends StatelessWidget {
  static const String routeName = '/';

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<SplashCubit>()..resolveSession(),
      child: const _SplashView(),
    );
  }
}

class _SplashView extends StatefulWidget {
  const _SplashView();

  @override
  State<_SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<_SplashView> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(splashNavigationDelay, () {
      if (!mounted) return;
      final destination = context.read<SplashCubit>().state;
      final canBrowse =
          destination is SplashAuthenticated || destination is SplashGuest;
      final route = canBrowse ? BaseScreen.routeName : LoginScreen.routeName;
      context.go(route);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 130.w),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.15),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Image.asset(isDark ? Assets.logo : Assets.logo),
              );
            },
          ),
        ),
      ),
    );
  }
}
