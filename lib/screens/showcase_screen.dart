import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

// ── Transaction step model ────────────────────────────────────────────────────

enum _StepId {
  idle,
  passengerSearching,
  requestSent,
  driverAccepted,
  driverEnRoute,
  driverArrived,
  tripInProgress,
  tripComplete,
}

class _Step {
  final _StepId id;
  final String label;
  final String passengerTitle;
  final String passengerBody;
  final String driverTitle;
  final String driverBody;
  final IconData passengerIcon;
  final IconData driverIcon;
  final Color passengerAccent;
  final Color driverAccent;

  const _Step({
    required this.id,
    required this.label,
    required this.passengerTitle,
    required this.passengerBody,
    required this.driverTitle,
    required this.driverBody,
    required this.passengerIcon,
    required this.driverIcon,
    required this.passengerAccent,
    required this.driverAccent,
  });
}

const _steps = [
  _Step(
    id: _StepId.idle,
    label: 'Start',
    passengerTitle: 'Passenger App',
    passengerBody:
        'Juan opens Pasahero and sees the home screen with available ride types.',
    driverTitle: 'Driver App',
    driverBody:
        'Pedro is offline. He taps the toggle to go online and wait for requests.',
    passengerIcon: Icons.home_rounded,
    driverIcon: Icons.wifi_off_rounded,
    passengerAccent: AppColors.primary,
    driverAccent: AppColors.driverTextMuted,
  ),
  _Step(
    id: _StepId.passengerSearching,
    label: 'Booking',
    passengerTitle: 'Requesting a Ride',
    passengerBody:
        'Juan selects Habal-habal, enters his destination "Ayala Center Cebu", and taps Search Drivers.',
    driverTitle: 'Driver Online',
    driverBody:
        'Pedro switches to Online. The app shows a pulsing indicator — he\'s now visible to passengers.',
    passengerIcon: Icons.search_rounded,
    driverIcon: Icons.wifi_rounded,
    passengerAccent: AppColors.primary,
    driverAccent: AppColors.success,
  ),
  _Step(
    id: _StepId.requestSent,
    label: 'Request',
    passengerTitle: 'Ride Request Sent',
    passengerBody:
        'Juan sees Pedro\'s profile — ₱65 fare, 4.9 ★, 3 mins away. He taps "Order Ride".',
    driverTitle: 'New Request!',
    driverBody:
        'Pedro gets an alert with a 30-second countdown. He sees the fare ₱65, pickup & drop-off.',
    passengerIcon: Icons.send_rounded,
    driverIcon: Icons.notifications_active_rounded,
    passengerAccent: AppColors.amber,
    driverAccent: AppColors.amber,
  ),
  _Step(
    id: _StepId.driverAccepted,
    label: 'Accepted',
    passengerTitle: 'Driver Accepted!',
    passengerBody:
        'Pedro accepted the ride. Juan sees a live map with Pedro\'s location moving toward him.',
    driverTitle: 'Ride Accepted',
    driverBody:
        'Pedro taps Accept. The app shows navigation to Juan\'s pickup at SM City Cebu.',
    passengerIcon: Icons.check_circle_rounded,
    driverIcon: Icons.navigation_rounded,
    passengerAccent: AppColors.success,
    driverAccent: AppColors.primary,
  ),
  _Step(
    id: _StepId.driverEnRoute,
    label: 'En Route',
    passengerTitle: 'Driver On the Way',
    passengerBody:
        'Juan tracks Pedro in real-time. ETA: 3 mins. He can call, message, or share his location.',
    driverTitle: 'Heading to Pickup',
    driverBody:
        'Pedro follows navigation. The app shows distance to pickup: 0.8 km remaining.',
    passengerIcon: Icons.location_on_rounded,
    driverIcon: Icons.two_wheeler,
    passengerAccent: AppColors.primary,
    driverAccent: AppColors.primary,
  ),
  _Step(
    id: _StepId.driverArrived,
    label: 'Arrived',
    passengerTitle: 'Driver Arrived!',
    passengerBody:
        'Juan gets a notification — Pedro has arrived at SM City Cebu. Time to board!',
    driverTitle: 'At Pickup Point',
    driverBody:
        'Pedro taps "Passenger Picked Up" to start the trip and begin navigation to Ayala Center.',
    passengerIcon: Icons.person_pin_rounded,
    driverIcon: Icons.flag_rounded,
    passengerAccent: AppColors.success,
    driverAccent: AppColors.success,
  ),
  _Step(
    id: _StepId.tripInProgress,
    label: 'Trip',
    passengerTitle: 'Trip in Progress',
    passengerBody:
        'Juan is riding. He sees the route, ETA 8 mins, and can share his live location with family.',
    driverTitle: 'Trip in Progress',
    driverBody:
        'Pedro follows navigation to Ayala Center Cebu. Fare meter is running — ₱65 confirmed.',
    passengerIcon: Icons.directions_rounded,
    driverIcon: Icons.route_rounded,
    passengerAccent: AppColors.primary,
    driverAccent: AppColors.driverAccent,
  ),
  _Step(
    id: _StepId.tripComplete,
    label: 'Done',
    passengerTitle: 'Trip Complete!',
    passengerBody:
        'Juan rates Pedro 5 stars, adds a ₱10 tip, and pays ₱75 via GCash. Receipt saved.',
    driverTitle: 'Earnings Updated',
    driverBody:
        'Pedro\'s dashboard shows +₱65. Daily total: ₱912.50. He\'s ready for the next ride.',
    passengerIcon: Icons.star_rounded,
    driverIcon: Icons.monetization_on_rounded,
    passengerAccent: AppColors.amber,
    driverAccent: AppColors.driverAccent,
  ),
];

