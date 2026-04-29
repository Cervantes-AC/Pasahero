import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

// =============================================================================
// APP COLORS (inline so file is self-contained)
// =============================================================================

class _AppColors {
  static const primary = Color(0xFF1D4ED8);
  static const primaryLight = Color(0xFF60A5FA);
  static const primaryDark = Color(0xFF1E3A8A);
  static const success = Color(0xFF22C55E);
  static const error = Color(0xFFEF4444);
  static const amber = Color(0xFFD97706);
  static const surface = Color(0xFFF8FAFC);
  static const border = Color(0xFFE2E8F0);
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF475569);
  static const textTertiary = Color(0xFF94A3B8);
  static const driverBg = Color(0xFF0C1A38);
  static const driverSurface = Color(0xFF0F2040);
  static const driverBorder = Color(0xFF1E3A5F);
  static const driverAccent = Color(0xFFD97706);
  static const driverTextMuted = Color(0xFF64748B);
}

// =============================================================================
// DATA MODEL
// =============================================================================

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
    label: 'Home',
    pTitle: 'Passenger Home',
    pDesc:
        'Juan opens Pasahero. He sees Habal-habal, Motorela, and Bao-bao options. Wallet balance and saved locations are ready.',
    dTitle: 'Driver Offline',
    dDesc:
        "Pedro is offline. Dashboard shows ₱847.50 earnings and 12 trips. He taps the toggle to go online.",
    pIcon: Icons.home_rounded,
    dIcon: Icons.wifi_off_rounded,
    pColor: _AppColors.primary,
    dColor: _AppColors.driverTextMuted,
  ),
  _StepData(
    phase: _Phase.searching,
    label: 'Book',
    pTitle: 'Searching Drivers',
    pDesc:
        'Juan picks Habal-habal, sets pickup at SM City Cebu, types "Ayala Center Cebu" as destination, and taps Search Drivers.',
    dTitle: 'Driver Online',
    dDesc:
        "Pedro goes online. A green pulse shows he's now visible. Nearby passengers appear on his map.",
    pIcon: Icons.search_rounded,
    dIcon: Icons.wifi_rounded,
    pColor: _AppColors.primary,
    dColor: _AppColors.success,
  ),
  _StepData(
    phase: _Phase.requested,
    label: 'Request',
    pTitle: 'Request Sent',
    pDesc:
        "Juan sees Pedro's card — ₱65 fare, ★4.9, 3 mins away, ABC 1234. He taps \"Order Ride\" to send the request.",
    dTitle: 'Incoming Request!',
    dDesc:
        'Pedro gets a 30-second countdown alert showing ₱65 fare, pickup at SM City, drop-off at Ayala. Accept or decline.',
    pIcon: Icons.send_rounded,
    dIcon: Icons.notifications_active_rounded,
    pColor: _AppColors.amber,
    dColor: _AppColors.amber,
  ),
  _StepData(
    phase: _Phase.accepted,
    label: 'Accept',
    pTitle: 'Driver Accepted!',
    pDesc:
        "Pedro accepted. Juan sees a live map with Pedro's bike moving toward his location. ETA updates in real time.",
    dTitle: 'Ride Accepted',
    dDesc:
        'Pedro taps Accept. Navigation starts — heading to SM City Cebu. Passenger details and route are shown.',
    pIcon: Icons.check_circle_rounded,
    dIcon: Icons.navigation_rounded,
    pColor: _AppColors.success,
    dColor: _AppColors.primary,
  ),
  _StepData(
    phase: _Phase.enRoute,
    label: 'En Route',
    pTitle: 'Driver On the Way',
    pDesc:
        'ETA: 3 mins. Juan can call Pedro, send a message, or share his live location with family for safety.',
    dTitle: 'Heading to Pickup',
    dDesc:
        'Pedro follows the route. Distance to pickup: 0.8 km. Passenger name and contact visible on screen.',
    pIcon: Icons.location_on_rounded,
    dIcon: Icons.two_wheeler,
    pColor: _AppColors.primary,
    dColor: _AppColors.primary,
  ),
  _StepData(
    phase: _Phase.arrived,
    label: 'Arrived',
    pTitle: 'Driver Arrived!',
    pDesc:
        'Pedro is at SM City Cebu. Juan gets a notification and heads to the pickup point to board.',
    dTitle: 'At Pickup Point',
    dDesc:
        'Pedro taps "Passenger Picked Up" to confirm boarding and start navigation to Ayala Center.',
    pIcon: Icons.person_pin_rounded,
    dIcon: Icons.flag_rounded,
    pColor: _AppColors.success,
    dColor: _AppColors.success,
  ),
  _StepData(
    phase: _Phase.inTrip,
    label: 'Trip',
    pTitle: 'Trip in Progress',
    pDesc:
        'Juan is riding. ETA 8 mins, 3.2 km to Ayala. He shares his live location with family for safety.',
    dTitle: 'Trip in Progress',
    dDesc:
        'Pedro navigates to Ayala Center. Fare ₱65 confirmed. Trip timer running. Passenger is on board.',
    pIcon: Icons.directions_rounded,
    dIcon: Icons.route_rounded,
    pColor: _AppColors.primary,
    dColor: _AppColors.driverAccent,
  ),
  _StepData(
    phase: _Phase.complete,
    label: 'Done',
    pTitle: 'Trip Complete!',
    pDesc:
        'Juan rates Pedro ★5, adds ₱10 tip, pays ₱75 via GCash. Receipt saved automatically to ride history.',
    dTitle: 'Earnings Updated',
    dDesc:
        "Pedro's dashboard: +₱65 added. Daily total ₱912.50. 13 trips. Rating stays at ★4.9. Ready for next ride.",
    pIcon: Icons.star_rounded,
    dIcon: Icons.monetization_on_rounded,
    pColor: _AppColors.amber,
    dColor: _AppColors.driverAccent,
  ),
];

