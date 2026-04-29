import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../data/app_state.dart';
import '../../widgets/toast.dart';
import '../../utils/responsive.dart';

class DriverRequestScreen extends StatefulWidget {
  const DriverRequestScreen({super.key});

  @override
  State<DriverRequestScreen> createState() => _DriverRequestScreenState();
}

class _DriverRequestScreenState extends State<DriverRequestScreen>
    with TickerProviderStateMixin {
  late AnimationController _timerController;
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late Timer _countdownTimer;
  int _secondsLeft = 30;
  bool _responded = false;

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _secondsLeft--);

      // Add shake effect when time is running low
      if (_secondsLeft <= 10 && _secondsLeft > 0) {
        _shakeController.forward().then((_) => _shakeController.reset());
      }

      if (_secondsLeft <= 0) {
        t.cancel();
        if (!_responded) _handleTimeout();
      }
    });
  }

  @override
  void dispose() {
    _timerController.dispose();
    _pulseController.dispose();
    _shakeController.dispose();
    _countdownTimer.cancel();
    super.dispose();
  }

  void _handleTimeout() {
    if (!mounted) return;
    showToast(context, 'Request timed out', isError: true);
    context.go('/driver-home');
  }

  void _handleAccept() {
    _responded = true;
    _countdownTimer.cancel();
    showToast(context, 'Ride accepted! Head to pickup location.');
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) context.go('/driver-active');
    });
  }

  void _handleDecline() {
    _responded = true;
    _countdownTimer.cancel();
    showToast(context, 'Ride declined.');
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) context.go('/driver-home');
    });
  }

  @override
  Widget build(BuildContext context) {
    final req = AppState.instance.pendingRequest ?? mockRideRequest;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.driverGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Enhanced timer ring with multiple effects
              Padding(
                padding: EdgeInsets.fromLTRB(
                  Responsive.spacing(context, units: 3),
                  Responsive.spacing(context, units: 3),
                  Responsive.spacing(context, units: 3),
                  0,
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer glow effect
                            AnimatedBuilder(
                              animation: _pulseController,
                              builder: (_, __) => Container(
                                width:
                                    Responsive.iconSize(context, base: 140) +
                                    Responsive.iconSize(context, base: 20) *
                                        _pulseController.value,
                                height:
                                    Responsive.iconSize(context, base: 140) +
                                    Responsive.iconSize(context, base: 20) *
                                        _pulseController.value,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      (_secondsLeft > 10
                                              ? AppColors.driverAccent
                                              : AppColors.error)
                                          .withValues(
                                            alpha:
                                                0.1 *
                                                (1 - _pulseController.value),
                                          ),
                                ),
                              ),
                            ),
                            // Main timer circle
                            AnimatedBuilder(
                              animation: _shakeController,
                              builder: (_, child) => Transform.translate(
                                offset: Offset(
                                  _secondsLeft <= 10
                                      ? 2 *
                                            _shakeController.value *
                                            (1 - _shakeController.value)
                                      : 0,
                                  0,
                                ),
                                child: child,
                              ),
                              child: Container(
                                width: Responsive.iconSize(context, base: 120),
                                height: Responsive.iconSize(context, base: 120),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: _secondsLeft > 10
                                        ? [
                                            AppColors.driverAccent,
                                            AppColors.driverAccentDark,
                                          ]
                                        : [
                                            AppColors.error,
                                            const Color(0xFFB91C1C),
                                          ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          (_secondsLeft > 10
                                                  ? AppColors.driverAccent
                                                  : AppColors.error)
                                              .withValues(alpha: 0.4),
                                      blurRadius: 20,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Progress indicator
                                    SizedBox(
                                      width: Responsive.iconSize(
                                        context,
                                        base: 100,
                                      ),
                                      height: Responsive.iconSize(
                                        context,
                                        base: 100,
                                      ),
                                      child: AnimatedBuilder(
                                        animation: _timerController,
                                        builder: (_, __) =>
                                            CircularProgressIndicator(
                                              value: 1 - _timerController.value,
                                              strokeWidth: 4,
                                              backgroundColor: Colors.white
                                                  .withValues(alpha: 0.3),
                                              valueColor:
                                                  const AlwaysStoppedAnimation(
                                                    Colors.white,
                                                  ),
                                            ),
                                      ),
                                    ),
                                    // Timer text
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '$_secondsLeft',
                                          style: TextStyle(
                                            fontSize: Responsive.fontSize(
                                              context,
                                              36,
                                            ),
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                            letterSpacing: -1,
                                          ),
                                        ),
                                        Text(
                                          'seconds',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: Responsive.fontSize(
                                              context,
                                              11,
                                            ),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Responsive.spacing(context, units: 2)),
                        Text(
                              'New Ride Request!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Responsive.fontSize(context, 24),
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            )
                            .animate(
                              onPlay: (controller) =>
                                  controller.repeat(reverse: true),
                            )
                            .shimmer(
                              duration: 2000.ms,
                              color: AppColors.driverAccent.withValues(
                                alpha: 0.3,
                              ),
                            ),
                        SizedBox(
                          height: Responsive.spacing(context, units: 0.75),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.spacing(context, units: 1.5),
                            vertical: Responsive.spacing(context, units: 0.75),
                          ),
                          decoration: BoxDecoration(
                            color:
                                (_secondsLeft > 10
                                        ? AppColors.driverAccent
                                        : AppColors.error)
                                    .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(
                              Responsive.radius(context, base: 20),
                            ),
                            border: Border.all(
                              color:
                                  (_secondsLeft > 10
                                          ? AppColors.driverAccent
                                          : AppColors.error)
                                      .withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            _secondsLeft > 10
                                ? 'Accept before the timer runs out'
                                : 'Hurry up! Time is running out!',
                            style: TextStyle(
                              color: _secondsLeft > 10
                                  ? AppColors.driverAccent
                                  : AppColors.error,
                              fontSize: Responsive.fontSize(context, 12),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // SOS button
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          showToast(
                            context,
                            'Emergency services contacted!',
                            isError: true,
                          );
                        },
                        child: Container(
                          width: Responsive.iconSize(context, base: 48),
                          height: Responsive.iconSize(context, base: 48),
                          decoration: BoxDecoration(
                            color: AppColors.red,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.red.withValues(alpha: 0.4),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.emergency,
                            color: Colors.white,
                            size: Responsive.iconSize(context, base: 24),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),

              const SizedBox(height: 24),

              // Request card
              Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: Responsive.spacing(context, units: 2),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(
                          Responsive.radius(context, base: 24),
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(
                          Responsive.spacing(context, units: 2.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Passenger info
                            Row(
                              children: [
                                Container(
                                  width: Responsive.iconSize(context, base: 52),
                                  height: Responsive.iconSize(
                                    context,
                                    base: 52,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.primary,
                                        AppColors.primaryLight,
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      req.passengerName
                                          .split(' ')
                                          .map((n) => n[0])
                                          .join(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: Responsive.fontSize(
                                          context,
                                          18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: Responsive.spacing(
                                    context,
                                    units: 1.75,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        req.passengerName,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: Responsive.fontSize(
                                            context,
                                            17,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: List.generate(
                                          req.passengerRating,
                                          (_) => Icon(
                                            Icons.star,
                                            size: Responsive.iconSize(
                                              context,
                                              base: 13,
                                            ),
                                            color: AppColors.yellow,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Fare highlight
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
                                    color: AppColors.driverAccent.withValues(
                                      alpha: 0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      Responsive.radius(context, base: 12),
                                    ),
                                    border: Border.all(
                                      color: AppColors.driverAccent.withValues(
                                        alpha: 0.4,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        '₱${req.fare.toStringAsFixed(0)}',
                                        style: TextStyle(
                                          color: AppColors.driverAccent,
                                          fontWeight: FontWeight.w800,
                                          fontSize: Responsive.fontSize(
                                            context,
                                            22,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'fare',
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: Responsive.fontSize(
                                            context,
                                            10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: Responsive.spacing(context, units: 2.5),
                            ),
                            const Divider(color: Colors.white12),
                            SizedBox(
                              height: Responsive.spacing(context, units: 2),
                            ),

                            // Route
                            _RouteItem(
                              dotColor: AppColors.green,
                              label: 'Pickup',
                              address: req.pickup,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: Responsive.spacing(context, units: 1.375),
                              ),
                              child: Container(
                                height: Responsive.spacing(context, units: 3.5),
                                width: 2,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [AppColors.green, AppColors.red],
                                  ),
                                ),
                              ),
                            ),
                            _RouteItem(
                              dotColor: AppColors.red,
                              label: 'Drop-off',
                              address: req.dropoff,
                            ),

                            SizedBox(
                              height: Responsive.spacing(context, units: 2.5),
                            ),

                            // Trip stats
                            Row(
                              children: [
                                Expanded(
                                  child: _TripStat(
                                    icon: Icons.straighten,
                                    label: 'Distance',
                                    value: '${req.distance} km',
                                  ),
                                ),
                                SizedBox(
                                  width: Responsive.spacing(
                                    context,
                                    units: 1.25,
                                  ),
                                ),
                                Expanded(
                                  child: _TripStat(
                                    icon: Icons.access_time,
                                    label: 'ETA to pickup',
                                    value: req.eta,
                                  ),
                                ),
                                SizedBox(
                                  width: Responsive.spacing(
                                    context,
                                    units: 1.25,
                                  ),
                                ),
                                Expanded(
                                  child: _TripStat(
                                    icon: Icons.monetization_on_outlined,
                                    label: 'Your cut',
                                    value:
                                        '₱${(req.fare * 0.85).toStringAsFixed(0)}',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 400.ms)
                  .slideY(begin: 0.3, end: 0),

              // Action buttons
              Padding(
                    padding: EdgeInsets.fromLTRB(
                      Responsive.spacing(context, units: 2),
                      Responsive.spacing(context, units: 2),
                      Responsive.spacing(context, units: 2),
                      Responsive.spacing(context, units: 3),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: Responsive.buttonHeight(context),
                            child: OutlinedButton(
                              onPressed: _handleDecline,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.red,
                                side: const BorderSide(
                                  color: AppColors.red,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    Responsive.radius(context, base: 16),
                                  ),
                                ),
                              ),
                              child: Text(
                                'Decline',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: Responsive.fontSize(context, 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Responsive.spacing(context, units: 1.5),
                        ),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: Responsive.buttonHeight(context),
                            child: ElevatedButton(
                              onPressed: _handleAccept,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    Responsive.radius(context, base: 16),
                                  ),
                                ),
                                elevation: 6,
                                shadowColor: AppColors.green.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: Responsive.iconSize(
                                      context,
                                      base: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.spacing(
                                      context,
                                      units: 1,
                                    ),
                                  ),
                                  Text(
                                    'Accept Ride',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: Responsive.fontSize(
                                        context,
                                        16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 400.ms)
                  .slideY(begin: 0.3, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _RouteItem extends StatelessWidget {
  final Color dotColor;
  final String label;
  final String address;
  const _RouteItem({
    required this.dotColor,
    required this.label,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: Responsive.iconSize(context, base: 24),
          height: Responsive.iconSize(context, base: 24),
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          child: const Center(
            child: CircleAvatar(radius: 4, backgroundColor: Colors.white),
          ),
        ),
        SizedBox(width: Responsive.spacing(context, units: 1.5)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: Responsive.fontSize(context, 11),
                ),
              ),
              Text(
                address,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: Responsive.fontSize(context, 14),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TripStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _TripStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Responsive.spacing(context, units: 1.5)),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(
          Responsive.radius(context, base: 12),
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white54,
            size: Responsive.iconSize(context, base: 18),
          ),
          SizedBox(height: Responsive.spacing(context, units: 0.5)),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: Responsive.fontSize(context, 13),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white38,
              fontSize: Responsive.fontSize(context, 10),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
