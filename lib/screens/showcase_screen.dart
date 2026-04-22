import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DATA MODEL
// ─────────────────────────────────────────────────────────────────────────────

enum _Phase {
  idle,
  searching,
  requested,
  accepted,
  enRoute,
  arrived,
  inTrip,
  complete,
}

class _StepData {
  final _Phase phase;
  final String label;
  final String pTitle;
  final String pDesc;
  final String dTitle;
  final String dDesc;
  final IconData pIcon;
  final IconData dIcon;
  final Color pColor;
  final Color dColor;

  const _StepData({
    required this.phase,
    required this.label,
    required this.pTitle,
    required this.pDesc,
    required this.dTitle,
    required this.dDesc,
    required this.pIcon,
    required this.dIcon,
    required this.pColor,
    required this.dColor,
  });
}

const List<_StepData> _kSteps = [
  _StepData(
    phase: _Phase.idle,
    label: 'Start',
    pTitle: 'Home Screen',
    pDesc:
        'Juan opens Pasahero. He sees Habal-habal, Motorela, and Bao-bao options ready to book.',
    dTitle: 'Driver Offline',
    dDesc:
        'Pedro is offline. His dashboard shows today\'s earnings. He taps the toggle to go online.',
    pIcon: Icons.home_rounded,
    dIcon: Icons.wifi_off_rounded,
    pColor: AppColors.primary,
    dColor: AppColors.driverTextMuted,
  ),
  _StepData(
    phase: _Phase.searching,
    label: 'Book',
    pTitle: 'Searching Drivers',
    pDesc:
        'Juan picks Habal-habal, types "Ayala Center Cebu" as destination, and taps Search Drivers.',
    dTitle: 'Driver Online',
    dDesc:
        'Pedro goes online. A green pulse shows he\'s now visible and accepting ride requests.',
    pIcon: Icons.search_rounded,
    dIcon: Icons.wifi_rounded,
    pColor: AppColors.primary,
    dColor: AppColors.success,
  ),
  _StepData(
    phase: _Phase.requested,
    label: 'Request',
    pTitle: 'Request Sent',
    pDesc:
        'Juan sees Pedro\'s card — ₱65 fare, ★4.9, 3 mins away. He taps "Order Ride".',
    dTitle: 'Incoming Request!',
    dDesc:
        'Pedro gets a 30-second alert showing ₱65 fare, pickup at SM City, drop-off at Ayala.',
    pIcon: Icons.send_rounded,
    dIcon: Icons.notifications_active_rounded,
    pColor: AppColors.amber,
    dColor: AppColors.amber,
  ),
  _StepData(
    phase: _Phase.accepted,
    label: 'Accept',
    pTitle: 'Driver Accepted!',
    pDesc:
        'Pedro accepted. Juan sees a live map with Pedro\'s bike moving toward his location.',
    dTitle: 'Ride Accepted',
    dDesc:
        'Pedro taps Accept. Navigation starts — heading to SM City Cebu to pick up Juan.',
    pIcon: Icons.check_circle_rounded,
    dIcon: Icons.navigation_rounded,
    pColor: AppColors.success,
    dColor: AppColors.primary,
  ),
  _StepData(
    phase: _Phase.enRoute,
    label: 'En Route',
    pTitle: 'Driver On the Way',
    pDesc:
        'ETA: 3 mins. Juan can call Pedro, send a message, or share his live location with family.',
    dTitle: 'Heading to Pickup',
    dDesc:
        'Pedro follows the route. Distance to pickup: 0.8 km. Passenger details visible on screen.',
    pIcon: Icons.location_on_rounded,
    dIcon: Icons.two_wheeler,
    pColor: AppColors.primary,
    dColor: AppColors.primary,
  ),
  _StepData(
    phase: _Phase.arrived,
    label: 'Arrived',
    pTitle: 'Driver Arrived!',
    pDesc:
        'Pedro is at SM City Cebu. Juan gets a notification and heads to the pickup point.',
    dTitle: 'At Pickup Point',
    dDesc:
        'Pedro taps "Passenger Picked Up" to confirm boarding and start navigation to Ayala.',
    pIcon: Icons.person_pin_rounded,
    dIcon: Icons.flag_rounded,
    pColor: AppColors.success,
    dColor: AppColors.success,
  ),
  _StepData(
    phase: _Phase.inTrip,
    label: 'Trip',
    pTitle: 'Trip in Progress',
    pDesc:
        'Juan is riding. ETA 8 mins, 3.2 km. He shares his live location with his family.',
    dTitle: 'Trip in Progress',
    dDesc:
        'Pedro navigates to Ayala Center. Fare ₱65 confirmed. Trip timer running.',
    pIcon: Icons.directions_rounded,
    dIcon: Icons.route_rounded,
    pColor: AppColors.primary,
    dColor: AppColors.driverAccent,
  ),
  _StepData(
    phase: _Phase.complete,
    label: 'Done',
    pTitle: 'Trip Complete!',
    pDesc:
        'Juan rates Pedro ★5, adds ₱10 tip, pays ₱75 via GCash. Receipt saved automatically.',
    dTitle: 'Earnings Updated',
    dDesc:
        'Pedro\'s dashboard: +₱65 added. Daily total ₱912.50. 13 trips. Ready for next ride.',
    pIcon: Icons.star_rounded,
    dIcon: Icons.monetization_on_rounded,
    pColor: AppColors.amber,
    dColor: AppColors.driverAccent,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// SHOWCASE SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class ShowcaseScreen extends StatefulWidget {
  const ShowcaseScreen({super.key});

  @override
  State<ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen>
    with SingleTickerProviderStateMixin {
  int _step = 0;
  bool _autoPlay = false;
  Timer? _timer;

  // Pulse animation lives here — never recreated
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _timer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  void _goTo(int i) {
    if (i < 0 || i >= _kSteps.length) return;
    setState(() => _step = i);
  }

  void _toggleAuto() {
    if (_autoPlay) {
      _timer?.cancel();
      setState(() => _autoPlay = false);
    } else {
      setState(() => _autoPlay = true);
      _timer = Timer.periodic(const Duration(seconds: 3), (_) {
        if (!mounted) return;
        if (_step < _kSteps.length - 1) {
          setState(() => _step++);
        } else {
          _timer?.cancel();
          setState(() => _autoPlay = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _kSteps[_step];
    final isLast = _step == _kSteps.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFF060B18),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────────────────
            _Header(
              onClose: () => context.go('/'),
              autoPlay: _autoPlay,
              onToggleAuto: _toggleAuto,
            ),

            // ── Step pills ───────────────────────────────────────────────────
            _StepPills(steps: _kSteps, current: _step, onTap: _goTo),

            const SizedBox(height: 8),

            // ── Phase label ──────────────────────────────────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Text(
                'STEP ${_step + 1} OF ${_kSteps.length}  ·  ${s.label.toUpperCase()}',
                key: ValueKey(_step),
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 10,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ── Split view ───────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Passenger side
                    Expanded(
                      child: _SidePanel(
                        isPassenger: true,
                        phase: s.phase,
                        title: s.pTitle,
                        desc: s.pDesc,
                        icon: s.pIcon,
                        accent: s.pColor,
                        pulse: _pulse,
                        stepIndex: _step,
                      ),
                    ),

                    // Center connector
                    _Connector(phase: s.phase),

                    // Driver side
                    Expanded(
                      child: _SidePanel(
                        isPassenger: false,
                        phase: s.phase,
                        title: s.dTitle,
                        desc: s.dDesc,
                        icon: s.dIcon,
                        accent: s.dColor,
                        pulse: _pulse,
                        stepIndex: _step,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ── Controls ─────────────────────────────────────────────────────
            if (isLast)
              _LaunchRow(
                onPassenger: () => context.go('/home'),
                onDriver: () => context.go('/driver-home'),
                onRestart: () => _goTo(0),
              )
            else
              _NavRow(
                step: _step,
                total: _kSteps.length,
                onPrev: _step > 0 ? () => _goTo(_step - 1) : null,
                onNext: () => _goTo(_step + 1),
              ),

            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HEADER
// ─────────────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final VoidCallback onClose;
  final bool autoPlay;
  final VoidCallback onToggleAuto;

  const _Header({
    required this.onClose,
    required this.autoPlay,
    required this.onToggleAuto,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      child: Row(
        children: [
          _CircleBtn(icon: Icons.close, onTap: onClose),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Live Demo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'Passenger ↔ Driver transaction walkthrough',
                  style: TextStyle(color: Colors.white38, fontSize: 10),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onToggleAuto,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: autoPlay
                    ? AppColors.primary.withValues(alpha: 0.22)
                    : Colors.white.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: autoPlay
                      ? AppColors.primary.withValues(alpha: 0.55)
                      : Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    autoPlay ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: autoPlay ? AppColors.primaryLight : Colors.white54,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    autoPlay ? 'Pause' : 'Auto',
                    style: TextStyle(
                      color: autoPlay ? AppColors.primaryLight : Colors.white54,
                      fontSize: 11,
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

// ─────────────────────────────────────────────────────────────────────────────
// STEP PILLS
// ─────────────────────────────────────────────────────────────────────────────

class _StepPills extends StatelessWidget {
  final List<_StepData> steps;
  final int current;
  final ValueChanged<int> onTap;

  const _StepPills({
    required this.steps,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: steps.asMap().entries.map((e) {
          final i = e.key;
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
                      duration: const Duration(milliseconds: 250),
                      height: 3,
                      decoration: BoxDecoration(
                        color: done
                            ? AppColors.primary
                            : active
                            ? AppColors.primaryLight
                            : Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      e.value.label,
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                        color: active
                            ? Colors.white
                            : done
                            ? AppColors.primaryLight.withValues(alpha: 0.6)
                            : Colors.white.withValues(alpha: 0.25),
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

// ─────────────────────────────────────────────────────────────────────────────
// CENTER CONNECTOR
// ─────────────────────────────────────────────────────────────────────────────

class _Connector extends StatelessWidget {
  final _Phase phase;
  const _Connector({required this.phase});

  @override
  Widget build(BuildContext context) {
    final active = phase != _Phase.idle;
    return SizedBox(
      width: 24,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: 1,
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: active
                  ? AppColors.primary.withValues(alpha: 0.18)
                  : Colors.white.withValues(alpha: 0.04),
              shape: BoxShape.circle,
              border: Border.all(
                color: active
                    ? AppColors.primary.withValues(alpha: 0.45)
                    : Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Icon(
              active ? Icons.bolt_rounded : Icons.more_horiz,
              color: active ? AppColors.primaryLight : Colors.white24,
              size: 12,
            ),
          ),
          Expanded(
            child: Container(
              width: 1,
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SIDE PANEL
// ─────────────────────────────────────────────────────────────────────────────

class _SidePanel extends StatelessWidget {
  final bool isPassenger;
  final _Phase phase;
  final String title;
  final String desc;
  final IconData icon;
  final Color accent;
  final AnimationController pulse;
  final int stepIndex;

  const _SidePanel({
    required this.isPassenger,
    required this.phase,
    required this.title,
    required this.desc,
    required this.icon,
    required this.accent,
    required this.pulse,
    required this.stepIndex,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isPassenger ? const Color(0xFF0C1A38) : const Color(0xFF0F172A);
    final border = isPassenger
        ? AppColors.primary.withValues(alpha: 0.2)
        : AppColors.driverBorder;
    final initials = isPassenger ? 'JD' : 'PS';
    final name = isPassenger ? 'Juan Dela Cruz' : 'Pedro Santos';
    final role = isPassenger ? 'PASSENGER' : 'DRIVER';

    // Online status
    final isOnline = isPassenger ? phase != _Phase.idle : phase != _Phase.idle;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          // ── Panel header ──────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
            decoration: BoxDecoration(
              color: isPassenger
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.03),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              border: Border(bottom: BorderSide(color: border)),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: accent.withValues(alpha: 0.35)),
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.w700,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        role,
                        style: TextStyle(
                          color: accent,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status dot
                AnimatedBuilder(
                  animation: pulse,
                  builder: (_, __) => Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: isOnline ? AppColors.success : Colors.white24,
                      shape: BoxShape.circle,
                      boxShadow: isOnline
                          ? [
                              BoxShadow(
                                color: AppColors.success.withValues(
                                  alpha: 0.5 * pulse.value,
                                ),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Mock screen ───────────────────────────────────────────────────
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              child: Stack(
                children: [
                  // The mock UI — keyed so it rebuilds on step change
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, anim) =>
                        FadeTransition(opacity: anim, child: child),
                    child: KeyedSubtree(
                      key: ValueKey('${isPassenger ? 'p' : 'd'}_$stepIndex'),
                      child: _buildMock(phase, pulse),
                    ),
                  ),

                  // Description overlay at bottom
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            bg.withValues(alpha: 0),
                            bg.withValues(alpha: 0.95),
                            bg,
                          ],
                          stops: const [0, 0.4, 1],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(icon, color: accent, size: 11),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    color: accent,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            desc,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.55),
                              fontSize: 9,
                              height: 1.4,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
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

  Widget _buildMock(_Phase p, AnimationController pulse) {
    if (isPassenger) {
      switch (p) {
        case _Phase.idle:
        case _Phase.searching:
          return _PMockHome(pulse: pulse, searching: p == _Phase.searching);
        case _Phase.requested:
          return _PMockDriverCard();
        case _Phase.accepted:
        case _Phase.enRoute:
        case _Phase.arrived:
          return _PMockTracking(pulse: pulse, arrived: p == _Phase.arrived);
        case _Phase.inTrip:
          return _PMockOngoing(pulse: pulse);
        case _Phase.complete:
          return _PMockComplete();
      }
    } else {
      switch (p) {
        case _Phase.idle:
          return _DMockOffline();
        case _Phase.searching:
          return _DMockOnline(pulse: pulse);
        case _Phase.requested:
          return _DMockRequest(pulse: pulse);
        case _Phase.accepted:
        case _Phase.enRoute:
        case _Phase.arrived:
          return _DMockNav(pulse: pulse, arrived: p == _Phase.arrived);
        case _Phase.inTrip:
          return _DMockTrip(pulse: pulse);
        case _Phase.complete:
          return _DMockEarnings();
      }
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PASSENGER MOCK SCREENS
// ─────────────────────────────────────────────────────────────────────────────

class _PMockHome extends StatelessWidget {
  final AnimationController pulse;
  final bool searching;
  const _PMockHome({required this.pulse, required this.searching});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          // Blue header
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.white24,
                      child: Text(
                        'JD',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 6,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good morning,',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 6,
                            ),
                          ),
                          Text(
                            'Juan Dela Cruz',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white60,
                      size: 12,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Search bar overlapping
          Transform.translate(
            offset: const Offset(0, -10),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.primary, size: 11),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      searching
                          ? 'Ayala Center Cebu'
                          : 'Where do you want to go?',
                      style: TextStyle(
                        color: searching
                            ? AppColors.textPrimary
                            : AppColors.textTertiary,
                        fontSize: 7,
                        fontWeight: searching
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Go',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 6,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Ride type cards
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -6),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    _MiniRideRow(
                      label: 'Habal-habal',
                      color: AppColors.primary,
                      icon: Icons.two_wheeler,
                      price: '₱25',
                      highlighted: searching,
                    ),
                    const SizedBox(height: 4),
                    _MiniRideRow(
                      label: 'Motorela',
                      color: AppColors.error,
                      icon: Icons.two_wheeler,
                      price: '₱35',
                    ),
                    const SizedBox(height: 4),
                    _MiniRideRow(
                      label: 'Bao-bao',
                      color: AppColors.amber,
                      icon: Icons.directions_car,
                      price: '₱50',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniRideRow extends StatelessWidget {
  final String label, price;
  final Color color;
  final IconData icon;
  final bool highlighted;
  const _MiniRideRow({
    required this.label,
    required this.color,
    required this.icon,
    required this.price,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: highlighted ? color.withValues(alpha: 0.06) : Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: highlighted ? color.withValues(alpha: 0.4) : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(icon, color: color, size: 10),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            price,
            style: TextStyle(
              color: color,
              fontSize: 7,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 3),
          const Icon(
            Icons.chevron_right,
            color: AppColors.textTertiary,
            size: 10,
          ),
        ],
      ),
    );
  }
}

class _PMockDriverCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          // Mini map
          Expanded(
            child: Container(
              color: const Color(0xFFE8F0F8),
              child: Stack(
                children: [
                  CustomPaint(painter: _MapPainter(), size: Size.infinite),
                  CustomPaint(painter: _RoutePainter(), size: Size.infinite),
                  Positioned(
                    top: 20,
                    left: 30,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.amber,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.two_wheeler,
                        color: Colors.white,
                        size: 8,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 25,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Driver card
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
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
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 8,
                                color: AppColors.amber,
                              ),
                              const Text(
                                ' 4.9 · ABC 1234',
                                style: TextStyle(
                                  fontSize: 7,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          '₱65',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        const Text(
                          'est. fare',
                          style: TextStyle(
                            fontSize: 6,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
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

class _PMockTracking extends StatelessWidget {
  final AnimationController pulse;
  final bool arrived;
  const _PMockTracking({required this.pulse, required this.arrived});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFFE8F0F8),
              child: Stack(
                children: [
                  CustomPaint(painter: _MapPainter(), size: Size.infinite),
                  CustomPaint(painter: _RoutePainter(), size: Size.infinite),
                  // Animated driver marker
                  AnimatedBuilder(
                    animation: pulse,
                    builder: (_, __) => Positioned(
                      top: arrived ? 18 : 18 + 22 * (1 - pulse.value),
                      left: arrived ? 28 : 28 + 12 * (1 - pulse.value),
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.amber,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.amber.withValues(alpha: 0.4),
                              blurRadius: 6,
                            ),
                          ],
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
                  AnimatedBuilder(
                    animation: pulse,
                    builder: (_, __) => Positioned(
                      bottom: 22,
                      right: 22,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(
                                alpha: 0.4 * pulse.value,
                              ),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Status pill
                  Positioned(
                    top: 6,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: arrived
                              ? AppColors.success
                              : AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          arrived ? '🎉 Driver Arrived!' : 'Driver On the Way',
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
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 10,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    'PS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 6,
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
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        arrived ? 'At your location' : '3 mins away · ABC 1234',
                        style: TextStyle(
                          fontSize: 7,
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
                Row(
                  children: [
                    _TinyBtn(icon: Icons.phone, color: AppColors.primary),
                    const SizedBox(width: 4),
                    _TinyBtn(icon: Icons.message, color: AppColors.primary),
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

class _PMockOngoing extends StatelessWidget {
  final AnimationController pulse;
  const _PMockOngoing({required this.pulse});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFFE8F0F8),
              child: Stack(
                children: [
                  CustomPaint(painter: _MapPainter(), size: Size.infinite),
                  CustomPaint(painter: _RoutePainter(), size: Size.infinite),
                  AnimatedBuilder(
                    animation: pulse,
                    builder: (_, __) => Positioned(
                      top: 15 + 30 * pulse.value,
                      left: 15 + 20 * pulse.value,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.amber,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: const Icon(
                          Icons.navigation,
                          color: Colors.white,
                          size: 9,
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
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedBuilder(
                              animation: pulse,
                              builder: (_, __) => Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(
                                    alpha: 0.5 + 0.5 * pulse.value,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Ride Ongoing',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 7,
                                fontWeight: FontWeight.w700,
                              ),
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
            color: Colors.white,
            padding: const EdgeInsets.all(7),
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
                      ' · 3.2 km',
                      style: TextStyle(
                        fontSize: 7,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.share_outlined,
                      color: AppColors.primary,
                      size: 11,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.amber.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: AppColors.amber.withValues(alpha: 0.35),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Share Live Location',
                      style: TextStyle(
                        color: AppColors.amber,
                        fontSize: 6.5,
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

class _PMockComplete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          Container(
            height: 55,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.success, Color(0xFF15803D)],
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(height: 2),
                Text(
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
                        color: AppColors.amber,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    '₱75.00',
                    style: TextStyle(
                      fontSize: 18,
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
                        'Pay via GCash  ✓',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Receipt saved',
                    style: TextStyle(
                      fontSize: 7,
                      color: AppColors.textTertiary,
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

// ─────────────────────────────────────────────────────────────────────────────
// DRIVER MOCK SCREENS
// ─────────────────────────────────────────────────────────────────────────────

class _DMockOffline extends StatelessWidget {
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
                radius: 10,
                backgroundColor: Color(0xFF1E3A5F),
                child: Text(
                  'PS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 6,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pedro Santos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '4.9 · Habal-habal',
                      style: TextStyle(color: Colors.white38, fontSize: 6),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.settings_outlined,
                color: Colors.white24,
                size: 11,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: AppColors.driverSurface,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: AppColors.driverBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.07),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.wifi_off_rounded,
                    color: Colors.white38,
                    size: 13,
                  ),
                ),
                const SizedBox(width: 7),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "You're Offline",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Tap to go online',
                        style: TextStyle(color: Colors.white38, fontSize: 6),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 28,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'OFF',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 6,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.driverSurface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.driverBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "TODAY'S EARNINGS",
                  style: TextStyle(
                    color: AppColors.driverTextMuted,
                    fontSize: 6,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₱847.50',
                  style: TextStyle(
                    color: AppColors.driverAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Text(
                  '12 trips completed',
                  style: TextStyle(color: Colors.white38, fontSize: 6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DMockOnline extends StatelessWidget {
  final AnimationController pulse;
  const _DMockOnline({required this.pulse});

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
                radius: 10,
                backgroundColor: Color(0xFF1E3A5F),
                child: Text(
                  'PS',
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
                  'Pedro Santos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: pulse,
            builder: (_, __) => Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(
                  alpha: 0.08 + 0.05 * pulse.value,
                ),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(
                  color: AppColors.success.withValues(
                    alpha: 0.25 + 0.2 * pulse.value,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 26 + 8 * pulse.value,
                        height: 26 + 8 * pulse.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.success.withValues(
                            alpha: 0.15 * (1 - pulse.value),
                          ),
                        ),
                      ),
                      Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.wifi_rounded,
                          color: Colors.white,
                          size: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 7),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "You're Online",
                          style: TextStyle(
                            color: AppColors.success,
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Waiting for requests...',
                          style: TextStyle(color: Colors.white38, fontSize: 6),
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
            'Looking for nearby passengers...',
            style: TextStyle(color: Colors.white24, fontSize: 7),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _DMockRequest extends StatelessWidget {
  final AnimationController pulse;
  const _DMockRequest({required this.pulse});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.driverBg,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Countdown ring
          AnimatedBuilder(
            animation: pulse,
            builder: (_, __) => Center(
              child: SizedBox(
                width: 42,
                height: 42,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: 0.7 - 0.2 * pulse.value,
                      strokeWidth: 3,
                      backgroundColor: Colors.white.withValues(alpha: 0.08),
                      valueColor: AlwaysStoppedAnimation(
                        AppColors.driverAccent,
                      ),
                    ),
                    Text(
                      '21',
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
            padding: const EdgeInsets.all(7),
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
                      radius: 9,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        'JD',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Juan Dela Cruz',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 7,
                                color: AppColors.amber,
                              ),
                              Text(
                                ' 4.8',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 6,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '₱65',
                      style: TextStyle(
                        color: AppColors.driverAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                _DMiniRoute(
                  pickup: 'SM City Cebu',
                  dropoff: 'Ayala Center Cebu',
                ),
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
                      '✓ Accept Ride',
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

class _DMockNav extends StatelessWidget {
  final AnimationController pulse;
  final bool arrived;
  const _DMockNav({required this.pulse, required this.arrived});

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
                  CustomPaint(painter: _MapPainter(), size: Size.infinite),
                  CustomPaint(painter: _RoutePainter(), size: Size.infinite),
                  AnimatedBuilder(
                    animation: pulse,
                    builder: (_, __) => Positioned(
                      top: arrived ? 18 : 18 + 22 * (1 - pulse.value),
                      left: arrived ? 28 : 28 + 12 * (1 - pulse.value),
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.driverAccent,
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
                  Positioned(
                    top: 6,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: arrived
                              ? AppColors.success
                              : AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          arrived ? 'At Pickup Point' : 'Heading to Pickup',
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
            color: AppColors.driverBg,
            padding: const EdgeInsets.all(7),
            child: Column(
              children: [
                _DMiniRoute(
                  pickup: 'SM City Cebu',
                  dropoff: 'Ayala Center Cebu',
                ),
                const SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  height: 20,
                  decoration: BoxDecoration(
                    color: arrived ? AppColors.success : AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      arrived ? '✓ Passenger Picked Up' : 'Navigating...',
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

class _DMockTrip extends StatelessWidget {
  final AnimationController pulse;
  const _DMockTrip({required this.pulse});

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
                  CustomPaint(painter: _MapPainter(), size: Size.infinite),
                  CustomPaint(painter: _RoutePainter(), size: Size.infinite),
                  AnimatedBuilder(
                    animation: pulse,
                    builder: (_, __) => Positioned(
                      top: 12 + 35 * pulse.value,
                      left: 12 + 22 * pulse.value,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.driverAccent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: const Icon(
                          Icons.navigation,
                          color: Colors.white,
                          size: 9,
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
                          horizontal: 7,
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
            color: AppColors.driverBg,
            padding: const EdgeInsets.all(7),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Juan Dela Cruz',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '→ Ayala Center Cebu',
                        style: TextStyle(color: Colors.white38, fontSize: 6),
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
                      style: TextStyle(color: Colors.white38, fontSize: 6),
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

class _DMockEarnings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.driverBg,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.driverAccent.withValues(alpha: 0.18),
                  AppColors.driverAccent.withValues(alpha: 0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: AppColors.driverAccent.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "TODAY'S EARNINGS",
                  style: TextStyle(
                    color: AppColors.driverTextMuted,
                    fontSize: 6,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
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
                  style: TextStyle(color: Colors.white38, fontSize: 6),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Mini bar chart
          SizedBox(
            height: 36,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [0.45, 0.6, 0.38, 0.72, 0.85, 0.95, 1.0]
                  .asMap()
                  .entries
                  .map((e) {
                    final isLast = e.key == 6;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1.5),
                        child: Container(
                          height: 36 * e.value,
                          decoration: BoxDecoration(
                            color: isLast
                                ? AppColors.driverAccent
                                : AppColors.primary.withValues(alpha: 0.45),
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
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppColors.driverSurface,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: AppColors.driverBorder),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.success,
                  size: 11,
                ),
                const SizedBox(width: 5),
                const Expanded(
                  child: Text(
                    'Trip #13 completed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 7,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  '+₱65',
                  style: TextStyle(
                    color: AppColors.driverAccent,
                    fontSize: 9,
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

// ─────────────────────────────────────────────────────────────────────────────
// SHARED MINI WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _DMiniRoute extends StatelessWidget {
  final String pickup, dropoff;
  const _DMiniRoute({required this.pickup, required this.dropoff});

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
            const SizedBox(width: 4),
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
          child: Container(width: 1, height: 5, color: Colors.white24),
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
            const SizedBox(width: 4),
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

class _TinyBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _TinyBtn({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 11),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.07),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white54, size: 17),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MAP PAINTERS
// ─────────────────────────────────────────────────────────────────────────────

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()..color = Colors.white.withValues(alpha: 0.88);
    final minor = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.38, size.width, 5), road);
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.68, size.width, 6), road);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.42, 0, 5, size.height), road);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.72, 0, 6, size.height), road);
    canvas.drawLine(
      Offset(0, size.height * 0.18),
      Offset(size.width, size.height * 0.18),
      minor,
    );
    canvas.drawLine(
      Offset(size.width * 0.22, 0),
      Offset(size.width * 0.22, size.height),
      minor,
    );
    // Green block
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.24,
          size.height * 0.2,
          size.width * 0.16,
          size.height * 0.16,
        ),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFFD1E8D0).withValues(alpha: 0.5),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(size.width * 0.22, size.height * 0.82)
      ..quadraticBezierTo(
        size.width * 0.38,
        size.height * 0.52,
        size.width * 0.62,
        size.height * 0.18,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// NAVIGATION CONTROLS
// ─────────────────────────────────────────────────────────────────────────────

class _NavRow extends StatelessWidget {
  final int step, total;
  final VoidCallback? onPrev;
  final VoidCallback onNext;

  const _NavRow({
    required this.step,
    required this.total,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          // Prev
          GestureDetector(
            onTap: onPrev,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: onPrev != null
                    ? Colors.white.withValues(alpha: 0.07)
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: onPrev != null
                      ? Colors.white.withValues(alpha: 0.12)
                      : Colors.transparent,
                ),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: onPrev != null ? Colors.white60 : Colors.transparent,
                size: 18,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Progress
          Expanded(
            child: Column(
              children: [
                Text(
                  '${step + 1} of $total',
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: (step + 1) / total,
                    backgroundColor: Colors.white.withValues(alpha: 0.07),
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
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
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.45),
                ),
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.primaryLight,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LaunchRow extends StatelessWidget {
  final VoidCallback onPassenger;
  final VoidCallback onDriver;
  final VoidCallback onRestart;

  const _LaunchRow({
    required this.onPassenger,
    required this.onDriver,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onPassenger,
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 15,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Try Passenger',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: onDriver,
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.driverAccent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.driverAccent.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.two_wheeler,
                          color: AppColors.driverBg,
                          size: 15,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Try Driver',
                          style: TextStyle(
                            color: AppColors.driverBg,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                  color: Colors.white30,
                  size: 13,
                ),
                const SizedBox(width: 5),
                Text(
                  'Restart demo',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.35),
                    fontSize: 11,
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
