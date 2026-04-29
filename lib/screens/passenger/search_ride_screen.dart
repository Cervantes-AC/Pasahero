import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/ph_widgets.dart';

class SearchRideScreen extends StatefulWidget {
  final String rideType;
  const SearchRideScreen({super.key, required this.rideType});

  @override
  State<SearchRideScreen> createState() => _SearchRideScreenState();
}

class _SearchRideScreenState extends State<SearchRideScreen>
    with TickerProviderStateMixin {
  final _pickupCtrl = TextEditingController(text: 'Valencia City, Philippines');
  final _destCtrl = TextEditingController();
  late AnimationController _mapController;
  late AnimationController _pulseController;

  // Map pan and zoom state
  Offset _mapOffset = Offset.zero;
  double _mapZoom = 1.0;
  final double _minZoom = 0.5;
  final double _maxZoom = 3.0;

  // Enhanced features
  bool _showEstimate = false;
  double _estimatedFare = 0.0;
  String _estimatedTime = '';

  @override
  void initState() {
    super.initState();
    _mapController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pickupCtrl.dispose();
    _destCtrl.dispose();
    _mapController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _zoomIn() {
    setState(() {
      _mapZoom = (_mapZoom + 0.2).clamp(_minZoom, _maxZoom);
    });
  }

  void _zoomOut() {
    setState(() {
      _mapZoom = (_mapZoom - 0.2).clamp(_minZoom, _maxZoom);
    });
  }

  void _resetMap() {
    setState(() {
      _mapOffset = Offset.zero;
      _mapZoom = 1.0;
    });
  }

  void _search() {
    if (_destCtrl.text.isNotEmpty) {
      context.go(
        '/drivers?type=${widget.rideType}&from=${_pickupCtrl.text}&to=${_destCtrl.text}',
      );
    }
  }

  void _calculateFare() {
    if (_destCtrl.text.isEmpty) return;

    // Simulate fare calculation
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      // Mock fare calculation based on destination length
      final distance = (_destCtrl.text.length * 0.5).clamp(1.0, 50.0);
      final baseFare = widget.rideType == 'habal-habal' ? 40.0 : 60.0;
      final distanceFare =
          distance * (widget.rideType == 'habal-habal' ? 8.0 : 12.0);
      final totalFare = baseFare + distanceFare;

      final minutes = (distance * 2).toInt().clamp(3, 45);

      setState(() {
        _estimatedFare = totalFare;
        _estimatedTime = '$minutes min';
        _showEstimate = true;
      });
    });
  }

  String get _rideLabel {
    switch (widget.rideType) {
      case 'habal-habal':
        return 'Habal-habal';
      case 'bao-bao':
        return 'Bao-bao';
      default:
        return widget.rideType;
    }
  }

  IconData get _rideIcon {
    switch (widget.rideType) {
      case 'habal-habal':
        return Icons.two_wheeler;
      case 'bao-bao':
        return Icons.directions_car_outlined;
      default:
        return Icons.two_wheeler;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hp = Responsive.hPad(context);
    final mapHeight = Responsive.isWide(context) ? 320.0 : 240.0;

    return Scaffold(
      backgroundColor: AppColors.surface,
      // KEY FIX: Use a Stack at the Scaffold body level so the map never
      // overlaps the scrollable form. The Column below is NOT scrollable —
      // only the CustomScrollView inside it is. The map is a fixed-size,
      // non-scrollable widget that sits above the list.
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primaryDark,
                  AppColors.primary.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: SafeArea(
              bottom: false, // only safe-area the top
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  hp,
                  Responsive.spacing(context, units: 2),
                  hp,
                  Responsive.spacing(context, units: 2.5),
                ),
                child: Row(
                  children: [
                    PhIconButton(
                      icon: Icons.arrow_back,
                      onTap: () => context.go('/home'),
                      color: Colors.white.withValues(alpha: 0.15),
                      iconColor: Colors.white,
                    ),
                    SizedBox(width: Responsive.spacing(context, units: 1.75)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.spacing(context, units: 1.5),
                        vertical: Responsive.spacing(context, units: 0.75),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _rideIcon,
                            color: Colors.white,
                            size: Responsive.iconSize(context, base: 16),
                          ),
                          SizedBox(
                            width: Responsive.spacing(context, units: 0.75),
                          ),
                          Text(
                            _rideLabel,
                            style: TextStyle(
                              fontSize: Responsive.fontSize(context, 14),
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.spacing(context, units: 1),
                        vertical: Responsive.spacing(context, units: 0.5),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: Responsive.iconSize(context, base: 6),
                            height: Responsive.iconSize(context, base: 6),
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(
                            width: Responsive.spacing(context, units: 0.5),
                          ),
                          Text(
                            '12 online',
                            style: TextStyle(
                              fontSize: Responsive.fontSize(context, 11),
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Map (fixed height, NOT part of the scroll) ──────────────────
          // ClipRect ensures the map's panned/zoomed content never bleeds
          // outside this bounded box.
          ClipRect(
            child: SizedBox(
              height: mapHeight,
              child: GestureDetector(
                // absorb touches so the scroll view underneath doesn't react
                // to drags inside the map area
                behavior: HitTestBehavior.opaque,
                onPanUpdate: (details) {
                  setState(() {
                    _mapOffset += details.delta;
                  });
                },
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    // Map background
                    Positioned.fill(
                      child: Transform.translate(
                        offset: _mapOffset,
                        child: Transform.scale(
                          scale: _mapZoom,
                          alignment: Alignment.center,
                          child: Container(
                            color: const Color(0xFFE8F0F8),
                            child: CustomPaint(
                              painter: _MapGridPainter(),
                              size: Size.infinite,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // User location marker (stays centered in the view,
                    // but moves with the map offset so it feels anchored)
                    Center(
                      child: Transform.translate(
                        offset: _mapOffset,
                        child: Transform.scale(
                          scale: _mapZoom,
                          alignment: Alignment.center,
                          child:
                              Container(
                                    width: Responsive.iconSize(
                                      context,
                                      base: 48,
                                    ),
                                    height: Responsive.iconSize(
                                      context,
                                      base: 48,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 12,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.navigation,
                                      color: Colors.white,
                                      size: Responsive.iconSize(
                                        context,
                                        base: 24,
                                      ),
                                    ),
                                  )
                                  .animate(onPlay: (c) => c.repeat())
                                  .scale(
                                    begin: const Offset(1, 1),
                                    end: const Offset(1.1, 1.1),
                                    duration: 1000.ms,
                                  )
                                  .then()
                                  .scale(
                                    begin: const Offset(1.1, 1.1),
                                    end: const Offset(1, 1),
                                    duration: 1000.ms,
                                  ),
                        ),
                      ),
                    ),

                    // Zoom / reset buttons
                    Positioned(
                      right: Responsive.spacing(context, units: 2),
                      top: Responsive.spacing(context, units: 2),
                      child: Column(
                        children: [
                          _MapBtn(label: '+', onTap: _zoomIn),
                          SizedBox(
                            height: Responsive.spacing(context, units: 1),
                          ),
                          _MapBtn(label: '−', onTap: _zoomOut),
                          SizedBox(
                            height: Responsive.spacing(context, units: 1),
                          ),
                          _MapBtn(
                            label: '⊙',
                            onTap: _resetMap,
                            tooltip: 'Reset map',
                          ),
                        ],
                      ),
                    ),

                    // Pan hint overlay
                    if (_mapZoom == 1.0 && _mapOffset == Offset.zero)
                      Positioned(
                        bottom: Responsive.spacing(context, units: 2),
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Responsive.spacing(
                                context,
                                units: 1.5,
                              ),
                              vertical: Responsive.spacing(
                                context,
                                units: 0.75,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Drag to pan • Zoom to explore',
                              style: TextStyle(
                                fontSize: Responsive.fontSize(context, 11),
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // ── Scrollable form content ──────────────────────────────────────
          // Expanded + SingleChildScrollView means this section fills the
          // remaining screen height and scrolls independently of the map.
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(hp),
              // Add bottom padding so content isn't hidden behind system nav
              child: Padding(
                padding: EdgeInsets.only(
                  bottom:
                      MediaQuery.of(context).viewInsets.bottom +
                      Responsive.spacing(context, units: 2),
                ),
                child: ResponsiveContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Location card ──────────────────────────────────
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            Responsive.radius(context, base: 16),
                          ),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(
                          Responsive.spacing(context, units: 2),
                        ),
                        child: Column(
                          children: [
                            _LocationField(
                              controller: _pickupCtrl,
                              icon: Icons.place,
                              iconColor: AppColors.primary,
                              hint: 'Pickup location',
                              label: 'Pickup',
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: Responsive.spacing(
                                  context,
                                  units: 1.25,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Expanded(child: Divider()),
                                  Container(
                                    width: Responsive.iconSize(
                                      context,
                                      base: 28,
                                    ),
                                    height: Responsive.iconSize(
                                      context,
                                      base: 28,
                                    ),
                                    margin: EdgeInsets.symmetric(
                                      horizontal: Responsive.spacing(
                                        context,
                                        units: 1.25,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.amber,
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: CircleAvatar(
                                        radius: Responsive.iconSize(
                                          context,
                                          base: 4,
                                        ),
                                        backgroundColor: AppColors.amber,
                                      ),
                                    ),
                                  ),
                                  const Expanded(child: Divider()),
                                ],
                              ),
                            ),
                            _LocationField(
                              controller: _destCtrl,
                              icon: Icons.search,
                              iconColor: AppColors.textTertiary,
                              hint: 'Where do you want to go?',
                              label: 'Drop-off',
                              onChanged: (_) {
                                setState(() {});
                                if (_destCtrl.text.isNotEmpty) {
                                  _calculateFare();
                                } else {
                                  setState(() => _showEstimate = false);
                                }
                              },
                            ),
                            SizedBox(
                              height: Responsive.spacing(context, units: 1.75),
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: Responsive.buttonHeight(context),
                              child: ElevatedButton(
                                onPressed: _destCtrl.text.isNotEmpty
                                    ? _search
                                    : null,
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
                                  'Search Drivers',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Responsive.fontSize(context, 16),
                                  ),
                                ),
                              ),
                            ),

                            // Fare Estimate Card
                            if (_showEstimate)
                              Padding(
                                padding: EdgeInsets.only(
                                  top: Responsive.spacing(context, units: 1.5),
                                ),
                                child:
                                    Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.primarySurface,
                                            borderRadius: BorderRadius.circular(
                                              Responsive.radius(
                                                context,
                                                base: 12,
                                              ),
                                            ),
                                            border: Border.all(
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.3),
                                            ),
                                          ),
                                          padding: EdgeInsets.all(
                                            Responsive.spacing(
                                              context,
                                              units: 1.5,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Estimated Fare',
                                                    style: TextStyle(
                                                      fontSize:
                                                          Responsive.fontSize(
                                                            context,
                                                            11,
                                                          ),
                                                      color: AppColors
                                                          .textTertiary,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: Responsive.spacing(
                                                      context,
                                                      units: 0.5,
                                                    ),
                                                  ),
                                                  Text(
                                                    '₱${_estimatedFare.toStringAsFixed(0)}',
                                                    style: TextStyle(
                                                      fontSize:
                                                          Responsive.fontSize(
                                                            context,
                                                            18,
                                                          ),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: AppColors.primary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                width: 1,
                                                height: Responsive.spacing(
                                                  context,
                                                  units: 3,
                                                ),
                                                color: AppColors.border,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Estimated Time',
                                                    style: TextStyle(
                                                      fontSize:
                                                          Responsive.fontSize(
                                                            context,
                                                            11,
                                                          ),
                                                      color: AppColors
                                                          .textTertiary,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: Responsive.spacing(
                                                      context,
                                                      units: 0.5,
                                                    ),
                                                  ),
                                                  Text(
                                                    _estimatedTime,
                                                    style: TextStyle(
                                                      fontSize:
                                                          Responsive.fontSize(
                                                            context,
                                                            18,
                                                          ),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: AppColors.primary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                        .animate()
                                        .fadeIn(duration: 300.ms)
                                        .slideY(begin: -0.1, end: 0),
                              ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.2, end: 0),

                      SizedBox(height: Responsive.spacing(context, units: 2.5)),

                      // ── Quick Suggestions ──────────────────────────────
                      Text(
                        'Popular Destinations',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 13),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      SizedBox(
                        height: Responsive.spacing(context, units: 1.25),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _QuickDestination(
                              icon: Icons.shopping_bag_outlined,
                              label: 'Shopping',
                              destination: 'Robinsons Place',
                              onTap: () => setState(
                                () => _destCtrl.text = 'Robinsons Place',
                              ),
                            ),
                            SizedBox(
                              width: Responsive.spacing(context, units: 1),
                            ),
                            _QuickDestination(
                              icon: Icons.restaurant_outlined,
                              label: 'Dining',
                              destination: 'Paseo de Santa Rosa',
                              onTap: () => setState(
                                () => _destCtrl.text = 'Paseo de Santa Rosa',
                              ),
                            ),
                            SizedBox(
                              width: Responsive.spacing(context, units: 1),
                            ),
                            _QuickDestination(
                              icon: Icons.local_hospital_outlined,
                              label: 'Hospital',
                              destination: 'Medical Center',
                              onTap: () => setState(
                                () => _destCtrl.text =
                                    'Medical Center, Valencia City',
                              ),
                            ),
                            SizedBox(
                              width: Responsive.spacing(context, units: 1),
                            ),
                            _QuickDestination(
                              icon: Icons.school_outlined,
                              label: 'School',
                              destination: 'University',
                              onTap: () => setState(
                                () => _destCtrl.text =
                                    'University, Valencia City',
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: Responsive.spacing(context, units: 2.5)),

                      // ── Saved Locations ────────────────────────────────
                      Text(
                        'Saved Locations',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 13),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      SizedBox(
                        height: Responsive.spacing(context, units: 1.25),
                      ),
                      Row(
                        children: [
                          _SavedChip(
                            icon: Icons.home_outlined,
                            label: 'Home',
                            color: AppColors.primary,
                            onTap: () => setState(
                              () => _destCtrl.text =
                                  '123 Mabolo St, Valencia City',
                            ),
                          ),
                          SizedBox(
                            width: Responsive.spacing(context, units: 1.25),
                          ),
                          _SavedChip(
                            icon: Icons.work_outline,
                            label: 'Work',
                            color: AppColors.error,
                            onTap: () => setState(
                              () => _destCtrl.text =
                                  'Robinsons Place, Valencia City',
                            ),
                          ),
                          SizedBox(
                            width: Responsive.spacing(context, units: 1.25),
                          ),
                          _SavedChip(
                            icon: Icons.star_outline,
                            label: 'Favorite',
                            color: AppColors.amber,
                            onTap: () => setState(
                              () => _destCtrl.text =
                                  'Paseo de Santa Rosa, Valencia City',
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: Responsive.spacing(context, units: 2.5)),

                      // ── Recent Destinations ────────────────────────────
                      Text(
                        'Recent Destinations',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 13),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      SizedBox(
                        height: Responsive.spacing(context, units: 1.25),
                      ),
                      ...[
                        'Robinsons Place',
                        'Paseo de Santa Rosa',
                        'Puregold',
                      ].map(
                        (place) => Padding(
                          padding: EdgeInsets.only(
                            bottom: Responsive.spacing(context, units: 1),
                          ),
                          child: GestureDetector(
                            onTap: () => setState(() => _destCtrl.text = place),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Responsive.spacing(
                                  context,
                                  units: 1.75,
                                ),
                                vertical: Responsive.spacing(
                                  context,
                                  units: 1.625,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  Responsive.radius(context, base: 12),
                                ),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.history,
                                    color: AppColors.textTertiary,
                                    size: Responsive.iconSize(
                                      context,
                                      base: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.spacing(
                                      context,
                                      units: 1.5,
                                    ),
                                  ),
                                  Text(
                                    place,
                                    style: TextStyle(
                                      fontSize: Responsive.fontSize(
                                        context,
                                        14,
                                      ),
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Supporting widgets (unchanged) ──────────────────────────────────────────

class _LocationField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final Color iconColor;
  final String hint, label;
  final ValueChanged<String>? onChanged;

  const _LocationField({
    required this.controller,
    required this.icon,
    required this.iconColor,
    required this.hint,
    required this.label,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Responsive.fontSize(context, 11),
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: Responsive.spacing(context, units: 0.75)),
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: iconColor,
              size: Responsive.iconSize(context, base: 18),
            ),
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.textTertiary,
              fontSize: Responsive.fontSize(context, 14),
            ),
            filled: true,
            fillColor: AppColors.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                Responsive.radius(context, base: 10),
              ),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                Responsive.radius(context, base: 10),
              ),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                Responsive.radius(context, base: 10),
              ),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: Responsive.spacing(context, units: 1.5),
              vertical: Responsive.spacing(context, units: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _SavedChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SavedChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: Responsive.spacing(context, units: 1.75),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              Responsive.radius(context, base: 12),
            ),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Container(
                width: Responsive.iconSize(context, base: 40),
                height: Responsive.iconSize(context, base: 40),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: Responsive.iconSize(context, base: 18),
                ),
              ),
              SizedBox(height: Responsive.spacing(context, units: 0.75)),
              Text(
                label,
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, 11),
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapBtn extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final String? tooltip;

  const _MapBtn({required this.label, this.onTap, this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: Responsive.iconSize(context, base: 40),
          height: Responsive.iconSize(context, base: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              Responsive.radius(context, base: 10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: AppColors.border),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: Responsive.fontSize(context, 18),
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()..color = Colors.white.withValues(alpha: 0.85);
    final minor = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.35, size.width, 6), road);
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.68, size.width, 8), road);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.42, 0, 6, size.height), road);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.72, 0, 8, size.height), road);
    canvas.drawLine(
      Offset(0, size.height * 0.18),
      Offset(size.width, size.height * 0.18),
      minor,
    );
    canvas.drawLine(
      Offset(size.width * 0.22, 0),
      Offset(size.width * 0.22, size.height),
      minor,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Quick Destination Widget ───────────────────────────────────────────────

class _QuickDestination extends StatelessWidget {
  final IconData icon;
  final String label;
  final String destination;
  final VoidCallback onTap;

  const _QuickDestination({
    required this.icon,
    required this.label,
    required this.destination,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Responsive.spacing(context, units: 11),
        padding: EdgeInsets.all(Responsive.spacing(context, units: 1.25)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            Responsive.radius(context, base: 12),
          ),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: Responsive.iconSize(context, base: 36),
              height: Responsive.iconSize(context, base: 36),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(
                  Responsive.radius(context, base: 8),
                ),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: Responsive.iconSize(context, base: 18),
              ),
            ),
            SizedBox(height: Responsive.spacing(context, units: 0.75)),
            Text(
              label,
              style: TextStyle(
                fontSize: Responsive.fontSize(context, 11),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Responsive.spacing(context, units: 0.5)),
            Text(
              destination,
              style: TextStyle(
                fontSize: Responsive.fontSize(context, 9),
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
