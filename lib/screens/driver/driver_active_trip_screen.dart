import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../data/app_state.dart';
import '../../widgets/contact_sheet.dart';
import '../../widgets/toast.dart';

enum _TripPhase { toPickup, inProgress }

class DriverActiveTripScreen extends StatefulWidget {
  const DriverActiveTripScreen({super.key});

  @override
  State<DriverActiveTripScreen> createState() => _DriverActiveTripScreenState();
}

class _DriverActiveTripScreenState extends State<DriverActiveTripScreen>
    with SingleTickerProviderStateMixin {
  _TripPhase _phase = _TripPhase.toPickup;
  late AnimationController _vehicleController;
  late Animation<double> _topAnim;
  late Animation<double> _leftAnim;

  @override
  void initState() {
    super.initState();
    _vehicleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _topAnim = Tween<double>(
      begin: 0.75,
      end: 0.25,
    ).animate(_vehicleController);
    _leftAnim = Tween<double>(
      begin: 0.20,
      end: 0.65,
    ).animate(_vehicleController);
  }

  @override
  void dispose() {
    _vehicleController.dispose();
    super.dispose();
  }

  void _handlePickedUp() {
    setState(() => _phase = _TripPhase.inProgress);
    showToast(context, 'Trip started! Navigate to destination.');
  }

  void _handleEndTrip() {
    showToast(context, 'Trip completed! Great job!');
    AppState.instance.dailyEarnings += 65;
    AppState.instance.dailyTrips += 1;
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) context.go('/driver-home');
    });
  }

  @override
  Widget build(BuildContext context) {
    final req = AppState.instance.pendingRequest ?? mockRideRequest;
    final isPickup = _phase == _TripPhase.toPickup;

    return Scaffold(
      body: Column(
        children: [
          // Map area
          Expanded(
            child: Stack(
              children: [
                // Map background
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFDBEAFB), Color(0xFFEEF4FB)],
                    ),
                  ),
                  child: CustomPaint(
                    painter: _MapPainter(),
                    size: Size.infinite,
                  ),
                ),

                // Route line
                CustomPaint(painter: _RoutePainter(), size: Size.infinite),

                // Destination pin
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.22,
                  left: MediaQuery.of(context).size.width * 0.65,
                  child: Column(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isPickup ? AppColors.green : AppColors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Icon(
                          isPickup ? Icons.person_pin : Icons.flag,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          isPickup ? 'Pickup' : 'Destination',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Animated vehicle
                AnimatedBuilder(
                  animation: _vehicleController,
                  builder: (context, _) {
                    return Positioned(
                      top:
                          MediaQuery.of(context).size.height * _topAnim.value -
                          28,
                      left:
                          MediaQuery.of(context).size.width * _leftAnim.value -
                          28,
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.driverAccent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.two_wheeler,
                          color: AppColors.driverPrimary,
                          size: 26,
                        ),
                      ),
                    );
                  },
                ),

                // Status banner
                Positioned(
                  top: MediaQuery.of(context).padding.top + 12,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isPickup ? AppColors.primary : AppColors.green,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPickup ? Icons.navigation : Icons.directions,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isPickup ? 'Heading to Pickup' : 'Trip in Progress',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
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

          // Bottom card
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF0F172A),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Passenger row
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          req.passengerName.split(' ').map((n) => n[0]).join(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            req.passengerName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            isPickup ? req.pickup : req.dropoff,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        _ContactBtn(
                          icon: Icons.phone,
                          onTap: () => showContactSheet(
                            context,
                            name: req.passengerName,
                            phone: '+63 917 123 4567',
                            isDark: true,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _ContactBtn(
                          icon: Icons.message,
                          onTap: () => showContactSheet(
                            context,
                            name: req.passengerName,
                            phone: '+63 917 123 4567',
                            isDark: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Route summary
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _InfoChip(
                          icon: Icons.straighten,
                          value: '${req.distance} km',
                          label: 'Distance',
                        ),
                      ),
                      Container(width: 1, height: 32, color: Colors.white12),
                      Expanded(
                        child: _InfoChip(
                          icon: Icons.access_time,
                          value: '~12 mins',
                          label: 'Duration',
                        ),
                      ),
                      Container(width: 1, height: 32, color: Colors.white12),
                      Expanded(
                        child: _InfoChip(
                          icon: Icons.monetization_on_outlined,
                          value: '₱${req.fare.toStringAsFixed(0)}',
                          label: 'Fare',
                          valueColor: AppColors.driverAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Action button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: isPickup ? _handlePickedUp : _handleEndTrip,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPickup
                          ? AppColors.primary
                          : AppColors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isPickup ? Icons.person_pin : Icons.flag,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isPickup ? 'Passenger Picked Up' : 'End Trip',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ).animate().slideY(begin: 1, end: 0, duration: 400.ms),
        ],
      ),
    );
  }
}

class _ContactBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ContactBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white70, size: 18),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? valueColor;
  const _InfoChip({
    required this.icon,
    required this.value,
    required this.label,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white38, size: 16),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 10),
        ),
      ],
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()..color = Colors.white.withValues(alpha: 0.8);
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.3, size.width, 8),
      roadPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.7, size.width, 12),
      roadPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.4, 0, 8, size.height),
      roadPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.75, 0, 10, size.height),
      roadPaint,
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
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(size.width * 0.20, size.height * 0.75)
      ..quadraticBezierTo(
        size.width * 0.40,
        size.height * 0.50,
        size.width * 0.65,
        size.height * 0.22,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
