import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../data/app_state.dart';
import '../../widgets/toast.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rating = AppState.instance.driverRating;
    final trips = AppState.instance.dailyTrips;

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
                      'Driver Profile',
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
                      // Profile card
                      Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Column(
                              children: [
                                // Avatar
                                Stack(
                                  children: [
                                    Container(
                                      width: 88,
                                      height: 88,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            AppColors.primary,
                                            AppColors.primaryLight,
                                          ],
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.driverAccent
                                              .withValues(alpha: 0.6),
                                          width: 2.5,
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'PS',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: AppColors.driverAccent,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color(0xFF0F172A),
                                            width: 2,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt,
                                          size: 14,
                                          color: AppColors.driverPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                const Text(
                                  'Pedro Santos',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  '+63 912 345 6789',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Verified badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.green.withValues(
                                      alpha: 0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.green.withValues(
                                        alpha: 0.4,
                                      ),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.verified,
                                        color: AppColors.green,
                                        size: 14,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Verified Driver',
                                        style: TextStyle(
                                          color: AppColors.green,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Stats row
                                Row(
                                  children: [
                                    Expanded(
                                      child: _ProfileStat(
                                        value: '$rating',
                                        label: 'Rating',
                                        icon: Icons.star,
                                        iconColor: AppColors.yellow,
                                      ),
                                    ),
                                    Container(
                                      width: 1,
                                      height: 40,
                                      color: Colors.white12,
                                    ),
                                    Expanded(
                                      child: _ProfileStat(
                                        value: '1,250',
                                        label: 'Total Trips',
                                        icon: Icons.two_wheeler,
                                        iconColor: AppColors.primary,
                                      ),
                                    ),
                                    Container(
                                      width: 1,
                                      height: 40,
                                      color: Colors.white12,
                                    ),
                                    Expanded(
                                      child: _ProfileStat(
                                        value: 'Jan 2024',
                                        label: 'Member Since',
                                        icon: Icons.calendar_today,
                                        iconColor: Colors.white54,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 100.ms, duration: 400.ms)
                          .slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 20),

                      // Vehicle info
                      _SectionCard(
                            title: 'Vehicle Information',
                            child: Column(
                              children: [
                                _InfoRow(
                                  icon: Icons.two_wheeler,
                                  label: 'Vehicle',
                                  value: 'Honda TMX 155',
                                ),
                                const Divider(
                                  color: Colors.white12,
                                  height: 20,
                                ),
                                _InfoRow(
                                  icon: Icons.confirmation_number_outlined,
                                  label: 'Plate No.',
                                  value: 'ABC 1234',
                                ),
                                const Divider(
                                  color: Colors.white12,
                                  height: 20,
                                ),
                                _InfoRow(
                                  icon: Icons.category_outlined,
                                  label: 'Service Type',
                                  value: 'Habal-habal',
                                ),
                              ],
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 400.ms)
                          .slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 14),

                      // Documents
                      _SectionCard(
                            title: 'Documents',
                            child: Column(
                              children: [
                                _DocRow(
                                  label: "Driver's License",
                                  status: 'Verified',
                                ),
                                const Divider(
                                  color: Colors.white12,
                                  height: 20,
                                ),
                                _DocRow(
                                  label: 'Vehicle Registration',
                                  status: 'Verified',
                                ),
                                const Divider(
                                  color: Colors.white12,
                                  height: 20,
                                ),
                                _DocRow(
                                  label: 'Insurance',
                                  status: 'Expiring Soon',
                                  isWarning: true,
                                ),
                              ],
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 300.ms, duration: 400.ms)
                          .slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 14),

                      // Recent ratings
                      _SectionCard(
                            title: 'Recent Ratings',
                            child: Column(
                              children: [
                                _RatingRow(
                                  name: 'Ana Reyes',
                                  rating: 5,
                                  comment: 'Very safe driver!',
                                  time: '2h ago',
                                ),
                                const Divider(
                                  color: Colors.white12,
                                  height: 20,
                                ),
                                _RatingRow(
                                  name: 'Carlos Tan',
                                  rating: 5,
                                  comment: 'Fast and friendly.',
                                  time: 'Yesterday',
                                ),
                                const Divider(
                                  color: Colors.white12,
                                  height: 20,
                                ),
                                _RatingRow(
                                  name: 'Maria Cruz',
                                  rating: 4,
                                  comment: 'Good ride overall.',
                                  time: '2 days ago',
                                ),
                              ],
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 400.ms)
                          .slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 20),

                      // Logout
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            showToast(context, 'Logged out');
                            Future.delayed(
                              const Duration(milliseconds: 800),
                              () {
                                if (context.mounted) context.go('/');
                              },
                            );
                          },
                          icon: const Icon(Icons.logout),
                          label: const Text(
                            'Logout',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.red,
                            side: const BorderSide(
                              color: AppColors.red,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
                      const SizedBox(height: 16),
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

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color iconColor;
  const _ProfileStat({
    required this.value,
    required this.label,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white38, size: 18),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 13),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DocRow extends StatelessWidget {
  final String label;
  final String status;
  final bool isWarning;
  const _DocRow({
    required this.label,
    required this.status,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isWarning ? AppColors.orange : AppColors.green;
    return Row(
      children: [
        Icon(Icons.description_outlined, color: Colors.white38, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _RatingRow extends StatelessWidget {
  final String name;
  final int rating;
  final String comment;
  final String time;
  const _RatingRow({
    required this.name,
    required this.rating,
    required this.comment,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              name[0],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    time,
                    style: const TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: List.generate(
                  rating,
                  (_) =>
                      const Icon(Icons.star, size: 12, color: AppColors.yellow),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                comment,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
