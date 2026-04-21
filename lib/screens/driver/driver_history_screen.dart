import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';

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
                      'Trip History',
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
                child: ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: trips.length,
                  itemBuilder: (context, index) {
                    final trip = trips[index];
                    final showDateHeader =
                        index == 0 || trips[index - 1].date != trip.date;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showDateHeader) ...[
                          if (index > 0) const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              trip.date,
                              style: TextStyle(
                                color: AppColors.driverAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                        Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.08),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: AppColors.green.withValues(
                                        alpha: 0.15,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: AppColors.green,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${trip.pickup} → ${trip.dropoff}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              trip.time,
                                              style: const TextStyle(
                                                color: Colors.white54,
                                                fontSize: 11,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Row(
                                              children: List.generate(
                                                trip.rating,
                                                (_) => const Icon(
                                                  Icons.star,
                                                  size: 10,
                                                  color: AppColors.yellow,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '₱${trip.fare}',
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
                            .fadeIn(delay: (index * 60).ms, duration: 400.ms)
                            .slideX(begin: -0.1, end: 0),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
