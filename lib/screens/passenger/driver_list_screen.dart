import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../data/mock_drivers.dart';
import '../../widgets/toast.dart';
import '../../widgets/ph_widgets.dart';
import '../../utils/responsive.dart';

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
            margin: EdgeInsets.symmetric(
              horizontal: Responsive.spacing(context, units: 3),
              vertical: Responsive.spacing(context, units: 1),
            ),
            padding: EdgeInsets.all(Responsive.spacing(context, units: 0.5)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                Responsive.radius(context, base: 16),
              ),
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
                borderRadius: BorderRadius.circular(
                  Responsive.radius(context, base: 12),
                ),
              ),
              dividerColor: Colors.transparent,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map_rounded,
                        size: Responsive.iconSize(context, base: 18),
                      ),
                      SizedBox(width: Responsive.spacing(context, units: 1)),
                      const Text('Map'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.list_rounded,
                        size: Responsive.iconSize(context, base: 18),
                      ),
                      SizedBox(width: Responsive.spacing(context, units: 1)),
                      const Text('List'),
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
          left:
              MediaQuery.of(context).size.width * 0.30 -
              Responsive.iconSize(context, base: 20),
          top:
              MediaQuery.of(context).size.height * 0.35 -
              Responsive.iconSize(context, base: 20),
          child: Container(
            width: Responsive.iconSize(context, base: 40),
            height: Responsive.iconSize(context, base: 40),
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
            child: Center(
              child: CircleAvatar(
                radius: Responsive.iconSize(context, base: 4),
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
            left:
                MediaQuery.of(context).size.width * pos.dx -
                Responsive.iconSize(context, base: 20),
            top:
                (MediaQuery.of(context).size.height -
                        (selected != null
                            ? Responsive.buttonHeight(context) * 3.5
                            : 0)) *
                    pos.dy -
                Responsive.iconSize(context, base: 20),
            child: GestureDetector(
              onTap: () => onSelectDriver(driver.id),
              child: Container(
                width: Responsive.iconSize(context, base: 40),
                height: Responsive.iconSize(context, base: 40),
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
                  size: Responsive.iconSize(context, base: 22),
                  color: isSelected ? Colors.white : AppColors.primary,
                ),
              ),
            ).animate().scale(delay: (i * 100).ms, duration: 300.ms),
          );
        }),

        // Navigation button
        Positioned(
          right: Responsive.spacing(context, units: 2),
          bottom: selected != null
              ? Responsive.buttonHeight(context) * 3.5
              : Responsive.spacing(context, units: 2),
          child: Container(
            width: Responsive.iconSize(context, base: 48),
            height: Responsive.iconSize(context, base: 48),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                Responsive.radius(context, base: 12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
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
        ),

        // Driver info card
        if (selected != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    Responsive.radius(context, base: 24),
                  ),
                  topRight: Radius.circular(
                    Responsive.radius(context, base: 24),
                  ),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              padding: EdgeInsets.all(Responsive.spacing(context, units: 3)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: Responsive.iconSize(context, base: 64),
                        height: Responsive.iconSize(context, base: 64),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(
                            Responsive.radius(context, base: 16),
                          ),
                        ),
                        child: Icon(
                          vehicleIcon,
                          size: Responsive.iconSize(context, base: 32),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: Responsive.spacing(context, units: 2)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selected.name,
                              style: TextStyle(
                                fontSize: Responsive.fontSize(context, 16),
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
                                  width: Responsive.spacing(
                                    context,
                                    units: 0.5,
                                  ),
                                ),
                                Text(
                                  '${selected.rating}',
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
                                  '${selected.totalRides} rides',
                                  style: TextStyle(
                                    fontSize: Responsive.fontSize(context, 13),
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              selected.plateNumber,
                              style: TextStyle(
                                fontSize: Responsive.fontSize(context, 13),
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
                            '₱${selected.fare}',
                            style: TextStyle(
                              fontSize: Responsive.fontSize(context, 24),
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            'Estimated fare',
                            style: TextStyle(
                              fontSize: Responsive.fontSize(context, 11),
                              color: AppColors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: Responsive.spacing(context, units: 1.5)),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.spacing(context, units: 2),
                      vertical: Responsive.spacing(context, units: 1.25),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.muted,
                      borderRadius: BorderRadius.circular(
                        Responsive.radius(context, base: 12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: Responsive.iconSize(context, base: 16),
                          color: AppColors.mutedForeground,
                        ),
                        SizedBox(width: Responsive.spacing(context, units: 1)),
                        Text(
                          '${selected.eta} away',
                          style: TextStyle(
                            fontSize: Responsive.fontSize(context, 13),
                          ),
                        ),
                        SizedBox(width: Responsive.spacing(context, units: 2)),
                        Icon(
                          Icons.navigation,
                          size: Responsive.iconSize(context, base: 16),
                          color: AppColors.mutedForeground,
                        ),
                        SizedBox(width: Responsive.spacing(context, units: 1)),
                        Text(
                          selected.distance,
                          style: TextStyle(
                            fontSize: Responsive.fontSize(context, 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Responsive.spacing(context, units: 1.5)),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: Responsive.buttonHeight(context),
                          child: ElevatedButton(
                            onPressed: () =>
                                context.go('/driver-detail?id=${selected.id}'),
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
                              'View Full Profile',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: Responsive.fontSize(context, 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: Responsive.spacing(context, units: 1)),
                      Expanded(
                        child: SizedBox(
                          height: Responsive.buttonHeight(context),
                          child: ElevatedButton(
                            onPressed: () => onOrderRide(selected),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.red,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  Responsive.radius(context, base: 12),
                                ),
                              ),
                            ),
                            child: Text(
                              'Order Ride',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: Responsive.fontSize(context, 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
      padding: EdgeInsets.all(Responsive.spacing(context, units: 3)),
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
                    margin: EdgeInsets.only(
                      bottom: Responsive.spacing(context, units: 2),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        Responsive.radius(context, base: 20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(
                      Responsive.spacing(context, units: 2),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: Responsive.iconSize(context, base: 64),
                              height: Responsive.iconSize(context, base: 64),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(
                                  Responsive.radius(context, base: 16),
                                ),
                              ),
                              child: Icon(
                                vehicleIcon,
                                size: Responsive.iconSize(context, base: 32),
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
                                    driver.name,
                                    style: TextStyle(
                                      fontSize: Responsive.fontSize(
                                        context,
                                        15,
                                      ),
                                      fontWeight: FontWeight.w600,
                                    ),
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
                                        '${driver.rating}',
                                        style: TextStyle(
                                          fontSize: Responsive.fontSize(
                                            context,
                                            13,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        ' • ',
                                        style: TextStyle(
                                          color: AppColors.mutedForeground,
                                          fontSize: Responsive.fontSize(
                                            context,
                                            13,
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
                                  Text(
                                    driver.plateNumber,
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
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '₱${driver.fare}',
                                  style: TextStyle(
                                    fontSize: Responsive.fontSize(context, 20),
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Text(
                                  'Estimated',
                                  style: TextStyle(
                                    fontSize: Responsive.fontSize(context, 11),
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (totalSeats > 0) ...[
                          SizedBox(
                            height: Responsive.spacing(context, units: 1.25),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Responsive.spacing(
                                context,
                                units: 1.5,
                              ),
                              vertical: Responsive.spacing(context, units: 1),
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.muted.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(
                                Responsive.radius(context, base: 8),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '$availableSeats seat${availableSeats != 1 ? 's' : ''} available',
                                  style: TextStyle(
                                    fontSize: Responsive.fontSize(context, 13),
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.green,
                                  ),
                                ),
                                Text(
                                  ' • $occupiedSeats/$totalSeats occupied',
                                  style: TextStyle(
                                    fontSize: Responsive.fontSize(context, 13),
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        SizedBox(
                          height: Responsive.spacing(context, units: 1.25),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: Responsive.iconSize(context, base: 14),
                              color: AppColors.mutedForeground,
                            ),
                            SizedBox(
                              width: Responsive.spacing(context, units: 0.5),
                            ),
                            Text(
                              driver.eta,
                              style: TextStyle(
                                fontSize: Responsive.fontSize(context, 13),
                                color: AppColors.mutedForeground,
                              ),
                            ),
                            SizedBox(
                              width: Responsive.spacing(context, units: 2),
                            ),
                            Icon(
                              Icons.navigation,
                              size: Responsive.iconSize(context, base: 14),
                              color: AppColors.mutedForeground,
                            ),
                            SizedBox(
                              width: Responsive.spacing(context, units: 0.5),
                            ),
                            Text(
                              driver.distance,
                              style: TextStyle(
                                fontSize: Responsive.fontSize(context, 13),
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Responsive.spacing(context, units: 1.5),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: Responsive.buttonHeight(context) * 0.75,
                          child: ElevatedButton(
                            onPressed: () => onOrderRide(driver),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.red,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  Responsive.radius(context, base: 12),
                                ),
                              ),
                            ),
                            child: Text(
                              'Order Ride',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: Responsive.fontSize(context, 14),
                              ),
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
