/// Passenger edit profile screen — fully functional with mock data
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../data/app_state.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/ph_widgets.dart';
import '../../widgets/toast.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _bioCtrl;

  @override
  void initState() {
    super.initState();
    final state = AppState.instance;
    _nameCtrl = TextEditingController(text: state.passengerName);
    _emailCtrl = TextEditingController(text: 'john.doe@example.com');
    _phoneCtrl = TextEditingController(text: state.passengerPhone);
    _addressCtrl = TextEditingController(text: '123 Main St, Manila, PH');
    _bioCtrl = TextEditingController(text: 'Frequent rider | Coffee lover');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_nameCtrl.text.isEmpty || _phoneCtrl.text.isEmpty) {
      showToast(context, 'Name and phone are required', isError: true);
      return;
    }

    // Mock update
    AppState.instance.updatePassengerName(_nameCtrl.text);
    showToast(context, 'Profile updated successfully');

    // Use mounted check to avoid BuildContext issues
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted && context.mounted) {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/home');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = AppState.instance.passengerName;
    final initials = name.split(' ').map((n) => n[0]).join();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          PhAppBar(
            title: 'Edit Profile',
            showBack: true,
            onBack: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.spacing(context, units: 3),
                vertical: Responsive.spacing(context, units: 1),
              ),
              child: Column(
                children: [
                  // ── Profile avatar section ────────────────────────────────
                  SizedBox(height: Responsive.spacing(context, units: 3)),
                  Stack(
                        children: [
                          Container(
                            width: Responsive.iconSize(context, base: 100),
                            height: Responsive.iconSize(context, base: 100),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.1,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                initials,
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontSize: Responsive.fontSize(context, 32),
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => showToast(
                                context,
                                'Photo upload coming soon',
                              ),
                              child: Container(
                                width: Responsive.iconSize(context, base: 32),
                                height: Responsive.iconSize(context, base: 32),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: Responsive.iconSize(context, base: 16),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                      .animate()
                      .fadeIn(duration: 300.ms)
                      .scale(begin: const Offset(0.8, 0.8)),
                  SizedBox(height: Responsive.spacing(context, units: 3)),

                  // ── Form fields ───────────────────────────────────────────
                  PhTextField(
                        label: 'Full Name',
                        hint: 'Enter your full name',
                        controller: _nameCtrl,
                        prefixIcon: Icons.person_outline,
                      )
                      .animate()
                      .fadeIn(delay: 100.ms, duration: 300.ms)
                      .slideX(begin: -0.2, end: 0),
                  SizedBox(height: Responsive.spacing(context, units: 2)),
                  PhTextField(
                        label: 'Email Address',
                        hint: 'your.email@example.com',
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                      )
                      .animate()
                      .fadeIn(delay: 150.ms, duration: 300.ms)
                      .slideX(begin: -0.2, end: 0),
                  SizedBox(height: Responsive.spacing(context, units: 2)),
                  PhTextField(
                        label: 'Phone Number',
                        hint: '+63 9XX XXX XXXX',
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone_outlined,
                      )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 300.ms)
                      .slideX(begin: -0.2, end: 0),
                  SizedBox(height: Responsive.spacing(context, units: 2)),
                  _MultilineTextField(
                        label: 'Address',
                        hint: 'Your residential address',
                        controller: _addressCtrl,
                        prefixIcon: Icons.location_on_outlined,
                        maxLines: 2,
                      )
                      .animate()
                      .fadeIn(delay: 250.ms, duration: 300.ms)
                      .slideX(begin: -0.2, end: 0),
                  SizedBox(height: Responsive.spacing(context, units: 2)),
                  _MultilineTextField(
                        label: 'Bio',
                        hint: 'Tell us about yourself',
                        controller: _bioCtrl,
                        maxLines: 3,
                      )
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 300.ms)
                      .slideX(begin: -0.2, end: 0),
                  SizedBox(height: Responsive.spacing(context, units: 3)),

                  // ── Info section ──────────────────────────────────────────
                  PhCard(
                    padding: EdgeInsets.all(
                      Responsive.spacing(context, units: 2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account Information',
                          style: TextStyle(
                            fontSize: Responsive.fontSize(context, 14),
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(
                          height: Responsive.spacing(context, units: 1.5),
                        ),
                        _InfoRow(label: 'Member Since', value: 'January 2024'),
                        SizedBox(height: Responsive.spacing(context, units: 1)),
                        _InfoRow(label: 'Total Rides', value: '47'),
                        SizedBox(height: Responsive.spacing(context, units: 1)),
                        _InfoRow(label: 'Rating', value: '4.8 ⭐'),
                      ],
                    ),
                  ).animate().fadeIn(delay: 350.ms, duration: 300.ms),
                  SizedBox(height: Responsive.spacing(context, units: 3)),

                  // ── Action buttons ────────────────────────────────────────
                  PhButton(
                        label: 'Save Changes',
                        height: Responsive.buttonHeight(context),
                        onTap: _saveProfile,
                      )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 300.ms)
                      .slideY(begin: 0.2, end: 0),
                  SizedBox(height: Responsive.spacing(context, units: 1.5)),
                  PhButton(
                        label: 'Cancel',
                        outlined: true,
                        height: Responsive.buttonHeight(context),
                        onTap: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/home');
                          }
                        },
                      )
                      .animate()
                      .fadeIn(delay: 450.ms, duration: 300.ms)
                      .slideY(begin: 0.2, end: 0),
                  SizedBox(height: Responsive.spacing(context, units: 2)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _MultilineTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final int maxLines;

  const _MultilineTextField({
    required this.label,
    required this.hint,
    required this.controller,
    this.prefixIcon,
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Responsive.fontSize(context, 13),
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: Responsive.spacing(context, units: 0.75)),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: Responsive.fontSize(context, 15),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.textTertiary,
              fontSize: Responsive.fontSize(context, 14),
            ),
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: AppColors.textTertiary,
                    size: Responsive.iconSize(context, base: 18),
                  )
                : null,
            filled: true,
            fillColor: AppColors.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                Responsive.radius(context, base: 12),
              ),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                Responsive.radius(context, base: 12),
              ),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                Responsive.radius(context, base: 12),
              ),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: Responsive.spacing(context, units: 1.75),
              vertical: Responsive.spacing(context, units: 1.75),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Responsive.fontSize(context, 13),
            color: AppColors.textSecondary,
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
    );
  }
}
