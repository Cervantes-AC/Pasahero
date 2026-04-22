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

/// Tablet/Desktop: side navigation rail
class _WideLayout extends StatelessWidget {
  final Widget child;
  const _WideLayout({required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

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

    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      body: Row(
        children: [
          // Side nav
          Container(
            width: isDesktop ? 220 : 72,
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
                      horizontal: isDesktop ? 20 : 12,
                      vertical: 20,
                    ),
                    child: isDesktop
                        ? Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                                  child: Image.asset(
                                    'logo.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Pasahero',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: Image.asset(
                                  'logo.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                  ),

                  const SizedBox(height: 8),

                  // Nav items
                  ...tabs.map((tab) {
                    final active = location == tab.path;
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 12 : 8,
                        vertical: 2,
                      ),
                      child: InkWell(
                        onTap: () => context.go(tab.path),
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 12 : 8,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.primarySurface
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: isDesktop
                              ? Row(
                                  children: [
                                    Icon(
                                      active ? tab.activeIcon : tab.icon,
                                      size: 20,
                                      color: active
                                          ? AppColors.primary
                                          : AppColors.textTertiary,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      tab.label,
                                      style: TextStyle(
                                        fontSize: 14,
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
                                    size: 22,
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

          // Content
          Expanded(child: child),
        ],
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
