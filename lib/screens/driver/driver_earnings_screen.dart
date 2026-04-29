import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../data/app_state.dart';
import '../../widgets/ph_widgets.dart';

class DriverEarningsScreen extends StatefulWidget {
  const DriverEarningsScreen({super.key});

  @override
  State<DriverEarningsScreen> createState() => _DriverEarningsScreenState();
}

class _DriverEarningsScreenState extends State<DriverEarningsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmer;

  @override
  void initState() {
    super.initState();
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final earnings = AppState.instance.dailyEarnings;
    final trips = AppState.instance.dailyTrips;

    final week = [
      (day: 'Mon', amount: 620.0, trips: 9),
      (day: 'Tue', amount: 780.0, trips: 11),
      (day: 'Wed', amount: 540.0, trips: 8),
      (day: 'Thu', amount: 920.0, trips: 14),
      (day: 'Fri', amount: 1100.0, trips: 16),
      (day: 'Sat', amount: 1350.0, trips: 19),
      (day: 'Sun', amount: earnings, trips: trips),
    ];

    final maxAmt = week.map((d) => d.amount).reduce((a, b) => a > b ? a : b);
    final weekTotal = week.fold<double>(0, (s, d) => s + d.amount);
    final weekTrips = week.fold<int>(0, (s, d) => s + d.trips);

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
                  PhIconButton(
                    icon: Icons.arrow_back,
                    onTap: () => context.go('/driver-home'),
                    color: Colors.white.withValues(alpha: 0.1),
                    iconColor: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Earnings',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          'Your financial overview',
                          style: TextStyle(
                            color: AppColors.driverTextMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 350.ms),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // ── Weekly total card ────────────────────────────────────
                    Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.driverAccent.withValues(alpha: 0.25),
                                AppColors.driverAccent.withValues(alpha: 0.08),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.driverAccent.withValues(
                                alpha: 0.4,
                              ),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.driverAccent.withValues(
                                  alpha: 0.2,
                                ),
                                blurRadius: 24,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  AppColors.driverAccent,
                                                  AppColors.driverAccentDark,
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.calendar_today_rounded,
                                              color: AppColors.driverBg,
                                              size: 16,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'This Week',
                                            style: TextStyle(
                                              color: AppColors.driverTextMuted,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      AnimatedBuilder(
                                        animation: _shimmer,
                                        builder: (_, __) => ShaderMask(
                                          shaderCallback: (bounds) =>
                                              LinearGradient(
                                                colors: [
                                                  AppColors.driverAccent,
                                                  AppColors.driverAccent
                                                      .withValues(alpha: 0.8),
                                                  AppColors.driverAccent,
                                                ],
                                                stops: [
                                                  (_shimmer.value - 0.3).clamp(
                                                    0.0,
                                                    1.0,
                                                  ),
                                                  _shimmer.value.clamp(
                                                    0.0,
                                                    1.0,
                                                  ),
                                                  (_shimmer.value + 0.3).clamp(
                                                    0.0,
                                                    1.0,
                                                  ),
                                                ],
                                              ).createShader(bounds),
                                          child: Text(
                                            '₱${weekTotal.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              color: AppColors.driverAccent,
                                              fontSize: 36,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: -1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.success,
                                              AppColors.success.withValues(
                                                alpha: 0.8,
                                              ),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.success
                                                  .withValues(alpha: 0.3),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.trending_up_rounded,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '+12%',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      const Text(
                                        'vs last week',
                                        style: TextStyle(
                                          color: AppColors.driverTextMuted,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  _WStat(
                                    label: 'Total Trips',
                                    value: '$weekTrips',
                                    icon: Icons.two_wheeler_rounded,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 12),
                                  _WStat(
                                    label: 'Avg/Trip',
                                    value:
                                        '₱${(weekTotal / weekTrips).toStringAsFixed(0)}',
                                    icon: Icons.monetization_on_rounded,
                                    color: AppColors.success,
                                  ),
                                  const SizedBox(width: 12),
                                  _WStat(
                                    label: 'Best Day',
                                    value: '₱1,350',
                                    icon: Icons.emoji_events_rounded,
                                    color: AppColors.amber,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 80.ms, duration: 400.ms)
                        .slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 16),

                    // ── Bar chart ────────────────────────────────────────────
                    PhDriverCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Daily Breakdown',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 130,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: week.asMap().entries.map((e) {
                                    final i = e.key;
                                    final d = e.value;
                                    final isToday = i == week.length - 1;
                                    final h = (d.amount / maxAmt) * 110;
                                    return Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 3,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            if (isToday)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 4,
                                                ),
                                                child: Text(
                                                  '₱${d.amount.toStringAsFixed(0)}',
                                                  style: const TextStyle(
                                                    color:
                                                        AppColors.driverAccent,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            AnimatedContainer(
                                              duration: Duration(
                                                milliseconds: 500 + i * 80,
                                              ),
                                              height: h,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: isToday
                                                      ? [
                                                          AppColors
                                                              .driverAccent,
                                                          AppColors
                                                              .driverAccentDark,
                                                        ]
                                                      : [
                                                          AppColors.primary
                                                              .withValues(
                                                                alpha: 0.7,
                                                              ),
                                                          AppColors.primaryDark,
                                                        ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              d.day,
                                              style: TextStyle(
                                                color: isToday
                                                    ? AppColors.driverAccent
                                                    : AppColors.driverTextMuted,
                                                fontSize: 11,
                                                fontWeight: isToday
                                                    ? FontWeight.w700
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 160.ms, duration: 350.ms)
                        .slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 16),

                    // ── Today's trips ────────────────────────────────────────
                    PhDriverCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Today's Trips",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    '$trips trips',
                                    style: const TextStyle(
                                      color: AppColors.driverTextMuted,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              ...[
                                ('SM City Cebu', 'Ayala Center', 65, '2:30 PM'),
                                ('IT Park', 'Guadalupe', 48, '11:15 AM'),
                                ('Capitol Site', 'Mabolo', 55, '9:00 AM'),
                              ].asMap().entries.map((e) {
                                final t = e.value;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 34,
                                        height: 34,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.success,
                                              AppColors.success.withValues(
                                                alpha: 0.7,
                                              ),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${e.key + 1}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${t.$1} → ${t.$2}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              t.$4,
                                              style: const TextStyle(
                                                color:
                                                    AppColors.driverTextMuted,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '₱${t.$3}',
                                        style: const TextStyle(
                                          color: AppColors.driverAccent,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 240.ms, duration: 350.ms)
                        .slideY(begin: 0.1, end: 0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WStat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _WStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.15),
              color.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 14),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.driverTextMuted,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