// =============================================================================
// SHOWCASE SCREEN
// =============================================================================

class ShowcaseScreen extends StatefulWidget {
  const ShowcaseScreen({super.key});

  @override
  State<ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen>
    with TickerProviderStateMixin {
  int _step = 0;
  bool _autoPlay = false;
  Timer? _autoTimer;

  // Pulsing animation for online dots, map markers, etc.
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  // Slide transition for panel content
  late final AnimationController _slide = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );
  late final Animation<double> _fadeAnim =
      CurvedAnimation(parent: _slide, curve: Curves.easeOut);
  late final Animation<Offset> _slideAnim = Tween<Offset>(
    begin: const Offset(0.04, 0),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _slide, curve: Curves.easeOut));

  // Countdown for driver request screen
  int _countdown = 30;
  Timer? _countdownTimer;

  // Trip timer
  int _tripSeconds = 0;
  Timer? _tripTimer;

  // Driver marker animation (moving toward pickup)
  late final AnimationController _driverMove = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  )..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    _slide.forward();
  }

  @override
  void dispose() {
    _pulse.dispose();
    _slide.dispose();
    _driverMove.dispose();
    _autoTimer?.cancel();
    _countdownTimer?.cancel();
    _tripTimer?.cancel();
    super.dispose();
  }

  void _goTo(int i) {
    if (i < 0 || i >= _kSteps.length) return;
    HapticFeedback.selectionClick();

    // Stop timers from previous step
    _countdownTimer?.cancel();
    _tripTimer?.cancel();

    setState(() => _step = i);
    _slide.forward(from: 0);

    // Start countdown on "requested" phase
    if (_kSteps[i].phase == _Phase.requested) {
      _countdown = 30;
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        if (_countdown > 0) {
          setState(() => _countdown--);
        } else {
          _countdownTimer?.cancel();
        }
      });
    }

    // Start trip timer on "inTrip" phase
    if (_kSteps[i].phase == _Phase.inTrip) {
      _tripSeconds = 0;
      _tripTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() => _tripSeconds++);
      });
    }
  }

  void _toggleAuto() {
    if (_autoPlay) {
      _autoTimer?.cancel();
      setState(() => _autoPlay = false);
    } else {
      setState(() => _autoPlay = true);
      _autoTimer = Timer.periodic(const Duration(seconds: 3), (_) {
        if (!mounted) return;
        if (_step < _kSteps.length - 1) {
          _goTo(_step + 1);
        } else {
          _autoTimer?.cancel();
          setState(() => _autoPlay = false);
        }
      });
    }
  }

  String _formatTimer(int s) {
    final m = s ~/ 60;
    final sec = s % 60;
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final s = _kSteps[_step];
    final isLast = _step == _kSteps.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFF060B18),
      body: SafeArea(
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            final v = details.primaryVelocity ?? 0;
            if (v < -300) _goTo(_step + 1);
            if (v > 300) _goTo(_step - 1);
          },
          child: Column(
            children: [
              _Header(
                onClose: () => context.go('/'),
                autoPlay: _autoPlay,
                onToggleAuto: _toggleAuto,
              ),
              _StepPills(steps: _kSteps, current: _step, onTap: _goTo),
              const SizedBox(height: 4),
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
              const SizedBox(height: 6),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: FadeTransition(
                          opacity: _fadeAnim,
                          child: SlideTransition(
                            position: _slideAnim,
                            child: _SidePanel(
                              isPassenger: true,
                              phase: s.phase,
                              title: s.pTitle,
                              desc: s.pDesc,
                              icon: s.pIcon,
                              accent: s.pColor,
                              pulse: _pulse,
                              driverMove: _driverMove,
                              stepIndex: _step,
                              countdown: _countdown,
                              tripSeconds: _tripSeconds,
                              formatTimer: _formatTimer,
                            ),
                          ),
                        ),
                      ),
                      _Connector(phase: s.phase, pulse: _pulse),
                      Expanded(
                        child: FadeTransition(
                          opacity: _fadeAnim,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(-0.04, 0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                                parent: _slide, curve: Curves.easeOut)),
                            child: _SidePanel(
                              isPassenger: false,
                              phase: s.phase,
                              title: s.dTitle,
                              desc: s.dDesc,
                              icon: s.dIcon,
                              accent: s.dColor,
                              pulse: _pulse,
                              driverMove: _driverMove,
                              stepIndex: _step,
                              countdown: _countdown,
                              tripSeconds: _tripSeconds,
                              formatTimer: _formatTimer,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
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
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// HEADER
// =============================================================================

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
                  'Passenger ↔ Driver  ·  Swipe or tap to navigate',
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
                    ? _AppColors.primary.withOpacity(0.22)
                    : Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: autoPlay
                      ? _AppColors.primary.withOpacity(0.55)
                      : Colors.white.withOpacity(0.1),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    autoPlay ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: autoPlay
                        ? _AppColors.primaryLight
                        : Colors.white54,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    autoPlay ? 'Pause' : 'Auto',
                    style: TextStyle(
                      color:
                          autoPlay ? _AppColors.primaryLight : Colors.white54,
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

// =============================================================================
// STEP PILLS
// =============================================================================

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
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: 3,
                      decoration: BoxDecoration(
                        color: done
                            ? _AppColors.primary
                            : active
                                ? _AppColors.primaryLight
                                : Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      e.value.label,
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight:
                            active ? FontWeight.w700 : FontWeight.w400,
                        color: active
                            ? Colors.white
                            : done
                                ? _AppColors.primaryLight.withOpacity(0.6)
                                : Colors.white.withOpacity(0.25),
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

// =============================================================================
// CENTER CONNECTOR
// =============================================================================

class _Connector extends StatelessWidget {
  final _Phase phase;
  final AnimationController pulse;

  const _Connector({required this.phase, required this.pulse});

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
              color: Colors.white.withOpacity(0.06),
            ),
          ),
          AnimatedBuilder(
            animation: pulse,
            builder: (_, __) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: active ? 22 + 2 * pulse.value : 22,
              height: active ? 22 + 2 * pulse.value : 22,
              decoration: BoxDecoration(
                color: active
                    ? _AppColors.primary.withOpacity(0.18)
                    : Colors.white.withOpacity(0.04),
                shape: BoxShape.circle,
                border: Border.all(
                  color: active
                      ? _AppColors.primary.withOpacity(0.45)
                      : Colors.white.withOpacity(0.08),
                ),
              ),
              child: Icon(
                active ? Icons.bolt_rounded : Icons.more_horiz,
                color:
                    active ? _AppColors.primaryLight : Colors.white24,
                size: 11,
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: 1,
              color: Colors.white.withOpacity(0.06),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SIDE PANEL
// =============================================================================

class _SidePanel extends StatelessWidget {
  final bool isPassenger;
  final _Phase phase;
  final String title;
  final String desc;
  final IconData icon;
  final Color accent;
  final AnimationController pulse;
  final AnimationController driverMove;
  final int stepIndex;
  final int countdown;
  final int tripSeconds;
  final String Function(int) formatTimer;

  const _SidePanel({
    required this.isPassenger,
    required this.phase,
    required this.title,
    required this.desc,
    required this.icon,
    required this.accent,
    required this.pulse,
    required this.driverMove,
    required this.stepIndex,
    required this.countdown,
    required this.tripSeconds,
    required this.formatTimer,
  });

  @override
  Widget build(BuildContext context) {
    final bg =
        isPassenger ? const Color(0xFF0C1A38) : const Color(0xFF0F172A);
    final border = isPassenger
        ? _AppColors.primary.withOpacity(0.2)
        : _AppColors.driverBorder;
    final initials = isPassenger ? 'JD' : 'PS';
    final name =
        isPassenger ? 'Juan Dela Cruz' : 'Pedro Santos';
    final role = isPassenger ? 'PASSENGER' : 'DRIVER';
    final isOnline = phase != _Phase.idle;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          // Panel header
          Container(
            padding: const EdgeInsets.fromLTRB(10, 9, 10, 8),
            decoration: BoxDecoration(
              color: isPassenger
                  ? _AppColors.primary.withOpacity(0.1)
                  : Colors.white.withOpacity(0.03),
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
                    color: accent.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: accent.withOpacity(0.35)),
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
                // Pulsing online dot
                AnimatedBuilder(
                  animation: pulse,
                  builder: (_, __) => Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: isOnline
                          ? _AppColors.success
                          : Colors.white24,
                      shape: BoxShape.circle,
                      boxShadow: isOnline
                          ? [
                              BoxShadow(
                                color: _AppColors.success
                                    .withOpacity(0.5 * pulse.value),
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
          // Mock screen body
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: _buildMock(phase),
                  ),
                  // Description overlay
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(9, 28, 9, 9),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            bg.withOpacity(0),
                            bg.withOpacity(0.96),
                            bg,
                          ],
                          stops: const [0, 0.35, 1],
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
                              color: Colors.white.withOpacity(0.55),
                              fontSize: 9,
                              height: 1.45,
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

  Widget _buildMock(_Phase p) {
    if (isPassenger) {
      switch (p) {
        case _Phase.idle:
          return _PMockHome(pulse: pulse, searching: false);
        case _Phase.searching:
          return _PMockHome(pulse: pulse, searching: true);
        case _Phase.requested:
          return _PMockDriverCard();
        case _Phase.accepted:
        case _Phase.enRoute:
          return _PMockTracking(
              pulse: pulse, driverMove: driverMove, arrived: false);
        case _Phase.arrived:
          return _PMockTracking(
              pulse: pulse, driverMove: driverMove, arrived: true);
        case _Phase.inTrip:
          return _PMockOngoing(
              pulse: pulse,
              driverMove: driverMove,
              tripSeconds: tripSeconds,
              formatTimer: formatTimer);
        case _Phase.complete:
          return const _PMockComplete();
      }
    } else {
      switch (p) {
        case _Phase.idle:
          return const _DMockOffline();
        case _Phase.searching:
          return _DMockOnline(pulse: pulse);
        case _Phase.requested:
          return _DMockRequest(pulse: pulse, countdown: countdown);
        case _Phase.accepted:
        case _Phase.enRoute:
          return _DMockNav(
              pulse: pulse, driverMove: driverMove, arrived: false);
        case _Phase.arrived:
          return _DMockNav(
              pulse: pulse, driverMove: driverMove, arrived: true);
        case _Phase.inTrip:
          return _DMockTrip(
              pulse: pulse,
              driverMove: driverMove,
              tripSeconds: tripSeconds,
              formatTimer: formatTimer);
        case _Phase.complete:
          return const _DMockEarnings();
      }
    }
  }
}

// =============================================================================
// MAP PAINTERS
// =============================================================================

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white.withOpacity(0.88);
    final minorPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final greenPaint = Paint()
      ..color = const Color(0xFFD1E8D0).withOpacity(0.6);
    final buildingPaint = Paint()
      ..color = Colors.blueGrey.withOpacity(0.18);

    // Major roads
    canvas.drawRect(
        Rect.fromLTWH(0, size.height * 0.38, size.width, 5), roadPaint);
    canvas.drawRect(
        Rect.fromLTWH(0, size.height * 0.68, size.width, 6), roadPaint);
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.42, 0, 5, size.height), roadPaint);
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.72, 0, 6, size.height), roadPaint);
    // Minor roads
    canvas.drawLine(Offset(0, size.height * 0.18),
        Offset(size.width, size.height * 0.18), minorPaint);
    canvas.drawLine(Offset(size.width * 0.22, 0),
        Offset(size.width * 0.22, size.height), minorPaint);
    // Park block
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.24, size.height * 0.2,
            size.width * 0.16, size.height * 0.16),
        const Radius.circular(3),
      ),
      greenPaint,
    );
    // Buildings
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.74, size.height * 0.42,
            size.width * 0.12, size.height * 0.12),
        const Radius.circular(2),
      ),
      buildingPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.06, size.height * 0.42,
            size.width * 0.14, size.height * 0.22),
        const Radius.circular(2),
      ),
      buildingPaint,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _AppColors.primary
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

