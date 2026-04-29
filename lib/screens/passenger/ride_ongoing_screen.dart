import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/contact_sheet.dart';
import '../../widgets/toast.dart';
import '../../utils/responsive.dart';

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

  void _showSOSNotification(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.emergency, color: AppColors.error, size: 28),
            SizedBox(width: 12),
            Text('SOS Alert'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Emergency assistance requested',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Your SOS request has been sent to the nearest LGU (Local Government Unit). Emergency responders have been notified of your location.',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.location_on, color: AppColors.error, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Location: Valencia City, Philippines',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, color: AppColors.error, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'ETA: 5-10 minutes',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    showToast(context, 'SOS alert sent to nearest LGU');
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
                            width: Responsive.iconSize(context, base: 40),
                            height: Responsive.iconSize(context, base: 40),
                            decoration: BoxDecoration(
                              color: AppColors.red,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: Responsive.radius(context, base: 3),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Center(
                              child: CircleAvatar(
                                radius: Responsive.iconSize(context, base: 6),
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Responsive.spacing(context, units: 0.5),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Responsive.spacing(context, units: 1),
                              vertical: Responsive.spacing(
                                context,
                                units: 0.375,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                Responsive.radius(context, base: 6),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Text(
                              'Robinsons Place',
                              style: TextStyle(
                                fontSize: Responsive.fontSize(context, 10),
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
                        final vehicleSize = Responsive.iconSize(
                          context,
                          base: 56,
                        );
                        return Positioned(
                          top:
                              MediaQuery.of(context).size.height *
                                  _topAnim.value -
                              vehicleSize / 2,
                          left:
                              MediaQuery.of(context).size.width *
                                  _leftAnim.value -
                              vehicleSize / 2,
                          child: Container(
                            width: vehicleSize,
                            height: vehicleSize,
                            decoration: BoxDecoration(
                              color: AppColors.yellow,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: Responsive.radius(context, base: 3),
                              ),
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
                              size: Responsive.iconSize(context, base: 28),
                            ),
                          ),
                        );
                      },
                    ),

                    // Status banner
                    Positioned(
                      top:
                          MediaQuery.of(context).padding.top +
                          Responsive.spacing(context, units: 2),
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.spacing(context, units: 2.5),
                            vertical: Responsive.spacing(context, units: 1.25),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(
                              Responsive.radius(context, base: 24),
                            ),
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
                                    width: Responsive.spacing(
                                      context,
                                      units: 1,
                                    ),
                                    height: Responsive.spacing(
                                      context,
                                      units: 1,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                  .animate(onPlay: (c) => c.repeat())
                                  .fadeOut(duration: 800.ms)
                                  .then()
                                  .fadeIn(duration: 800.ms),
                              SizedBox(
                                width: Responsive.spacing(context, units: 1),
                              ),
                              Text(
                                'Ride Ongoing',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: Responsive.fontSize(context, 14),
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
                onSOS: () => _showSOSNotification(context),
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
  final VoidCallback onSOS;

  const _TripInfoCard({
    required this.onShareLocation,
    required this.onCompleteRide,
    required this.onSOS,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Responsive.radius(context, base: 24)),
          topRight: Radius.circular(Responsive.radius(context, base: 24)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        Responsive.spacing(context, units: 3),
        Responsive.spacing(context, units: 2.5),
        Responsive.spacing(context, units: 3),
        Responsive.spacing(context, units: 3),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Driver info
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
                            color: AppColors.mutedForeground,
                            fontSize: Responsive.fontSize(context, 13),
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
                  SizedBox(width: Responsive.spacing(context, units: 1)),
                  _IconBtn(
                    icon: Icons.emergency,
                    color: AppColors.error,
                    onTap: onSOS,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: Responsive.spacing(context, units: 2)),

          // Vehicle selection display
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.spacing(context, units: 2),
              vertical: Responsive.spacing(context, units: 1.5),
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(
                Responsive.radius(context, base: 12),
              ),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: Responsive.iconSize(context, base: 36),
                  height: Responsive.iconSize(context, base: 36),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(
                      Responsive.radius(context, base: 8),
                    ),
                  ),
                  child: Icon(
                    Icons.two_wheeler,
                    size: Responsive.iconSize(context, base: 18),
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: Responsive.spacing(context, units: 1.5)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Habal-habal',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 13),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Motorcycle · 1 seat',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 11),
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.spacing(context, units: 1),
                    vertical: Responsive.spacing(context, units: 0.5),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      Responsive.radius(context, base: 6),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: Responsive.iconSize(context, base: 12),
                        color: AppColors.green,
                      ),
                      SizedBox(width: Responsive.spacing(context, units: 0.5)),
                      Text(
                        'Active',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 10),
                          fontWeight: FontWeight.w600,
                          color: AppColors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Responsive.spacing(context, units: 2)),

          // Route
          Container(
            padding: EdgeInsets.all(Responsive.spacing(context, units: 2)),
            decoration: BoxDecoration(
              color: AppColors.muted,
              borderRadius: BorderRadius.circular(
                Responsive.radius(context, base: 12),
              ),
            ),
            child: Column(
              children: [
                _RouteRow(
                  dotColor: AppColors.primary,
                  label: 'Pickup',
                  address: 'Valencia City, Philippines',
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: Responsive.spacing(context, units: 1.375),
                  ),
                  child: Container(
                    height: Responsive.spacing(context, units: 2),
                    width: Responsive.spacing(context, units: 0.25),
                    color: AppColors.border,
                  ),
                ),
                _RouteRow(
                  dotColor: AppColors.red,
                  label: 'Destination',
                  address: 'Robinsons Place',
                ),
              ],
            ),
          ),
          SizedBox(height: Responsive.spacing(context, units: 2)),

          // ETA & distance
          Row(
            children: [
              Expanded(
                child: _StatBox(label: 'Estimated time', value: '8 mins'),
              ),
              SizedBox(width: Responsive.spacing(context, units: 1.5)),
              Expanded(
                child: _StatBox(label: 'Distance', value: '3.2 km'),
              ),
            ],
          ),
          SizedBox(height: Responsive.spacing(context, units: 2)),

          // Share location
          SizedBox(
            width: double.infinity,
            height: Responsive.buttonHeight(context),
            child: ElevatedButton.icon(
              onPressed: onShareLocation,
              icon: Icon(
                Icons.share,
                size: Responsive.iconSize(context, base: 20),
              ),
              label: Text(
                'Share Location with Friends/Family',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Responsive.fontSize(context, 14),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow,
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    Responsive.radius(context, base: 12),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: Responsive.spacing(context, units: 1.25)),

          // Complete ride (demo)
          SizedBox(
            width: double.infinity,
            height: Responsive.buttonHeight(context),
            child: ElevatedButton(
              onPressed: onCompleteRide,
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
                'Complete Ride (Demo)',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Responsive.fontSize(context, 14),
                ),
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
          margin: EdgeInsets.symmetric(
            horizontal: Responsive.spacing(context, units: 3),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              Responsive.radius(context, base: 20),
            ),
          ),
          padding: EdgeInsets.all(Responsive.spacing(context, units: 3)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Share Live Location',
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, 18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Responsive.spacing(context, units: 1)),
              Text(
                'Share your real-time location with friends or family for safety',
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, 13),
                  color: AppColors.mutedForeground,
                ),
              ),
              SizedBox(height: Responsive.spacing(context, units: 2)),
              TextField(
                controller: controller,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Enter phone number (09XX XXX XXXX)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      Responsive.radius(context, base: 12),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Responsive.spacing(context, units: 2),
                    vertical: Responsive.spacing(context, units: 1.75),
                  ),
                ),
              ),
              SizedBox(height: Responsive.spacing(context, units: 2)),
              Text(
                'Recent Contacts',
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, 12),
                  fontWeight: FontWeight.w600,
                  color: AppColors.mutedForeground,
                ),
              ),
              SizedBox(height: Responsive.spacing(context, units: 1)),
              ...recentContacts.map((contact) {
                final phone =
                    RegExp(r'\((.*?)\)').firstMatch(contact)?.group(1) ?? '';
                return GestureDetector(
                  onTap: () => controller.text = phone,
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      bottom: Responsive.spacing(context, units: 1),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.spacing(context, units: 2),
                      vertical: Responsive.spacing(context, units: 1.5),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.muted,
                      borderRadius: BorderRadius.circular(
                        Responsive.radius(context, base: 12),
                      ),
                    ),
                    child: Text(
                      contact,
                      style: TextStyle(
                        fontSize: Responsive.fontSize(context, 13),
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(height: Responsive.spacing(context, units: 2)),
              SizedBox(
                width: double.infinity,
                height: Responsive.buttonHeight(context),
                child: ElevatedButton(
                  onPressed: onShare,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Responsive.radius(context, base: 12),
                      ),
                    ),
                  ),
                  child: Text(
                    'Share Location',
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 14),
                    ),
                  ),
                ),
              ),
              SizedBox(height: Responsive.spacing(context, units: 1)),
              SizedBox(
                width: double.infinity,
                height: Responsive.buttonHeight(context) * 0.75,
                child: TextButton(
                  onPressed: onClose,
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 14),
                    ),
                  ),
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
          width: Responsive.iconSize(context, base: 24),
          height: Responsive.iconSize(context, base: 24),
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          child: Center(
            child: CircleAvatar(
              radius: Responsive.iconSize(context, base: 4),
              backgroundColor: Colors.white,
            ),
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
                  fontSize: Responsive.fontSize(context, 11),
                  color: AppColors.mutedForeground,
                ),
              ),
              Text(
                address,
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, 13),
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
  final Color? color;
  const _IconBtn({required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final btnColor = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Responsive.iconSize(context, base: 44),
        height: Responsive.iconSize(context, base: 44),
        decoration: BoxDecoration(
          color: btnColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: btnColor,
          size: Responsive.iconSize(context, base: 20),
        ),
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
