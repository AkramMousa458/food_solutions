import 'package:food_solutions/core/widgets/error_screen.dart';
import 'package:food_solutions/features/splash/presentation/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:food_solutions/features/base/presentation/screens/base_screen.dart';
import 'package:food_solutions/features/services/data/models/service_item_model.dart';
import 'package:food_solutions/features/services/presentation/screens/service_details_screen.dart';
import 'package:food_solutions/features/booking/presentation/screens/booking_screen.dart';
import 'package:food_solutions/features/contact/presentation/screens/contact_screen.dart';

abstract class AppRouter {
  static final router = GoRouter(
    initialLocation: SplashScreen.routeName,
    routes: [
      GoRoute(
        path: SplashScreen.routeName,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: ErrorScreen.routeName,
        builder: (context, state) => ErrorScreen(error: state.extra as String?),
      ),

      GoRoute(
        path: BaseScreen.routeName,
        builder: (context, state) => const BaseScreen(),
      ),
      GoRoute(
        path: ServiceDetailsScreen.routeName,
        builder: (context, state) =>
            ServiceDetailsScreen(service: state.extra as ServiceItemModel),
      ),
      GoRoute(
        path: BookingScreen.routeName,
        builder: (context, state) =>
            BookingScreen(initialService: state.extra as ServiceItemModel?),
      ),
      GoRoute(
        path: ContactScreen.routeName,
        builder: (context, state) => const ContactScreen(),
      ),
    ],
  );
}
