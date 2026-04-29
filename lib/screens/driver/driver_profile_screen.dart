import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../data/app_state.dart';
import '../../widgets/ph_widgets.dart';
import '../../widgets/toast.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _glow;

  @override
  void initState() {
    super.initState();
    _glow = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
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
                    // ── Profile card ─────────────────────────────────────────
                    PhDriverCard(
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Glow ring
                                  AnimatedBuilder(
                                    animation: _glow,
                                    builder: (_, __) => Container(
                                      width: 100 + 10 * _glow.value,
                                      height: 100 + 10 * _glow.value,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: [
                                            AppColors.driverAccent.withValues(
                                              alpha: 0.2 * _glow.value,
                                            ),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Avatar
                                  Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          AppColors.driverAccent,
                                          AppColors.driverAccentDark,
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.driverAccent
                                            .withValues(alpha: 0.6),
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.driverAccent
                                              .withValues(alpha: 0.4),
                                          blurRadius: 20,
                                          spreadRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'PS',
                                        style: TextStyle(
                                          color: AppColors.driverBg,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 32,
                                          letterSpacing: -1,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Camera badge
                                  Positioned(
                                    bottom: 4,
                                    right: 4,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            AppColors.primary,
                                            AppColors.primaryDark,
                                          ],
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.driverBg,
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary.withValues(
                                              alpha: 0.4,
                                            ),
                                            blurRadius: 8,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_rounded,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Pedro Santos',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.phone_rounded,
                                    color: AppColors.driverTextMuted,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    '+63 912 345 6789',
                                    style: TextStyle(
                                      color: AppColors.driverTextMuted,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.success,
                                      AppColors.success.withValues(alpha: 0.8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.success.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.verified_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Verified Driver',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: _PStat(
                                      value: '$rating',
                                      label: 'Rating',
                                      icon: Icons.star_rounded,
                                      color: AppColors.amber,
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 40,
                                    color: AppColors.driverBorder,
                                  ),
                                  Expanded(
                                    child: _PStat(
                                      value: '1,250',
                                      label: 'Total Trips',
                                      icon: Icons.two_wheeler_rounded,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 40,
                                    color: AppColors.driverBorder,
                                  ),
                                  Expanded(
                                    child: _PStat(
                                      value: 'Jan 2024',
                                      label: 'Since',
                                      icon: Icons.calendar_today_rounded,
                                      color: AppColors.driverAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 80.ms, duration: 400.ms)
                        .slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 14),

                    // ── Vehicle info ─────────────────────────────────────────
                    _Section(
                      title: 'Vehicle Information',
                      child: Column(
                        children: [
                          _InfoRow(
                            icon: Icons.two_wheeler_rounded,
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

                    // ── Documents ────────────────────────────────────────────
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

                    // ── Recent ratings ───────────────────────────────────────
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
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          showToast(context, 'Logged out');
                          Future.delayed(const Duration(milliseconds: 600), () {
                            if (context.mounted) context.go('/');
                          });
                        },
                        icon: const Icon(Icons.logout_rounded, size: 18),
                        label: const Text(
                          'Log Out',
                          style: TextStyle(fontWeight: FontWeight.w700),
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
  final Color color;
  const _PStat({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.2),
                color.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 17),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 14,
            letterSpacing: -0.3,
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
              letterSpacing: 0.8,
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
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.4),
                AppColors.primary.withValues(alpha: 0.2),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              name[0],
              style: const TextStyle(
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
              const SizedBox(height: 3),
              Row(
                children: List.generate(
                  rating,
                  (_) => const Icon(
                    Icons.star_rounded,
                    size: 12,
                    color: AppColors.amber,
                  ),
                ),
              ),
              const SizedBox(height: 3),
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
