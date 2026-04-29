import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../data/app_state.dart';
import '../../utils/responsive.dart';

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
        child: Responsive.isWide(context)
            ? _WideLayout(
                isDriver: _isDriver,
                role: _role,
                onRoleChanged: (r) => setState(() => _role = r),
              )
            : _MobileLayout(
                isDriver: _isDriver,
                role: _role,
                onRoleChanged: (r) => setState(() => _role = r),
              ),
      ),
    );
  }
}

// ── Mobile layout ─────────────────────────────────────────────────────────────

class _MobileLayout extends StatelessWidget {
  final bool isDriver;
  final UserRole role;
  final ValueChanged<UserRole> onRoleChanged;

  const _MobileLayout({
    required this.isDriver,
    required this.role,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final fs = Responsive.fontScale(context);
    final sp = Responsive.spacing(context);
    final logoSz = Responsive.logoSize(context);

    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: sp * 6),

          // Logo
          _LogoSection(
            size: logoSz,
            isDriver: isDriver,
            fontScale: fs,
          ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),

          SizedBox(height: sp * 4.5),

          // Role toggle
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sp * 4),
            child: _RoleToggle(
              isDriver: isDriver,
              onRoleChanged: onRoleChanged,
            ),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.15, end: 0),

          SizedBox(height: sp * 4),

          // Feature list
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sp * 4),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isDriver
                  ? _DriverFeatures(key: const ValueKey('driver'), fs: fs)
                  : _PassengerServices(
                      key: const ValueKey('passenger'),
                      fs: fs,
                    ),
            ),
          ).animate().fadeIn(delay: 400.ms),

          const Spacer(),

          _CtaSection(isDriver: isDriver, role: role, sp: sp, fs: fs),
        ],
      ),
    );
  }
}

// ── Wide layout (tablet / laptop / desktop / TV) ──────────────────────────────

class _WideLayout extends StatelessWidget {
  final bool isDriver;
  final UserRole role;
  final ValueChanged<UserRole> onRoleChanged;

  const _WideLayout({
    required this.isDriver,
    required this.role,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final fs = Responsive.fontScale(context);
    final sp = Responsive.spacing(context);
    final logoSz = Responsive.logoSize(context);
    final isTv = Responsive.isTv(context);

    return Row(
      children: [
        // ── Left branding panel ──────────────────────────────────────────────
        Expanded(
          flex: isTv ? 5 : 4,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(sp * 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo + name
                  Row(
                    children: [
                      Container(
                        width: logoSz,
                        height: logoSz,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(logoSz * 0.25),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(logoSz * 0.25),
                          child: Image.asset(
                            'assets/logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: sp * 1.5),
                      Text(
                        'Pasahero',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Responsive.fontSize(context, 18),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Headline
                  Text(
                    isDriver
                        ? 'Drive.\nEarn.\nRepeat.'
                        : 'Your trusted\nride in Cebu.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Responsive.fontSize(context, 48),
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                      letterSpacing: -1,
                    ),
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),

                  SizedBox(height: sp * 2),

                  Text(
                    isDriver
                        ? 'Your earnings, your schedule'
                        : 'Book habal-habal, motorela & bao-bao',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: Responsive.fontSize(context, 16),
                    ),
                  ).animate().fadeIn(delay: 150.ms),

                  const Spacer(),

                  // Feature bullets
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isDriver
                        ? _DriverFeatures(key: const ValueKey('driver'), fs: fs)
                        : _PassengerServices(
                            key: const ValueKey('passenger'),
                            fs: fs,
                          ),
                  ).animate().fadeIn(delay: 200.ms),

                  SizedBox(height: sp * 6),
                ],
              ),
            ),
          ),
        ),

        // ── Right CTA panel ──────────────────────────────────────────────────
        Expanded(
          flex: isTv ? 4 : 3,
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(sp * 6),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isTv ? 600 : 440),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isDriver ? 'Join as Driver' : 'Get Started',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Responsive.fontSize(context, 28),
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ).animate().fadeIn(delay: 200.ms),

                      SizedBox(height: sp * 1.5),

                      Text(
                        isDriver
                            ? 'Choose your schedule and earn on your terms'
                            : 'Select your role to continue',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.65),
                          fontSize: Responsive.fontSize(context, 14),
                        ),
                      ).animate().fadeIn(delay: 250.ms),

                      SizedBox(height: sp * 4),

                      // Role toggle
                      _RoleToggle(
                        isDriver: isDriver,
                        onRoleChanged: onRoleChanged,
                      ).animate().fadeIn(delay: 300.ms),

                      SizedBox(height: sp * 4),

