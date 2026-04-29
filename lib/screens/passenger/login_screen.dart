import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/ph_widgets.dart';
import '../../widgets/toast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _showPass = false;
  bool _isLoading = false;
  late AnimationController _floatingController;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_phoneCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      showToast(context, 'Please fill in all fields', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    // Simulate login delay
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() => _isLoading = false);
      showToast(context, 'Welcome back!');
      context.go('/home');
    }
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
              phoneCtrl: _phoneCtrl,
              passCtrl: _passCtrl,
              showPass: _showPass,
              isLoading: _isLoading,
              onTogglePass: () => setState(() => _showPass = !_showPass),
              onLogin: _handleLogin,
              onRegister: () => context.go('/register'),
            ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.08, end: 0),
          ),
        ),
      ],
    );
  }

  Widget _wideLayout(BuildContext context) {
    return Row(
      children: [
        // Left branding panel
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
                              child: Image.asset(
                                'assets/logo.png',
                                fit: BoxFit.cover,
                              ),
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
                    Stack(
                      children: [
                        // Floating elements
                        AnimatedBuilder(
                          animation: _floatingController,
                          builder: (context, child) {
                            return Positioned(
                              top: 50 + (20 * _floatingController.value),
                              right: 100,
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.two_wheeler,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            );
                          },
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome\nback!',
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
                              'Sign in to continue your journey',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    _FeatureRow(
                      icon: Icons.two_wheeler,
                      text: 'Habal-habal & Bao-bao rides',
                    ).animate().fadeIn(delay: 200.ms, duration: 350.ms),
                    const SizedBox(height: 12),
                    _FeatureRow(
                      icon: Icons.location_on_outlined,
                      text: 'Real-time tracking & location sharing',
                    ).animate().fadeIn(delay: 300.ms, duration: 350.ms),
                    const SizedBox(height: 12),
                    _FeatureRow(
                      icon: Icons.star_outline_rounded,
                      text: 'Rate drivers and earn rewards',
                    ).animate().fadeIn(delay: 400.ms, duration: 350.ms),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Right form panel
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
                        'Sign in',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Enter your phone number and password',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _FormContent(
                        phoneCtrl: _phoneCtrl,
                        passCtrl: _passCtrl,
                        showPass: _showPass,
                        isLoading: _isLoading,
                        onTogglePass: () =>
                            setState(() => _showPass = !_showPass),
                        onLogin: _handleLogin,
                        onRegister: () => context.go('/register'),
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
                'Welcome back',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Sign in to continue your journey',
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
  final TextEditingController phoneCtrl;
  final TextEditingController passCtrl;
  final bool showPass;
  final bool isLoading;
  final VoidCallback onTogglePass;
  final VoidCallback onLogin;
  final VoidCallback onRegister;

  const _FormContent({
    required this.phoneCtrl,
    required this.passCtrl,
    required this.showPass,
    required this.isLoading,
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
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.phone_outlined,
        ),
        const SizedBox(height: 16),
        PhTextField(
          label: 'Password',
          hint: 'Enter your password',
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
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text(
              'Forgot password?',
              style: TextStyle(color: AppColors.primary, fontSize: 13),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Enhanced login button with loading state
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: isLoading ? null : onLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: isLoading ? 0 : 2,
            ),
            child: isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Signing in...',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                : const Text(
                    'Sign In',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
          ),
        ),

        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't have an account? ",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            GestureDetector(
              onTap: onRegister,
              child: const Text(
                'Sign up',
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

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 16),
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
