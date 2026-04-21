import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../data/app_state.dart';

class DriverEarningsScreen extends StatelessWidget {
  const DriverEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final earnings = AppState.instance.dailyEarnings;
    final trips = AppState.instance.dailyTrips;

    final weeklyData = [
      (day: 'Mon', amount: 620.0, trips: 9),
      (day: 'Tue', amount: 780.0, trips: 11),
      (day: 'Wed', amount: 540.0, trips: 8),
      (day: 'Thu', amount: 920.0, trips: 14),
      (day: 'Fri', amount: 1100.0, trips: 16),
      (day: 'Sat', amount: 1350.0, trips: 19),
      (day: 'Sun', amount: earnings, trips: trips),
    ];

    final maxAmount = weeklyData
        .map((d) => d.amount)
        .reduce((a, b) => a > b ? a : b);
    final weeklyTotal = weeklyData.fold<double>(0, (sum, d) => sum + d.amount);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.driverGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.go('/driver-home'),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Earnings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Weekly total card
                      Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.driverAccent.withValues(
                                    alpha: 0.25,
                                  ),
                                  AppColors.driverAccent.withValues(
                                    alpha: 0.08,
                                  ),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.driverAccent.withValues(
                                  alpha: 0.4,
                                ),
                              ),
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
                                        const Text(
                                          'This Week',
                                          style: TextStyle(
                                            color: Colors.white60,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '₱${weeklyTotal.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color: AppColors.driverAccent,
                                            fontSize: 32,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.green.withValues(
                                          alpha: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: AppColors.green.withValues(
                                            alpha: 0.4,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.trending_up,
                                            color: AppColors.green,
                                            size: 14,
                                          ),
                                          const SizedBox(width: 4),
                                          const Text(
                                            '+12%',
                                            style: TextStyle(
                                              color: AppColors.green,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    _WeekStat(
                                      label: 'Total Trips',
                                      value:
                                          '${weeklyData.fold<int>(0, (s, d) => s + d.trips)}',
                                      icon: Icons.two_wheeler,
                                    ),
                                    const SizedBox(width: 12),
                                    _WeekStat(
                                      label: 'Avg/Trip',
                                      value:
                                          '₱${(weeklyTotal / weeklyData.fold<int>(0, (s, d) => s + d.trips)).toStringAsFixed(0)}',
                                      icon: Icons.monetization_on_outlined,
                                    ),
                                    const SizedBox(width: 12),
                                    _WeekStat(
                                      label: 'Best Day',
                                      value: '₱1,350',
                                      icon: Icons.emoji_events_outlined,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 100.ms, duration: 400.ms)
                          .slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 24),

                      // Bar chart
                      Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
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
                                  height: 140,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: weeklyData.asMap().entries.map((
                                      entry,
                                    ) {
                                      final i = entry.key;
                                      final d = entry.value;
                                      final isToday =
                                          i == weeklyData.length - 1;
                                      final barHeight =
                                          (d.amount / maxAmount) * 120;
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 4,
                                                      ),
                                                  child: Text(
                                                    '₱${d.amount.toStringAsFixed(0)}',
                                                    style: TextStyle(
                                                      color: AppColors
                                                          .driverAccent,
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              AnimatedContainer(
                                                duration: Duration(
                                                  milliseconds: 600 + i * 80,
                                                ),
                                                height: barHeight,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: isToday
                                                        ? [
                                                            AppColors
                                                                .driverAccent,
                                                            AppColors
                                                                .yellowDark,
                                                          ]
                                                        : [
                                                            AppColors.primary
                                                                .withValues(
                                                                  alpha: 0.8,
                                                                ),
                                                            AppColors
                                                                .primaryDark,
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
                                                      : Colors.white54,
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
                          .fadeIn(delay: 200.ms, duration: 400.ms)
                          .slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 24),

                      // Today's breakdown
                      Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
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
                                        color: Colors.white54,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                ...[
                                  (
                                    'SM City Cebu',
                                    'Ayala Center',
                                    65,
                                    '2:30 PM',
                                  ),
                                  ('IT Park', 'Guadalupe', 48, '11:15 AM'),
                                  ('Capitol Site', 'Mabolo', 55, '9:00 AM'),
                                ].asMap().entries.map((entry) {
                                  final i = entry.key;
                                  final t = entry.value;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: AppColors.green.withValues(
                                              alpha: 0.15,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${i + 1}',
                                              style: const TextStyle(
                                                color: AppColors.green,
                                                fontWeight: FontWeight.w700,
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
                                                  color: Colors.white54,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '₱${t.$3}',
                                          style: TextStyle(
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
                          .fadeIn(delay: 300.ms, duration: 400.ms)
                          .slideY(begin: 0.2, end: 0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeekStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _WeekStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white54, size: 16),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white38, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
