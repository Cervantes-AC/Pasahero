import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/toast.dart';

class RideOngoingScreen extends StatefulWidget {
  const RideOngoingScreen({super.key});

  @override
  State<RideOngoingScreen> createState() => _RideOngoingScreenState();
}

class _RideOngoingScreenState extends State<RideOngoingScreen>
    with SingleTickerProviderStateMixin {
  bool _showShareDialog = false;
  final _sharePhoneController = TextEditingController();
  late AnimationController _vehicleController;
  late Animation<double> _topAnim;
  late Animation<double> _leftAnim;

  final _recentContacts = [
    'Mom (0917 123 4567)',
    'Dad (0918 234 5678)',
    'Sister (0919 345 6789)',
  ];

  @override
  void initState() {
    super.initState();
    _vehicleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _topAnim = Tween<double>(
      begin: 0.85,
      end: 0.30,
    ).animate(_vehicleController);
    _leftAnim = Tween<double>(
      begin: 0.25,
      end: 0.60,
    ).animate(_vehicleController);
  }

  @override
  void dispose() {
    _vehicleController.dispose();
    _sharePhoneController.dispose();
    super.dispose();
  }

  void _handleShareLocation() {
    if (_sharePhoneController.text.isNotEmpty) {
      showToast(context, 'Location shared with ${_sharePhoneController.text}');
      setState(() => _showShareDialog = false);
      _sharePhoneController.clear();
    }
  }

  void _handleCompleteRide() {
    showToast(context, 'Arriving at destination...');
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) context.go('/complete');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
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
                        painter: _GridPainter(),
                        size: Size.infinite,
                      ),
                    ),

                    // Animated route line
                    CustomPaint(painter: _RoutePainter(), size: Size.infinite),

                    // Destination marker
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.15,
                      left: MediaQuery.of(context).size.width * 0.70,
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: CircleAvatar(
                                radius: 6,
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
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
                            child: const Text(
                              'SM City Cebu',
                              style: TextStyle(
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
                      builder: (context, child) {
                        return Positioned(
                          top:
                              MediaQuery.of(context).size.height *
                                  _topAnim.value -
                              28,
                          left:
                              MediaQuery.of(context).size.width *
                                  _leftAnim.value -
                              28,
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.yellow,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.navigation,
                              color: AppColors.primary,
                              size: 28,
                            ),
                          ),
                        );
                      },
                    ),

                    // Status banner
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 16,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                  .animate(onPlay: (c) => c.repeat())
                                  .fadeOut(duration: 800.ms)
                                  .then()
                                  .fadeIn(duration: 800.ms),
                              const SizedBox(width: 8),
                              const Text(
                                'Ride Ongoing',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
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

              // Trip info card
              _TripInfoCard(
                onShareLocation: () => setState(() => _showShareDialog = true),
                onCompleteRide: _handleCompleteRide,
              ),
            ],
          ),

          // Share dialog overlay
          if (_showShareDialog)
            _ShareLocationDialog(
              controller: _sharePhoneController,
              recentContacts: _recentContacts,
              onShare: _handleShareLocation,
              onClose: () => setState(() => _showShareDialog = false),
            ),
        ],
      ),
    );
  }
}

class _TripInfoCard extends StatelessWidget {
  final VoidCallback onShareLocation;
  final VoidCallback onCompleteRide;

  const _TripInfoCard({
    required this.onShareLocation,
    required this.onCompleteRide,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Driver info
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'PS',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pedro Santos',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: const [
                        Icon(Icons.star, size: 14, color: AppColors.yellow),
                        SizedBox(width: 4),
                        Text('4.9', style: TextStyle(fontSize: 13)),
                        Text(
                          ' • ',
                          style: TextStyle(color: AppColors.mutedForeground),
                        ),
                        Text(
                          'ABC 1234',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _IconBtn(icon: Icons.phone, onTap: () {}),
                  const SizedBox(width: 8),
                  _IconBtn(icon: Icons.message, onTap: () {}),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Route
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.muted,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _RouteRow(
                  dotColor: AppColors.primary,
                  label: 'Pickup',
                  address: 'Cebu City, Philippines',
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 11),
                  child: Container(
                    height: 16,
                    width: 2,
                    color: AppColors.border,
                  ),
                ),
                _RouteRow(
                  dotColor: AppColors.red,
                  label: 'Destination',
                  address: 'SM City Cebu',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ETA & distance
          Row(
            children: const [
              Expanded(
                child: _StatBox(label: 'Estimated time', value: '8 mins'),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _StatBox(label: 'Distance', value: '3.2 km'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Share location
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: onShareLocation,
              icon: const Icon(Icons.share, size: 20),
              label: const Text(
                'Share Location with Friends/Family',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow,
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Complete ride (demo)
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onCompleteRide,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Complete Ride (Demo)',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 1, end: 0, duration: 400.ms);
  }
}

class _ShareLocationDialog extends StatelessWidget {
  final TextEditingController controller;
  final List<String> recentContacts;
  final VoidCallback onShare;
  final VoidCallback onClose;

  const _ShareLocationDialog({
    required this.controller,
    required this.recentContacts,
    required this.onShare,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Share Live Location',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Share your real-time location with friends or family for safety',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Enter phone number (09XX XXX XXXX)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Recent Contacts',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 8),
              ...recentContacts.map((contact) {
                final phone =
                    RegExp(r'\((.*?)\)').firstMatch(contact)?.group(1) ?? '';
                return GestureDetector(
                  onTap: () => controller.text = phone,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.muted,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(contact, style: const TextStyle(fontSize: 13)),
                  ),
                );
              }),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: onShare,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Share Location'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: TextButton(
                  onPressed: onClose,
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RouteRow extends StatelessWidget {
  final Color dotColor;
  final String label;
  final String address;

  const _RouteRow({
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
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.mutedForeground,
                ),
              ),
              Text(
                address,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.15)
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
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
      ..moveTo(size.width * 0.25, size.height * 0.85)
      ..quadraticBezierTo(
        size.width * 0.40,
        size.height * 0.55,
        size.width * 0.55,
        size.height * 0.35,
      )
      ..lineTo(size.width * 0.70, size.height * 0.15);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
