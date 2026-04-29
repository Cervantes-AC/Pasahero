import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/contact_sheet.dart';
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
                        width: Responsive.iconSize(context, base: 32),
                        height: Responsive.iconSize(context, base: 32),
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: Responsive.isLargeScreen(context) ? 4 : 3,
                          ),
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
                            width: Responsive.iconSize(context, base: 40),
                            height: Responsive.iconSize(context, base: 40),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: Responsive.iconSize(context, base: 20),
                            height: Responsive.iconSize(context, base: 20),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: Responsive.isLargeScreen(context)
                                    ? 4
                                    : 3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Back / close button
                    Positioned(
                      top:
                          MediaQuery.of(context).padding.top +
                          Responsive.spacing(context, units: 2),
                      left: Responsive.spacing(context, units: 2),
                      child: GestureDetector(
                        onTap: () => context.go('/home'),
                        child: Container(
                          width: Responsive.iconSize(context, base: 40),
                          height: Responsive.iconSize(context, base: 40),
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
                          child: Icon(
                            Icons.close,
                            size: Responsive.iconSize(context, base: 20),
                          ),
                        ),
                      ),
                    ),

                    // SOS button
                    Positioned(
                      top:
                          MediaQuery.of(context).padding.top +
                          Responsive.spacing(context, units: 2),
                      right: Responsive.spacing(context, units: 2),
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
        final markerSize = Responsive.iconSize(context, base: 48);
        final labelSize = Responsive.fontSize(context, 11);

        return Positioned(
          top:
              MediaQuery.of(context).size.height * _topAnim.value -
              markerSize / 2,
          left:
              MediaQuery.of(context).size.width * _leftAnim.value -
              markerSize / 2,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.spacing(context, units: 1.25),
                  vertical: Responsive.spacing(context, units: 0.5),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    Responsive.radius(context, base: 8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Text(
                  'Pedro Santos',
                  style: TextStyle(
                    fontSize: labelSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: Responsive.spacing(context, units: 0.5)),
              Container(
                width: markerSize,
                height: markerSize,
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
                child: Icon(
                  Icons.navigation,
                  color: AppColors.primary,
                  size: Responsive.iconSize(context, base: 24),
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
    final padding = Responsive.spacing(context, units: 3);
    final radius = Responsive.radius(context, base: 24);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(padding, padding * 0.8, padding, padding),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.spacing(context, units: 2),
                vertical: Responsive.spacing(context, units: 1),
              ),
              decoration: BoxDecoration(
                color: AppColors.yellow.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(
                  Responsive.radius(context, base: 20),
                ),
              ),
              child: Text(
                'Driver is on the way',
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, 13),
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(height: Responsive.spacing(context, units: 2)),

            // Driver info row
            Row(
              children: [
                Container(
                  width: Responsive.iconSize(context, base: 64),
                  height: Responsive.iconSize(context, base: 64),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      'PS',
                      style: TextStyle(
                        fontSize: Responsive.fontSize(context, 20),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: Responsive.spacing(context, units: 2)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pedro Santos',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 17),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: Responsive.iconSize(context, base: 14),
                            color: AppColors.yellow,
                          ),
                          SizedBox(
                            width: Responsive.spacing(context, units: 0.5),
                          ),
                          Text(
                            '4.9',
                            style: TextStyle(
                              fontSize: Responsive.fontSize(context, 13),
                            ),
                          ),
                          Text(
                            ' • ',
                            style: TextStyle(
                              fontSize: Responsive.fontSize(context, 13),
                              color: AppColors.mutedForeground,
                            ),
                          ),
                          Text(
                            'ABC 1234',
                            style: TextStyle(
                              fontSize: Responsive.fontSize(context, 13),
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
                    _IconBtn(
                      icon: Icons.phone,
                      onTap: () => showContactSheet(
                        context,
                        name: 'Pedro Santos',
                        phone: '+63 912 345 6789',
                      ),
                    ),
                    SizedBox(width: Responsive.spacing(context, units: 1)),
                    _IconBtn(
                      icon: Icons.message,
                      onTap: () => showContactSheet(
                        context,
                        name: 'Pedro Santos',
                        phone: '+63 912 345 6789',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: Responsive.spacing(context, units: 2)),

            // ETA & fare
            Row(
              children: [
                Expanded(
                  child: _StatBox(label: 'Estimated arrival', value: '3 mins'),
                ),
                SizedBox(width: Responsive.spacing(context, units: 1.5)),
                Expanded(
                  child: _StatBox(label: 'Estimated fare', value: '₱45'),
                ),
              ],
            ),
            SizedBox(height: Responsive.spacing(context, units: 2)),

            // Actions
            SizedBox(
              width: double.infinity,
              height: Responsive.buttonHeight(context),
              child: ElevatedButton(
                onPressed: onDriverArrived,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      Responsive.radius(context, base: 12),
                    ),
                  ),
                ),
                child: Text(
                  'Driver Arrived (Demo)',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Responsive.fontSize(context, 16),
                  ),
                ),
              ),
            ),
            SizedBox(height: Responsive.spacing(context, units: 1.25)),
            SizedBox(
              width: double.infinity,
              height: Responsive.buttonHeight(context),
              child: OutlinedButton(
                onPressed: onCancelRide,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.red,
                  side: const BorderSide(color: AppColors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      Responsive.radius(context, base: 12),
                    ),
                  ),
                ),
                child: Text(
                  'Cancel Ride',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Responsive.fontSize(context, 16),
                  ),
                ),
              ),
            ),
          ],
        ),
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
    final padding = Responsive.spacing(context, units: 3);
    final radius = Responsive.radius(context, base: 20);
    final fontSize = Responsive.fontSize(context, 18);

    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: Responsive.spacing(context, units: 3),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
          ),
          padding: EdgeInsets.all(padding),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cancel Ride?',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Responsive.spacing(context, units: 1)),
                Text(
                  'A cancellation fee of ₱15 will be charged. Please select a reason:',
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 13),
                    color: AppColors.mutedForeground,
                  ),
                ),
                SizedBox(height: Responsive.spacing(context, units: 2)),
                ...cancelReasons.map(
                  (reason) => GestureDetector(
                    onTap: () => onReasonSelected(reason),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Responsive.spacing(context, units: 0.5),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: Responsive.iconSize(context, base: 24),
                            height: Responsive.iconSize(context, base: 24),
                            child: Radio<String>(
                              value: reason,
                              groupValue: selectedReason,
                              onChanged: (v) => onReasonSelected(v ?? ''),
                              activeColor: AppColors.primary,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                          SizedBox(
                            width: Responsive.spacing(context, units: 1),
                          ),
                          Text(
                            reason,
                            style: TextStyle(
                              fontSize: Responsive.fontSize(context, 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (selectedReason == 'Other') ...[
                  SizedBox(height: Responsive.spacing(context, units: 1)),
                  TextField(
                    controller: customReasonController,
                    decoration: InputDecoration(
                      hintText: 'Please specify your reason...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          Responsive.radius(context, base: 12),
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: Responsive.spacing(context, units: 1.5),
                        vertical: Responsive.spacing(context, units: 1.25),
                      ),
                    ),
                    maxLines: 2,
                  ),
                ],
                SizedBox(height: Responsive.spacing(context, units: 2.5)),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onKeepRide,
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              Responsive.radius(context, base: 12),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: Responsive.spacing(context, units: 1.75),
                          ),
                        ),
                        child: Text(
                          'Keep Ride',
                          style: TextStyle(
                            fontSize: Responsive.fontSize(context, 14),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: Responsive.spacing(context, units: 1.5)),
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
                            borderRadius: BorderRadius.circular(
                              Responsive.radius(context, base: 12),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: Responsive.spacing(context, units: 1.75),
                          ),
                        ),
                        child: Text(
                          'Confirm Cancel',
                          style: TextStyle(
                            fontSize: Responsive.fontSize(context, 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
      padding: EdgeInsets.all(Responsive.spacing(context, units: 1.5)),
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: BorderRadius.circular(
          Responsive.radius(context, base: 12),
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 22),
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, units: 0.25)),
          Text(
            label,
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 11),
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
    final size = Responsive.iconSize(context, base: 44);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: Responsive.iconSize(context, base: 20),
        ),
      ),
    );
  }
}
