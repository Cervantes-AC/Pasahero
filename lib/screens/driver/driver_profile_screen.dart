import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../data/app_state.dart';
import '../../widgets/ph_widgets.dart';
import '../../widgets/toast.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rating = AppState.instance.driverRating;

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
                    'Driver Profile',
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Profile card
                    PhDriverCard(
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          AppColors.primary,
                                          AppColors.primaryDark,
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.driverAccent
                                            .withValues(alpha: 0.5),
                                        width: 2,
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'PS',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 26,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 26,
                                      height: 26,
                                      decoration: BoxDecoration(
                                        color: AppColors.driverAccent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.driverBg,
                                          width: 2,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        size: 12,
                                        color: AppColors.driverBg,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Pedro Santos',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                '+63 912 345 6789',
                                style: TextStyle(
                                  color: AppColors.driverTextMuted,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.success.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.verified_rounded,
                                      color: AppColors.success,
                                      size: 13,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Verified Driver',
                                      style: TextStyle(
                                        color: AppColors.success,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _PStat(
                                      value: '$rating',
                                      label: 'Rating',
                                      icon: Icons.star_rounded,
                                      iconColor: AppColors.amber,
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 36,
                                    color: AppColors.driverBorder,
                                  ),
                                  Expanded(
                                    child: _PStat(
                                      value: '1,250',
                                      label: 'Total Trips',
                                      icon: Icons.two_wheeler,
                                      iconColor: AppColors.primary,
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 36,
                                    color: AppColors.driverBorder,
                                  ),
                                  Expanded(
                                    child: _PStat(
                                      value: 'Jan 2024',
                                      label: 'Since',
                                      icon: Icons.calendar_today_outlined,
                                      iconColor: AppColors.driverTextMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 80.ms, duration: 350.ms)
                        .slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 14),

                    _Section(
                      title: 'Vehicle Information',
                      child: Column(
                        children: [
                          _InfoRow(
                            icon: Icons.two_wheeler,
                            label: 'Vehicle',
                            value: 'Honda TMX 155',
                          ),
                          const SizedBox(height: 12),
                          _InfoRow(
                            icon: Icons.confirmation_number_outlined,
                            label: 'Plate No.',
                            value: 'ABC 1234',
                          ),
                          const SizedBox(height: 12),
                          _InfoRow(
                            icon: Icons.category_outlined,
                            label: 'Service Type',
                            value: 'Habal-habal',
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 160.ms, duration: 350.ms),

                    const SizedBox(height: 14),

                    _Section(
                      title: 'Documents',
                      child: Column(
                        children: [
                          _DocRow(
                            label: "Driver's License",
                            status: 'Verified',
                            ok: true,
                          ),
                          const SizedBox(height: 12),
                          _DocRow(
                            label: 'Vehicle Registration',
                            status: 'Verified',
                            ok: true,
                          ),
                          const SizedBox(height: 12),
                          _DocRow(
                            label: 'Insurance',
                            status: 'Expiring Soon',
                            ok: false,
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 240.ms, duration: 350.ms),

                    const SizedBox(height: 14),

                    _Section(
                      title: 'Recent Ratings',
                      child: Column(
                        children: [
                          _RatingRow(
                            name: 'Ana Reyes',
                            rating: 5,
                            comment: 'Very safe driver!',
                            time: '2h ago',
                          ),
                          const SizedBox(height: 12),
                          _RatingRow(
                            name: 'Carlos Tan',
                            rating: 5,
                            comment: 'Fast and friendly.',
                            time: 'Yesterday',
                          ),
                          const SizedBox(height: 12),
                          _RatingRow(
                            name: 'Maria Cruz',
                            rating: 4,
                            comment: 'Good ride overall.',
                            time: '2 days ago',
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 320.ms, duration: 350.ms),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          showToast(context, 'Logged out');
                          Future.delayed(const Duration(milliseconds: 600), () {
                            if (context.mounted) context.go('/');
                          });
                        },
                        icon: const Icon(Icons.logout, size: 18),
                        label: const Text(
                          'Log Out',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 400.ms, duration: 350.ms),
                    const SizedBox(height: 16),
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

class _PStat extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color iconColor;
  const _PStat({
    required this.value,
    required this.label,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 16),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.driverTextMuted,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return PhDriverCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: AppColors.driverTextMuted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
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
  final String label, value;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.driverTextMuted, size: 16),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.driverTextMuted,
            fontSize: 13,
          ),
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
  final String label, status;
  final bool ok;
  const _DocRow({required this.label, required this.status, required this.ok});

  @override
  Widget build(BuildContext context) {
    final color = ok ? AppColors.success : AppColors.warning;
    return Row(
      children: [
        const Icon(
          Icons.description_outlined,
          color: AppColors.driverTextMuted,
          size: 16,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
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
  final String name, comment, time;
  final int rating;
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
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.25),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              name[0],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
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
                    style: const TextStyle(
                      color: AppColors.driverTextMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: List.generate(
                  rating,
                  (_) => const Icon(
                    Icons.star_rounded,
                    size: 11,
                    color: AppColors.amber,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                comment,
                style: const TextStyle(
                  color: AppColors.driverTextMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
