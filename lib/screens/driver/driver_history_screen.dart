import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/ph_widgets.dart';

class DriverHistoryScreen extends StatefulWidget {
  const DriverHistoryScreen({super.key});

  @override
  State<DriverHistoryScreen> createState() => _DriverHistoryScreenState();
}

class _DriverHistoryScreenState extends State<DriverHistoryScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final trips = [
      (
        pickup: 'SM City Cebu',
        dropoff: 'Ayala Center Cebu',
        fare: 65,
        time: '2:30 PM',
        date: 'Today',
        rating: 5,
      ),
      (
        pickup: 'IT Park, Lahug',
        dropoff: 'Guadalupe',
        fare: 48,
        time: '11:15 AM',
        date: 'Today',
        rating: 5,
      ),
      (
        pickup: 'Capitol Site',
        dropoff: 'Mabolo',
        fare: 55,
        time: '9:00 AM',
        date: 'Today',
        rating: 4,
      ),
      (
        pickup: 'Colon Street',
        dropoff: 'Carbon Market',
        fare: 35,
        time: '3:20 PM',
        date: 'Yesterday',
        rating: 5,
      ),
      (
        pickup: 'Banilad Town Centre',
        dropoff: 'SM Seaside',
        fare: 80,
        time: '1:00 PM',
        date: 'Yesterday',
        rating: 5,
      ),
      (
        pickup: 'Talamban',
        dropoff: 'IT Park',
        fare: 70,
        time: '8:30 AM',
        date: 'Mar 5, 2026',
        rating: 4,
      ),
    ];

    final totalFare = trips.fold<int>(0, (s, t) => s + t.fare);

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
                          'Trip History',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          'All your completed rides',
                          style: TextStyle(
                            color: AppColors.driverTextMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.driverAccent.withValues(alpha: 0.2),
                          AppColors.driverAccent.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.driverAccent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.driverAccent,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${trips.length}',
                          style: const TextStyle(
                            color: AppColors.driverAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 350.ms).slideY(begin: -0.1, end: 0),

            const SizedBox(height: 12),

            // ── Summary strip ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.driverSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.driverBorder),
                ),
                child: Row(
                  children: [
                    _SummaryItem(
                      label: 'Total Trips',
                      value: '${trips.length}',
                      color: AppColors.primary,
                    ),
                    _Divider(),
                    _SummaryItem(
                      label: 'Total Earned',
                      value: '₱$totalFare',
                      color: AppColors.driverAccent,
                    ),
                    _Divider(),
                    _SummaryItem(
                      label: 'Avg Rating',
                      value: '4.8 ★',
                      color: AppColors.amber,
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 60.ms, duration: 350.ms),

            const SizedBox(height: 12),

            // ── Filter chips ─────────────────────────────────────────────────
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: ['All', 'Today', 'This Week', 'This Month'].map((
                  filter,
                ) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedFilter = filter),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? const LinearGradient(
                                  colors: [
                                    AppColors.driverAccent,
                                    AppColors.driverAccentDark,
                                  ],
                                )
                              : null,
                          color: isSelected ? null : AppColors.driverSurface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.driverAccent
                                : AppColors.driverBorder,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.driverAccent.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 8,
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.driverBg
                                : Colors.white,
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ).animate().fadeIn(delay: 100.ms, duration: 350.ms),

            const SizedBox(height: 8),

            // ── Trip list ────────────────────────────────────────────────────
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                itemCount: trips.length,
                itemBuilder: (context, i) {
                  final t = trips[i];
                  final showHeader = i == 0 || trips[i - 1].date != t.date;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showHeader) ...[
                        if (i > 0) const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.driverAccent.withValues(alpha: 0.15),
                                AppColors.driverAccent.withValues(alpha: 0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.driverAccent.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                color: AppColors.driverAccent,
                                size: 12,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                t.date,
                                style: const TextStyle(
                                  color: AppColors.driverAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.driverSurface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.driverBorder),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.success,
                                        Color(0xFF15803D),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.success.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${t.pickup} → ${t.dropoff}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: -0.2,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_rounded,
                                            color: AppColors.driverTextMuted,
                                            size: 12,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            t.time,
                                            style: const TextStyle(
                                              color: AppColors.driverTextMuted,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          ...List.generate(
                                            t.rating,
                                            (_) => const Icon(
                                              Icons.star_rounded,
                                              size: 12,
                                              color: AppColors.amber,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '₱${t.fare}',
                                      style: const TextStyle(
                                        color: AppColors.driverAccent,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 18,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.success.withValues(
                                          alpha: 0.15,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'Done',
                                        style: TextStyle(
                                          color: AppColors.success,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                          .animate()
                          .fadeIn(delay: (i * 50).ms, duration: 350.ms)
                          .slideX(begin: -0.05, end: 0),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label, value;
  final Color color;
  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.driverTextMuted,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 32, color: AppColors.driverBorder);
  }
}
