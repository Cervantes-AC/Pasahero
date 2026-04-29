import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../data/mock_drivers.dart';
import '../../widgets/toast.dart';
import '../../utils/responsive.dart';

class DriverDetailScreen extends StatelessWidget {
  final String driverId;
  const DriverDetailScreen({super.key, required this.driverId});

  String _serviceLabel(String type) {
    if (type == 'habal-habal') return 'Habal-habal (Motorcycle)';
    if (type == 'bao-bao') return 'Bao-bao (Tricycle)';
    return type;
  }

  IconData _vehicleIcon(String type) =>
      type == 'bao-bao' ? Icons.directions_car : Icons.two_wheeler;

  @override
  Widget build(BuildContext context) {
    final driver = driverDetails[driverId] ?? driverDetails['1']!;
    final icon = _vehicleIcon(driver.vehicleType);

    void handleOrderRide() {
      showToast(context, 'Requesting ride from ${driver.name}...');
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (context.mounted) context.go('/tracking');
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  Responsive.spacing(context, units: 3),
                  Responsive.spacing(context, units: 2),
                  Responsive.spacing(context, units: 3),
                  Responsive.spacing(context, units: 3),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: Responsive.iconSize(context, base: 40),
                        height: Responsive.iconSize(context, base: 40),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: Responsive.iconSize(context, base: 20),
                        ),
                      ),
                    ),
                    SizedBox(width: Responsive.spacing(context, units: 2)),
                    Text(
                      'Driver Details',
                      style: TextStyle(
                        fontSize: Responsive.fontSize(context, 20),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                Responsive.spacing(context, units: 3),
                Responsive.spacing(context, units: 3),
                Responsive.spacing(context, units: 3),
                Responsive.spacing(context, units: 12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Driver profile card
                  _Card(
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Avatar
                                Container(
                                  width: Responsive.iconSize(context, base: 80),
                                  height: Responsive.iconSize(
                                    context,
                                    base: 80,
                                  ),
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primary,
                                        AppColors.primaryDark,
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      driver.name
                                          .split(' ')
                                          .map((n) => n[0])
                                          .join(),
                                      style: TextStyle(
                                        fontSize: Responsive.fontSize(
                                          context,
                                          24,
                                        ),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: Responsive.spacing(context, units: 2),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        driver.name,
                                        style: TextStyle(
                                          fontSize: Responsive.fontSize(
                                            context,
                                            20,
                                          ),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: Responsive.spacing(
                                          context,
                                          units: 0.5,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: Responsive.iconSize(
                                              context,
                                              base: 18,
                                            ),
                                            color: AppColors.yellow,
                                          ),
                                          SizedBox(
                                            width: Responsive.spacing(
                                              context,
                                              units: 0.5,
                                            ),
                                          ),
                                          Text(
                                            '${driver.rating}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: Responsive.fontSize(
                                                context,
                                                15,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            ' • ',
                                            style: TextStyle(
                                              color: AppColors.mutedForeground,
                                              fontSize: Responsive.fontSize(
                                                context,
                                                15,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${driver.totalRides} rides',
                                            style: TextStyle(
                                              fontSize: Responsive.fontSize(
                                                context,
                                                13,
                                              ),
                                              color: AppColors.mutedForeground,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Responsive.spacing(
                                          context,
                                          units: 0.75,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.verified_user,
                                            size: Responsive.iconSize(
                                              context,
                                              base: 14,
                                            ),
                                            color: AppColors.green,
                                          ),
                                          SizedBox(
                                            width: Responsive.spacing(
                                              context,
                                              units: 0.5,
                                            ),
                                          ),
                                          Text(
                                            'Verified Driver',
                                            style: TextStyle(
                                              fontSize: Responsive.fontSize(
                                                context,
                                                13,
                                              ),
                                              color: AppColors.green,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: Responsive.spacing(context, units: 2),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: _StatBox(
                                    label: 'ETA',
                                    value: driver.eta,
                                  ),
                                ),
                                SizedBox(
                                  width: Responsive.spacing(
                                    context,
                                    units: 1.5,
                                  ),
                                ),
                                Expanded(
                                  child: _StatBox(
                                    label: 'Estimated Fare',
                                    value: '₱${driver.fare}',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.2, end: 0),

                  SizedBox(height: Responsive.spacing(context, units: 2.5)),

                  // Vehicle details
                  Text(
                    'Vehicle Details',
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 17),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: Responsive.spacing(context, units: 1.5)),
                  _Card(
                        child: Row(
                          children: [
                            Container(
                              width: Responsive.iconSize(context, base: 96),
                              height: Responsive.iconSize(context, base: 96),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.primaryDark,
                                  ],
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    Responsive.radius(context, base: 16),
                                  ),
                                ),
                              ),
                              child: Icon(
                                icon,
                                size: Responsive.iconSize(context, base: 48),
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: Responsive.spacing(context, units: 2),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    driver.vehicleName,
                                    style: TextStyle(
                                      fontSize: Responsive.fontSize(
                                        context,
                                        16,
                                      ),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: Responsive.spacing(
                                      context,
                                      units: 0.5,
                                    ),
                                  ),
                                  Text(
                                    'Plate: ${driver.plateNumber}',
                                    style: TextStyle(
                                      fontSize: Responsive.fontSize(
                                        context,
                                        13,
                                      ),
                                      color: AppColors.mutedForeground,
                                    ),
                                  ),
                                  SizedBox(
                                    height: Responsive.spacing(
                                      context,
                                      units: 1,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Responsive.spacing(
                                        context,
                                        units: 1.5,
                                      ),
                                      vertical: Responsive.spacing(
                                        context,
                                        units: 0.5,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        Responsive.radius(context, base: 20),
                                      ),
                                    ),
                                    child: Text(
                                      driver.vehicleType,
                                      style: TextStyle(
                                        fontSize: Responsive.fontSize(
                                          context,
                                          12,
                                        ),
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 100.ms, duration: 400.ms)
                      .slideY(begin: 0.2, end: 0),

                  SizedBox(height: Responsive.spacing(context, units: 2.5)),

                  // Contact
                  Text(
                    'Contact Driver',
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 17),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: Responsive.spacing(context, units: 1.5)),
                  Row(
                        children: [
                          Expanded(
                            child: _ContactButton(
                              icon: Icons.phone,
                              label: 'Call',
                              onTap: () => showToast(
                                context,
                                'Calling ${driver.name}...',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: Responsive.spacing(context, units: 1.5),
                          ),
                          Expanded(
                            child: _ContactButton(
                              icon: Icons.message,
                              label: 'Message',
                              onTap: () =>
                                  showToast(context, 'Opening chat...'),
                            ),
                          ),
                        ],
                      )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 400.ms)
                      .slideY(begin: 0.2, end: 0),

                  SizedBox(height: Responsive.spacing(context, units: 2.5)),

                  // Additional details
                  Text(
                    'Additional Details',
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 17),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: Responsive.spacing(context, units: 1.5)),
                  _Card(
                        child: Column(
                          children: [
                            _DetailRow(
                              icon: icon,
                              iconBg: AppColors.primary.withValues(alpha: 0.1),
                              iconColor: AppColors.primary,
                              label: 'Service Type',
                              value: _serviceLabel(driver.vehicleType),
                            ),
                            if (driver.vehicleType == 'habal-habal') ...[
                              Divider(
                                height: Responsive.spacing(context, units: 3),
                              ),
                              _DetailRow(
                                icon: Icons.verified_user,
                                iconBg: AppColors.green.withValues(alpha: 0.1),
                                iconColor: AppColors.green,
                                label: 'Safety Equipment',
                                value: driver.helmetsAvailable
                                    ? 'Helmets Available'
                                    : 'No Helmets Available',
                              ),
                            ],
                            Divider(
                              height: Responsive.spacing(context, units: 3),
                            ),
                            _DetailRow(
                              icon: Icons.calendar_today,
                              iconBg: AppColors.yellow.withValues(alpha: 0.2),
                              iconColor: AppColors.primary,
                              label: 'Driver Since',
                              value: driver.verifiedDate,
                            ),
                            Divider(
                              height: Responsive.spacing(context, units: 3),
                            ),
                            _DetailRow(
                              icon: Icons.location_on_outlined,
                              iconBg: AppColors.primary.withValues(alpha: 0.1),
                              iconColor: AppColors.primary,
                              label: 'Current Location',
                              value: 'Near Paseo de Santa Rosa',
                            ),
                            Divider(
                              height: Responsive.spacing(context, units: 3),
                            ),
                            _DetailRow(
                              icon: Icons.access_time_outlined,
                              iconBg: AppColors.amber.withValues(alpha: 0.1),
                              iconColor: AppColors.amber,
                              label: 'Availability',
                              value: 'Online • Available Now',
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 400.ms)
                      .slideY(begin: 0.2, end: 0),

                  SizedBox(height: Responsive.spacing(context, units: 2.5)),

                  // Driver stats
                  Text(
                    'Driver Statistics',
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 17),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: Responsive.spacing(context, units: 1.5)),
                  _Card(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                icon: Icons.route_rounded,
                                label: 'Total Trips',
                                value: '${driver.totalRides}',
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(
                              width: Responsive.spacing(context, units: 1.5),
                            ),
                            Expanded(
                              child: _StatCard(
                                icon: Icons.schedule_rounded,
                                label: 'Response Time',
                                value: '< 2 min',
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Responsive.spacing(context, units: 1.5),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                icon: Icons.thumb_up_outlined,
                                label: 'Acceptance Rate',
                                value: '98%',
                                color: AppColors.amber,
                              ),
                            ),
                            SizedBox(
                              width: Responsive.spacing(context, units: 1.5),
                            ),
                            Expanded(
                              child: _StatCard(
                                icon: Icons.cancel_outlined,
                                label: 'Cancellation Rate',
                                value: '< 1%',
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 350.ms, duration: 400.ms),

                  SizedBox(height: Responsive.spacing(context, units: 2.5)),

                  // Reviews
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Passenger Reviews',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 17),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${mockReviews.length} reviews',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 13),
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Responsive.spacing(context, units: 1.5)),
                  ...mockReviews.asMap().entries.map((entry) {
                    final i = entry.key;
                    final review = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: Responsive.spacing(context, units: 1.5),
                      ),
                      child:
                          _Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              review.passengerName,
                                              style: TextStyle(
                                                fontSize: Responsive.fontSize(
                                                  context,
                                                  14,
                                                ),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              review.date,
                                              style: TextStyle(
                                                fontSize: Responsive.fontSize(
                                                  context,
                                                  12,
                                                ),
                                                color:
                                                    AppColors.mutedForeground,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              size: Responsive.iconSize(
                                                context,
                                                base: 14,
                                              ),
                                              color: AppColors.yellow,
                                            ),
                                            SizedBox(
                                              width: Responsive.spacing(
                                                context,
                                                units: 0.5,
                                              ),
                                            ),
                                            Text(
                                              '${review.rating}',
                                              style: TextStyle(
                                                fontSize: Responsive.fontSize(
                                                  context,
                                                  13,
                                                ),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: Responsive.spacing(
                                        context,
                                        units: 1,
                                      ),
                                    ),
                                    Text(
                                      review.comment,
                                      style: TextStyle(
                                        fontSize: Responsive.fontSize(
                                          context,
                                          13,
                                        ),
                                        color: AppColors.mutedForeground,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .animate()
                              .fadeIn(
                                delay: (400 + i * 100).ms,
                                duration: 400.ms,
                              )
                              .slideX(begin: -0.2, end: 0),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),

      // Fixed bottom button
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(
          Responsive.spacing(context, units: 3),
          Responsive.spacing(context, units: 1.5),
          Responsive.spacing(context, units: 3),
          Responsive.spacing(context, units: 3),
        ),
        child: SafeArea(
          child: SizedBox(
            height: Responsive.buttonHeight(context),
            child: ElevatedButton(
              onPressed: handleOrderRide,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    Responsive.radius(context, base: 16),
                  ),
                ),
              ),
              child: Text(
                'Order Ride - ₱${driver.fare}',
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, 16),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.spacing(context, units: 2.5)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          Responsive.radius(context, base: 20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
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
              fontSize: Responsive.fontSize(context, 18),
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

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ContactButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Responsive.buttonHeight(context),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary, width: 2),
          borderRadius: BorderRadius.circular(
            Responsive.radius(context, base: 12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: Responsive.iconSize(context, base: 20),
            ),
            SizedBox(width: Responsive.spacing(context, units: 1)),
            Text(
              label,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: Responsive.fontSize(context, 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;
  const _DetailRow({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: Responsive.iconSize(context, base: 40),
          height: Responsive.iconSize(context, base: 40),
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(
              Responsive.radius(context, base: 10),
            ),
          ),
          child: Icon(
            icon,
            size: Responsive.iconSize(context, base: 20),
            color: iconColor,
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
                  fontSize: Responsive.fontSize(context, 12),
                  color: AppColors.mutedForeground,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, 14),
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

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Responsive.spacing(context, units: 1.75)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(
          Responsive.radius(context, base: 12),
        ),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: Responsive.iconSize(context, base: 16),
                color: color,
              ),
              SizedBox(width: Responsive.spacing(context, units: 0.75)),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 11),
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.spacing(context, units: 0.75)),
          Text(
            value,
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 16),
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
