import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../data/app_state.dart';
import '../../widgets/ph_widgets.dart';
import '../../widgets/toast.dart';
import '../../utils/responsive.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});
  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen>
    with TickerProviderStateMixin {
  bool _online = false;
  late AnimationController _pulse;
  late AnimationController _breathe;
  late AnimationController _shimmer;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _breathe = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulse.dispose();
    _breathe.dispose();
    _shimmer.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _online = !_online);
    AppState.instance.driverStatus = _online
        ? DriverStatus.online
        : DriverStatus.offline;
    showToast(
      context,
      _online ? 'You are now online!' : 'You are now offline.',
    );
    if (_online) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _online) {
          AppState.instance.pendingRequest = mockRideRequest;
          context.go('/driver-request');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final earnings = AppState.instance.dailyEarnings;
    final trips = AppState.instance.dailyTrips;
    final rating = AppState.instance.driverRating;

    return Scaffold(
      backgroundColor: AppColors.driverBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Header ──────────────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(
                  Responsive.spacing(context, units: 2.5),
                  Responsive.spacing(context, units: 2),
                  Responsive.spacing(context, units: 2.5),
                  0,
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: Responsive.iconSize(context, base: 56),
                          height: Responsive.iconSize(context, base: 56),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.driverAccent,
                                Color(0xFFFFB300),
                              ],
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.driverAccent.withValues(
                                alpha: 0.3,
                              ),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.driverAccent.withValues(
                                  alpha: 0.2,
                                ),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'PS',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                fontSize: Responsive.fontSize(context, 18),
                              ),
                            ),
                          ),
                        ),
                        if (_online)
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              width: Responsive.iconSize(context, base: 16),
                              height: Responsive.iconSize(context, base: 16),
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.driverBg,
                                  width: 2.5,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(width: Responsive.spacing(context, units: 2)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pedro Santos',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: Responsive.fontSize(context, 18),
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(
                            height: Responsive.spacing(context, units: 0.5),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Responsive.spacing(
                                    context,
                                    units: 1,
                                  ),
                                  vertical: Responsive.spacing(
                                    context,
                                    units: 0.25,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.driverAccent.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    Responsive.radius(context, base: 6),
                                  ),
                                  border: Border.all(
                                    color: AppColors.driverAccent.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      color: AppColors.driverAccent,
                                      size: Responsive.iconSize(
                                        context,
                                        base: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      width: Responsive.spacing(
                                        context,
                                        units: 0.5,
                                      ),
                                    ),
                                    Text(
                                      '4.9',
                                      style: TextStyle(
                                        color: AppColors.driverAccent,
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
                                width: Responsive.spacing(context, units: 1),
                              ),
                              Text(
                                'Habal-habal',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontSize: Responsive.fontSize(context, 12),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    PhIconButton(
                      icon: Icons.settings_rounded,
                      onTap: () => context.go('/driver-profile'),
                      color: Colors.white.withValues(alpha: 0.08),
                      iconColor: Colors.white,
                      size: Responsive.iconSize(context, base: 48),
                      bordered: true,
                    ),
                    SizedBox(width: Responsive.spacing(context, units: 1)),
                    PhIconButton(
                      icon: Icons.logout_rounded,
                      onTap: () {
                        showToast(context, 'Logging out...');
                        Future.delayed(const Duration(milliseconds: 500), () {
                          if (mounted) {
                            context.replace('/');
                          }
                        });
                      },
                      color: Colors.white.withValues(alpha: 0.08),
                      iconColor: Colors.white,
                      size: Responsive.iconSize(context, base: 48),
                      bordered: true,
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),

              SizedBox(height: Responsive.spacing(context, units: 2.5)),

              // ── Online Toggle ────────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.spacing(context, units: 2.5),
                ),
                child: PhCard(
                  onTap: _toggle,
                  padding: EdgeInsets.all(
                    Responsive.spacing(context, units: 3),
                  ),
                  color: _online
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.driverSurface,
                  bordered: true,
                  borderRadius: Responsive.radius(
                    context,
                    base: 24,
                  ).round().toDouble(),
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          if (_online)
                            AnimatedBuilder(
                              animation: _pulse,
                              builder: (context, child) => Container(
                                width:
                                    Responsive.iconSize(context, base: 64) +
                                    Responsive.iconSize(context, base: 32) *
                                        _pulse.value,
                                height:
                                    Responsive.iconSize(context, base: 64) +
                                    Responsive.iconSize(context, base: 32) *
                                        _pulse.value,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.success.withValues(
                                    alpha: 0.15 * (1 - _pulse.value),
                                  ),
                                ),
                              ),
                            ),
                          Container(
                            width: Responsive.iconSize(context, base: 64),
                            height: Responsive.iconSize(context, base: 64),
                            decoration: BoxDecoration(
                              gradient: _online
                                  ? const LinearGradient(
                                      colors: [
                                        AppColors.success,
                                        Color(0xFF059669),
                                      ],
                                    )
                                  : null,
                              color: _online ? null : AppColors.driverBorder,
                              shape: BoxShape.circle,
                              boxShadow: _online
                                  ? [
                                      BoxShadow(
                                        color: AppColors.success.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              _online
                                  ? Icons.power_settings_new_rounded
                                  : Icons.power_off_rounded,
                              color: _online
                                  ? Colors.white
                                  : AppColors.driverTextMuted,
                              size: Responsive.iconSize(context, base: 32),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: Responsive.spacing(context, units: 3)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _online ? 'You are ONLINE' : 'You are OFFLINE',
                              style: TextStyle(
                                color: _online
                                    ? AppColors.success
                                    : Colors.white,
                                fontSize: Responsive.fontSize(context, 18),
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(
                              height: Responsive.spacing(context, units: 0.5),
                            ),
                            Text(
                              _online
                                  ? 'Waiting for ride requests...'
                                  : 'Go online to start earning',
                              style: TextStyle(
                                color: _online
                                    ? AppColors.success.withValues(alpha: 0.7)
                                    : AppColors.driverTextMuted,
                                fontSize: Responsive.fontSize(context, 14),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _online,
                        onChanged: (_) => _toggle(),
                        activeThumbColor: AppColors.success,
                        activeTrackColor: AppColors.success.withValues(
                          alpha: 0.2,
                        ),
                        inactiveThumbColor: AppColors.driverTextMuted,
                        inactiveTrackColor: AppColors.driverBorder,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: Responsive.spacing(context, units: 2.5)),

              // ── Stats ────────────────────────────────────────────────────────
              Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.spacing(context, units: 2.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "TODAY'S PERFORMANCE",
                              style: TextStyle(
                                color: AppColors.driverTextMuted,
                                fontSize: Responsive.fontSize(context, 11),
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Responsive.spacing(
                                  context,
                                  units: 1,
                                ),
                                vertical: Responsive.spacing(
                                  context,
                                  units: 0.375,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(
                                  Responsive.radius(context, base: 12),
                                ),
                                border: Border.all(
                                  color: AppColors.success.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.trending_up_rounded,
                                    color: AppColors.success,
                                    size: Responsive.iconSize(
                                      context,
                                      base: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.spacing(
                                      context,
                                      units: 0.5,
                                    ),
                                  ),
                                  Text(
                                    '+12%',
                                    style: TextStyle(
                                      color: AppColors.success,
                                      fontSize: Responsive.fontSize(
                                        context,
                                        10,
                                      ),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Responsive.spacing(context, units: 1.5),
                        ),
                        // Earnings card
                        Container(
                          padding: EdgeInsets.all(
                            Responsive.spacing(context, units: 2.5),
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.driverAccent.withValues(alpha: 0.25),
                                AppColors.driverAccent.withValues(alpha: 0.08),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(
                              Responsive.radius(context, base: 18),
                            ),
                            border: Border.all(
                              color: AppColors.driverAccent.withValues(
                                alpha: 0.4,
                              ),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.driverAccent.withValues(
                                  alpha: 0.15,
                                ),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: Responsive.iconSize(
                                      context,
                                      base: 44,
                                    ),
                                    height: Responsive.iconSize(
                                      context,
                                      base: 44,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          AppColors.driverAccent,
                                          AppColors.driverAccentDark,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        Responsive.radius(context, base: 12),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.driverAccent
                                              .withValues(alpha: 0.3),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.monetization_on_rounded,
                                      color: AppColors.driverBg,
                                      size: Responsive.iconSize(
                                        context,
                                        base: 22,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.spacing(
                                      context,
                                      units: 1.5,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Total Earnings',
                                      style: TextStyle(
                                        color: AppColors.driverTextMuted,
                                        fontSize: Responsive.fontSize(
                                          context,
                                          14,
                                        ),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Responsive.spacing(
                                        context,
                                        units: 1.25,
                                      ),
                                      vertical: Responsive.spacing(
                                        context,
                                        units: 0.625,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withValues(
                                        alpha: 0.15,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        Responsive.radius(context, base: 20),
                                      ),
                                      border: Border.all(
                                        color: AppColors.success.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'vs yesterday',
                                      style: TextStyle(
                                        color: AppColors.success,
                                        fontSize: Responsive.fontSize(
                                          context,
                                          10,
                                        ),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: Responsive.spacing(context, units: 2),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '₱${earnings.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: AppColors.driverAccent,
                                      fontSize: Responsive.fontSize(
                                        context,
                                        32,
                                      ),
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.spacing(
                                      context,
                                      units: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom: Responsive.spacing(
                                        context,
                                        units: 0.5,
                                      ),
                                    ),
                                    child: Text(
                                      'PHP',
                                      style: TextStyle(
                                        color: AppColors.driverAccent,
                                        fontSize: Responsive.fontSize(
                                          context,
                                          14,
                                        ),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: Responsive.spacing(context, units: 1),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.route_rounded,
                                    color: AppColors.driverTextMuted,
                                    size: Responsive.iconSize(
                                      context,
                                      base: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.spacing(
                                      context,
                                      units: 0.75,
                                    ),
                                  ),
                                  Text(
                                    '$trips trips completed today',
                                    style: TextStyle(
                                      color: AppColors.driverTextMuted,
                                      fontSize: Responsive.fontSize(
                                        context,
                                        13,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${(earnings / (trips > 0 ? trips : 1)).toStringAsFixed(0)} avg/trip',
                                    style: TextStyle(
                                      color: AppColors.driverTextMuted,
                                      fontSize: Responsive.fontSize(
                                        context,
                                        12,
                                      ),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Responsive.spacing(context, units: 1.75),
                        ),
                        // Mini stat cards
                        Row(
                          children: [
                            Expanded(
                              child: _MiniStat(
                                icon: Icons.star_rounded,
                                iconColor: AppColors.amber,
                                label: 'Rating',
                                value: '$rating',
                                sub: 'Excellent',
                              ),
                            ),
                            SizedBox(
                              width: Responsive.spacing(context, units: 1.5),
                            ),
                            Expanded(
                              child: _MiniStat(
                                icon: Icons.schedule_rounded,
                                iconColor: AppColors.primary,
                                label: 'Online',
                                value: '6.5h',
                                sub: 'Today',
                              ),
                            ),
                            SizedBox(
                              width: Responsive.spacing(context, units: 1.5),
                            ),
                            Expanded(
                              child: _MiniStat(
                                icon: Icons.local_fire_department_rounded,
                                iconColor: AppColors.error,
                                label: 'Streak',
                                value: '${trips}d',
                                sub: 'Active',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 160.ms, duration: 400.ms)
                  .slideY(begin: 0.1, end: 0),

              SizedBox(height: Responsive.spacing(context, units: 2.5)),

              // ── Quick Actions ────────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.spacing(context, units: 2.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'QUICK ACTIONS',
                      style: TextStyle(
                        color: AppColors.driverTextMuted,
                        fontSize: Responsive.fontSize(context, 11),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: Responsive.spacing(context, units: 1.5)),
                    Row(
                      children: [
                        _ActionBtn(
                          icon: Icons.history_rounded,
                          label: 'Trip History',
                          sub: '$trips today',
                          color: AppColors.primary,
                          onTap: () => context.go('/driver-history'),
                        ),
                        SizedBox(
                          width: Responsive.spacing(context, units: 1.5),
                        ),
                        _ActionBtn(
                          icon: Icons.star_rounded,
                          label: 'Ratings',
                          sub: '$rating stars',
                          color: AppColors.amber,
                          onTap: () => context.go('/driver-ratings'),
                        ),
                      ],
                    ),
                    SizedBox(height: Responsive.spacing(context, units: 1.5)),
                    Row(
                      children: [
                        _ActionBtn(
                          icon: Icons.analytics_rounded,
                          label: 'Earnings',
                          sub: '₱${earnings.toStringAsFixed(0)}',
                          color: AppColors.success,
                          onTap: () => context.go('/driver-earnings'),
                        ),
                        SizedBox(
                          width: Responsive.spacing(context, units: 1.5),
                        ),
                        _ActionBtn(
                          icon: Icons.account_balance_wallet_rounded,
                          label: 'PasaWallet',
                          sub: 'My wallet',
                          color: AppColors.driverAccent,
                          onTap: () => context.go('/driver-wallet'),
                        ),
                      ],
                    ),
                    SizedBox(height: Responsive.spacing(context, units: 1.5)),
                    Row(
                      children: [
                        _ActionBtn(
                          icon: Icons.person_outline_rounded,
                          label: 'Profile',
                          sub: 'Verified',
                          color: AppColors.primary,
                          onTap: () => context.go('/driver-profile'),
                        ),
                        SizedBox(
                          width: Responsive.spacing(context, units: 1.5),
                        ),
                        _ActionBtn(
                          icon: Icons.account_balance_outlined,
                          label: 'Withdraw',
                          sub: 'Cash out',
                          color: AppColors.error,
                          onTap: () => context.go('/driver-wallet-withdraw'),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 240.ms, duration: 400.ms),

              SizedBox(height: Responsive.spacing(context, units: 2.5)),

              // ── Recent Trips ─────────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(
                  Responsive.spacing(context, units: 2.5),
                  0,
                  Responsive.spacing(context, units: 2.5),
                  Responsive.spacing(context, units: 3),
                ),
                child: Column(
                  children: [
                    PhSectionHeader(
                      title: 'Recent Trips',
                      action: 'See all',
                      onAction: () => context.go('/driver-history'),
                      dark: true,
                    ),
                    SizedBox(height: Responsive.spacing(context, units: 1.25)),
                    _TripRow(
                      pickup: 'Robinsons Place',
                      dropoff: 'Paseo de Santa Rosa',
                      fare: 65,
                      time: '2:30 PM',
                    ),
                    SizedBox(height: Responsive.spacing(context, units: 1)),
                    _TripRow(
                      pickup: 'IT Park',
                      dropoff: 'Guadalupe',
                      fare: 48,
                      time: '11:15 AM',
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 350.ms),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shared small widgets ──────────────────────────────────────────────────────

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label, value, sub;
  const _MiniStat({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Responsive.spacing(context, units: 1.75)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            iconColor.withValues(alpha: 0.15),
            iconColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(
          Responsive.radius(context, base: 16),
        ),
        border: Border.all(color: iconColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Responsive.iconSize(context, base: 30),
            height: Responsive.iconSize(context, base: 30),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(
                Responsive.radius(context, base: 8),
              ),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: Responsive.iconSize(context, base: 15),
            ),
          ),
          SizedBox(height: Responsive.spacing(context, units: 1.25)),
          Text(
            value,
            style: TextStyle(
              color: iconColor,
              fontSize: Responsive.fontSize(context, 18),
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: AppColors.driverTextMuted,
              fontSize: Responsive.fontSize(context, 10),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            sub,
            style: TextStyle(
              color: iconColor.withValues(alpha: 0.7),
              fontSize: Responsive.fontSize(context, 9),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label, sub;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.sub,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(Responsive.spacing(context, units: 2)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.12),
                color.withValues(alpha: 0.06),
              ],
            ),
            borderRadius: BorderRadius.circular(
              Responsive.radius(context, base: 16),
            ),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Responsive.iconSize(context, base: 36),
                height: Responsive.iconSize(context, base: 36),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(
                    Responsive.radius(context, base: 10),
                  ),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: Responsive.iconSize(context, base: 18),
                ),
              ),
              SizedBox(height: Responsive.spacing(context, units: 1.5)),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Responsive.fontSize(context, 13),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: Responsive.spacing(context, units: 0.25)),
              Text(
                sub,
                style: TextStyle(
                  color: color.withValues(alpha: 0.8),
                  fontSize: Responsive.fontSize(context, 11),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TripRow extends StatelessWidget {
  final String pickup, dropoff, time;
  final int fare;
  const _TripRow({
    required this.pickup,
    required this.dropoff,
    required this.fare,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.spacing(context, units: 1.75),
        vertical: Responsive.spacing(context, units: 1.5),
      ),
      decoration: BoxDecoration(
        color: AppColors.driverSurface,
        borderRadius: BorderRadius.circular(
          Responsive.radius(context, base: 14),
        ),
        border: Border.all(color: AppColors.driverBorder),
      ),
      child: Row(
        children: [
          Container(
            width: Responsive.iconSize(context, base: 38),
            height: Responsive.iconSize(context, base: 38),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.success, Color(0xFF15803D)],
              ),
              borderRadius: BorderRadius.circular(
                Responsive.radius(context, base: 10),
              ),
            ),
            child: Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: Responsive.iconSize(context, base: 18),
            ),
          ),
          SizedBox(width: Responsive.spacing(context, units: 1.5)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$pickup → $dropoff',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Responsive.fontSize(context, 13),
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  time,
                  style: TextStyle(
                    color: AppColors.driverTextMuted,
                    fontSize: Responsive.fontSize(context, 11),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₱$fare',
            style: TextStyle(
              color: AppColors.driverAccent,
              fontWeight: FontWeight.w800,
              fontSize: Responsive.fontSize(context, 16),
            ),
          ),
        ],
      ),
    );
  }
}