// =============================================================================
// PASSENGER MOCK SCREENS
// =============================================================================

class _PMockHome extends StatelessWidget {
  final AnimationController pulse;
  final bool searching;

  const _PMockHome({required this.pulse, required this.searching});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _AppColors.surface,
      child: Column(
        children: [
          // Blue app header
          Container(
            color: _AppColors.primary,
            padding: const EdgeInsets.fromLTRB(9, 9, 9, 18),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 11,
                  backgroundColor: Colors.white24,
                  child: Text('JD',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 7,
                          fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 5),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good morning,',
                          style: TextStyle(
                              color: Colors.white60, fontSize: 7)),
                      Text('Juan Dela Cruz',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.account_balance_wallet_rounded,
                          color: Colors.white, size: 8),
                      SizedBox(width: 3),
                      Text('₱250',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 7,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Stack(
                  children: [
                    const Icon(Icons.notifications_outlined,
                        color: Colors.white60, size: 14),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                            color: _AppColors.error,
                            shape: BoxShape.circle),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Search bar (overlapping header)
          Transform.translate(
            offset: const Offset(0, -11),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.09),
                      blurRadius: 10)
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search,
                      color: _AppColors.primary, size: 12),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      searching
                          ? 'Ayala Center Cebu'
                          : 'Where do you want to go?',
                      style: TextStyle(
                        color: searching
                            ? _AppColors.textPrimary
                            : _AppColors.textTertiary,
                        fontSize: 8,
                        fontWeight: searching
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: searching
                          ? _AppColors.primary
                          : _AppColors.primary.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('Go',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 7,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),
          // Ride type list
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    _MiniRideRow(
                      label: 'Habal-habal',
                      sublabel: 'Motorcycle · 1 seat',
                      color: _AppColors.primary,
                      icon: Icons.two_wheeler,
                      price: '₱25',
                      eta: '3 min',
                      highlighted: searching,
                    ),
                    const SizedBox(height: 4),
                    _MiniRideRow(
                      label: 'Motorela',
                      sublabel: 'Tricycle · 3 seats',
                      color: _AppColors.error,
                      icon: Icons.electric_rickshaw,
                      price: '₱35',
                      eta: '5 min',
                    ),
                    const SizedBox(height: 4),
                    _MiniRideRow(
                      label: 'Bao-bao',
                      sublabel: 'Van · 6 seats',
                      color: _AppColors.amber,
                      icon: Icons.airport_shuttle,
                      price: '₱50',
                      eta: '8 min',
                    ),
                    const SizedBox(height: 6),
                    // Quick locations
                    Row(
                      children: [
                        _QuickLocChip(
                            icon: Icons.home_rounded,
                            label: 'Home',
                            color: _AppColors.primary),
                        const SizedBox(width: 5),
                        _QuickLocChip(
                            icon: Icons.work_rounded,
                            label: 'Work',
                            color: _AppColors.amber),
                      ],
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

class _QuickLocChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _QuickLocChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 10),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(
                    color: color,
                    fontSize: 8,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _MiniRideRow extends StatelessWidget {
  final String label;
  final String sublabel;
  final String price;
  final String eta;
  final Color color;
  final IconData icon;
  final bool highlighted;

  const _MiniRideRow({
    required this.label,
    required this.sublabel,
    required this.color,
    required this.icon,
    required this.price,
    required this.eta,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        color: highlighted ? color.withOpacity(0.06) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: highlighted
              ? color.withOpacity(0.4)
              : _AppColors.border,
          width: highlighted ? 1.2 : 0.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 13),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: _AppColors.textPrimary,
                        fontSize: 9,
                        fontWeight: FontWeight.w700)),
                Text(sublabel,
                    style: const TextStyle(
                        color: _AppColors.textTertiary,
                        fontSize: 7)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price,
                  style: TextStyle(
                      color: color,
                      fontSize: 9,
                      fontWeight: FontWeight.w800)),
              Text(eta,
                  style: const TextStyle(
                      color: _AppColors.textTertiary, fontSize: 6.5)),
            ],
          ),
          const SizedBox(width: 3),
          Icon(Icons.chevron_right,
              color: _AppColors.textTertiary, size: 11),
        ],
      ),
    );
  }
}

