import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../widgets/toast.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _userInfo = (
    name: 'Juan Dela Cruz',
    email: 'juan.delacruz@email.com',
    phone: '+63 912 345 6789',
    memberSince: 'January 2024',
  );

  final _paymentMethods = const [
    (id: '1', type: 'GCash', number: '0912 345 6789', isPrimary: true),
    (id: '2', type: 'Maya', number: '0912 345 6789', isPrimary: false),
    (id: '3', type: 'Cash', number: 'Pay on Ride', isPrimary: false),
  ];

  final _emergencyContacts = const [
    (
      id: '1',
      name: 'Maria Dela Cruz',
      relationship: 'Spouse',
      phone: '+63 917 123 4567',
    ),
    (
      id: '2',
      name: 'Pedro Santos',
      relationship: 'Brother',
      phone: '+63 918 234 5678',
    ),
  ];

  void _handleLogout() {
    showToast(context, 'Logged out successfully');
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) context.go('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    final initials = _userInfo.name.split(' ').map((n) => n[0]).join();

    return Scaffold(
      backgroundColor: AppColors.background,
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Profile & Settings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Profile card
                  _Card(
                        child: Column(
                          children: [
                            // Avatar
                            Stack(
                              children: [
                                Container(
                                  width: 96,
                                  height: 96,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primary,
                                        AppColors.primaryDark,
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      initials,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: const BoxDecoration(
                                      color: AppColors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _userInfo.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _userInfo.email,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                            Text(
                              _userInfo.phone,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.verified_user,
                                    size: 12,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Member since ${_userInfo.memberSince}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () => showToast(
                                  context,
                                  'Edit profile coming soon',
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: const BorderSide(
                                    color: AppColors.primary,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Edit Profile'),
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 24),

                  // Payment methods
                  _SectionHeader(
                    title: 'Payment Methods',
                    actionLabel: '+ Add',
                    onAction: () =>
                        showToast(context, 'Add payment method coming soon'),
                  ),
                  const SizedBox(height: 12),
                  ..._paymentMethods.asMap().entries.map((entry) {
                    final i = entry.key;
                    final method = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child:
                          _Card(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: AppColors.green.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.credit_card,
                                        color: AppColors.green,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            method.type,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            method.number,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: AppColors.mutedForeground,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (method.isPrimary)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: const Text(
                                          'Primary',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              )
                              .animate()
                              .fadeIn(
                                delay: (200 + i * 100).ms,
                                duration: 400.ms,
                              )
                              .slideX(begin: -0.2, end: 0),
                    );
                  }),
                  const SizedBox(height: 16),

                  // Emergency contacts
                  _SectionHeader(
                    title: 'Emergency Contacts',
                    actionLabel: '+ Add',
                    onAction: () =>
                        showToast(context, 'Add contact coming soon'),
                  ),
                  const SizedBox(height: 12),
                  ..._emergencyContacts.asMap().entries.map((entry) {
                    final i = entry.key;
                    final contact = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child:
                          _Card(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: AppColors.red.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.phone,
                                        color: AppColors.red,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            contact.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            contact.relationship,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: AppColors.mutedForeground,
                                            ),
                                          ),
                                          Text(
                                            contact.phone,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: AppColors.mutedForeground,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .animate()
                              .fadeIn(
                                delay: (300 + i * 100).ms,
                                duration: 400.ms,
                              )
                              .slideX(begin: -0.2, end: 0),
                    );
                  }),
                  const SizedBox(height: 24),

                  // Logout
                  SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton.icon(
                          onPressed: _handleLogout,
                          icon: const Icon(Icons.logout),
                          label: const Text(
                            'Logout',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.red,
                            side: const BorderSide(
                              color: AppColors.red,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 400.ms)
                      .slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        GestureDetector(
          onTap: onAction,
          child: Text(
            actionLabel,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
