import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../data/mock_drivers.dart';
import '../widgets/toast.dart';

class DriverDetailScreen extends StatelessWidget {
  final String driverId;
  const DriverDetailScreen({super.key, required this.driverId});

  String _serviceLabel(String type) {
    if (type == 'habal-habal') return 'Habal-habal (Motorcycle)';
    if (type == 'rela') return 'Rela (Motorcycle with Sidecar)';
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
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Driver Details',
                      style: TextStyle(
                        fontSize: 20,
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
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
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
                                  width: 80,
                                  height: 80,
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
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        driver.name,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            size: 18,
                                            color: AppColors.yellow,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${driver.rating}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const Text(
                                            ' â€¢ ',
                                            style: TextStyle(
                                              color: AppColors.mutedForeground,
                                            ),
                                          ),
                                          Text(
                                            '${driver.totalRides} rides',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: AppColors.mutedForeground,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.verified_user,
                                            size: 14,
                                            color: AppColors.green,
                                          ),
                                          const SizedBox(width: 4),
                                          const Text(
                                            'Verified Driver',
                                            style: TextStyle(
                                              fontSize: 13,
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
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _StatBox(
                                    label: 'ETA',
                                    value: driver.eta,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _StatBox(
                                    label: 'Estimated Fare',
                                    value: 'â‚±${driver.fare}',
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

                  const SizedBox(height: 20),

                  // Vehicle details
                  const Text(
                    'Vehicle Details',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  _Card(
                        child: Row(
                          children: [
                            Container(
                              width: 96,
                              height: 96,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.primaryDark,
                                  ],
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                              ),
                              child: Icon(icon, size: 48, color: Colors.white),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    driver.vehicleName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Plate: ${driver.plateNumber}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.mutedForeground,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      driver.vehicleType,
                                      style: const TextStyle(
                                        fontSize: 12,
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

                  const SizedBox(height: 20),

                  // Contact
                  const Text(
                    'Contact Driver',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
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
                          const SizedBox(width: 12),
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

                  const SizedBox(height: 20),

                  // Additional details
                  const Text(
                    'Additional Details',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
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
                              const Divider(height: 24),
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
                            const Divider(height: 24),
                            _DetailRow(
                              icon: Icons.calendar_today,
                              iconBg: AppColors.yellow.withValues(alpha: 0.2),
                              iconColor: AppColors.primary,
                              label: 'Driver Since',
                              value: driver.verifiedDate,
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 400.ms)
                      .slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 20),

                  // Reviews
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Passenger Reviews',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${mockReviews.length} reviews',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...mockReviews.asMap().entries.map((entry) {
                    final i = entry.key;
                    final review = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
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
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              review.date,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color:
                                                    AppColors.mutedForeground,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              size: 14,
                                              color: AppColors.yellow,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${review.rating}',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      review.comment,
                                      style: const TextStyle(
                                        fontSize: 13,
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
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: SafeArea(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: handleOrderRide,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Order Ride - â‚±${driver.fare}',
                style: const TextStyle(
                  fontSize: 16,
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
              fontSize: 18,
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
        height: 56,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
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
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.mutedForeground,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
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