class _PMockDriverCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: _AppColors.surface,
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFFE8F0F8),
              child: Stack(
                children: [
                  CustomPaint(painter: _MapPainter(), size: Size.infinite),
                  CustomPaint(painter: _RoutePainter(), size: Size.infinite),
                  Positioned(
                    top: 22,
                    left: 28,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: _AppColors.amber,
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.two_wheeler,
                          color: Colors.white, size: 9),
                    ),
                  ),
                  Positioned(
                    bottom: 22,
                    right: 26,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: _AppColors.primary,
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 7,
                    right: 7,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 5)
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.access_time_rounded,
                              size: 8, color: _AppColors.primary),
                          SizedBox(width: 2),
                          Text('3 min',
                              style: TextStyle(
                                  color: _AppColors.primary,
                                  fontSize: 7,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(9),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 14,
                      backgroundColor: _AppColors.primary,
                      child: Text('PS',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 7,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Pedro Santos',
                              style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: _AppColors.textPrimary)),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  size: 9, color: _AppColors.amber),
                              const Text(' 4.9 · ABC 1234 · 0.8 km',
                                  style: TextStyle(
                                      fontSize: 7,
                                      color: _AppColors.textTertiary)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('₱65',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: _AppColors.primary)),
                        const Text('est. fare',
                            style: TextStyle(
                                fontSize: 6.5,
                                color: _AppColors.textTertiary)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Expanded(
                      child: _OutlineBtn(
                          label: 'Details',
                          icon: Icons.info_outline,
                          height: 26),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      flex: 2,
                      child: _FilledBtn(
                          label: 'Order Ride',
                          icon: Icons.check_rounded,
                          color: _AppColors.primary,
                          height: 26),
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

class _PMockTracking extends StatelessWidget {
  final AnimationController pulse;
  final AnimationController driverMove;
  final bool arrived;

  const _PMockTracking({
    required this.pulse,
    required this.driverMove,
    required this.arrived,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _AppColors.surface,
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFFE8F0F8),
              child: Stack(
                children: [
                  CustomPaint(painter: _MapPainter(), size: Size.infinite),
                  CustomPaint(painter: _RoutePainter(), size: Size.infinite),
                  // Moving driver marker
                  AnimatedBuilder(
                    animation: driverMove,
                    builder: (_, __) => Positioned(
                      top: arrived
                          ? 20
                          : 20 + 28 * (1 - driverMove.value),
                      left: arrived
                          ? 27
                          : 27 + 16 * (1 - driverMove.value),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _AppColors.amber,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                                color: _AppColors.amber
                                    .withOpacity(0.45),
                                blurRadius: 8)
                          ],
                        ),
                        child: const Icon(Icons.two_wheeler,
                            color: Colors.white, size: 10),
                      ),
                    ),
                  ),
                  // User location with pulse ring
                  AnimatedBuilder(
                    animation: pulse,
                    builder: (_, __) => Positioned(
                      bottom: 24,
                      right: 24,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 20 + 10 * pulse.value,
                            height: 20 + 10 * pulse.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _AppColors.primary.withOpacity(
                                  0.15 * (1 - pulse.value)),
                            ),
                          ),
                          Container(
                            width: 13,
                            height: 13,
                            decoration: BoxDecoration(
                              color: _AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white, width: 2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Status chip
                  Positioned(
                    top: 7,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: arrived
                              ? _AppColors.success
                              : _AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.22),
                                blurRadius: 5)
                          ],
                        ),
                        child: Text(
                          arrived
                              ? '📍 Driver Arrived!'
                              : 'Driver On the Way',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w700),
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
            padding: const EdgeInsets.symmetric(
                horizontal: 9, vertical: 8),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 11,
                  backgroundColor: _AppColors.primary,
                  child: Text('PS',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 6,
                          fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Pedro Santos',
                          style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: _AppColors.textPrimary)),
                      Text(
                        arrived
                            ? 'At your location · ABC 1234'
                            : '3 mins away · ABC 1234',
                        style: TextStyle(
                          fontSize: 7,
                          color: arrived
                              ? _AppColors.success
                              : _AppColors.textTertiary,
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
                    _TinyBtn(
                        icon: Icons.phone_rounded,
                        color: _AppColors.primary),
                    const SizedBox(width: 5),
                    _TinyBtn(
                        icon: Icons.chat_bubble_outline_rounded,
                        color: _AppColors.primary),
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
  final AnimationController driverMove;
  final int tripSeconds;
  final String Function(int) formatTimer;

  const _PMockOngoing({
    required this.pulse,
    required this.driverMove,
    required this.tripSeconds,
    required this.formatTimer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _AppColors.surface,
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
                    animation: driverMove,
                    builder: (_, __) => Positioned(
                      top: 14 + 38 * driverMove.value,
                      left: 12 + 26 * driverMove.value,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _AppColors.amber,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                                color: _AppColors.amber
                                    .withOpacity(0.4),
                                blurRadius: 7)
                          ],
                        ),
                        child: const Icon(Icons.navigation,
                            color: Colors.white, size: 10),
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 16,
                    right: 22,
                    child: Icon(Icons.location_pin,
                        color: _AppColors.error, size: 18),
                  ),
                  Positioned(
                    top: 7,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: AnimatedBuilder(
                        animation: pulse,
                        builder: (_, __) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: _AppColors.success,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(
                                      0.5 + 0.5 * pulse.value),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text('Ride Ongoing',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(width: 5),
                              Text(formatTimer(tripSeconds),
                                  style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 7,
                                      fontWeight: FontWeight.w500)),
                            ],
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
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('8 mins',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: _AppColors.primary)),
                    const Text(' · 3.2 km',
                        style: TextStyle(
                            fontSize: 8,
                            color: _AppColors.textTertiary)),
                    const Spacer(),
                    _TinyBtn(
                        icon: Icons.share_location_rounded,
                        color: _AppColors.amber),
                  ],
                ),
                const SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: _AppColors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: _AppColors.amber.withOpacity(0.35)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.share_location_rounded,
                          color: _AppColors.amber, size: 9),
                      SizedBox(width: 4),
                      Text('Share Live Location with Family',
                          style: TextStyle(
                              color: _AppColors.amber,
                              fontSize: 7.5,
                              fontWeight: FontWeight.w700)),
                    ],
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
  const _PMockComplete();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _AppColors.surface,
      child: Column(
        children: [
          Container(
            height: 66,
            color: _AppColors.success,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_rounded,
                    color: Colors.white, size: 24),
                SizedBox(height: 3),
                Text('Trip Complete!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700)),
                Text('SM City → Ayala Center',
                    style: TextStyle(
                        color: Colors.white60, fontSize: 7)),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(9),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (i) => const Icon(Icons.star_rounded,
                          color: _AppColors.amber, size: 18),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text('Rate Pedro Santos',
                      style: TextStyle(
                          fontSize: 8,
                          color: _AppColors.textTertiary)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _AppColors.surface,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: _AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _FareRow(label: 'Base fare', value: '₱65.00'),
                        _FareRow(label: 'Tip', value: '₱10.00'),
                        const Divider(height: 8, thickness: 0.5),
                        _FareRow(
                            label: 'Total',
                            value: '₱75.00',
                            bold: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  _FilledBtn(
                    label: 'Pay via GCash',
                    icon: Icons.payment_rounded,
                    color: _AppColors.primary,
                    height: 28,
                  ),
                  const SizedBox(height: 5),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long_rounded,
                          size: 9, color: _AppColors.textTertiary),
                      SizedBox(width: 3),
                      Text('Receipt saved to history',
                          style: TextStyle(
                              fontSize: 7.5,
                              color: _AppColors.textTertiary)),
                    ],
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

class _FareRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _FareRow(
      {required this.label,
      required this.value,
      this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: TextStyle(
                    fontSize: 8,
                    color: bold
                        ? _AppColors.textPrimary
                        : _AppColors.textTertiary,
                    fontWeight: bold
                        ? FontWeight.w700
                        : FontWeight.normal)),
          ),
          Text(value,
              style: TextStyle(
                  fontSize: 8,
                  color: bold
                      ? _AppColors.primary
                      : _AppColors.textSecondary,
                  fontWeight: bold
                      ? FontWeight.w800
                      : FontWeight.normal)),
        ],
      ),
    );
  }
}

