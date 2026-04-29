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
    with TickerProviderStateMixin {
  bool _online = false;
  late AnimationController _pulse;
  late AnimationController _breathe;
  late AnimationController _shimmer;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _breathe = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulse.dispose();
    _breathe.dispose();
    _shimmer.dispose();
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
            // ── Header ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.driverAccent, Color(0xFFFFB300)],
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.driverAccent.withValues(
                              alpha: 0.3,
                            ),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.driverAccent.withValues(
                                alpha: 0.2,
                              ),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'PS',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      if (_online)
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.driverBg,
                                width: 2.5,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pedro Santos',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.driverAccent.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: AppColors.driverAccent.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    color: AppColors.driverAccent,
                                    size: 14,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '4.9',
                                    style: TextStyle(
                                      color: AppColors.driverAccent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Habal-habal',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PhIconButton(
                    icon: Icons.settings_rounded,
                    onTap: () => context.go('/driver-profile'),
                    color: Colors.white.withValues(alpha: 0.08),
                    iconColor: Colors.white,
                    size: 48,
                    bordered: true,
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),

            const SizedBox(height: 20),

            // ── Online Toggle ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: PhCard(
                onTap: _toggle,
                padding: const EdgeInsets.all(24),
                color: _online
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.driverSurface,
                bordered: true,
                borderRadius: 24,
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        if (_online)
                          AnimatedBuilder(
                            animation: _pulse,
                            builder: (_, __) => Container(
                              width: 64 + 32 * _pulse.value,
                              height: 64 + 32 * _pulse.value,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.success.withValues(
                                  alpha: 0.15 * (1 - _pulse.value),
                                ),
                              ),
                            ),
                          ),
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            gradient: _online
                                ? const LinearGradient(
                                    colors: [
                                      AppColors.success,
                                      Color(0xFF059669),
                                    ],
                                  )
                                : null,
                            color: _online ? null : AppColors.driverBorder,
                            shape: BoxShape.circle,
                            boxShadow: _online
                                ? [
                                    BoxShadow(
                                      color: AppColors.success.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(
                            _online
                                ? Icons.power_settings_new_rounded
                                : Icons.power_off_rounded,
                            color: _online
                                ? Colors.white
                                : AppColors.driverTextMuted,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _online ? 'You are ONLINE' : 'You are OFFLINE',
                            style: TextStyle(
                              color: _online ? AppColors.success : Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _online
                                ? 'Waiting for ride requests...'
                                : 'Go online to start earning',
                            style: TextStyle(
                              color: _online
                                  ? AppColors.success.withValues(alpha: 0.7)
                                  : AppColors.driverTextMuted,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _online,
                      onChanged: (_) => _toggle(),
                      activeThumbColor: AppColors.success,
                      activeTrackColor: AppColors.success.withValues(
                        alpha: 0.2,
                      ),
                      inactiveThumbColor: AppColors.driverTextMuted,
                      inactiveTrackColor: AppColors.driverBorder,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Stats ────────────────────────────────────────────────────────
            Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "TODAY'S PERFORMANCE",
                            style: TextStyle(
                              color: AppColors.driverTextMuted,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.success.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.trending_up_rounded,
                                  color: AppColors.success,
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  '+12%',
                                  style: TextStyle(
                                    color: AppColors.success,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Earnings card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.driverAccent.withValues(alpha: 0.25),
                              AppColors.driverAccent.withValues(alpha: 0.08),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AppColors.driverAccent.withValues(
                              alpha: 0.4,
                            ),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.driverAccent.withValues(
                                alpha: 0.15,
                              ),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.driverAccent,
                                        AppColors.driverAccentDark,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.driverAccent
                                            .withValues(alpha: 0.3),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.monetization_on_rounded,
                                    color: AppColors.driverBg,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    'Total Earnings',
                                    style: TextStyle(
                                      color: AppColors.driverTextMuted,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withValues(
                                      alpha: 0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.success.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'vs yesterday',
                                    style: TextStyle(
                                      color: AppColors.success,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '₱${earnings.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: AppColors.driverAccent,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -1,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    'PHP',
                                    style: TextStyle(
                                      color: AppColors.driverAccent,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.route_rounded,
                                  color: AppColors.driverTextMuted,
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '$trips trips completed today',
                                  style: const TextStyle(
                                    color: AppColors.driverTextMuted,
                                    fontSize: 13,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${(earnings / (trips > 0 ? trips : 1)).toStringAsFixed(0)} avg/trip',
                                  style: const TextStyle(
                                    color: AppColors.driverTextMuted,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Mini stat cards
                      Row(
                        children: [
                          Expanded(
                            child: _MiniStat(
                              icon: Icons.star_rounded,
                              iconColor: AppColors.amber,
                              label: 'Rating',
                              value: '$rating',
                              sub: 'Excellent',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _MiniStat(
                              icon: Icons.schedule_rounded,
                              iconColor: AppColors.primary,
                              label: 'Online',
                              value: '6.5h',
                              sub: 'Today',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _MiniStat(
                              icon: Icons.local_fire_department_rounded,
                              iconColor: AppColors.error,
                              label: 'Streak',
                              value: '${trips}d',
                              sub: 'Active',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(delay: 160.ms, duration: 400.ms)
                .slideY(begin: 0.1, end: 0),

            const SizedBox(height: 20),

            // ── Quick Actions ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'QUICK ACTIONS',
                    style: TextStyle(
                      color: AppColors.driverTextMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _ActionBtn(
                        icon: Icons.history_rounded,
                        label: 'Trip History',
                        sub: '$trips today',
                        color: AppColors.primary,
                        onTap: () => context.go('/driver-history'),
                      ),
                      const SizedBox(width: 12),
                      _ActionBtn(
                        icon: Icons.star_rounded,
                        label: 'Ratings',
                        sub: '$rating stars',
                        color: AppColors.amber,
                        onTap: () => context.go('/driver-ratings'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _ActionBtn(
                        icon: Icons.analytics_rounded,
                        label: 'Earnings',
                        sub: '₱${earnings.toStringAsFixed(0)}',
                        color: AppColors.success,
                        onTap: () => context.go('/driver-earnings'),
                      ),
                      const SizedBox(width: 12),
                      _ActionBtn(
                        icon: Icons.account_balance_wallet_rounded,
                        label: 'PasaWallet',
                        sub: 'My wallet',
                        color: AppColors.driverAccent,
                        onTap: () => context.go('/driver-wallet'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _ActionBtn(
                        icon: Icons.person_outline_rounded,
                        label: 'Profile',
                        sub: 'Verified',
                        color: AppColors.primary,
                        onTap: () => context.go('/driver-profile'),
                      ),
                      const SizedBox(width: 12),
                      _ActionBtn(
                        icon: Icons.account_balance_outlined,
                        label: 'Withdraw',
                        sub: 'Cash out',
                        color: AppColors.error,
                        onTap: () => context.go('/driver-wallet-withdraw'),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 240.ms, duration: 400.ms),

            const Spacer(),

            // ── Recent Trips ─────────────────────────────────────────────────
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

// ── Shared small widgets ──────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label, value, sub;
  const _MiniStat({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            iconColor.withValues(alpha: 0.15),
            iconColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 15),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: iconColor,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.driverTextMuted,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            sub,
            style: TextStyle(
              color: iconColor.withValues(alpha: 0.7),
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label, sub;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.sub,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.12),
                color.withValues(alpha: 0.06),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                sub,
                style: TextStyle(
                  color: color.withValues(alpha: 0.8),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
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
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.driverBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.success, Color(0xFF15803D)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$pickup → $dropoff',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
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
            style: const TextStyle(
              color: AppColors.driverAccent,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
