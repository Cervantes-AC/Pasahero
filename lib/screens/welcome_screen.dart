import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../data/app_state.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  UserRole _role = UserRole.passenger;

  bool get _isDriver => _role == UserRole.driver;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _isDriver
                ? [AppColors.driverBg, const Color(0xFF1E293B)]
                : [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 48),

              // Logo
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.asset('logo.jpg', fit: BoxFit.cover),
                ),
              ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),

              const SizedBox(height: 16),

              Text(
                    'Pasahero',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 150.ms, duration: 400.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: 4),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(
                  _isDriver
                      ? 'Your earnings, your schedule'
                      : 'Your trusted ride in Cebu',
                  key: ValueKey(_isDriver),
                  style: TextStyle(
                    fontSize: 14,
                    color: _isDriver
                        ? AppColors.driverAccent
                        : Colors.white.withValues(alpha: 0.75),
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

              const SizedBox(height: 36),

              // Role toggle
              Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          _RoleTab(
                            label: 'Passenger',
                            icon: Icons.person_outline,
                            selected: !_isDriver,
                            onTap: () =>
                                setState(() => _role = UserRole.passenger),
                            accentColor: AppColors.primary,
                          ),
                          _RoleTab(
                            label: 'Driver',
                            icon: Icons.two_wheeler,
                            selected: _isDriver,
                            onTap: () =>
                                setState(() => _role = UserRole.driver),
                            accentColor: AppColors.driverAccent,
                          ),
                        ],
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 400.ms)
                  .slideY(begin: 0.15, end: 0),

              const SizedBox(height: 32),

              // Feature list
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _isDriver
                      ? _DriverFeatures(key: const ValueKey('driver'))
                      : _PassengerServices(key: const ValueKey('passenger')),
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 400.ms),

              const Spacer(),

              // CTA buttons
              Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              AppState.instance.role = _role;
                              context.go(
                                _isDriver ? '/driver-register' : '/register',
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isDriver
                                  ? AppColors.driverAccent
                                  : Colors.white,
                              foregroundColor: _isDriver
                                  ? AppColors.driverBg
                                  : AppColors.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              _isDriver ? 'Register as Driver' : 'Get Started',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton(
                            onPressed: () {
                              AppState.instance.role = _role;
                              context.go(
                                _isDriver ? '/driver-login' : '/login',
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.35),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'I already have an account',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 400.ms)
                  .slideY(begin: 0.3, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final Color accentColor;

  const _RoleTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: selected ? accentColor : Colors.white60,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? accentColor : Colors.white60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PassengerServices extends StatelessWidget {
  const _PassengerServices({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      (icon: Icons.two_wheeler, label: 'Habal-habal', color: AppColors.amber),
      (icon: Icons.two_wheeler, label: 'Motorela', color: AppColors.error),
      (icon: Icons.directions_car, label: 'Bao-bao', color: AppColors.success),
    ];

    return Row(
      children: services.map((s) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: s.color.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(s.icon, color: s.color, size: 20),
                ),
                const SizedBox(height: 6),
                Text(
                  s.label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _DriverFeatures extends StatelessWidget {
  const _DriverFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      (icon: Icons.monetization_on_outlined, text: 'See fare before accepting'),
      (icon: Icons.toggle_on_outlined, text: 'Go online or offline anytime'),
      (icon: Icons.bar_chart_rounded, text: 'Track your daily earnings'),
    ];

    return Column(
      children: features.map((f) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.driverAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(f.icon, color: AppColors.driverAccent, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                f.text,
                style: const TextStyle(fontSize: 13, color: Colors.white70),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