// ── Showcase Screen ───────────────────────────────────────────────────────────

class ShowcaseScreen extends StatefulWidget {
  const ShowcaseScreen({super.key});

  @override
  State<ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  bool _autoPlay = false;
  Timer? _autoTimer;
  late AnimationController _progressCtrl;
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _progressCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    if (index < 0 || index >= _steps.length) return;
    setState(() => _currentStep = index);
    _progressCtrl.forward(from: 0);
  }

  void _next() => _goTo(_currentStep + 1);
  void _prev() => _goTo(_currentStep - 1);

  void _toggleAutoPlay() {
    setState(() => _autoPlay = !_autoPlay);
    if (_autoPlay) {
      _progressCtrl.forward(from: 0);
      _autoTimer = Timer.periodic(const Duration(seconds: 4), (_) {
        if (!mounted) return;
        if (_currentStep < _steps.length - 1) {
          _goTo(_currentStep + 1);
        } else {
          _toggleAutoPlay(); // stop at end
        }
      });
    } else {
      _autoTimer?.cancel();
      _progressCtrl.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStep];
    final isLast = _currentStep == _steps.length - 1;
    final isFirst = _currentStep == 0;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1E),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──────────────────────────────────────────────────────
            _TopBar(
              onClose: () => context.go('/'),
              autoPlay: _autoPlay,
              onToggleAutoPlay: _toggleAutoPlay,
              progressCtrl: _progressCtrl,
              autoPlayActive: _autoPlay,
            ),

            // ── Step indicator ───────────────────────────────────────────────
            _StepIndicator(steps: _steps, current: _currentStep, onTap: _goTo),

            const SizedBox(height: 12),

            // ── Step label ───────────────────────────────────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _stepPhrase(step.id),
                key: ValueKey(_currentStep),
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Split panels ─────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    // Passenger panel
                    Expanded(
                      child: _Panel(
                        key: ValueKey('p_$_currentStep'),
                        role: 'PASSENGER',
                        name: 'Juan Dela Cruz',
                        title: step.passengerTitle,
                        body: step.passengerBody,
                        icon: step.passengerIcon,
                        accent: step.passengerAccent,
                        isPassenger: true,
                        stepId: step.id,
                        pulseCtrl: _pulseCtrl,
                      ),
                    ),

                    // Divider with lightning bolt
                    _CenterDivider(stepId: step.id),

                    // Driver panel
                    Expanded(
                      child: _Panel(
                        key: ValueKey('d_$_currentStep'),
                        role: 'DRIVER',
                        name: 'Pedro Santos',
                        title: step.driverTitle,
                        body: step.driverBody,
                        icon: step.driverIcon,
                        accent: step.driverAccent,
                        isPassenger: false,
                        stepId: step.id,
                        pulseCtrl: _pulseCtrl,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Navigation controls ──────────────────────────────────────────
            _NavControls(
              onPrev: isFirst ? null : _prev,
              onNext: isLast ? null : _next,
              onRestart: isLast ? () => _goTo(0) : null,
              onLaunchPassenger: () {
                context.go('/home');
              },
              onLaunchDriver: () {
                context.go('/driver-home');
              },
              currentStep: _currentStep,
              totalSteps: _steps.length,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _stepPhrase(_StepId id) {
    switch (id) {
      case _StepId.idle:
        return 'STEP 1 OF 8  ·  INITIAL STATE';
      case _StepId.passengerSearching:
        return 'STEP 2 OF 8  ·  BOOKING FLOW';
      case _StepId.requestSent:
        return 'STEP 3 OF 8  ·  RIDE REQUEST';
      case _StepId.driverAccepted:
        return 'STEP 4 OF 8  ·  ACCEPTANCE';
      case _StepId.driverEnRoute:
        return 'STEP 5 OF 8  ·  EN ROUTE';
      case _StepId.driverArrived:
        return 'STEP 6 OF 8  ·  ARRIVAL';
      case _StepId.tripInProgress:
        return 'STEP 7 OF 8  ·  ACTIVE TRIP';
      case _StepId.tripComplete:
        return 'STEP 8 OF 8  ·  COMPLETION';
    }
  }
}

// ── Top Bar ───────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final VoidCallback onClose;
  final bool autoPlay;
  final VoidCallback onToggleAutoPlay;
  final AnimationController progressCtrl;
  final bool autoPlayActive;

  const _TopBar({
    required this.onClose,
    required this.autoPlay,
    required this.onToggleAutoPlay,
    required this.progressCtrl,
    required this.autoPlayActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          // Close
          GestureDetector(
            onTap: onClose,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white60, size: 18),
            ),
          ),
          const SizedBox(width: 12),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Live Demo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'Passenger ↔ Driver transaction',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Auto-play toggle
          GestureDetector(
            onTap: onToggleAutoPlay,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: autoPlay
                    ? AppColors.primary.withValues(alpha: 0.25)
                    : Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: autoPlay
                      ? AppColors.primary.withValues(alpha: 0.6)
                      : Colors.white.withValues(alpha: 0.12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    autoPlay ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: autoPlay ? AppColors.primaryLight : Colors.white60,
                    size: 15,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    autoPlay ? 'Pause' : 'Auto',
                    style: TextStyle(
                      color: autoPlay ? AppColors.primaryLight : Colors.white60,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step Indicator ────────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  final List<_Step> steps;
  final int current;
  final ValueChanged<int> onTap;

  const _StepIndicator({
    required this.steps,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        children: steps.asMap().entries.map((e) {
          final i = e.key;
          final step = e.value;
          final done = i < current;
          final active = i == current;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 3,
                      decoration: BoxDecoration(
                        color: done
                            ? AppColors.primary
                            : active
                            ? AppColors.primaryLight
                            : Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      step.label,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                        color: active
                            ? Colors.white
                            : done
                            ? AppColors.primaryLight.withValues(alpha: 0.7)
                            : Colors.white.withValues(alpha: 0.3),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Center Divider ────────────────────────────────────────────────────────────

class _CenterDivider extends StatelessWidget {
  final _StepId stepId;

  const _CenterDivider({required this.stepId});

  @override
  Widget build(BuildContext context) {
    final isActive = stepId != _StepId.idle;
    return SizedBox(
      width: 28,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 1,
            height: 60,
            color: Colors.white.withValues(alpha: 0.08),
          ),
          const SizedBox(height: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.06),
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive
                    ? AppColors.primary.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: Icon(
              isActive ? Icons.bolt_rounded : Icons.more_horiz,
              color: isActive ? AppColors.primaryLight : Colors.white30,
              size: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 1,
            height: 60,
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ],
      ),
    );
  }
}

// ── Panel ─────────────────────────────────────────────────────────────────────

class _Panel extends StatelessWidget {
  final String role;
  final String name;
  final String title;
  final String body;
  final IconData icon;
  final Color accent;
  final bool isPassenger;
  final _StepId stepId;
  final AnimationController pulseCtrl;

  const _Panel({
    super.key,
    required this.role,
    required this.name,
    required this.title,
    required this.body,
    required this.icon,
    required this.accent,
    required this.isPassenger,
    required this.stepId,
    required this.pulseCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isPassenger ? const Color(0xFF0D1B3E) : const Color(0xFF0F172A);
    final borderColor = isPassenger
        ? AppColors.primary.withValues(alpha: 0.25)
        : AppColors.driverBorder;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          // Panel header
          Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            decoration: BoxDecoration(
              color: isPassenger
                  ? AppColors.primary.withValues(alpha: 0.12)
                  : Colors.white.withValues(alpha: 0.04),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(17),
                topRight: Radius.circular(17),
              ),
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                    border: Border.all(color: accent.withValues(alpha: 0.4)),
                  ),
                  child: Center(
                    child: Text(
                      name.split(' ').map((n) => n[0]).join(),
                      style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        role,
                        style: TextStyle(
                          color: accent,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status dot
                _StatusDot(
                  stepId: stepId,
                  isPassenger: isPassenger,
                  pulseCtrl: pulseCtrl,
                ),
              ],
            ),
          ),

          // Panel body
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // Mock screen visual
                  Expanded(
                    child:
                        _MockScreen(
                              stepId: stepId,
                              isPassenger: isPassenger,
                              accent: accent,
                              pulseCtrl: pulseCtrl,
                            )
                            .animate()
                            .fadeIn(duration: 350.ms)
                            .scale(
                              begin: const Offset(0.96, 0.96),
                              end: const Offset(1, 1),
                              duration: 350.ms,
                              curve: Curves.easeOut,
                            ),
                  ),

                  const SizedBox(height: 10),

                  // Text description
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.07),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(icon, color: accent, size: 13),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                title,
                                style: TextStyle(
                                  color: accent,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          body,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 10.5,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Status Dot ────────────────────────────────────────────────────────────────

class _StatusDot extends StatelessWidget {
  final _StepId stepId;
  final bool isPassenger;
  final AnimationController pulseCtrl;

  const _StatusDot({
    required this.stepId,
    required this.isPassenger,
    required this.pulseCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = isPassenger
        ? stepId != _StepId.idle
        : stepId == _StepId.passengerSearching ||
              stepId == _StepId.requestSent ||
              stepId == _StepId.driverAccepted ||
              stepId == _StepId.driverEnRoute ||
              stepId == _StepId.driverArrived ||
              stepId == _StepId.tripInProgress;

    final color = isActive ? AppColors.success : Colors.white24;

    return AnimatedBuilder(
      animation: pulseCtrl,
      builder: (_, __) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: isActive
              ? Color.lerp(
                  AppColors.success,
                  AppColors.successLight,
                  pulseCtrl.value * 0.4,
                )
              : Colors.white24,
          shape: BoxShape.circle,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.5 * pulseCtrl.value),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}

// ── Mock Screen ───────────────────────────────────────────────────────────────
// Each step renders a simplified but recognizable UI mockup inside the panel.

class _MockScreen extends StatelessWidget {
  final _StepId stepId;
  final bool isPassenger;
  final Color accent;
  final AnimationController pulseCtrl;

  const _MockScreen({
    required this.stepId,
    required this.isPassenger,
    required this.accent,
    required this.pulseCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: isPassenger ? _buildPassengerMock() : _buildDriverMock(),
    );
  }

  Widget _buildPassengerMock() {
    switch (stepId) {
      case _StepId.idle:
      case _StepId.passengerSearching:
        return _MockHomeScreen(accent: accent);
      case _StepId.requestSent:
        return _MockDriverCard(accent: accent);
      case _StepId.driverAccepted:
      case _StepId.driverEnRoute:
      case _StepId.driverArrived:
        return _MockTrackingScreen(
          accent: accent,
          pulseCtrl: pulseCtrl,
          arrived: stepId == _StepId.driverArrived,
        );
      case _StepId.tripInProgress:
        return _MockOngoingScreen(accent: accent, pulseCtrl: pulseCtrl);
      case _StepId.tripComplete:
        return _MockCompleteScreen(accent: accent);
    }
  }

  Widget _buildDriverMock() {
    switch (stepId) {
      case _StepId.idle:
        return _MockDriverOffline();
      case _StepId.passengerSearching:
        return _MockDriverOnline(pulseCtrl: pulseCtrl);
      case _StepId.requestSent:
        return _MockRideRequest(accent: accent, pulseCtrl: pulseCtrl);
      case _StepId.driverAccepted:
      case _StepId.driverEnRoute:
      case _StepId.driverArrived:
        return _MockDriverNavigation(
          accent: accent,
          pulseCtrl: pulseCtrl,
          arrived: stepId == _StepId.driverArrived,
        );
      case _StepId.tripInProgress:
        return _MockDriverTrip(accent: accent, pulseCtrl: pulseCtrl);
      case _StepId.tripComplete:
        return _MockDriverEarnings(accent: accent);
    }
  }
}

// ── Passenger mock screens ────────────────────────────────────────────────────

class _MockHomeScreen extends StatelessWidget {
  final Color accent;
  const _MockHomeScreen({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D1B3E),
      child: Column(
        children: [
          // Header
          Container(
            height: 52,
            color: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.white24,
                  child: Text(
                    'JD',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Good morning,',
                        style: TextStyle(color: Colors.white60, fontSize: 7),
                      ),
                      const Text(
                        'Juan Dela Cruz',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white60,
                  size: 14,
                ),
              ],
            ),
          ),
          // Search bar
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: AppColors.primary, size: 12),
                const SizedBox(width: 5),
                const Expanded(
                  child: Text(
                    'Where do you want to go?',
                    style: TextStyle(color: Colors.black38, fontSize: 8),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Go',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 7,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Ride types
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  _MiniRideCard(
                    label: 'Habal-habal',
                    color: AppColors.primary,
                    icon: Icons.two_wheeler,
                  ),
                  const SizedBox(height: 4),
                  _MiniRideCard(
                    label: 'Motorela',
                    color: AppColors.error,
                    icon: Icons.two_wheeler,
                  ),
                  const SizedBox(height: 4),
                  _MiniRideCard(
                    label: 'Bao-bao',
                    color: AppColors.amber,
                    icon: Icons.directions_car,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniRideCard extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  const _MiniRideCard({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(icon, color: color, size: 11),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          const Icon(Icons.chevron_right, color: Colors.white30, size: 12),
        ],
      ),
    );
  }
}

class _MockDriverCard extends StatelessWidget {
  final Color accent;
  const _MockDriverCard({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D1B3E),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Map area
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0F8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  CustomPaint(painter: _MiniMapPainter(), size: Size.infinite),
                  Center(
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.amber,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.two_wheeler,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          // Driver info card
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        'PS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pedro Santos',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 9,
                                color: AppColors.amber,
                              ),
                              const Text(
                                ' 4.9 · ABC 1234',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      '₱65',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(
                    child: Text(
                      'Order Ride',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MockTrackingScreen extends StatelessWidget {
  final Color accent;
  final AnimationController pulseCtrl;
  final bool arrived;
  const _MockTrackingScreen({
    required this.accent,
    required this.pulseCtrl,
    required this.arrived,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D1B3E),
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFFE8F0F8),
              child: Stack(
                children: [
                  CustomPaint(painter: _MiniMapPainter(), size: Size.infinite),
                  // Route line
                  CustomPaint(
                    painter: _MiniRoutePainter(),
                    size: Size.infinite,
                  ),
                  // Driver marker
                  AnimatedBuilder(
                    animation: pulseCtrl,
                    builder: (_, __) => Positioned(
                      top: arrived ? 30 : 30 + 20 * (1 - pulseCtrl.value),
                      left: arrived ? 40 : 40 + 10 * (1 - pulseCtrl.value),
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.amber,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: const Icon(
                          Icons.two_wheeler,
                          color: Colors.white,
                          size: 9,
                        ),
                      ),
                    ),
                  ),
                  // Your location
                  Positioned(
                    bottom: 30,
                    right: 30,
                    child: AnimatedBuilder(
                      animation: pulseCtrl,
                      builder: (_, __) => Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(
                                alpha: 0.4 * pulseCtrl.value,
                              ),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    'PS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 7,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pedro Santos',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        arrived ? 'Driver arrived!' : '3 mins away',
                        style: TextStyle(
                          fontSize: 8,
                          color: arrived
                              ? AppColors.success
                              : AppColors.textTertiary,
                          fontWeight: arrived
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: arrived ? AppColors.success : AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    arrived ? 'Arrived!' : '₱65',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MockOngoingScreen extends StatelessWidget {
  final Color accent;
  final AnimationController pulseCtrl;
  const _MockOngoingScreen({required this.accent, required this.pulseCtrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D1B3E),
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFFE8F0F8),
              child: Stack(
                children: [
                  CustomPaint(painter: _MiniMapPainter(), size: Size.infinite),
                  CustomPaint(
                    painter: _MiniRoutePainter(),
                    size: Size.infinite,
                  ),
                  AnimatedBuilder(
                    animation: pulseCtrl,
                    builder: (_, __) => Positioned(
                      top: 20 + 30 * pulseCtrl.value,
                      left: 20 + 20 * pulseCtrl.value,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.amber,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.navigation,
                          color: Colors.white,
                          size: 10,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Ride Ongoing',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 7,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      '8 mins',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const Text(
                      ' · ',
                      style: TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 9,
                      ),
                    ),
                    const Text(
                      '3.2 km',
                      style: TextStyle(
                        fontSize: 9,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.share_outlined,
                      color: AppColors.primary,
                      size: 12,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.amber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: AppColors.amber.withValues(alpha: 0.4),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Share Location',
                      style: TextStyle(
                        color: AppColors.amber,
                        fontSize: 7,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MockCompleteScreen extends StatelessWidget {
  final Color accent;
  const _MockCompleteScreen({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D1B3E),
      child: Column(
        children: [
          Container(
            height: 60,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.success, Color(0xFF15803D)],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: Colors.white,
                  size: 22,
                ),
                const Text(
                  'Trip Complete!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (i) => Icon(
                        Icons.star_rounded,
                        color: i < 5 ? AppColors.amber : AppColors.border,
                        size: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '₱75.00',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Text(
                    'Fare ₱65 + Tip ₱10',
                    style: TextStyle(
                      fontSize: 7,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text(
                        'Pay via GCash',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Driver mock screens ───────────────────────────────────────────────────────

class _MockDriverOffline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.driverBg,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              const CircleAvatar(
                radius: 12,
                backgroundColor: Color(0xFF1E3A5F),
                child: Text(
                  'PS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 7,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pedro Santos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '4.9 · Habal-habal',
                      style: TextStyle(color: Colors.white38, fontSize: 7),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.settings_outlined,
                color: Colors.white30,
                size: 12,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Offline toggle
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.driverSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.driverBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.wifi_off_rounded,
                    color: Colors.white38,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "You're Offline",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Tap to go online',
                        style: TextStyle(color: Colors.white38, fontSize: 7),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Earnings preview
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.driverSurface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.driverBorder),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.monetization_on_outlined,
                  color: AppColors.driverTextMuted,
                  size: 12,
                ),
                const SizedBox(width: 5),
                const Text(
                  'Today',
                  style: TextStyle(
                    color: AppColors.driverTextMuted,
                    fontSize: 8,
                  ),
                ),
                const Spacer(),
                Text(
                  '₱847.50',
                  style: TextStyle(
                    color: AppColors.driverAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MockDriverOnline extends StatelessWidget {
  final AnimationController pulseCtrl;
  const _MockDriverOnline({required this.pulseCtrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.driverBg,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 12,
                backgroundColor: Color(0xFF1E3A5F),
                child: Text(
                  'PS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 7,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Pedro Santos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Online toggle with pulse
          AnimatedBuilder(
            animation: pulseCtrl,
            builder: (_, __) => Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(
                  alpha: 0.1 + 0.05 * pulseCtrl.value,
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.success.withValues(
                    alpha: 0.3 + 0.2 * pulseCtrl.value,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.success.withValues(
                            alpha: 0.4 * pulseCtrl.value,
                          ),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.wifi_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "You're Online",
                          style: TextStyle(
                            color: AppColors.success,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Waiting for requests...',
                          style: TextStyle(color: Colors.white38, fontSize: 7),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          const Text(
            'Waiting for a ride request...',
            style: TextStyle(color: Colors.white24, fontSize: 8),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MockRideRequest extends StatelessWidget {
  final Color accent;
  final AnimationController pulseCtrl;
  const _MockRideRequest({required this.accent, required this.pulseCtrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.driverBg,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Timer ring
          AnimatedBuilder(
            animation: pulseCtrl,
            builder: (_, __) => Center(
              child: SizedBox(
                width: 44,
                height: 44,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: 1 - pulseCtrl.value * 0.3,
                      strokeWidth: 3,
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation(
                        AppColors.driverAccent,
                      ),
                    ),
                    const Text(
                      '28',
                      style: TextStyle(
                        color: AppColors.driverAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'New Ride Request!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.driverSurface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.driverBorder),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 10,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        'AR',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 6,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Expanded(
                      child: Text(
                        'Ana Reyes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '₱65',
                      style: TextStyle(
                        color: AppColors.driverAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                _MiniRoute(pickup: 'SM City Cebu', dropoff: 'Ayala Center'),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.error),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Text(
                      'Decline',
                      style: TextStyle(
                        color: AppColors.error,
                        fontSize: 7,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                flex: 2,
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Text(
                      'Accept Ride',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 7,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MockDriverNavigation extends StatelessWidget {
  final Color accent;
  final AnimationController pulseCtrl;
  final bool arrived;
  const _MockDriverNavigation({
    required this.accent,
    required this.pulseCtrl,
    required this.arrived,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.driverBg,
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFFE8F0F8),
              child: Stack(
                children: [
                  CustomPaint(painter: _MiniMapPainter(), size: Size.infinite),
                  CustomPaint(
                    painter: _MiniRoutePainter(),
                    size: Size.infinite,
                  ),
                  AnimatedBuilder(
                    animation: pulseCtrl,
                    builder: (_, __) => Positioned(
                      top: arrived ? 25 : 25 + 25 * (1 - pulseCtrl.value),
                      left: arrived ? 35 : 35 + 15 * (1 - pulseCtrl.value),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.driverAccent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.two_wheeler,
                          color: Colors.white,
                          size: 10,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: arrived
                              ? AppColors.success
                              : AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          arrived ? 'At Pickup' : 'Heading to Pickup',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 7,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: AppColors.driverBg,
            child: Column(
              children: [
                _MiniRoute(pickup: 'SM City Cebu', dropoff: 'Ayala Center'),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  height: 20,
                  decoration: BoxDecoration(
                    color: arrived ? AppColors.success : AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      arrived ? 'Passenger Picked Up' : 'Navigating...',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 7,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MockDriverTrip extends StatelessWidget {
  final Color accent;
  final AnimationController pulseCtrl;
  const _MockDriverTrip({required this.accent, required this.pulseCtrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.driverBg,
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFFE8F0F8),
              child: Stack(
                children: [
                  CustomPaint(painter: _MiniMapPainter(), size: Size.infinite),
                  CustomPaint(
                    painter: _MiniRoutePainter(),
                    size: Size.infinite,
                  ),
                  AnimatedBuilder(
                    animation: pulseCtrl,
                    builder: (_, __) => Positioned(
                      top: 15 + 35 * pulseCtrl.value,
                      left: 15 + 25 * pulseCtrl.value,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.driverAccent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.navigation,
                          color: Colors.white,
                          size: 10,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Trip in Progress',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 7,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: AppColors.driverBg,
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ana Reyes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '→ Ayala Center Cebu',
                        style: TextStyle(color: Colors.white38, fontSize: 7),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₱65',
                      style: TextStyle(
                        color: AppColors.driverAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text(
                      '~8 mins',
                      style: TextStyle(color: Colors.white38, fontSize: 7),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MockDriverEarnings extends StatelessWidget {
  final Color accent;
  const _MockDriverEarnings({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.driverBg,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.driverAccent.withValues(alpha: 0.2),
                  AppColors.driverAccent.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.driverAccent.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Today\'s Earnings',
                  style: TextStyle(
                    color: AppColors.driverTextMuted,
                    fontSize: 7,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '₱912.50',
                  style: TextStyle(
                    color: AppColors.driverAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Text(
                  '13 trips completed',
                  style: TextStyle(color: Colors.white38, fontSize: 7),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Mini bar chart
          SizedBox(
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [0.5, 0.7, 0.4, 0.8, 0.9, 1.0, 0.95]
                  .asMap()
                  .entries
                  .map((e) {
                    final isLast = e.key == 6;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1.5),
                        child: Container(
                          height: 40 * e.value,
                          decoration: BoxDecoration(
                            color: isLast
                                ? AppColors.driverAccent
                                : AppColors.primary.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    );
                  })
                  .toList(),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.driverSurface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.driverBorder),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.success,
                  size: 12,
                ),
                const SizedBox(width: 5),
                const Expanded(
                  child: Text(
                    'Trip #13 completed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  '+₱65',
                  style: TextStyle(
                    color: AppColors.driverAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared mini widgets ───────────────────────────────────────────────────────

class _MiniRoute extends StatelessWidget {
  final String pickup;
  final String dropoff;
  const _MiniRoute({required this.pickup, required this.dropoff});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                pickup,
                style: const TextStyle(color: Colors.white60, fontSize: 7),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2.5),
          child: Container(width: 1, height: 6, color: Colors.white24),
        ),
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                dropoff,
                style: const TextStyle(color: Colors.white60, fontSize: 7),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()..color = Colors.white.withValues(alpha: 0.85);
    final minor = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.35, size.width, 5), road);
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.7, size.width, 7), road);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.45, 0, 5, size.height), road);
    canvas.drawLine(
      Offset(0, size.height * 0.15),
      Offset(size.width, size.height * 0.15),
      minor,
    );
    canvas.drawLine(
      Offset(size.width * 0.2, 0),
      Offset(size.width * 0.2, size.height),
      minor,
    );
    canvas.drawLine(
      Offset(size.width * 0.75, 0),
      Offset(size.width * 0.75, size.height),
      minor,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

class _MiniRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(size.width * 0.25, size.height * 0.8)
      ..quadraticBezierTo(
        size.width * 0.4,
        size.height * 0.5,
        size.width * 0.65,
        size.height * 0.2,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Nav Controls ──────────────────────────────────────────────────────────────

class _NavControls extends StatelessWidget {
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final VoidCallback? onRestart;
  final VoidCallback onLaunchPassenger;
  final VoidCallback onLaunchDriver;
  final int currentStep;
  final int totalSteps;

  const _NavControls({
    required this.onPrev,
    required this.onNext,
    required this.onRestart,
    required this.onLaunchPassenger,
    required this.onLaunchDriver,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final isLast = onRestart != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          if (isLast) ...[
            // Launch buttons on last step
            Row(
              children: [
                Expanded(
                  child: _LaunchBtn(
                    label: 'Try Passenger',
                    icon: Icons.person_rounded,
                    color: AppColors.primary,
                    onTap: onLaunchPassenger,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _LaunchBtn(
                    label: 'Try Driver',
                    icon: Icons.two_wheeler,
                    color: AppColors.driverAccent,
                    textColor: AppColors.driverBg,
                    onTap: onLaunchDriver,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: onRestart,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.replay_rounded,
                    color: Colors.white38,
                    size: 14,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Restart demo',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Prev / Next navigation
            Row(
              children: [
                // Prev
                GestureDetector(
                  onTap: onPrev,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: onPrev != null
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.white.withValues(alpha: 0.03),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: onPrev != null
                            ? Colors.white.withValues(alpha: 0.15)
                            : Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: onPrev != null ? Colors.white70 : Colors.white24,
                      size: 18,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Progress text
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${currentStep + 1} / $totalSteps',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: (currentStep + 1) / totalSteps,
                          backgroundColor: Colors.white.withValues(alpha: 0.08),
                          valueColor: const AlwaysStoppedAnimation(
                            AppColors.primary,
                          ),
                          minHeight: 3,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Next
                GestureDetector(
                  onTap: onNext,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: onNext != null
                          ? AppColors.primary.withValues(alpha: 0.25)
                          : Colors.white.withValues(alpha: 0.03),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: onNext != null
                            ? AppColors.primary.withValues(alpha: 0.5)
                            : Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: onNext != null
                          ? AppColors.primaryLight
                          : Colors.white24,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _LaunchBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _LaunchBtn({
    required this.label,
    required this.icon,
    required this.color,
    this.textColor = Colors.white,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 16),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
