import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/ph_widgets.dart';

class SearchRideScreen extends StatefulWidget {
  final String rideType;
  const SearchRideScreen({super.key, required this.rideType});

  @override
  State<SearchRideScreen> createState() => _SearchRideScreenState();
}

class _SearchRideScreenState extends State<SearchRideScreen> {
  final _pickupCtrl = TextEditingController(text: 'Cebu City, Philippines');
  final _destCtrl = TextEditingController();

  @override
  void dispose() {
    _pickupCtrl.dispose();
    _destCtrl.dispose();
    super.dispose();
  }

  void _search() {
    if (_destCtrl.text.isNotEmpty) {
      context.go(
        '/drivers?type=${widget.rideType}&from=${_pickupCtrl.text}&to=${_destCtrl.text}',
      );
    }
  }

  String get _rideLabel {
    switch (widget.rideType) {
      case 'habal-habal':
        return 'Habal-habal';
      case 'motorela':
        return 'Motorela';
      case 'bao-bao':
        return 'Bao-bao';
      default:
        return widget.rideType;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hp = Responsive.hPad(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
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
                padding: EdgeInsets.fromLTRB(hp, 16, hp, 20),
                child: Row(
                  children: [
                    PhIconButton(
                      icon: Icons.arrow_back,
                      onTap: () => context.go('/home'),
                      color: Colors.white.withValues(alpha: 0.15),
                      iconColor: Colors.white,
                    ),
                    const SizedBox(width: 14),
                    Text(
                      _rideLabel,
                      style: const TextStyle(
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

          // Map placeholder
          SizedBox(
            height: Responsive.isWide(context) ? 320 : 240,
            child: Stack(
              children: [
                Container(
                  color: const Color(0xFFE8F0F8),
                  child: CustomPaint(
                    painter: _MapGridPainter(),
                    size: Size.infinite,
                  ),
                ),
                Center(
                  child:
                      Container(
                            width: 48,
                            height: 48,
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
                            child: const Icon(
                              Icons.navigation,
                              color: Colors.white,
                              size: 24,
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
                Positioned(
                  right: 16,
                  top: 16,
                  child: Column(
                    children: [
                      _MapBtn(label: '+'),
                      const SizedBox(height: 8),
                      _MapBtn(label: 'âˆ’'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(hp),
              child: ResponsiveContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Row(
                                  children: [
                                    const Expanded(child: Divider()),
                                    Container(
                                      width: 28,
                                      height: 28,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.amber,
                                          width: 2,
                                        ),
                                      ),
                                      child: const Center(
                                        child: CircleAvatar(
                                          radius: 4,
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
                                onChanged: (_) => setState(() {}),
                              ),
                              const SizedBox(height: 14),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _destCtrl.text.isNotEmpty
                                      ? _search
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Search Drivers',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 350.ms)
                        .slideY(begin: 0.2, end: 0),

                    const SizedBox(height: 20),

                    const Text(
                      'Saved Locations',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _SavedChip(
                          icon: Icons.home_outlined,
                          label: 'Home',
                          color: AppColors.primary,
                          onTap: () => setState(
                            () => _destCtrl.text = '123 Mabolo St, Cebu City',
                          ),
                        ),
                        const SizedBox(width: 10),
                        _SavedChip(
                          icon: Icons.work_outline,
                          label: 'Work',
                          color: AppColors.error,
                          onTap: () => setState(
                            () => _destCtrl.text = 'IT Park, Lahug, Cebu City',
                          ),
                        ),
                        const SizedBox(width: 10),
                        _SavedChip(
                          icon: Icons.star_outline,
                          label: 'Favorite',
                          color: AppColors.amber,
                          onTap: () => setState(
                            () => _destCtrl.text =
                                'South Road Properties, Cebu City',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Recent Destinations',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...['SM City Cebu', 'Ayala Center Cebu', 'IT Park'].map(
                      (place) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _destCtrl.text = place),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 13,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.history,
                                  color: AppColors.textTertiary,
                                  size: 16,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  place,
                                  style: const TextStyle(
                                    fontSize: 14,
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
        ],
      ),
    );
  }
}

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
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: iconColor, size: 18),
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.textTertiary,
              fontSize: 14,
            ),
            filled: true,
            fillColor: AppColors.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
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
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
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
  const _MapBtn({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
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
