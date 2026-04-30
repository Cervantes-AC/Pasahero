/// Schedule a ride screen
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/app_state.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/ph_widgets.dart';
import '../../widgets/toast.dart';

class ScheduleRideScreen extends StatefulWidget {
  const ScheduleRideScreen({super.key});

  @override
  State<ScheduleRideScreen> createState() => _ScheduleRideScreenState();
}

class _ScheduleRideScreenState extends State<ScheduleRideScreen> {
  final _pickupCtrl = TextEditingController();
  final _dropoffCtrl = TextEditingController();
  String _rideType = 'habal-habal';
  DateTime _selectedDate = DateTime.now().add(const Duration(hours: 1));
  TimeOfDay _selectedTime = TimeOfDay.fromDateTime(
    DateTime.now().add(const Duration(hours: 1)),
  );
  bool _saving = false;

  @override
  void dispose() {
    _pickupCtrl.dispose();
    _dropoffCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _scheduleRide() async {
    if (_pickupCtrl.text.isEmpty || _dropoffCtrl.text.isEmpty) {
      showToast(context, 'Please fill in pickup and drop-off', isError: true);
      return;
    }

    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 800));

    final scheduledAt = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    AppState.instance.addScheduledRide(
      ScheduledRide(
        id: 'sr_${DateTime.now().millisecondsSinceEpoch}',
        pickup: _pickupCtrl.text,
        dropoff: _dropoffCtrl.text,
        rideType: _rideType,
        scheduledAt: scheduledAt,
        status: 'upcoming',
      ),
    );

    setState(() => _saving = false);

    if (!mounted) return;
    showToast(context, 'Ride scheduled successfully!');
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/home');
      }
    }
  }

  String _formatDate(DateTime dt) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    final scheduled = AppState.instance.scheduledRides;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PhAppBar(
              title: 'Schedule a Ride',
              subtitle: 'Book up to 7 days in advance',
              showBack: true,
              onBack: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/home');
                }
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── New schedule form ──────────────────────────────────────
                PhCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New Scheduled Ride',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 15),
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      PhTextField(
                        label: 'Pickup Location',
                        hint: 'Enter pickup address',
                        controller: _pickupCtrl,
                        prefixIcon: Icons.my_location_outlined,
                      ),
                      const SizedBox(height: 12),
                      PhTextField(
                        label: 'Drop-off Location',
                        hint: 'Enter destination',
                        controller: _dropoffCtrl,
                        prefixIcon: Icons.location_on_outlined,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Ride Type',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 13),
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _RideTypeChip(
                            label: 'Habal-habal',
                            icon: Icons.two_wheeler,
                            value: 'habal-habal',
                            selected: _rideType,
                            onTap: (v) => setState(() => _rideType = v),
                          ),
                          const SizedBox(width: 8),
                          _RideTypeChip(
                            label: 'Bao-bao',
                            icon: Icons.directions_car_outlined,
                            value: 'bao-bao',
                            selected: _rideType,
                            onTap: (v) => setState(() => _rideType = v),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _DateTimeButton(
                              icon: Icons.calendar_today_outlined,
                              label: 'Date',
                              value: _formatDate(_selectedDate),
                              onTap: _pickDate,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _DateTimeButton(
                              icon: Icons.access_time_outlined,
                              label: 'Time',
                              value: _formatTime(_selectedTime),
                              onTap: _pickTime,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      PhButton(
                        label: 'Schedule Ride',
                        icon: Icons.schedule_outlined,
                        loading: _saving,
                        onTap: _saving ? null : _scheduleRide,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Upcoming scheduled rides ───────────────────────────────
                if (scheduled.isNotEmpty) ...[
                  const PhSectionHeader(title: 'Upcoming Rides'),
                  const SizedBox(height: 12),
                  ...scheduled.map(
                    (ride) => _ScheduledRideCard(
                      ride: ride,
                      onCancel: () {
                        setState(
                          () => AppState.instance.cancelScheduledRide(ride.id),
                        );
                        showToast(context, 'Scheduled ride cancelled');
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _RideTypeChip extends StatelessWidget {
  final String label, value, selected;
  final IconData icon;
  final ValueChanged<String> onTap;

  const _RideTypeChip({
    required this.label,
    required this.icon,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = selected == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? AppColors.primarySurface : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: active ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: Responsive.iconSize(context, base: 16),
                color: active ? AppColors.primary : AppColors.textTertiary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, 13),
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  color: active ? AppColors.primary : AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateTimeButton extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final VoidCallback onTap;

  const _DateTimeButton({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: Responsive.iconSize(context, base: 16),
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 10),
                      color: AppColors.textTertiary,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 13),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: Responsive.iconSize(context, base: 16),
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduledRideCard extends StatelessWidget {
  final ScheduledRide ride;
  final VoidCallback onCancel;

  const _ScheduledRideCard({required this.ride, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final dt = ride.scheduledAt;
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final dateStr =
        '${months[dt.month - 1]} ${dt.day}, ${dt.year} at $h:$m $period';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  ride.rideType == 'habal-habal' ? 'Habal-habal' : 'Bao-bao',
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 11),
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Upcoming',
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 11),
                    fontWeight: FontWeight.w600,
                    color: AppColors.amber,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          PhRouteDisplay(pickup: ride.pickup, dropoff: ride.dropoff),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.schedule_outlined,
                size: Responsive.iconSize(context, base: 14),
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: 6),
              Text(
                dateStr,
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, 12),
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: Responsive.buttonHeight(context) * 0.7,
            child: OutlinedButton.icon(
              onPressed: onCancel,
              icon: Icon(
                Icons.cancel_outlined,
                size: Responsive.iconSize(context, base: 14),
              ),
              label: Text(
                'Cancel Scheduled Ride',
                style: TextStyle(fontSize: Responsive.fontSize(context, 13)),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
