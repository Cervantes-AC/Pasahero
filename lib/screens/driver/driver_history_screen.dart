import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/ph_widgets.dart';

class DriverHistoryScreen extends StatelessWidget {
  const DriverHistoryScreen({super.key});

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

    return Scaffold(
      backgroundColor: AppColors.driverBg,
      body: SafeArea(
        child: Column(
          children: [
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
                  const Text(
                    'Trip History',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 350.ms),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: trips.length,
                itemBuilder: (context, i) {
                  final t = trips[i];
                  final showHeader = i == 0 || trips[i - 1].date != t.date;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showHeader) ...[
                        if (i > 0) const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            t.date,
                            style: TextStyle(
                              color: AppColors.driverAccent,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                      Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.driverSurface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.driverBorder),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withValues(
                                      alpha: 0.12,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: AppColors.success,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${t.pickup} → ${t.dropoff}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        children: [
                                          Text(
                                            t.time,
                                            style: const TextStyle(
                                              color: AppColors.driverTextMuted,
                                              fontSize: 11,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Row(
                                            children: List.generate(
                                              t.rating,
                                              (_) => const Icon(
                                                Icons.star_rounded,
                                                size: 10,
                                                color: AppColors.amber,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '₱${t.fare}',
                                  style: TextStyle(
                                    color: AppColors.driverAccent,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
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
