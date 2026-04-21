import 'package:flutter/material.dart';
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
import 'widgets/root_layout.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const WelcomeScreen()),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
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
    GoRoute(path: '/tracking', builder: (_, __) => const RideTrackingScreen()),
    GoRoute(path: '/ongoing', builder: (_, __) => const RideOngoingScreen()),
    GoRoute(path: '/complete', builder: (_, __) => const RideCompleteScreen()),
    ShellRoute(
      builder: (context, state, child) => RootLayout(child: child),
      routes: [
        GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
        GoRoute(
          path: '/ride-history',
          builder: (_, __) => const RideHistoryScreen(),
        ),
        GoRoute(
          path: '/saved-locations',
          builder: (_, __) => const SavedLocationsScreen(),
        ),
        GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      ],
    ),
  ],
);
