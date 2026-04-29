import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../data/mock_drivers.dart';

class DriverRatingsScreen extends StatelessWidget {
  const DriverRatingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final overallRating = 4.9;
    final totalReviews = mockReviews.length + 156; // Mock additional reviews

    // Calculate rating distribution
    final ratingCounts = {5: 142, 4: 18, 3: 2, 2: 1, 1: 0};

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
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.driverSurface,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.driverBorder),
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
                    'My Ratings & Reviews',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 350.ms),

            const SizedBox(height: 24),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overall rating card
                    Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.driverAccent.withValues(alpha: 0.2),
                                AppColors.driverAccent.withValues(alpha: 0.06),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: AppColors.driverAccent.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: AppColors.driverAccent.withValues(
                                        alpha: 0.2,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.star_rounded,
                                      color: AppColors.driverAccent,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '$overallRating',
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.driverAccent,
                                          ),
                                        ),
                                        const Text(
                                          'Overall Rating',
                                          style: TextStyle(
                                            color: AppColors.driverTextMuted,
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          'Based on $totalReviews reviews',
                                          style: const TextStyle(
                                            color: AppColors.driverTextMuted,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: List.generate(5, (i) {
                                  return Icon(
                                    Icons.star_rounded,
                                    color: AppColors.driverAccent,
                                    size: 20,
                                  );
                                }),
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 350.ms)
                        .slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 20),

                    // Rating breakdown
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.driverSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.driverBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rating Breakdown',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 14),
                          ...List.generate(5, (i) {
                            final stars = 5 - i;
                            final count = ratingCounts[stars] ?? 0;
                            final percentage = count / totalReviews;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Text(
                                    '$stars',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.star_rounded,
                                    color: AppColors.amber,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Container(
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: AppColors.driverBorder,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: FractionallySizedBox(
                                        alignment: Alignment.centerLeft,
                                        widthFactor: percentage,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.driverAccent,
                                            borderRadius: BorderRadius.circular(
                                              3,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '$count',
                                    style: const TextStyle(
                                      color: AppColors.driverTextMuted,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ).animate().fadeIn(delay: 80.ms, duration: 350.ms),

                    const SizedBox(height: 20),

                    // Recent reviews section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Reviews',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${mockReviews.length} of $totalReviews',
                          style: const TextStyle(
                            color: AppColors.driverTextMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Reviews list
                    ...mockReviews.asMap().entries.map((entry) {
                      final i = entry.key;
                      final review = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child:
                            Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.driverSurface,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: AppColors.driverBorder,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  review.passengerName,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  review.date,
                                                  style: const TextStyle(
                                                    color: AppColors
                                                        .driverTextMuted,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: List.generate(5, (
                                              starIndex,
                                            ) {
                                              return Icon(
                                                starIndex < review.rating
                                                    ? Icons.star_rounded
                                                    : Icons
                                                          .star_outline_rounded,
                                                color: starIndex < review.rating
                                                    ? AppColors.amber
                                                    : AppColors.driverBorder,
                                                size: 14,
                                              );
                                            }),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        review.comment,
                                        style: const TextStyle(
                                          color: AppColors.driverTextMuted,
                                          fontSize: 13,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .animate()
                                .fadeIn(
                                  delay: (160 + i * 60).ms,
                                  duration: 350.ms,
                                )
                                .slideX(begin: -0.1, end: 0),
                      );
                    }),

                    const SizedBox(height: 20),

                    // Tips for better ratings
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                color: AppColors.primary,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Tips for Better Ratings',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '• Be punctual and communicate arrival times\n'
                            '• Keep your vehicle clean and well-maintained\n'
                            '• Drive safely and follow traffic rules\n'
                            '• Be polite and professional with passengers',
                            style: TextStyle(
                              color: AppColors.driverTextMuted,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 300.ms, duration: 350.ms),

                    const SizedBox(height: 24),
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
