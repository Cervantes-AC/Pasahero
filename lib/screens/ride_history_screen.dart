import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../widgets/ph_widgets.dart';
import '../widgets/toast.dart';

class _Ride {
  final String id,
      date,
      time,
      pickup,
      dropoff,
      driverName,
      vehicleType,
      distance,
      duration,
      plateNumber,
      status;
  final double driverRating;
  final int fare;
  final int? rating;
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

const _rides = [
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
    vehicleType: 'motorela',
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
  _Ride? _selected;

  String _label(String t) => t == 'habal-habal'
      ? 'Habal-habal'
      : t == 'motorela'
      ? 'Motorela'
      : 'Bao-bao';

  @override
  Widget build(BuildContext context) {
    if (_selected != null) {
      return _ReceiptView(
        ride: _selected!,
        label: _label(_selected!.vehicleType),
        onBack: () => setState(() => _selected = null),
        onRebook: () {
          showToast(context, 'Rebooking...');
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) context.go('/drivers');
          });
        },
      );
    }

    final completed = _rides.where((r) => r.status == 'completed').toList();
    final totalSpent = completed.fold<int>(0, (s, r) => s + r.fare);
    final rated = _rides.where((r) => r.rating != null).toList();
    final avg = rated.isEmpty
        ? 0.0
        : rated.fold<int>(0, (s, r) => s + r.rating!) / rated.length;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: const Text(
                  'Ride History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                        children: [
                          Expanded(
                            child: PhStatBox(
                              value: '${completed.length}',
                              label: 'Completed',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: PhStatBox(
                              value: '₱$totalSpent',
                              label: 'Total Spent',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: PhStatBox(
                              value: avg.toStringAsFixed(1),
                              label: 'Avg Rating',
                            ),
                          ),
                        ],
                      )
                      .animate()
                      .fadeIn(duration: 350.ms)
                      .slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 20),
                  const Text(
                    'Recent Rides',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._rides.asMap().entries.map((e) {
                    final ride = e.value;
                    final done = ride.status == 'completed';
                    return GestureDetector(
                      onTap: () => setState(() => _selected = ride),
                      child:
                          Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppColors.border),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.03,
                                      ),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: done
                                                ? AppColors.successLight
                                                : AppColors.errorLight,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Icon(
                                            done
                                                ? Icons.check_circle_outline
                                                : Icons.cancel_outlined,
                                            color: done
                                                ? AppColors.success
                                                : AppColors.error,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
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
                                                      fontSize: 13,
                                                      color:
                                                          AppColors.textPrimary,
                                                    ),
                                                  ),
                                                  const Text(
                                                    ' · ',
                                                    style: TextStyle(
                                                      color: AppColors
                                                          .textTertiary,
                                                    ),
                                                  ),
                                                  Text(
                                                    ride.time,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: AppColors
                                                          .textTertiary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${ride.pickup} → ${ride.dropoff}',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                '${_label(ride.vehicleType)} · ${ride.driverName}',
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: AppColors.textTertiary,
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
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            PhBadge(
                                              label: done
                                                  ? 'Completed'
                                                  : 'Cancelled',
                                              color: done
                                                  ? AppColors.success
                                                  : AppColors.error,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    const PhDivider(),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.access_time_outlined,
                                              size: 13,
                                              color: AppColors.textTertiary,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${ride.distance} · ${ride.duration}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: AppColors.textTertiary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.chevron_right,
                                          color: AppColors.textTertiary,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                              .animate()
                              .fadeIn(delay: (e.key * 60).ms, duration: 350.ms)
                              .slideX(begin: -0.05, end: 0),
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

class _ReceiptView extends StatelessWidget {
  final _Ride ride;
  final String label;
  final VoidCallback onBack;
  final VoidCallback onRebook;
  const _ReceiptView({
    required this.ride,
    required this.label,
    required this.onBack,
    required this.onRebook,
  });

  @override
  Widget build(BuildContext context) {
    final done = ride.status == 'completed';
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Row(
                  children: [
                    PhIconButton(
                      icon: Icons.arrow_back,
                      onTap: onBack,
                      color: Colors.white.withValues(alpha: 0.15),
                      iconColor: Colors.white,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Receipt',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
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
              padding: const EdgeInsets.all(16),
              child: PhCard(
                child: Column(
                  children: [
                    PhBadge(
                      label: done ? '✓ Completed' : '✕ Cancelled',
                      color: done ? AppColors.success : AppColors.error,
                      filled: true,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '₱${ride.fare}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${ride.date} · ${ride.time}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const PhDivider(),
                    const SizedBox(height: 16),
                    PhRouteDisplay(pickup: ride.pickup, dropoff: ride.dropoff),
                    const SizedBox(height: 16),
                    const PhDivider(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        PhAvatar(
                          initials: ride.driverName
                              .split(' ')
                              .map((n) => n[0])
                              .join(),
                          size: 44,
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
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    size: 13,
                                    color: AppColors.amber,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    '${ride.driverRating}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
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
                          child: _InfoPair(label: 'Vehicle', value: label),
                        ),
                        Expanded(
                          child: _InfoPair(
                            label: 'Plate',
                            value: ride.plateNumber,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const PhDivider(),
                    const SizedBox(height: 16),
                    _InfoPair(label: 'Distance', value: ride.distance),
                    const SizedBox(height: 6),
                    _InfoPair(label: 'Duration', value: ride.duration),
                    const SizedBox(height: 6),
                    _InfoPair(label: 'Base Fare', value: '₱${ride.fare}'),
                    if (ride.rating != null) ...[
                      const SizedBox(height: 16),
                      const PhDivider(),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Text(
                            'Your Rating',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textTertiary,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                Icons.star_rounded,
                                size: 18,
                                color: i < ride.rating!
                                    ? AppColors.amber
                                    : AppColors.border,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (done) ...[
                      const SizedBox(height: 20),
                      PhButton(label: 'Book Same Route Again', onTap: onRebook),
                    ],
                  ],
                ),
              ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.1, end: 0),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPair extends StatelessWidget {
  final String label;
  final String value;
  const _InfoPair({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textTertiary),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
