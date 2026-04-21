import 'package:go_router/go_router.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/search_ride_screen.dart';
import 'screens/driver_list_screen.dart';
import 'screens/driver_detail_screen.dart';
import 'screens/ride_tracking_screen.dart';
import 'screens/ride_ongoing_screen.dart';
import 'screens/ride_complete_screen.dart';
import 'screens/ride_history_screen.dart';
import 'screens/saved_locations_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/driver/driver_login_screen.dart';
import 'screens/driver/driver_register_screen.dart';
import 'screens/driver/driver_home_screen.dart';
import 'screens/driver/driver_request_screen.dart';
import 'screens/driver/driver_active_trip_screen.dart';
import 'screens/driver/driver_earnings_screen.dart';
import 'screens/driver/driver_profile_screen.dart';
import 'screens/driver/driver_history_screen.dart';
import 'widgets/root_layout.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // ── Shared ──────────────────────────────────────────────────────────────
    GoRoute(path: '/', builder: (_, _s) => const WelcomeScreen()),

    // ── Passenger auth ───────────────────────────────────────────────────────
    GoRoute(path: '/login', builder: (_, _s) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, _s) => const RegisterScreen()),

    // ── Passenger ride flow ──────────────────────────────────────────────────
    GoRoute(
      path: '/search',
      builder: (_, state) {
        final type = state.uri.queryParameters['type'] ?? 'habal-habal';
        return SearchRideScreen(rideType: type);
      },
    ),
    GoRoute(
      path: '/drivers',
      builder: (_, state) {
        final type = state.uri.queryParameters['type'] ?? 'habal-habal';
        return DriverListScreen(rideType: type);
      },
    ),
    GoRoute(
      path: '/driver-detail',
      builder: (_, state) {
        final id = state.uri.queryParameters['id'] ?? '1';
        return DriverDetailScreen(driverId: id);
      },
    ),
    GoRoute(path: '/tracking', builder: (_, _s) => const RideTrackingScreen()),
    GoRoute(path: '/ongoing', builder: (_, _s) => const RideOngoingScreen()),
    GoRoute(path: '/complete', builder: (_, _s) => const RideCompleteScreen()),

    // ── Passenger shell (bottom nav) ─────────────────────────────────────────
    ShellRoute(
      builder: (context, state, child) => RootLayout(child: child),
      routes: [
        GoRoute(path: '/home', builder: (_, _s) => const HomeScreen()),
        GoRoute(
          path: '/ride-history',
          builder: (_, _s) => const RideHistoryScreen(),
        ),
        GoRoute(
          path: '/saved-locations',
          builder: (_, _s) => const SavedLocationsScreen(),
        ),
        GoRoute(path: '/profile', builder: (_, _s) => const ProfileScreen()),
      ],
    ),

    // ── Driver auth ──────────────────────────────────────────────────────────
    GoRoute(
      path: '/driver-login',
      builder: (_, _s) => const DriverLoginScreen(),
    ),
    GoRoute(
      path: '/driver-register',
      builder: (_, _s) => const DriverRegisterScreen(),
    ),

    // ── Driver app ───────────────────────────────────────────────────────────
    GoRoute(path: '/driver-home', builder: (_, _s) => const DriverHomeScreen()),
    GoRoute(
      path: '/driver-request',
      builder: (_, _s) => const DriverRequestScreen(),
    ),
    GoRoute(
      path: '/driver-active',
      builder: (_, _s) => const DriverActiveTripScreen(),
    ),
    GoRoute(
      path: '/driver-earnings',
      builder: (_, _s) => const DriverEarningsScreen(),
    ),
    GoRoute(
      path: '/driver-profile',
      builder: (_, _s) => const DriverProfileScreen(),
    ),
    GoRoute(
      path: '/driver-history',
      builder: (_, _s) => const DriverHistoryScreen(),
    ),
  ],
);
