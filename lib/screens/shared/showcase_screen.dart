import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DATA MODEL
// ─────────────────────────────────────────────────────────────────────────────

enum _Phase {
  idle,
  searching,
  requested,
  accepted,
  enRoute,
  arrived,
  inTrip,
  complete,
}

class _StepData {
  final _Phase phase;
  final String label;
  final String pTitle;
  final String pDesc;
  final String dTitle;
  final String dDesc;
  final IconData pIcon;
  final IconData dIcon;
  final Color pColor;
  final Color dColor;

  const _StepData({
    required this.phase,
    required this.label,
    required this.pTitle,
    required this.pDesc,
    required this.dTitle,
    required this.dDesc,
    required this.pIcon,
    required this.dIcon,
    required this.pColor,
    required this.dColor,
  });
}

const List<_StepData> _kSteps = [
  _StepData(
    phase: _Phase.idle,
    label: 'Home',
    pTitle: 'Passenger Home',
    pDesc:
        'Juan opens Pasahero. He sees Habal-habal, Motorela, and Bao-bao options. Wallet balance and saved locations are ready.',
    dTitle: 'Driver Offline',
    dDesc:
        'Pedro is offline. His dashboard shows today\'s earnings ₱847.50 and 12 trips. He taps the toggle to go online.',
    pIcon: Icons.home_rounded,
    dIcon: Icons.wifi_off_rounded,
    pColor: AppColors.primary,
    dColor: AppColors.driverTextMuted,
  ),
  _StepData(
    phase: _Phase.searching,
    label: 'Book',
    pTitle: 'Searching Drivers',
    pDesc:
        'Juan picks Habal-habal, sets pickup at SM City Cebu, types "Ayala Center Cebu" as destination, and taps Search Drivers.',
    dTitle: 'Driver Online',
    dDesc:
        'Pedro goes online. A green pulse shows he\'s now visible. Nearby passengers appear on his map.',
    pIcon: Icons.search_rounded,
    dIcon: Icons.wifi_rounded,
    pColor: AppColors.primary,
    dColor: AppColors.success,
  ),
  _StepData(
    phase: _Phase.requested,
    label: 'Request',
    pTitle: 'Request Sent',
    pDesc:
        'Juan sees Pedro\'s card — ₱65 fare, ★4.9, 3 mins away, ABC 1234. He taps "Order Ride" to send the request.',
    dTitle: 'Incoming Request!',
    dDesc:
        'Pedro gets a 30-second countdown alert showing ₱65 fare, pickup at SM City, drop-off at Ayala. Accept or decline.',
    pIcon: Icons.send_rounded,
    dIcon: Icons.notifications_active_rounded,
    pColor: AppColors.amber,
    dColor: AppColors.amber,
  ),
  _StepData(
    phase: _Phase.accepted,
    label: 'Accept',
    pTitle: 'Driver Accepted!',
    pDesc:
        'Pedro accepted. Juan sees a live map with Pedro\'s bike moving toward his location. ETA updates in real time.',
    dTitle: 'Ride Accepted',
    dDesc:
        'Pedro taps Accept. Navigation starts — heading to SM City Cebu. Passenger details and route are shown.',
    pIcon: Icons.check_circle_rounded,
    dIcon: Icons.navigation_rounded,
    pColor: AppColors.success,
    dColor: AppColors.primary,
  ),
  _StepData(
    phase: _Phase.enRoute,
    label: 'En Route',
    pTitle: 'Driver On the Way',
    pDesc:
        'ETA: 3 mins. Juan can call Pedro, send a message, or share his live location with family for safety.',
    dTitle: 'Heading to Pickup',
    dDesc:
        'Pedro follows the route. Distance to pickup: 0.8 km. Passenger name and contact visible on screen.',
    pIcon: Icons.location_on_rounded,
    dIcon: Icons.two_wheeler,
    pColor: AppColors.primary,
    dColor: AppColors.primary,
  ),
  _StepData(
    phase: _Phase.arrived,
    label: 'Arrived',
    pTitle: 'Driver Arrived!',
    pDesc:
        'Pedro is at SM City Cebu. Juan gets a notification and heads to the pickup point to board.',
    dTitle: 'At Pickup Point',
    dDesc:
        'Pedro taps "Passenger Picked Up" to confirm boarding and start navigation to Ayala Center.',
    pIcon: Icons.person_pin_rounded,
    dIcon: Icons.flag_rounded,
    pColor: AppColors.success,
    dColor: AppColors.success,
  ),
  _StepData(
    phase: _Phase.inTrip,
    label: 'Trip',
    pTitle: 'Trip in Progress',
    pDesc:
        'Juan is riding. ETA 8 mins, 3.2 km to Ayala. He shares his live location with his family for safety.',
    dTitle: 'Trip in Progress',
    dDesc:
        'Pedro navigates to Ayala Center. Fare ₱65 confirmed. Trip timer running. Passenger is on board.',
    pIcon: Icons.directions_rounded,
    dIcon: Icons.route_rounded,
    pColor: AppColors.primary,
    dColor: AppColors.driverAccent,
  ),
  _StepData(
    phase: _Phase.complete,
    label: 'Done',
    pTitle: 'Trip Complete!',
    pDesc:
        'Juan rates Pedro ★5, adds ₱10 tip, pays ₱75 via GCash. Receipt saved automatically to ride history.',
    dTitle: 'Earnings Updated',
    dDesc:
        'Pedro\'s dashboard: +₱65 added. Daily total ₱912.50. 13 trips. Rating stays at ★4.9. Ready for next ride.',
    pIcon: Icons.star_rounded,
    dIcon: Icons.monetization_on_rounded,
    pColor: AppColors.amber,
    dColor: AppColors.driverAccent,
  ),
];
