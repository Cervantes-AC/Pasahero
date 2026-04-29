import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/ph_widgets.dart';
import '../../widgets/toast.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _showPass = false;
  bool _agreed = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_nameCtrl.text.isEmpty ||
        _phoneCtrl.text.isEmpty ||
        _passCtrl.text.isEmpty) {
      showToast(context, 'Please fill in all fields', isError: true);
      return;
    }
    if (!_agreed) {
      showToast(context, 'Please accept the terms to continue', isError: true);
      return;
    }
    showToast(context, 'Account created successfully!');
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final isWide = Responsive.isWide(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: isWide ? _wideLayout(context) : _mobileLayout(context),
    );
  }

  Widget _mobileLayout(BuildContext context) {
    return Column(
      children: [
        _Header(),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Responsive.hPad(context)),
            child: _FormContent(
              nameCtrl: _nameCtrl,
              phoneCtrl: _phoneCtrl,
              passCtrl: _passCtrl,
              showPass: _showPass,
              agreed: _agreed,
              onTogglePass: () => setState(() => _showPass = !_showPass),
              onToggleAgreed: () => setState(() => _agreed = !_agreed),
              onRegister: _handleRegister,
              onLogin: () => context.go('/login'),
            ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.08, end: 0),
          ),
        ),
      ],
    );
  }

  Widget _wideLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => context.go('/'),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset('logo.jpg', fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Pasahero',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Join\nPasahero',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Thousands of riders trust us in Cebu',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    _Bullet(text: 'Book habal-habal, motorela, or bao-bao'),
                    const SizedBox(height: 10),
                    _Bullet(text: 'Track your driver in real-time'),
                    const SizedBox(height: 10),
                    _Bullet(text: 'Pay with GCash, Maya, or cash'),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(48),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Create account',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Fill in your details to get started',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _FormContent(
                        nameCtrl: _nameCtrl,
                        phoneCtrl: _phoneCtrl,
                        passCtrl: _passCtrl,
                        showPass: _showPass,
                        agreed: _agreed,
                        onTogglePass: () =>
                            setState(() => _showPass = !_showPass),
                        onToggleAgreed: () =>
                            setState(() => _agreed = !_agreed),
                        onRegister: _handleRegister,
                        onLogin: () => context.go('/login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          padding: EdgeInsets.fromLTRB(
            Responsive.hPad(context),
            16,
            Responsive.hPad(context),
            32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PhIconButton(
                icon: Icons.arrow_back,
                onTap: () => context.go('/'),
                color: Colors.white.withValues(alpha: 0.15),
                iconColor: Colors.white,
              ),
              const SizedBox(height: 20),
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
    );
  }
}

class _FormContent extends StatelessWidget {
  final TextEditingController nameCtrl, phoneCtrl, passCtrl;
  final bool showPass, agreed;
  final VoidCallback onTogglePass, onToggleAgreed, onRegister, onLogin;

  const _FormContent({
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.passCtrl,
    required this.showPass,
    required this.agreed,
    required this.onTogglePass,
    required this.onToggleAgreed,
    required this.onRegister,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PhTextField(
          label: 'Full Name',
          hint: 'Juan Dela Cruz',
          controller: nameCtrl,
          prefixIcon: Icons.person_outline,
        ),
        const SizedBox(height: 14),
        PhTextField(
          label: 'Phone Number',
          hint: '09XX XXX XXXX',
          controller: phoneCtrl,
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.phone_outlined,
        ),
        const SizedBox(height: 14),
        PhTextField(
          label: 'Password',
          hint: 'Create a strong password',
          controller: passCtrl,
          obscure: !showPass,
          prefixIcon: Icons.lock_outline,
          suffix: IconButton(
            icon: Icon(
              showPass
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textTertiary,
              size: 20,
            ),
            onPressed: onTogglePass,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: onToggleAgreed,
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: agreed ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: agreed ? AppColors.primary : AppColors.borderStrong,
                    width: 1.5,
                  ),
                ),
                child: agreed
                    ? const Icon(Icons.check, color: Colors.white, size: 13)
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
        PhButton(label: 'Create Account', onTap: onRegister),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Already have an account? ',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            GestureDetector(
              onTap: onLogin,
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
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
