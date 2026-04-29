import 'package:go_router/go_router.dart';
import 'screens/shared/welcome_screen.dart';
import 'screens/passenger/login_screen.dart';
import 'screens/passenger/register_screen.dart';
import 'screens/passenger/home_screen.dart';
import 'screens/passenger/search_ride_screen.dart';
import 'screens/passenger/driver_list_screen.dart';
import 'screens/passenger/driver_detail_screen.dart';
import 'screens/passenger/ride_tracking_screen.dart';
import 'screens/passenger/ride_ongoing_screen.dart';
import 'screens/passenger/ride_complete_screen.dart';
import 'screens/passenger/ride_history_screen.dart';
import 'screens/passenger/saved_locations_screen.dart';
import 'screens/passenger/profile_screen.dart';
import 'screens/passenger/edit_profile_screen.dart';
import 'screens/passenger/wallet_screen.dart';
import 'screens/passenger/wallet_cash_in_screen.dart';
import 'screens/passenger/wallet_history_screen.dart';
import 'screens/shared/location_sharing_screen.dart';
import 'screens/driver/driver_login_screen.dart';
import 'screens/driver/driver_register_screen.dart';
import 'screens/driver/driver_home_screen.dart';
import 'screens/driver/driver_request_screen.dart';
import 'screens/driver/driver_active_trip_screen.dart';
import 'screens/driver/driver_earnings_screen.dart';
import 'screens/driver/driver_profile_screen.dart';
import 'screens/driver/driver_history_screen.dart';
import 'screens/driver/driver_ratings_screen.dart';
import 'screens/driver/driver_wallet_screen.dart';
import 'screens/driver/driver_wallet_withdraw_screen.dart';
import 'screens/driver/driver_wallet_history_screen.dart';
import 'screens/driver/driver_wallet_cash_in_screen.dart';
import 'screens/passenger/notifications_screen.dart';
import 'widgets/root_layout.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // ── Shared ──────────────────────────────────────────────────────────────
    GoRoute(path: '/', builder: (ctx, s) => const WelcomeScreen()),

    // ── Passenger auth ───────────────────────────────────────────────────────
    GoRoute(path: '/login', builder: (ctx, s) => const LoginScreen()),
    GoRoute(path: '/register', builder: (ctx, s) => const RegisterScreen()),

    // ── Passenger ride flow ──────────────────────────────────────────────────
    GoRoute(
      path: '/search',
      builder: (ctx, state) {
        final type = state.uri.queryParameters['type'] ?? 'habal-habal';
        return SearchRideScreen(rideType: type);
      },
    ),
    GoRoute(
      path: '/drivers',
      builder: (ctx, state) {
        final type = state.uri.queryParameters['type'] ?? 'habal-habal';
        return DriverListScreen(rideType: type);
      },
    ),
    GoRoute(
      path: '/driver-detail',
      builder: (ctx, state) {
        final id = state.uri.queryParameters['id'] ?? '1';
        return DriverDetailScreen(driverId: id);
      },
    ),
    GoRoute(path: '/tracking', builder: (ctx, s) => const RideTrackingScreen()),
    GoRoute(path: '/ongoing', builder: (ctx, s) => const RideOngoingScreen()),
    GoRoute(path: '/complete', builder: (ctx, s) => const RideCompleteScreen()),
    GoRoute(
      path: '/location-sharing',
      builder: (ctx, s) => const LocationSharingScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (ctx, s) => const NotificationsScreen(),
    ),

    // ── Passenger shell (bottom nav) ─────────────────────────────────────────
    ShellRoute(
      builder: (context, state, child) => RootLayout(child: child),
      routes: [
        GoRoute(path: '/home', builder: (ctx, s) => const HomeScreen()),
        GoRoute(
          path: '/ride-history',
          builder: (ctx, s) => const RideHistoryScreen(),
        ),
        GoRoute(
          path: '/wallet',
          builder: (ctx, s) => const PassengerWalletScreen(),
        ),
        GoRoute(
          path: '/saved-locations',
          builder: (ctx, s) => const SavedLocationsScreen(),
        ),
        GoRoute(path: '/profile', builder: (ctx, s) => const ProfileScreen()),
        GoRoute(
          path: '/edit-profile',
          builder: (ctx, s) => const EditProfileScreen(),
        ),
      ],
    ),

    // ── Driver auth ──────────────────────────────────────────────────────────
    GoRoute(
      path: '/driver-login',
      builder: (ctx, s) => const DriverLoginScreen(),
    ),
    GoRoute(
      path: '/driver-register',
      builder: (ctx, s) => const DriverRegisterScreen(),
    ),

    // ── Driver app ───────────────────────────────────────────────────────────
    GoRoute(
      path: '/driver-home',
      builder: (ctx, s) => const DriverHomeScreen(),
    ),
    GoRoute(
      path: '/driver-request',
      builder: (ctx, s) => const DriverRequestScreen(),
    ),
    GoRoute(
      path: '/driver-active',
      builder: (ctx, s) => const DriverActiveTripScreen(),
    ),
    GoRoute(
      path: '/driver-earnings',
      builder: (ctx, s) => const DriverEarningsScreen(),
    ),
    GoRoute(
      path: '/driver-profile',
      builder: (ctx, s) => const DriverProfileScreen(),
    ),
    GoRoute(
      path: '/driver-history',
      builder: (ctx, s) => const DriverHistoryScreen(),
    ),
    GoRoute(
      path: '/driver-ratings',
      builder: (ctx, s) => const DriverRatingsScreen(),
    ),

    // ── Passenger wallet (standalone) ────────────────────────────────────────
    GoRoute(
      path: '/wallet-cash-in',
      builder: (ctx, s) => const WalletCashInScreen(),
    ),
    GoRoute(
      path: '/wallet-history',
      builder: (ctx, s) => const WalletHistoryScreen(),
    ),

    // ── Driver wallet ────────────────────────────────────────────────────────
    GoRoute(
      path: '/driver-wallet',
      builder: (ctx, s) => const DriverWalletScreen(),
    ),
    GoRoute(
      path: '/driver-wallet-cash-in',
      builder: (ctx, s) => const DriverWalletCashInScreen(),
    ),
    GoRoute(
      path: '/driver-wallet-withdraw',
      builder: (ctx, s) => const DriverWalletWithdrawScreen(),
    ),
    GoRoute(
      path: '/driver-wallet-history',
      builder: (ctx, s) => const DriverWalletHistoryScreen(),
    ),
  ],
);