// =============================================================================
// DRIVER MOCK SCREENS
// =============================================================================

class _DMockOffline extends StatelessWidget {
  const _DMockOffline();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _AppColors.driverBg,
      padding: const EdgeInsets.all(9),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 11,
                backgroundColor: Color(0xFF1E3A5F),
                child: Text('PS',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 7,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pedro Santos',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w600)),
                    Text('★4.9 · Habal-habal · ABC 1234',
                        style: TextStyle(
                            color: Colors.white38, fontSize: 7)),
                  ],
                ),
              ),
              const Icon(Icons.settings_outlined,
                  color: Colors.white24, size: 13),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _AppColors.driverSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _AppColors.driverBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.07),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.wifi_off_rounded,
                      color: Colors.white38, size: 14),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("You're Offline",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700)),
                      Text('Tap toggle to go online',
                          style: TextStyle(
                              color: Colors.white38, fontSize: 7)),
                    ],
                  ),
                ),
                Container(
                  width: 36,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text('OFF',
                        style: TextStyle(
                            color: Colors.white38,
                            fontSize: 7,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 9),
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: _AppColors.driverSurface,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: _AppColors.driverBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("TODAY'S EARNINGS",
                    style: TextStyle(
                        color: _AppColors.driverTextMuted,
                        fontSize: 7,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5)),
                const SizedBox(height: 4),
                const Text('₱847.50',
                    style: TextStyle(
                        color: _AppColors.driverAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.w800)),
                const Text('12 trips completed',
                    style: TextStyle(
                        color: Colors.white38, fontSize: 7)),
                const SizedBox(height: 7),
                Row(
                  children: [
                    _DStatChip(label: 'Rating', value: '★4.9'),
                    const SizedBox(width: 5),
                    _DStatChip(label: 'Online', value: '4h 20m'),
                    const SizedBox(width: 5),
                    _DStatChip(label: 'Accept', value: '94%'),
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

class _DStatChip extends StatelessWidget {
  final String label;
  final String value;

  const _DStatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 1),
            Text(label,
                style: const TextStyle(
                    color: _AppColors.driverTextMuted, fontSize: 6)),
          ],
        ),
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
      color: _AppColors.driverBg,
      padding: const EdgeInsets.all(9),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 11,
                backgroundColor: Color(0xFF1E3A5F),
                child: Text('PS',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 7,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Text('Pedro Santos',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w600)),
              ),
              AnimatedBuilder(
                animation: pulse,
                builder: (_, __) => Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _AppColors.success,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: _AppColors.success
                              .withOpacity(0.6 * pulse.value),
                          blurRadius: 8,
                          spreadRadius: 2)
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          AnimatedBuilder(
            animation: pulse,
            builder: (_, __) => Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _AppColors.success
                    .withOpacity(0.08 + 0.05 * pulse.value),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _AppColors.success
                      .withOpacity(0.25 + 0.2 * pulse.value),
                ),
              ),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 28 + 8 * pulse.value,
                        height: 28 + 8 * pulse.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _AppColors.success.withOpacity(
                              0.15 * (1 - pulse.value)),
                        ),
                      ),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: _AppColors.success,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.wifi_rounded,
                            color: Colors.white, size: 14),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("You're Online",
                            style: TextStyle(
                                color: _AppColors.success,
                                fontSize: 9,
                                fontWeight: FontWeight.w700)),
                        Text('Waiting for requests...',
                            style: TextStyle(
                                color: Colors.white38, fontSize: 7)),
                      ],
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 20,
                    decoration: BoxDecoration(
                      color: _AppColors.success.withOpacity(0.22),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: _AppColors.success.withOpacity(0.45)),
                    ),
                    child: const Center(
                      child: Text('ON',
                          style: TextStyle(
                              color: _AppColors.success,
                              fontSize: 7,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          // Earnings preview while online
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: _AppColors.driverSurface,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: _AppColors.driverBorder),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("TODAY'S EARNINGS",
                          style: TextStyle(
                              color: _AppColors.driverTextMuted,
                              fontSize: 6,
                              letterSpacing: 0.4)),
                      SizedBox(height: 2),
                      Text('₱847.50',
                          style: TextStyle(
                              color: _AppColors.driverAccent,
                              fontSize: 14,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('12 trips',
                        style:
                            TextStyle(color: Colors.white54, fontSize: 7)),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _AppColors.success.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('LIVE',
                          style: TextStyle(
                              color: _AppColors.success,
                              fontSize: 6,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _DMockRequest extends StatelessWidget {
  final AnimationController pulse;
  final int countdown;

  const _DMockRequest({required this.pulse, required this.countdown});

  @override
  Widget build(BuildContext context) {
    final progress = countdown / 30.0;
    final urgentColor = countdown <= 10
        ? _AppColors.error
        : countdown <= 20
            ? _AppColors.amber
            : _AppColors.driverAccent;

    return Container(
      color: _AppColors.driverBg,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      child: Column(
        children: [
          // Countdown ring
          Center(
            child: SizedBox(
              width: 52,
              height: 52,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 4,
                    backgroundColor: Colors.white.withOpacity(0.08),
                    valueColor: AlwaysStoppedAnimation(urgentColor),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$countdown',
                        style: TextStyle(
                          color: urgentColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Text('sec',
                          style: TextStyle(
                              color: Colors.white38, fontSize: 6)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Text('New Ride Request!',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 7),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _AppColors.driverSurface,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: _AppColors.driverBorder),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 11,
                      backgroundColor: _AppColors.primary,
                      child: Text('JD',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 6,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Juan Dela Cruz',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600)),
                          Row(
                            children: [
                              Icon(Icons.star_rounded,
                                  size: 8,
                                  color: _AppColors.amber),
                              Text(' 4.8 · 0.8 km away',
                                  style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 7)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text('₱65',
                        style: TextStyle(
                            color: _AppColors.driverAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.w800)),
                  ],
                ),
                const SizedBox(height: 6),
                const _DMiniRoute(
                    pickup: 'SM City Cebu',
                    dropoff: 'Ayala Center Cebu'),
              ],
            ),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: _AppColors.error),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.close,
                            color: _AppColors.error, size: 11),
                        SizedBox(width: 3),
                        Text('Decline',
                            style: TextStyle(
                                color: _AppColors.error,
                                fontSize: 8,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                flex: 2,
                child: AnimatedBuilder(
                  animation: pulse,
                  builder: (_, __) => Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: _AppColors.success,
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: [
                        BoxShadow(
                            color: _AppColors.success
                                .withOpacity(0.35 * pulse.value),
                            blurRadius: 8,
                            offset: const Offset(0, 2))
                      ],
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_rounded,
                              color: Colors.white, size: 12),
                          SizedBox(width: 3),
                          Text('Accept Ride',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700)),
                        ],
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
  final AnimationController driverMove;
  final bool arrived;

  const _DMockNav({
    required this.pulse,
    required this.driverMove,
    required this.arrived,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _AppColors.driverBg,
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
                    animation: driverMove,
                    builder: (_, __) => Positioned(
                      top: arrived
                          ? 20
                          : 20 + 28 * (1 - driverMove.value),
                      left: arrived
                          ? 27
                          : 27 + 16 * (1 - driverMove.value),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _AppColors.driverAccent,
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                                color: _AppColors.driverAccent
                                    .withOpacity(0.4),
                                blurRadius: 7)
                          ],
                        ),
                        child: const Icon(Icons.two_wheeler,
                            color: Colors.white, size: 10),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 7,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: arrived
                              ? _AppColors.success
                              : _AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5)
                          ],
                        ),
                        child: Text(
                          arrived
                              ? '📍 At Pickup Point'
                              : 'Heading to Pickup',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: _AppColors.driverBg,
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                const _DMiniRoute(
                    pickup: 'SM City Cebu',
                    dropoff: 'Ayala Center Cebu'),
                const SizedBox(height: 6),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  height: 28,
                  decoration: BoxDecoration(
                    color: arrived
                        ? _AppColors.success
                        : _AppColors.primary,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Center(
                    child: Text(
                      arrived
                          ? '✓  Passenger Picked Up'
                          : 'Navigating...',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w700),
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
  final AnimationController driverMove;
  final int tripSeconds;
  final String Function(int) formatTimer;

  const _DMockTrip({
    required this.pulse,
    required this.driverMove,
    required this.tripSeconds,
    required this.formatTimer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _AppColors.driverBg,
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
                    animation: driverMove,
                    builder: (_, __) => Positioned(
                      top: 12 + 38 * driverMove.value,
                      left: 12 + 24 * driverMove.value,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _AppColors.driverAccent,
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                                color: _AppColors.driverAccent
                                    .withOpacity(0.4),
                                blurRadius: 7)
                          ],
                        ),
                        child: const Icon(Icons.navigation,
                            color: Colors.white, size: 10),
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 16,
                    right: 22,
                    child: Icon(Icons.location_pin,
                        color: _AppColors.error, size: 18),
                  ),
                  Positioned(
                    top: 7,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: AnimatedBuilder(
                        animation: pulse,
                        builder: (_, __) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: _AppColors.success,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(
                                      0.5 + 0.5 * pulse.value),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text('Trip in Progress',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(width: 5),
                              Text(formatTimer(tripSeconds),
                                  style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 7)),
                            ],
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
            color: _AppColors.driverBg,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Juan Dela Cruz',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w600)),
                      Text('→ Ayala Center Cebu',
                          style: TextStyle(
                              color: Colors.white38, fontSize: 7)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('₱65',
                        style: TextStyle(
                            color: _AppColors.driverAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.w800)),
                    const Text('~8 mins',
                        style: TextStyle(
                            color: Colors.white38, fontSize: 7)),
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
  const _DMockEarnings();

  @override
  Widget build(BuildContext context) {
    const barHeights = [0.45, 0.62, 0.38, 0.72, 0.85, 0.95, 1.0];

    return Container(
      color: _AppColors.driverBg,
      padding: const EdgeInsets.all(9),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _AppColors.driverAccent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: _AppColors.driverAccent.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("TODAY'S EARNINGS",
                    style: TextStyle(
                        color: _AppColors.driverTextMuted,
                        fontSize: 7,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5)),
                const SizedBox(height: 3),
                const Text('₱912.50',
                    style: TextStyle(
                        color: _AppColors.driverAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.w800)),
                const Row(
                  children: [
                    Text('13 trips  ·  ',
                        style: TextStyle(
                            color: Colors.white38, fontSize: 7)),
                    Icon(Icons.star_rounded,
                        color: _AppColors.amber, size: 9),
                    Text('4.9',
                        style: TextStyle(
                            color: Colors.white38, fontSize: 7)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Weekly bar chart
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text('This week',
                    style: TextStyle(
                        color: Colors.white38, fontSize: 7)),
              ),
              SizedBox(
                height: 38,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: barHeights.asMap().entries.map((e) {
                    final isToday = e.key == 6;
                    return Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 2),
                        child: Container(
                          height: 38 * e.value,
                          decoration: BoxDecoration(
                            color: isToday
                                ? _AppColors.driverAccent
                                : _AppColors.primary
                                    .withOpacity(0.42),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Mon',
                        style: TextStyle(
                            color: Colors.white24, fontSize: 6)),
                    Text('Tue',
                        style: TextStyle(
                            color: Colors.white24, fontSize: 6)),
                    Text('Wed',
                        style: TextStyle(
                            color: Colors.white24, fontSize: 6)),
                    Text('Thu',
                        style: TextStyle(
                            color: Colors.white24, fontSize: 6)),
                    Text('Fri',
                        style: TextStyle(
                            color: Colors.white24, fontSize: 6)),
                    Text('Sat',
                        style: TextStyle(
                            color: Colors.white24, fontSize: 6)),
                    Text('Sun',
                        style: TextStyle(
                            color: _AppColors.driverAccent,
                            fontSize: 6,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _AppColors.driverSurface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _AppColors.driverBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _AppColors.success.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: _AppColors.success, size: 13),
                ),
                const SizedBox(width: 7),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Trip #13 completed',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w600)),
                      Text('SM City → Ayala Center',
                          style: TextStyle(
                              color: Colors.white38, fontSize: 7)),
                    ],
                  ),
                ),
                const Text('+₱65',
                    style: TextStyle(
                        color: _AppColors.driverAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SHARED MINI WIDGETS
// =============================================================================

class _DMiniRoute extends StatelessWidget {
  final String pickup;
  final String dropoff;

  const _DMiniRoute({required this.pickup, required this.dropoff});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                  color: _AppColors.success, shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(pickup,
                  style: const TextStyle(
                      color: Colors.white60, fontSize: 7.5),
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3),
          child: Container(
              width: 1, height: 6, color: Colors.white24),
        ),
        Row(
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                  color: _AppColors.error, shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(dropoff,
                  style: const TextStyle(
                      color: Colors.white60, fontSize: 7.5),
                  overflow: TextOverflow.ellipsis),
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
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.22)),
      ),
      child: Icon(icon, color: color, size: 12),
    );
  }
}

class _OutlineBtn extends StatelessWidget {
  final String label;
  final IconData? icon;
  final double height;

  const _OutlineBtn(
      {required this.label, this.icon, this.height = 30});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: _AppColors.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: _AppColors.textSecondary, size: 10),
              const SizedBox(width: 3),
            ],
            Text(label,
                style: const TextStyle(
                    color: _AppColors.textSecondary,
                    fontSize: 8,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _FilledBtn extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final double height;

  const _FilledBtn({
    required this.label,
    this.icon,
    required this.color,
    this.height = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 11),
              const SizedBox(width: 4),
            ],
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      ),
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
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Icon(icon, color: Colors.white54, size: 18),
      ),
    );
  }
}

// =============================================================================
// NAVIGATION CONTROLS
// =============================================================================

class _NavRow extends StatelessWidget {
  final int step;
  final int total;
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
          GestureDetector(
            onTap: onPrev,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: onPrev != null
                    ? Colors.white.withOpacity(0.07)
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: onPrev != null
                      ? Colors.white.withOpacity(0.12)
                      : Colors.transparent,
                ),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: onPrev != null
                    ? Colors.white60
                    : Colors.transparent,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                Text(
                  '${step + 1} of $total',
                  style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: (step + 1) / total,
                    backgroundColor: Colors.white.withOpacity(0.07),
                    valueColor:
                        const AlwaysStoppedAnimation(_AppColors.primary),
                    minHeight: 3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onNext,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _AppColors.primary.withOpacity(0.22),
                shape: BoxShape.circle,
                border: Border.all(
                    color: _AppColors.primary.withOpacity(0.5)),
              ),
              child: const Icon(Icons.arrow_forward_rounded,
                  color: _AppColors.primaryLight, size: 18),
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
                    height: 48,
                    decoration: BoxDecoration(
                      color: _AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_rounded,
                            color: Colors.white, size: 16),
                        SizedBox(width: 7),
                        Text('Try Passenger',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700)),
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
                    height: 48,
                    decoration: BoxDecoration(
                      color: _AppColors.driverAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.two_wheeler,
                            color: Colors.white, size: 16),
                        SizedBox(width: 7),
                        Text('Try Driver',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          GestureDetector(
            onTap: onRestart,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.replay_rounded,
                    color: Colors.white30, size: 14),
                const SizedBox(width: 5),
                Text(
                  'Restart demo',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.35),
                      fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}