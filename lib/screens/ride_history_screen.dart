import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../widgets/toast.dart';

class _Ride {
  final String id;
  final String date;
  final String time;
  final String pickup;
  final String dropoff;
  final String driverName;
  final double driverRating;
  final String vehicleType;
  final int fare;
  final int? rating;
  final String distance;
  final String duration;
  final String plateNumber;
  final String status; // 'completed' | 'cancelled'

  const _Ride({
    required this.id,
    required this.date,
    required this.time,
    required this.pickup,
    required this.dropoff,
    required this.driverName,
    required this.driverRating,
    required this.vehicleType,
    required this.fare,
    this.rating,
    required this.distance,
    required this.duration,
    required this.plateNumber,
    required this.status,
  });
}

const _mockRides = [
  _Ride(
    id: '1',
    date: 'Today',
    time: '2:30 PM',
    pickup: 'SM City Cebu',
    dropoff: 'Ayala Center Cebu',
    driverName: 'Pedro Santos',
    driverRating: 4.9,
    vehicleType: 'habal-habal',
    fare: 45,
    rating: 5,
    distance: '3.2 km',
    duration: '15 mins',
    plateNumber: 'ABC 1234',
    status: 'completed',
  ),
  _Ride(
    id: '2',
    date: 'Yesterday',
    time: '9:15 AM',
    pickup: 'IT Park, Lahug',
    dropoff: 'Guadalupe',
    driverName: 'Maria Garcia',
    driverRating: 4.8,
    vehicleType: 'habal-habal',
    fare: 42,
    rating: 5,
    distance: '2.8 km',
    duration: '12 mins',
    plateNumber: 'XYZ 5678',
    status: 'completed',
  ),
  _Ride(
    id: '3',
    date: 'March 5, 2026',
    time: '6:45 PM',
    pickup: 'Capitol Site',
    dropoff: 'Mabolo',
    driverName: 'Juan Reyes',
    driverRating: 4.7,
    vehicleType: 'rela',
    fare: 48,
    rating: 4,
    distance: '4.1 km',
    duration: '18 mins',
    plateNumber: 'DEF 9012',
    status: 'completed',
  ),
  _Ride(
    id: '4',
    date: 'March 3, 2026',
    time: '3:20 PM',
    pickup: 'Colon Street',
    dropoff: 'Carbon Market',
    driverName: 'Rosa Mendoza',
    driverRating: 4.9,
    vehicleType: 'bao-bao',
    fare: 35,
    distance: '1.5 km',
    duration: '8 mins',
    plateNumber: 'GHI 3456',
    status: 'cancelled',
  ),
  _Ride(
    id: '5',
    date: 'March 1, 2026',
    time: '11:00 AM',
    pickup: 'Banilad Town Centre',
    dropoff: 'SM Seaside',
    driverName: 'Carlos Tan',
    driverRating: 4.6,
    vehicleType: 'bao-bao',
    fare: 65,
    rating: 4,
    distance: '6.3 km',
    duration: '25 mins',
    plateNumber: 'JKL 7890',
    status: 'completed',
  ),
];

class RideHistoryScreen extends StatefulWidget {
  const RideHistoryScreen({super.key});

  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  _Ride? _selectedRide;

  String _vehicleLabel(String type) {
    if (type == 'habal-habal') return 'Habal-habal';
    if (type == 'rela') return 'Rela';
    if (type == 'bao-bao') return 'Bao-bao';
    return type;
  }

