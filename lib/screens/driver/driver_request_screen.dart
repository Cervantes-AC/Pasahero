import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../data/app_state.dart';
import '../../widgets/toast.dart';

class DriverRequestScreen extends StatefulWidget {
  const DriverRequestScreen({super.key});

  @override
  State<DriverRequestScreen> createState() => _DriverRequestScreenState();
}

class _DriverRequestScreenState extends State<DriverRequestScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _timerController;
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

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) {
        t.cancel();
        if (!_responded) _handleTimeout();
      }
    });
  }

  @override
  void dispose() {
    _timerController.dispose();
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
              // Timer ring
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: AnimatedBuilder(
                            animation: _timerController,
                            builder: (_, __) => CircularProgressIndicator(
                              value: 1 - _timerController.value,
                              strokeWidth: 6,
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.1,
                              ),
                              valueColor: AlwaysStoppedAnimation(
                                _secondsLeft > 10
                                    ? AppColors.driverAccent
                                    : AppColors.red,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '$_secondsLeft',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: _secondsLeft > 10
                                    ? AppColors.driverAccent
                                    : AppColors.red,
                              ),
                            ),
                            const Text(
                              'secs',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'New Ride Request!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Accept before the timer runs out',
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                  ],
                ),
              ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),

              const SizedBox(height: 24),

              // Request card
              Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Passenger info
                            Row(
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
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
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        req.passengerName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17,
                                        ),
                                      ),
                                      Row(
                                        children: List.generate(
                                          req.passengerRating,
                                          (_) => const Icon(
                                            Icons.star,
                                            size: 13,
                                            color: AppColors.yellow,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Fare highlight
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.driverAccent.withValues(
                                      alpha: 0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
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
                                          fontSize: 22,
                                        ),
                                      ),
                                      const Text(
                                        'fare',
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),
                            const Divider(color: Colors.white12),
                            const SizedBox(height: 16),

                            // Route
                            _RouteItem(
                              dotColor: AppColors.green,
                              label: 'Pickup',
                              address: req.pickup,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 11),
                              child: Container(
                                height: 28,
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

                            const SizedBox(height: 20),

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
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _TripStat(
                                    icon: Icons.access_time,
                                    label: 'ETA to pickup',
                                    value: req.eta,
                                  ),
                                ),
                                const SizedBox(width: 10),
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
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: OutlinedButton(
                              onPressed: _handleDecline,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.red,
                                side: const BorderSide(
                                  color: AppColors.red,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'Decline',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _handleAccept,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 6,
                                shadowColor: AppColors.green.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle_outline, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Accept Ride',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
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
          width: 24,
          height: 24,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          child: const Center(
            child: CircleAvatar(radius: 4, backgroundColor: Colors.white),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white54, fontSize: 11),
              ),
              Text(
                address,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white54, size: 18),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
