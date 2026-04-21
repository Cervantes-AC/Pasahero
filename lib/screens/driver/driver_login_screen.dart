import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/ph_widgets.dart';
import '../../widgets/toast.dart';

class DriverLoginScreen extends StatefulWidget {
  const DriverLoginScreen({super.key});
  @override
  State<DriverLoginScreen> createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends State<DriverLoginScreen> {
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _showPass = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _login() {
    if (_phoneCtrl.text.isNotEmpty && _passCtrl.text.isNotEmpty) {
      showToast(context, 'Welcome back, Driver!');
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) context.go('/driver-home');
      });
    } else {
      showToast(context, 'Please fill in all fields', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.driverBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PhIconButton(
                icon: Icons.arrow_back,
                onTap: () => context.go('/'),
                color: Colors.white.withValues(alpha: 0.1),
                iconColor: Colors.white,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.asset('logo.jpg', fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Driver Portal',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Pasahero',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.driverAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 36),
              const Text(
                'Sign in to\nyour account',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
              ).animate().fadeIn(delay: 80.ms, duration: 400.ms),
              const SizedBox(height: 28),
              PhTextField(
                label: 'Phone Number',
                hint: '09XX XXX XXXX',
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_outlined,
                dark: true,
              ),
              const SizedBox(height: 14),
              PhTextField(
                label: 'Password',
                hint: 'Enter your password',
                controller: _passCtrl,
                obscure: !_showPass,
                prefixIcon: Icons.lock_outline,
                dark: true,
                suffix: IconButton(
                  icon: Icon(
                    _showPass
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.driverTextMuted,
                    size: 18,
                  ),
                  onPressed: () => setState(() => _showPass = !_showPass),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.driverAccent,
                    foregroundColor: AppColors.driverBg,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: AppColors.driverTextMuted,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go('/driver-register'),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: AppColors.driverAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ).animate().fadeIn(duration: 350.ms),
        ),
      ),
    );
  }
}
