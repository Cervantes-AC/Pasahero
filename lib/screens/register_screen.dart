import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../widgets/ph_widgets.dart';
import '../widgets/toast.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _showPass = false;
  bool _agreed = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_nameCtrl.text.isNotEmpty &&
        _emailCtrl.text.isNotEmpty &&
        _phoneCtrl.text.isNotEmpty &&
        _passCtrl.text.isNotEmpty) {
      if (!_agreed) {
        showToast(
          context,
          'Please accept the terms to continue',
          isError: true,
        );
        return;
      }
      showToast(context, 'Account created successfully!');
      context.go('/home');
    } else {
      showToast(context, 'Please fill in all fields', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PhIconButton(
                      icon: Icons.arrow_back,
                      onTap: () => context.go('/'),
                      color: Colors.white.withValues(alpha: 0.15),
                      iconColor: Colors.white,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Create account',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Join thousands of riders in Cebu',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  PhTextField(
                    label: 'Full Name',
                    hint: 'Juan Dela Cruz',
                    controller: _nameCtrl,
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 14),
                  PhTextField(
                    label: 'Email address',
                    hint: 'you@example.com',
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.mail_outline,
                  ),
                  const SizedBox(height: 14),
                  PhTextField(
                    label: 'Phone Number',
                    hint: '09XX XXX XXXX',
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_outlined,
                  ),
                  const SizedBox(height: 14),
                  PhTextField(
                    label: 'Password',
                    hint: 'Create a strong password',
                    controller: _passCtrl,
                    obscure: !_showPass,
                    prefixIcon: Icons.lock_outline,
                    suffix: IconButton(
                      icon: Icon(
                        _showPass
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textTertiary,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _showPass = !_showPass),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => setState(() => _agreed = !_agreed),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: _agreed
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: _agreed
                                  ? AppColors.primary
                                  : AppColors.borderStrong,
                              width: 1.5,
                            ),
                          ),
                          child: _agreed
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 13,
                                )
                              : null,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'I agree to the Terms of Service and Privacy Policy',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  PhButton(label: 'Create Account', onTap: _handleRegister),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go('/login'),
                        child: const Text(
                          'Sign in',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
            ),
          ),
        ],
      ),
    );
  }
}
