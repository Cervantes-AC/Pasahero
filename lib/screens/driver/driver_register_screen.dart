import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/toast.dart';
import '../../widgets/ph_widgets.dart';

class DriverRegisterScreen extends StatefulWidget {
  const DriverRegisterScreen({super.key});

  @override
  State<DriverRegisterScreen> createState() => _DriverRegisterScreenState();
}

class _DriverRegisterScreenState extends State<DriverRegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _licenseController = TextEditingController();
  final _plateController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  String _vehicleType = 'habal-habal';
  int _currentStep = 0;

  final _vehicleTypes = [
    (
      value: 'habal-habal',
      label: 'Habal-habal',
      icon: Icons.two_wheeler,
      desc: 'Motorcycle',
    ),
    (
      value: 'bao-bao',
      label: 'Bao-bao',
      icon: Icons.directions_car,
      desc: 'Tricycle',
    ),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _licenseController.dispose();
    _plateController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    showToast(context, 'Registration submitted! Pending verification.');
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) context.go('/driver-home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.driverBg,
      body: SafeArea(
        child: Column(
          children: [
            PhAppBar(
              title: 'Driver Registration',
              showBack: true,
              onBack: () => context.go('/'),
            ),

            // Step indicator
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: Row(
                children: List.generate(2, (i) {
                  final active = i == _currentStep;
                  final done = i < _currentStep;
                  return Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 6,
                            decoration: BoxDecoration(
                              color: done || active
                                  ? AppColors.driverAccent
                                  : Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                        if (i < 1) const SizedBox(width: 8),
                      ],
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Step ${_currentStep + 1} of 2',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.driverAccent,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    _currentStep == 0 ? 'Personal Details' : 'Vehicle Details',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _currentStep == 0
                    ? _buildStep1().animate().fadeIn(duration: 400.ms)
                    : _buildStep2().animate().fadeIn(duration: 400.ms),
              ),
            ),

            // Bottom buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                children: [
                  if (_currentStep > 0) ...[
                    Expanded(
                      child: PhButton(
                        label: 'Back',
                        onTap: () => setState(() => _currentStep--),
                        outlined: true,
                        backgroundColor: Colors.white.withValues(alpha: 0.3),
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  Expanded(
                    flex: 2,
                    child: PhButton(
                      label: _currentStep == 0
                          ? 'Continue'
                          : 'Submit Application',
                      onTap: _currentStep == 0
                          ? () => setState(() => _currentStep = 1)
                          : _handleRegister,
                      backgroundColor: AppColors.driverAccent,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tell us about\nyourself',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 32),
        PhTextField(
          label: 'Full Name',
          hint: 'Juan Dela Cruz',
          controller: _nameController,
          prefixIcon: Icons.person_outline_rounded,
        ),
        const SizedBox(height: 20),
        PhTextField(
          label: 'Phone Number',
          hint: '09XX XXX XXXX',
          controller: _phoneController,
          prefixIcon: Icons.phone_android_rounded,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 20),
        PhTextField(
          label: "Driver's License No.",
          hint: 'N01-23-456789',
          controller: _licenseController,
          prefixIcon: Icons.badge_outlined,
        ),
        const SizedBox(height: 20),
        PhTextField(
          label: 'Password',
          hint: 'Create a password',
          controller: _passwordController,
          obscure: !_showPassword,
          prefixIcon: Icons.lock_outline_rounded,
          suffix: IconButton(
            icon: Icon(
              _showPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.white.withValues(alpha: 0.5),
            ),
            onPressed: () => setState(() => _showPassword = !_showPassword),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vehicle\nInformation',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 28),
        const Text(
          'Vehicle Type',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        ...(_vehicleTypes.map((v) {
          final selected = _vehicleType == v.value;
          return GestureDetector(
            onTap: () => setState(() => _vehicleType = v.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.driverAccent.withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected
                      ? AppColors.driverAccent
                      : Colors.white.withValues(alpha: 0.12),
                  width: selected ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.driverAccent.withValues(alpha: 0.2)
                          : Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      v.icon,
                      color: selected ? AppColors.driverAccent : Colors.white54,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          v.label,
                          style: TextStyle(
                            color: selected
                                ? AppColors.driverAccent
                                : Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          v.desc,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (selected)
                    Icon(
                      Icons.check_circle,
                      color: AppColors.driverAccent,
                      size: 20,
                    ),
                ],
              ),
            ),
          );
        })),
        const SizedBox(height: 8),
        _buildField(
          'Plate Number',
          'ABC 1234',
          _plateController,
          Icons.confirmation_number_outlined,
        ),
        const SizedBox(height: 16),

        // Vehicle Photos Section
        const Text(
          'Vehicle Photos',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _PhotoUploadBox(
                      label: 'Front View',
                      icon: Icons.camera_alt_outlined,
                      onTap: () => showToast(
                        context,
                        'Photo upload feature coming soon',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PhotoUploadBox(
                      label: 'Side View',
                      icon: Icons.camera_alt_outlined,
                      onTap: () => showToast(
                        context,
                        'Photo upload feature coming soon',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _PhotoUploadBox(
                      label: 'License Plate',
                      icon: Icons.camera_alt_outlined,
                      onTap: () => showToast(
                        context,
                        'Photo upload feature coming soon',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PhotoUploadBox(
                      label: 'Interior',
                      icon: Icons.camera_alt_outlined,
                      onTap: () => showToast(
                        context,
                        'Photo upload feature coming soon',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.driverAccent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.driverAccent.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.driverAccent, size: 18),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Your documents and vehicle photos will be verified within 24 hours before you can start accepting rides.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildField(
    String label,
    String hint,
    TextEditingController controller,
    IconData icon, {
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: _inputDecoration(hint: hint, prefixIcon: icon),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    IconData? prefixIcon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.35)),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: Colors.white38, size: 20)
          : null,
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.08),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.driverAccent, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}

class _PhotoUploadBox extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _PhotoUploadBox({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white54, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
