import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../data/app_state.dart';
import '../../widgets/ph_widgets.dart';
import '../../widgets/toast.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});
  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen>
    with SingleTickerProviderStateMixin {
  bool _online = false;
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _online = !_online);
    AppState.instance.driverStatus = _online
        ? DriverStatus.online
        : DriverStatus.offline;
    showToast(
      context,
      _online ? 'You are now online!' : 'You are now offline.',
    );
    if (_online) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _online) {
          AppState.instance.pendingRequest = mockRideRequest;
          context.go('/driver-request');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final earnings = AppState.instance.dailyEarnings;
    final trips = AppState.instance.dailyTrips;
    final rating = AppState.instance.driverRating;

    return Scaffold(
      backgroundColor: AppColors.driverBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.driverAccent.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'PS',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pedro Santos',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 12,
                              color: AppColors.amber,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '$rating · Habal-habal',
                              style: const TextStyle(
                                color: AppColors.driverTextMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PhIconButton(
                    icon: Icons.settings_outlined,
                    onTap: () => context.go('/driver-profile'),
                    color: Colors.white.withValues(alpha: 0.08),
                    iconColor: Colors.white,
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 350.ms),

            const SizedBox(height: 20),

            // Online toggle
            Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: _toggle,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: _online
                            ? AppColors.success.withValues(alpha: 0.12)
                            : AppColors.driverSurface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: _online
                              ? AppColors.success.withValues(alpha: 0.4)
                              : AppColors.driverBorder,
                        ),
                      ),
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              if (_online)
                                AnimatedBuilder(
                                  animation: _pulse,
                                  builder: (_, __) => Container(
                                    width: 52 + 18 * _pulse.value,
                                    height: 52 + 18 * _pulse.value,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.success.withValues(
                                        alpha: 0.12 * (1 - _pulse.value),
                                      ),
                                    ),
                                  ),
                                ),
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: _online
                                      ? AppColors.success
                                      : AppColors.driverBorder,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _online
                                      ? Icons.wifi_rounded
                                      : Icons.wifi_off_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _online ? "You're Online" : "You're Offline",
                                  style: TextStyle(
                                    color: _online
                                        ? AppColors.success
                                        : Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _online
                                      ? 'Waiting for ride requests...'
                                      : 'Tap to start accepting rides',
                                  style: const TextStyle(
                                    color: AppColors.driverTextMuted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _online,
                            onChanged: (_) => _toggle(),
                            activeColor: AppColors.success,
                            activeTrackColor: AppColors.success.withValues(
                              alpha: 0.25,
                            ),
                            inactiveThumbColor: AppColors.driverTextMuted,
                            inactiveTrackColor: AppColors.driverBorder,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 80.ms, duration: 350.ms)
                .slideY(begin: 0.1, end: 0),

            const SizedBox(height: 20),

            // Stats
            Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "TODAY'S SUMMARY",
                        style: TextStyle(
                          color: AppColors.driverTextMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.driverAccent.withValues(
                                      alpha: 0.2,
                                    ),
                                    AppColors.driverAccent.withValues(
                                      alpha: 0.06,
                                    ),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.driverAccent.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.monetization_on_outlined,
                                        color: AppColors.driverAccent,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        'Earnings',
                                        style: TextStyle(
                                          color: AppColors.driverTextMuted,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '₱${earnings.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: AppColors.driverAccent,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '$trips trips completed',
                                    style: const TextStyle(
                                      color: AppColors.driverTextMuted,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              children: [
                                PhStatBox(
                                  value: '$rating',
                                  label: 'Rating',
                                  valueColor: AppColors.amber,
                                  dark: true,
                                ),
                                const SizedBox(height: 10),
                                PhStatBox(
                                  value: '6.5h',
                                  label: 'Hours',
                                  dark: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(delay: 160.ms, duration: 350.ms)
                .slideY(begin: 0.1, end: 0),

            const SizedBox(height: 20),

            // Quick actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _QuickBtn(
                    icon: Icons.history_rounded,
                    label: 'History',
                    onTap: () => context.go('/driver-history'),
                  ),
                  const SizedBox(width: 10),
                  _QuickBtn(
                    icon: Icons.bar_chart_rounded,
                    label: 'Earnings',
                    onTap: () => context.go('/driver-earnings'),
                  ),
                  const SizedBox(width: 10),
                  _QuickBtn(
                    icon: Icons.person_outline,
                    label: 'Profile',
                    onTap: () => context.go('/driver-profile'),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 240.ms, duration: 350.ms),

            const Spacer(),

            // Recent trips
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                children: [
                  PhSectionHeader(
                    title: 'Recent Trips',
                    action: 'See all',
                    onAction: () => context.go('/driver-history'),
                    dark: true,
                  ),
                  const SizedBox(height: 10),
                  _TripRow(
                    pickup: 'SM City Cebu',
                    dropoff: 'Ayala Center',
                    fare: 65,
                    time: '2:30 PM',
                  ),
                  const SizedBox(height: 8),
                  _TripRow(
                    pickup: 'IT Park',
                    dropoff: 'Guadalupe',
                    fare: 48,
                    time: '11:15 AM',
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 300.ms, duration: 350.ms),
          ],
        ),
      ),
    );
  }
}

class _QuickBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickBtn({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.driverSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.driverBorder),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white70, size: 20),
              const SizedBox(height: 5),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.driverTextMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TripRow extends StatelessWidget {
  final String pickup, dropoff, time;
  final int fare;
  const _TripRow({
    required this.pickup,
    required this.dropoff,
    required this.fare,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.driverSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.driverBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.success,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$pickup → $dropoff',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  time,
                  style: const TextStyle(
                    color: AppColors.driverTextMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₱$fare',
            style: TextStyle(
              color: AppColors.driverAccent,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