  void _handleRebook(_Ride ride) {
    showToast(context, 'Rebooking ride...');
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) context.go('/drivers');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedRide != null) {
      return _ReceiptView(
        ride: _selectedRide!,
        vehicleLabel: _vehicleLabel(_selectedRide!.vehicleType),
        onBack: () => setState(() => _selectedRide = null),
        onRebook: () => _handleRebook(_selectedRide!),
      );
    }

    final completed = _mockRides.where((r) => r.status == 'completed').toList();
    final totalSpent = completed.fold<int>(0, (sum, r) => sum + r.fare);
    final rated = _mockRides.where((r) => r.rating != null).toList();
    final avgRating = rated.isEmpty
        ? 0.0
        : rated.fold<int>(0, (sum, r) => sum + r.rating!) / rated.length;

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
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ride History',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats
                  Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              value: '${completed.length}',
                              label: 'Completed',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              value: '₱$totalSpent',
                              label: 'Total Spent',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              value: avgRating.toStringAsFixed(1),
                              label: 'Avg Rating',
                            ),
                          ),
                        ],
                      )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 24),

                  const Text(
                    'Recent Rides',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),

                  ...List.generate(_mockRides.length, (index) {
                    final ride = _mockRides[index];
                    return GestureDetector(
                      onTap: () => setState(() => _selectedRide = ride),
                      child:
                          Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.06,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    ride.date,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const Text(
                                                    ' • ',
                                                    style: TextStyle(
                                                      color: AppColors
                                                          .mutedForeground,
                                                    ),
                                                  ),
                                                  Text(
                                                    ride.time,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      color: AppColors
                                                          .mutedForeground,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 6),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Icon(
                                                    Icons.place,
                                                    size: 14,
                                                    color: AppColors.green,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          ride.pickup,
                                                          style: const TextStyle(
                                                            fontSize: 13,
                                                            color: AppColors
                                                                .mutedForeground,
                                                          ),
                                                        ),
                                                        Text(
                                                          'to ${ride.dropoff}',
                                                          style: const TextStyle(
                                                            fontSize: 13,
                                                            color: AppColors
                                                                .mutedForeground,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${_vehicleLabel(ride.vehicleType)} • ${ride.driverName}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      AppColors.mutedForeground,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '₱${ride.fare}',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            _StatusBadge(
                                              completed:
                                                  ride.status == 'completed',
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Divider(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.access_time,
                                              size: 14,
                                              color: AppColors.mutedForeground,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${ride.distance} • ${ride.duration}',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color:
                                                    AppColors.mutedForeground,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.chevron_right,
                                          color: AppColors.primary,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                              .animate()
                              .fadeIn(delay: (index * 100).ms, duration: 400.ms)
                              .slideX(begin: -0.2, end: 0),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Receipt View ──────────────────────────────────────────────────────────────

class _ReceiptView extends StatelessWidget {
  final _Ride ride;
  final String vehicleLabel;
  final VoidCallback onBack;
  final VoidCallback onRebook;

  const _ReceiptView({
    required this.ride,
    required this.vehicleLabel,
    required this.onBack,
    required this.onRebook,
  });

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: onBack,
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
                      'Ride Receipt',
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

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
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
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status
                    Center(
                      child: _StatusBadge(
                        completed: ride.status == 'completed',
                        large: true,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Fare & date
                    Center(
                      child: Column(
                        children: [
                          Text(
                            '₱${ride.fare}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${ride.date} • ${ride.time}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 32),

                    // Route
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: AppColors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 40,
                              color: AppColors.border,
                            ),
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: AppColors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Pickup',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.mutedForeground,
                                    ),
                                  ),
                                  Text(
                                    ride.pickup,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Drop-off',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.mutedForeground,
                                    ),
                                  ),
                                  Text(
                                    ride.dropoff,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // Driver info
                    const Text(
                      'Driver Information',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
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
                              ride.driverName
                                  .split(' ')
                                  .map((n) => n[0])
                                  .join(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
                                ride.driverName,
                                style: const TextStyle(
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
                                  Text(
                                    '${ride.driverRating}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _LabelValue(
                            label: 'Vehicle Type',
                            value: vehicleLabel,
                          ),
                        ),
                        Expanded(
                          child: _LabelValue(
                            label: 'Plate Number',
                            value: ride.plateNumber,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // Trip details
                    const Text(
                      'Trip Details',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _LabelValue(label: 'Distance', value: ride.distance),
                    const SizedBox(height: 8),
                    _LabelValue(label: 'Duration', value: ride.duration),
                    const SizedBox(height: 8),
                    _LabelValue(label: 'Base Fare', value: '₱${ride.fare}'),

                    // Rating
                    if (ride.rating != null) ...[
                      const Divider(height: 32),
                      const Text(
                        'Your Rating',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            Icons.star,
                            size: 24,
                            color: i < ride.rating!
                                ? AppColors.yellow
                                : AppColors.border,
                          );
                        }),
                      ),
                    ],

                    if (ride.status == 'completed') ...[
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: onRebook,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Book Same Route Again',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
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

class _StatusBadge extends StatelessWidget {
  final bool completed;
  final bool large;
  const _StatusBadge({required this.completed, this.large = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 16 : 8,
        vertical: large ? 8 : 4,
      ),
      decoration: BoxDecoration(
        color: completed
            ? AppColors.green.withValues(alpha: 0.1)
            : AppColors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        completed
            ? (large ? '✓ Completed' : 'Completed')
            : (large ? '✕ Cancelled' : 'Cancelled'),
        style: TextStyle(
          fontSize: large ? 14 : 11,
          fontWeight: FontWeight.w600,
          color: completed ? AppColors.green : AppColors.red,
        ),
      ),
    );
  }
}

class _LabelValue extends StatelessWidget {
  final String label;
  final String value;
  const _LabelValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.mutedForeground,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