                      _CtaSection(
                        isDriver: isDriver,
                        role: role,
                        sp: sp,
                        fs: fs,
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

// ── Shared sub-widgets ────────────────────────────────────────────────────────

class _LogoSection extends StatelessWidget {
  final double size;
  final bool isDriver;
  final double fontScale;

  const _LogoSection({
    required this.size,
    required this.isDriver,
    required this.fontScale,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size * 0.25),
            child: Image.asset('assets/logo.png', fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Pasahero',
          style: TextStyle(
            fontSize: 32 * fontScale,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.2, end: 0),
        const SizedBox(height: 4),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Text(
            isDriver
                ? 'Your earnings, your schedule'
                : 'Your trusted ride in Cebu',
            key: ValueKey(isDriver),
            style: TextStyle(
              fontSize: 14 * fontScale,
              color: isDriver
                  ? AppColors.driverAccent
                  : Colors.white.withValues(alpha: 0.75),
            ),
          ),
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }
}

class _RoleToggle extends StatelessWidget {
  final bool isDriver;
  final ValueChanged<UserRole> onRoleChanged;

  const _RoleToggle({required this.isDriver, required this.onRoleChanged});

  @override
  Widget build(BuildContext context) {
    final fs = Responsive.fontScale(context);

    return Container(
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
            selected: !isDriver,
            onTap: () => onRoleChanged(UserRole.passenger),
            accentColor: AppColors.primary,
            fontScale: fs,
          ),
          _RoleTab(
            label: 'Driver',
            icon: Icons.two_wheeler,
            selected: isDriver,
            onTap: () => onRoleChanged(UserRole.driver),
            accentColor: AppColors.driverAccent,
            fontScale: fs,
          ),
        ],
      ),
    );
  }
}

class _CtaSection extends StatelessWidget {
  final bool isDriver;
  final UserRole role;
  final double sp;
  final double fs;

  const _CtaSection({
    required this.isDriver,
    required this.role,
    required this.sp,
    required this.fs,
  });

  @override
  Widget build(BuildContext context) {
    final btnH = Responsive.buttonHeight(context);

    return Column(
      children: [
        // Showcase button
        GestureDetector(
          onTap: () => context.go('/showcase'),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: sp * 1.4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_circle_outline_rounded,
                    color: Colors.white70,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Watch Live Demo',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13 * fs,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Passenger ↔ Driver',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 9 * fs,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 480.ms),

        SizedBox(height: sp * 1.5),

        // Get started / Register
        SizedBox(
          width: double.infinity,
          height: btnH,
          child: ElevatedButton(
            onPressed: () {
              AppState.instance.role = role;
              context.go(isDriver ? '/driver-register' : '/register');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDriver ? AppColors.driverAccent : Colors.white,
              foregroundColor: isDriver
                  ? AppColors.driverBg
                  : AppColors.primary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              isDriver ? 'Register as Driver' : 'Get Started',
              style: TextStyle(fontSize: 15 * fs, fontWeight: FontWeight.w700),
            ),
          ),
        ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3, end: 0),

        SizedBox(height: sp * 1.25),

        // Sign in
        SizedBox(
          width: double.infinity,
          height: btnH,
          child: OutlinedButton(
            onPressed: () {
              AppState.instance.role = role;
              context.go(isDriver ? '/driver-login' : '/login');
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withValues(alpha: 0.35)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              'I already have an account',
              style: TextStyle(fontSize: 15 * fs),
            ),
          ),
        ).animate().fadeIn(delay: 540.ms).slideY(begin: 0.3, end: 0),

        SizedBox(height: sp * 4),
      ],
    );
  }
}

class _RoleTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final Color accentColor;
  final double fontScale;

  const _RoleTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.accentColor,
    required this.fontScale,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 11 * fontScale),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16 * fontScale,
                color: selected ? accentColor : Colors.white60,
              ),
              SizedBox(width: 6 * fontScale),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13 * fontScale,
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
  final double fs;
  const _PassengerServices({super.key, required this.fs});

  @override
  Widget build(BuildContext context) {
    final services = [
      (icon: Icons.two_wheeler, label: 'Habal-habal', color: AppColors.amber),
      (icon: Icons.two_wheeler, label: 'Motorela', color: AppColors.error),
      (icon: Icons.directions_car, label: 'Bao-bao', color: AppColors.success),
    ];

    return Row(
      children: services.map((s) {
        final iconBoxSz = 40.0 * fs;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: EdgeInsets.symmetric(vertical: 14 * fs),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Column(
              children: [
                Container(
                  width: iconBoxSz,
                  height: iconBoxSz,
                  decoration: BoxDecoration(
                    color: s.color.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(s.icon, color: s.color, size: 20 * fs),
                ),
                SizedBox(height: 6 * fs),
                Text(
                  s.label,
                  style: TextStyle(
                    fontSize: 10 * fs,
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
  final double fs;
  const _DriverFeatures({super.key, required this.fs});

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
          padding: EdgeInsets.only(bottom: 10 * fs),
          child: Row(
            children: [
              Container(
                width: 36 * fs,
                height: 36 * fs,
                decoration: BoxDecoration(
                  color: AppColors.driverAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  f.icon,
                  color: AppColors.driverAccent,
                  size: 18 * fs,
                ),
              ),
              SizedBox(width: 12 * fs),
              Text(
                f.text,
                style: TextStyle(fontSize: 13 * fs, color: Colors.white70),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
