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
  UserRole _selectedRole = UserRole.passenger;

  @override
  Widget build(BuildContext context) {
    final isDriver = _selectedRole == UserRole.driver;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          gradient: isDriver
              ? AppColors.driverGradient
              : AppColors.passengerGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top spacer
              const SizedBox(height: 32),

              // Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.asset('logo.jpg', fit: BoxFit.cover),
                ),
              ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),

              const SizedBox(height: 20),

              // App name
              const Text(
                    'Pasahero',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 500.ms)
                  .slideY(begin: 0.3, end: 0),

              Text(
                isDriver
                    ? 'Your earnings, your schedule'
                    : 'Your trusted ride in Cebu',
                style: TextStyle(
                  fontSize: 14,
                  color: isDriver ? AppColors.driverAccent : Colors.blue[100],
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 500.ms),

              const SizedBox(height: 40),

              // Role toggle
              Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          _RoleTab(
                            label: 'Passenger',
                            icon: Icons.person,
                            selected: !isDriver,
                            onTap: () => setState(
                              () => _selectedRole = UserRole.passenger,
                            ),
                            selectedColor: AppColors.primary,
                          ),
                          _RoleTab(
                            label: 'Driver',
                            icon: Icons.two_wheeler,
                            selected: isDriver,
                            onTap: () =>
                                setState(() => _selectedRole = UserRole.driver),
                            selectedColor: AppColors.driverAccent,
                          ),
                        ],
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 500.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: 32),

              // Service chips
              if (!isDriver)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ServiceChip(
                        icon: Icons.two_wheeler,
                        label: 'Habal-habal',
                        color: AppColors.yellow,
                      ),
                      const SizedBox(width: 12),
                      _ServiceChip(
                        icon: Icons.two_wheeler,
                        label: 'Motorela',
                        color: AppColors.red,
                      ),
                      const SizedBox(width: 12),
                      _ServiceChip(
                        icon: Icons.directions_car,
                        label: 'Bao-bao',
                        color: AppColors.green,
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 500.ms, duration: 500.ms)
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      _DriverFeatureRow(
                        icon: Icons.monetization_on_outlined,
                        text: 'See fare before accepting rides',
                      ),
                      const SizedBox(height: 10),
                      _DriverFeatureRow(
                        icon: Icons.toggle_on_outlined,
                        text: 'Go online/offline anytime',
                      ),
                      const SizedBox(height: 10),
                      _DriverFeatureRow(
                        icon: Icons.bar_chart,
                        text: 'Track your daily earnings',
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 500.ms, duration: 500.ms),

              const Spacer(),

              // Buttons
              Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              AppState.instance.role = _selectedRole;
                              context.go(
                                isDriver ? '/driver-register' : '/register',
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDriver
                                  ? AppColors.driverAccent
                                  : AppColors.red,
                              foregroundColor: isDriver
                                  ? AppColors.driverPrimary
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 6,
                              shadowColor: isDriver
                                  ? AppColors.driverAccent.withValues(
                                      alpha: 0.4,
                                    )
                                  : AppColors.red.withValues(alpha: 0.4),
                            ),
                            child: Text(
                              isDriver ? 'Register as Driver' : 'Get Started',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton(
                            onPressed: () {
                              AppState.instance.role = _selectedRole;
                              context.go(isDriver ? '/driver-login' : '/login');
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.4),
                              ),
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.08,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
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
                  .fadeIn(delay: 600.ms, duration: 500.ms)
                  .slideY(begin: 0.4, end: 0),
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
  final Color selectedColor;

  const _RoleTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? selectedColor : Colors.white70,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: selected ? selectedColor : Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ServiceChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              label,
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
  }
}

class _DriverFeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DriverFeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.driverAccent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.driverAccent, size: 18),
        ),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(fontSize: 14, color: Colors.white70)),
      ],
    );
  }
}
