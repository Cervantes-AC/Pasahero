import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/toast.dart';

class RideTrackingScreen extends StatefulWidget {
  const RideTrackingScreen({super.key});

  @override
  State<RideTrackingScreen> createState() => _RideTrackingScreenState();
}

class _RideTrackingScreenState extends State<RideTrackingScreen> {
  bool _showCancelDialog = false;
  String _cancelReason = '';
  final _customReasonController = TextEditingController();

  final _cancelReasons = [
    'Driver is taking too long',
    'Changed my mind',
    'Found another ride',
    'Emergency came up',
    'Other',
  ];

  @override
  void dispose() {
    _customReasonController.dispose();
    super.dispose();
  }

  void _handleCancelRide() {
    if (_cancelReason.isNotEmpty) {
      showToast(
        context,
        'Ride cancelled. ₱15 cancellation fee will be charged.',
      );
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) context.go('/home');
      });
    }
  }

  void _handleDriverArrived() {
    showToast(context, 'Driver has arrived! Starting your ride...');
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) context.go('/ongoing');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map view
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

                    // Route line
                    CustomPaint(painter: _RoutePainter(), size: Size.infinite),

                    // Destination marker
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.20,
                      left: MediaQuery.of(context).size.width * 0.60,
                      child: Container(
                        width: 32,
                        height: 32,
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
                      ),
                    ),

                    // Animated driver marker
                    _AnimatedDriverMarker(),

                    // Your location
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.40,
                      left: MediaQuery.of(context).size.width * 0.50,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Back / close button
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 16,
                      left: 16,
                      child: GestureDetector(
                        onTap: () => context.go('/home'),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.close, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Driver info card
              _DriverInfoCard(
                onDriverArrived: _handleDriverArrived,
                onCancelRide: () => setState(() => _showCancelDialog = true),
              ),
            ],
          ),

          // Cancel dialog overlay
          if (_showCancelDialog)
            _CancelDialog(
              cancelReasons: _cancelReasons,
              selectedReason: _cancelReason,
              customReasonController: _customReasonController,
              onReasonSelected: (r) => setState(() => _cancelReason = r),
              onKeepRide: () => setState(() {
                _showCancelDialog = false;
                _cancelReason = '';
              }),
              onConfirmCancel: _handleCancelRide,
            ),
        ],
      ),
    );
  }
}

class _AnimatedDriverMarker extends StatefulWidget {
  @override
  State<_AnimatedDriverMarker> createState() => _AnimatedDriverMarkerState();
}

class _AnimatedDriverMarkerState extends State<_AnimatedDriverMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _topAnim;
  late Animation<double> _leftAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _topAnim = Tween<double>(begin: 0.75, end: 0.40).animate(_controller);
    _leftAnim = Tween<double>(begin: 0.30, end: 0.50).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          top: MediaQuery.of(context).size.height * _topAnim.value - 24,
          left: MediaQuery.of(context).size.width * _leftAnim.value - 24,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Text(
                  'Pedro Santos',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  shape: BoxShape.circle,
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
                  size: 24,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DriverInfoCard extends StatelessWidget {
  final VoidCallback onDriverArrived;
  final VoidCallback onCancelRide;

  const _DriverInfoCard({
    required this.onDriverArrived,
    required this.onCancelRide,
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
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.yellow.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Driver is on the way',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Driver info row
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
                      children: [
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: AppColors.yellow,
                        ),
                        const SizedBox(width: 4),
                        const Text('4.9', style: TextStyle(fontSize: 13)),
                        const Text(
                          ' • ',
                          style: TextStyle(color: AppColors.mutedForeground),
                        ),
                        const Text(
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

          // ETA & fare
          Row(
            children: [
              Expanded(
                child: _StatBox(label: 'Estimated arrival', value: '3 mins'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatBox(label: 'Estimated fare', value: '₱45'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Actions
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onDriverArrived,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Driver Arrived (Demo)',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: onCancelRide,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.red,
                side: const BorderSide(color: AppColors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Cancel Ride',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 1, end: 0, duration: 400.ms);
  }
}

class _CancelDialog extends StatelessWidget {
  final List<String> cancelReasons;
  final String selectedReason;
  final TextEditingController customReasonController;
  final ValueChanged<String> onReasonSelected;
  final VoidCallback onKeepRide;
  final VoidCallback onConfirmCancel;

  const _CancelDialog({
    required this.cancelReasons,
    required this.selectedReason,
    required this.customReasonController,
    required this.onReasonSelected,
    required this.onKeepRide,
    required this.onConfirmCancel,
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
                'Cancel Ride?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'A cancellation fee of ₱15 will be charged. Please select a reason:',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 16),
              ...cancelReasons.map(
                (reason) => GestureDetector(
                  onTap: () => onReasonSelected(reason),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Radio<String>(
                            value: reason,
                            groupValue: selectedReason,
                            onChanged: (v) => onReasonSelected(v ?? ''),
                            activeColor: AppColors.primary,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(reason, style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ),
              if (selectedReason == 'Other') ...[
                const SizedBox(height: 8),
                TextField(
                  controller: customReasonController,
                  decoration: InputDecoration(
                    hintText: 'Please specify your reason...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  maxLines: 2,
                ),
              ],
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onKeepRide,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Keep Ride'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          selectedReason.isEmpty ||
                              (selectedReason == 'Other' &&
                                  customReasonController.text.isEmpty)
                          ? null
                          : onConfirmCancel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Confirm Cancel'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.15)
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final routePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(size.width * 0.30, size.height * 0.75)
      ..quadraticBezierTo(
        size.width * 0.40,
        size.height * 0.50,
        size.width * 0.55,
        size.height * 0.30,
      );
    canvas.drawPath(path, routePaint);
  }

  @override
  bool shouldRepaint(_) => false;
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
