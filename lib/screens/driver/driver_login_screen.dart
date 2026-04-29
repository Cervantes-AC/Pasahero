import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/ph_widgets.dart';
import '../../widgets/toast.dart';

class DriverLoginScreen extends StatefulWidget {
  const DriverLoginScreen({super.key});
  @override
  State<DriverLoginScreen> createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends State<DriverLoginScreen>
    with TickerProviderStateMixin {
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _showPass = false;
  late AnimationController _floatingController;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _floatingController.dispose();
    _glowController.dispose();
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
    final isWide = Responsive.isWide(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.driverBg,
              AppColors.driverSurface,
              AppColors.driverBg,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background elements
            ...List.generate(
              6,
              (i) => AnimatedBuilder(
                animation: _floatingController,
                builder: (_, __) => Positioned(
                  top: 100 + i * 120 + 30 * _floatingController.value,
                  left:
                      (i % 2 == 0
                          ? 50
                          : MediaQuery.of(context).size.width - 100) +
                      20 * _floatingController.value,
                  child: Container(
                    width: 60 + i * 10,
                    height: 60 + i * 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.driverAccent.withValues(
                        alpha: 0.03 + 0.02 * _floatingController.value,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            isWide ? _wideLayout(context) : _mobileLayout(context),
          ],
        ),
      ),
    );
  }

  Widget _mobileLayout(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(Responsive.hPad(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PhIconButton(
              icon: Icons.arrow_back,
              onTap: () => context.go('/'),
              color: Colors.white.withValues(alpha: 0.1),
              iconColor: Colors.white,
            ),
            const SizedBox(height: 28),
            _BrandRow(),
            const SizedBox(height: 32),
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
            _FormContent(
              phoneCtrl: _phoneCtrl,
              passCtrl: _passCtrl,
              showPass: _showPass,
              onTogglePass: () => setState(() => _showPass = !_showPass),
              onLogin: _login,
              onRegister: () => context.go('/driver-register'),
            ),
          ],
        ).animate().fadeIn(duration: 350.ms),
      ),
    );
  }

  Widget _wideLayout(BuildContext context) {
    return Row(
      children: [
        // Left dark panel
        Expanded(
          child: Container(
            color: AppColors.driverSurface,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => context.go('/'),
                      child: _BrandRow(),
                    ),
                    const Spacer(),
                    Text(
                      'Driver\nPortal',
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
                      'Manage your rides and earnings',
                      style: TextStyle(
                        color: AppColors.driverTextMuted,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    _DFeature(
                      icon: Icons.monetization_on_outlined,
                      text: 'See fare before accepting rides',
                    ),
                    const SizedBox(height: 12),
                    _DFeature(
                      icon: Icons.toggle_on_outlined,
                      text: 'Go online or offline anytime',
                    ),
                    const SizedBox(height: 12),
                    _DFeature(
                      icon: Icons.bar_chart_rounded,
                      text: 'Track your daily earnings',
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Right form
        Expanded(
          child: Container(
            color: AppColors.driverBg,
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(48),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sign in',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Enter your phone number and password',
                          style: TextStyle(
                            color: AppColors.driverTextMuted,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 32),
                        _FormContent(
                          phoneCtrl: _phoneCtrl,
                          passCtrl: _passCtrl,
                          showPass: _showPass,
                          onTogglePass: () =>
                              setState(() => _showPass = !_showPass),
                          onLogin: _login,
                          onRegister: () => context.go('/driver-register'),
                        ),
                      ],
                    ),
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

class _BrandRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
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
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Text(
              'Pasahero',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.driverAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FormContent extends StatelessWidget {
  final TextEditingController phoneCtrl, passCtrl;
  final bool showPass;
  final VoidCallback onTogglePass, onLogin, onRegister;

  const _FormContent({
    required this.phoneCtrl,
    required this.passCtrl,
    required this.showPass,
    required this.onTogglePass,
    required this.onLogin,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PhTextField(
          label: 'Phone Number',
          hint: '09XX XXX XXXX',
          controller: phoneCtrl,
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.phone_outlined,
          dark: true,
        ),
        const SizedBox(height: 14),
        PhTextField(
          label: 'Password',
          hint: 'Enter your password',
          controller: passCtrl,
          obscure: !showPass,
          prefixIcon: Icons.lock_outline,
          dark: true,
          suffix: IconButton(
            icon: Icon(
              showPass
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.driverTextMuted,
              size: 18,
            ),
            onPressed: onTogglePass,
          ),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: onLogin,
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
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't have an account? ",
              style: TextStyle(color: AppColors.driverTextMuted, fontSize: 14),
            ),
            GestureDetector(
              onTap: onRegister,
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
    );
  }
}

class _DFeature extends StatelessWidget {
  final IconData icon;
  final String text;
  const _DFeature({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.driverAccent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.driverAccent, size: 16),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.driverTextMuted,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
