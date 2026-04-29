import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import 'bottom_navigation.dart';

class RootLayout extends StatelessWidget {
  final Widget child;
  const RootLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (Responsive.isWide(context)) {
      return _WideLayout(child: child);
    }
    return Scaffold(body: child, bottomNavigationBar: const BottomNavBar());
  }
}

/// Tablet / Laptop / Desktop / TV: side navigation rail or drawer
class _WideLayout extends StatelessWidget {
  final Widget child;
  const _WideLayout({required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final showLabels = Responsive.navShowsLabels(context);
    final navW = Responsive.navWidth(context);
    final logoSz = Responsive.logoSize(context);
    final isTv = Responsive.isTv(context);

    final tabs = [
      _NavItem(
        label: 'Home',
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        path: '/home',
      ),
      _NavItem(
        label: 'Rides',
        icon: Icons.receipt_long_outlined,
        activeIcon: Icons.receipt_long,
        path: '/ride-history',
      ),
      _NavItem(
        label: 'Saved',
        icon: Icons.bookmark_outline,
        activeIcon: Icons.bookmark,
        path: '/saved-locations',
      ),
      _NavItem(
        label: 'Profile',
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        path: '/profile',
      ),
    ];

    return Scaffold(
      body: Row(
        children: [
          // ── Side nav ──────────────────────────────────────────────────────
          Container(
            width: navW,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(right: BorderSide(color: AppColors.border)),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Logo
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: showLabels ? 20 : 12,
                      vertical: isTv ? 28 : 20,
                    ),
                    child: showLabels
                        ? Row(
                            children: [
                              _LogoBox(size: logoSz),
                              const SizedBox(width: 10),
                              Text(
                                'Pasahero',
                                style: TextStyle(
                                  fontSize: Responsive.fontSize(context, 16),
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          )
                        : Center(child: _LogoBox(size: logoSz)),
                  ),

                  SizedBox(height: Responsive.spacing(context)),

                  // Nav items
                  ...tabs.map((tab) {
                    final active = location == tab.path;
                    final iconSz = Responsive.iconSize(context, base: 20);
                    final itemPadV = isTv ? 16.0 : 10.0;

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: showLabels ? 12 : 8,
                        vertical: isTv ? 4 : 2,
                      ),
                      child: InkWell(
                        onTap: () => context.go(tab.path),
                        borderRadius: BorderRadius.circular(
                          Responsive.radius(context, base: 12),
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(
                            horizontal: showLabels ? 12 : 8,
                            vertical: itemPadV,
                          ),
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.primarySurface
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(
                              Responsive.radius(context, base: 12),
                            ),
                          ),
                          child: showLabels
                              ? Row(
                                  children: [
                                    Icon(
                                      active ? tab.activeIcon : tab.icon,
                                      size: iconSz,
                                      color: active
                                          ? AppColors.primary
                                          : AppColors.textTertiary,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      tab.label,
                                      style: TextStyle(
                                        fontSize: Responsive.fontSize(
                                          context,
                                          14,
                                        ),
                                        fontWeight: active
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: active
                                            ? AppColors.primary
                                            : AppColors.textTertiary,
                                      ),
                                    ),
                                  ],
                                )
                              : Center(
                                  child: Icon(
                                    active ? tab.activeIcon : tab.icon,
                                    size: iconSz,
                                    color: active
                                        ? AppColors.primary
                                        : AppColors.textTertiary,
                                  ),
                                ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // ── Content ───────────────────────────────────────────────────────
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _LogoBox extends StatelessWidget {
  final double size;
  const _LogoBox({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.25),
        child: Image.asset('assets/logo.png', fit: BoxFit.cover),
      ),
    );
  }
}

class _NavItem {
  final String label, path;
  final IconData icon, activeIcon;
  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.path,
  });
}
