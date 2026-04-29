import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/ph_widgets.dart';
import '../../widgets/toast.dart';
import '../../utils/responsive.dart';

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
    return Scaffold(
      backgroundColor: AppColors.driverBg,
      body: SafeArea(
        child: Column(
          children: [
            PhAppBar(
              title: 'Driver Profile',
              showBack: true,
              onBack: () => context.go('/driver-home'),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.spacing(context, units: 3),
                  vertical: Responsive.spacing(context, units: 1),
                ),
                child: Column(
                  children: [
                    // ── Profile card ─────────────────────────────────────────
                    PhCard(
                          padding: EdgeInsets.all(
                            Responsive.spacing(context, units: 4),
                          ),
                          color: AppColors.driverSurface,
                          bordered: true,
                          borderRadius: Responsive.radius(
                            context,
                            base: 28,
                          ).round().toDouble(),
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Avatar
                                  Container(
                                    width: Responsive.iconSize(
                                      context,
                                      base: 100,
                                    ),
                                    height: Responsive.iconSize(
                                      context,
                                      base: 100,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          AppColors.driverAccent,
                                          Color(0xFFFFB300),
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.driverAccent
                                            .withValues(alpha: 0.3),
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.driverAccent
                                              .withValues(alpha: 0.2),
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        'PS',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900,
                                          fontSize: Responsive.fontSize(
                                            context,
                                            32,
                                          ),
                                          letterSpacing: -1,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Camera badge
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: Responsive.iconSize(
                                        context,
                                        base: 32,
                                      ),
                                      height: Responsive.iconSize(
                                        context,
                                        base: 32,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.driverSurface,
                                          width: 2,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.camera_alt_rounded,
                                        size: Responsive.iconSize(
                                          context,
                                          base: 16,
                                        ),
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: Responsive.spacing(context, units: 2.5),
                              ),
                              Text(
                                'Pedro Santos',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Responsive.fontSize(context, 24),
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              SizedBox(
                                height: Responsive.spacing(context, units: 0.5),
                              ),
                              Text(
                                '+63 912 345 6789',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: Responsive.fontSize(context, 14),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: Responsive.spacing(context, units: 2.5),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Responsive.spacing(
                                    context,
                                    units: 1.75,
                                  ),
                                  vertical: Responsive.spacing(
                                    context,
                                    units: 1,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    Responsive.radius(context, base: 12),
                                  ),
                                  border: Border.all(
                                    color: AppColors.success.withValues(
                                      alpha: 0.2,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.verified_rounded,
                                      color: AppColors.success,
                                      size: Responsive.iconSize(
                                        context,
                                        base: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      width: Responsive.spacing(
                                        context,
                                        units: 1,
                                      ),
                                    ),
                                    Text(
                                      'Verified Driver',
                                      style: TextStyle(
                                        color: AppColors.success,
                                        fontSize: Responsive.fontSize(
                                          context,
                                          12,
                                        ),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: Responsive.spacing(context, units: 4),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _PStat(
                                    value: '4.9',
                                    label: 'Rating',
                                    icon: Icons.star_rounded,
                                    color: AppColors.driverAccent,
                                  ),
                                  Container(
                                    width: 1,
                                    height: 40,
                                    color: AppColors.driverBorder,
                                  ),
                                  _PStat(
                                    value: '1.2k',
                                    label: 'Trips',
                                    icon: Icons.two_wheeler_rounded,
                                    color: AppColors.secondary,
                                  ),
                                  Container(
                                    width: 1,
                                    height: 40,
                                    color: AppColors.driverBorder,
                                  ),
                                  _PStat(
                                    value: '2y',
                                    label: 'Exp',
                                    icon: Icons.calendar_today_rounded,
                                    color: AppColors.tertiary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.1, end: 0),

                    SizedBox(height: Responsive.spacing(context, units: 1.75)),

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
                          SizedBox(
                            height: Responsive.spacing(context, units: 1.5),
                          ),
                          _InfoRow(
                            icon: Icons.confirmation_number_outlined,
                            label: 'Plate No.',
                            value: 'ABC 1234',
                          ),
                          SizedBox(
                            height: Responsive.spacing(context, units: 1.5),
                          ),
                          _InfoRow(
                            icon: Icons.category_outlined,
                            label: 'Service Type',
                            value: 'Habal-habal',
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 160.ms, duration: 350.ms),

                    SizedBox(height: Responsive.spacing(context, units: 1.75)),

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
                          SizedBox(
                            height: Responsive.spacing(context, units: 1.5),
                          ),
                          _DocRow(
                            label: 'Vehicle Registration',
                            status: 'Verified',
                            ok: true,
                          ),
                          SizedBox(
                            height: Responsive.spacing(context, units: 1.5),
                          ),
                          _DocRow(
                            label: 'Insurance',
                            status: 'Expiring Soon',
                            ok: false,
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 240.ms, duration: 350.ms),

                    SizedBox(height: Responsive.spacing(context, units: 1.75)),

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
                          SizedBox(
                            height: Responsive.spacing(context, units: 1.5),
                          ),
                          _RatingRow(
                            name: 'Carlos Tan',
                            rating: 5,
                            comment: 'Fast and friendly.',
                            time: 'Yesterday',
                          ),
                          SizedBox(
                            height: Responsive.spacing(context, units: 1.5),
                          ),
                          _RatingRow(
                            name: 'Maria Cruz',
                            rating: 4,
                            comment: 'Good ride overall.',
                            time: '2 days ago',
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 320.ms, duration: 350.ms),

                    SizedBox(height: Responsive.spacing(context, units: 2.5)),

                    SizedBox(
                      width: double.infinity,
                      height: Responsive.buttonHeight(context),
                      child: OutlinedButton.icon(
                        onPressed: () {
                          showToast(context, 'Logged out');
                          Future.delayed(const Duration(milliseconds: 600), () {
                            if (context.mounted) context.go('/');
                          });
                        },
                        icon: Icon(
                          Icons.logout_rounded,
                          size: Responsive.iconSize(context, base: 18),
                        ),
                        label: Text(
                          'Log Out',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: Responsive.fontSize(context, 16),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              Responsive.radius(context, base: 14),
                            ),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 400.ms, duration: 350.ms),
                    SizedBox(height: Responsive.spacing(context, units: 2)),
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
          width: Responsive.iconSize(context, base: 34),
          height: Responsive.iconSize(context, base: 34),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.2),
                color.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(
              Responsive.radius(context, base: 10),
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: Responsive.iconSize(context, base: 17),
          ),
        ),
        SizedBox(height: Responsive.spacing(context, units: 1)),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: Responsive.fontSize(context, 14),
            letterSpacing: -0.3,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.driverTextMuted,
            fontSize: Responsive.fontSize(context, 10),
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
            style: TextStyle(
              color: AppColors.driverTextMuted,
              fontSize: Responsive.fontSize(context, 11),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, units: 1.75)),
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
        Icon(
          icon,
          color: AppColors.driverTextMuted,
          size: Responsive.iconSize(context, base: 16),
        ),
        SizedBox(width: Responsive.spacing(context, units: 1.25)),
        Text(
          label,
          style: TextStyle(
            color: AppColors.driverTextMuted,
            fontSize: Responsive.fontSize(context, 13),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: Responsive.fontSize(context, 13),
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
        Icon(
          Icons.description_outlined,
          color: AppColors.driverTextMuted,
          size: Responsive.iconSize(context, base: 16),
        ),
        SizedBox(width: Responsive.spacing(context, units: 1.25)),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: Responsive.fontSize(context, 13),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.spacing(context, units: 1.125),
            vertical: Responsive.spacing(context, units: 0.375),
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(
              Responsive.radius(context, base: 20),
            ),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: Responsive.fontSize(context, 11),
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
          width: Responsive.iconSize(context, base: 36),
          height: Responsive.iconSize(context, base: 36),
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
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: Responsive.fontSize(context, 14),
              ),
            ),
          ),
        ),
        SizedBox(width: Responsive.spacing(context, units: 1.25)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Responsive.fontSize(context, 13),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    time,
                    style: TextStyle(
                      color: AppColors.driverTextMuted,
                      fontSize: Responsive.fontSize(context, 11),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Responsive.spacing(context, units: 0.375)),
              Row(
                children: List.generate(
                  rating,
                  (_) => Icon(
                    Icons.star_rounded,
                    size: Responsive.iconSize(context, base: 12),
                    color: AppColors.amber,
                  ),
                ),
              ),
              SizedBox(height: Responsive.spacing(context, units: 0.375)),
              Text(
                comment,
                style: TextStyle(
                  color: AppColors.driverTextMuted,
                  fontSize: Responsive.fontSize(context, 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
