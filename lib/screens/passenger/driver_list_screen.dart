import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../data/mock_drivers.dart';
import '../../widgets/toast.dart';
import '../../widgets/ph_widgets.dart';

class DriverListScreen extends StatefulWidget {
  final String rideType;
  const DriverListScreen({super.key, required this.rideType});

  @override
  State<DriverListScreen> createState() => _DriverListScreenState();
}

class _DriverListScreenState extends State<DriverListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedDriverId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  IconData get _vehicleIcon =>
      widget.rideType == 'bao-bao' ? Icons.directions_car : Icons.two_wheeler;

  void _handleOrderRide(Driver driver) {
    setState(() => _selectedDriverId = driver.id);
    showToast(context, 'Requesting ride from ${driver.name}...');
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) context.go('/tracking');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          PhAppBar(
            title: 'Available Drivers',
            subtitle: '${mockDrivers.length} drivers nearby',
            showBack: true,
            onBack: () => context.go('/search'),
          ),

          // Tab bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.5),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map_rounded, size: 18),
                      SizedBox(width: 8),
                      Text('Map'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.list_rounded, size: 18),
                      SizedBox(width: 8),
                      Text('List'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _MapView(
                  rideType: widget.rideType,
                  vehicleIcon: _vehicleIcon,
                  selectedDriverId: _selectedDriverId,
                  onSelectDriver: (id) =>
                      setState(() => _selectedDriverId = id),
                  onOrderRide: _handleOrderRide,
                ),
                _ListView(
                  rideType: widget.rideType,
                  vehicleIcon: _vehicleIcon,
                  onOrderRide: _handleOrderRide,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// â”€â”€ Map View â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _MapView extends StatelessWidget {
  final String rideType;
  final IconData vehicleIcon;
  final String? selectedDriverId;
  final ValueChanged<String> onSelectDriver;
  final ValueChanged<Driver> onOrderRide;

  const _MapView({
    required this.rideType,
    required this.vehicleIcon,
    required this.selectedDriverId,
    required this.onSelectDriver,
    required this.onOrderRide,
  });

  @override
  Widget build(BuildContext context) {
    final positions = [
      const Offset(0.40, 0.15),
      const Offset(0.65, 0.30),
      const Offset(0.20, 0.40),
      const Offset(0.55, 0.60),
    ];

    final selected = selectedDriverId != null
        ? mockDrivers.firstWhere(
            (d) => d.id == selectedDriverId,
            orElse: () => mockDrivers.first,
          )
        : null;

    return Stack(
      children: [
        // Map background
        Container(
          color: const Color(0xFFD4CFE8),
          child: CustomPaint(painter: _MapPainter(), size: Size.infinite),
        ),

        // Current location
        Positioned(
          left: MediaQuery.of(context).size.width * 0.30 - 20,
          top: MediaQuery.of(context).size.height * 0.35 - 20,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Center(
              child: CircleAvatar(
                radius: 4,
                backgroundColor: AppColors.primary,
              ),
            ),
          ),
        ),

        // Driver markers
        ...mockDrivers.asMap().entries.map((entry) {
          final i = entry.key;
          final driver = entry.value;
          final pos = positions[i];
          final isSelected = selectedDriverId == driver.id;
          return Positioned(
            left: MediaQuery.of(context).size.width * pos.dx - 20,
            top:
                (MediaQuery.of(context).size.height -
                        (selected != null ? 280 : 0)) *
                    pos.dy -
                20,
            child: GestureDetector(
              onTap: () => onSelectDriver(driver.id),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.red : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(
                  vehicleIcon,
                  size: 22,
                  color: isSelected ? Colors.white : AppColors.primary,
                ),
              ),
            ).animate().scale(delay: (i * 100).ms, duration: 300.ms),
          );
        }),

        // Navigation button
        Positioned(
          right: 16,
          bottom: selected != null ? 296 : 16,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(Icons.navigation, color: AppColors.primary),
          ),
        ),

        // Driver info card
        if (selected != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
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
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(vehicleIcon, size: 32, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selected.name,
                              style: const TextStyle(
                                fontSize: 16,
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
                                  '${selected.rating}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const Text(
                                  ' â€¢ ',
                                  style: TextStyle(
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                                Text(
                                  '${selected.totalRides} rides',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              selected.plateNumber,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'â‚±${selected.fare}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const Text(
                            'Estimated fare',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.muted,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 16,
                          color: AppColors.mutedForeground,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${selected.eta} away',
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.navigation,
                          size: 16,
                          color: AppColors.mutedForeground,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          selected.distance,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => onOrderRide(selected),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Order Ride',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().slideY(begin: 1, end: 0, duration: 300.ms),
          ),
      ],
    );
  }
}

// â”€â”€ List View â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ListView extends StatelessWidget {
  final String rideType;
  final IconData vehicleIcon;
  final ValueChanged<Driver> onOrderRide;

  const _ListView({
    required this.rideType,
    required this.vehicleIcon,
    required this.onOrderRide,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: mockDrivers.length,
      itemBuilder: (context, index) {
        final driver = mockDrivers[index];
        final totalSeats = rideType == 'bao-bao'
            ? 5
            : (rideType == 'rela' ? 4 : 0);
        final occupiedSeats = totalSeats > 0
            ? (int.parse(driver.id) % (totalSeats - 1) + 1)
            : 0;
        final availableSeats = totalSeats > 0 ? totalSeats - occupiedSeats : 0;

        return GestureDetector(
          onTap: () => context.go('/driver-detail?id=${driver.id}'),
          child:
              Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                vehicleIcon,
                                size: 32,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    driver.name,
                                    style: const TextStyle(
                                      fontSize: 15,
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
                                        '${driver.rating}',
                                        style: const TextStyle(fontSize: 13),
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
                                  Text(
                                    driver.plateNumber,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.mutedForeground,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'â‚±${driver.fare}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const Text(
                                  'Estimated',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (totalSeats > 0) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.muted.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '$availableSeats seat${availableSeats != 1 ? 's' : ''} available',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.green,
                                  ),
                                ),
                                Text(
                                  ' â€¢ $occupiedSeats/$totalSeats occupied',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 14,
                              color: AppColors.mutedForeground,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              driver.eta,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Icon(
                              Icons.navigation,
                              size: 14,
                              color: AppColors.mutedForeground,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              driver.distance,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () => onOrderRide(driver),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.red,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Order Ride',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(delay: (index * 100).ms, duration: 400.ms)
                  .slideX(begin: -0.2, end: 0),
        );
      },
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()..color = Colors.white.withValues(alpha: 0.8);
    final smallRoadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..strokeWidth = 3;

    // Horizontal roads
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.3, size.width, 8),
      roadPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.7, size.width, 12),
      roadPaint,
    );
    // Vertical roads
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.4, 0, 8, size.height),
      roadPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.75, 0, 10, size.height),
      roadPaint,
    );
    // Small streets
    canvas.drawLine(
      Offset(0, size.height * 0.15),
      Offset(size.width, size.height * 0.15),
      smallRoadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.2, 0),
      Offset(size.width * 0.2, size.height),
      smallRoadPaint,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
