import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../widgets/toast.dart';

class RideCompleteScreen extends StatefulWidget {
  const RideCompleteScreen({super.key});

  @override
  State<RideCompleteScreen> createState() => _RideCompleteScreenState();
}

class _RideCompleteScreenState extends State<RideCompleteScreen> {
  int _rating = 0;
  int _tip = 0;
  final _customTipController = TextEditingController();
  final _tipOptions = [0, 10, 20, 50];

  @override
  void dispose() {
    _customTipController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_rating == 0) {
      showToast(context, 'Please rate your driver', isError: true);
      return;
    }
    final total = 45 + _tip;
    showToast(context, 'Payment of ₱$total completed!');
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Success header
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.green, AppColors.greenDark],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
                child: Column(
                  children: [
                    Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            size: 48,
                            color: AppColors.green,
                          ),
                        )
                        .animate()
                        .scale(
                          begin: const Offset(0.8, 0.8),
                          end: const Offset(1, 1),
                          duration: 400.ms,
                        )
                        .fadeIn(duration: 400.ms),
                    const SizedBox(height: 20),
                    const Text(
                      'Trip Complete!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Thank you for riding with us',
                      style: TextStyle(fontSize: 15, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content card
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Trip summary
                    const Text(
                      'Trip Summary',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.muted,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _RouteRow(
                            dotColor: AppColors.primary,
                            label: 'From',
                            address: 'Cebu City, Philippines',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 11),
                            child: Container(
                              height: 20,
                              width: 2,
                              decoration: const BoxDecoration(
                                color: AppColors.border,
                              ),
                            ),
                          ),
                          _RouteRow(
                            dotColor: AppColors.red,
                            label: 'To',
                            address: 'SM City Cebu',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _InfoTile(
                            icon: Icons.access_time,
                            label: 'Duration',
                            value: '8 mins',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _InfoTile(
                            icon: Icons.calendar_today,
                            label: 'Distance',
                            value: '3.2 km',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Driver info
                    const Text(
                      'Your Driver',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.muted,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.primaryDark,
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text(
                                'PS',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pedro Santos',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Habal-habal • ABC 1234',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Rating
                    const Text(
                      'Rate Your Driver',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (i) {
                        final star = i + 1;
                        return GestureDetector(
                          onTap: () => setState(() => _rating = star),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(
                              Icons.star,
                              size: 44,
                              color: star <= _rating
                                  ? AppColors.yellow
                                  : AppColors.border,
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),

                    // Payment
                    const Text(
                      'Payment',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.muted,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _PayRow(label: 'Fare', value: '₱45.00'),
                          if (_tip > 0) ...[
                            const SizedBox(height: 8),
                            _PayRow(label: 'Tip', value: '₱$_tip.00'),
                          ],
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '₱${45 + _tip}.00',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tip options
                    const Text(
                      'Add Tip (Optional)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: _tipOptions.map((amount) {
                        final isSelected =
                            _tip == amount && _customTipController.text.isEmpty;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _tip = amount;
                                _customTipController.clear();
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              height: 48,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.border,
                                  width: 2,
                                ),
                                color: isSelected
                                    ? AppColors.primary.withValues(alpha: 0.1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  amount == 0 ? 'No tip' : '₱$amount',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _customTipController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Custom amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      onChanged: (v) {
                        setState(() => _tip = int.tryParse(v) ?? 0);
                      },
                    ),
                    const SizedBox(height: 24),

                    // Submit
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Pay ₱${45 + _tip}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => context.go('/home'),
                        child: const Text(
                          'Skip for now',
                          style: TextStyle(color: AppColors.mutedForeground),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
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
          width: 24,
          height: 24,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          child: const Center(
            child: CircleAvatar(radius: 4, backgroundColor: Colors.white),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.mutedForeground,
                ),
              ),
              Text(
                address,
                style: const TextStyle(
                  fontSize: 13,
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

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.mutedForeground),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.mutedForeground,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PayRow extends StatelessWidget {
  final String label;
  final String value;
  const _PayRow({required this.label, required this.value});

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
