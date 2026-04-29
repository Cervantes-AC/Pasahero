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
    final theme = Theme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PhIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => context.go('/'),
              color: Colors.white.withValues(alpha: 0.1),
              iconColor: Colors.white,
              size: 48,
              bordered: true,
            ),
            const SizedBox(height: 40),
            _BrandRow(),
            const SizedBox(height: 40),
            Text(
              'Driver Portal',
              style: theme.textTheme.displayMedium?.copyWith(
                color: Colors.white,
              ),
            ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2, end: 0),
            const SizedBox(height: 8),
            Text(
              'Sign in to manage your rides and earnings.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
            const SizedBox(height: 48),
            _FormContent(
                  phoneCtrl: _phoneCtrl,
                  passCtrl: _passCtrl,
                  showPass: _showPass,
                  onTogglePass: () => setState(() => _showPass = !_showPass),
                  onLogin: _login,
                  onRegister: () => context.go('/driver-register'),
                )
                .animate()
                .fadeIn(delay: 200.ms, duration: 400.ms)
                .slideY(begin: 0.1, end: 0),
          ],
        ),
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
          width: 48,
          height: 48,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Image.asset('assets/logo.png', fit: BoxFit.contain),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PASAHERO',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            Text(
              'FOR DRIVERS',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.driverAccent,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FormContent extends StatelessWidget {
  final TextEditingController phoneCtrl;
  final TextEditingController passCtrl;
  final bool showPass;
  final VoidCallback onTogglePass;
  final VoidCallback onLogin;
  final VoidCallback onRegister;

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PhTextField(
          label: 'Phone Number',
          hint: '09XX XXX XXXX',
          controller: phoneCtrl,
          prefixIcon: Icons.phone_android_rounded,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 24),
        PhTextField(
          label: 'Password',
          hint: 'Enter your password',
          controller: passCtrl,
          obscure: !showPass,
          prefixIcon: Icons.lock_outline_rounded,
          suffix: IconButton(
            icon: Icon(
              showPass
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.white.withValues(alpha: 0.5),
            ),
            onPressed: onTogglePass,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                color: AppColors.driverAccent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        PhButton(
          label: 'Sign In',
          onTap: onLogin,
          backgroundColor: AppColors.driverAccent,
          foregroundColor: Colors.black,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Want to drive with us? ",
              style: TextStyle(color: Colors.white70),
            ),
            GestureDetector(
              onTap: onRegister,
              child: const Text(
                'Register Now',
                style: TextStyle(
                  color: AppColors.driverAccent,
                  fontWeight: FontWeight.w800,
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
