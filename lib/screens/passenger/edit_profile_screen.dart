/// Edit passenger profile screen
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/app_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/ph_widgets.dart';
import '../../widgets/toast.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final s = AppState.instance;
    _nameCtrl = TextEditingController(text: s.passengerName);
    _phoneCtrl = TextEditingController(text: s.passengerPhone);
    _emailCtrl = TextEditingController(text: s.passengerEmail);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      showToast(context, 'Name cannot be empty', isError: true);
      return;
    }
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 900));

    AppState.instance.passengerName = _nameCtrl.text.trim();
    AppState.instance.passengerPhone = _phoneCtrl.text.trim();
    AppState.instance.passengerEmail = _emailCtrl.text.trim();

    setState(() => _saving = false);
    if (!mounted) return;
    showToast(context, 'Profile updated successfully!');
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final initials = AppState.instance.passengerName
        .split(' ')
        .map((n) => n[0])
        .join();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: PhAppBar(
              title: 'Edit Profile',
              subtitle: 'Update your personal information',
              showBack: true,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Avatar ─────────────────────────────────────────────────
                Center(
                  child: Stack(
                    children: [
                      PhAvatar(
                        initials: initials,
                        size: 88,
                        bgColor: AppColors.primarySurface,
                        textColor: AppColors.primary,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () =>
                              showToast(context, 'Photo upload coming soon'),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Tap camera to change photo',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Form ───────────────────────────────────────────────────
                PhCard(
                  child: Column(
                    children: [
                      PhTextField(
                        label: 'Full Name',
                        hint: 'Enter your full name',
                        controller: _nameCtrl,
                        prefixIcon: Icons.person_outline,
                      ),
                      const SizedBox(height: 14),
                      PhTextField(
                        label: 'Phone Number',
                        hint: '+63 9XX XXX XXXX',
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone_outlined,
                      ),
                      const SizedBox(height: 14),
                      PhTextField(
                        label: 'Email Address',
                        hint: 'your@email.com',
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Change password ────────────────────────────────────────
                PhCard(
                  onTap: () => _showChangePasswordSheet(context),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Change Password',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Update your account password',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.textTertiary,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                PhButton(
                  label: 'Save Changes',
                  loading: _saving,
                  onTap: _saving ? null : _save,
                ),
                const SizedBox(height: 12),
                PhButton(
                  label: 'Cancel',
                  outlined: true,
                  onTap: () => context.pop(),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordSheet(BuildContext context) {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Change Password',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              PhTextField(
                label: 'Current Password',
                hint: '••••••••',
                controller: currentCtrl,
                obscure: true,
              ),
              const SizedBox(height: 12),
              PhTextField(
                label: 'New Password',
                hint: '••••••••',
                controller: newCtrl,
                obscure: true,
              ),
              const SizedBox(height: 12),
              PhTextField(
                label: 'Confirm New Password',
                hint: '••••••••',
                controller: confirmCtrl,
                obscure: true,
              ),
              const SizedBox(height: 20),
              PhButton(
                label: 'Update Password',
                onTap: () async {
                  if (newCtrl.text != confirmCtrl.text) {
                    showToast(ctx, 'Passwords do not match', isError: true);
                    return;
                  }
                  Navigator.pop(ctx);
                  showToast(context, 'Password updated successfully!');
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
