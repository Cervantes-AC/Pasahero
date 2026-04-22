import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/ph_widgets.dart';
import '../widgets/toast.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const name = 'Juan Dela Cruz';
    const phone = '+63 912 345 6789';
    const since = 'January 2024';
    final initials = name.split(' ').map((n) => n[0]).join();

    final payments = [
      (type: 'GCash', number: '0912 345 6789', primary: true),
      (type: 'Maya', number: '0912 345 6789', primary: false),
      (type: 'Cash', number: 'Pay on Ride', primary: false),
    ];

    final contacts = [
      (name: 'Maria Dela Cruz', rel: 'Spouse', phone: '+63 917 123 4567'),
      (name: 'Pedro Santos', rel: 'Brother', phone: '+63 918 234 5678'),
    ];

    final hp = Responsive.hPad(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // Header
          Container(
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
                padding: EdgeInsets.fromLTRB(hp, 16, hp, 20),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(hp),
              child: ResponsiveContainer(
                child: Column(
                  children: [
                    // Profile card
                    PhCard(
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  PhAvatar(
                                    initials: initials,
                                    size: 80,
                                    bgColor: AppColors.primarySurface,
                                    textColor: AppColors.primary,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 26,
                                      height: 26,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        size: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                phone,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              PhBadge(
                                label: 'Member since $since',
                                color: AppColors.primary,
                              ),
                              const SizedBox(height: 14),
                              PhButton(
                                label: 'Edit Profile',
                                outlined: true,
                                height: 40,
                                onTap: () => showToast(
                                  context,
                                  'Edit profile coming soon',
                                ),
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 350.ms)
                        .slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 20),

                    // Payment methods
                    PhSectionHeader(
                      title: 'Payment Methods',
                      action: '+ Add',
                      onAction: () =>
                          showToast(context, 'Add payment method coming soon'),
                    ),
                    const SizedBox(height: 10),
                    ...payments.asMap().entries.map((e) {
                      final m = e.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child:
                            PhCard(
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.successLight,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.credit_card_outlined,
                                      color: AppColors.success,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          m.type,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          m.number,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textTertiary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (m.primary)
                                    PhBadge(
                                      label: 'Primary',
                                      color: AppColors.primary,
                                    ),
                                ],
                              ),
                            ).animate().fadeIn(
                              delay: (e.key * 60).ms,
                              duration: 350.ms,
                            ),
                      );
                    }),

                    const SizedBox(height: 20),

                    // Emergency contacts
                    PhSectionHeader(
                      title: 'Emergency Contacts',
                      action: '+ Add',
                      onAction: () =>
                          showToast(context, 'Add contact coming soon'),
                    ),
                    const SizedBox(height: 10),
                    ...contacts.asMap().entries.map((e) {
                      final c = e.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child:
                            PhCard(
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.errorLight,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.phone_outlined,
                                      color: AppColors.error,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          c.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          c.rel,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textTertiary,
                                          ),
                                        ),
                                        Text(
                                          c.phone,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ).animate().fadeIn(
                              delay: (e.key * 60).ms,
                              duration: 350.ms,
                            ),
                      );
                    }),

                    const SizedBox(height: 24),

                    PhButton(
                      label: 'Log Out',
                      outlined: true,
                      backgroundColor: AppColors.error,
                      foregroundColor: AppColors.error,
                      icon: Icons.logout,
                      onTap: () {
                        showToast(context, 'Logged out successfully');
                        Future.delayed(const Duration(milliseconds: 800), () {
                          if (context.mounted) context.go('/');
                        });
                      },
                    ).animate().fadeIn(delay: 300.ms, duration: 350.ms),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
