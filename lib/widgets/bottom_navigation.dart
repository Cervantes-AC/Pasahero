import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    final tabs = [
      _NavTab(
        id: 'home',
        label: 'Home',
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        path: '/home',
      ),
      _NavTab(
        id: 'rides',
        label: 'Rides',
        icon: Icons.access_time_outlined,
        activeIcon: Icons.access_time,
        path: '/ride-history',
      ),
      _NavTab(
        id: 'saved',
        label: 'Saved',
        icon: Icons.place_outlined,
        activeIcon: Icons.place,
        path: '/saved-locations',
      ),
      _NavTab(
        id: 'profile',
        label: 'Profile',
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        path: '/profile',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            children: tabs.map((tab) {
              final active = location == tab.path;
              return Expanded(
                child: InkWell(
                  onTap: () => context.go(tab.path),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            active ? tab.activeIcon : tab.icon,
                            size: 24,
                            color: active
                                ? AppColors.primary
                                : AppColors.mutedForeground,
                          ),
                          if (active)
                            Positioned(
                              bottom: -6,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  width: 4,
                                  height: 4,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tab.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: active
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: active
                              ? AppColors.primary
                              : AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavTab {
  final String id;
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String path;
  const _NavTab({
    required this.id,
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.path,
  });
}
